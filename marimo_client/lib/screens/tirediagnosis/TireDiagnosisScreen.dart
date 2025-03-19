import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'widgets/TireDiagnosisCard.dart';
import 'widgets/Instruction.dart';
import 'package:marimo_client/commons/CustomAppHeader.dart';

class TireDiagnosisScreen extends StatefulWidget {
  const TireDiagnosisScreen({Key? key}) : super(key: key);

  @override
  _TireDiagnosisScreenState createState() => _TireDiagnosisScreenState();
}

class _TireDiagnosisScreenState extends State<TireDiagnosisScreen> {
  final List<XFile> _selectedImages = [];
  
  void addImage(XFile image) {
    setState(() {
      if (_selectedImages.isNotEmpty) {
        _selectedImages.clear();
      }
      _selectedImages.add(image);
    });
  }
  
  void removeImage(int index) {
    setState(() {
      _selectedImages.clear();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 커스텀 앱 헤더 적용 - 원하는 타이틀 전달
      appBar: CustomAppHeader(
        title: 'AI 진단',  // 여기에 원하는 문구 입력
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          // top 패딩을 16으로 설정하여 헤더와의 여백 조정
          padding: EdgeInsets.only(left: 20, right: 20, top: 16.h, bottom: 16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI 타이어 마모도 진단',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              
              // 타이어 진단 카드 - 가로로 전체 화면 채우기
              SizedBox(
                width: MediaQuery.of(context).size.width - 40, // 좌우 패딩 각 20을 제외한 전체 너비
                child: TireDiagnosisCard(
                  selectedImages: _selectedImages,
                  onAddImage: addImage,
                  onRemoveImage: removeImage,
                  onAnalysisPressed: () {
                    // 타이어 분석 로직 구현
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('타이어 분석 시작')),
                    );
                  },
                ),
              ),
              
              SizedBox(height: 33.h),
              
              // 유의사항 섹션 - 가로로 전체 화면 채우기
              SizedBox(
                width: MediaQuery.of(context).size.width - 40, // 좌우 패딩 각 20을 제외한 전체 너비
                child: const Instruction(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}