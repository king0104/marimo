import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:marimo_client/providers/car_registration_provider.dart';
import 'package:marimo_client/screens/signin/widgets/CustomTitleText.dart';
import 'package:marimo_client/theme.dart';
import 'package:provider/provider.dart';

class CarAdditionalInfoScreen extends StatefulWidget {
  const CarAdditionalInfoScreen({super.key});

  @override
  _CarAdditionalInfoScreenState createState() =>
      _CarAdditionalInfoScreenState();
}

class _CarAdditionalInfoScreenState extends State<CarAdditionalInfoScreen> {
  final TextEditingController carNumberController = TextEditingController();
  String selectedFuel = '휘발유';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final carProvider = Provider.of<CarRegistrationProvider>(
        context,
        listen: false,
      );
      selectedFuel = carProvider.fuelType ?? '휘발유';
      carProvider.setFuelType(selectedFuel); // 초기값으로 저장
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final carProvider = Provider.of<CarRegistrationProvider>(
      context,
      listen: false,
    );

    final OutlineInputBorder baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: lightgrayColor, width: 1),
    );

    final OutlineInputBorder selectedBorder = baseBorder.copyWith(
      borderSide: const BorderSide(color: brandColor, width: 1),
    );

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const CustomTitleText(
              text: "차량 추가 정보를 입력해주세요.",
              highlight: "차량 추가 정보",
            ),
            const SizedBox(height: 12),

            /// 유종 선택
            Text(
              '유종',
              style: TextStyle(
                color: iconColor,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField2<String>(
              isExpanded: true,
              decoration: InputDecoration(
                border: selectedFuel.isNotEmpty ? selectedBorder : baseBorder,
                enabledBorder: baseBorder,
                focusedBorder: baseBorder,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              value: selectedFuel,
              items:
                  ['휘발유', '경유', '하이브리드']
                      .map(
                        (fuel) => DropdownMenuItem(
                          value: fuel,
                          child: Text(
                            fuel,
                            style: const TextStyle(
                              color: black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedFuel = value;
                  });
                  carProvider.setFuelType(value); // ✅ Provider에도 저장
                }
              },
              dropdownStyleData: DropdownStyleData(
                offset: const Offset(0, -8),
                width: MediaQuery.of(context).size.width - 40,
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(color: lightgrayColor, width: 1),
                  boxShadow: [],
                ),
              ),
              style: const TextStyle(color: Colors.black),
              iconStyleData: IconStyleData(
                icon: Image.asset(
                  'assets/images/icons/icon_drop.png',
                  width: 16,
                  height: 16,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// 연료탱크 용량 입력
            Text(
              '연료탱크 용량',
              style: TextStyle(
                color: iconColor,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 14,
                color: black,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                border: baseBorder,
                enabledBorder: baseBorder,
                focusedBorder: baseBorder,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                suffixIcon: const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Text(
                    'L',
                    style: TextStyle(
                      color: black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                suffixIconConstraints: const BoxConstraints(
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
