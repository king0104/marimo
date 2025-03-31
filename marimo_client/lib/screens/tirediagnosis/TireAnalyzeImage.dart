// TireAnalyzeImage.dart
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

/// 타이어 이미지를 분석하여 "정상" 또는 "위험" 결과를 반환
Future<String> analyzeTireImage(File imageFile) async {
  final interpreter = await Interpreter.fromAsset('ai/tire_model.tflite');

  final rawBytes = await imageFile.readAsBytes();
  final decoded = img.decodeImage(rawBytes)!;
  final resized = img.copyResize(decoded, width: 224, height: 224);

  final input = Float32List(1 * 224 * 224 * 3);
  int index = 0;

  for (int y = 0; y < 224; y++) {
    for (int x = 0; x < 224; x++) {
      final pixel = resized.getPixelSafe(x, y); // ✅ image 4.x 방식
      input[index++] = pixel.r / 255.0;
      input[index++] = pixel.g / 255.0;
      input[index++] = pixel.b / 255.0;
    }
  }

  final output = List.filled(2, 0.0).reshape([1, 2]);
  interpreter.run(input.buffer.asUint8List(), output);

  final labels = ['정상', '위험'];
  int maxIndex = output[0].indexOf(output[0].reduce(max));

  return labels[maxIndex];
}
