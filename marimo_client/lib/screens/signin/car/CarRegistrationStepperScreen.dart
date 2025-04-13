import 'package:flutter/material.dart';
import 'package:marimo_client/main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marimo_client/providers/car_provider.dart';
import 'package:marimo_client/providers/card_provider.dart';
import 'package:marimo_client/providers/member/auth_provider.dart';
import 'package:marimo_client/screens/signin/car/CarNicknameScreen.dart';
import 'package:marimo_client/services/car/car_registration_service.dart';
import 'package:marimo_client/services/card/card_service.dart';
import 'package:marimo_client/services/user/user_service.dart';
import 'package:marimo_client/utils/toast.dart';
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
  String? userName;
  bool isCarConfirmed = false;
  late PageController _pageController;

  List<Widget> get _screens => [
    CarNumberScreen(),
    CarVinScreen(),
    CarBrandScreen(),
    CarModelScreen(),
    CarAdditionalInfoScreen(),
    CarLastInspectionScreen(),
    CardSelectScreen(userName: userName ?? '회원'), // 🔥 이제 userName 접근 가능
    CarNicknameScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentStep);
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final token = context.read<AuthProvider>().accessToken;
    if (token == null) return;
    final name = await UserService.getUserName(accessToken: token);
    setState(() {
      userName = name;
    });
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
          userName: userName ?? '회원',
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
                      onPressed: () async {
                        final isLastStep = _currentStep == _screens.length - 1;
                        final provider =
                            context.read<CarRegistrationProvider>();

                        if (_currentStep == 0 && !isCarConfirmed) {
                          final isValid =
                              context
                                  .read<CarRegistrationProvider>()
                                  .isPlateNumberValid;
                          if (!isValid) {
                            showToast(
                              context,
                              "올바른 차량 번호를 입력해주세요.",
                              icon: Icons.error,
                              type: 'error',
                              position: 'top-down',
                            );
                            return;
                          }
                          _showCarConfirmationSheet(); // ✅ 명의 확인 시트 띄우기
                          return; // ❗시트를 띄우고 여기서 중단
                        }

                        if (_currentStep == 1) {
                          final isValid =
                              context
                                  .read<CarRegistrationProvider>()
                                  .isVinValid;
                          if (!isValid) {
                            showToast(
                              context,
                              "올바른 차대번호를 입력해주세요.",
                              icon: Icons.error,
                              type: 'error',
                              position: 'top-down',
                            );
                            return;
                          }
                        }

                        if (_currentStep == 2 &&
                            (provider.brand?.trim().isEmpty ?? true)) {
                          showToast(
                            context,
                            "제조사를 선택해주세요.",
                            icon: Icons.error,
                            type: 'error',
                            position: 'top-down',
                          );
                          return;
                        }

                        if (_currentStep == 3 &&
                            (provider.modelName?.trim().isEmpty ?? true)) {
                          showToast(
                            context,
                            "모델을 선택해주세요.",
                            icon: Icons.error,
                            type: 'error',
                            position: 'top-down',
                          );
                          return;
                        }

                        if (isLastStep) {
                          try {
                            final provider =
                                Provider.of<CarRegistrationProvider>(
                                  context,
                                  listen: false,
                                );
                            final authProvider = Provider.of<AuthProvider>(
                              context,
                              listen: false,
                            );
                            final carProvider = Provider.of<CarProvider>(
                              context,
                              listen: false,
                            );

                            final token = authProvider.accessToken;
                            if (token == null)
                              throw Exception('AccessToken이 존재하지 않습니다.');

                            // ✅ 선택한 카드 등록
                            final selectedCard =
                                context.read<CardProvider>().selectedCard;
                            if (selectedCard != null) {
                              await CardService.registerUserOilCard(
                                accessToken: token,
                                cardUniqueNo: selectedCard.cardUniqueNo,
                              );
                            }

                            // ✅ 차량 등록 및 carId 받아오기
                            await CarRegistrationService.registerCar(
                              provider: provider,
                              accessToken: token,
                            );

                            // ✅ 서버에서 차량 목록 다시 불러오기
                            await carProvider.fetchCarsFromServer(token);

                            // ✅ 확인 로그
                            print("✅ 현재 차량 개수: ${carProvider.cars.length}");
                            print("✅ 현재 내 차 : ${carProvider.cars}");

                            // ✅ 성공 토스트 or SnackBar
                            showToast(
                              context,
                              "차량 등록이 완료되었습니다!",
                              icon: Icons.check_circle,
                              type: 'success',
                              position: 'top-down',
                            );
                            await Future.delayed(
                              const Duration(milliseconds: 200),
                            );
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const InitialRouter(),
                              ),
                              (route) => false,
                            );
                          } catch (e) {
                            showToast(
                              context,
                              "차량 등록 실패: $e",
                              icon: Icons.error,
                              type: 'error',
                              position: 'top-down',
                            );
                            print("❌ 차량 등록 실패: $e");
                          }
                        } else {
                          setState(() => _currentStep += 1);
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
