import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/obd_polling_provider.dart';
import 'package:marimo_client/utils/obd_response_parser.dart';

class CarStatusWidget extends StatelessWidget {
  const CarStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final responses = context.watch<ObdPollingProvider>().responses;
    final data = parseObdResponses(responses);
    print('📊 현재 상태 데이터:');
    print('   distance: ${data.distanceSinceCodesCleared}');
    print('   rpm: ${data.rpm}');
    print('   maf: ${data.maf}');
    print('   fuel: ${data.fuelLevel}');

    final lastPollingTime =
        context.watch<ObdPollingProvider>().lastSuccessfulPollingTime;

    final formattedDate =
        lastPollingTime != null
            ? DateFormat('yyyy. M. d').format(lastPollingTime.toLocal())
            : '';

    final List<Map<String, dynamic>> statusData = [
      {
        'icon': 'icon_tacometer.png',
        'label': '총 주행거리',
        'value':
            data.distanceSinceCodesCleared != null
                ? NumberFormat.decimalPattern().format(
                  data.distanceSinceCodesCleared,
                )
                : '--',
        'unit': 'km',
      },
      {
        'icon': 'icon_car.png',
        'label': '마력',
        'value':
            (data.rpm != null && data.maf != null)
                ? ((data.maf! * data.rpm!) / 5652).toStringAsFixed(1)
                : '--',
        'unit': 'HP',
      },

      {
        'icon': 'icon_gas.png',
        'label': '연료',
        'value':
            data.fuelLevel != null ? data.fuelLevel!.toStringAsFixed(1) : '--',
        'unit': '%',
        'isFuel': true,
        'fuelPercentage': data.fuelLevel != null ? data.fuelLevel! / 100 : 0.0,
      },
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              formattedDate,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.grey, width: 1.w),
              ),
              child: Text(
                formattedDate.isEmpty ? 'OBD2 연결 전' : '업데이트됨',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
            ),
            SizedBox(width: 10.w),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
              statusData.map((data) {
                return SizedBox(
                  width: 100.w,
                  child: _buildStatusCard(
                    icon:
                        data['isFuel'] == true
                            ? _buildFuelGauge(data['fuelPercentage'] ?? 0.0)
                            : Image.asset(
                              'assets/images/icons/${data['icon']}',
                              width: 24.sp,
                            ),
                    label: data['label'],
                    value: data['value'],
                    unit: data['unit'],
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildFuelGauge(double fuelPercentage) {
    return SizedBox(
      width: 52.w,
      height: 25.h,
      child: Stack(
        children: [
          Container(
            width: 50.w,
            height: 30.w,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          Positioned(
            left: 3,
            top: 3,
            bottom: 3,
            child: Container(
              width: fuelPercentage * 44.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors:
                      fuelPercentage < 0.33
                          ? [Colors.red.withOpacity(0.7), Colors.red]
                          : fuelPercentage < 0.66
                          ? [Colors.orange.withOpacity(0.7), Colors.orange]
                          : [const Color(0xFF9DBFFF), const Color(0xFF4888FF)],
                ),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          Positioned(
            right: 0.w,
            top: 8.h,
            child: Container(
              width: 3.w,
              height: 10.h,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(1.r),
                  bottomRight: Radius.circular(1.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard({
    required Widget icon,
    required String label,
    required String value,
    required String unit,
  }) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30.h,
            child: Align(alignment: Alignment.centerLeft, child: icon),
          ),
          SizedBox(height: 30.h),
          Text(label, style: TextStyle(fontSize: 11.sp, color: Colors.black)),
          SizedBox(height: 2.h),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 2.w),
              Text(
                unit,
                style: TextStyle(fontSize: 11.sp, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
