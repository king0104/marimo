// PlusButton.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';
import 'package:marimo_client/models/payment/car_payment_entry.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlusButton extends StatelessWidget {
  const PlusButton({super.key});

  void _showAddEntryDialog(BuildContext context) {
    String selectedCategory = '주유';
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('지출 추가'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  value: selectedCategory,
                  items:
                      ['주유', '정비', '세차']
                          .map(
                            (cat) =>
                                DropdownMenuItem(value: cat, child: Text(cat)),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) selectedCategory = value;
                  },
                ),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(labelText: '금액 입력'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final amount = int.tryParse(controller.text);
                  if (amount != null) {
                    Provider.of<CarPaymentProvider>(
                      context,
                      listen: false,
                    ).addEntry(
                      CarPaymentEntry(
                        category: selectedCategory,
                        amount: amount,
                        date: DateTime.now(),
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('추가'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAddEntryDialog(context),
      child: SizedBox(
        width: 57.w,
        height: 57.h,
        child: Stack(
          alignment: Alignment.center, // 아이콘을 원 안에 중앙 배치
          children: [
            // 파란색 동그라미 배경
            Container(
              width: 64.w,
              height: 64.h,
              decoration: BoxDecoration(
                color: const Color(0xFF4888FF), // 파란색
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0x4D007DFC,
                    ), // #007DFC with 30% opacity → 0x4D = 30% alpha
                    offset: Offset(2.w, 4.h), // X: 2, Y: 4
                    blurRadius: 4.r, // Blur: 9.4
                    spreadRadius: -1.r, // Spread: -1
                  ),
                ],
              ),
            ),

            // 아이콘을 흰색으로 올리기
            SvgPicture.asset(
              'assets/images/icons/icon_plus_white.svg',
              width: 16.84.w, // 아이콘 크기
              height: 16.84.h, // 아이콘 크기
            ),
          ],
        ),
      ),
    );
  }
}
