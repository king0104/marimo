import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:marimo_client/models/map/Place.dart';
import 'package:marimo_client/screens/map/data/MockData.dart';
import 'package:marimo_client/screens/map/widgets/PlaceCard.dart';
import 'package:marimo_client/services/MapService.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:marimo_client/screens/map/widgets/category/CarWashIcon.dart';
import 'package:marimo_client/screens/map/widgets/category/GasStationIcon.dart';
import 'package:marimo_client/screens/map/widgets/category/RepairIcon.dart';
import 'widgets/FilterIcon.dart';
import 'widgets/FilterBottomSheet.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final List<Map<String, dynamic>> gasStations = [
    {"name": "GS 칼텍스 방이점", "lat": 37.5153, "lng": 127.1059},
    {"name": "해뛰는 주유소", "lat": 37.5124, "lng": 127.1023},
  ];

  final MapService _mapService = MapService();
  late NaverMapController _mapController; // 지도 컨트롤러
  NMarker? _userLocationMarker; // 현재 위치 마커

  // 필터 상태 저장
  bool _gasStationFilter = false;
  bool _repairFilter = false;
  bool _carWashFilter = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 지도 전체를 화면에 채우는 위젯
        Positioned.fill(
          child: NaverMap(
            options: NaverMapViewOptions(
              locationButtonEnable: false,
              initialCameraPosition: NCameraPosition(
                // 일단 기본 위치: 서울시청 (또는 아무 기본값)
                target: NLatLng(37.5665, 126.9780),
                zoom: 15,
              ),
              mapType: NMapType.basic,
            ),
            onMapReady: (controller) async {
              _mapController = controller;

              /// 🔄 지도 준비되면 위치 권한 확인 → 현재 위치로 카메라 이동
              final permissionGranted = await Permission.location.request();
              if (permissionGranted.isGranted) {
                final currentLatLng = await _mapService.fetchCurrentLatLng();

                // 카메라를 현 위치로 이동
                await _mapService.moveCamera(
                  controller: _mapController,
                  target: currentLatLng,
                );

                // 위치 오버레이 설정
                _mapService.setCurrentLocationOverlay(
                  controller: _mapController,
                  position: currentLatLng,
                );
              }

              // 주유소 마커 추가 (서비스 함수 사용)
              await _mapService.addGasStationMarkers(
                controller: _mapController,
                gasStations: gasStations,
              );
            },
          ),
        ),

        // 하단 주유소 정보 카드
        Positioned(bottom: 20, left: 0, right: 0, child: _buildStationCard()),

        /// 현위치 이동, 필터 버튼
        Positioned(
          top: 16,
          right: 16,
          child: Column(
            children: [
              // 현위치로 이동 버튼
              FloatingActionButton(
                mini: true,
                elevation: 4.0,
                backgroundColor: Colors.white,
                onPressed: _moveToCurrentLocation,
                child: const Icon(Icons.my_location, color: Colors.black),
              ),
              const SizedBox(height: 8),

              // 필터 이동 버튼튼
              FloatingActionButton(
                mini: true,
                elevation: 4.0,
                backgroundColor: Colors.white,
                onPressed: _onFilterPressed,
                child: const FilterIcon(),
              ),
            ],
          ),
        ),

        /// 주유소 / 정비소 / 세차장 아이콘
        Positioned(
          top: 16,
          left: 16,
          child: Row(
            children: [
              GasStationIcon(
                isActive: _gasStationFilter,
                onTap:
                    () => setState(() {
                      _gasStationFilter = true;
                      _repairFilter = false;
                      _carWashFilter = false;
                    }),
              ),
              const SizedBox(width: 8),
              RepairIcon(
                isActive: _repairFilter,
                onTap:
                    () => setState(() {
                      _repairFilter = true;
                      _gasStationFilter = false;
                      _carWashFilter = false;
                    }),
              ),
              const SizedBox(width: 12),
              CarWashIcon(
                isActive: _carWashFilter,
                onTap:
                    () => setState(() {
                      _carWashFilter = true;
                      _gasStationFilter = false;
                      _repairFilter = false;
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 현위치로 이동하는 함수
  Future<void> _moveToCurrentLocation() async {
    // 위치 권한 요청
    final permissionGranted = await Permission.location.request();
    if (!permissionGranted.isGranted) {
      if (permissionGranted.isPermanentlyDenied) {
        await openAppSettings(); // 권한이 완전 차단된 경우 설정으로 유도도
      }
      return;
    }

    // 현재 위치 받아오기 (MapService 내부에서 Geolocator 사용)
    final currentLatLng = await _mapService.fetchCurrentLatLng();

    // 기존 마커 삭제
    if (_userLocationMarker != null) {
      await _mapService.removeMarker(
        controller: _mapController,
        id: 'user_location',
      );
    }

    // 현재 위치 마커 추가
    await _mapService.addMarker(
      controller: _mapController,
      id: 'user_location',
      position: currentLatLng,
      caption: 'Your Location',
    );

    // 지도 카메라 현재 위치로 이동
    await _mapService.moveCamera(
      controller: _mapController,
      target: currentLatLng,
    );
  }

  /// 필터 바텀시트 열기
  void _onFilterPressed() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const FilterBottomSheet(),
    );
  }

  /// 주유소 정보 카드
  Widget _buildStationCard() {
    final List<Place> filtered =
        mockPlaces.where((p) {
          if (_gasStationFilter) return p.type == 'gas';
          if (_repairFilter) return p.type == 'repair';
          if (_carWashFilter) return p.type == 'carwash';
          return false;
        }).toList();

    return Visibility(
      visible: _gasStationFilter || _repairFilter || _carWashFilter,
      child: SizedBox(
        height: 200, // <-- 이게 꼭 필요해!
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            return PlaceCard(place: filtered[index]);
          },
        ),
      ),
    );
  }
}
