// TireDiagnosisScreen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper_plus/tflite_flutter_helper_plus.dart';
import 'widgets/TireDiagnosisCard.dart';
import 'widgets/Instruction.dart';
import 'package:marimo_client/commons/CustomAppHeader.dart';
import 'TireTestPage.dart';
import 'TireAnalyzeImage.dart'; // 백업용 알고리즘 분석

class TireDiagnosisScreen extends StatefulWidget {
  const TireDiagnosisScreen({Key? key}) : super(key: key);

  @override
  _TireDiagnosisScreenState createState() => _TireDiagnosisScreenState();
}

class _TireDiagnosisScreenState extends State<TireDiagnosisScreen>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  final List<XFile> _selectedImages = [];
  Interpreter? _interpreter;
  double? _predictedDepth;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadModel();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _interpreter?.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      setState(() {
        // 필요 시 상태 업데이트 로직 추가
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  void addImage(XFile image) {
    setState(() {
      _selectedImages.clear();
      _selectedImages.add(image);
    });
  }

  void removeImage(int index) {
    setState(() {
      _selectedImages.clear();
    });
  }

  /// TFLite 모델을 assets에서 로드 (TF Select Ops 포함)
  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/tire_tread_depth_regressor.tflite',
      );
      _interpreter!.options.supportedOps = [
        TfLiteOpsSet.tfliteBuiltinOps,
        TfLiteOpsSet.selectTfOps,
      ];
      print('TFLite model loaded successfully');
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  /// 파일(File)을 받아 전처리한 후 모델 추론을 실행하고 예측된 트레드 깊이(double)를 반환
  Future<double> analyzeTireImage(File file) async {
    if (_interpreter == null) {
      throw Exception("Interpreter not loaded");
    }
    try {
      // 1. TensorImage를 파일에서 바로 생성
      TensorImage inputImage = TensorImage.fromFile(file);

      // 2. ImageProcessor 구성: 이미지 크기를 224x224로 리사이즈하고 픽셀값을 [0,1]로 정규화
      ImageProcessor imageProcessor =
          ImageProcessorBuilder()
              .add(ResizeOp(224, 224, ResizeMethod.BILINEAR))
              .add(NormalizeOp(0, 255)) // 0~255 -> 0~1
              .build();

      // 3. 전처리 적용
      inputImage = imageProcessor.process(inputImage);

      // 4. 모델 입력 텐서 모양 가져오기 (예: [1, 224, 224, 3])
      var inputShape = _interpreter!.getInputTensor(0).shape;
      var input = inputImage.buffer.reshape(inputShape);

      // 5. 출력 텐서 생성 ([1, 1] float32 배열)
      var output = List.filled(1, 0.0).reshape([1, 1]);

      // 6. 모델 추론 실행
      _interpreter!.run(input, output);

      return output[0][0];
    } catch (e) {
      print('Error during inference: $e');
      rethrow;
    }
  }

  /// 카메라로 이미지 촬영 후 추론 실행 및 결과 페이지(TireTestPage)로 이동
  Future<void> captureAndRunInference() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;

    setState(() {
      _imageFile = File(pickedFile.path);
      addImage(pickedFile);
    });

    try {
      double result = await analyzeTireImage(_imageFile!);
      setState(() {
        _predictedDepth = result;
      });
      // TireTestPage는 double 값을 받아 내부에서 결과 Map으로 변환하여 표시합니다.
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => TireTestPage(result: result)));
    } catch (e) {
      print('Inference failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final contentWidth = MediaQuery.of(context).size.width - 40;

    return Scaffold(
      appBar: CustomAppHeader(
        title: 'AI 진단',
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ).copyWith(top: 16.h, bottom: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI 타이어 마모도 진단',
                  key: UniqueKey(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: contentWidth,
                  child: TireDiagnosisCard(
                    key: UniqueKey(),
                    selectedImages: _selectedImages,
                    onAddImage: addImage,
                    onRemoveImage: removeImage,
                    onAnalysisPressed: () async {
                      await captureAndRunInference();
                    },
                  ),
                ),
                SizedBox(height: 33.h),
                SizedBox(
                  width: contentWidth,
                  child: Instruction(key: UniqueKey()),
                ),
                SizedBox(height: 20),
                if (_imageFile != null)
                  Center(
                    child: Container(
                      width: 224,
                      height: 224,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Image.file(_imageFile!, fit: BoxFit.cover),
                    ),
                  ),
                SizedBox(height: 20),
                if (_predictedDepth != null)
                  Center(
                    child: Text(
                      "Predicted Tread Depth: ${_predictedDepth!.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
