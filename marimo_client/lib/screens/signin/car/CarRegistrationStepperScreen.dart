import 'package:flutter/material.dart';
import 'package:marimo_client/screens/signin/car/CarAdditionalInfoScreen.dart';
import 'package:marimo_client/screens/signin/car/CarBrandScreen.dart';
import 'package:marimo_client/screens/signin/car/CarNumberScreen.dart';
import 'package:marimo_client/screens/signin/car/CarVinScreen.dart';
import 'package:marimo_client/screens/signin/car/CarModelScreen.dart';
import 'package:marimo_client/screens/signin/widgets/car/CarConfirmationSheet.dart';
import 'package:marimo_client/theme.dart';

class CarRegistrationStepperScreen extends StatefulWidget {
  @override
  _CarRegistrationStepperScreenState createState() =>
      _CarRegistrationStepperScreenState();
}

class _CarRegistrationStepperScreenState
    extends State<CarRegistrationStepperScreen> {
  int _currentStep = 0;
  bool isCarConfirmed = false; // 🚗 차량 확인 여부

  // 🚗 각 단계별 화면 리스트
  final List<Widget> _screens = [
    const CarNumberScreen(), // 1단계: 차량 번호 입력
    const CarVinScreen(), // 2단계: 차대 번호 입력
    const CarBrandScreen(), // 3단계: 제조사 선택
    const CarModelScreen(), // 4단계: 자동차 모델 선택
    const CarAdditionalInfoScreen(), // 5단계: 추가 정보 입력
  ];

  // 🔹 바텀 팝업 표시
  void _showCarConfirmationSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      barrierColor: backgroundBlackColor.withAlpha(51),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return CarConfirmationSheet(
          carNumber: "259서8221", // 차량 번호 (실제 데이터와 연결 가능)
          onConfirmed: () {
            setState(() {
              isCarConfirmed = true; // ✅ 차량 확인 완료
              _currentStep += 1;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 🔹 현재 단계 화면
          Expanded(child: _screens[_currentStep]),

          // 🔹 이전 / 다음 버튼
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 🔹 이전 버튼
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          _currentStep > 0
                              ? () {
                                setState(() {
                                  _currentStep -= 1;
                                });
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFBFBFB),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                            color: Color(0xFFBEBFC0),
                            width: 1,
                          ),
                        ),
                      ),
                      child: const Text(
                        "이전으로",
                        style: TextStyle(
                          color: Color(0xFF7E7E7E),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),

                // 🔹 다음 버튼 (팝업 또는 다음 단계로 이동)
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!isCarConfirmed) {
                          _showCarConfirmationSheet(); // ✅ 팝업 표시
                        } else if (_currentStep < _screens.length - 1) {
                          setState(() {
                            _currentStep += 1; // ✅ 다음 단계로 이동
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4888FF),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "다음으로",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
