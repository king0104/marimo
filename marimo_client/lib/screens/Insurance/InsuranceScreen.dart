import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/screens/Insurance/widgets/InsuranceHeader.dart';
import 'package:marimo_client/screens/Insurance/widgets/InsurancePageView.dart';
import 'package:marimo_client/commons/CustomAppHeader.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/navigation_provider.dart';

class InsuranceScreen extends StatelessWidget {
  final bool isInsuranceRegistered;

  const InsuranceScreen({
    super.key,
    this.isInsuranceRegistered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: CustomAppHeader(
        title: '자동차 보험',
        onBackPressed: () {
          if (isInsuranceRegistered) {
            // 보험이 등록된 상태일 때 메인 스크린으로 이동하고 마이페이지 탭 선택
            final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
              (route) => false,
            ).then((_) {
              navigationProvider.setIndex(4);
            });
          } else {
            // 보험 등록 과정 중에는 이전 화면으로 이동
            Navigator.pop(context);
          }
        },
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