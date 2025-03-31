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

    // TTS 완료 시 처리: 음성 합성이 끝나면 처리 애니메이션 중단 후 초기 상태 복귀
    _flutterTts.setCompletionHandler(() {
      _stopProcessingAnimation();
      setState(() {
        _isProcessing = false;
        _recognizedText = "준비 중이에요";
      });
    });
  }

  /// 음성 인식 시작 (STT)
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
    return Container(
      width: 360,
      height: 300,
      child: Stack(
        children: [
          // 배경 컨테이너: 흰색, 둥근 상단 모서리, 그림자
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 360,
              height: 300,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 61.70,
                    offset: Offset(0, -16),
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
          ),
          // 로고 (좌측 상단)
          Positioned(
            left: 16,
            top: 16,
            child: Image.asset(
              "assets/images/logo/marimo_logo.png",
              width: 40,
              height: 40,
            ),
          ),
          // 닫기 버튼 (우측 상단)
          Positioned(
            right: 16,
            top: 16,
            child: IconButton(
              icon: SvgPicture.asset("assets/images/icons/icon_close.svg"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          // 왼쪽 상단의 작은 사각형 (원래 UI 요소)
          const Positioned(
            left: 21,
            top: 34.85,
            child: SizedBox(
              width: 7.38,
              height: 7.38,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xFF8D8D8D),
                  borderRadius: BorderRadius.all(Radius.circular(2.23)),
                ),
              ),
            ),
          ),
          // 하단의 원형 그라데이션 배경 (외곽)
          const Positioned(
            left: 146,
            top: 204,
            child: SizedBox(
              width: 66,
              height: 66,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment(0.50, -0.00),
                    end: Alignment(0.50, 1.00),
                    colors: [Color(0xFF4888FF), Color(0x194888FF)],
                  ),
                ),
              ),
            ),
          ),
          // 하단의 내부 원형 (배경)
          const Positioned(
            left: 152.11,
            top: 210.11,
            child: SizedBox(
              width: 53.78,
              height: 53.78,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xFF4888FF),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          // 중앙 하단의 마이크 버튼 영역
          Positioned(
            left: 152.11 + ((53.78 - 40) / 2),
            top: 210.11 + ((53.78 - 40) / 2),
            child: GestureDetector(
              onTap: _isListening || _isProcessing ? null : _startListening,
              child:
                  _isListening
                      // STT 진행 중이면 progress 아이콘 시퀀스 (1~4)
                      ? SvgPicture.asset(
                        "assets/images/icons/icons_chatbot_progress_$_listeningIconIndex.svg",
                        width: 40,
                        height: 40,
                      )
                      // TTS 처리 중이면 after 아이콘 시퀀스 (1~3)
                      : _isProcessing
                      ? SvgPicture.asset(
                        "assets/images/icons/icons_chatbot_after_$_processingIconIndex.svg",
                        width: 40,
                        height: 40,
                      )
                      // idle 상태: 초기 상태에서는 활성화된 마이크 버튼 아이콘 표시
                      : SvgPicture.asset(
                        "assets/images/icons/icons_chatbot_mic_button_active.svg",
                        width: 40,
                        height: 40,
                      ),
            ),
          ),
          // 인식된 텍스트를 표시하는 영역 (중앙)
          Positioned(
            left: 134,
            top: 113,
            child: Text(
              _recognizedText,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'FreesentationVF',
                fontWeight: FontWeight.w400,
                height: 0.78,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
