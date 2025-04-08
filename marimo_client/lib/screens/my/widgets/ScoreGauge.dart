import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/obd_polling_provider.dart';
import 'package:marimo_client/utils/warning_storage.dart';

class ScoreGauge extends StatefulWidget {
  const ScoreGauge({super.key});

  @override
  State<ScoreGauge> createState() => _ScoreGaugeState();
}

class _ScoreGaugeState extends State<ScoreGauge> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _targetPercentage = 0.0;
  int _totalScore = 0;
  int _dtcScore = 0;
  int _warningScore = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0, end: _targetPercentage).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _calculateScore();
  }

  Future<void> _calculateScore() async {
    // DTC 코드 점수 계산 (20점 만점)
    final dtcCount = await Provider.of<ObdPollingProvider>(context, listen: false).getStoredDtcCodeCount();
    _dtcScore = dtcCount == 0 ? 20 : 0;
    
    // 경고 메시지 점수 계산 (80점 만점)
    final warningCount = await WarningStorage.count();
    _warningScore = warningCount == 0 ? 80 : max(0, 80 - (warningCount * 7));
    
    // 총 점수 계산
    _totalScore = _dtcScore + _warningScore;
    
    // 애니메이션 목표값 설정 (0~1 사이 값으로 변환)
    _targetPercentage = _totalScore / 100;
    
    // 애니메이션 재설정 및 시작
    _animation = Tween<double>(begin: 0, end: _targetPercentage).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    
    if (mounted) {
      setState(() {});
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
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
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
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
                        painter: GaugePainter(percentage: _animation.value),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 80.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${(_animation.value * 100).toInt()}',
                              style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 4.w),
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.h),
                              child: Text(
                                '점',
                                style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildScoreItem('고장 코드', _dtcScore),
                  SizedBox(width: 16.w),
                  _buildScoreItem('상태 주의', _warningScore),
                ],
              ),
              SizedBox(height: 28.h),
              if (_totalScore < 100) // 100점이 아닐 때만 버튼 표시
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
                      onPressed: () {
                        // 모니터링 탭(2번 탭)으로 이동
                        DefaultTabController.of(context).animateTo(1);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                        minimumSize: Size(50.w, 20.h),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: Color(0xF5F5F5F5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                      ),
                      child: Text(
                        '상태 확인하기',
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
      },
    );
  }

  Widget _buildScoreItem(String label, int score) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
        ),
        SizedBox(height: 4.h),
        Text(
          '${score}점',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
      ],
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

    Color startColor;
    Color endColor;

    if (percentage < 0.33) {
      startColor = Colors.red.shade300;
      endColor = Colors.red.shade600;
    } else if (percentage < 0.66) {
      startColor = Colors.orange.shade300;
      endColor = Colors.orange.shade600;
    } else {
      startColor = const Color(0xFF9DBFFF);
      endColor = const Color(0xFF4888FF);
    }

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
      ..shader = LinearGradient(colors: [startColor, endColor])
          .createShader(Rect.fromCircle(center: Offset(centerX, centerY), radius: radius))
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

    final outerMarkerPaint = Paint()
      ..color = endColor.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(markerX, markerY), 16.w, outerMarkerPaint);

    final markerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(markerX, markerY), 6.w, markerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
