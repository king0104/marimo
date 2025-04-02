import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gemma/core/model.dart';
import 'package:flutter_gemma/pigeon.g.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marimo_client/screens/my/MyScreen.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_gemma/flutter_gemma.dart'; // flutter_gemma 플러그인 import

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
  // 마이크 버튼 클릭 시 프리셋 메시지: 음성 인식 시작 전에 기본 안내 문구를 표시
  String _recognizedText = "안녕하세요? AI 마리모입니다.\n원하시는 내용을 말씀해주세요.";

  // Gemma 모델 추론 인스턴스 및 현재 활성 세션
  InferenceModel? _inferenceModel;
  dynamic _currentSession;

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

    // TTS 완료 시 처리: 응답이 끝나면 처리 애니메이션을 중지하고 기본 안내 메시지로 복원
    _flutterTts.setCompletionHandler(() {
      _stopProcessingAnimation();
      setState(() {
        _isProcessing = false;
        _recognizedText = "안녕하세요? AI 마리모입니다.\n원하시는 내용을 말씀해주세요.";
      });
    });

    // Gemma 모델 초기화 (assets/ai/gemma3-1B-it-int4.task)
    _initializeGemmaModel();
  }

  /// flutter_gemma 플러그인을 사용하여 assets에 포함된 Gemma 모델 파일을 설치하고 InferenceModel 생성
  Future<void> _initializeGemmaModel() async {
    try {
      final modelManager = FlutterGemmaPlugin.instance.modelManager;
      // 모델 설치: assets에 있는 .task 파일을 디바이스 내부에 저장 (디버그 모드에서 사용)
      await modelManager.installModelFromAsset('ai/gemma3-1B-it-int4.task');
      // 모델 추론 인스턴스 생성
      _inferenceModel = await FlutterGemmaPlugin.instance.createModel(
        modelType: ModelType.gemmaIt, // Gemma instruction-tuned 모델
        preferredBackend: PreferredBackend.cpu, // 또는 PreferredBackend.gpu
        maxTokens: 512, // 최대 토큰 수 (응답 길이 제한)
      );
      debugPrint('Gemma 모델 초기화 완료');
    } catch (e) {
      debugPrint('Gemma 모델 초기화 오류: $e');
    }
  }

  /// Gemma 모델을 통해 추론 수행
  /// 프롬프트에 "마크다운 사용 금지", "최대 1분 분량", "서비스 기능 호출 시 action: myscreen" 조건을 포함합니다.
  Future<String> _performGemmaInference(String prompt) async {
    if (_inferenceModel == null) {
      return "모델이 초기화되지 않았습니다.";
    }
    try {
      final session = await _inferenceModel!.createSession(
        temperature: 1.0, // 생성 시 무작위성
        randomSeed: 1, // 재현성을 위한 랜덤 시드
        topK: 1, // 후보 토큰 제한
      );
      _currentSession = session;
      String modifiedPrompt =
          "대답은 일반 텍스트로만 작성해 주세요. 마크다운이나 다른 포맷은 사용하지 마세요. "
              "대답은 최대 1분 이내로 간결하게 작성해 주세요. 만약 사용자 요청이 서비스 기능(예: 마이 스크린 이동)을 요구하면, "
              "'action: myscreen' 형식으로 응답해 주세요. 사용자 입력: " +
          prompt;
      await session.addQueryChunk(Message(text: modifiedPrompt));
      final response = await session.getResponse();
      await session.close();
      _currentSession = null;
      return response;
    } catch (e) {
      debugPrint("추론 오류: $e");
      return "오류 발생";
    }
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => debugPrint('STT Status: $status'),
      onError: (error) => debugPrint('STT Error: $error'),
    );
    if (available) {
      setState(() {
        _isListening = true;
        // 마이크 버튼 클릭 시 기본 안내 메시지를 미리 출력
        _recognizedText = "안녕하세요? AI 마리모입니다.\n원하시는 내용을 말씀해주세요.";
      });
      _startListeningAnimation();
      _speech.listen(
        onResult: (result) async {
          // 인식된 결과를 한 줄씩 추가하여 화면에 표시
          setState(() {
            _recognizedText += "\n" + result.recognizedWords;
          });
          if (result.finalResult) {
            await _stopListening();
            _startProcessingAnimation();
            String generatedResponse = await _performGemmaInference(
              _recognizedText,
            );
            // Gemma 응답이 서비스 기능 호출 명령(action:)이면 TTS 대신 해당 기능 수행
            if (generatedResponse.trim().startsWith("action:")) {
              String action =
                  generatedResponse.trim().substring("action:".length).trim();
              if (action.toLowerCase() == "myscreen") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyScreen()),
                );
              }
            } else {
              // 일반 응답은 TTS로 읽어줌
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
    _speech.stop();
    _flutterTts.stop();
    _currentSession?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final containerHeight = size.height / 3;
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
            // 인식된 텍스트 영역
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
                      fontSize: size.width * 0.05,
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
