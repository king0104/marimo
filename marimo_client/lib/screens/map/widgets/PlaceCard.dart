import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/models/map/gas_station_place.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        width: screenWidth * 0.83,
        height: 112.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border:
              isSelected
                  ? Border.all(color: Colors.blue, width: 2)
                  : Border.all(color: Colors.transparent, width: 0),
          boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black12)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ 1순위
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${rank}순위',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),

                // 오른쪽: 연료 종류
                Text(
                  place.oilType ?? '휘발유', // null-safe 기본값
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
                  place.price?.toString() ?? '',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

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
}
