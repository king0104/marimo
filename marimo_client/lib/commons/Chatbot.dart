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
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Chatbot extends StatefulWidget {
  final bool isReceiptMode;
  const Chatbot({super.key, required this.isReceiptMode});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> with WidgetsBindingObserver {
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  bool _isProcessing = false;
  bool _keyboardVisible = false;

  // 원래 placeholder 텍스트
  final String _guideText = "버튼을 누르고, 예시처럼 말해보세요.\n";
  final String _placeholderText = "\"냉각수가 뭐야?\"";
  final String _receiptPlaceholderText = "\"차계부에 주유 2만원 기록해줘\"";
  String _recognizedText = "버튼을 누르고, 예시처럼 말해보세요.\n\"냉각수가 뭐야?\"";
  String _receiptRecognizedText = "버튼을 누르고, 예시처럼 말해보세요.\n\"차계부에 주유 2만원 기록해줘\"";

  // Gemma 모델 추론 인스턴스
  InferenceModel? _inferenceModel;

  // 애니메이션 인덱스 및 타이머
  int _listeningIconIndex = 1;
  int _processingIconIndex = 1;
  Timer? _listeningTimer;
  Timer? _processingTimer;

  // 최종 결과 중복 처리를 위한 플래그
  bool _finalResultProcessed = false;

  // 상수 정의 추가
  static const String RECEIPT_PROCESSING_MESSAGE = "차계부 등록 정보를 추출 중이에요";
  static const String AI_PROCESSING_MESSAGE = "마리모 AI가 대답을 준비하고 있어요";

  void _initializeTts() {
    _flutterTts.setLanguage("ko-KR");
    _flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    });
  }

  void _initializeSpeech() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _initializeTts();
    _initializeSpeech();
    WidgetsBinding.instance.addObserver(this);

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

  // 상대적인 날짜를 DateTime으로 변환하는 함수
  DateTime? convertRelativeDate(String dateStr) {
    try {
      dateStr = dateStr.trim().toLowerCase();
      final now = DateTime.now();
      
      if (dateStr == "오늘") {
        return now;
      } else if (dateStr == "어제") {
        return now.subtract(const Duration(days: 1));
      } else if (dateStr == "그제" || dateStr == "그저께") {
        return now.subtract(const Duration(days: 2));
      } else if (dateStr.endsWith("일 전")) {
        final days = int.tryParse(dateStr.replaceAll(RegExp(r'[^0-9]'), ''));
        if (days != null) {
          return now.subtract(Duration(days: days));
        }
      } else if (dateStr.endsWith("주 전")) {
        final weeks = int.tryParse(dateStr.replaceAll(RegExp(r'[^0-9]'), ''));
        if (weeks != null) {
          return now.subtract(Duration(days: weeks * 7));
        }
      }
    } catch (e) {
      debugPrint("날짜 변환 오류: $e");
    }
    return null;
  }

  /// STT 텍스트에서 금액을 추출하고 처리하는 함수
  int extractAndProcessAmount(String text) {
    try {
      // 금액 패턴 정규식 (만원 단위와 일반 금액 모두 포함)
      final RegExp amountPattern = RegExp(r'(\d+(?:,\d{3})*만\s*\d*원|\d+만원|\d+(?:,\d{3})*원)');
      final match = amountPattern.firstMatch(text);
      if (match == null) return 0;

      String amountStr = match.group(0)!.replaceAll(',', '');
      debugPrint('추출된 금액 문자열: $amountStr');
      
      // 1. 만 단위 + 일반 금액 조합 (예: "60만 520원")
      if (amountStr.contains('만') && amountStr.contains('원')) {
        List<String> parts = amountStr.split('만');
        int result = 0;
        
        // 만 단위 처리
        String manPart = parts[0].trim();
        int? manAmount = int.tryParse(manPart);
        if (manAmount != null) {
          result = manAmount * 10000;
        }
        
        // 일반 금액 처리
        if (parts.length > 1) {
          String wonPart = parts[1].trim().replaceAll('원', '');
          if (wonPart.isNotEmpty) {
            int? wonAmount = int.tryParse(wonPart);
            if (wonAmount != null) {
              result += wonAmount;
            }
          }
        }
        
        return result;
      }
      
      // 2. 만 단위만 있는 경우 (예: "2만원")
      if (amountStr.contains('만원')) {
        String manPart = amountStr.replaceAll('만원', '');
        int? amount = int.tryParse(manPart);
        return amount != null ? amount * 10000 : 0;
      }
      
      // 3. 일반 금액 (예: "9,200원", "200원")
      String normalAmount = amountStr.replaceAll('원', '');
      int? amount = int.tryParse(normalAmount);
      return amount ?? 0;
      
    } catch (e) {
      debugPrint('금액 추출 오류: $e');
      return 0;
    }
  }

  // 차계부 결제내역 등록 정보를 추출하는 Gemma 프롬프트 함수
  Future<Map<String, dynamic>> _performCarPaymentEntryInference(String userCommand) async {
    if (_inferenceModel == null) return {};
    try {
      // 1. STT 텍스트에서 금액 추출 및 변환
      int extractedAmount = extractAndProcessAmount(userCommand);
      debugPrint('추출된 금액: $extractedAmount');

      // 2. 원본 텍스트에서 금액 부분을 추출된 정수로 대체
      String modifiedCommand = userCommand.replaceAll(
        RegExp(r'\d+(?:,\d{3})*만\s*\d*원|\d+만원|\d+(?:,\d{3})*원'),
        '${extractedAmount}원'
      );
      debugPrint('수정된 명령어: $modifiedCommand');

      String carPaymentPrompt =
          "당신은 자동차 결제내역 등록 전문가입니다. 사용자 명령을 분석하여 아래 정보를 추출하세요.\n"
              "출력은 반드시 순수 JSON 형식으로만 작성해 주세요. 어떠한 markdown 태그나 추가 서식(예: ``` , **, ## 등)도 포함하지 않아야 합니다.\n"
              "1. 결제 유형: '주유', '정비', '세차' 중 하나.\n"
              "2. 결제 금액: 입력된 정수 금액을 그대로 사용하세요.\n"
              "3. 날짜: [매우 중요] 다음 규칙을 반드시 지켜주세요!\n"
              "   - 상대적 날짜(\"어제\", \"3일 전\" 등)는 절대로 변환하지 말고 그대로 출력\n"
              "   - 날짜가 없으면 \"오늘\"\n"
              "   - 예시:\n"
              "     * \"어제\" -> \"어제\"\n"
              "     * \"3일 전\" -> \"3일 전\"\n"
              "     * 날짜 없음 -> \"오늘\"\n"
              "4. 장소: 결제가 이루어진 장소가 언급된 경우에만 출력하세요. 장소가 언급되지 않았다면 빈 문자열(\"\")을 출력하세요. '주유'인 경우, 반드시 SK, GS, 현대오일뱅크, S-OIL 중 하나로 시작해야 합니다.\n"
              "5. 타입: 만약 '주유'이면 반드시 '고급 휘발유', '일반 휘발유', '경유', 'LPG' 중 하나여야 하며, '정비'이면 부품, '세차'이면 null을 출력하세요.\n"
              "6. 메모: 선택 사항입니다. 입력이 없으면 null로 출력하세요.\n"
              "예시1: { \"category\": \"주유\", \"amount\": 35280, \"date\": \"오늘\", \"location\": \"\", \"type\": \"일반 휘발유\", \"memo\": null }\n"
              "예시2: { \"category\": \"주유\", \"amount\": 720090, \"date\": \"오늘\", \"location\": \"\", \"type\": \"일반 휘발유\", \"memo\": null }\n"
              "사용자 명령: " +
          modifiedCommand;

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
        .replaceAll(RegExp(r'```'), '')  // 남아있는 모든 ``` 제거
        .trim();
  }

  Future<void> _startListening() async {
    await _flutterTts.stop();
    
    if (!mounted) return;
    
    if (widget.isReceiptMode) {
      if (_recognizedText == _guideText + _receiptPlaceholderText) {
        setState(() {
          _recognizedText = "";
        });
      }
    } else {
      if (_recognizedText == _guideText + _placeholderText) {
        setState(() {
          _recognizedText = "";
        });
      }
    }
    _finalResultProcessed = false;
    
    try {
      bool available = await _speech.initialize(
        onStatus: (status) => debugPrint('STT Status: $status'),
        onError: (error) => debugPrint('STT Error: $error'),
      );
      
      if (available && mounted) {
        setState(() {
          _isListening = true;
        });
        _startListeningAnimation();
        
        await _speech.listen(
          onResult: (result) async {
            if (!result.finalResult) return;
            if (_finalResultProcessed) return;
            _finalResultProcessed = true;
            
            if (!mounted) return;
            
            String recognized = result.recognizedWords;
            debugPrint("최종 STT 결과: $recognized");
            
            await _stopListening();
            if (!mounted) return;
            
            if (widget.isReceiptMode) {
              _startProcessingAnimation();
              if (mounted) {
                setState(() {
                  _isProcessing = true;
                  _recognizedText = RECEIPT_PROCESSING_MESSAGE;
                });
              }
              Map<String, dynamic> paymentData = await _performCarPaymentEntryInference(recognized);
              if (!mounted) return;
              _stopProcessingAnimation();
              String category = paymentData["category"] ?? "주유";
              int amount = 0;
              
              // 금액 처리 로직 수정
              var rawAmount = paymentData["amount"];
              if (rawAmount != null) {
                if (rawAmount is int) {
                  amount = rawAmount;
                } else if (rawAmount is String) {
                  // 문자열에서 숫자만 추출
                  amount = int.tryParse(rawAmount.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                }
              }

              debugPrint('처리된 금액: $amount');  // 디버그 로그 추가

              // Provider 업데이트
              final carPaymentProvider = Provider.of<CarPaymentProvider>(
                context,
                listen: false,
              );
              carPaymentProvider.setSelectedCategory(category);
              carPaymentProvider.setSelectedAmount(amount);
              if (paymentData["date"] != null) {
                try {
                  String dateStr = paymentData["date"].toString().trim();
                  DateTime? date;
                  
                  // ISO8601 형식이 아닌 경우 상대적 날짜로 처리
                  if (!dateStr.contains('T')) {
                    date = convertRelativeDate(dateStr);
                  } else {
                    try {
                      date = DateTime.parse(dateStr);
                    } catch (e) {
                      debugPrint('날짜 파싱 오류: $e');
                      date = null;
                    }
                  }
                  
                  // 날짜 변환 실패시 현재 날짜 사용
                  date ??= DateTime.now();
                  
                  if (mounted) {
                    carPaymentProvider.setSelectedDate(date);
                  }
                } catch (e) {
                  debugPrint("날짜 처리 오류: $e");
                  if (mounted) {
                    carPaymentProvider.setSelectedDate(DateTime.now());
                  }
                }
              } else {
                if (mounted) {
                  carPaymentProvider.setSelectedDate(DateTime.now());
                }
              }
              // 주유의 경우, location은 SK, GS, 현대오일뱅크, S-OIL로 시작해야 함
              if (category == "주유") {
                String location = paymentData["location"]?.toString() ?? "";
                if (location.isNotEmpty &&
                    (location.startsWith("SK") ||
                    location.startsWith("GS") ||
                    location.startsWith("현대오일뱅크") ||
                    location.startsWith("S-OIL"))) {
                  carPaymentProvider.setLocation(location);
                } else {
                  carPaymentProvider.setLocation("");
                }
              } else {
                carPaymentProvider.setLocation(paymentData["location"]?.toString() ?? "");
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
              if (!mounted) return;
              String generatedResponse = await _performGemmaInference(recognized);
              if (!mounted) return;
              _stopProcessingAnimation();
              setState(() {
                _recognizedText = generatedResponse;
              });
              await _flutterTts.speak(removeMarkdownCharacters(generatedResponse));
            }
          },
          listenFor: const Duration(seconds: 10),
          localeId: "ko_KR",
        );
      }
    } catch (e) {
      debugPrint("STT 초기화 오류: $e");
      if (mounted) {
        setState(() {
          _isListening = false;
        });
      }
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
    if (!mounted) return;
    _listeningTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _listeningIconIndex = (_listeningIconIndex % 4) + 1;
      });
    });
  }

  void _stopListeningAnimation() {
    _listeningTimer?.cancel();
    if (!mounted) return;
    setState(() {
      _listeningIconIndex = 1;
      _isListening = false;
    });
  }

  void _startProcessingAnimation() {
    _processingTimer?.cancel();
    if (!mounted) return;
    setState(() {
      _isProcessing = true;
    });
    _processingTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _processingIconIndex = (_processingIconIndex % 3) + 1;
      });
    });
  }

  void _stopProcessingAnimation() {
    _processingTimer?.cancel();
    if (!mounted) return;
    setState(() {
      _processingIconIndex = 1;
      _isProcessing = false;
    });
  }

  @override
  void dispose() {
    _listeningTimer?.cancel();
    _processingTimer?.cancel();
    _speech.stop();
    _flutterTts.stop();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (mounted) {
      final newKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
      if (newKeyboardVisible != _keyboardVisible) {
        setState(() {
          _keyboardVisible = newKeyboardVisible;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final containerHeight = size.height * 0.65;
    final horizontalMargin = size.width * 0.08;
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
      fontSize: size.width * 0.035,
      fontFamily: 'FreesentationVF',
      fontWeight: FontWeight.w400,
    );

    TextStyle noticeTextStyle = TextStyle(  // 안내 문구용 스타일 추가
      color: Colors.grey[500],
      fontSize: size.width * 0.03,  // 더 작은 폰트 크기
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
              top: topPadding*0.5,
              left: horizontalMargin*1.0,
              child: Image.asset(
                widget.isReceiptMode 
                  ? "assets/images/icons/icons_ai_receipt.png"
                  : "assets/images/icons/icons_ai_mic.png",
                width: size.width * 0.06,
                height: size.width * 0.06,
              ),
            ),
            // 타이틀 텍스트 (중앙 상단)
            Positioned(
              top: topPadding*0.5,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  widget.isReceiptMode ? "AI 차계부 음성입력" : "차량 전문가 AI",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: size.width * 0.04,
                    fontFamily: 'FreesentationVF',
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (_recognizedText.startsWith(_guideText))
                      Center(
                        child: Text(
                          _guideText,
                          style: guideTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (_recognizedText.startsWith(_guideText))
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          widget.isReceiptMode ? _receiptPlaceholderText : _placeholderText,
                          style: placeholderTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      )
                    else if (_isProcessing)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            widget.isReceiptMode 
                              ? RECEIPT_PROCESSING_MESSAGE
                              : AI_PROCESSING_MESSAGE,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: size.width * 0.04,
                              fontFamily: 'FreesentationVF',
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else
                      MarkdownBody(
                        data: _recognizedText,
                        styleSheet: MarkdownStyleSheet(
                          p: TextStyle(
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
              bottom: size.height * 0.08, // 안내 문구 위에 위치
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
            // 안내 문구
            Positioned(
              bottom: 10, // 컨테이너 하단에서 10 위치
              left: horizontalMargin,
              right: horizontalMargin,
              child: Text(
                "마리모 AI는 온디바이스 AI로, 날씨나 시간 등 실시간성 질문에 대한 답변은 부정확할 수 있습니다.",
                style: noticeTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
