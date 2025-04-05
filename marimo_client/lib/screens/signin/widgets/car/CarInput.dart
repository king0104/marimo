import 'package:flutter/material.dart';
import 'package:marimo_client/providers/car_registration_provider.dart';
import 'package:marimo_client/theme.dart';
import 'package:provider/provider.dart';

class CarInput extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final FocusNode? focusNode;

  const CarInput({
    super.key,
    required this.controller,
    this.labelText = "차량 번호",
    this.hintText = "아이디를 입력해주세요.",
    this.focusNode,
  });

  @override
  State<CarInput> createState() => _CarInputState();
}

class _CarInputState extends State<CarInput> {
  bool isFilled = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleInputChange);
    _handleInputChange(); // 초기 상태 반영
  }

  void _handleInputChange() {
    setState(() {
      isFilled = widget.controller.text.trim().isNotEmpty;
      errorMessage = _validateInput(widget.controller.text);
    });
  }

  String? _validateInput(String input) {
    input = input.trim();

    if (widget.labelText == "차량 번호") {
      final regex = RegExp(r'^\d{2,3}[가-힣]\d{4}$');
      if (!regex.hasMatch(input)) {
        return "유효하지 않은 차량 번호 형식입니다. 예) 123가1234";
      }
    }

    if (widget.labelText == "차대 번호") {
      final vinRegex = RegExp(r'^[A-HJ-NPR-Z0-9]{17}$');
      if (!vinRegex.hasMatch(input)) {
        return "차대번호는 영문 대문자와 숫자로만 된 17자리여야 합니다.";
      }
    }

    if (widget.labelText == "닉네임") {
      if (input.length < 2 || input.length > 10) {
        return "닉네임은 2자 이상 10자 이하로 입력해주세요.";
      }
    }

    return null;
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
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
              fillColor: isFilled ? const Color(0xFFF5F5F5) : white,

              // ✅ 유효성에 따라 테두리 색상 변경
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: errorMessage != null ? pointRedColor : brandColor,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: errorMessage != null ? pointRedColor : brandColor,
                  width: 1,
                ),
              ),

              // ✅ error 상태일 때도 같은 스타일 유지
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: pointRedColor, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: pointRedColor, width: 1),
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
        ),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorMessage!,
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
      ],
    );
  }
}
