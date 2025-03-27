// CarMonthlyPayment.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';
import 'package:marimo_client/theme.dart';
import 'package:intl/intl.dart';

class CarMonthlyPayment extends StatelessWidget {
  const CarMonthlyPayment({super.key});

  void _showMonthSelector(BuildContext context) async {
    final provider = context.read<CarPaymentProvider>();

    final selected = await showModalBottomSheet<int>(
      context: context,
      builder:
          (_) => ListView.builder(
            itemCount: 12,
            itemBuilder:
                (_, index) => ListTile(
                  title: Text('${index + 1}월'),
                  onTap: () => Navigator.pop(context, index + 1),
                ),
          ),
    );

    if (selected != null) {
      provider.setSelectedMonth(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarPaymentProvider>();
    final selectedMonth = provider.selectedMonth;
    final total = provider.totalAmountForSelectedMonth;
    final formattedTotal = NumberFormat(
      '###,###,###,###,###,###',
    ).format(total);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _showMonthSelector(context),
          behavior: HitTestBehavior.translucent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$selectedMonth월',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(width: 5.w),
              Container(
                padding: EdgeInsets.all(8.w),
                child: SvgPicture.asset(
                  'assets/images/icons/icon_down.svg',
                  width: 6.32.w,
                  height: 9.19.h,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formattedTotal,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: brandColor,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              '원',
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          '지난 달보다 +11,000원',
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF8E8E8E),
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
