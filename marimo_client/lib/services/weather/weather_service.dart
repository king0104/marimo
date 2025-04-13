import 'dart:convert';
import 'dart:async';  // TimeoutException을 위한 import 추가
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:marimo_client/models/weathers/weather_model.dart';

class WeatherService {
  final String apiKey = dotenv.env['OPENWEATHERMAP_API_KEY'] ?? '';
  
  Future<WeatherModel> getWeather() async {
    try {
      // 위치 정보 가져오기 (타임아웃 15초로 증가)
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.reduced,  // 정확도를 낮춰서 속도 향상
        timeLimit: const Duration(seconds: 15),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('위치 정보를 가져오는데 시간이 너무 오래 걸립니다.'),
      );

      // 날씨 API 호출 (타임아웃 10초)
      final response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&lang=kr'
        ),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('날씨 정보를 가져오는데 시간이 너무 오래 걸립니다.'),
      );

      if (response.statusCode == 200) {
        // 한국어 주소 가져오기 (타임아웃 5초)
        final koreanLocation = await getKoreanAddress(position.latitude, position.longitude)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => '알 수 없는 위치',  // 타임아웃 시 기본값 사용
          );
        
        final weatherData = jsonDecode(response.body);
        return WeatherModel.fromJson({
          ...weatherData,
          'name': koreanLocation,
        });
      } else {
        throw Exception('날씨 정보를 가져오는데 실패했습니다. (${response.statusCode})');
      }
    } catch (e) {
      if (e is TimeoutException) {
        throw Exception('네트워크 상태가 불안정합니다. 잠시 후 다시 시도해주세요.');
      }
      rethrow;
    }
  }

  Future<String> getKoreanAddress(double lat, double lon) async {
    try {
      List<geocoding.Placemark> placemarks = 
          await geocoding.placemarkFromCoordinates(lat, lon);
      
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.administrativeArea ?? ''} ${place.subLocality ?? ''}'.trim();
      }
    } catch (e) {
      print('Geocoding error: $e');
    }
    return '알 수 없는 위치';
  }
}
