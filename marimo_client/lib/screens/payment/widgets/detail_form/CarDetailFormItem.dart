// CarDetailFormItem.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marimo_client/theme.dart';

class CarDetailFormItem extends StatelessWidget {
  final String title;
  final String? value;
  final String? hintText;
  final TextEditingController controller;
  final bool isRequired;
  final Function()? onTap;
  final bool showIconRight;
  final int? maxLength;
  final bool isDateField;

  const CarDetailFormItem({
    Key? key,
    required this.title,
    this.value,
    this.hintText,
    required this.controller,
    this.isRequired = false,
    this.onTap,
    this.showIconRight = true,
    this.maxLength,
    this.isDateField = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 메모 필드인지 확인
    final bool isMemoField = title == '메모';

    return Container(
      height: 45.h, // 모든 항목에 동일한 높이 적용
      margin: EdgeInsets.only(bottom: 30.h), // 모든 항목에 일관된 여백 적용
      child: Row(
        children: [
          // 항목 제목 (모든 필드 동일)
          Container(
            width: 60.w, // 제목 영역 고정 너비 설정
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),

          // 메모 필드는 Text 사용, 다른 필드는 TextField 사용
          if (isMemoField)
            // 메모 필드 (터치 가능한 Text 위젯)
            Expanded(
              child: GestureDetector(
                onTap: onTap,
                behavior: HitTestBehavior.opaque, // 전체 영역 터치 가능하게
                child: Container(
                  alignment: Alignment.centerRight, // 내용 수직 중앙 정렬
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // 힌트 텍스트 부분에 충분한 너비 확보
                      Expanded(
                        child: Text(
                          hintText ?? '',
                          textAlign: TextAlign.right,
                          maxLines: 1, // 한 줄로 표시
                          overflow: TextOverflow.ellipsis, // 길이가 넘치면 말줄임표 표시
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Color(0xFF8E8E8E),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      // 오른쪽 화살표 아이콘
                      if (showIconRight)
                        Padding(
                          padding: EdgeInsets.only(left: 8.w),
                          child: SvgPicture.asset(
                            'assets/images/icons/icon_detail.svg',
                            width: 11.w,
                            height: 11.h,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            )
          else
            // 일반 필드 (텍스트 입력 또는 선택 영역)
            Expanded(
              child: GestureDetector(
                onTap: onTap,
                child: AbsorbPointer(
                  absorbing: onTap != null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            hintText: hintText,
                            hintStyle: TextStyle(
                              fontSize: 16.sp,
                              color: Color(0xFF8E8E8E),
                              fontWeight: FontWeight.w300,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          maxLength: maxLength,
                          buildCounter:
                              (
                                _, {
                                required currentLength,
                                required isFocused,
                                maxLength,
                              }) => null,
                          validator:
                              isRequired
                                  ? (value) {
                                    if (value == null || value.isEmpty) {
                                      return '$title을(를) 입력해주세요';
                                    }
                                    return null;
                                  }
                                  : null,
                        ),
                      ),
                      // 날짜 필드인 경우 달력 아이콘 표시
                      if (isDateField)
                        Padding(
                          padding: EdgeInsets.only(left: 4.w),
                          child: SvgPicture.asset(
                            'assets/images/icons/icon_calendar.svg',
                            width: 16.w,
                            height: 16.h,
                          ),
                        ),
                      // 일반 필드의 오른쪽 화살표 아이콘
                      if (showIconRight && !isDateField && !isMemoField)
                        Padding(
                          padding: EdgeInsets.only(left: 4.w),
                          child: SvgPicture.asset(
                            'assets/images/icons/icon_dwon.svg',
                            width: 11.w,
                            height: 11.h,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
