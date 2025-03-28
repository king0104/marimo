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
import 'package:marimo_client/providers/map_provider.dart';
import 'package:provider/provider.dart';
import 'widgets/FilterIcon.dart';
import 'widgets/FilterBottomSheet.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapService _mapService = MapService();
  NaverMapController? _mapController; // 네이버 지도 컨트롤러 (nullable)
  NMarker? _userLocationMarker; // 사용자 위치 마커

  // 필터 버튼 상태 관리
  bool _gasStationFilter = false;
  bool _repairFilter = false;
  bool _carWashFilter = false;

  List<Place> _currentPlaces = []; // 현재 표시 중인 장소 리스트
  List<String> _previousMarkerIds = []; // 이전 마커 ID 저장 (지우기용)
  String? _highlightedPlaceId; // 선택된 장소 ID

  @override
  void dispose() {
    _mapController?.dispose(); // 지도 컨트롤러 정리 (Surface 해제)
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cachedPosition = context.read<MapStateProvider>().lastKnownPosition;

    return Scaffold(
      // 전체 화면 Stack 구성
      body: Stack(
        children: [
          // 지도 뷰
          Positioned.fill(
            child: NaverMap(
              options: NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target:
                      cachedPosition ??
                      NLatLng(37.5665, 126.9780), // ✅ 캐시된 위치 or 기본 서울
                  zoom: 15,
                ),
                minZoom: 7.0,
                maxZoom: 18.0,
                extent: NLatLngBounds(
                  southWest: NLatLng(33.0, 124.0),
                  northEast: NLatLng(39.5, 131.0),
                ),
              ),
              onMapReady: (controller) async {
                _mapController = controller;

                /// 🔄 위치 권한 요청 및 사용자 위치 표시
                final permissionGranted = await Permission.location.request();
                if (permissionGranted.isGranted) {
                  final currentLatLng = await _mapService.fetchCurrentLatLng();

                  context.read<MapStateProvider>().updatePosition(
                    currentLatLng,
                  );

                  // 카메라 이동
                  await _mapService.moveCamera(
                    controller: _mapController!,
                    target: currentLatLng,
                  );

                  // 내장된 현재 위치 오버레이 (파란 점)
                  _mapService.setCurrentLocationOverlay(
                    controller: _mapController!,
                    position: currentLatLng,
                  );

                  // 사용자 마커 직접 추가
                  await _mapService.addCurrentLocationMarker(
                    controller: _mapController!,
                    id: 'user_location',
                    position: currentLatLng,
                  );

                  _userLocationMarker = NMarker(
                    id: 'user_location',
                    position: currentLatLng,
                  );
                }
              },
              onCameraIdle: () async {
                final position = await _mapController?.getCameraPosition();
                final currentTarget = position?.target;
                if (currentTarget != null &&
                    !MapUtils.isInsideKorea(currentTarget)) {
                  await _mapController?.updateCamera(
                    NCameraUpdate.scrollAndZoomTo(
                      target: NLatLng(37.5665, 126.9780),
                      zoom: position!.zoom,
                    ),
                  );
                }
              },
            ),
          ),

          // 하단 장소 카드 영역
          Positioned(
            bottom: 110,
            left: 0,
            right: 0,
            child: _buildStationCard(),
          ),

          // 우측 상단 버튼들 (현위치, 필터)
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
                const SizedBox(height: 8),
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

          // 좌측 상단 카테고리 아이콘들
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

  /// 현위치 이동 처리 함수
  Future<void> _moveToCurrentLocation() async {
    final permissionGranted = await Permission.location.request();
    if (!permissionGranted.isGranted) {
      if (permissionGranted.isPermanentlyDenied) {
        await openAppSettings();
      }
      return;
    }

    final currentLatLng = await _mapService.fetchCurrentLatLng();

    context.read<MapStateProvider>().updatePosition(currentLatLng);

    await _mapService.removeMarkersByIds(
      controller: _mapController!,
      ids: _previousMarkerIds,
    );

    setState(() {
      _currentPlaces = [];
      _highlightedPlaceId = null;
      _previousMarkerIds = [];
      _gasStationFilter = false;
      _repairFilter = false;
      _carWashFilter = false;
    });

    if (_userLocationMarker != null) {
      await _mapService.removeMarker(
        controller: _mapController!,
        id: 'user_location',
      );
    }

    await _mapService.addCurrentLocationMarker(
      controller: _mapController!,
      id: 'user_location',
      position: currentLatLng,
    );

    await _mapService.moveCamera(
      controller: _mapController!,
      target: currentLatLng,
    );
  }

  /// 필터 바텀시트 호출
  void _onFilterPressed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const FilterBottomSheet(),
    );
  }

  /// 카테고리 선택 시 마커 생성
  Future<void> _onCategoryTap(String type) async {
    await _mapService.removeMarkersByIds(
      controller: _mapController!,
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
      controller: _mapController!,
      places: _currentPlaces,
      onMarkerTap: _onMarkerTapped,
    );

    await Future.delayed(const Duration(milliseconds: 300));

    await _mapService.centerMarkersWithZoom(
      controller: _mapController!,
      places: _currentPlaces,
    );
  }

  /// 마커 탭 시 강조 처리
  void _onMarkerTapped(String markerId) async {
    final tappedPlace = _currentPlaces.firstWhere((p) => p.id == markerId);

    if (_highlightedPlaceId != null && _highlightedPlaceId != markerId) {
      final prev = _currentPlaces.firstWhere(
        (p) => p.id == _highlightedPlaceId,
      );
      await _mapService.resetMarker(controller: _mapController!, place: prev);
    }

    await _mapService.highlightMarker(
      controller: _mapController!,
      place: tappedPlace,
    );

    setState(() {
      _highlightedPlaceId = markerId;
    });

    await _mapService.moveCamera(
      controller: _mapController!,
      target: NLatLng(tappedPlace.lat, tappedPlace.lng),
    );
  }

  /// 하단 장소 카드 렌더링
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
                    controller: _mapController!,
                    place: prev,
                  );
                }

                await _mapService.highlightMarker(
                  controller: _mapController!,
                  place: place,
                );

                setState(() {
                  _highlightedPlaceId = place.id;
                });

                await _mapService.moveCamera(
                  controller: _mapController!,
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
