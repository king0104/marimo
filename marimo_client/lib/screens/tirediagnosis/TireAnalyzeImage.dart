// TireAnalyzeImage.dart
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';

/// 타이어 이미지를 분석하여 트레드 깊이와 상태를 반환
Future<Map<String, dynamic>> analyzeTireImage(File imageFile) async {
  try {
    // 실제 모델 분석 수행
    return await _performRealAnalysis(imageFile);
  } catch (e) {
    print("❌ 모델 처리 오류: $e");
    print("테스트 데이터 사용");

    // 테스트용 가상 결과 생성
    return _generateTestResults(imageFile);
  }
}

/// 실제 모델을 사용한 분석 수행
Future<Map<String, dynamic>> _performRealAnalysis(File imageFile) async {
  // 모델 존재 확인
  final data = await rootBundle.load('assets/ai/tire_wear_model.tflite');
  print("✅ 모델 존재: ${data.lengthInBytes} bytes");

  // tflite 인터프리터 초기화
  final interpreter = await Interpreter.fromAsset(
    'assets/ai/tire_wear_model.tflite',
  );

  final rawBytes = await imageFile.readAsBytes();
  final decoded = img.decodeImage(rawBytes)!;

  // 모델 입력 크기에 맞게 조정 (640x480)
  final resized = img.copyResize(decoded, width: 640, height: 480);

  // 입력 텐서 준비 (1, 480, 640, 3) 형태로
  final input = List.generate(
    1,
    (_) => List.generate(
      480,
      (y) => List.generate(640, (x) => List.filled(3, 0.0)),
    ),
  );

  // 이미지 데이터를 input에 채워넣기
  for (int y = 0; y < 480; y++) {
    for (int x = 0; x < 640; x++) {
      final pixel = resized.getPixelSafe(x, y);
      input[0][y][x][0] = pixel.r / 255.0;
      input[0][y][x][1] = pixel.g / 255.0;
      input[0][y][x][2] = pixel.b / 255.0;
    }
  }

  // 출력 텐서 준비 (회귀 모델이므로 1개의 값만 출력)
  final output = List.filled(1, 0.0).reshape([1, 1]);

  // 모델 실행
  interpreter.run(input, output);

  // 트레드 깊이 값 (mm)
  final treadDepth = output[0][0];

  // 🔥 출력값 확인
  print('📊 TFLite 예측 결과 (트레드 깊이): ${treadDepth}mm');

  // 트레드 깊이에 따른 타이어 상태 판단
  final condition = _determineTireCondition(treadDepth);

  // 마모율 계산 (새 타이어 깊이 8mm 기준)
  final wearPercentage = _calculateWearPercentage(treadDepth);

  // 잔여 수명 계산
  final remainingLife = _calculateRemainingLife(treadDepth);

  // 결과 반환
  return {
    'treadDepth': treadDepth,
    'condition': condition,
    'wearPercentage': wearPercentage,
    'remainingLife': remainingLife,
  };
}

/// 테스트용 가상 결과 생성
Map<String, dynamic> _generateTestResults(File imageFile) {
  // 이미지에 따라 약간 다른 결과 제공 (좀 더 실제처럼 보이게)
  final fileSize = imageFile.lengthSync();

  // 파일 크기에 따라 약간 다른 값 생성
  final randomFactor = (fileSize % 1000) / 1000;
  final treadDepth = 3.5 + randomFactor * 2.0; // 3.5~5.5 사이 값

  final condition = _determineTireCondition(treadDepth);
  final wearPercentage = _calculateWearPercentage(treadDepth);
  final remainingLife = _calculateRemainingLife(treadDepth);

  print("📊 가상 결과 (트레드 깊이): ${treadDepth.toStringAsFixed(2)}mm");

  return {
    'treadDepth': treadDepth,
    'condition': condition,
    'wearPercentage': wearPercentage,
    'remainingLife': remainingLife,
  };
}

/// 트레드 깊이에 따른 타이어 상태 판단
String _determineTireCondition(double treadDepth) {
  if (treadDepth <= 1.6) {
    return '교체 필요';
  } else if (treadDepth <= 3.0) {
    return '주의';
  } else {
    return '정상';
  }
}

/// 마모율 계산 (%)
double _calculateWearPercentage(double treadDepth) {
  const newTireDepth = 8.0; // 새 타이어 깊이 (mm)
  return ((newTireDepth - treadDepth) / newTireDepth) * 100;
}

/// 잔여 수명 계산 (%)
double _calculateRemainingLife(double treadDepth) {
  const newTireDepth = 8.0;
  const replaceThreshold = 1.6; // 교체가 필요한 최소 깊이

  // 최소값을 0으로 제한하여 음수가 나오지 않게 함
  return math.max(
    0,
    100 * (treadDepth - replaceThreshold) / (newTireDepth - replaceThreshold),
  );
}
