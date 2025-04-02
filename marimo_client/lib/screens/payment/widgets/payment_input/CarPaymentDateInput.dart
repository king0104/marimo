// CarPaymentDateInput.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/theme.dart';
import 'package:marimo_client/commons/CustomCalendar.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';

class CarPaymentDateInput extends StatefulWidget {
  const CarPaymentDateInput({super.key});

  @override
  State<CarPaymentDateInput> createState() => _CarPaymentDateInputState();
}

class _CarPaymentDateInputState extends State<CarPaymentDateInput> {
  bool _isFirstBuild = true;

  // 세 개의 매개변수를 받도록 수정
  void _openCustomCalendar(
    BuildContext context,
    DateTime initialDate,
    Function(DateTime) onDateSelected,
  ) {
    showCustomCalendarPopup(
      context: context,
      initialDate: initialDate,
      onDateSelected: onDateSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CarPaymentProvider>(
      builder: (context, provider, child) {
        // 첫 빌드 시 오늘 날짜로 초기화
        if (_isFirstBuild) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            provider.setSelectedDate(DateTime.now());
            _isFirstBuild = false;
          });
        }

        final selectedDate = provider.selectedDate;

        return GestureDetector(
          onTap:
              () => _openCustomCalendar(context, selectedDate, (newDate) {
                provider.setSelectedDate(newDate);
              }),
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
      },
    );
  }
}
