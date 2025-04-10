import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/models/map/repair_shop_place.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class RepairShopCard extends StatelessWidget {
  final RepairShopPlace place;
  final VoidCallback onTap;
  final bool isSelected;
  final double screenWidth;
  final int rank;

  const RepairShopCard({
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
                // 🔧 순위 + 정비소 상태
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
                    Text(
                      place.status,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // 🏪 정비소 이름
                Text(
                  place.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                // 📍 도로명 주소
                Text(
                  place.roadAddress,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                ),

                const Spacer(),

                // 📞 전화번호 + ⏰ 운영시간
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '운영시간 ${place.openTime} ~ ${place.closeTime}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey[800],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final destination = Location(
                          name: _sanitizeName(place.name),
                          x: place.lng.toString(),
                          y: place.lat.toString(),
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

  String _sanitizeName(String name) {
    return name.replaceAll(RegExp(r'[^\uAC00-\uD7A3a-zA-Z0-9\s]'), '').trim();
  }
}
