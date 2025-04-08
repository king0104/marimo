import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_provider.dart';

class CarImageWidget extends StatelessWidget {
  const CarImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final carProvider = Provider.of<CarProvider>(context);
    final modelName =
        carProvider.cars.isNotEmpty
            ? carProvider.cars.first.modelName ?? ""
            : "";

    // 모델명-이미지 맵핑
    final modelImageMap = {
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
      "프리우스": "assets/images/cars/prius.png",
    };

    final imagePath = modelImageMap[modelName];

    return Container(
      height: 300.h,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (imagePath != null)
            Positioned(
              left: -330.w,
              top: 0,
              bottom: 0,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder:
                    (child, animation) => SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.3, 0), // 오른쪽에서 들어오기
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                child: Image.asset(
                  imagePath,
                  key: ValueKey(imagePath), // 이미지가 바뀔 때 애니메이션 트리거
                  width: 650.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
