import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/models/map/Place.dart';
import 'package:marimo_client/providers/navigation_provider.dart';
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
    final cachedPosition = context.read<MapStateProvider>().lastKnownPosition;

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

                  context.read<MapStateProvider>().updatePosition(
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
