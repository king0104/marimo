import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:marimo_client/models/map/gas_station_place.dart';
import 'package:marimo_client/models/map/repair_shop_place.dart';
import 'package:marimo_client/screens/map/utils/map_utils.dart';

class MapService {
  /// 현재 위치 가져오기
  Future<NLatLng> fetchCurrentLatLng() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return NLatLng(position.latitude, position.longitude);
  }

  /// 현재 위치 마커 추가
  Future<void> addCurrentLocationMarker({
    required NaverMapController controller,
    required String id,
    required NLatLng position,
    String caption = '현재 위치',
    Size size = const Size(48, 48),
  }) async {
    final markerIcon = await NOverlayImage.fromAssetImage(
      'assets/images/markers/marker_current.png',
    );

    final marker = NMarker(
      id: id,
      position: position,
      icon: markerIcon,
      caption: NOverlayCaption(text: caption),
    );

    await controller.addOverlay(marker);
  }

  /// Place 마커 생성
  Future<void> _addTypedMarker({
    required NaverMapController controller,
    required Place place,
    required bool isSelected,
    void Function()? onTap,
  }) async {
    final markerIcon = await NOverlayImage.fromAssetImage(
      _getMarkerAssetPath(type: 'gas', isSelected: isSelected),
    );

    final marker = NMarker(
      id: place.id,
      position: NLatLng(place.lat, place.lng),
      icon: markerIcon,
      caption: NOverlayCaption(text: place.name),
    );

    if (onTap != null) {
      marker.setOnTapListener((overlay) => onTap());
    }

    await controller.addOverlay(marker);
  }

  /// Repair 마커 생성
  Future<void> _addTypedRepairMarker({
    required NaverMapController controller,
    required RepairShopPlace place,
    required bool isSelected,
    void Function()? onTap,
  }) async {
    final markerIcon = await NOverlayImage.fromAssetImage(
      _getMarkerAssetPath(type: 'repair', isSelected: isSelected),
    );

    final marker = NMarker(
      id: place.id.toString(),
      position: NLatLng(place.lat, place.lng),
      icon: markerIcon,
      caption: NOverlayCaption(text: place.name),
    );

    if (onTap != null) {
      marker.setOnTapListener((overlay) => onTap());
    }

    await controller.addOverlay(marker);
  }

  /// Place 리스트 기반 마커 추가
  Future<void> addPlaceMarkers({
    required NaverMapController controller,
    required List<Place> places,
    void Function(String markerId)? onMarkerTap,
  }) async {
    final futures = places.map((place) {
      return _addTypedMarker(
        controller: controller,
        place: place,
        isSelected: false,
        onTap: onMarkerTap != null ? () => onMarkerTap(place.id) : null,
      );
    });

    await Future.wait(futures);
  }

  /// Repair 리스트 기반 마커 추가
  Future<void> addRepairMarkers({
    required NaverMapController controller,
    required List<RepairShopPlace> places,
    void Function(String markerId)? onMarkerTap,
  }) async {
    final futures = places.map((place) {
      return _addTypedRepairMarker(
        controller: controller,
        place: place,
        isSelected: false,
        onTap:
            onMarkerTap != null ? () => onMarkerTap(place.id.toString()) : null,
      );
    });

    await Future.wait(futures);
  }

  /// 마커 강조 (주유소)
  Future<void> highlightMarker({
    required NaverMapController controller,
    required Place place,
    void Function()? onTap,
  }) async {
    await removeMarker(controller: controller, id: place.id);
    await Future.delayed(const Duration(milliseconds: 30));
    await _addTypedMarker(
      controller: controller,
      place: place,
      isSelected: true,
      onTap: onTap,
    );
  }

  /// 마커 강조 (정비소)
  Future<void> highlightRepairMarker({
    required NaverMapController controller,
    required RepairShopPlace place,
    void Function()? onTap,
  }) async {
    await removeMarker(controller: controller, id: place.id.toString());
    await Future.delayed(const Duration(milliseconds: 30));
    await _addTypedRepairMarker(
      controller: controller,
      place: place,
      isSelected: true,
      onTap: onTap,
    );
  }

  /// 마커 리셋 (주유소)
  Future<void> resetMarker({
    required NaverMapController controller,
    required Place place,
    void Function()? onTap,
  }) async {
    await removeMarker(controller: controller, id: place.id);
    await Future.delayed(const Duration(milliseconds: 30));
    await _addTypedMarker(
      controller: controller,
      place: place,
      isSelected: false,
      onTap: onTap,
    );
  }

  /// 마커 리셋 (정비소)
  Future<void> resetRepairMarker({
    required NaverMapController controller,
    required RepairShopPlace place,
    void Function()? onTap,
  }) async {
    await removeMarker(controller: controller, id: place.id.toString());
    await Future.delayed(const Duration(milliseconds: 30));
    await _addTypedRepairMarker(
      controller: controller,
      place: place,
      isSelected: false,
      onTap: onTap,
    );
  }

  /// 마커 삭제
  Future<void> removeMarker({
    required NaverMapController controller,
    required String id,
  }) async {
    try {
      await controller.deleteOverlay(
        NOverlayInfo(type: NOverlayType.marker, id: id),
      );
    } catch (e) {
      debugPrint("⚠️ 마커 제거 실패 (id: $id): $e");
    }
  }

  /// 여러 마커 삭제
  Future<void> removeMarkersByIds({
    required NaverMapController controller,
    required List<String> ids,
  }) async {
    for (final id in ids) {
      await removeMarker(controller: controller, id: id);
    }
  }

  /// 카메라 이동
  Future<void> moveCamera({
    required NaverMapController controller,
    required NLatLng target,
    double zoom = 15,
  }) async {
    await controller.updateCamera(
      NCameraUpdate.scrollAndZoomTo(target: target, zoom: zoom),
    );
  }

  /// 현재 위치 오버레이
  void setCurrentLocationOverlay({
    required NaverMapController controller,
    required NLatLng position,
  }) {
    final overlay = controller.getLocationOverlay();
    overlay.setPosition(position);
  }

  /// 카메라 안전 이동
  Future<void> safeMoveCamera({
    required BuildContext context,
    required NaverMapController controller,
    required NLatLng target,
    double zoom = 15,
  }) async {
    if (MapUtils.isInsideKorea(target)) {
      await moveCamera(controller: controller, target: target, zoom: zoom);
    } else {
      await moveCamera(
        controller: controller,
        target: const NLatLng(37.5665, 126.9780),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('선택한 위치가 지도 범위를 벗어났습니다.')));
    }
  }

  /// 마커 전체 중앙 정렬
  Future<void> centerMarkersWithZoom({
    required NaverMapController controller,
    required List<dynamic> places, // Place or RepairShopPlace
  }) async {
    if (places.isEmpty) return;

    final latList = places.map((p) => p.lat).toList();
    final lngList = places.map((p) => p.lng).toList();

    final southWest = NLatLng(
      latList.reduce((a, b) => a < b ? a : b),
      lngList.reduce((a, b) => a < b ? a : b),
    );

    final northEast = NLatLng(
      latList.reduce((a, b) => a > b ? a : b),
      lngList.reduce((a, b) => a > b ? a : b),
    );

    final bounds = NLatLngBounds(southWest: southWest, northEast: northEast);
    await controller.updateCamera(
      NCameraUpdate.fitBounds(bounds, padding: const EdgeInsets.all(80)),
    );
  }

  /// 마커 이미지 경로 계산
  String _getMarkerAssetPath({required String type, required bool isSelected}) {
    final status = isSelected ? 'selected' : 'default';
    return switch (type) {
      'gas' => 'assets/images/markers/marker_gas_$status.png',
      'repair' => 'assets/images/markers/marker_repair_$status.png',
      'carwash' => 'assets/images/markers/marker_wash_$status.png',
      _ => 'assets/images/markers/marker_default.png',
    };
  }
}
