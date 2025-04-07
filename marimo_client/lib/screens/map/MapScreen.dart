import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/models/map/gas_station_place.dart';
import 'package:marimo_client/providers/map/filter.provider.dart';
import 'package:marimo_client/screens/map/utils/map_filter_mapper.dart';
import 'package:marimo_client/providers/navigation_provider.dart';
import 'package:marimo_client/screens/map/utils/map_utils.dart';
import 'package:marimo_client/screens/map/widgets/PlaceCard.dart';
import 'package:marimo_client/services/map/MapService.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:marimo_client/screens/map/widgets/category/CarWashIcon.dart';
import 'package:marimo_client/screens/map/widgets/category/GasStationIcon.dart';
import 'package:marimo_client/screens/map/widgets/category/RepairIcon.dart';
import 'package:marimo_client/providers/map/location_provider.dart';
import 'package:provider/provider.dart';
import 'widgets/FilterIcon.dart';
import 'widgets/FilterBottomSheet.dart';
import 'package:collection/collection.dart';
import 'package:marimo_client/services/map/map_search_service.dart';
import 'package:marimo_client/models/map/gas_station_place.dart';
import 'package:marimo_client/providers/member/auth_provider.dart';
import 'package:marimo_client/screens/map/utils/map_place_mapper.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapService _mapService = MapService();
  NaverMapController? _mapController;
  NMarker? _userLocationMarker;

  bool _gasStationFilter = false;
  bool _repairFilter = false;
  bool _carWashFilter = false;

  List<Place> _currentPlaces = [];
  List<String> _previousMarkerIds = [];
  String? _highlightedPlaceId;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cachedPosition = context.read<LocationProvider>().lastKnownPosition;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: NaverMap(
              options: NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: cachedPosition ?? NLatLng(37.5665, 126.9780),
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

                final permissionGranted = await Permission.location.request();
                if (permissionGranted.isGranted) {
                  final currentLatLng = await _mapService.fetchCurrentLatLng();

                  context.read<LocationProvider>().updatePosition(
                    currentLatLng,
                  );

                  await _mapService.moveCamera(
                    controller: _mapController!,
                    target: currentLatLng,
                  );

                  _mapService.setCurrentLocationOverlay(
                    controller: _mapController!,
                    position: currentLatLng,
                  );

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

                final navProvider = context.read<NavigationProvider>();
                if (navProvider.shouldApplyRepairFilter) {
                  await _onCategoryTap('repair');
                  navProvider.consumeRepairFilter();
                }
              },
              onCameraIdle: () async {
                final position = await _mapController?.getCameraPosition();
                if (position?.target != null &&
                    !MapUtils.isInsideKorea(position!.target)) {
                  await _mapController?.updateCamera(
                    NCameraUpdate.scrollAndZoomTo(
                      target: NLatLng(37.5665, 126.9780),
                      zoom: position.zoom,
                    ),
                  );
                }
              },
            ),
          ),
          Positioned(
            bottom: 110,
            left: 0,
            right: 0,
            child: _buildStationCard(),
          ),
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

  Future<void> _moveToCurrentLocation() async {
    final permissionGranted = await Permission.location.request();
    if (!permissionGranted.isGranted) {
      if (permissionGranted.isPermanentlyDenied) {
        await openAppSettings();
      }
      return;
    }

    final currentLatLng = await _mapService.fetchCurrentLatLng();

    context.read<LocationProvider>().updatePosition(currentLatLng);

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

  void _onFilterPressed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (modalContext) {
        return Builder(
          builder:
              (modalContext) => FilterBottomSheet(
                onApply: () => _onCategoryTap('gas'), // ✅ 현재 필터 기반으로 다시 호출
              ), // ✅ 이 ctx로 Provider 접근
        );
      },
    );
  }

  Future<void> _onCategoryTap(String type) async {
    final token = context.read<AuthProvider>().accessToken;
    final position = context.read<LocationProvider>().lastKnownPosition;
    final filters = context.read<FilterProvider>().filtersByCategory;
    final parsed = parseFilterOptions(filters); // ✅ 이제 Map 기반 파싱

    await _mapService.removeMarkersByIds(
      controller: _mapController!,
      ids: _previousMarkerIds.toSet().toList(),
    );

    await Future.delayed(const Duration(milliseconds: 50));
    _previousMarkerIds.clear();

    if (token == null || position == null) {
      print('❗ 토큰 또는 위치 정보 없음');
      return;
    }

    List<Place> places = [];

    try {
      if (type == 'gas') {
        // ✅ 위치 + 필터 파라미터 포함한 POST 요청
        final data = await MapSearchService.getGasStations(
          accessToken: token,
          latitude: position.latitude,
          longitude: position.longitude,
          radius: 3000,
          hasSelfService: parsed.hasSelfService,
          hasMaintenance: parsed.hasMaintenance,
          hasCarWash: parsed.hasCarWash,
          hasCvs: parsed.hasCvs,
          brandList: parsed.brandList,
          oilType: parsed.oilType,
        );

        print('✅ [API 응답] 받은 주유소 개수: ${data.length}');

        places = data.map((json) => mapGasStationJsonToPlace(json)).toList();
      } else {
        // TODO: 정비소/세차장 API 완성되면 여기도 확장
        return;
      }
    } catch (e) {
      print('🚨 주유소 데이터 불러오기 실패: $e');
      return;
    }

    setState(() {
      _currentPlaces = places;
      _highlightedPlaceId = null;
      _previousMarkerIds = places.map((e) => e.id).toList();
      _gasStationFilter = type == 'gas';
      _repairFilter = type == 'repair';
      _carWashFilter = type == 'carwash';
    });

    await _mapService.addPlaceMarkers(
      controller: _mapController!,
      places: places,
      onMarkerTap: _onMarkerTapped,
    );

    await Future.delayed(const Duration(milliseconds: 300));
    await _mapService.centerMarkersWithZoom(
      controller: _mapController!,
      places: _currentPlaces,
    );
  }

  void _onMarkerTapped(String markerId) async {
    await handlePlaceSelection(markerId);
  }

  Widget _buildStationCard() {
    final screenWidth = MediaQuery.of(context).size.width;

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
              rank: index + 1,
              isSelected: _highlightedPlaceId == place.id,
              onTap: () => handlePlaceSelection(place.id),
              screenWidth: screenWidth,
            );
          },
        ),
      ),
    );
  }

  /// 공통 로직 처리: 마커 및 카드 선택 처리
  Future<void> handlePlaceSelection(String selectedPlaceId) async {
    final previousPlaceId = _highlightedPlaceId; // ✅ 이전 강조된 ID 저장

    // 1️⃣ UI 반응 빠르게: 먼저 선택된 카드 강조
    setState(() {
      _highlightedPlaceId = selectedPlaceId;
    });

    // 2️⃣ 이전 마커 비활성화
    final prevPlace = _currentPlaces.firstWhereOrNull(
      (p) => p.id == previousPlaceId,
    );

    if (prevPlace != null && previousPlaceId != selectedPlaceId) {
      await _mapService.resetMarker(
        controller: _mapController!,
        place: prevPlace,
        onTap: () => _onMarkerTapped(prevPlace.id),
      );
    }

    // 3️⃣ 새 마커 강조
    final newPlace = _currentPlaces.firstWhereOrNull(
      (p) => p.id == selectedPlaceId,
    );

    if (newPlace != null) {
      await _mapService.highlightMarker(
        controller: _mapController!,
        place: newPlace,
        onTap: () => _onMarkerTapped(newPlace.id),
      );

      await _mapService.moveCamera(
        controller: _mapController!,
        target: NLatLng(newPlace.lat, newPlace.lng),
      );
    }
  }
}
