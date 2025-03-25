// TireDiagnosisResult.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/theme.dart';
import 'widgets/ResultDetailCard.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marimo_client/commons/CustomAppHeader.dart';

class TireDiagnosisResult extends StatefulWidget {
  final XFile? userImage;

  const TireDiagnosisResult({super.key, this.userImage});

  @override
  _TireDiagnosisResultState createState() => _TireDiagnosisResultState();
}

class _TireDiagnosisResultState extends State<TireDiagnosisResult> {
  late XFile? _userImage;
  late double _treadDepth;

  @override
  void initState() {
    super.initState();
    // 초기 상태 설정
    _userImage = widget.userImage;
    _treadDepth = 1.2; // 기본값 설정 (예시)
  }

  void updateTreadDepth(double newDepth) {
    setState(() {
      _treadDepth = newDepth;
    });
  }

  void updateUserImage(XFile? newImage) {
    setState(() {
      _userImage = newImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppHeader(
        title: 'AI 진단',
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Text(
                '측정 결과',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: black,
                ),
              ),
              SizedBox(height: 16.h),

              // ResultDetailCard에 상태값 전달
              ResultDetailCard(
                cardHeight: 500.h,
                treadDepth: _treadDepth,
                userImage: _userImage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
