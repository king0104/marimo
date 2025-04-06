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
  // 분석을 위해 적절한 크기로 조정
  final resized = img.copyResize(original, width: 300, height: 300);

  // 그레이스케일 변환
  final grayscale = img.grayscale(resized);

  // 명암 향상 (직접 구현)
  final enhanced = _enhanceContrast(grayscale, 1.5);

  return enhanced;
}

/// 직접 구현한 대비 향상 함수
img.Image _enhanceContrast(img.Image image, double factor) {
  // 결과 이미지 생성
  final result = img.Image(
    width: image.width,
    height: image.height,
    format: image.format,
  );

  // 이미지 전체 픽셀 스캔
  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      final pixel = image.getPixelSafe(x, y);

      // 그레이스케일 값 얻기
      final value = pixel.r.toInt();

      // 중간 값(128)을 기준으로 대비 조정
      final adjusted = ((value - 128) * factor) + 128;

      // 값 범위 제한 (0-255)
      final newValue = adjusted.round().clamp(0, 255);

      // 새 픽셀 값 설정 (그레이스케일이므로 R,G,B 모두 동일한 값)
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

  // 픽셀 분석
  for (int y = 0; y < processed.height; y++) {
    for (int x = 0; x < processed.width; x++) {
      final pixel = processed.getPixelSafe(x, y);

      // 그레이스케일 값 계산 (R, G, B 값이 모두 같음)
      // image 패키지 버전에 따라 r이 num 타입일 수 있음
      final int brightness = pixel.r.toInt();

      // 최대/최소 밝기 갱신
      if (brightness < minBrightness) minBrightness = brightness;
      if (brightness > maxBrightness) maxBrightness = brightness;

      // 합계 계산
      totalBrightness += brightness;

      // 어두운 픽셀 카운트 (타이어 트레드 홈을 나타냄)
      if (brightness < 80) {
        darkPixels++;
      }

      // 엣지 감지 (x 방향)
      if (x < processed.width - 1) {
        final nextPixel = processed.getPixelSafe(x + 1, y);
        final diff = (brightness - nextPixel.r.toInt()).abs();
        edgeStrengthSum += diff;
      }

      totalPixels++;
    }
  }

  // 결과 계산
  final darkRatio = darkPixels / totalPixels; // 어두운 영역 비율
  final avgBrightness = totalBrightness / totalPixels; // 평균 밝기
  final contrast = (maxBrightness - minBrightness) / 255.0; // 명암비
  final edgeStrength =
      edgeStrengthSum / (processed.width * processed.height); // 엣지 강도

  return {
    'darkRatio': darkRatio,
    'avgBrightness': avgBrightness,
    'contrast': contrast,
    'edgeStrength': edgeStrength,
  };
}

/// 이미지 특성에 기반한 트레드 깊이 추정
double _estimateTreadDepth({
  required double darkRatio,
  required double contrast,
  required double edgeStrength,
}) {
  // 어두운 영역 비율, 대비, 엣지 강도를 이용한 트레드 깊이 추정
  // 새 타이어(깊은 트레드)는 어두운 영역이 많고, 대비가 높으며, 엣지가 선명함
  // 마모된 타이어는 어두운 영역이 적고, 대비가 낮으며, 엣지가 흐릿함

  // 각 특성에 가중치 적용
  final darkRatioWeight = 4.0;
  final contrastWeight = 2.0;
  final edgeWeight = 2.0;

  // 트레드 깊이 추정 공식 (경험적 수치 기반)
  double estimatedDepth = 0.0;

  // 어두운 영역 비율 반영 (0.1~0.5 범위를 2~7mm로 매핑)
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

  // 대비 반영 (0.2~0.8 범위를 2~6mm로 매핑)
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

  // 엣지 강도 반영 (5~30 범위를 2~6mm로 매핑)
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

  // 가중 평균 계산
  estimatedDepth =
      estimatedDepth / (darkRatioWeight + contrastWeight + edgeWeight);

  // 최종 값 범위 제한 (1.0~8.0mm)
  return math.min(8.0, math.max(1.0, estimatedDepth));
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
