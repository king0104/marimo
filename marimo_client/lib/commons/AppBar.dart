// 파일명: lib/commons/common_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/commons/chatbot.dart';
// import 'package:marimo_client/screens/Insurance/InsuranceScreen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marimo_client/theme.dart';

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget? leading;
  const CommonAppBar({super.key, this.leading});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<CommonAppBar> createState() => _CommonAppBarState();
}

class _CommonAppBarState extends State<CommonAppBar> {
  bool isReceiptActive = false;
  bool isMicActive = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      elevation: 0,
      leadingWidth: 70.w,
      leading:
          widget.leading ??
          Padding(
            padding: EdgeInsets.only(left: 0.w, top: 19.h, bottom: 19.h),
            child: SizedBox(
              width: 36.w,
              height: 22.h,
              child: SvgPicture.asset(
                'assets/images/icons/logo_app_bar.svg',
                width: 36.w,
                height: 22.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
      actions: [
        IconButton(
          icon: Image.asset(
            isReceiptActive 
              ? 'assets/images/icons/icons_ai_receipt_on.png'
              : 'assets/images/icons/icons_ai_receipt.png',
            width: 22.w,
            height: 22.w,
          ),
          onPressed: () {
            setState(() {
              isReceiptActive = true;
            });
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => const Chatbot(isReceiptMode: true),
            ).whenComplete(() {
              setState(() {
                isReceiptActive = false;
              });
            });
          },
        ),
        IconButton(
          icon: Image.asset(
            isMicActive 
              ? 'assets/images/icons/icons_ai_mic_on.png'
              : 'assets/images/icons/icons_ai_mic.png',
            width: 22.w,
            height: 22.w,
          ),
          onPressed: () {
            setState(() {
              isMicActive = true;
            });
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => const Chatbot(isReceiptMode: false),
            ).whenComplete(() {
              setState(() {
                isMicActive = false;
              });
            });
          },
        ),
        SizedBox(width: 8.w),
      ],
    );
  }
}
