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

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      // 기본 후면 카메라(0) 사용
      _cameraController = CameraController(
        _cameras!.first,
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
          final double guidePadding = 30.w;
          final double guideTop = 100.h; // "타이어 사진 촬영" 아래에서 100px 띄움
          final double guideWidth = constraints.maxWidth - (guidePadding * 2);
          final double guideHeight = guideWidth;

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
                top: guideTop - 52.h,
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

              // 하단 안내 텍스트
              // 📌 가이드 박스 하단 기준으로 32px 아래 위치
              Positioned(
                top: guideTop + guideHeight + 32.h,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 69.w),
                      child: _buildGuideIcon(
                        'assets/images/icons/icon_distance.png',
                        "적절한 거리에서\n촬영해주세요.",
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 69.w),
                      child: _buildGuideIcon(
                        'assets/images/icons/icon_eye.png',
                        "밝고 선명하게\n촬영해주세요.",
                      ),
                    ),
                  ],
                ),
              ),

              // 촬영 버튼
              Positioned(
                bottom: 40.h,
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
      height = 14.h;
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
    // 1. 새 레이어 생성 (blendMode를 위해)
    final Paint overlayPaint = Paint()..color = overlayColor;
    canvas.saveLayer(Offset.zero & size, Paint());

    // 2. 전체 반투명 오버레이 먼저 그림
    canvas.drawRect(Offset.zero & size, overlayPaint);

    // 3. guideRect 영역을 clear로 뚫어줌 (카메라 원본 그대로 보이게)
    final Paint clearPaint = Paint()..blendMode = BlendMode.clear;
    canvas.drawRect(guideRect, clearPaint);

    // 4. dashed border 그리기 (guideRect 기준)
    final Paint dashedPaint =
        Paint()
          ..color = borderColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    final Path path = Path()..addRect(guideRect);
    final Path dashedPath = _createDashedPath(path, 3.0, 2.0); // 피그마 기준 dash

    // 반드시 clear 처리 이후에 그려야 정상 표시됨
    canvas.drawPath(dashedPath, dashedPaint);

    // 5. 레이어 복원
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
