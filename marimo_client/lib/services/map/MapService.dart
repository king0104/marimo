import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:marimo_client/models/map/Place.dart'; // ✅ Place 모델 import

class MapService {
  /// 현재 위치 가져오기
  Future<NLatLng> fetchCurrentLatLng() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return NLatLng(position.latitude, position.longitude);
  }

  /// 현재 위치 마커 추가 (고정된 이미지 사용)
  Future<void> addCurrentLocationMarker({
    required NaverMapController controller,
    required String id,
    required NLatLng position,
    String caption = '현재 위치',
    Size size = const Size(48, 48),
  }) async {
    final markerIcon = await NOverlayImage.fromAssetImage(
      'assets/images/markers/marker_current.png', // 고정 이미지 경로
    );

    final marker = NMarker(
      id: id,
      position: position,
      icon: markerIcon,
      caption: NOverlayCaption(text: caption),
    );
    await controller.addOverlay(marker);
  }

  /// 마커 추가 (with custom icon)
  Future<void> addMarker({
    required NaverMapController controller,
    required String id,
    required NLatLng position,
    String caption = '',
    required String type,
    bool isSelected = false,
    Size size = const Size(48, 48),
  }) async {
    final markerIcon = await NOverlayImage.fromAssetImage(
      _getMarkerAssetPath(type: type, isSelected: isSelected),
    );

    // ✅ 디버깅용 로그 추가
    print(
      '🧷 addMarker() called → id: $id, type: $type, isSelected: $isSelected, position: (${position.latitude}, ${position.longitude})',
    );

    final marker = NMarker(
      id: id,
      position: position,
      icon: markerIcon,
      caption: NOverlayCaption(text: caption),
    );
    await controller.addOverlay(marker);
  }

  /// 마커 삭제 (단일)
  Future<void> removeMarker({
    required NaverMapController controller,
    required String id,
  }) async {
    try {
      await controller.deleteOverlay(
        NOverlayInfo(type: NOverlayType.marker, id: id),
      );
      print('🗑 마커 제거됨: $id');
    } catch (e) {
      print('⚠️ 마커 제거 실패 (id: $id) → $e');
    }
  }

  /// 다수 마커 삭제
  Future<void> removeMarkersByIds({
    required NaverMapController controller,
    required List<String> ids,
  }) async {
    for (final id in ids) {
      await removeMarker(controller: controller, id: id);
    }
  }

  /// 다수 마커 추가 (Place 객체 리스트 사용)
  Future<void> addPlaceMarkers({
    required NaverMapController controller,
    required List<Place> places,
  }) async {
    for (var place in places) {
      await addMarker(
        controller: controller,
        id: place.name,
        position: NLatLng(place.lat, place.lng),
        caption: place.name,
        type: place.type,
        isSelected: false,
      );
    }
  }

  /// 마커 강조 (선택된 마커만 스타일 바꾸기)
  Future<void> highlightMarker({
    required NaverMapController controller,
    required Place place,
  }) async {
    await removeMarker(controller: controller, id: place.name);
    await addMarker(
      controller: controller,
      id: place.name,
      position: NLatLng(place.lat, place.lng),
      caption: place.name,
      type: place.type,
      isSelected: true,
    );
  }

  /// 마커 강조 해제
  Future<void> resetMarker({
    required NaverMapController controller,
    required Place place,
  }) async {
    await removeMarker(controller: controller, id: place.name);
    await addMarker(
      controller: controller,
      id: place.name,
      position: NLatLng(place.lat, place.lng),
      caption: place.name,
      type: place.type,
      isSelected: false,
    );
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

  String _getMarkerAssetPath({required String type, required bool isSelected}) {
    final status = isSelected ? 'selected' : 'default';
    final path = switch (type) {
      'gas' => 'assets/images/markers/marker_gas_$status.png',
      'repair' => 'assets/images/markers/marker_repair_$status.png',
      'carwash' => 'assets/images/markers/marker_wash_$status.png',
      _ => 'assets/images/markers/marker_default.png',
    };

    // ✅ 어떤 경로로 이미지 불러오는지 확인
    print('🧷 marker image path → $path');
    return path;
  }
}
