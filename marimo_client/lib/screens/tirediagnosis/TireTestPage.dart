// TireTestPage.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/theme.dart'; // ✅ theme import 추가
import 'package:marimo_client/commons/CustomAppHeader.dart';

class TireTestPage extends StatelessWidget {
  final Map<String, dynamic> result;

  const TireTestPage({Key? key, required this.result}) : super(key: key);

  Color _getConditionColor(String condition) {
    switch (condition) {
      case '정상':
        return brandColor;
      case '주의':
        return pointColor;
      case '교체 필요':
        return pointRedColor;
      default:
        return iconColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final contentWidth = MediaQuery.of(context).size.width - 40;

    return Scaffold(
      appBar: CustomAppHeader(
        title: 'AI 진단',
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: backgroundColor, // ✅ theme 적용
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ).copyWith(top: 16.h, bottom: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 결과 헤더
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    decoration: BoxDecoration(
                      color: _getConditionColor(
                        result['condition'],
                      ).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '타이어 상태: ${result['condition']}',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: _getConditionColor(result['condition']),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // 상세 정보 카드
                Container(
                  width: contentWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 11.8,
                        spreadRadius: 4,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      side: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1.w,
                      ),
                    ),
                    color: white,
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '상세 분석 결과',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: black, // ✅ theme 적용
                            ),
                          ),
                          SizedBox(height: 16.h),

                          _buildResultRow(
                            '트레드 깊이:',
                            '${result['treadDepth'].toStringAsFixed(2)} mm',
                          ),

                          SizedBox(height: 24.h),

                          _buildResultRow('교체 시기:', ''),

                          SizedBox(height: 8.h),

                          // 트레드 깊이에 따른 문구
                          Text(
                            () {
                              final depth = result['treadDepth'];
                              if (depth <= 1.6) {
                                return '❗타이어 트레드의 법적 최저한계선보다 마모되었습니다.\n당장 타이어 교체가 필요합니다.';
                              } else if (depth <= 3.0) {
                                return '⚠️ 트레드 깊이가 1.6mm ~ 3.0mm 사이입니다.\n타이어 교체를 권장합니다.';
                              } else {
                                return '✅ 아직 타이어 교체 시기가 아닙니다.';
                              }
                            }(),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: () {
                                final depth = result['treadDepth'];
                                if (depth <= 1.6) return pointRedColor;
                                if (depth <= 3.0) return pointColor;
                                return brandColor;
                              }(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 8.h),

                          Text(
                            '트레드 깊이 게이지 (0~9mm)',
                            style: TextStyle(fontSize: 14.sp, color: iconColor),
                          ),

                          SizedBox(height: 8.h),

                          Stack(
                            clipBehavior: Clip.none, // ✅ 영역 넘치는 화살표 렌더링 허용
                            children: [
                              // 🔽 화살표 마커 (게이지 위에 표시)
                              Positioned(
                                left:
                                    (result['treadDepth'] / 9.0) *
                                        contentWidth -
                                    12.w,
                                top: -15.h,
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  size: 24.sp,
                                  color: black,
                                ),
                              ),

                              // 전체 게이지 바
                              Container(
                                width: double.infinity,
                                height: 12.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: lightgrayColor.withOpacity(0.2),
                                ),
                              ),

                              // 0 ~ 3.0mm 구간 pointRedColor → 투명 그라데이션
                              Positioned(
                                left: 0,
                                width: (3.0 / 9.0) * contentWidth,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        pointRedColor,
                                        pointRedColor.withOpacity(0.0),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(7),
                                    ),
                                  ),
                                ),
                              ),

                              // 3.0mm 기준선 막대 (게이지 위아래로 넘기는 긴 막대)
                              Positioned(
                                left: (3.0 / 9.0) * contentWidth - 0.5,
                                top: -4.h, // 위로 일정 높이
                                bottom: -4.h, // 아래로 일정 높이
                                child: Container(width: 1, color: iconColor),
                              ),

                              // ⬇️ 눈금 텍스트
                              Positioned(
                                top: 20.h,
                                left: 0,
                                child: Text(
                                  '0',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: iconColor,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 20.h,
                                left: (1.6 / 9.0) * contentWidth - 8.w,
                                child: Text(
                                  '1.6',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: iconColor,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 20.h,
                                left: (3.0 / 9.0) * contentWidth - 8.w,
                                child: Text(
                                  '3.0',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: iconColor,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 20.h,
                                left: contentWidth - 36.w,
                                child: Text(
                                  '9',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: iconColor,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 48.h),

                          _buildResultRow(
                            '잔여 수명:',
                            '${result['remainingLife'].toStringAsFixed(1)}%',
                          ),

                          SizedBox(height: 12.h),

                          Text(
                            '잔여 수명 그래프',
                            style: TextStyle(fontSize: 14.sp, color: iconColor),
                          ),

                          SizedBox(height: 8.h),

                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // 전체 게이지 바
                              Container(
                                width: double.infinity,
                                height: 12.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: lightgrayColor.withOpacity(0.2),
                                ),
                              ),

                              // 남은 수명 바
                              Positioned(
                                left: 0,
                                width:
                                    (result['remainingLife'] / 100) *
                                    contentWidth,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _getConditionColor(
                                      result['condition'],
                                    ),
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(7),
                                    ),
                                  ),
                                ),
                              ),

                              // 눈금 텍스트: 0
                              Positioned(
                                top: 20.h,
                                left: 0,
                                child: Text(
                                  '0',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: iconColor,
                                  ),
                                ),
                              ),

                              // 눈금 텍스트: 100
                              Positioned(
                                top: 20.h,
                                right: 0,
                                child: Text(
                                  '100',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: iconColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // 권장 사항
                Container(
                  width: contentWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 11.8,
                        spreadRadius: 4,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      side: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1.w,
                      ),
                    ),
                    color: white,
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '권장 사항',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: black, // ✅ theme 적용
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            _getRecommendation(result['condition']),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: black.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            color: black,
            fontWeight: FontWeight.w700,
          ),
        ), // ✅ theme 적용
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: black, // ✅ theme 적용
          ),
        ),
      ],
    );
  }

  String _getRecommendation(String condition) {
    switch (condition) {
      case '정상':
        return '• 타이어 상태가 양호합니다.\n• 정기적인 공기압 점검을 유지하세요.\n• 3,000~5,000km마다 타이어 상태를 확인하세요.';
      case '주의':
        return '• 타이어 마모가 진행 중입니다.\n• 운전 시 더 주의하세요, 특히 비나 눈이 올 때.\n• 가까운 시일 내에 타이어 교체를 계획하세요.\n• 공기압을 정확하게 유지하여 추가 마모를 방지하세요.';
      case '교체 필요':
        return '• 타이어를 즉시 교체하세요!\n• 현재 타이어 상태는 안전하지 않습니다.\n• 미끄러운 노면에서 제동 거리가 크게 증가할 수 있습니다.\n• 가능한 빨리 타이어 전문점을 방문하세요.';
      default:
        return '상태를 확인할 수 없습니다. 전문가에게 문의하세요.';
    }
  }
}
