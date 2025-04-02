import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

/// 입력된 타이어 이미지를 분석하여, "Good", "Normal", "Bad" 텍스트 결과를 반환합니다.
Future<String> analyzeTireImage(File imageFile) async {
  try {
    // 모델 로드: assets/ai/model.tflite
    final interpreter = await Interpreter.fromAsset('ai/model.tflite');

    // 이미지 읽기 및 디코딩
    final imageBytes = await imageFile.readAsBytes();
    img.Image? originalImage = img.decodeImage(imageBytes);
    if (originalImage == null) {
      throw Exception("이미지 디코딩 실패");
    }

    // 모델 입력 크기(224x224)로 리사이즈
    final resizedImage = img.copyResize(originalImage, width: 224, height: 224);

    // 모델 입력 텐서 생성: [1, 224, 224, 3]
    // 각 픽셀 값을 0.0 ~ 1.0 범위로 정규화합니다.
    var input = List.generate(
      1,
      (_) => List.generate(
        224,
        (y) => List.generate(224, (x) {
          final pixel = resizedImage.getPixel(x, y); // Pixel 객체
          final r = pixel.r / 255.0;
          final g = pixel.g / 255.0;
          final b = pixel.b / 255.0;
          return [r, g, b];
        }),
      ),
    );

    // 모델 출력 텐서 생성: [1, 3] (각 클래스의 확률)
    var output = List.generate(1, (_) => List.filled(3, 0.0));

    // 추론 실행
    interpreter.run(input, output);
    interpreter.close();

    // 결과 해석: 가장 높은 확률을 가진 인덱스 찾기
    List<double> probabilities = output[0];
    int predictedIndex = 0;
    double maxProb = probabilities[0];
    for (int i = 1; i < probabilities.length; i++) {
      if (probabilities[i] > maxProb) {
        maxProb = probabilities[i];
        predictedIndex = i;
      }
    }

    // 클래스 매핑: 0 -> Good, 1 -> Normal, 2 -> Bad
    String resultLabel;
    switch (predictedIndex) {
      case 0:
        resultLabel = "Good";
        break;
      case 1:
        resultLabel = "Normal";
        break;
      case 2:
        resultLabel = "Bad";
        break;
      default:
        resultLabel = "Unknown";
    }

    return resultLabel;
  } catch (e) {
    print("모델 실행 오류: $e");
    throw e;
  }
}
