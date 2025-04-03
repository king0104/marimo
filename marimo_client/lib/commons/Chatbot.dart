import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gemma/core/model.dart';
import 'package:flutter_gemma/pigeon.g.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_gemma/flutter_gemma.dart';

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
  // 누적 텍스트 (타자기 효과 적용)
  String _recognizedText = "";

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

    // TTS 완료 시 처리
    _flutterTts.setCompletionHandler(() {
      _stopProcessingAnimation();
      setState(() {
        _isProcessing = false;
        // 기본 안내 문구로 초기화
        _recognizedText = "AI '마리모'에게 궁금한 것을 물어봐주세요.";
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

  // Gemma 모델을 통한 추론 수행
  Future<String> _performGemmaInference(String prompt) async {
    if (_inferenceModel == null) {
      return "모델이 초기화되지 않았습니다.";
    }
    try {
      // markdown 금지 및 1분 제한 프롬프트 추가
      String modifiedPrompt =
          "응답은 순수 텍스트만 사용하고 markdown 형식은 사용하지 마세요. "
              "대답은 최대 1분 이내로 작성해주세요. " +
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

  // 타자기 효과로 한 줄씩 텍스트 추가
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

  Future<void> _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => debugPrint('STT Status: $status'),
      onError: (error) => debugPrint('STT Error: $error'),
    );
    if (available) {
      setState(() {
        _isListening = true;
        _recognizedText = "";
      });
      // 초기 인사말과 안내문을 타자기 효과로 표시
      await _appendTextWithTypewriterEffect("안녕하세요? AI 마리모입니다.");
      await _appendTextWithTypewriterEffect("원하시는 내용을 말씀해주세요.");
      _startListeningAnimation();
      _speech.listen(
        onResult: (result) async {
          if (result.finalResult) {
            // 최종 결과를 타자기 효과로 추가
            await _appendTextWithTypewriterEffect(result.recognizedWords);
            await _stopListening();
            _startProcessingAnimation();
            // Gemma 모델 추론 및 결과 타자기 효과
            String generatedResponse = await _performGemmaInference(
              _recognizedText,
            );
            await _appendTextWithTypewriterEffect(generatedResponse);
            // TTS로 음성 출력
            await _flutterTts.speak(generatedResponse);
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
            // 인식된 텍스트 영역 (타자기 효과로 표시)
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
