import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.all(12.w),
        child: Image.asset(
          'assets/images/logo/marimo_logo.png',
          width: 24.w,
          height: 24.w,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.mic, size: 24.w),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.notifications_outlined, size: 24.w),
          onPressed: () {},
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}