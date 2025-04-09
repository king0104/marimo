// screens/map/MapScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import 'package:marimo_client/models/map/gas_station_place.dart';
import 'package:marimo_client/models/map/repair_shop_place.dart';

import 'package:marimo_client/screens/map/widgets/PlaceCard.dart';
import 'package:marimo_client/screens/map/widgets/RepairShopCard.dart';
import 'package:marimo_client/screens/map/widgets/EmptyPlaceCard.dart';
import 'package:marimo_client/screens/map/widgets/category/GasStationIcon.dart';
import 'package:marimo_client/screens/map/widgets/category/RepairIcon.dart';
import 'package:marimo_client/screens/map/widgets/category/CarWashIcon.dart';
import 'package:marimo_client/screens/map/widgets/FilterBottomSheet.dart';
import 'package:marimo_client/screens/map/widgets/FilterIcon.dart';

import 'package:marimo_client/providers/map/filter_provider.dart';
import 'package:marimo_client/providers/map/location_provider.dart';
import 'package:marimo_client/providers/member/auth_provider.dart';
import 'package:marimo_client/providers/navigation_provider.dart';

import 'package:marimo_client/services/map/MapService.dart';
import 'package:marimo_client/services/map/map_search_service.dart';

import 'package:marimo_client/screens/map/utils/map_utils.dart';
import 'package:marimo_client/screens/map/utils/gas_filter_mapper.dart';

