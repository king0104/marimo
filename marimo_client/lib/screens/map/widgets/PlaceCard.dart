import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/models/map/gas_station_place.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class PlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback onTap;
  final bool isSelected;
  final double screenWidth;
  final int rank;

  const PlaceCard({
    super.key,
    required this.place,
    required this.onTap,
    required this.screenWidth,
    this.isSelected = false,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(12),
            width: screenWidth * 0.83,
            constraints: BoxConstraints(minHeight: 160.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border:
                  isSelected
                      ? Border.all(color: Colors.blue, width: 2)
                      : Border.all(color: Colors.transparent, width: 0),
              boxShadow: const [
                BoxShadow(blurRadius: 4, color: Colors.black12),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ 변경됨: 1순위 + 상태라벨 + 연료종류
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 왼쪽: 순위 + 상태 라벨
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${rank}순위',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (_getStatusLabel(place) != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.black,
                                width: 0.4,
                              ),
                            ),
                            child: Text(
                              _getStatusLabel(place)!,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Text(
                      place.oilType ?? '일반 휘발유',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // ✅ 주유소 이름 + 가격
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        place.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${place.discountedPrice}원',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // ✅ 부가 정보 태그 + 취소선 가격 (한 줄에 정렬)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 왼쪽: 부가 정보 태그들
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          if (place.hasSelfService) _buildTag("셀프"),
                          if (place.hasCarWash) _buildTag("세차"),
                          if (place.hasMaintenance) _buildTag("경정비"),
                          if (place.hasCvs) _buildTag("편의점"),
                          _buildTag("24시"),
                        ],
                      ),
                    ),

                    // 오른쪽: 취소선 가격 텍스트
                    if (place.isOilCardRegistered &&
                        place
                            .isOilCardMonthlyRequirementSatisfied) // place.price != place.discountedPrice
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          '${place.price}원',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                  ],
                ),

                const Spacer(),

                // ✅ 거리 + 카카오내비 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${place.distance.toStringAsFixed(1)}m',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final destination = Location(
                          name: _sanitizeName(place.name),
                          x: place.lng.toString(),
                          y: place.lat.toString(),
                        );

                        print(
                          '📍 [카카오내비 요청] name: ${destination.name}, x: ${destination.x}, y: ${destination.y}',
                        );

                        if (await NaviApi.instance.isKakaoNaviInstalled()) {
                          await NaviApi.instance.navigate(
                            destination: destination,
                            option: NaviOption(coordType: CoordType.wgs84),
                          );
                        } else {
                          launchBrowserTab(Uri.parse(NaviApi.webNaviInstall));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                      ),
                      icon: SvgPicture.asset(
                        'assets/images/icons/icon_kakaoNavi.svg',
                        height: 20,
                      ),
                      label: const Text(
                        '카카오내비',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF4B5563),
        ),
      ),
    );
  }

  // ✅ 추가됨: 카드 상태 텍스트 반환 함수
  String? _getStatusLabel(Place place) {
    if (!place.isOilCardRegistered) return '카드 미등록';
    if (!place.isOilCardMonthlyRequirementSatisfied) return '전월 실적 부족';
    return null;
  }

  // ✅ 추가됨: 목적지 이름에서 특수문자 제거
  String _sanitizeName(String name) {
    return name.replaceAll(RegExp(r'[^\uAC00-\uD7A3a-zA-Z0-9\s]'), '').trim();
  }
}
