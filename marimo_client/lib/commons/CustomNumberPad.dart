// CustomNumberPad.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/theme.dart';

class CustomNumberPad extends StatelessWidget {
  final String input;
  final Function(String value, int index) onPressed;
  final int? tappedIndex;

  const CustomNumberPad({
    Key? key,
    required this.input,
    required this.onPressed,
    this.tappedIndex,
  }) : super(key: key);

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

    return Container(
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
                    onTap: () => onPressed(label, index),
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
    );
  }
}
