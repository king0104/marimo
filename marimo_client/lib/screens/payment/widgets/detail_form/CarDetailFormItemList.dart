// CarDetailFormItemList.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';
import 'package:marimo_client/models/payment/car_payment_entry.dart';
import 'CarDetailFormItem.dart';
import 'CarDetailFormSaveButton.dart';
import 'CarDetailFormMemo.dart';
import 'package:marimo_client/commons/CustomCalendar.dart'; // 달력 위젯 import
import 'package:marimo_client/commons/CustomDropdownList.dart';
import 'CarDetailFormRepairList.dart';

class CarDetailFormItemList extends StatefulWidget {
  final String category;
  final int amount;
  final bool isEditMode;
  final VoidCallback? onSaveComplete;

  const CarDetailFormItemList({
    Key? key,
    required this.category,
    required this.amount,
    this.isEditMode = true, // ✅ 기본값 true
    this.onSaveComplete,
  }) : super(key: key);

  @override
  State<CarDetailFormItemList> createState() => CarDetailFormItemListState();
}

class CarDetailFormItemListState extends State<CarDetailFormItemList> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _placeController = TextEditingController(); // 주유소/정비소/세차장
  final _typeController = TextEditingController(); // 유종/정비항목/세차유형
  final _memoController = TextEditingController();
  final LayerLink _dropdownLink = LayerLink(); // 드롭다운 포지션 고정용

  late DateTime _selectedDate;
  late CarPaymentProvider _provider;

  @override
  void initState() {
    super.initState();

    // initState에서는 Provider.of를 바로 사용할 수 없으므로
    // WidgetsBinding.instance.addPostFrameCallback를 사용
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = Provider.of<CarPaymentProvider>(context, listen: false);
      setState(() {
        // 프로바이더에서 선택된 날짜를 가져옴
        _selectedDate = _provider.selectedDate;
        _dateController.text = DateFormat('yyyy년 M월 d일').format(_selectedDate);
      });
    });

    // 기본값으로 현재 날짜 설정 (프로바이더 초기화 전에 필요)
    _selectedDate = DateTime.now();
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
    if (!widget.isEditMode) return;
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

          // 프로바이더에 선택된 날짜 저장
          _provider.setSelectedDate(_selectedDate);
        });
      },
    );
  }

  // 메모 페이지로 이동하는 함수
  void _navigateToMemoPage() async {
    if (!widget.isEditMode) return;
    // CarDetailFormMemo 페이지로 이동
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => CarDetailFormMemo(initialText: _memoController.text),
      ),
    );

    // 결과가 반환되면 (메모가 입력되었으면) 메모 컨트롤러에 값 설정
    if (result != null && result is String) {
      setState(() {
        _memoController.text = result;
      });
    }
  }

  void _showDropdownForParts() async {
    if (!widget.isEditMode) return;
    final List<String> partsList = ['일반 휘발유', '고급 휘발유', '경유', 'LPG'];
    await showDropdownList(
      context: context,
      items: partsList,
      selectedItem:
          _typeController.text.isNotEmpty ? _typeController.text : null,
      onItemSelected: (String selected) {
        setState(() {
          _typeController.text = selected;
        });
      },
      layerLink: _dropdownLink,
      width: 120,
      height: partsList.length * 40,
      offset: Offset(200, 45), // 선택하기 아래로 띄우기 위해 Y 오프셋 지정
    );
  }

  void _navigateToRepairList() async {
    final List<String> repairList = [
      '엔진 오일',
      '연료 필터',
      '변속기 오일',
      '에어클리너 필터',
      '냉각수',
      '타이어 교체',
      '와이퍼',
    ];

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CarDetailFormRepairList(repairItems: repairList),
      ),
    );

    setState(() {
      _typeController.text = _provider.selectedRepairItems.join(', ');
    });
  }

  // 카테고리별 장소 필드명 반환
  String _getPlaceFieldName() {
    switch (widget.category) {
      case '주유':
        return '주유소';
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
      default:
        return '유형';
    }
  }

  // 카테고리별 타입 힌트 텍스트 반환
  String _getTypeHintText() {
    final hasSelection = _provider.selectedRepairItems.isNotEmpty;
    switch (widget.category) {
      case '주유':
        return '선택하기';
      case '정비':
        return hasSelection ? _provider.selectedRepairItems.join(', ') : '선택하기';
      default:
        return '';
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
        isDateField: true, // 달력 아이콘 표시를 위해 true로 설정
        enabled: widget.isEditMode,
        showIconRight: widget.isEditMode,
      ),
    );

    // 2. 장소 항목 (주유소/정비소/장소)
    items.add(
      CarDetailFormItem(
        title: _getPlaceFieldName(),
        controller: _placeController,
        hintText: '장소를 입력하세요',
        isRequired: true,
        enabled: widget.isEditMode,
        showIconRight: false,
      ),
    );

    // 3. 유형 항목 (유종/부품/세차 유형) - 세차의 경우 부품 항목이 없음
    if (widget.category == '주유' || widget.category == '정비') {
      items.add(
        CompositedTransformTarget(
          link: widget.category == '주유' ? _dropdownLink : LayerLink(),
          child: CarDetailFormItem(
            title: _getTypeFieldName(),
            controller: _typeController,
            hintText: _getTypeHintText(),
            onTap:
                widget.isEditMode
                    ? (widget.category == '정비'
                        ? _navigateToRepairList
                        : _showDropdownForParts)
                    : null,
            showIconRight: widget.isEditMode,
            iconType: 'detail',
            enabled: widget.isEditMode,
          ),
        ),
      );
    }

    // 4. 메모 항목 (모든 카테고리 공통)
    items.add(
      CarDetailFormItem(
        title: '메모',
        controller: _memoController,
        hintText: '메모할 수 있어요 (최대 100자)',
        onTap: widget.isEditMode ? _navigateToMemoPage : null,
        maxLength: 100,
        showIconRight: widget.isEditMode,
        enabled: widget.isEditMode,
      ),
    );

    return items;
  }

  // 저장 전에 호출: 입력값들을 Provider에 반영
  void saveInputsToProvider() {
    _provider.setSelectedAmount(widget.amount);
    _provider.setSelectedDate(_selectedDate);
    _provider.setLocation(_placeController.text);
    _provider.setMemo(_memoController.text);
    if (widget.category == '주유') {
      _provider.setFuelType(_typeController.text);
    }

    print('📝 saveInputsToProvider 호출됨');
    print('📌 장소: ${_placeController.text}');
    print('📌 메모: ${_memoController.text}');
    if (widget.category == '주유') {
      print('📌 유종: ${_typeController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Consumer를 사용하여 프로바이더의 변경 사항 감지
    return Consumer<CarPaymentProvider>(
      builder: (context, provider, child) {
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
            ],
          ),
        );
      },
    );
  }
}
