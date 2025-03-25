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
    if (state == AppLifecycleState.resumed && mounted) {
      setState(() {
        // 필요한 경우 여기에 상태 업데이트 로직을 추가할 수 있습니다.
      });
    }
  }

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
    super.build(context);

    final contentWidth = MediaQuery.of(context).size.width - 40;

    return Scaffold(
      appBar: CustomAppHeader(
        title: 'AI 진단',
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Color(0xFFFBFBFB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ).copyWith(top: 16.h, bottom: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI 타이어 마모도 진단',
                  key: UniqueKey(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16.h),

                SizedBox(
                  width: contentWidth,
                  child: TireDiagnosisCard(
                    key: UniqueKey(),
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

                SizedBox(
                  width: contentWidth,
                  child: Instruction(key: UniqueKey()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
