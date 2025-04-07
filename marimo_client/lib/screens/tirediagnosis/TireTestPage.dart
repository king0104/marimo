// TireTestPage.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TireTestPage extends StatelessWidget {
  final Map<String, dynamic> result;

  const TireTestPage({Key? key, required this.result}) : super(key: key);

  Color _getConditionColor(String condition) {
    switch (condition) {
      case '정상':
        return Colors.green;
      case '주의':
        return Colors.amber;
      case '교체 필요':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final contentWidth = MediaQuery.of(context).size.width - 40;

    return Scaffold(
      appBar: AppBar(title: Text('타이어 분석 결과'), centerTitle: true, elevation: 0),
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
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '상세 분석 결과',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      _buildResultRow(
                        '트레드 깊이:',
                        '${result['treadDepth'].toStringAsFixed(2)} mm',
                      ),

                      SizedBox(height: 24.h),

                      _buildResultRow('교체 시기:', ''),

                      SizedBox(height: 24.h),

                      // 트레드 깊이에 따른 문구
                      Text(
                        () {
                          final depth = result['treadDepth'];
                          if (depth <= 1.6) {
                            return '❗ 타이어 트레드의 법적 최저 한계선보다 마모되었습니다.\n당장 타이어 교체가 필요합니다.';
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
                            if (depth <= 1.6) return Colors.red;
                            if (depth <= 3.0) return Colors.orange;
                            return Colors.green;
                          }(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 12.h),

                      Text(
                        '트레드 깊이 게이지 (0~8mm)',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[700],
                        ),
                      ),

                      SizedBox(height: 8.h),

                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 24.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey[200],
                            ),
                          ),
                          Positioned(
                            left: (1.6 / 8.0) * contentWidth,
                            width: ((3.0 - 1.6) / 8.0) * contentWidth,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          Positioned(
                            left:
                                (result['treadDepth'] / 8.0) * contentWidth -
                                1.5,
                            top: 0,
                            bottom: 0,
                            child: Container(width: 3, color: Colors.black),
                          ),
                        ],
                      ),

                      SizedBox(height: 24.h),

                      _buildResultRow(
                        '잔여 수명:',
                        '${result['remainingLife'].toStringAsFixed(1)}%',
                      ),

                      SizedBox(height: 20.h),

                      Text(
                        '잔여 수명 그래프',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[700],
                        ),
                      ),

                      SizedBox(height: 8.h),

                      Container(
                        width: double.infinity,
                        height: 24.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[200],
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: result['remainingLife'] / 100,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: _getConditionColor(result['condition']),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // 권장 사항
                Container(
                  width: contentWidth,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '권장 사항',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        _getRecommendation(result['condition']),
                        style: TextStyle(fontSize: 14.sp),
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
  }

  Widget _buildResultRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16.sp, color: Colors.grey[800])),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
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
