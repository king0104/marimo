// CategoryAndAmount.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/commons/icons/OilIcon.dart';
import 'package:marimo_client/commons/icons/RepairIcon.dart';
import 'package:marimo_client/commons/icons/WashIcon.dart';
import 'package:marimo_client/commons/CustomNumberPad.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';

class CategoryAndAmount extends StatefulWidget {
  final String category;
  final int amount;
  final bool isEditMode;

  const CategoryAndAmount({
    Key? key,
    required this.category,
    required this.amount,
    this.isEditMode = true,
  }) : super(key: key);

  @override
  State<CategoryAndAmount> createState() => _CategoryAndAmountState();
}

class _CategoryAndAmountState extends State<CategoryAndAmount> {
  late int _amount;
  int? _tappedIndex;

  @override
  void initState() {
    super.initState();
    _amount = widget.amount;
  }

  // 키패드 입력 처리 함수
  void _handleAmountChange(String value, int index) {
    setState(() {
      _tappedIndex = index;

      // ✅ 200ms 후 애니메이션 초기화
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() {
            _tappedIndex = null;
          });
        }
      });

      String current = _amount.toString();
      if (value == '<') {
        if (current.isNotEmpty) {
          current = current.substring(0, current.length - 1);
        }
      } else {
        current += value;
      }

      final numeric = current.replaceAll(RegExp(r'[^0-9]'), '');
      if (numeric.isNotEmpty && numeric.length <= 10) {
        _amount = int.parse(numeric);
        Provider.of<CarPaymentProvider>(
          context,
          listen: false,
        ).setSelectedAmount(_amount); // ✅ Provider에 반영
      } else if (numeric.isEmpty) {
        _amount = 0;
      }
    });
  }

  void _showNumberPad() {
    if (!widget.isEditMode) return; // ✅ 편집 불가 시 리턴

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (_, anim, __, child) {
        // ✅ 애니메이션 효과 추가
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        );
      },
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: Colors.transparent,
            child: CustomNumberPad(
              key: ValueKey(_tappedIndex),
              input: _amount.toString(),
              tappedIndex: _tappedIndex,
              onPressed: _handleAmountChange,
            ),
          ),
        );
      },
    );
  }

  // 카테고리에 따른 아이콘 반환
  Widget _getCategoryIcon() {
    switch (widget.category) {
      case '주유':
        return const OilIcon(size: 44);
      case '정비':
        return const RepairIcon(size: 44);
      case '세차':
        return const WashIcon(size: 44);
      default:
        return const SizedBox(); // 기본값
    }
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');

    // // ✅ Provider 값 출력
    // final providerAmount =
    //     Provider.of<CarPaymentProvider>(context).selectedAmount;
    // print('[CategoryAndAmount] provider.selectedAmount: $providerAmount');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 카테고리 아이콘과 텍스트는 원래 위치에 유지
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // 카테고리 아이콘
                _getCategoryIcon(),
                SizedBox(width: 12.w),

                // 카테고리 텍스트
                Text(
                  widget.category,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),

        Spacer(),

        // 금액 표시 (오른쪽 여백 50, 위 여백 60)
        Padding(
          padding: EdgeInsets.only(top: 44.h),
          child: GestureDetector(
            onTap: _showNumberPad,
            child: Row(
              children: [
                Text(
                  numberFormat.format(_amount),
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  '원',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
