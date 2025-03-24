import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      elevation: 0,
      leadingWidth: 70.w,
      leading: Padding(
        padding: EdgeInsets.only(left: 0.w),
        child: Image.asset(
          'assets/images/logo/marimo_logo.png',
          width: 30.w,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.mic, size: 24.w),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.notifications, size: 24.w),
          onPressed: () {},
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}