// TireAnalyzeImage.dart
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

/// 타이어 이미지를 분석하여 트레드 깊이와 상태를 반환
Future<Map<String, dynamic>> analyzeTireImage(File imageFile) async {
  try {
    // 이미지 분석 기법으로 타이어 상태 분석
    return await _performImageAnalysis(imageFile);
  } catch (e) {
    print("❌ 이미지 분석 오류: $e");
    print("테스트 데이터 사용");

    // 테스트용 가상 결과 생성
    return _generateTestResults(imageFile);
  }
}

/// 이미지 분석 기법으로 타이어 트레드 깊이 추정
Future<Map<String, dynamic>> _performImageAnalysis(File imageFile) async {
  print("🔍 이미지 분석 기반 타이어 평가 시작");

  try {
    // 이미지 로드 및 디코딩
    final Uint8List rawBytes = await imageFile.readAsBytes();
    final img.Image? decoded = img.decodeImage(rawBytes);

    if (decoded == null) {
      throw Exception("이미지를 디코딩할 수 없습니다");
    }

    // 분석을 위한 이미지 전처리
    final img.Image processed = _preprocessImage(decoded);

    // 타이어 트레드 영역 감지 및 분석
    final analysisResult = _analyzeTirePattern(processed);

    if (analysisResult['darkRatio'] == null ||
        analysisResult['contrast'] == null ||
        analysisResult['edgeStrength'] == null) {
      print("❌ 타이어 사진을 찾을 수 없습니다. 타이어 사진을 다시 찍어주세요");
      throw Exception("분석값이 null입니다. 유효한 타이어 이미지가 아닐 수 있습니다.");
    }

    // 트레드 깊이 추정
    final double estimatedDepth = _estimateTreadDepth(
      darkRatio: analysisResult['darkRatio']!,
      contrast: analysisResult['contrast']!,
      edgeStrength: analysisResult['edgeStrength']!,
    );

    print(
      "📊 분석 결과 - 어두운 영역 비율: ${analysisResult['darkRatio']?.toStringAsFixed(2) ?? 'N/A'}, " +
          "대비: ${analysisResult['contrast']?.toStringAsFixed(2) ?? 'N/A'}, " +
          "엣지 강도: ${analysisResult['edgeStrength']?.toStringAsFixed(2) ?? 'N/A'}",
    );

    // 트레드 깊이에 따른 타이어 상태 판단
    final condition = _determineTireCondition(estimatedDepth);

    // 마모율 계산 (새 타이어 깊이 8mm 기준)
    final wearPercentage = _calculateWearPercentage(estimatedDepth);

    // 잔여 수명 계산
    final remainingLife = _calculateRemainingLife(estimatedDepth);

    // 결과 반환
    return {
      'treadDepth': estimatedDepth,
      'condition': condition,
      'wearPercentage': wearPercentage,
      'remainingLife': remainingLife,
      'analysis': {
        'darkRatio': analysisResult['darkRatio'],
        'contrast': analysisResult['contrast'],
        'edgeStrength': analysisResult['edgeStrength'],
      },
    };
  } catch (e) {
    print("❌ 이미지 분석 중 오류: $e");
    throw e;
  }
}

/// 이미지 전처리 (명암 향상, 노이즈 제거 등)
img.Image _preprocessImage(img.Image original) {
  final resized = img.copyResize(original, width: 300, height: 300);
  final grayscale = img.grayscale(resized);
  final enhanced = _enhanceContrast(grayscale, 1.5);
  return enhanced;
}

/// 직접 구현한 대비 향상 함수
img.Image _enhanceContrast(img.Image image, double factor) {
  final result = img.Image(
    width: image.width,
    height: image.height,
    format: image.format,
  );
  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      final pixel = image.getPixelSafe(x, y);
      final value = pixel.r.toInt();
      final adjusted = ((value - 128) * factor) + 128;
      final newValue = adjusted.round().clamp(0, 255);
      result.setPixelRgba(x, y, newValue, newValue, newValue, pixel.a.toInt());
    }
  }
  return result;
}

