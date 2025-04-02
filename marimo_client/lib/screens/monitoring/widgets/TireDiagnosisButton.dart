import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/screens/tirediagnosis/TireDiagnosisScreen.dart';
import 'package:marimo_client/providers/obd_polling_provider.dart';
import 'package:marimo_client/utils/obd_response_parser.dart';

class TireDiagnosisButton extends StatelessWidget {
  const TireDiagnosisButton({super.key});

  @override
  Widget build(BuildContext context) {
    final responses = context.watch<ObdPollingProvider>().responses;
    final parsed = parseObdResponses(responses);
    final distance = parsed.distanceSinceCodesCleared;

    final formattedDistance =
        distance != null
            ? NumberFormat.decimalPattern().format(distance)
            : "--";

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const TireDiagnosisScreen(),
            ),
          );
          debugPrint("🚀 AI 진단 받기 클릭!!");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0x1A4888FF),
          foregroundColor: Colors.black,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF4888FF), width: 0.5),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          overlayColor: const Color(0x1A4888FF),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/icons/icon_tire.webp',
                width: 32.w,
                height: 32.h,
              ),
              SizedBox(width: 7.w),
              Expanded(
                child: Text(
                  "마지막 점검 후 $formattedDistance km 주행",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                "AI 진단 받기",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF0E0E0E),
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.chevron_right,
                size: 18.sp,
                color: const Color(0xFF0E0E0E),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
