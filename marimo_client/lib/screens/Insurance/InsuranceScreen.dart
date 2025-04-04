import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/commons/CustomAppHeader.dart';
import 'package:marimo_client/screens/Insurance/widgets/InsuranceHeader.dart';
import 'package:marimo_client/screens/Insurance/widgets/InsuranceDetails.dart';
import 'package:marimo_client/screens/Insurance/widgets/InsurancePageView.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/navigation_provider.dart';

class InsuranceScreen extends StatelessWidget {
  final bool isInsuranceRegistered;

  const InsuranceScreen({
    super.key,
    this.isInsuranceRegistered = false,
  });

  // 만기일까지 남은 일수 계산 함수 추가
  bool _isNearExpiration(String expiryDate) {
    final expiry = DateTime.parse(expiryDate.replaceAll('.', '-'));
    final today = DateTime.now();
    final difference = expiry.difference(today).inDays;
    return difference <= 30 && difference >= 0;  // 만기 30일 이내이고 아직 만기가 지나지 않은 경우
  }

  @override
  Widget build(BuildContext context) {
    // 만기일 체크 (InsuranceDetails의 '2024.12.31' 형식 사용)
    final bool showExpiryNotice = _isNearExpiration('2025.04.31');

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
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isInsuranceRegistered 
                      ? '내 자동차 마일리지 특약 관리'
                      : '내 자동차 보험 관리',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (isInsuranceRegistered)
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF000000).withOpacity(0.02),
                            blurRadius: 11.8,
                            spreadRadius: 4,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO: 삭제 기능 구현
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 6.h),
                          backgroundColor: Colors.white,
                          side: BorderSide(
                            color: const Color(0xFF000000).withOpacity(0.2),
                            width: 0.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          '삭제하기',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (isInsuranceRegistered && showExpiryNotice) ...[  // 조건 추가
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEFEF),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: const Color(0xFFFF9898),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 20.w,
                        color: const Color(0xFFFF9898),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '이번 달에 보험이 만기되어요.',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF000000),
                              ),
                            ),
                            Text(
                              '지금 주행거리를 제출하는게 유리해요!',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF000000),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 10.h),
              if (isInsuranceRegistered) ...[
                const InsuranceHeader(),
                SizedBox(height: 20.h),
                Text(
                  '상세 정보',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.h),
                const InsuranceDetails(),
                SizedBox(height: 40.h),
              ] else
                const InsurancePageView(),
            ],
          ),
        ),
      ),
    );
  }
}