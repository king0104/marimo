// RepairshopButton.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/theme.dart';

class RepairshopButton extends StatelessWidget {
  const RepairshopButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // TODO: 정비소 찾기 기능
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '정비소 찾기',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: iconColor,
            ),
          ),
          SizedBox(width: 4.w), // 텍스트와 아이콘 사이 여백
          Image.asset(
            'assets/images/icons/icon_next.png',
            width: 9.w,
            height: 9.w,
          ),
        ],
      ),
    );
  }
}
