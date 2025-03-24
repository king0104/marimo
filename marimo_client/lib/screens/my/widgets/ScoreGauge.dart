import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';

class ScoreGauge extends StatelessWidget {
  const ScoreGauge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '붕붕이 상태 점수',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 120.h,
                  width: 200.w,
                  child: CustomPaint(
                    painter: GaugePainter(percentage: 0.84 ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 80.h), // 숫자 위치 조정
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end, // 숫자와 "점" 정렬
                      children: [
                        Text(
                          '84',
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4.w), // 숫자와 "점" 간격 조정
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.h), // "점" 위치 조정 (아래로)
                          child: Text(
                            '점',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 28.h),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(24.r),
                  right: Radius.circular(24.r),
                ),
              ),
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h), // 버튼 높이 설정
                  minimumSize: Size(50.w, 20.h), // 최소 높이 설정
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 탭 영역 최소화
                  backgroundColor: Color(0xF5F5F5F5), // 배경색 변경
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r), // 모서리 둥글게
                  ),
                ),
                child: Text(
                  '자세히 보기',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GaugePainter extends CustomPainter {
  final double percentage;

  GaugePainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height;
    final radius = size.width * 0.4;

    final startAngle = pi;
    final sweepAngle = pi;

    final bgPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    final progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF9DBFFF),
          const Color(0xFF4888FF),
        ],
      ).createShader(Rect.fromCircle(center: Offset(centerX, centerY), radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      startAngle,
      sweepAngle * percentage,
      false,
      progressPaint,
    );

    final markerAngle = startAngle + sweepAngle * percentage;
    final markerX = centerX + radius * cos(markerAngle);
    final markerY = centerY + radius * sin(markerAngle);

    // ✅ 반투명 원을 먼저 그림 (z-index 낮음)
    final outerMarkerPaint = Paint()
      ..color = const Color(0x804888FF) // 반투명 파란색
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(markerX, markerY), 16.w, outerMarkerPaint);

    // ✅ 흰색 마커를 나중에 그림 (z-index 높음)
    final markerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(markerX, markerY), 6.w, markerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
