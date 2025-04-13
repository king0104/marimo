// CarPaymentAmountInput.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/theme.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';
import 'package:marimo_client/screens/payment/CarPaymentDetailForm.dart';
import 'package:marimo_client/commons/CustomNumberPad.dart';

class CarPaymentAmountInput extends StatefulWidget {
  const CarPaymentAmountInput({super.key});

  @override
  State<CarPaymentAmountInput> createState() => _CarPaymentAmountInputState();
}

class _CarPaymentAmountInputState extends State<CarPaymentAmountInput> {
  String input = '';
  int? tappedIndex;

  @override
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<CarPaymentProvider>(context);

    if (provider.isFromPlusButton) {
      input = '';
      provider.markAsFromPlusButton(false);
    } else {
      input = provider.selectedAmount.toString();
    }
  }

  void _onPressed(String value, int index) {
    setState(() {
      tappedIndex = index;

      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() => tappedIndex = null);
      });

      final provider = Provider.of<CarPaymentProvider>(context, listen: false);
      String nextInput = provider.selectedAmount.toString();

      if (value == '<') {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      } else {
        // ✅ 자릿수 제한: 최대 10자리까지만 입력 허용
        final nextInput = input + value;
        final numericInput = nextInput.replaceAll(RegExp(r'[^0-9]'), '');
        if (numericInput.length <= 10) {
          input = nextInput;
        }
      }
    });
  }

  // 다음 버튼 처리 함수 추가
  void _onNextPressed() {
    if (input.isEmpty) return;

    // 입력된 금액 변환
    final amount = int.tryParse(input.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    // 카테고리 정보 가져오기
    final provider = Provider.of<CarPaymentProvider>(context, listen: false);
    final selectedCategory = provider.selectedCategory ?? '주유';

    // CarPaymentDetailForm으로 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => CarPaymentDetailForm(
              selectedCategory: selectedCategory,
              amount: amount,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // // ✅ Provider 값 출력
    // final providerAmount =
    //     Provider.of<CarPaymentProvider>(context).selectedAmount;
    // print('[CarPaymentAmountInput] provider.selectedAmount: $providerAmount');

    final provider = Provider.of<CarPaymentProvider>(context);
    // input = provider.selectedAmount.toString(); // ✅ 동기화
    final selectedAmount = provider.selectedAmount;

    final formattedAmount = NumberFormat(
      '###,###,###',
    ).format(int.tryParse(selectedAmount.toString()) ?? 0);

    return Column(
      children: [
        Center(
          child:
              (input.isEmpty ||
                      int.tryParse(input.replaceAll(RegExp(r'[^0-9]'), '')) ==
                          0)
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
          GestureDetector(
            onTap: _onNextPressed, // 다음 버튼 탭 이벤트 처리
            child: Container(
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
          ),

        // ✅ 키패드 부분 CustomNumberPad로 교체
        CustomNumberPad(
          input: input,
          tappedIndex: tappedIndex,
          onPressed: _onPressed,
        ),
      ],
    );
  }
}
