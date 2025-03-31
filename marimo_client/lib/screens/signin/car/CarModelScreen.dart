import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_registration_provider.dart';
import 'package:marimo_client/screens/signin/widgets/CustomTitleText.dart';
import 'package:marimo_client/screens/signin/widgets/car/CarModelSelector.dart';

class CarModelScreen extends StatelessWidget {
  const CarModelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CarRegistrationProvider>(context);
    final selectedModel = provider.modelName ?? "";

    // ✅ 모델-이미지 매핑
    final Map<String, String> modelImageMap = {
      "팰리세이드": "assets/images/cars/palisade.png",
      "아반떼": "assets/images/cars/avante.png",
      "쏘나타": "assets/images/cars/sonata.png",
      "그랜저": "assets/images/cars/grandeur.png",
      "베뉴": "assets/images/cars/venue.png",
    };

    final String? imagePath = modelImageMap[provider.modelName ?? ""];

    return Scaffold(
      body: Stack(
        children: [
          // ✅ 선택된 모델의 이미지가 있을 때만 배경에 표시
          if (imagePath != null)
            Positioned.fill(
              left: 0,
              right: -330.w,
              top: 0,
              bottom: -40.h,
              child: Opacity(
                opacity: 0.2,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (
                      Widget child,
                      Animation<double> animation,
                    ) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0), // 오른쪽에서 들어옴
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                    child: Image.asset(
                      imagePath ?? '', // 바뀐 이미지
                      key: ValueKey(imagePath), // 이미지 변경 감지용 key 필수!
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
          // ✅ UI 위젯
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),
                const CustomTitleText(text: "모델을 선택해주세요.", highlight: "모델"),
                SizedBox(height: 12.h),
                CarModelSelector(
                  models: modelImageMap.keys.toList(),
                  initiallySelectedModel: selectedModel,
                  onSelected: (model) {
                    provider.setModelName(model);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
