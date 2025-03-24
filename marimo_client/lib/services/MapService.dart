import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';

class MapService {
  /// 현재 위치 가져오기
  Future<NLatLng> fetchCurrentLatLng() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return NLatLng(position.latitude, position.longitude);
  }

  /// 지도 마커 추가
  Future<void> addMarker({
    required NaverMapController controller,
    required String id,
    required NLatLng position,
    String caption = '',
  }) async {
    final marker = NMarker(
      id: id,
      position: position,
      caption: NOverlayCaption(text: caption),
    );
    await controller.addOverlay(marker);
  }

  /// 마커 삭제
  Future<void> removeMarker({
    required NaverMapController controller,
    required String id,
  }) async {
    await controller.deleteOverlay(
      NOverlayInfo(type: NOverlayType.marker, id: id),
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

  /// 초기 주유소 마커들 추가
  Future<void> addGasStationMarkers({
    required NaverMapController controller,
    required List<Map<String, dynamic>> gasStations,
  }) async {
    for (var station in gasStations) {
      final marker = NMarker(
        id: station['name'],
        position: NLatLng(station['lat'], station['lng']),
      );
      await controller.addOverlay(marker);
    }
  }

  /// 현재 위치 오버레이 설정
  void setCurrentLocationOverlay({
    required NaverMapController controller,
    required NLatLng position,
  }) {
    final overlay = controller.getLocationOverlay();
    overlay.setPosition(position);
  }
}
