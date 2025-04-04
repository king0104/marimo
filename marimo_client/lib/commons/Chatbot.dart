import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gemma/core/model.dart';
import 'package:flutter_gemma/pigeon.g.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
// 내장 기능 호출을 위한 화면 임포트 (CarPaymentDetailForm.dart)
import 'package:marimo_client/screens/payment/CarPaymentDetailForm.dart';

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
  // 대화 내역 또는 placeholder 텍스트
  String _recognizedText =
      "엔진 마모가 뭐야?\n마리모 요청: 차계부에 오늘 날짜로 GS칼텍스 방이점에 주유 2만원 기록해줘";

  // Gemma 모델 추론 인스턴스
  InferenceModel? _inferenceModel;

  // 애니메이션 인덱스 및 타이머
  int _listeningIconIndex = 1;
  int _processingIconIndex = 1;
  Timer? _listeningTimer;
  Timer? _processingTimer;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _flutterTts.setLanguage("ko-KR");

    // TTS 완료 시 처리: 처리 애니메이션만 중지하고, 대화 내역은 그대로 남김
    _flutterTts.setCompletionHandler(() {
      _stopProcessingAnimation();
      setState(() {
        _isProcessing = false;
      });
    });

    // Gemma 모델 초기화 (assets/ai/gemma3-1B-it-int4.task)
    _initializeGemmaModel();
  }

  // flutter_gemma 플러그인을 사용하여 모델 파일 설치 및 InferenceModel 생성
  Future<void> _initializeGemmaModel() async {
    try {
      final modelManager = FlutterGemmaPlugin.instance.modelManager;
      await modelManager.installModelFromAsset('ai/gemma3-1B-it-int4.task');
      _inferenceModel = await FlutterGemmaPlugin.instance.createModel(
        modelType: ModelType.gemmaIt,
        preferredBackend: PreferredBackend.cpu,
        maxTokens: 512,
      );
      debugPrint('Gemma 모델 초기화 완료');
    } catch (e) {
      debugPrint('Gemma 모델 초기화 오류: $e');
    }
  }

  // Gemma 모델을 통한 추론 수행 (자동차 전문가 페르소나 및 기타 질문 처리 지침 포함)
  Future<String> _performGemmaInference(String prompt) async {
    if (_inferenceModel == null) {
      return "모델이 초기화되지 않았습니다.";
    }
    try {
      // markdown 금지, 1분 제한, 자동차 전문가 페르소나와
      // 자동차 관련이 아닌 질문은 상식적인 경우에만 답변하고, 그렇지 않으면 "다시 말씀해주시겠어요?"라고 응답하도록 지시
      String modifiedPrompt =
          "응답은 순수 텍스트만 사용하고 markdown 형식은 사용하지 마세요. "
              "대답은 최대 1분 이내로 작성해주세요. "
              "당신은 30년 이상의 경력을 가진 자동차 전문가로, 모든 차량 문제, 부품, 유지보수 및 수리 관련 정보를 폭넓게 알고 있습니다. "
              "전문적이고 신뢰할 수 있는 정보를 바탕으로 답변해주세요. "
              "만약 질문이 자동차와 관련된 것이 아니라면, 상식적인 내용이면 답변해주시고, 그렇지 않은 경우에는 '다시 말씀해주시겠어요?'라고 응답해주세요. " +
          prompt;
      final session = await _inferenceModel!.createSession(
        temperature: 1.0,
        randomSeed: 1,
        topK: 1,
      );
      await session.addQueryChunk(Message(text: modifiedPrompt));
      final response = await session.getResponse();
      await session.close();
      return response;
    } catch (e) {
      debugPrint("추론 오류: $e");
      return "오류 발생";
    }
  }

  // 타자기 효과로 한 글자씩 텍스트 추가 (append)
  Future<void> _appendTextWithTypewriterEffect(String newLine) async {
    for (int i = 0; i < newLine.length; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        _recognizedText += newLine[i];
      });
    }
    setState(() {
      _recognizedText += "\n";
    });
  }

  // 타자기 효과로 전체 텍스트를 업데이트 (덮어쓰기)
  Future<void> _updateTypewriterText(String newText) async {
    setState(() {
      _recognizedText = "";
    });
    for (int i = 0; i < newText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        _recognizedText += newText[i];
      });
    }
  }

  Future<void> _startListening() async {
    // placeholder 텍스트가 그대로 있으면 새 대화를 위해 초기화
    if (_recognizedText ==
        "엔진 마모가 뭐야?\n마리모 요청: 차계부에 오늘 날짜로 GS칼텍스 방이점에 주유 2만원 기록해줘") {
      setState(() {
        _recognizedText = "";
      });
    }
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
          // STT 중: partial 결과에도 타자기 효과 적용
          if (!result.finalResult) {
            await _updateTypewriterText(result.recognizedWords);
          } else {
            // 최종 결과 처리
            String recognized = result.recognizedWords;
            // 우선 사용자의 발화를 타자기 효과로 추가
            await _appendTextWithTypewriterEffect(recognized);
            await _stopListening();

            // 만약 인식된 텍스트가 "마리모 요청"으로 시작하면 내장 기능 호출
            if (recognized.trim().startsWith("마리모 요청")) {
              // "마리모 요청:" 접두어를 제거하여 실제 명령을 추출
              String command =
                  recognized.replaceFirst(RegExp(r'^마리모 요청:?'), "").trim();
              // 여기서 command를 파싱하여 내장 기능에 필요한 정보(예, selectedCategory, amount)를 추출할 수 있음.
              // 예시로 '주유' 카테고리와 2만원(20000원)으로 처리한다고 가정합니다.
              String selectedCategory = "주유";
              int amount = 20000;

              // 처리 시작: 내장 기능 호출 메시지 출력
              _startProcessingAnimation();
              setState(() {
                _isProcessing = true;
                _recognizedText += "내장된 차계부 기능을 호출합니다.\n";
              });

              // 내장 기능 호출: CarPaymentDetailForm 화면으로 전환
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
            } else {
              // 일반적인 경우: 자동차 전문가로서 Gemma 모델을 통한 추론 처리
              _startProcessingAnimation();
              setState(() {
                _isProcessing = true;
                _recognizedText += "AI 마리모가 대답을 준비하고 있어요.\n";
              });
              String generatedResponse = await _performGemmaInference(
                recognized,
              );
              _stopProcessingAnimation();
              setState(() {
                _isProcessing = false;
                _recognizedText += generatedResponse + "\n";
              });
              await _flutterTts.speak(generatedResponse);
            }
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
    final topPadding = containerHeight * 0.05;
    final textTop = containerHeight * 0.25;
    final textBottom = containerHeight * 0.25;
    final micBottom = containerHeight * 0.1;

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
              top: topPadding,
              left: horizontalMargin,
              child: Image.asset(
                "assets/images/logo/marimo_logo.png",
                width: size.width * 0.1,
                height: size.width * 0.1,
              ),
            ),
            // 닫기 버튼 (우측 상단)
            Positioned(
              top: topPadding,
              right: horizontalMargin,
              child: IconButton(
                icon: SvgPicture.asset("assets/images/icons/icon_close.svg"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            // 인식된 텍스트 영역 (타자기 효과 또는 full text로 표시)
            Positioned(
              top: textTop,
              bottom: textBottom,
              left: horizontalMargin,
              right: horizontalMargin,
              child: SingleChildScrollView(
                child: Center(
                  child: Text(
                    _recognizedText,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: size.width * 0.04,
                      fontFamily: 'FreesentationVF',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
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
