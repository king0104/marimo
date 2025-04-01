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
    final bool isMemoField = title == '메모';

    return Container(
      height: 45.h,
      margin: EdgeInsets.only(bottom: 20.h),
      child: Row(
        children: [
          Container(
            width: 60.w,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),

          /// ✅ 메모 필드
          if (isMemoField)
            Expanded(
              child: GestureDetector(
                onTap: onTap,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  alignment: Alignment.centerRight,
                  constraints: BoxConstraints(minHeight: 45.h),
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          right: showIconRight ? 20.w : 0,
                        ),
                        child: Text(
                          controller.text.isNotEmpty
                              ? (controller.text.length > 12
                                  ? '${controller.text.substring(0, 12)}..'
                                  : controller.text)
                              : (hintText ?? '메모할 수 있어요 (최대 100자)'),
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color:
                                controller.text.isNotEmpty
                                    ? Colors.black
                                    : const Color(0xFF8E8E8E),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      if (showIconRight)
                        Positioned(
                          right: 0,
                          child: SvgPicture.asset(
                            'assets/images/icons/icon_detail.svg',
                            width: 6.w,
                            height: 10.h,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            )
          /// ✅ 일반 필드
          else
            Expanded(
              child: GestureDetector(
                onTap: onTap,
                child: AbsorbPointer(
                  absorbing: onTap != null,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          right:
                              (showIconRight && hintText != '장소를 입력하세요')
                                  ? 20.w
                                  : 0,
                        ),
                        child: TextFormField(
                          controller: controller,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            hintText: hintText,
                            hintStyle: TextStyle(
                              fontSize: 16.sp,
                              color: const Color(0xFF8E8E8E),
                              fontWeight: FontWeight.w300,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          maxLength: title == '장소' ? 50 : maxLength,
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
                      if (showIconRight && hintText != '장소를 입력하세요')
                        Positioned(
                          right: 0,
                          child: SvgPicture.asset(
                            isDateField
                                ? 'assets/images/icons/icon_calendar.svg'
                                : 'assets/images/icons/icon_down.svg',
                            width: isDateField ? 14.w : 8.w,
                            height: isDateField ? 14.h : 5.h,
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
