import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/models/map/Place.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlaceCard extends StatelessWidget {
  final Place place;
  final void Function(NLatLng) onTap;
  final bool isSelected;

  const PlaceCard({
    super.key,
    required this.place,
    required this.onTap,
    this.isSelected = false,
  });

  String getPlaceTypeLabel(String type) {
    switch (type) {
      case 'gas':
        return '휘발유';
      case 'repair':
        return '정비소';
      case 'carwash':
        return '세차장';
      default:
        return '기타';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => onTap(NLatLng(place.lat, place.lng)),
      child: Container(
        width: screenWidth * 0.83,
        height: 112.h,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.blue.shade100,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black12)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ✅ 1순위 + 주유소/정비소/세차장
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '1순위',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
                Text(
                  getPlaceTypeLabel(place.type),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 4),

            /// ✅ 주유소 이름 + 가격 (주유소일 때만)
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
                if (place.type == 'gas')
                  Text(
                    place.price?.toString() ?? '',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 4),

            /// ✅ 평점 + 태그
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(place.rating.toStringAsFixed(1)),
                const SizedBox(width: 6),
                ...place.tags
                    .take(5)
                    .map(
                      (tag) => Container(
                        margin: const EdgeInsets.only(left: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(tag, style: const TextStyle(fontSize: 12)),
                      ),
                    ),
              ],
            ),
            const Spacer(),

            /// ✅ 거리 + 카카오내비 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${place.distance.toStringAsFixed(1)}km',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
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
    );
  }
}
