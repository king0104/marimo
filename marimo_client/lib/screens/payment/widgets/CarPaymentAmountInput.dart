// CarPaymentAmountInput.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:marimo_client/theme.dart';

class CarPaymentAmountInput extends StatefulWidget {
  const CarPaymentAmountInput({super.key});

  @override
  State<CarPaymentAmountInput> createState() => _CarPaymentAmountInputState();
}

class _CarPaymentAmountInputState extends State<CarPaymentAmountInput> {
  String input = '';
  int? tappedIndex;

  void _onPressed(String value, int index) {
    setState(() {
      tappedIndex = index;

      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() => tappedIndex = null);
      });

      if (value == '<') {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      } else {
        // ✅ 자릿수 제한: 최대 15자리까지만 입력 허용
        final nextInput = input + value;
        final numericInput = nextInput.replaceAll(RegExp(r'[^0-9]'), '');
        if (numericInput.length <= 15) {
          input = nextInput;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '00',
      '0',
      '<',
    ];

    return Column(
      children: [
        Center(
          child:
              input.isEmpty
                  ? Text(
                    '얼마를 쓰셨나요?',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFCECECE),
                    ),
                  )
                  : Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        NumberFormat('###,###,###').format(
                          int.tryParse(
                                input.replaceAll(RegExp(r'[^0-9]'), ''),
                              ) ??
                              0,
                        ),
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Padding(
                        padding: EdgeInsets.only(),
                        child: Text(
                          '원',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
        ),
        const Spacer(),

        if (input.isNotEmpty)
          Container(
            height: 50.h,
            width: double.infinity,
            color: brandColor,
            alignment: Alignment.center,
            child: Text(
              '다음',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

        Container(
          color: Colors.white,
          height: 274.h,
          width: double.infinity,
          child: Column(
            children: List.generate(4, (row) {
              return Expanded(
                child: Row(
                  children: List.generate(3, (col) {
                    int index = row * 3 + col;
                    String label = buttons[index];
                    bool isTapped = tappedIndex == index;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _onPressed(label, index),
                        behavior: HitTestBehavior.opaque,
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: isTapped ? 1 : 0,
                                child: ImageFiltered(
                                  imageFilter: ImageFilter.blur(
                                    sigmaX: 12,
                                    sigmaY: 12,
                                  ),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 44.w,
                                    height: 44.w,
                                    decoration: BoxDecoration(
                                      color: brandColor.withOpacity(0.4),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                              label == '<'
                                  ? Icon(Icons.backspace_outlined, size: 22.sp)
                                  : Text(
                                    label,
                                    style: TextStyle(
                                      fontSize: 26.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
