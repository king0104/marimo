import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/screens/Insurance/SelectInsuranceScreen.dart';

class InsurancePageView extends StatefulWidget {
  const InsurancePageView({super.key});

  @override
  State<InsurancePageView> createState() => _InsurancePageViewState();
}

class _InsurancePageViewState extends State<InsurancePageView> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 500.h,  // 높이 조정 필요
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            children: [
              _buildEmptyInsurance(),
              _buildSecondPage(),
              _buildThirdPage(),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        _buildButton(),
      ],
    );
  }

  Widget _buildEmptyInsurance() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        height: 400.h, // 카드 크기 조정
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
    );
  }

  Widget _buildSecondPage() {
    return Container();
  }

  Widget _buildThirdPage() {
    return Container();
  }

  Widget _buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (currentPage < 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SelectInsuranceScreen()),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4888FF),
          padding: EdgeInsets.symmetric(vertical: 16.h),
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
    );
  }
}
