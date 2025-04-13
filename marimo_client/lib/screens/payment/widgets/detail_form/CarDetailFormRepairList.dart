import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marimo_client/commons/CustomAppHeader.dart';
import 'package:marimo_client/theme.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';

class CarDetailFormRepairList extends StatelessWidget {
  final List<String> repairItems;

  const CarDetailFormRepairList({Key? key, required this.repairItems})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarPaymentProvider>();
    final selectedItems = provider.selectedRepairItems;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 60.h,
              child: Stack(
                children: [
                  CustomAppHeader(
                    title: '목록',
                    onBackPressed: () => Navigator.pop(context),
                  ),
                  Positioned(
                    right: 16.w,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          '완료',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 리스트
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                itemCount: repairItems.length,
                separatorBuilder:
                    (_, __) => Divider(
                      height: 1.h,
                      thickness: 1.h,
                      color: lightgrayColor,
                    ),
                itemBuilder: (context, index) {
                  final item = repairItems[index];
                  final isSelected = selectedItems.contains(item);
                  return Container(
                    height: 60.h,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: GestureDetector(
                      onTap: () {
                        context.read<CarPaymentProvider>().toggleRepairItem(
                          item,
                        );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            item,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          if (isSelected)
                            SvgPicture.asset(
                              'assets/images/icons/icon_check.svg',
                              width: 20.w,
                              height: 20.h,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
