// CarPlusButton.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/commons/CustomDropdownList.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';
import 'package:marimo_client/screens/payment/CarPaymentInput.dart';
import 'package:provider/provider.dart';

class PlusButton extends StatefulWidget {
  const PlusButton({Key? key}) : super(key: key);

  @override
  State<PlusButton> createState() => _PlusButtonState();
}

class _PlusButtonState extends State<PlusButton> {
  final LayerLink _layerLink = LayerLink();
  final List<String> categories = ['주유', '정비', '세차'];

  void _showCategoryDropdown() {
    // 드롭다운 표시 함수 호출
    showDropdownList(
      context: context,
      items: categories,
      selectedItem: null, // 처음에는 선택된 항목 없음
      onItemSelected: (item) {
        // 선택한 카테고리를 Provider에 설정하고 화면 이동
        _selectCategoryAndNavigate(item);
      },
      layerLink: _layerLink,
      width: 100,
      height: 150,
      offset: Offset(-30.w - 12, -152 - 10), // 버튼 위로 10만큼 떨어진 위치에 표시
    );
  }

  // 카테고리 선택 및 화면 이동 함수를 분리
  void _selectCategoryAndNavigate(String category) {
    // Provider에 선택한 카테고리 설정
    final provider = Provider.of<CarPaymentProvider>(context, listen: false);
    provider.setSelectedCategory(category);

    // 드롭다운이 닫힌 뒤 다음 프레임에 화면 전환
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const CarPaymentInput()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _showCategoryDropdown,
        child: Container(
          width: 60.w,
          height: 60.w,
          decoration: const BoxDecoration(
            color: Color(0xFF4285F4),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}
