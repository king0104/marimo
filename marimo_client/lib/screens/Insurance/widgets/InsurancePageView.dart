import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/screens/Insurance/SelectInsuranceScreen.dart';

class InsurancePageView extends StatefulWidget {
  const InsurancePageView({super.key});

  @override
  State<InsurancePageView> createState() => _InsurancePageViewState();
}

class _InsurancePageViewState extends State<InsurancePageView> {
  @override
  Widget build(BuildContext context) {
    // 화면 높이에서 SafeArea 영역과 패딩을 제외한 높이 계산
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final topPadding = MediaQuery.of(context).padding.top;
    final availableHeight = screenHeight - bottomPadding - topPadding - 250.h; // 높이를 더 줄임

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: availableHeight,
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '등록된 자동차보험이 없습니다.',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SafeArea(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SelectInsuranceScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4888FF),
              minimumSize: Size(double.infinity, 56.h),  // 너비를 double.infinity로 설정
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              '내 자동차 보험 추가하기',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
