// CarDetailFormItem.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CarDetailFormItem extends StatelessWidget {
  final String title;
  final String? value;
  final String? hintText;
  final TextEditingController controller;
  final bool isRequired;
  final Function()? onTap;
  final bool showIconRight;
  final int? maxLength;

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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.h),
        Row(
          children: [
            // 항목 제목
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            Spacer(),
            // 입력 필드 또는 선택 영역
            Expanded(
              child: GestureDetector(
                onTap: onTap,
                child: AbsorbPointer(
                  absorbing: onTap != null, // onTap이 있으면 터치 이벤트 흡수
                  child: TextFormField(
                    controller: controller,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey),
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
              ),
            ),
            // 오른쪽 화살표 아이콘 (필요한 경우)
            if (showIconRight)
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: SvgPicture.asset(
                  'assets/images/icons/icon_right.svg',
                  width: 16.w,
                  height: 16.h,
                ),
              ),
          ],
        ),
        SizedBox(height: 16.h),
        Divider(height: 1.h, color: Color(0xFFEEEEEE)),
      ],
    );
  }
}
