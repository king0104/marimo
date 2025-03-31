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
    // 메모 필드인지 확인 - 메모 필드는 다른 방식으로 처리
    final bool isMemoField = title == '메모';

    return Column(
      children: [
        // 메모 필드인 경우 GestureDetector로 감싸서 터치 이벤트 처리
        isMemoField
            ? GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
                  // 메모 제목
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  // 힌트 텍스트 (메모할 수 있어요...)
                  Text(
                    hintText ?? '',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Color(0xFF8E8E8E),
                      fontWeight: FontWeight.w300,
                    ),
                    overflow: TextOverflow.visible,
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
            )
            : Row(
              children: [
                // 항목 제목
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                // 입력 필드 또는 선택 영역
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
                        ],
                      ),
                    ),
                  ),
                ),
                // 오른쪽 화살표 아이콘 (필요한 경우)
                if (showIconRight && !isDateField)
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
        SizedBox(height: 18.h),
      ],
    );
  }
}
