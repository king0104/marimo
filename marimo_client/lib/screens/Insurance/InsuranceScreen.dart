import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/commons/CustomAppHeader.dart';
import 'package:marimo_client/screens/Insurance/widgets/InsuranceHeader.dart';
import 'package:marimo_client/screens/Insurance/widgets/InsuranceDetails.dart';
import 'package:marimo_client/screens/Insurance/widgets/InsurancePageView.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/navigation_provider.dart';
import 'package:marimo_client/services/insurance/Insurance_service.dart';
import 'package:marimo_client/providers/member/auth_provider.dart';
import 'package:marimo_client/providers/car_provider.dart';

class InsuranceScreen extends StatefulWidget {  // StatefulWidget으로 변경
  const InsuranceScreen({
    super.key,
  });

  @override
  State<InsuranceScreen> createState() => _InsuranceScreenState();
}

class _InsuranceScreenState extends State<InsuranceScreen> {
  bool isInsuranceRegistered = false;
  Map<String, dynamic>? insuranceInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // 다음 프레임에서 실행하도록 수정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInsuranceInfo();
    });
  }

  Future<void> _fetchInsuranceInfo() async {
    if (!mounted) return;
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final carProvider = Provider.of<CarProvider>(context, listen: false);
      
      final carId = carProvider.firstCarId;
      final accessToken = authProvider.accessToken;

      print('🔍 Fetching insurance info - carId: $carId, token: $accessToken');

      final info = await InsuranceService.getInsuranceInfo(carId!, accessToken!);
      print('✅ Received insurance info: $info');
      
      if (!mounted) return;
      
      setState(() {
        insuranceInfo = info;
        isInsuranceRegistered = true;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      if (e is InsuranceException) {
        switch (e.statusCode) {
          case 404:
            setState(() {
              isInsuranceRegistered = false;
              isLoading = false;
            });
            break;
          case 403:
            setState(() {
              isLoading = false;
              isInsuranceRegistered = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('접근 권한이 없습니다.')),
            );
            _navigateToMyTab(context);
            break;
          default:
            setState(() {
              isLoading = false;
              isInsuranceRegistered = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('오류가 발생했습니다: ${e.toString()}')),
            );
            _navigateToMyTab(context);
        }
      } else {
        // 네트워크 타임아웃 등 기타 에러 처리
        setState(() {
          isLoading = false;
          isInsuranceRegistered = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다: ${e.toString()}')),
        );
        _navigateToMyTab(context);
      }
    }
  }

  // 마이 탭으로 이동하는 메서드
  void _navigateToMyTab(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => false,
    ).then((_) {
      navigationProvider.setIndex(4);  // 마이 탭 인덱스
    });
  }

  // 만기일까지 남은 일수 계산 함수 추가
  bool _isNearExpiration(String expiryDate) {
    final expiry = DateTime.parse(expiryDate.replaceAll('.', '-'));
    final today = DateTime.now();
    final difference = expiry.difference(today).inDays;
    return difference <= 30 && difference >= 0;  // 만기 30일 이내이고 아직 만기가 지나지 않은 경우
  }

  // 보험 삭제 메서드 추가
  Future<void> _deleteInsurance() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final accessToken = authProvider.accessToken;
      final carInsuranceId = insuranceInfo?['carInsuranceId'];

      if (accessToken == null || carInsuranceId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('삭제에 필요한 정보가 없습니다.')),
        );
        return;
      }

      // 삭제 확인 다이얼로그
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.5),  // 반투명 배경
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '등록된 자동차 보험을 삭제하시겠습니까?',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context, false),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      color: const Color(0xFFE5E5EA),
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '취소',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context, true),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '확인',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      if (confirmed != true) return;

      await InsuranceService.deleteInsurance(carInsuranceId, accessToken);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('보험 정보가 삭제되었습니다.')),
      );

      setState(() {
        isInsuranceRegistered = false;
        insuranceInfo = null;
      });

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('삭제 실패: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 만기일 체크 (insuranceInfo의 endDate 사용)
    final bool showExpiryNotice = insuranceInfo != null && 
        _isNearExpiration(insuranceInfo!['endDate']);

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: CustomAppHeader(
        title: '자동차 보험',
        onBackPressed: () {
          // 보험이 등록된 상태이거나 등록되지 않은 상태 모두 마이 탭으로 이동
          final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/',
            (route) => false,
          ).then((_) {
            navigationProvider.setIndex(4);  // 마이 탭 인덱스
          });
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
                        onPressed: _deleteInsurance,
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
              if (isInsuranceRegistered && showExpiryNotice) ...[
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
                              '이번 달에 보험이 만기돼요.',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF000000),
                              ),
                            ),
                            Text(
                              insuranceInfo!['canSubmitDistanceNow'] 
                                ? '지금 주행거리를 제출하는 게 유리해요!'
                                : '${insuranceInfo!['remainingDistanceToNextDiscount']}km이하로 운행할 예정이시라면\n말일에 제출하는 게 유리해요!',
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
                InsuranceHeader(insuranceInfo: insuranceInfo!),
                SizedBox(height: 20.h),
                Text(
                  '상세 정보',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.h),
                InsuranceDetails(insuranceInfo: insuranceInfo!),
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