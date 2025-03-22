import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:marimo_client/screens/signin/widgets/car/CarInput.dart';
import 'package:marimo_client/screens/signin/widgets/CustomTitleText.dart';
import 'package:marimo_client/theme.dart';

class CarLastInspectionScreen extends StatefulWidget {
  const CarLastInspectionScreen({super.key});

  @override
  _CarLastInspectionScreenState createState() =>
      _CarLastInspectionScreenState();
}

class _CarLastInspectionScreenState extends State<CarLastInspectionScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            const CustomTitleText(
              text: "마지막 차량 점검일을 입력해주세요.",
              highlight: "마지막 차량 점검일",
            ),
            const SizedBox(height: 51),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(10), // ✅ padding 30
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: black.withAlpha((0.12 * 255).toInt()), // 12% 투명도
                    offset: const Offset(0, 3.14), // X: 0, Y: 3.14
                    blurRadius: 12.55, // Blur: 12.55
                    spreadRadius: 0, // Spread: 0
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TableCalendar(
                    rowHeight: 44,
                    firstDay: DateTime.utc(2000, 1, 1),
                    lastDay: DateTime.utc(2100, 12, 31),
                    focusedDay: selectedDate,
                    calendarFormat: CalendarFormat.month,
                    selectedDayPredicate: (day) {
                      return isSameDay(selectedDate, day);
                    },
                    onDaySelected: (selected, focused) {
                      setState(() {
                        selectedDate = selected;
                      });
                    },
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: black,
                      ),
                      leftChevronIcon: const Icon(
                        Icons.chevron_left,
                        color: black,
                      ),
                      rightChevronIcon: const Icon(
                        Icons.chevron_right,
                        color: Colors.black,
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: brandColor),
                      ),
                      todayTextStyle: const TextStyle(
                        color: black, // ✅ 오늘 날짜도 잘 보이게
                        fontWeight: FontWeight.w500,
                      ),
                      selectedDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: brandColor,
                      ),
                      selectedTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      defaultTextStyle: const TextStyle(color: black),
                      weekendTextStyle: const TextStyle(color: black),
                    ),
                    daysOfWeekHeight: 44,
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(color: Colors.black54),
                      weekendStyle: TextStyle(color: Colors.black54),
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// ✅ 확인 버튼을 컨테이너 안에 넣음
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        print("선택된 날짜: $selectedDate");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("확인"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
