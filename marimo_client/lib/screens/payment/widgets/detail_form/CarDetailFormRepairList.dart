// CarDetailFormRepairList.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marimo_client/commons/CustomAppHeader.dart';

class CarDetailFormRepairList extends StatelessWidget {
  final String selectedItem;
  final List<String> repairItems;
  final Function(String) onItemSelected;

  const CarDetailFormRepairList({
    Key? key,
    required this.selectedItem,
    required this.repairItems,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppHeader(
            title: '목록',
            onBackPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              itemCount: repairItems.length,
              separatorBuilder:
                  (_, __) =>
                      Divider(height: 1.h, color: const Color(0xFFDBDBDB)),
              itemBuilder: (context, index) {
                final item = repairItems[index];
                final isSelected = item == selectedItem;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    item,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  trailing:
                      isSelected
                          ? SvgPicture.asset(
                            'assets/images/icons/icon_check.svg',
                            width: 20.w,
                            height: 20.h,
                          )
                          : null,
                  onTap: () {
                    onItemSelected(item);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
