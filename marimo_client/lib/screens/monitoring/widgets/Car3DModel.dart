import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class Car3DModel extends StatelessWidget {
  const Car3DModel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ModelViewer(
          src: 'assets/models/uberXL.glb',
          alt: 'A 3D model of a car',
          ar: false,
          autoRotate: false,
          cameraControls: true,
          cameraOrbit: "90deg 90deg 140m",
          shadowIntensity: 1,
          shadowSoftness: 1,
          interactionPrompt: InteractionPrompt.none,
          innerModelViewerHtml: '''
          <model-viewer id="carViewer"
            src="assets/models/uberXL.glb"
            camera-controls
            interpolationDecay="200">
          </model-viewer>

          <button id="hotspot-trunk" slot="hotspot-trunk" data-position="0m 24m -40m" class="hotspot">📦</button>
          <button id="hotspot-wheel" slot="hotspot-wheel" data-position="16m 8m 33.5m" class="hotspot">🔘</button>


          <script>
            document.addEventListener("DOMContentLoaded", function() {
              console.log("ModelViewer is loaded");
              let modelViewer = document.querySelector("model-viewer");

              if (!modelViewer) {
                console.error("ModelViewer not found!");
                return;
              }

              setTimeout(() => {
                console.log("Adding hotspot event listeners...");

                document.getElementById("hotspot-trunk").addEventListener("click", function() {
                  console.log("Trunk hotspot clicked");
                  modelViewer.setAttribute("camera-orbit", "180deg 75deg 140m");
                });

                document.getElementById("hotspot-wheel").addEventListener("click", function() {
                  console.log("Wheel hotspot clicked");
                  modelViewer.setAttribute("camera-orbit", "90deg 90deg 140m");
                });

              }, 1000); // DOM이 완전히 렌더링된 후 실행
            });
          </script>
        ''',

          relatedCss: '''
          .hotspot {
            background: #FF4E4E;
            border: none;
            border-radius: 50%;
            width: 27px;
            height: 27px;
            position: absolute;
            transform: translate(-50%, -50%);
            transition: transform 0.3s ease-in-out;
            font-size: 16px;
            color: white;
            font-weight: bold;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
          }
          
          .hotspot::before {
            content: "";
            position: absolute;
            top: 50%;
            left: 50%;
            width: 37px;
            height: 37px;
            background: #FF4E4E;
            border-radius: 50%;
            transform: translate(-50%, -50%);
            opacity: 0.2;
          }

          .hotspot:hover {
            transform: translate(-50%, -50%) scale(1.2); /* ✅ 커질 때 위치 유지 */
            transform-origin: center; /* ✅ 확장 중심을 중앙으로 설정 */
          }
        ''',
        ),
      ),
    );
  }
}
