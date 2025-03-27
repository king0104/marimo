import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:marimo_client/models/map/Place.dart'; // ✅ Place 모델 import
import 'package:marimo_client/screens/map/utils/map_utils.dart';

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
    void Function()? onTap,
  }) async {
    final markerIcon = await NOverlayImage.fromAssetImage(
      _getMarkerAssetPath(type: type, isSelected: isSelected),
    );

    final marker = NMarker(
      id: id,
      position: position,
      icon: markerIcon,
      caption: NOverlayCaption(text: caption),
    );

    // ✅ 마커 클릭 리스너 연결
    if (onTap != null) {
      marker.setOnTapListener((overlay) {
        onTap(); // 마커 ID 기반 클릭 처리
      });
    }
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
    void Function(String markerId)? onMarkerTap,
  }) async {
    for (var place in places) {
      await addMarker(
        controller: controller,
        id: place.id,
        position: NLatLng(place.lat, place.lng),
        caption: place.name,
        type: place.type,
        isSelected: false,
        onTap: onMarkerTap != null ? () => onMarkerTap(place.id) : null,
      );
    }
  }

  /// 마커 강조 (선택된 마커만 스타일 바꾸기)
  Future<void> highlightMarker({
    required NaverMapController controller,
    required Place place,
  }) async {
    await removeMarker(controller: controller, id: place.id);
    await addMarker(
      controller: controller,
      id: place.id,
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
    await removeMarker(controller: controller, id: place.id);
    await addMarker(
      controller: controller,
      id: place.id,
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

  /// 안전한 카메라 이동: 범위 벗어나면 서울로 이동 + 메시지 출력
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
        target: NLatLng(37.5665, 126.9780),
        zoom: zoom,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('선택한 위치가 지도 범위를 벗어났습니다.')));
    }
  }

  /// 각 카테고리 당 마커가 한 눈에 들어오게
  Future<void> centerMarkersWithZoom({
    required NaverMapController controller,
    required List<Place> places,
    double defaultZoom = 14.0,
  }) async {
    if (places.isEmpty) return;

    final latSum = places.fold(0.0, (sum, p) => sum + p.lat);
    final lngSum = places.fold(0.0, (sum, p) => sum + p.lng);
    final centerLat = latSum / places.length;
    final centerLng = lngSum / places.length;

    // 마커 개수에 따라 줌 조정
    final zoom = switch (places.length) {
      1 => 16.0,
      2 => 15.0,
      3 => 14.5,
      _ => defaultZoom,
    };

    await controller.updateCamera(
      NCameraUpdate.scrollAndZoomTo(
        target: NLatLng(centerLat, centerLng),
        zoom: zoom,
      ),
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