enum MapCategory { none, gas, repair, carwash }

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapService _mapService = MapService();
  NaverMapController? _mapController;

  bool _isLoading = false;
  bool _hasSearched = false;
  int _radius = 3;

  MapCategory _selectedCategory = MapCategory.none;

  String? _highlightedPlaceId;
  List<String> _previousMarkerIds = [];

  List<Place> _gasStationPlaces = [];
  List<RepairShopPlace> _repairShopPlaces = [];
  // List<CarWashPlace> _carWashPlaces = []; // ✅ 세차장용

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
                  target: cachedPosition ?? const NLatLng(37.5665, 126.9780),
                  zoom: 15,
                ),
                minZoom: 7.0,
                maxZoom: 18.0,
              ),
              onMapReady: (controller) async {
                _mapController = controller;
                final permission = await Permission.location.request();
                if (permission.isGranted) {
                  final current = await _mapService.fetchCurrentLatLng();
                  context.read<LocationProvider>().updatePosition(current);
                  await _mapService.moveCamera(
                    controller: controller,
                    target: current,
                  );
                  _mapService.setCurrentLocationOverlay(
                    controller: controller,
                    position: current,
                  );
                  await _mapService.addCurrentLocationMarker(
                    controller: controller,
                    id: 'user_location',
                    position: current,
                  );
                }

                final nav = context.read<NavigationProvider>();
                if (nav.shouldApplyRepairFilter) {
                  await _onCategoryTap('repair');
                  nav.consumeRepairFilter();
                }
              },
              onCameraIdle: () async {
                final position = await _mapController?.getCameraPosition();
                if (position?.target != null &&
                    !MapUtils.isInsideKorea(position!.target)) {
                  await _mapController?.updateCamera(
                    NCameraUpdate.scrollAndZoomTo(
                      target: const NLatLng(37.5665, 126.9780),
                      zoom: position.zoom,
                    ),
                  );
                }
              },
            ),
          ),
          Positioned(top: 16, left: 16, child: _buildCategoryIcons()),
          Positioned(top: 16, right: 16, child: _buildFloatingButtons()),
          Positioned(
            bottom: 110,
            left: 0,
            right: 0,
            child: _buildStationCard(),
          ),

          if (_isLoading)
            const Positioned.fill(
              child: ColoredBox(
                color: Colors.black38,
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFloatingButtons() {
    return Column(
      children: [
        FloatingActionButton(
          mini: true,
          backgroundColor: Colors.white,
          onPressed: _moveToCurrentLocation,
          child: const Icon(Icons.my_location, color: Colors.black),
        ),
        const SizedBox(height: 8),
        Visibility(
          visible: _selectedCategory == MapCategory.gas,
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.white,
            onPressed: _onFilterPressed,
            child: const FilterIcon(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryIcons() {
    return Row(
      children: [
        GasStationIcon(
          isActive: _selectedCategory == MapCategory.gas,
          onTap: () => _onCategoryTap('gas'),
        ),
        const SizedBox(width: 8),
        RepairIcon(
          isActive: _selectedCategory == MapCategory.repair,
          onTap: () => _onCategoryTap('repair'),
        ),
        // const SizedBox(width: 8),
        // CarWashIcon(
        //   isActive: _selectedCategory == MapCategory.carwash,
        //   onTap: () => _onCategoryTap('carwash'), // TODO
        // ),
      ],
    );
  }

  Widget _buildStationCard() {
    final screenWidth = MediaQuery.of(context).size.width;

    if (!_hasSearched) return const SizedBox.shrink();

    final places =
        _selectedCategory == MapCategory.gas
            ? _gasStationPlaces
            : _selectedCategory == MapCategory.repair
            ? _repairShopPlaces
            // : _carWashPlaces
            : [];

    return SizedBox(
      height: 168.h,
      child:
          places.isEmpty
              ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: EmptyPlaceCard(screenWidth: screenWidth),
              )
              : ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: places.length,
                itemBuilder: (context, index) {
                  final place = places[index];
                  final isSelected = _highlightedPlaceId == place.id.toString();

                  if (place is Place) {
                    return PlaceCard(
                      place: place,
                      rank: index + 1,
                      isSelected: isSelected,
                      onTap: () => handlePlaceSelection(place.id),
                      screenWidth: screenWidth,
                    );
                  } else if (place is RepairShopPlace) {
                    return RepairShopCard(
                      place: place,
                      rank: index + 1,
                      isSelected: isSelected,
                      onTap: () => handlePlaceSelection(place.id.toString()),
                      screenWidth: screenWidth,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
    );
  }

  void _onFilterPressed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (_) => FilterBottomSheet(
            onApply: (selectedRadius) {
              setState(() => _radius = selectedRadius);
              _onCategoryTap('gas');
            },
          ),
    );
  }

  Future<void> _onCategoryTap(String type) async {
    setState(() => _isLoading = true);
    final token = context.read<AuthProvider>().accessToken;
    final position = context.read<LocationProvider>().lastKnownPosition;
    final filters = context.read<FilterProvider>().filtersByCategory;
    final parsed = parseFilterOptions(filters);

    await _mapService.removeMarkersByIds(
      controller: _mapController!,
      ids: _previousMarkerIds,
    );

    if (token == null || position == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      if (type == 'gas') {
        final data = await MapSearchService.getGasStations(
          accessToken: token,
          latitude: position.latitude,
          longitude: position.longitude,
          radius: _radius,
          hasSelfService: parsed.hasSelfService,
          hasMaintenance: parsed.hasMaintenance,
          hasCarWash: parsed.hasCarWash,
          hasCvs: parsed.hasCvs,
          brandList: parsed.brandList,
          oilType: parsed.oilType,
        );

        final places = data.map((e) => Place.fromJson(e)).toList();
        setState(() {
          _selectedCategory = MapCategory.gas;
          _gasStationPlaces = places;
          _repairShopPlaces = [];
          _highlightedPlaceId = null;
          _previousMarkerIds = places.map((e) => e.id).toList();
          _hasSearched = true;
          _isLoading = false;
        });

        await _mapService.addPlaceMarkers(
          controller: _mapController!,
          places: places,
          onMarkerTap: _onMarkerTapped,
        );
      } else if (type == 'repair') {
        final data = await MapSearchService.getRepairShops(
          accessToken: token,
          latitude: position.latitude,
          longitude: position.longitude,
        );

        final places = data.map((e) => RepairShopPlace.fromJson(e)).toList();
        setState(() {
          _selectedCategory = MapCategory.repair;
          _repairShopPlaces = places;
          _gasStationPlaces = [];
          _highlightedPlaceId = null;
          _previousMarkerIds = places.map((e) => e.id.toString()).toList();
          _hasSearched = true;
          _isLoading = false;
        });

        await _mapService.addRepairMarkers(
          controller: _mapController!,
          places: places,
          onMarkerTap: _onMarkerTapped,
        );
      } else if (type == 'carwash') {
        // TODO: 세차장 연동
      }

      await _mapService.centerMarkersWithZoom(
        controller: _mapController!,
        places:
            _selectedCategory == MapCategory.gas
                ? _gasStationPlaces
                : _repairShopPlaces,
      );
    } catch (e) {
      print('🚨 오류: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _moveToCurrentLocation() async {
    final permission = await Permission.location.request();
    if (!permission.isGranted) {
      if (permission.isPermanentlyDenied) await openAppSettings();
      return;
    }

    final current = await _mapService.fetchCurrentLatLng();
    context.read<LocationProvider>().updatePosition(current);

    await _mapService.removeMarkersByIds(
      controller: _mapController!,
      ids: _previousMarkerIds,
    );

    setState(() {
      _highlightedPlaceId = null;
      _selectedCategory = MapCategory.none;
      _gasStationPlaces = [];
      _repairShopPlaces = [];
      _hasSearched = false;
    });

    await _mapService.addCurrentLocationMarker(
      controller: _mapController!,
      id: 'user_location',
      position: current,
    );

    await _mapService.moveCamera(controller: _mapController!, target: current);
  }

  void _onMarkerTapped(String id) {
    handlePlaceSelection(id);
  }

  Future<void> handlePlaceSelection(String selectedPlaceId) async {
    final prevId = _highlightedPlaceId;
    setState(() => _highlightedPlaceId = selectedPlaceId);

    if (_selectedCategory == MapCategory.gas) {
      final prev = _gasStationPlaces.firstWhereOrNull((p) => p.id == prevId);
      final next = _gasStationPlaces.firstWhereOrNull(
        (p) => p.id == selectedPlaceId,
      );

      if (prev != null && prev.id != next?.id) {
        await _mapService.resetMarker(controller: _mapController!, place: prev);
      }
      if (next != null) {
        await _mapService.highlightMarker(
          controller: _mapController!,
          place: next,
        );
        await _mapService.moveCamera(
          controller: _mapController!,
          target: NLatLng(next.lat, next.lng),
        );
      }
    } else if (_selectedCategory == MapCategory.repair) {
      final prev = _repairShopPlaces.firstWhereOrNull(
        (p) => p.id.toString() == prevId,
      );
      final next = _repairShopPlaces.firstWhereOrNull(
        (p) => p.id.toString() == selectedPlaceId,
      );

      if (prev != null && prev.id != next?.id) {
        await _mapService.resetRepairMarker(
          controller: _mapController!,
          place: prev,
        );
      }
      if (next != null) {
        await _mapService.highlightRepairMarker(
          controller: _mapController!,
          place: next,
        );
        await _mapService.moveCamera(
          controller: _mapController!,
          target: NLatLng(next.lat, next.lng),
        );
      }
    }
  }
}
