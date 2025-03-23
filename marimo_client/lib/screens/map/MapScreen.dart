import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final List<Map<String, dynamic>> gasStations = [
    {"name": "GS 칼텍스 방이점", "lat": 37.5153, "lng": 127.1059},
    {"name": "해뜨는 주유소", "lat": 37.5124, "lng": 127.1023},
  ];

  late NaverMapController _mapController;

  // 필터 상태
  bool _gasStationFilter = false;
  bool _repairFilter = false;
  bool _carWashFilter = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// 🗺 지도
        Positioned.fill(
          child: NaverMap(
            options: NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                target: NLatLng(
                  gasStations.first['lat'],
                  gasStations.first['lng'],
                ),
                zoom: 15,
              ),
              mapType: NMapType.basic,
              locationButtonEnable: false, // 위치 버튼 비활성화
            ),
            onMapReady: (controller) {
              _mapController = controller;
              for (var station in gasStations) {
                final marker = NMarker(
                  id: station['name'],
                  position: NLatLng(station['lat'], station['lng']),
                );
                controller.addOverlay(marker);
              }
            },
          ),
        ),

        /// 🧾 마커 정보 카드
        Positioned(
          left: 16,
          right: 16,
          bottom: 20, // 하단바 높이보다 위로
          child: _buildStationCard(),
        ),

        /// 현위치 버튼 (지도 우측 상단)
        Positioned(
          top: 16,
          right: 16,
          child: Column(
            children: [
              FloatingActionButton(
                mini: true,
                elevation: 4.0,
                backgroundColor: Colors.white,
                onPressed: _moveToCurrentLocation,
                child: const Icon(Icons.my_location, color: Colors.black),
              ),
              const SizedBox(height: 8), // 버튼 간 간격
              /// 🎛 필터 버튼 추가
              FloatingActionButton(
                mini: true,
                elevation: 4.0,
                backgroundColor: Colors.white,
                onPressed: _onFilterPressed,
                child: const Icon(
                  Icons.filter_alt_outlined,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),

        /// 필터 아이콘들 (왼쪽 상단)
        Positioned(
          top: 16,
          left: 16,
          child: Row(
            children: [
              _buildFilterIcon(
                icon: Icons.local_gas_station,
                isActive: _gasStationFilter,
                onTap:
                    () =>
                        setState(() => _gasStationFilter = !_gasStationFilter),
              ),
              const SizedBox(width: 8),
              _buildFilterIcon(
                icon: Icons.build,
                isActive: _repairFilter,
                onTap: () => setState(() => _repairFilter = !_repairFilter),
              ),
              const SizedBox(width: 12),
              _buildFilterIcon(
                icon: Icons.cleaning_services,
                isActive: _carWashFilter,
                onTap: () => setState(() => _carWashFilter = !_carWashFilter),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 현재 위치로 이동
  void _moveToCurrentLocation() async {
    // 위치 권한, 실제 위치 가져오기 로직은 생략 (추가 가능)
    // 예시: 임시 위치
    final currentLatLng = NLatLng(37.5143, 127.1045); // 예: 석촌호수 근처

    await _mapController.updateCamera(
      NCameraUpdate.withParams(target: currentLatLng, zoom: 15),
    );
  }

  /// 필터 바텀시트
  void _onFilterPressed() {
    // TODO: 필터 다이얼로그, 바텀시트 등 띄우기
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => SizedBox(
            height: 300,
            child: Center(
              child: Text(
                '필터 기능은 여기에 표시됩니다.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
    );
  }

  /// 마커 정보 카드
  Widget _buildStationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:
            gasStations.map((station) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.local_gas_station, color: Colors.grey[700]),
                    const SizedBox(width: 8),
                    Text(
                      station['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  /// 좌측 상단 필터 아이콘 버튼
  Widget _buildFilterIcon({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(12), // FloatingActionButton과 동일
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Colors.black12,
              offset: Offset(0, 1),
            ),
          ],
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Icon(
            icon,
            color: isActive ? Colors.white : Colors.black,
            size: 24,
          ),
        ),
      ),
    );
  }
}
