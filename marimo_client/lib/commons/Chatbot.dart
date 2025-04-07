import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gemma/core/model.dart';
import 'package:flutter_gemma/pigeon.g.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
// 내장 기능 호출을 위한 화면 임포트 (CarPaymentDetailForm.dart)
import 'package:marimo_client/screens/payment/CarPaymentDetailForm.dart';
// Provider 임포트 (CarPaymentProvider)
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  bool _isProcessing = false;

  // 원래 placeholder 텍스트
  final String _guideText = "버튼을 누르고, 예시처럼 말해보세요.\n";
  final String _placeholderText =
      "\"엔진 마모가 뭐야?\"\n\n\"마리모 요청: 차계부에 오늘 날짜로 GS칼텍스 방이점에 주유 2만원 기록해줘\"";
  String _recognizedText =
      "버튼을 누르고, 예시처럼 말해보세요.\n\"엔진 마모가 뭐야?\"\n\n\"마리모 요청: 차계부에 오늘 날짜로 GS칼텍스 방이점에 주유 2만원 기록해줘\"";

  // Gemma 모델 추론 인스턴스
  InferenceModel? _inferenceModel;

  // 애니메이션 인덱스 및 타이머
  int _listeningIconIndex = 1;
  int _processingIconIndex = 1;
  Timer? _listeningTimer;
  Timer? _processingTimer;

  // 최종 결과 중복 처리를 위한 플래그
  bool _finalResultProcessed = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _flutterTts.setLanguage("ko-KR");

    _flutterTts.setCompletionHandler(() {
      _stopProcessingAnimation();
      setState(() {
        _isProcessing = false;
      });
    });

    _initializeGemmaModel();
  }

  Future<void> _initializeGemmaModel() async {
    try {
      final modelManager = FlutterGemmaPlugin.instance.modelManager;
      await modelManager.installModelFromAsset('ai/gemma3-1B-it-int4.task');
      _inferenceModel = await FlutterGemmaPlugin.instance.createModel(
        modelType: ModelType.gemmaIt,
        preferredBackend: PreferredBackend.cpu,
        maxTokens: 1024, // 토큰 수를 1024로 증가
      );
      debugPrint('Gemma 모델 초기화 완료');
    } catch (e) {
      debugPrint('Gemma 모델 초기화 오류: $e');
    }
  }

  // 일반 자동차 전문가 응답을 위한 Gemma 추론 함수 (평문 응답 요청)
  Future<String> _performGemmaInference(String prompt) async {
    if (_inferenceModel == null) return "모델이 초기화되지 않았습니다.";
    try {
      String modifiedPrompt =
          "대답은 최대 1분 이내로 작성해주세요. " +
          "출력에는 markdown 태그나 기타 서식(예: ``` , **, ## 등)을 포함하지 마세요." +
          "당신은 30년 이상의 경력을 가진 자동차 전문가로, 모든 차량 문제, 부품, 유지보수 및 수리 관련 정보를 폭넓게 알고 있습니다. " +
          "전문적이고 신뢰할 수 있는 정보를 바탕으로 답변해주세요. " +
          "만약 질문이 자동차와 관련된 것이 아니라면, 상식적인 내용이면 답변해주시고, 그렇지 않으면 '다시 말씀해주시겠어요?'라고 응답해주세요. " +
          prompt;
      final session = await _inferenceModel!.createSession(
        temperature: 1.0,
        randomSeed: 1,
        topK: 1,
      );
      await session.addQueryChunk(Message(text: modifiedPrompt));
      final response = await session.getResponse();
      await session.close();
      debugPrint("Gemma 응답 (일반): $response");
      return response;
    } catch (e) {
      debugPrint("추론 오류: $e");
      return "오류 발생";
    }
  }

  // 차계부 결제내역 등록 정보를 추출하는 Gemma 프롬프트 함수
  Future<Map<String, dynamic>> _performCarPaymentEntryInference(
    String userCommand,
  ) async {
    if (_inferenceModel == null) return {};
    try {
      String carPaymentPrompt =
          "당신은 자동차 결제내역 등록 전문가입니다. 사용자 명령을 분석하여 아래 정보를 추출하세요.\n"
              "출력은 반드시 순수 JSON 형식으로만 작성해 주세요. 어떠한 markdown 태그나 추가 서식(예: ``` , **, ## 등)도 포함하지 않아야 합니다.\n"
              "1. 결제 유형: '주유', '정비', '세차' 중 하나.\n"
              "2. 결제 금액: 원 단위의 정수로 출력하세요. 만약 한글로 표현되었다면 '십만원', '백만원' 등의 표현을 정수로 변환해야 합니다.\n"
              "3. 날짜: 반드시 ISO8601 형식 (예: 2025-04-04T00:00:00.000)으로 출력하세요.\n"
              "4. 장소: 결제가 이루어진 장소를 출력하세요. '주유'인 경우, 반드시 SK, GS, 현대오일뱅크, S-OIL 중 하나로 시작해야 합니다.\n"
              "5. 타입: 만약 '주유'이면 반드시 '고급 휘발유', '일반 휘발유', '경유', 'LPG' 중 하나여야 하며, '정비'이면 부품, '세차'이면 null을 출력하세요.\n"
              "6. 메모: 선택 사항입니다. 입력이 없으면 null로 출력하세요.\n"
              "예시: { \"category\": \"주유\", \"amount\": 20000, \"date\": \"2025-04-04T00:00:00.000\", \"location\": \"GS칼텍스 강남점\", \"type\": \"일반 휘발유\", \"memo\": \"추가 메모\" }\n"
              "사용자 명령: " +
          userCommand;

      String response = await _performGemmaInference(carPaymentPrompt);
      response = response.trim();

      // markdown 태그 제거
      if (response.startsWith("```")) {
        response = response.replaceFirst(RegExp(r"^```[a-zA-Z]*"), "").trim();
        if (response.endsWith("```")) {
          response = response.substring(0, response.length - 3).trim();
        }
      }

      // JSON 문자열의 첫 "{"와 마지막 "}" 사이의 부분만 추출
      int firstIndex = response.indexOf("{");
      int lastIndex = response.lastIndexOf("}");
      if (firstIndex == -1 || lastIndex == -1 || lastIndex <= firstIndex) {
        debugPrint("응답이 유효한 JSON 형식이 아닙니다: $response");
        return {};
      }
      String jsonString = response.substring(firstIndex, lastIndex + 1);

      // 쉼표 오류 제거: 예를 들어 ",}" -> "}"
      jsonString = jsonString.replaceAll(RegExp(r',\s*}'), "}");

      // JSON이 완전한지 확인
      if (!jsonString.endsWith("}")) {
        debugPrint("최종 JSON 문자열이 완전하지 않습니다: $jsonString");
        return {};
      }

      debugPrint("Gemma 응답 (차계부 등록): $jsonString");
      return jsonDecode(jsonString);
    } catch (e) {
      debugPrint("차계부 등록 JSON 파싱 오류: $e");
      return {};
    }
  }

  // 한글 금액을 정수로 변환하는 함수 (예: "십만원" -> 100000, "백만원" -> 1000000)
  int convertHangulAmount(String amountStr) {
    amountStr = amountStr.trim();
    int? parsed = int.tryParse(amountStr);
    if (parsed != null) return parsed;
    if (amountStr.contains("만원")) {
      String numPart = amountStr.replaceAll("만원", "").trim();
      int factor = 10000;
      Map<String, int> hangulMap = {
        "일": 1,
        "이": 2,
        "삼": 3,
        "사": 4,
        "오": 5,
        "육": 6,
        "칠": 7,
        "팔": 8,
        "구": 9,
        "십": 10,
        "백": 100,
        "천": 1000,
      };
      if (hangulMap.containsKey(numPart)) {
        return hangulMap[numPart]! * factor;
      }
    }
    return 0;
  }

  // 중복 문장 제거 함수 (줄바꿈 기준)
  String removeDuplicateSentences(String response) {
    List<String> sentences = response.split(RegExp(r'\n+'));
    Set<String> seen = {};
    List<String> unique = [];
    for (String sentence in sentences) {
      String trimmed = sentence.trim();
      if (trimmed.isNotEmpty && !seen.contains(trimmed)) {
        seen.add(trimmed);
        unique.add(trimmed);
      }
    }
    return unique.join("\n");
  }

  // 최종 결과만 화면에 표시 (partial 결과는 무시)
  Future<void> _updateFinalText(String newText) async {
    setState(() {
      _recognizedText = newText;
    });
  }

  // 마크다운 특수문자를 제거하는 함수
  String removeMarkdownCharacters(String text) {
    return text
        .replaceAll(RegExp(r'`{1,3}'), '') // 코드 블록
        .replaceAll(RegExp(r'\*{1,3}'), '') // 볼드/이탤릭
        .replaceAll(RegExp(r'#{1,6}\s'), '') // 헤더
        .replaceAll(RegExp(r'>\s'), '') // 인용구
        .replaceAll(RegExp(r'- '), '') // 리스트
        .replaceAll(RegExp(r'\[([^\]]*)\]\([^\)]*\)'), r'\$1') // 링크
        .replaceAll(RegExp(r'!\[([^\]]*)\]\([^\)]*\)'), r'\$1'); // 이미지
  }

  // 마크다운 문법을 수정하는 함수
  String fixMarkdownSyntax(String text) {
    return text
        .replaceAll(RegExp(r'\*   \*\*'), '* **')  // 불필요한 공백 제거
        .replaceAll(RegExp(r'\*\* '), '**')  // 볼드 뒤의 공백 제거
        .replaceAll(':**', ':** ');  // 콜론 뒤에 공백 추가
  }

  // 불필요한 마크다운 태그를 제거하는 함수
  String removeUnnecessaryMarkdown(String text) {
    return text
        .replaceAll(RegExp(r'^```.*\n'), '')  // 시작 부분의 ``` 제거
        .replaceAll(RegExp(r'\n```.*\n'), '\n')  // 중간의 ``` 제거
        .replaceAll(RegExp(r'\n```.*$'), '')  // 끝 부분의 ``` 제거
        .replaceAll(RegExp(r'```.*$'), '')  // 문자열 끝의 ``` 제거 (줄바꿈 없는 경우)
        .trim();
  }

  Future<void> _startListening() async {
    if (_recognizedText == _guideText + _placeholderText) {
      setState(() {
        _recognizedText = "";
      });
    }
    _finalResultProcessed = false;
    bool available = await _speech.initialize(
      onStatus: (status) => debugPrint('STT Status: $status'),
      onError: (error) => debugPrint('STT Error: $error'),
    );
    if (available) {
      setState(() {
        _isListening = true;
      });
      _startListeningAnimation();
      _speech.listen(
        onResult: (result) async {
          if (!result.finalResult) return;
          if (_finalResultProcessed) return;
          _finalResultProcessed = true;
          String recognized = result.recognizedWords;
          debugPrint("최종 STT 결과: $recognized");
          await _stopListening();
          await _updateFinalText("");
          if (recognized.trim().startsWith("마리모 요청")) {
            if (recognized.contains("차계부") || recognized.contains("결제내역")) {
              _startProcessingAnimation();
              setState(() {
                _isProcessing = true;
                _recognizedText = "차계부 결제내역 등록 정보를 추출 중입니다...\n";
              });
              Map<String, dynamic> paymentData =
                  await _performCarPaymentEntryInference(recognized);
              _stopProcessingAnimation();
              String category = paymentData["category"] ?? "주유";
              int amount;
              if (paymentData["amount"] is int) {
                amount = paymentData["amount"];
              } else {
                String amountStr = paymentData["amount"]?.toString() ?? "";
                amount = convertHangulAmount(amountStr);
                if (amount == 0) {
                  amount = int.tryParse(amountStr) ?? 0;
                }
              }
              // 후처리: "만"이 포함되어 있고, 주유의 경우 값이 100,000 미만이면 10배 보정
              // if (recognized.contains("만") && amount <= 100000000) {
              //   amount *= 10;
              // }
              // Provider 업데이트
              final carPaymentProvider = Provider.of<CarPaymentProvider>(
                context,
                listen: false,
              );
              carPaymentProvider.setSelectedCategory(category);
              carPaymentProvider.setSelectedAmount(amount);
              if (paymentData["date"] != null &&
                  paymentData["date"].toString().isNotEmpty) {
                try {
                  carPaymentProvider.setSelectedDate(
                    DateTime.parse(paymentData["date"]),
                  );
                } catch (_) {}
              }
              // 주유의 경우, location은 SK, GS, 현대오일뱅크, S-OIL로 시작해야 함
              if (category == "주유") {
                if (paymentData["location"] != null &&
                    paymentData["location"].toString().isNotEmpty) {
                  String location = paymentData["location"];
                  if (location.startsWith("SK") ||
                      location.startsWith("GS") ||
                      location.startsWith("현대오일뱅크") ||
                      location.startsWith("S-OIL")) {
                    carPaymentProvider.setLocation(location);
                  } else {
                    carPaymentProvider.setLocation("");
                  }
                }
              } else {
                if (paymentData["location"] != null &&
                    paymentData["location"].toString().isNotEmpty) {
                  carPaymentProvider.setLocation(paymentData["location"]);
                }
              }
              if (paymentData["memo"] != null &&
                  paymentData["memo"].toString().isNotEmpty) {
                carPaymentProvider.setMemo(paymentData["memo"]);
              }
              if (category == "주유" &&
                  paymentData["type"] != null &&
                  paymentData["type"].toString().isNotEmpty) {
                String fuelType = paymentData["type"];
                if (fuelType != "고급 휘발유" &&
                    fuelType != "일반 휘발유" &&
                    fuelType != "경유" &&
                    fuelType != "LPG") {
                  fuelType = "일반 휘발유";
                }
                carPaymentProvider.setFuelType(fuelType);
              }
              debugPrint(
                "차계부 등록용 Provider 업데이트 완료: ${carPaymentProvider.toJsonForDB(carId: 'dummy', location: carPaymentProvider.location, memo: carPaymentProvider.memo, fuelType: carPaymentProvider.fuelType)}",
              );
              setState(() {
                _isProcessing = false;
              });
              // 입력 처리 후 Provider 초기화
              carPaymentProvider.resetInput();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => CarPaymentDetailForm(
                        selectedCategory: category,
                        amount: amount,
                      ),
                ),
              );
            } else {
              _startProcessingAnimation();
              setState(() {
                _isProcessing = true;
                _recognizedText = "내장된 차계부 기능을 호출합니다.\n";
              });
              String selectedCategory = "주유";
              int amount = 20000;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => CarPaymentDetailForm(
                        selectedCategory: selectedCategory,
                        amount: amount,
                      ),
                ),
              );
              _stopProcessingAnimation();
            }
          } else {
            _startProcessingAnimation();
            setState(() {
              _isProcessing = true;
              _recognizedText = "AI 마리모가 대답을 준비하고 있어요.\n";
            });
            String generatedResponse = await _performGemmaInference(recognized);
            // 불필요한 마크다운 태그 제거
            generatedResponse = removeUnnecessaryMarkdown(generatedResponse);
            // 마크다운 형식이 유지되도록 중복 제거 전에 줄바꿈 추가
            generatedResponse = generatedResponse.replaceAll(". ", ".\n");
            // 마크다운 문법 수정을 중복 제거 전에 수행
            generatedResponse = fixMarkdownSyntax(generatedResponse);
            generatedResponse = removeDuplicateSentences(generatedResponse);
            debugPrint("Gemma 일반 응답: $generatedResponse");
            _stopProcessingAnimation();
            setState(() {
              _isProcessing = false;
              _recognizedText = generatedResponse;
            });
            // TTS에는 마크다운이 제거된 텍스트를 전달
            await _flutterTts.speak(removeMarkdownCharacters(generatedResponse));
          }
        },
        listenFor: const Duration(seconds: 10),
        localeId: "ko_KR",
      );
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    _stopListeningAnimation();
    setState(() {
      _isListening = false;
    });
  }

  void _startListeningAnimation() {
    _listeningTimer?.cancel();
    _listeningTimer = Timer.periodic(const Duration(milliseconds: 300), (
      timer,
    ) {
      setState(() {
        _listeningIconIndex = (_listeningIconIndex % 4) + 1;
      });
    });
  }

  void _stopListeningAnimation() {
    _listeningTimer?.cancel();
    setState(() {
      _listeningIconIndex = 1;
    });
  }

  void _startProcessingAnimation() {
    _processingTimer?.cancel();
    setState(() {
      _isProcessing = true;
    });
    _processingTimer = Timer.periodic(const Duration(milliseconds: 300), (
      timer,
    ) {
      setState(() {
        _processingIconIndex = (_processingIconIndex % 3) + 1;
      });
    });
  }

  void _stopProcessingAnimation() {
    _processingTimer?.cancel();
    setState(() {
      _processingIconIndex = 1;
    });
  }

  @override
  void dispose() {
    _listeningTimer?.cancel();
    _processingTimer?.cancel();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final containerHeight = size.height * 0.428;
    final horizontalMargin = size.width * 0.05;
    final topPadding = containerHeight * 0.08;
    final textTop = containerHeight * 0.16;
    final textBottom = containerHeight * 0.25;
    final micBottom = containerHeight * 0.1;

    TextStyle guideTextStyle = TextStyle(
      color: Colors.black,
      fontSize: size.width * 0.04,
      fontFamily: 'FreesentationVF',
      fontWeight: FontWeight.w600,
    );

    TextStyle placeholderTextStyle = TextStyle(
      color: Colors.grey[600],
      fontSize: size.width * 0.04,
      fontFamily: 'FreesentationVF',
      fontWeight: FontWeight.w400,
    );

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: containerHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(size.width * 0.02),
            topRight: Radius.circular(size.width * 0.02),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 61.70,
              offset: Offset(0, -16),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 로고 (좌측 상단)
            Positioned(
              top: topPadding*0.8,
              left: horizontalMargin*1.2,
              child: SvgPicture.asset(
                "assets/images/icons/logo_app_bar.svg",
                width: size.width * 0.06,
                height: size.width * 0.06,
              ),
            ),
            // 닫기 버튼 (우측 상단)
            Positioned(
              top: topPadding*0.2,
              right: horizontalMargin*0.2,
              child: IconButton(
                icon: SvgPicture.asset("assets/images/icons/icon_close.svg"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            // 인식된 텍스트 영역 (최종 결과만 표시)
            Positioned(
              top: textTop,
              bottom: textBottom,
              left: horizontalMargin,
              right: horizontalMargin,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_recognizedText.startsWith(_guideText))
                      Center(
                        child: Text(
                          _guideText,
                          style: guideTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    MarkdownBody(
                      data: _recognizedText.startsWith(_guideText)
                          ? _recognizedText.substring(_guideText.length)
                          : _recognizedText,
                      styleSheet: MarkdownStyleSheet(
                        p: _recognizedText.startsWith(_guideText)
                            ? placeholderTextStyle
                            : TextStyle(
                                color: Colors.black,
                                fontSize: size.width * 0.04,
                                fontFamily: 'FreesentationVF',
                                fontWeight: FontWeight.w400,
                              ),
                        h1: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.05,
                          fontFamily: 'FreesentationVF',
                          fontWeight: FontWeight.w600,
                        ),
                        h2: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.045,
                          fontFamily: 'FreesentationVF',
                          fontWeight: FontWeight.w600,
                        ),
                        code: TextStyle(
                          color: Colors.black87,
                          backgroundColor: Colors.grey[200],
                          fontSize: size.width * 0.038,
                          fontFamily: 'monospace',
                        ),
                        codeblockPadding: EdgeInsets.all(8),
                        codeblockDecoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        blockquote: TextStyle(
                          color: Colors.black87,
                          fontSize: size.width * 0.04,
                          fontFamily: 'FreesentationVF',
                          fontStyle: FontStyle.italic,
                        ),
                        blockquoteDecoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: Colors.grey[400]!,
                              width: 4,
                            ),
                          ),
                        ),
                        blockquotePadding: EdgeInsets.only(left: 16),
                        listBullet: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.04,
                          fontFamily: 'FreesentationVF',
                        ),
                      ),
                      selectable: true,
                      softLineBreak: true,
                      fitContent: true,
                    ),
                  ],
                ),
              ),
            ),
            // 마이크 버튼 (하단 중앙)
            Positioned(
              bottom: micBottom,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _isListening || _isProcessing ? null : _startListening,
                  child:
                      _isListening
                          ? SvgPicture.asset(
                            "assets/images/icons/icons_chatbot_progress_$_listeningIconIndex.svg",
                            width: size.width * 0.1,
                            height: size.width * 0.1,
                          )
                          : _isProcessing
                          ? SvgPicture.asset(
                            "assets/images/icons/icons_chatbot_after_$_processingIconIndex.svg",
                            width: size.width * 0.08,
                            height: size.width * 0.08,
                          )
                          : SvgPicture.asset(
                            "assets/images/icons/icons_chatbot_mic_button_active.svg",
                            width: size.width * 0.15,
                            height: size.width * 0.15,
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
