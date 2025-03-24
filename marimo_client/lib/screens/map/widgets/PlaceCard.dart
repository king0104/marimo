import 'package:flutter/material.dart';
import 'package:marimo_client/models/map/Place.dart';
import 'package:marimo_client/screens/map/data/MockData.dart';

class PlaceCard extends StatelessWidget {
  final Place place;

  const PlaceCard({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth, // 화면 전체 너비
      margin: const EdgeInsets.only(right: 12), // 스크롤 간격
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
        boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '1순위',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const Text('휘발유', style: TextStyle(color: Colors.grey)),
            ],
          ),

          const SizedBox(height: 8),
          Text(
            place.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(place.rating.toStringAsFixed(1)),
              const SizedBox(width: 6),
              ...place.tags
                  .take(4)
                  .map(
                    (tag) => Container(
                      margin: const EdgeInsets.only(right: 6),
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
                  )
                  .toList(),
            ],
          ),

          const SizedBox(height: 12),
          Text(
            '${place.distance.toStringAsFixed(1)}km',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            icon: const Icon(Icons.navigation, size: 18),
            label: const Text('카카오내비'),
          ),
        ],
      ),
    );
  }
}
