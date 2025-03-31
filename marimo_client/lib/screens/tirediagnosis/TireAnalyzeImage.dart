// TireAnalyzeImage.dart
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';

/// 타이어 이미지를 분석하여 "정상" 또는 "위험" 결과를 반환
Future<String> analyzeTireImage(File imageFile) async {
  // 모델 존재 확인
  try {
    final data = await rootBundle.load('assets/ai/tire_model.tflite');
    print("✅ 모델 존재: ${data.lengthInBytes} bytes");
  } catch (e) {
    print("❌ 모델 로딩 실패: $e");
    rethrow; // 또는 return "모델 없음"; 등
  }

  final interpreter = await Interpreter.fromAsset(
    'assets/ai/tire_model.tflite',
  );

  final rawBytes = await imageFile.readAsBytes();
  final decoded = img.decodeImage(rawBytes)!;
  final resized = img.copyResize(decoded, width: 224, height: 224);

  final input = List.generate(
    1,
    (_) => List.generate(
      224,
      (y) => List.generate(224, (x) => List.filled(3, 0.0)),
    ),
  );
  int index = 0;

  // 이미지 데이터를 input에 채워넣기
  for (int y = 0; y < 224; y++) {
    for (int x = 0; x < 224; x++) {
      final pixel = resized.getPixelSafe(x, y);
      input[0][y][x][0] = pixel.r / 255.0;
      input[0][y][x][1] = pixel.g / 255.0;
      input[0][y][x][2] = pixel.b / 255.0;
    }
  }
  // 이제 input shape: [1, 224, 224, 3] ✔️
  // 1장, 세로 224, 가로 224, RGB 3채널

  final output = List.filled(2, 0.0).reshape([1, 2]);

  interpreter.run(input, output);

  // 🔥 출력값 확인
  print('📊 TFLite 예측 결과: $output');

  final labels = ['위험', '정상'];
  final resultRow = List<double>.from(output[0]);

  final maxIndex = resultRow.indexOf(
    resultRow.reduce((double a, double b) => math.max(a, b)),
  );

  return labels[maxIndex];
}
