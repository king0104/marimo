import 'package:flutter/material.dart';
import 'package:marimo_client/providers/car_registration_provider.dart';
import 'package:marimo_client/theme.dart';
import 'package:provider/provider.dart';

class CarInput extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final FocusNode? focusNode; // ✅ focusNode 추가

  const CarInput({
    super.key,
    required this.controller,
    this.labelText = "차량 번호",
    this.hintText = "아이디를 입력해주세요.",
    this.focusNode, // ✅ 선택적 매개변수로 등록
  });

  @override
  State<CarInput> createState() => _CarInputState();
}

class _CarInputState extends State<CarInput> {
  bool isFilled = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleInputChange);
    _handleInputChange(); // 초기 상태 반영
  }

  void _handleInputChange() {
    setState(() {
      isFilled = widget.controller.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleInputChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CarRegistrationProvider>(
      context,
      listen: false,
    );

    return SizedBox(
      height: 50,
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode, // ✅ focusNode 연결
        onChanged: (value) {
          switch (widget.labelText) {
            case "차량 번호":
              provider.setPlateNumber(value);
              break;
            case "차대 번호":
              provider.setVin(value);
              break;
            case "닉네임":
              provider.setNickname(value);
              break;
          }
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: lightgrayColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          filled: isFilled,
          fillColor:
              isFilled ? const Color(0xFFF5F5F5) : white, // ✅ 입력 완료 시 배경색 변경
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: lightgrayColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: lightgrayColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
        style: const TextStyle(
          fontSize: 16,
          color: backgroundBlackColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
