import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

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
  String _recognizedText = "준비 중이에요";

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
        _recognizedText = "준비 중이에요";
      });
    });
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('STT Status: $status'),
      onError: (error) => print('STT Error: $error'),
    );
    if (available) {
      setState(() {
        _isListening = true;
        _recognizedText = "";
      });
      _startListeningAnimation();
      _speech.listen(
        onResult: (result) async {
          setState(() {
            _recognizedText = result.recognizedWords;
          });
          if (result.finalResult) {
            await _stopListening();
            _startProcessingAnimation();
            await _flutterTts.speak(_recognizedText);
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
                  // Center 위젯을 사용해서 텍스트 자체를 가운데 정렬합니다.
                  child: Text(
                    _recognizedText,
                    textAlign: TextAlign.center, // 텍스트 가운데 정렬
                    softWrap: true, // 자동 줄바꿈 활성화
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
