import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/models/map/Place.dart';
import 'package:marimo_client/screens/map/data/MockData.dart';
import 'package:marimo_client/screens/map/utils/map_utils.dart';
import 'package:marimo_client/screens/map/widgets/PlaceCard.dart';
import 'package:marimo_client/services/map/MapService.dart';
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
  final MapService _mapService = MapService();
  late NaverMapController _mapController; // 지도 컨트롤러
  NMarker? _userLocationMarker; // 현재 위치 마커

  // 필터 상태 저장
  bool _gasStationFilter = false;
  bool _repairFilter = false;
  bool _carWashFilter = false;

  List<Place> _currentPlaces = [];
  List<String> _previousMarkerIds = []; // 지도에 표시된 마커 ID들을 추적 용도
  String? _highlightedPlaceId; // Place.id를 기준으로 관리됨.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Scaffold 구조 추가
      body: Stack(
        children: [
          // 지도 전체를 화면에 채우는 위젯
          Positioned.fill(
            child: NaverMap(
              options: NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: NLatLng(37.5665, 126.9780),
                  zoom: 15,
                ),
                minZoom: 7.0, // ✅ 기본값보다 확대된 줌 설정
                maxZoom: 18.0,
                extent: NLatLngBounds(
                  southWest: NLatLng(33.0, 124.0),
                  northEast: NLatLng(39.5, 131.0),
                ),
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

                  // 지도 내장된 현재 위치 오버레이 (파란 점)
                  _mapService.setCurrentLocationOverlay(
                    controller: _mapController,
                    position: currentLatLng,
                  );

                  // ✅ 여기 추가: 사용자 위치에 마커 띄우기
                  await _mapService.addCurrentLocationMarker(
                    controller: _mapController,
                    id: 'user_location',
                    position: currentLatLng,
                  );

                  // 이후 필요시 상태 저장
                  _userLocationMarker = NMarker(
                    id: 'user_location',
                    position: currentLatLng,
                  );
                }
              },
              onCameraIdle: () async {
                final position =
                    await _mapController
                        .getCameraPosition(); // ✅ 현재 카메라 위치 가져오기
                final currentTarget = position.target;
                if (!MapUtils.isInsideKorea(currentTarget)) {
                  await _mapController.updateCamera(
                    NCameraUpdate.scrollAndZoomTo(
                      target: NLatLng(37.5665, 126.9780),
                      zoom: position.zoom,
                    ),
                  );
                }
              },
            ),
          ),

          // 하단 정보 카드
          Positioned(
            bottom: 110, // 70 (하단바 높이) + 20 (하단 margin) + 20 (카드 위 간격)
            left: 0,
            right: 0,
            child: _buildStationCard(),
          ),

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

                // 필터 이동 버튼
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
                  onTap: () => _onCategoryTap('gas'),
                ),
                const SizedBox(width: 8),
                RepairIcon(
                  isActive: _repairFilter,
                  onTap: () => _onCategoryTap('repair'),
                ),
                const SizedBox(width: 8),
                CarWashIcon(
                  isActive: _carWashFilter,
                  onTap: () => _onCategoryTap('carwash'),
                ),
              ],
            ),
          ),
        ],
      ),
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

    // 기존 마커들 제거 (카테고리 필터 마커들)
    await _mapService.removeMarkersByIds(
      controller: _mapController,
      ids: _previousMarkerIds,
    );

    // UI 상태 초기화 (카드 제거, 선택 상태 초기화)
    setState(() {
      _currentPlaces = [];
      _highlightedPlaceId = null;
      _previousMarkerIds = [];
      _gasStationFilter = false;
      _repairFilter = false;
      _carWashFilter = false;
    });

    // 기존 사용자 위치 마커 제거
    if (_userLocationMarker != null) {
      await _mapService.removeMarker(
        controller: _mapController,
        id: 'user_location',
      );
    }

    // 새 사용자 위치 마커 추가
    await _mapService.addCurrentLocationMarker(
      controller: _mapController,
      id: 'user_location',
      position: currentLatLng,
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
      isScrollControlled: true, // 이게 있어야 반드시 height가 반영됨
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const FilterBottomSheet(),
    );
  }

  Future<void> _onCategoryTap(String type) async {
    await _mapService.removeMarkersByIds(
      controller: _mapController,
      ids: _previousMarkerIds,
    );

    final filtered = mockPlaces.where((p) => p.type == type).take(3).toList();

    setState(() {
      _gasStationFilter = type == 'gas';
      _repairFilter = type == 'repair';
      _carWashFilter = type == 'carwash';
      _currentPlaces = filtered;
      _highlightedPlaceId = null;
      _previousMarkerIds = filtered.map((e) => e.id).toList();
    });

    await _mapService.addPlaceMarkers(
      controller: _mapController,
      places: _currentPlaces,
      onMarkerTap: _onMarkerTapped, // ✅ 클릭 시 호출될 함수
    );

    await Future.delayed(const Duration(milliseconds: 300));

    await _mapService.centerMarkersWithZoom(
      controller: _mapController,
      places: _currentPlaces,
    );
  }

  void _onMarkerTapped(String markerId) async {
    final tappedPlace = _currentPlaces.firstWhere((p) => p.id == markerId);

    if (_highlightedPlaceId != null && _highlightedPlaceId != markerId) {
      final prev = _currentPlaces.firstWhere(
        (p) => p.id == _highlightedPlaceId,
      );
      await _mapService.resetMarker(controller: _mapController, place: prev);
    }

    await _mapService.highlightMarker(
      controller: _mapController,
      place: tappedPlace,
    );

    setState(() {
      _highlightedPlaceId = markerId;
    });

    await _mapService.moveCamera(
      controller: _mapController,
      target: NLatLng(tappedPlace.lat, tappedPlace.lng),
    );
  }

  /// 주유소 정보 카드
  Widget _buildStationCard() {
    return Visibility(
      visible: _currentPlaces.isNotEmpty,
      child: SizedBox(
        height: 168.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: _currentPlaces.length,
          itemBuilder: (context, index) {
            final place = _currentPlaces[index];
            return PlaceCard(
              place: place,
              isSelected: _highlightedPlaceId == place.id,
              onTap: (position) async {
                if (_highlightedPlaceId != null &&
                    _highlightedPlaceId != place.id) {
                  final prev = _currentPlaces.firstWhere(
                    (p) => p.id == _highlightedPlaceId,
                  );
                  await _mapService.resetMarker(
                    controller: _mapController,
                    place: prev,
                  );
                }

                await _mapService.highlightMarker(
                  controller: _mapController,
                  place: place,
                );

                setState(() {
                  _highlightedPlaceId = place.id;
                });

                await _mapService.moveCamera(
                  controller: _mapController,
                  target: NLatLng(place.lat, place.lng),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
