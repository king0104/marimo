import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';
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
  final Map<String, dynamic>? detailData;

  const CarDetailFormItemList({
    Key? key,
    required this.category,
    required this.amount,
    this.isEditMode = true, // 기본값 true
    this.onSaveComplete,
    this.detailData,
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

  @override
  void initState() {
    super.initState();
    // 기본값으로 현재 날짜 설정
    _selectedDate = DateTime.now();
    _dateController.text = DateFormat('yyyy년 M월 d일').format(_selectedDate);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Provider의 현재 상태로 각 컨트롤러 초기화 (편집 모드라면)
    final provider = Provider.of<CarPaymentProvider>(context);
    // 날짜: provider에 값이 있으면 적용 (날짜는 기본적으로 항상 있음)
    _selectedDate = provider.selectedDate;
    _dateController.text = DateFormat('yyyy년 M월 d일').format(_selectedDate);
    // 장소
    if (_placeController.text.isEmpty && provider.location.isNotEmpty) {
      _placeController.text = provider.location;
    }
    // 메모
    if (_memoController.text.isEmpty && provider.memo.isNotEmpty) {
      _memoController.text = provider.memo;
    }
    // 유형: 주유면 fuelType, 정비면 selectedRepairItems
    if (widget.category == '주유') {
      if (_typeController.text.isEmpty && provider.fuelType.isNotEmpty) {
        _typeController.text = provider.fuelType;
      }
    } else if (widget.category == '정비') {
      if (_typeController.text.isEmpty &&
          provider.selectedRepairItems.isNotEmpty) {
        _typeController.text = provider.selectedRepairItems.join(', ');
      }
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _placeController.dispose();
    _typeController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  // 달력 팝업 띄우기 함수
  Future<void> _selectDate() async {
    if (!widget.isEditMode) return;
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
        // Provider 업데이트
        Provider.of<CarPaymentProvider>(
          context,
          listen: false,
        ).setSelectedDate(_selectedDate);
      },
    );
  }

  // 메모 페이지 이동 함수
  void _navigateToMemoPage() async {
    if (!widget.isEditMode) return;
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => CarDetailFormMemo(initialText: _memoController.text),
      ),
    );
    if (result != null && result is String) {
      setState(() {
        _memoController.text = result;
      });
    }
  }

  // 드롭다운 목록 띄우기 함수 (예: 유종 선택)
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
      offset: Offset(200, 45),
    );
  }

  // 정비 항목 선택 페이지 이동 함수
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
    final provider = Provider.of<CarPaymentProvider>(context, listen: false);
    setState(() {
      _typeController.text = provider.selectedRepairItems.join(', ');
    });
  }

  // 카테고리에 따른 장소 필드명 반환
  String _getPlaceFieldName() {
    switch (widget.category) {
      case '주유':
        return '주유소';
      default:
        return '장소';
    }
  }

  // 카테고리에 따른 타입 필드명 반환
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

  // 카테고리에 따른 타입 힌트 텍스트 반환 (Provider 사용)
  String _getTypeHintText(CarPaymentProvider provider) {
    final hasSelection = provider.selectedRepairItems.isNotEmpty;
    switch (widget.category) {
      case '주유':
        return '선택하기';
      case '정비':
        return hasSelection ? provider.selectedRepairItems.join(', ') : '선택하기';
      default:
        return '';
    }
  }

  // 폼 아이템 목록 생성
  List<Widget> _buildFormItems(CarPaymentProvider provider) {
    final items = <Widget>[];

    items.add(
      CarDetailFormItem(
        title: '날짜',
        controller: _dateController,
        onTap: _selectDate,
        isDateField: true,
        enabled: widget.isEditMode,
        showIconRight: widget.isEditMode,
      ),
    );

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

    if (widget.category == '주유' || widget.category == '정비') {
      items.add(
        CompositedTransformTarget(
          link: widget.category == '주유' ? _dropdownLink : LayerLink(),
          child: CarDetailFormItem(
            title: _getTypeFieldName(),
            controller: _typeController,
            hintText: _getTypeHintText(provider),
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

  // Provider에 입력값들을 저장하는 함수 (저장 시 호출)
  void saveInputsToProvider() {
    final provider = Provider.of<CarPaymentProvider>(context, listen: false);
    provider.setSelectedAmount(widget.amount);
    provider.setSelectedDate(_selectedDate);
    provider.setLocation(_placeController.text);
    provider.setMemo(_memoController.text);
    if (widget.category == '주유') {
      provider.setFuelType(_typeController.text);
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
                    children: _buildFormItems(provider),
                  ),
                ),
              ),
              // 저장 버튼 등 추가 가능
            ],
          ),
        );
      },
    );
  }
}
