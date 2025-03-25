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

class _TireDiagnosisResultState extends State<TireDiagnosisResult>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  late XFile? _userImage;
  late double _treadDepth;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
    }
  }

  void _initializeData() {
    _userImage = widget.userImage;
    _treadDepth = 1.2;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAlive 필수 호출
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
                key: UniqueKey(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontFamily: 'YourFontFamily', // 실제 사용 폰트 지정
                ),
              ),
              SizedBox(height: 16.h),
              ResultDetailCard(
                key: UniqueKey(),
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
