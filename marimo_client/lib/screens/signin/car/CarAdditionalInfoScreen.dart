import 'package:flutter/material.dart';
import 'package:marimo_client/screens/signin/widgets/car/CarInput.dart';
import 'package:marimo_client/screens/signin/widgets/CustomTitleText.dart';

class CarAdditionalInfoScreen extends StatefulWidget {
  const CarAdditionalInfoScreen({super.key});

  @override
  _CarAdditionalInfoScreenState createState() =>
      _CarAdditionalInfoScreenState();
}

class _CarAdditionalInfoScreenState extends State<CarAdditionalInfoScreen> {
  final TextEditingController carNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60),
            CustomTitleText(text: "차량 추가 정보를 입력해주세요.", highlight: "차량 추가 정보"),
            SizedBox(height: 20),

            /// 연료 종류 선택
            Text('유종', style: TextStyle(color: Colors.grey, fontSize: 14)),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              value: '휘발유',
              items:
                  ['휘발유', '경유', '하이브리드']
                      .map(
                        (fuel) =>
                            DropdownMenuItem(value: fuel, child: Text(fuel)),
                      )
                      .toList(),
              onChanged: (value) {
                // 선택한 값 처리
              },
            ),

            SizedBox(height: 20),

            /// 연료탱크 용량 입력
            Text('연료탱크 용량', style: TextStyle(color: Colors.grey, fontSize: 14)),
            SizedBox(height: 8),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20, // ✅ padding 넉넉히
                  vertical: 12,
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    'L',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                suffixIconConstraints: BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
