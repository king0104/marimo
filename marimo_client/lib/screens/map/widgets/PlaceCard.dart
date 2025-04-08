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
        // ✅ 변경됨: 상태 라벨 표시를 위해 Stack으로 감쌈
        children: [
          // ✅ 기존 카드 UI
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(12),
            width: screenWidth * 0.83,
            height: 160.h,
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
                // ✅ 1순위
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                    // 오른쪽: 연료 종류
                    Text(
                      place
                          .oilType, // 🔄 기존: place.oilType ?? '휘발유' → 불필요한 null-safe 제거
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
                      place.discountedPrice?.toString() ?? '',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // ✅✅ 변경된 부분: 상태 라벨을 Column 안으로 이동시킴
                if (_getStatusLabel(place) != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: Text(
                      _getStatusLabel(place)!,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                // ✅✅ 여기까지가 기존 Stack/Positioned → Column 내부로 옮긴 변경 내용

                // ✅ 부가 정보 태그 영역
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    if (place.hasSelfService) _buildTag("셀프"),
                    if (place.hasCarWash) _buildTag("세차"),
                    if (place.hasMaintenance) _buildTag("경정비"),
                    if (place.hasCvs) _buildTag("편의점"),
                    _buildTag("24시"), // 이건 지금 고정으로 넣었어. 필요하면 조건부로 수정 가능
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
                          name: _sanitizeName(place.name), // 🔄 여기만 바꿈
                          x: place.lng.toString(), // 경도
                          y: place.lat.toString(), // 위도
                        );

                        print(
                          '📍 [카카오내비 요청] name: ${destination.name}, x: ${destination.x}, y: ${destination.y}',
                        );

                        // 카카오내비 설치 여부
                        if (await NaviApi.instance.isKakaoNaviInstalled()) {
                          print('카카오내비 설치 여부 따지고 일단 들어감');
                          await NaviApi.instance.navigate(
                            destination: destination,
                            option: NaviOption(coordType: CoordType.wgs84),
                          );
                        } else {
                          print('카카오내비 미설치');
                          // 카카오내비 설치 페이지로 이동
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
