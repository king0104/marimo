// TireCameraGuide.dart
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marimo_client/theme.dart';

class TireCameraGuide extends StatefulWidget {
  final Function(XFile) onImageCaptured;

  const TireCameraGuide({Key? key, required this.onImageCaptured})
    : super(key: key);

  @override
  State<TireCameraGuide> createState() => _TireCameraGuideState();
}

class _TireCameraGuideState extends State<TireCameraGuide> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  int _selectedCameraIndex = 0; // 선택된 카메라 인덱스 (0: 후면, 1: 전면)

  final double baseHeight = 603.0; // 기준 해상도 height

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(
        _cameras![_selectedCameraIndex],
        ResolutionPreset.high,
      );
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    }
  }

  // 카메라 전환 함수
  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length <= 1) return;

    // 현재 카메라 컨트롤러 해제
    await _cameraController?.dispose();

    // 다음 카메라 인덱스 선택 (전면 <-> 후면)
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;

    // 새 카메라로 컨트롤러 초기화
    _cameraController = CameraController(
      _cameras![_selectedCameraIndex],
      ResolutionPreset.high,
    );

    // 초기화 및 상태 업데이트
    await _cameraController!.initialize();
    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  Future<void> _captureImage() async {
    if (!_isCameraInitialized || _cameraController == null) return;
    final XFile image = await _cameraController!.takePicture();
    widget.onImageCaptured(image);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenHeight = constraints.maxHeight;
          final double screenWidth = constraints.maxWidth;

          // 1. 기준 해상도에서의 값
          const double baseHeight = 603.0;
          const double baseGuideTop = 100.0;
          const double baseGuidePadding = 30.0;
          const double baseTextMarginFromGuide = 52.0; // 152 - 100
          const double baseIconMarginFromGuide = 35.0; // 하단 여백
          const double baseButtonMarginFromGuide = 120.0; // 대략 버튼까지 여백
          // 여기에 따로 추가할 오프셋 정의 (예: 20px 아래로)
          const double guideOffset = 10.0;

          // 헤더 높이 비율에 맞춰 제외 (예: 45 / 603 ≈ 0.0746)
          final double headerOffset = screenHeight * (45 / baseHeight);
          final double cameraHeight = screenHeight - headerOffset;

          // 2. 비율 계산
          // 가이드 박스는 offset 반영해서 아래로 내림
          final double guideTop =
              screenHeight * ((baseGuideTop + guideOffset) / baseHeight);
          final double guidePadding = baseGuidePadding.w;
          final double guideWidth = screenWidth - (guidePadding * 2);
          final double guideHeight = guideWidth;

          // final double topTextTop = guideTop - screenHeight * (35 / baseHeight);
          // 텍스트는 원래 자리 그대로!
          final double topTextTop =
              screenHeight * ((baseGuideTop - 35) / baseHeight);

          // 가이드 박스 아래 여백 계산 (전체 화면 기준)
          final double guideBottom = guideTop + guideHeight;
          final double guideBottomSpace = screenHeight - guideBottom;

          // 버튼 중심까지 거리 비율 적용 (비율: 106 / 203 ≈ 0.5221)
          final double captureButtonMarginFromBottom =
              guideBottomSpace * (30 / 203); // ← 아래 여백 30 유지하려면 이걸로
          final double iconMarginFromGuide =
              guideBottomSpace * (35 / 203); // 아이콘은 위 기준

          final double buttonMarginFromGuide =
              cameraHeight * (120.0 / baseHeight); // 106은 기준값
          final double distanceIconTop = guideBottom + iconMarginFromGuide;
          final double eyeIconTop = distanceIconTop;
          final double captureButtonTop = guideBottom + buttonMarginFromGuide;
          final double captureButtonBottom =
              baseHeight -
              (guideBottom +
                  screenHeight * (baseButtonMarginFromGuide / baseHeight));
          // final double captureButtonBottom =
          //     screenHeight - (guideBottom + screenHeight * (105 / baseHeight));

          // // 실제 cameraHeight를 기준으로 위치 계산
          // final double topTextTop = cameraHeight * 0.0796;
          // final double guideTop = cameraHeight * 0.1658;
          // final double guidePadding = 30.w;
          // final double guideWidth = constraints.maxWidth - (guidePadding * 2);
          // final double guideHeight = guideWidth; // ✅ 정사각형으로 고정

          // final double distanceIconTop =
          //     guideTop + guideHeight + cameraHeight * 0.0545;
          // final double eyeIconTop =
          //     guideTop + guideHeight + cameraHeight * 0.0497;
          // final double captureButtonBottom = cameraHeight * 0.0464;

          final Rect guideRect = Rect.fromLTWH(
            guidePadding,
            guideTop,
            guideWidth,
            guideHeight,
          );

          return Stack(
            children: [
              // 카메라 미리보기
              Positioned.fill(child: _buildCameraPreview()),

              // 오버레이 + 가이드 박스
              Positioned.fill(
                child: CustomPaint(
                  painter: TireOverlayPainter(
                    guideRect: guideRect,
                    overlayColor: const Color.fromRGBO(25, 24, 29, 0.7),
                    borderColor: brandColor,
                    strokeWidth: 2.w,
                  ),
                ),
              ),

              // 가이드 텍스트
              Positioned(
                top: topTextTop,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    '타이어 트레드(홈) 부분이 잘 보이도록 촬영하세요.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // 거리 아이콘
              Positioned(
                top: distanceIconTop,
                left: 69.w,
                child: _buildGuideIcon(
                  'assets/images/icons/icon_distance.png',
                  "적절한 거리에서\n촬영해주세요.",
                ),
              ),

              // 눈 아이콘
              Positioned(
                top: eyeIconTop,
                right: 69.w,
                child: _buildGuideIcon(
                  'assets/images/icons/icon_eye.png',
                  "밝고 선명하게\n촬영해주세요.",
                ),
              ),

              // 촬영 버튼
              Positioned(
                bottom: captureButtonMarginFromBottom,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: _captureImage,
                    child: Image.asset(
                      'assets/images/icons/icon_camerabutton.png',
                      width: 66.w,
                      height: 66.h,
                    ),
                  ),
                ),
              ),

              // 카메라 전환 버튼
              Positioned(
                top: 15.h,
                right: 15.w,
                child: GestureDetector(
                  onTap: _switchCamera,
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.flip_camera_ios,
                      color: Colors.white,
                      size: 24.w,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (!_isCameraInitialized || _cameraController == null) {
      return Container(color: Colors.black);
    }
    return CameraPreview(_cameraController!);
  }

  Widget _buildGuideIcon(String assetPath, String text) {
    double width = 24.w;
    double height = 24.h;

    if (assetPath.contains('icon_distance')) {
      width = 28.w;
      height = 18.h;
    } else if (assetPath.contains('icon_eye')) {
      width = 21.w;
      height = 18.h;
    }

    return Column(
      children: [
        Image.asset(
          assetPath,
          width: width,
          height: height,
          color: Colors.white,
        ),
        SizedBox(height: 8.h),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class TireOverlayPainter extends CustomPainter {
  final Rect guideRect;
  final Color overlayColor;
  final Color borderColor;
  final double strokeWidth;

  TireOverlayPainter({
    required this.guideRect,
    required this.overlayColor,
    required this.borderColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint overlayPaint = Paint()..color = overlayColor;
    canvas.saveLayer(Offset.zero & size, Paint());

    canvas.drawRect(Offset.zero & size, overlayPaint);

    final Paint clearPaint = Paint()..blendMode = BlendMode.clear;
    canvas.drawRect(guideRect, clearPaint);

    final Paint dashedPaint =
        Paint()
          ..color = borderColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    final Path path = Path()..addRect(guideRect);
    final Path dashedPath = _createDashedPath(path, 3.0, 2.0);

    canvas.drawPath(dashedPath, dashedPaint);
    canvas.restore();
  }

  Path _createDashedPath(Path source, double dashWidth, double dashSpace) {
    final Path dashedPath = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        dashedPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    return dashedPath;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
