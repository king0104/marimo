import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_registration_provider.dart';

import 'package:marimo_client/screens/signin/car/CarAdditionalInfoScreen.dart';
import 'package:marimo_client/screens/signin/car/CarBrandScreen.dart';
import 'package:marimo_client/screens/signin/car/CarLastInspectionScreen.dart';
import 'package:marimo_client/screens/signin/car/CarNumberScreen.dart';
import 'package:marimo_client/screens/signin/car/CarVinScreen.dart';
import 'package:marimo_client/screens/signin/car/CarModelScreen.dart';
import 'package:marimo_client/screens/signin/car/CardBrandScreen.dart';
import 'package:marimo_client/screens/signin/car/CardSelectScreen.dart';
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
  bool isCarConfirmed = false;
  late PageController _pageController;

  final List<Widget> _screens = [
    CarNumberScreen(),
    CarVinScreen(),
    CarBrandScreen(),
    CarModelScreen(),
    CarAdditionalInfoScreen(),
    CarLastInspectionScreen(),
    CardBrandScreen(),
    CardSelectScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentStep);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showCarConfirmationSheet() {
    final carNumber =
        Provider.of<CarRegistrationProvider>(
          context,
          listen: false,
        ).plateNumber ??
        '차량번호 미입력';

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
          carNumber: carNumber,
          onConfirmed: () {
            setState(() {
              isCarConfirmed = true;
              _currentStep += 1;
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 0,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: SvgPicture.asset(
                    'assets/images/icons/icon_back.svg', // 실제 아이콘 경로로 수정
                    width: 18,
                    height: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: _screens,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 🔙 이전 버튼
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          _currentStep > 0
                              ? () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
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

                // ➡️ 다음 버튼
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!isCarConfirmed && _currentStep == 0) {
                          _showCarConfirmationSheet();
                        } else if (_currentStep < _screens.length - 1) {
                          setState(() {
                            _currentStep += 1;
                          });
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
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
