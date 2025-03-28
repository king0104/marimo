import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/screens/Insurance/widgets/InsuranceHeader.dart';
import 'package:marimo_client/screens/Insurance/widgets/InsurancePageView.dart';

class InsuranceScreen extends StatelessWidget {
  final bool isInsuranceRegistered;  // 보험 등록 여부

  const InsuranceScreen({
    super.key,
    this.isInsuranceRegistered = false,  // 기본값은 미등록 상태
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20.w,
            color: Colors.grey[500],
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '자동차 보험',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '내 자동차 보험 관리',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20.h),
              // 보험 등록 여부에 따라 다른 화면 표시
              if (isInsuranceRegistered)
                const InsuranceHeader()
              else
                const InsurancePageView(),
            ],
          ),
        ),
      ),
    );
  }
}
