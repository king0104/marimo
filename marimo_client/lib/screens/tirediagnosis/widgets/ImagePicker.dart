// ImagePicker.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'TireCameraPage.dart';

class TireImagePicker extends StatelessWidget {
  final List<XFile> selectedImages;
  final Function(XFile) onAddImage;
  final Function(int) onRemoveImage;
  final double buttonSize; // 새로 추가된 매개변수
  
  // 피그마 디자인에서 가져온 색상 상수
  static const Color brandColor = Color(0xFF4888FF); // #4888FF 색상
  
  const TireImagePicker({
    Key? key,
    required this.selectedImages,
    required this.onAddImage,
    required this.onRemoveImage,
    this.buttonSize = 35, // 기본값 설정
  }) : super(key: key);

    Future<void> _pickImage(BuildContext context, ImageSource source) async {
    if (source == ImageSource.camera) {
      // 카메라로 촬영 선택 시 TireCameraPage로 이동
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TireCameraPage(
            onImageCaptured: (XFile image) {
              // 기존 이미지가 있으면 제거하고 새 이미지 추가
              if (selectedImages.isNotEmpty) {
                onRemoveImage(0);
              }
              onAddImage(image);
            },
          ),
        ),
      );
    } else {
      // 갤러리에서 선택하는 경우 기존 코드 유지
      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(source: source);
      
      if (pickedImage != null) {
        if (selectedImages.isNotEmpty) {
          onRemoveImage(0);
        }
        onAddImage(pickedImage);
      }
    }
  }
  
  void _showPickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('카메라로 촬영'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('갤러리에서 선택'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 194, // 고정 너비 설정
        height: 194, // 고정 높이 설정
        decoration: BoxDecoration(
          color: selectedImages.isEmpty ? brandColor.withOpacity(0.1) : null, // 배경색 업데이트
          border: Border.all(
            color: brandColor.withOpacity(0.4), // 테두리 색상 업데이트
            width: 1.w,
            style: BorderStyle.solid,
          ),
        ),
        child: selectedImages.isEmpty
            ? GestureDetector(
                onTap: () => _showPickerOptions(context),
                child: Center(
                  // 커스텀 얇은 + 아이콘 (brandColor 색상 사용)
                  child: CustomPaintedPlusIcon(
                    size: buttonSize,
                    strokeWidth: 2.w,
                    color: brandColor.withOpacity(0.4), // 아이콘 색상 업데이트
                  ),
                ),
              )
            : _buildImageView(context),
      ),
    );
  }

  Widget _buildImageView(BuildContext context) {
  return GestureDetector(
    onTap: () => _showPickerOptions(context),
    child: Image.file(
      File(selectedImages[0].path),
      fit: BoxFit.cover,
    ),
  );
}
}

// 커스텀 '+' 아이콘 - 선 굵기를 조절할 수 있음
class CustomPaintedPlusIcon extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color color;

  const CustomPaintedPlusIcon({
    Key? key,
    required this.size,
    required this.strokeWidth,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: PlusPainter(
          strokeWidth: strokeWidth,
          color: color,
        ),
      ),
    );
  }
}

class PlusPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;

  PlusPainter({
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // 가로선
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
    
    // 세로선
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}