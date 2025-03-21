import 'package:flutter/material.dart';

class CarInput extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;

  const CarInput({
    super.key,
    required this.controller,
    this.labelText = "차량 번호",
    this.hintText = "아이디를 입력해주세요.",
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
    return SizedBox(
      height: 50,
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: Color(0xFFBEBFC0),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          filled: isFilled,
          fillColor:
              isFilled
                  ? const Color(0xFFF5F5F5)
                  : const Color(0xFFFFFFFF), // ✅ 입력 완료 시 배경색 변경
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFBEBFC0), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFBEBFC0), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF19181D),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
