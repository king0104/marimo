import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marimo_client/theme.dart';

class ObdSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;

  const ObdSearchBar({
    super.key,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      height: 45.h,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(49.r),
        border: Border.all(color: lightgrayColor, width: 0.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onChanged,
              cursorColor: brandColor,
              style: TextStyle(
                color: black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: lightgrayColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w300,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
          SvgPicture.asset(
            'assets/images/icons/icon_search_24_grey.svg',
            width: 22.w,
            height: 22.h,
          ),
        ],
      ),
    );
  }
}
