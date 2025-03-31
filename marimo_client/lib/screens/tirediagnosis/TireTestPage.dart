import 'package:flutter/material.dart';

class TireTestPage extends StatelessWidget {
  final String result; // '정상' 또는 '위험'

  const TireTestPage({required this.result, Key? key}) : super(key: key);

  bool get isSafe => result == '정상';

  @override
  Widget build(BuildContext context) {
    final color = isSafe ? Colors.green : Colors.red;
    final icon = isSafe ? Icons.check_circle : Icons.error;
    final title = isSafe ? '타이어 상태가 양호합니다!' : '타이어가 위험합니다!';
    final description =
        isSafe ? '마모가 거의 없는 좋은 상태입니다.' : '마모가 심각합니다.\n즉시 교체 또는 정비소 방문이 필요합니다.';

    return Scaffold(
      appBar: AppBar(title: Text('AI 진단 결과'), backgroundColor: color),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 80, color: color),
              SizedBox(height: 24),
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                description,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('다시 진단하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
