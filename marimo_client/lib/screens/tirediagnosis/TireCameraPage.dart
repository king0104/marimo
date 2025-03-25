// TireCameraPage.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'widgets/TireCameraGuide.dart';
import 'package:marimo_client/commons/CustomAppHeader.dart';

class TireCameraPage extends StatefulWidget {
  final Function(XFile) onImageCaptured;

  const TireCameraPage({Key? key, required this.onImageCaptured})
    : super(key: key);

  @override
  _TireCameraPageState createState() => _TireCameraPageState();
}

class _TireCameraPageState extends State<TireCameraPage>
    with WidgetsBindingObserver {
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 앱이 다시 포그라운드로 돌아왔을 때
      setState(() {
        // 필요한 경우 여기서 상태를 복원하거나 갱신합니다.
      });
    }
  }

  void _handleImageCaptured(XFile image) {
    setState(() {
      _capturedImage = image;
    });
    widget.onImageCaptured(image);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppHeader(
        title: 'AI 진단',
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: 16),
            child: Text(
              "타이어 사진 촬영",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: TireCameraGuide(onImageCaptured: _handleImageCaptured),
          ),
          if (_capturedImage != null) ...[
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "사진이 성공적으로 캡처되었습니다!",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