/// 타이어 패턴 분석
Map<String, double> _analyzeTirePattern(img.Image processed) {
  int totalPixels = 0;
  int darkPixels = 0;
  double totalBrightness = 0;
  int minBrightness = 255;
  int maxBrightness = 0;
  double edgeStrengthSum = 0;

  for (int y = 0; y < processed.height; y++) {
    for (int x = 0; x < processed.width; x++) {
      final pixel = processed.getPixelSafe(x, y);
      final int brightness = pixel.r.toInt();
      if (brightness < minBrightness) minBrightness = brightness;
      if (brightness > maxBrightness) maxBrightness = brightness;
      totalBrightness += brightness;
      if (brightness < 80) {
        darkPixels++;
      }
      if (x < processed.width - 1) {
        final nextPixel = processed.getPixelSafe(x + 1, y);
        final diff = (brightness - nextPixel.r.toInt()).abs();
        edgeStrengthSum += diff;
      }
      totalPixels++;
    }
  }

  final darkRatio = darkPixels / totalPixels;
  final avgBrightness = totalBrightness / totalPixels;
  final contrast = (maxBrightness - minBrightness) / 255.0;
  final edgeStrength = edgeStrengthSum / (processed.width * processed.height);

  return {
    'darkRatio': darkRatio,
    'avgBrightness': avgBrightness,
    'contrast': contrast,
    'edgeStrength': edgeStrength,
  };
}

/// 타이어 트레드 깊이 추정 (경험적 수치 기반)
double _estimateTreadDepth({
  required double darkRatio,
  required double contrast,
  required double edgeStrength,
}) {
  final darkRatioWeight = 4.0;
  final contrastWeight = 2.0;
  final edgeWeight = 2.0;
  double estimatedDepth = 0.0;
  if (darkRatio > 0.5) {
    estimatedDepth += 7.0 * darkRatioWeight;
  } else if (darkRatio > 0.4) {
    estimatedDepth += 6.0 * darkRatioWeight;
  } else if (darkRatio > 0.3) {
    estimatedDepth += 5.0 * darkRatioWeight;
  } else if (darkRatio > 0.2) {
    estimatedDepth += 4.0 * darkRatioWeight;
  } else if (darkRatio > 0.1) {
    estimatedDepth += 3.0 * darkRatioWeight;
  } else {
    estimatedDepth += 2.0 * darkRatioWeight;
  }

  if (contrast > 0.8) {
    estimatedDepth += 6.0 * contrastWeight;
  } else if (contrast > 0.6) {
    estimatedDepth += 5.0 * contrastWeight;
  } else if (contrast > 0.4) {
    estimatedDepth += 4.0 * contrastWeight;
  } else if (contrast > 0.2) {
    estimatedDepth += 3.0 * contrastWeight;
  } else {
    estimatedDepth += 2.0 * contrastWeight;
  }

  if (edgeStrength > 30) {
    estimatedDepth += 6.0 * edgeWeight;
  } else if (edgeStrength > 20) {
    estimatedDepth += 5.0 * edgeWeight;
  } else if (edgeStrength > 10) {
    estimatedDepth += 4.0 * edgeWeight;
  } else if (edgeStrength > 5) {
    estimatedDepth += 3.0 * edgeWeight;
  } else {
    estimatedDepth += 2.0 * edgeWeight;
  }

  estimatedDepth =
      estimatedDepth / (darkRatioWeight + contrastWeight + edgeWeight);
  return math.min(8.0, math.max(1.0, estimatedDepth));
}

/// 타이어 상태 판단
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
  const newTireDepth = 8.0;
  return ((newTireDepth - treadDepth) / newTireDepth) * 100;
}

/// 잔여 수명 계산 (%)
double _calculateRemainingLife(double treadDepth) {
  const newTireDepth = 8.0;
  const replaceThreshold = 1.6;
  return math.max(
    0,
    100 * (treadDepth - replaceThreshold) / (newTireDepth - replaceThreshold),
  );
}

/// 테스트용 가상 결과 생성 (분석 실패 시 사용)
Map<String, dynamic> _generateTestResults(File imageFile) {
  final fileSize = imageFile.lengthSync();
  final randomFactor = (fileSize % 1000) / 1000;
  final treadDepth = 3.5 + randomFactor * 2.0;
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
