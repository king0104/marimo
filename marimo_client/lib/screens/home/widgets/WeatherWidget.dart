import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_provider.dart';
import 'package:marimo_client/services/weather/weather_service.dart';
import 'package:marimo_client/models/weathers/weather_model.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  final WeatherService _weatherService = WeatherService();
  WeatherModel? _weather;
  bool _isLoading = true;
  String? _error;
  bool _isRetrying = false;

  @override
  void initState() {
    super.initState();
    _initializeWeather();
  }

  void _initializeWeather() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadWeather();
      }
    });
  }

  Future<void> _loadWeather() async {
    if (_isRetrying) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
      _isRetrying = true;
    });

    try {
      final weather = await _weatherService.getWeather();
      if (!mounted) return;
      
      setState(() {
        _weather = weather;
        _isLoading = false;
        _isRetrying = false;
      });
    } catch (e) {
      print('Weather Widget error: $e');
      if (!mounted) return;
      
      setState(() {
        _error = '날씨 정보를 불러올 수 없습니다.';
        _isLoading = false;
        _isRetrying = false;
      });

      // 3초 후 자동 재시도
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _error != null) {
          _loadWeather();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<CarProvider>(
          builder: (context, carProvider, child) {
            final car = carProvider.cars.isNotEmpty ? carProvider.cars.first : null;
            final nickname = car?.nickname ?? '마이 리틀 모빌리티';
            return Text(
              nickname,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            );
          },
        ),
        SizedBox(height: 4.h),
        Text(
          _weather?.drivingDescription ?? (_isLoading ? '날씨 정보를 불러오는 중...' : '날씨 정보 없음'),
          style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            if (_weather != null) ...[
              Image.asset(
                'assets/images/weathers/${_weather?.weatherImage ?? 'default.png'}',
                width: 16.sp,
                height: 16.sp,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.wb_sunny, size: 16.sp, color: Colors.grey[600]);
                },
              ),
              SizedBox(width: 4.w),
              Text(
                _weather?.weatherName ?? '',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
              SizedBox(width: 8.w),
              Icon(Icons.thermostat_outlined, size: 16.sp, color: Colors.grey[600]),
              Text(
                '${_weather?.temperature.round()}°C',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
              SizedBox(width: 8.w),
              Icon(Icons.location_on, size: 16.sp, color: Colors.grey[600]),
              Text(
                _weather?.location ?? '위치 정보 없음',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
            ] else if (_error != null) ...[
              Icon(Icons.error_outline, size: 16.sp, color: Colors.grey[600]),
              SizedBox(width: 4.w),
              Text(
                _error!,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
            ] else ...[
              SizedBox(
                width: 16.sp,
                height: 16.sp,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
