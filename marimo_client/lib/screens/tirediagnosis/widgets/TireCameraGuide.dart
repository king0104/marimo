// TireCameraGuide.dart
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class TireCameraGuide extends StatefulWidget {
  final Function(XFile) onImageCaptured;

  const TireCameraGuide({
    Key? key,
    required this.onImageCaptured,
  }) : super(key: key);

  @override
  State<TireCameraGuide> createState() => _TireCameraGuideState();
}

class _TireCameraGuideState extends State<TireCameraGuide> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  int _selectedCameraIndex = 0; // 현재 선택된 카메라 (0 = 후면, 1 = 전면)

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  /// 📸 **카메라 초기화**
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

  /// 🔄 **카메라 전환 (후면 ↔ 전면)**
  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;

    _selectedCameraIndex = _selectedCameraIndex == 0 ? 1 : 0;

    await _cameraController?.dispose();
    _cameraController = CameraController(
      _cameras![_selectedCameraIndex],
      ResolutionPreset.high,
    );

    await _cameraController!.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  /// 📷 **사진 촬영 (파란색 버튼 클릭 시)**
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
      backgroundColor: Colors.black, // 📌 배경색을 검은색으로 설정
      body: Stack(
        children: [
          // 📸 **비율이 정상적인 카메라 미리보기**
          Positioned.fill(child: _buildCameraPreview()),

          // 📏 가이드 박스 및 텍스트
          Positioned(
            top: 70.h,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  '타이어 트레드(홈) 부분이 잘 보이도록 촬영하세요.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.h),
                Center(
                  child: Container(
                    width: 250.w,
                    height: 250.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFF4888FF),
                        width: 2.w,
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 📌 하단 촬영 가이드 아이콘 및 텍스트
          Positioned(
            bottom: 120.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildGuideIcon(Icons.swap_horiz, "적절한 거리에서\n촬영해주세요."),
                _buildGuideIcon(Icons.visibility_outlined, "밝고 선명하게\n촬영해주세요."),
              ],
            ),
          ),

          // 📸 하단 촬영 버튼 (파란색)
          Positioned(
            bottom: 40.h,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _captureImage, // 🔹 버튼 클릭 시 촬영
                child: Container(
                  width: 64.w,
                  height: 64.h,
                  decoration: BoxDecoration(
                    color: Color(0xFF4888FF), // 브랜드 색상
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 56.w,
                      height: 56.h,
                      decoration: BoxDecoration(
                        color: Color(0xFF4888FF),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.8),
                          width: 2.w,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 📌 **비율을 올바르게 유지하는 카메라 미리보기**
  Widget _buildCameraPreview() {
    if (!_isCameraInitialized || _cameraController == null) {
      return Container(color: Colors.black);
    }

    return Center(
      child: AspectRatio(
        aspectRatio: 1 / _cameraController!.value.aspectRatio,
        child: CameraPreview(_cameraController!),
      ),
    );
  }

  /// 📌 가이드 아이콘 및 텍스트
  Widget _buildGuideIcon(IconData icon, String text) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 24.sp,
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