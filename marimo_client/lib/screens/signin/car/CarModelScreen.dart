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
    final selectedBrand = provider.brand;

    final Map<String, String> kiaModelImageMap = {
      "모닝": "assets/images/cars/morning.png",
      "레이": "assets/images/cars/ray.png",
      "K3": "assets/images/cars/k3.png",
      "K5": "assets/images/cars/k5.png",
      "K7": "assets/images/cars/k7.png",
      "K9": "assets/images/cars/k9.png",
      "셀토스": "assets/images/cars/seltos.png",
      "니로": "assets/images/cars/niro.png",
      "스포티지": "assets/images/cars/sportage.png",
      "쏘렌토": "assets/images/cars/sorento.png",
      "모하비": "assets/images/cars/mohave.png",
    };

    final Map<String, String> hyundaiModelImageMap = {
      "아반떼": "assets/images/cars/avante.png",
      "쏘나타": "assets/images/cars/sonata.png",
      "그랜저": "assets/images/cars/grandeur.png",
      "에쿠스": "assets/images/cars/equus.png",
      "제네시스": "assets/images/cars/genesis.png",
      "베뉴": "assets/images/cars/venue.png",
      "코나": "assets/images/cars/kona.png",
      "투싼": "assets/images/cars/tucson.png",
      "산타페": "assets/images/cars/santafe.png",
      "팰리세이드": "assets/images/cars/palisade.png",
    };

    Map<String, String> getModelImageMapByBrand(String? brand) {
      switch (brand) {
        case "현대":
          return hyundaiModelImageMap;
        case "기아":
          return kiaModelImageMap;
        default:
          return {};
      }
    }

    final modelImageMap = getModelImageMapByBrand(selectedBrand);
    final String? imagePath = modelImageMap[selectedModel];

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              if (imagePath != null)
                Positioned(
                  bottom: 0.h,
                  right: -380.w,
                  child: SizedBox(
                    width: 770.w,
                    height: 420.h,
                    child: Opacity(
                      opacity: 0.2,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (
                          Widget child,
                          Animation<double> animation,
                        ) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                        child: Image.asset(
                          imagePath,
                          key: ValueKey(imagePath),
                          fit: BoxFit.contain,
                          alignment: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 40.h),
                        const CustomTitleText(
                          text: "모델을 선택해주세요.",
                          highlight: "모델",
                        ),
                        SizedBox(height: 12.h),
                        CarModelSelector(
                          models: modelImageMap.keys.toList(),
                          initiallySelectedModel: selectedModel,
                          onSelected: (model) {
                            provider.setModelName(model);
                          },
                        ),
                        SizedBox(height: 80.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
