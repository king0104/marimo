// InstructionItemList.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'InstructionItem.dart';

class InstructionItemList extends StatelessWidget {
  const InstructionItemList({Key? key}) : super(key: key);

  // 타이어 아이템 리스트 정의
  static final List<InstructionItem> instructionItems = [
    InstructionItem(
      imagePath: 'assets/images/tires/tire_right.png',
      isGood: true,
    ),
    InstructionItem(
      imagePath: 'assets/images/tires/tire_wrong_1.png', // .svg에서 .png로 변경
      isGood: false,
    ),
    InstructionItem(
      imagePath: 'assets/images/tires/tire_wrong_2.png', // .svg에서 .png로 변경
      isGood: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildInstructionItemWidgets(),
        ),
      ),
    );
  }

  // 타이어 아이템 위젯 리스트 생성 메서드
  List<Widget> _buildInstructionItemWidgets() {
    final List<Widget> itemWidgets = [];
    
    for (int i = 0; i < instructionItems.length; i++) {
      // 아이템 위젯 추가
      itemWidgets.add(
        InstructionItemWidget(item: instructionItems[i])
      );
      
      // 마지막 아이템이 아니면 간격 추가
      if (i < instructionItems.length - 1) {
        itemWidgets.add(SizedBox(width: 16.w));
      }
    }
    
    return itemWidgets;
  }
}