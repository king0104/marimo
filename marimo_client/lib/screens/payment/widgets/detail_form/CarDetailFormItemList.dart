// CarDetailFormItemList.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';
import 'package:marimo_client/models/payment/car_payment_entry.dart';
import 'CarDetailFormItem.dart';
import 'CarDetailFormSaveButton.dart';
import 'package:marimo_client/commons/CustomCalendar.dart'; // 달력 위젯 import

class CarDetailFormItemList extends StatefulWidget {
  final String category;
  final int amount;

  const CarDetailFormItemList({
    Key? key,
    required this.category,
    required this.amount,
  }) : super(key: key);

  @override
  State<CarDetailFormItemList> createState() => _CarDetailFormItemListState();
}

class _CarDetailFormItemListState extends State<CarDetailFormItemList> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _placeController = TextEditingController(); // 주유소/정비소/세차장
  final _typeController = TextEditingController(); // 유종/정비항목/세차유형
  final _memoController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy년 M월 d일').format(_selectedDate);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _placeController.dispose();
    _typeController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  // 달력 팝업을 띄우는 함수
  Future<void> _selectDate() async {
    // 커스텀 달력 팝업 표시
    await showCustomCalendarPopup(
      context: context,
      initialDate: _selectedDate,
      onDateSelected: (DateTime date) {
        setState(() {
          _selectedDate = date;
          _dateController.text = DateFormat(
            'yyyy년 M월 d일',
          ).format(_selectedDate);
        });
      },
    );
  }

  void _saveAndNavigate() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<CarPaymentProvider>(context, listen: false);

      // 새 데이터 생성
      final entry = CarPaymentEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        category: widget.category,
        amount: widget.amount,
        date: _selectedDate,
        details: {
          'place': _placeController.text,
          'type': _typeController.text,
          'memo': _memoController.text,
        },
      );

      // 데이터 저장
      provider.addEntry(entry);

      // 이전 화면으로 돌아가기
      Navigator.of(context).pop();
    }
  }

  // 카테고리별 장소 필드명 반환
  String _getPlaceFieldName() {
    switch (widget.category) {
      case '주유':
        return '주유소';
      case '정비':
        return '정비소';
      case '세차':
        return '장소';
      default:
        return '장소';
    }
  }

  // 카테고리별 타입 필드명 반환
  String _getTypeFieldName() {
    switch (widget.category) {
      case '주유':
        return '유종';
      case '정비':
        return '부품';
      case '세차':
        return '세차 유형';
      default:
        return '유형';
    }
  }

  // 카테고리별 타입 힌트 텍스트 반환
  String _getTypeHintText() {
    switch (widget.category) {
      case '주유':
        return '휘발유';
      case '정비':
        return '엔진오일';
      case '세차':
        return '셀프세차';
      default:
        return '';
    }
  }

  // 카테고리별 메모 힌트 텍스트 반환
  String _getMemoHintText() {
    switch (widget.category) {
      case '주유':
        return '주유할 수 있어요 (최대 20자)';
      case '정비':
        return '메모할 수 있어요 (최대 20자)';
      case '세차':
        return '메모할 수 있어요 (최대 20자)';
      default:
        return '메모할 수 있어요 (최대 20자)';
    }
  }

  // 카테고리별 폼 아이템 목록 생성
  List<Widget> _buildFormItems() {
    final items = <Widget>[];

    // 1. 날짜 항목 (모든 카테고리 공통)
    items.add(
      CarDetailFormItem(
        title: '날짜',
        controller: _dateController,
        onTap: _selectDate,
      ),
    );

    // 2. 장소 항목 (주유소/정비소/장소)
    items.add(
      CarDetailFormItem(
        title: _getPlaceFieldName(),
        controller: _placeController,
        hintText: '직접 입력하세요',
        isRequired: true,
      ),
    );

    // 3. 유형 항목 (유종/부품/세차 유형) - 세차의 경우 부품 항목이 없음
    if (widget.category == '주유' || widget.category == '정비') {
      items.add(
        CarDetailFormItem(
          title: _getTypeFieldName(),
          controller: _typeController,
          hintText: _getTypeHintText(),
        ),
      );
    }

    // 4. 메모 항목 (모든 카테고리 공통)
    items.add(
      CarDetailFormItem(
        title: '메모',
        controller: _memoController,
        hintText: _getMemoHintText(),
        maxLength: 20,
      ),
    );

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildFormItems(),
              ),
            ),
          ),

          // 분리된 저장 버튼 컴포넌트 사용
          CarDetailFormSaveButton(onPressed: _saveAndNavigate),
        ],
      ),
    );
  }
}
