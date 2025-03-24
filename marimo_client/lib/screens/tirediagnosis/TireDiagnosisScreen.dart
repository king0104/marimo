// TireDiagnosisScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'widgets/TireDiagnosisCard.dart';
import 'widgets/Instruction.dart';
import 'package:marimo_client/commons/CustomAppHeader.dart';
import 'TireDiagnosisResult.dart';

class TireDiagnosisScreen extends StatefulWidget {
  const TireDiagnosisScreen({Key? key}) : super(key: key);

  @override
  _TireDiagnosisScreenState createState() => _TireDiagnosisScreenState();
}

class _TireDiagnosisScreenState extends State<TireDiagnosisScreen>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  final List<XFile> _selectedImages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 앱이 다시 활성화될 때 화면을 강제로 다시 그립니다
      if (mounted) setState(() {});
    }
  }

  // AutomaticKeepAliveClientMixin 구현
  @override
  bool get wantKeepAlive => true;

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
    // AutomaticKeepAliveClientMixin 사용 시 필수
    super.build(context);

    // 화면 너비 계산 (패딩 제외)
    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = screenWidth - 40; // 좌우 패딩 각 20을 제외한 전체 너비

    return Scaffold(
      appBar: CustomAppHeader(
        title: 'AI 진단',
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Color(0xFFFBFBFB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16.h,
              bottom: 16.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 텍스트를 Key로 감싸서 리빌드 시 항상 새로 생성되도록 합니다
                Text(
                  'AI 타이어 마모도 진단',
                  key: ValueKey('title_text'),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16.h),

                // 타이어 진단 카드 - 가로로 전체 화면 채우기
                SizedBox(
                  width: contentWidth,
                  child: TireDiagnosisCard(
                    key: ValueKey('diagnosis_card'),
                    selectedImages: _selectedImages,
                    onAddImage: addImage,
                    onRemoveImage: removeImage,
                    onAnalysisPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (_) => TireDiagnosisResult(
                                userImage:
                                    _selectedImages.isNotEmpty
                                        ? _selectedImages[0]
                                        : null,
                              ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 33.h),

                // 유의사항 섹션 - 가로로 전체 화면 채우기
                SizedBox(
                  width: contentWidth,
                  child: const Instruction(key: ValueKey('instruction')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
