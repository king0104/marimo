import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:marimo_client/models/map/gas_station_place.dart'; // ✅ Place 모델 import
import 'package:marimo_client/screens/map/utils/map_utils.dart';

class MapService {
  /// 현재 위치 가져오기
  Future<NLatLng> fetchCurrentLatLng() async {
    // final position = await Geolocator.getCurrentPosition(
    //   desiredAccuracy: LocationAccuracy.high,
    // );
    // return NLatLng(position.latitude, position.longitude);

    // 실제 위치 대신 역삼역 좌표 반환
    return NLatLng(37.500612, 127.036431);
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

  /// 공통 마커 추가 함수 (마커 타입과 선택 여부만 받음)
  Future<void> _addTypedMarker({
    required NaverMapController controller,
    required Place place,
    required bool isSelected,
    void Function()? onTap,
  }) async {
    final markerIcon = await NOverlayImage.fromAssetImage(
      isSelected
          ? 'assets/images/markers/marker_gas_selected.png'
          : 'assets/images/markers/marker_gas_default.png',
    );

    final marker = NMarker(
      id: place.id,
      position: NLatLng(place.lat, place.lng),
      icon: markerIcon,
      caption: NOverlayCaption(text: place.name),
    );

    if (onTap != null) {
      marker.setOnTapListener((overlay) {
        print('👉 마커 클릭됨: ${place.id}');
        onTap();
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

  /// Place 리스트 기반 마커 추가
  Future<void> addPlaceMarkers({
    required NaverMapController controller,
    required List<Place> places,
    void Function(String markerId)? onMarkerTap,
  }) async {
    // 모든 마커 생성 Future를 한 번에 실행
    final futures = places.map((place) {
      return _addTypedMarker(
        controller: controller,
        place: place,
        isSelected: false,
        onTap: onMarkerTap != null ? () => onMarkerTap(place.id) : null,
      );
    });

    await Future.wait(futures); // 🔥 병렬 실행
  }

  /// 마커 강조
  Future<void> highlightMarker({
    required NaverMapController controller,
    required Place place,
    void Function()? onTap,
  }) async {
    await removeMarker(controller: controller, id: place.id);
    await Future.delayed(const Duration(milliseconds: 30)); // 안전한 제거 대기
    await _addTypedMarker(
      controller: controller,
      place: place,
      isSelected: true,
      onTap: onTap,
    );
  }

  /// 마커 강조 해제
  Future<void> resetMarker({
    required NaverMapController controller,
    required Place place,
    void Function()? onTap,
  }) async {
    await removeMarker(controller: controller, id: place.id);
    await Future.delayed(const Duration(milliseconds: 30)); // 안전한 제거 대기
    await _addTypedMarker(
      controller: controller,
      place: place,
      isSelected: false,
      onTap: onTap,
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

  /// 현재 위치 오버레이
  void setCurrentLocationOverlay({
    required NaverMapController controller,
    required NLatLng position,
  }) {
    final overlay = controller.getLocationOverlay();
    overlay.setPosition(position);
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
