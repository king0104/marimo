import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class Car3DModel extends StatelessWidget {
  const Car3DModel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ModelViewer(
          src: 'assets/models/uberXL.glb', // glb 파일 경로
          alt: 'A 3D model of a car',
          ar: false,
          autoRotate: true, // 필요하면 true로
          autoRotateDelay: 0,
          rotationPerSecond: "45deg",
          cameraControls: true,
          cameraOrbit: "90deg 55deg 200m",
          shadowIntensity: 1,
          shadowSoftness: 0,
          interactionPrompt: InteractionPrompt.none,
        ),
      ),
    );
  }
}
