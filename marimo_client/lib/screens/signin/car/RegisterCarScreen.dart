import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/screens/monitoring/widgets/Car3DModel.dart';
import 'package:marimo_client/screens/signin/widgets/CustomTitleText.dart';
import 'package:marimo_client/screens/signin/car/CarRegistrationStepperScreen.dart';
import 'package:marimo_client/theme.dart';

class RegisterCarScreen extends StatefulWidget {
  const RegisterCarScreen({super.key});

  @override
  State<RegisterCarScreen> createState() => _RegisterCarScreenState();
}

class _RegisterCarScreenState extends State<RegisterCarScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTitleText(
                            text: "좋아요!\n그럼 이제 내 차를 등록해볼까요?",
                            highlight: "내 차를 등록해볼까요?",
                          ),

                          SizedBox(height: 48.h),

                          Text.rich(
                            TextSpan(
                              style: TextStyle(
                                fontSize: 18.sp,
                                height: 1.5,
                                color: backgroundBlackColor,
                              ),
                              children: [
                                const TextSpan(text: "마리모는 차량의 "),
                                TextSpan(
                                  text: "실시간 상태 분석",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: brandColor,
                                  ),
                                ),
                                const TextSpan(text: "을 통해\n"),
                                TextSpan(
                                  text: "맞춤형 정비 추천",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: brandColor,
                                  ),
                                ),
                                const TextSpan(text: "과 "),
                                TextSpan(
                                  text: "금융 혜택",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: brandColor,
                                  ),
                                ),
                                const TextSpan(text: "을 제공해요!"),
                              ],
                            ),
                          ),

                          SizedBox(height: 48.h),

                          // 📦 준비물 리스트 (AIDescModal 느낌으로)
                          _SectionTitle(
                            icon: "📝",
                            title: "차량 등록을 위해 다음을 준비해주세요!",
                          ),
                          ...[
                            "본인 명의의 차량",
                            "OBD-II 스캐너 (예: ELM327 등)",
                            "내 소비 패턴 분석을 위한 마이데이터 카드 정보",
                            "운전자 맞춤 혜택을 위한 마이데이터 보험 정보",
                          ].map((text) {
                            final boldWords = [
                              "차량",
                              "OBD-II 스캐너",
                              "카드 정보",
                              "보험 정보",
                            ];

                            // 기본 span 초기화
                            InlineSpan span = TextSpan(
                              text: "· $text",
                              style: TextStyle(
                                fontSize: 16.sp,
                                height: 1.3.h,
                                color: backgroundBlackColor,
                              ),
                            );

                            // 강조 키워드 포함 시 스타일링 변경
                            for (final word in boldWords) {
                              if (text.contains(word)) {
                                final parts = text.split(word);
                                span = TextSpan(
                                  children: [
                                    TextSpan(text: "· ${parts[0]}"),
                                    TextSpan(
                                      text: word,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    TextSpan(
                                      text: parts.length > 1 ? parts[1] : "",
                                    ),
                                  ],
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    height: 1.3.h,
                                    color: backgroundBlackColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                );
                                break;
                              }
                            }

                            return Padding(
                              padding: EdgeInsets.only(bottom: 6.h),
                              child: Text.rich(span),
                            );
                          }),

                          SizedBox(height: 48.h),
                          // 🚗 등록 버튼
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  CarRegistrationStepperScreen(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: brandColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      "다음으로",
                                      style: TextStyle(
                                        color: white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Text(icon, style: TextStyle(fontSize: 16.sp)),
          SizedBox(width: 6.w),
          Text(
            title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
