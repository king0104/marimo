import 'package:flutter/material.dart';
import 'package:marimo_client/commons/CustomCalendar.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:marimo_client/providers/car_registration_provider.dart';
import 'package:marimo_client/screens/signin/widgets/CustomTitleText.dart';
import 'package:marimo_client/theme.dart';

class CarLastInspectionScreen extends StatefulWidget {
  const CarLastInspectionScreen({super.key});

  @override
  State<CarLastInspectionScreen> createState() =>
      _CarLastInspectionScreenState();
}

class _CarLastInspectionScreenState extends State<CarLastInspectionScreen> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<CarRegistrationProvider>(
      context,
      listen: false,
    );
    selectedDate = provider.lastCheckedDate ?? DateTime.now();
  }

  void _openCalendarPopup() async {
    final provider = Provider.of<CarRegistrationProvider>(
      context,
      listen: false,
    );
    await showCustomCalendarPopup(
      context: context,
      initialDate: selectedDate,
      onDateSelected: (newDate) {
        setState(() {
          selectedDate = newDate;
        });
        provider.setLastCheckedDate(newDate);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🔽 키보드 자동 내리기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const CustomTitleText(
              text: "마지막 차량 점검일을 입력해주세요.",
              highlight: "마지막 차량 점검일",
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _openCalendarPopup,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: lightgrayColor, // ← 너가 정의해둔 theme 색상
                    width: 0.5,
                  ),
                ),
                child: Text(
                  "${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
