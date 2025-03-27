// CarPaymentCalendar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showCustomCalendarPopup({
  required BuildContext context,
  required DateTime initialDate,
  required Function(DateTime) onDateSelected,
}) async {
  OverlayEntry? overlayEntry;

  void removePopup() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  DateTime selectedDate = initialDate;

  overlayEntry = OverlayEntry(
    builder:
        (context) => GestureDetector(
          onTap: removePopup,
          behavior: HitTestBehavior.translucent,
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                width: 320.w,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9.41.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CalendarDatePicker(
                      initialDate: selectedDate,
                      firstDate: DateTime(1990),
                      lastDate: DateTime(2101),
                      onDateChanged: (picked) => selectedDate = picked,
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // ✅ 닫기 버튼 - 테두리 없는 흰 배경
                        TextButton(
                          onPressed: removePopup,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 10.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: const Text('닫기'),
                        ),
                        SizedBox(width: 8.w),
                        // ✅ 확인 버튼 - 검정 배경
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 10.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onPressed: () {
                            onDateSelected(selectedDate);
                            removePopup();
                          },
                          child: const Text('확인'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
  );

  Overlay.of(context).insert(overlayEntry!);
}
