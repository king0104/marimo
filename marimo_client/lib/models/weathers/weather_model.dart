class WeatherModel {
  final double temperature;
  final String description;
  final String location;
  final int weatherId;

  WeatherModel({
    required this.temperature,
    required this.description,
    required this.location,
    required this.weatherId,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: (json['main']['temp'] as num).toDouble() - 273.15, // 켈빈을 섭씨로 변환
      description: json['weather'][0]['description'],
      location: json['name'],
      weatherId: json['weather'][0]['id'],
    );
  }

  String get weatherImage {
    // assets/images/weathers/ 폴더의 이미지 파일명과 매칭
    if (weatherId >= 200 && weatherId < 300) return 'thunder.png';     // 천둥번개
    if (weatherId >= 300 && weatherId < 500) return 'drizzle.png';     // 이슬비
    if (weatherId >= 500 && weatherId < 600) return 'rain.png';        // 비
    if (weatherId >= 600 && weatherId < 700) return 'snow.png';        // 눈
    if (weatherId >= 700 && weatherId < 800) return 'mist.png';        // 안개
    if (weatherId == 800) return 'clear.png';                          // 맑음
    if (weatherId > 800 && weatherId <= 804) return 'clouds.png';      // 구름
    return 'default.png';  // 기본 이미지
  }

  String get weatherName {
    if (weatherId >= 200 && weatherId < 300) return '뇌우';
    if (weatherId >= 300 && weatherId < 500) return '이슬비';
    if (weatherId >= 500 && weatherId < 600) return '비';
    if (weatherId >= 600 && weatherId < 700) return '눈';
    if (weatherId >= 700 && weatherId < 800) return '안개';
    if (weatherId == 800) return '맑음';
    if (weatherId > 800 && weatherId <= 804) return '흐림';
    return '날씨';
  }

  String get drivingDescription {
    if (weatherId >= 200 && weatherId < 300) return '천둥번개가 치니 운전에 각별히 주의하세요.';
    if (weatherId >= 300 && weatherId < 500) return '이슬비가 내리니 노면이 미끄러울 수 있어요.';
    if (weatherId >= 500 && weatherId < 600) return '비가 내리니 안전거리를 충분히 확보하세요.';
    if (weatherId >= 600 && weatherId < 700) return '눈길 운전, 미끄러지지 않게 조심하세요.';
    if (weatherId >= 700 && weatherId < 800) return '안개로 인해 시야가 좋지 않으니 주의운전하세요.';
    if (weatherId == 800) return '오늘은 드라이빙하기 좋은 날씨네요!';
    if (weatherId > 800 && weatherId <= 804) return '흐린 날씨지만 편안한 드라이빙 되세요.';
    return '안전운전 하세요!';
  }
}
