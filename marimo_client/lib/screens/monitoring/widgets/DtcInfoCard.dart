import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marimo_client/screens/monitoring/widgets/AIDescModal.dart';
import 'package:marimo_client/services/commons/chat_service.dart';
import 'package:marimo_client/theme.dart';

class DtcInfoCard extends StatelessWidget {
  final String code;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const DtcInfoCard({
    super.key,
    required this.code,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (isSelected) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => Center(child: CircularProgressIndicator()),
          );
          try {
            // ChatService 생성 (dotenv에서 API 키를 읽어옴)
            final chatService = ChatService.create();
            final response = await chatService.fetchChatGPTResponse(
              code: code,
              title: "엔진 실화 발생",
            );
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder:
                  (_) => AIDescModal(
                    code: code,
                    title: "엔진 실화 발생",
                    meaningList: response.meaningList,
                    actionList: response.actionList,
                  ),
            );
          } catch (e, stackTrace) {
            // 콘솔에 에러 메시지 및 스택 트레이스 출력
            debugPrint('Error fetching AI diagnosis: $e');
            debugPrint('Stack trace: $stackTrace');
            Navigator.of(context).pop();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("AI 진단 정보를 가져오는데 실패했습니다.")));
          }
        } else {
          onTap();
        }
      },
      child: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 250),
            width: double.infinity,
            height: 80.h,
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.only(
              left: 16.w,
              right: 8.w,
              top: 12.h,
              bottom: 12.h,
            ),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? const Color(0xFFE8F0FF)
                      : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8.r),
              border:
                  isSelected
                      ? Border.all(color: brandColor, width: 0.5.w)
                      : null,
            ),
            child:
                isSelected
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/icons/icon_ai_bot.svg',
                              width: 24.w,
                              height: 24.h,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "빠르게 AI 챗봇으로 알아보기",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: brandColor,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder:
                                  (_) => AIDescModal(
                                    code: code,
                                    title: "엔진 실화 발생",
                                    meaningList: ["불규칙한 실화가 발생했습니다."],
                                    actionList: ["즉시 정비소를 방문하세요."],
                                  ),
                            );
                          },
                          behavior: HitTestBehavior.translucent,
                          child: Container(
                            padding: EdgeInsets.all(12.w),
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              'assets/images/icons/icon_next_brand_16.svg',
                              width: 16.w,
                              height: 16.h,
                            ),
                          ),
                        ),
                      ],
                    )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          code,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300,
                            color: iconColor,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: black,
                          ),
                        ),
                      ],
                    ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SvgPicture.asset(
              isSelected
                  ? 'assets/images/icons/corner_brand_white.svg'
                  : 'assets/images/icons/corner_grey_white.svg',
              width: 16.w,
              height: 16.h,
            ),
          ),
        ],
      ),
    );
  }
}
