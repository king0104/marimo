import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapUtils {
  static bool isInsideKorea(NLatLng point) {
    const double minLat = 33.0;
    const double maxLat = 39.5;
    const double minLng = 124.0;
    const double maxLng = 131.0;

    return point.latitude >= minLat &&
        point.latitude <= maxLat &&
        point.longitude >= minLng &&
        point.longitude <= maxLng;
  }
}
