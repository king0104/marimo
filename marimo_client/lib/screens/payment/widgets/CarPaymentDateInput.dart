// CarPaymentDateInput.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:marimo_client/theme.dart';
import 'package:marimo_client/screens/payment/widgets/CarPaymentCalendar.dart';

class CarPaymentDateInput extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const CarPaymentDateInput({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  void _openCustomCalendar(BuildContext context) {
    showCustomCalendarPopup(
      context: context,
      initialDate: selectedDate,
      onDateSelected: onDateSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openCustomCalendar(context),
      child: Row(
        children: [
          Text(
            DateFormat('yyyy년 M월 d일').format(selectedDate),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 12.w),
          SvgPicture.asset(
            'assets/images/icons/icon_calendar.svg',
            width: 16.w,
            height: 16.w,
          ),
        ],
      ),
    );
  }
}
