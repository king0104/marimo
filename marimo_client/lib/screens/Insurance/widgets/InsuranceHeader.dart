import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animated_digit/animated_digit.dart';
import 'package:marimo_client/services/insurance/Insurance_service.dart';
import 'package:intl/intl.dart';  // NumberFormat을 사용하기 위해 추가

class InsuranceHeader extends StatefulWidget {
  final Map<String, dynamic> insuranceInfo;  // 보험 정보 추가

  const InsuranceHeader({
    super.key,
    required this.insuranceInfo,
  });

  @override
  State<InsuranceHeader> createState() => _InsuranceHeaderState();
}

class _InsuranceHeaderState extends State<InsuranceHeader> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final double percentage = 0.35;
  
  // 컨트롤러 초기값 설정
  late AnimatedDigitController _amountController = AnimatedDigitController(0);
  late AnimatedDigitController _distanceController = AnimatedDigitController(0);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    // 애니메이션 초기화 - drivingPercentage 사용
    _animation = Tween<double>(
      begin: 0, 
      end: widget.insuranceInfo['drivingPercentage'] ?? 0.0
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
    
    // 애니메이션 시작
    _animationController.forward();
    
    // 금액 애니메이션 컨트롤러 초기화
    _amountController = AnimatedDigitController(
      widget.insuranceInfo['currentDiscountAmount'] ?? 0
    );
    
    // 거리 애니메이션 컨트롤러 초기화
    _distanceController = AnimatedDigitController(
      widget.insuranceInfo['totalDistanceExpectation']?.toInt() ?? 0
    );
  }

  // _startAnimation 함수는 이제 컨트롤러만 재시작
  void _startAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  @override
  void didUpdateWidget(InsuranceHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (mounted) {
      _startAnimation();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _amountController.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  List<Color> _getGradientColors(double value) {
    if (value < 0.33) {
      return [const Color(0xFF9DBFFF), const Color(0xFF4888FF)];  // 파랑
    } else if (value < 0.66) {
      return [Colors.orange.shade300, Colors.orange.shade600];     // 주황
    } else {
      return [Colors.red.shade300, Colors.red.shade600];          // 빨강
    }
  }

  @override
  Widget build(BuildContext context) {
    final insuranceCode = widget.insuranceInfo['insuranceCompanyName'] as String;
    final insuranceName = InsuranceService.getInsuranceNameByCode(insuranceCode);
    final insuranceLogo = InsuranceService.getInsuranceLogoByCode(insuranceCode);
    final isExceededLimit = widget.insuranceInfo['remainingDistanceToNextDiscount'] == null;
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFFCCCCCC),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        insuranceLogo,
                        width: 20.w,
                        height: 20.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    insuranceName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              
              if (isExceededLimit) ...[
                Text(
                  '환급 가능한 주행거리를 넘었습니다.',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '현재 주행거리: ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '${NumberFormat('#,###').format(widget.insuranceInfo['calculatedDistance'])}km',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Column(
                  children: [
                    Text(
                      '다음 구간까지',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.sp,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${widget.insuranceInfo['remainingDistanceToNextDiscount']}',
                          style: TextStyle(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'km',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          ' 남음',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '현재 할인율: ',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '${widget.insuranceInfo['currentDiscountRate']}%',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '다음 할인율: ',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: _getGradientColors(_animation.value)[1],
                          ),
                        ),
                        Text(
                          '${widget.insuranceInfo['nextDiscountRate']}%',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: _getGradientColors(_animation.value)[1],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  height: 34.h,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: 9.h,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 16.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Stack(
                                  children: [
                                    Container(
                                      color: Colors.grey[200],
                                    ),
                                    FractionallySizedBox(
                                      widthFactor: _animation.value,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: _getGradientColors(_animation.value),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (_animation.value > 0 && _animation.value < 1)
                            Positioned(
                              left: constraints.maxWidth * _animation.value - 16.w,
                              child: Container(
                                width: 32.w,
                                height: 32.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _getGradientColors(_animation.value)[1].withOpacity(0.5),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 16.w,
                                    height: 16.w,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.insuranceInfo['discountFromKm']}km',  // 시작 km
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      '${widget.insuranceInfo['discountToKm']}km',  // 종료 km
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Text(
                      '현재 구간 환급 예상액',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Transform.translate(
                        offset: Offset(0, -4),
                        child: AnimatedDigitWidget(
                          value: widget.insuranceInfo['currentDiscountAmount'] ?? 0,
                          duration: const Duration(milliseconds: 1000),
                          textStyle: TextStyle(
                            fontSize: 24.sp,
                            color: const Color(0xFF4888FF),
                            fontWeight: FontWeight.bold,
                          ),
                          enableSeparator: true,
                          fractionDigits: 0,
                          separateLength: 3,
                          curve: Curves.easeOut,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '원',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xFF8E8E8E),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Text(
                      '예상 총 주행거리 (만기일 기준)',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '약 ',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xFF8E8E8E),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Transform.translate(
                        offset: Offset(0, -4),
                        child: AnimatedDigitWidget(
                          value: widget.insuranceInfo['totalDistanceExpectation'] ?? 0,  // 예상 총 주행거리
                          duration: const Duration(milliseconds: 1000),
                          textStyle: TextStyle(
                            fontSize: 24.sp,
                            color: const Color(0xFF4888FF),
                            fontWeight: FontWeight.bold,
                          ),
                          enableSeparator: true,
                          fractionDigits: 0,
                          separateLength: 3,
                          curve: Curves.easeOut,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'km',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xFF8E8E8E),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Text(
                      '보험료 관리팁',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4888FF).withOpacity(0.05),
                    border: Border.all(
                      color: const Color(0xFF4888FF),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '다음 구간 보다 ${NumberFormat('#,###').format(widget.insuranceInfo['discountDifferenceWithNextStage'])}원 절약할 수 있어요!',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

