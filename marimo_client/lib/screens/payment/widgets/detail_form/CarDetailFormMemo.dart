// CarDetailFormMemo.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarDetailFormMemo extends StatefulWidget {
  final String initialText;

  const CarDetailFormMemo({Key? key, this.initialText = ''}) : super(key: key);

  @override
  State<CarDetailFormMemo> createState() => _CarDetailFormMemoState();
}

class _CarDetailFormMemoState extends State<CarDetailFormMemo> {
  late TextEditingController _memoController;
  int _currentLength = 0;
  final int _maxLength = 100;

  @override
  void initState() {
    super.initState();
    _memoController = TextEditingController(text: widget.initialText);
    _currentLength = widget.initialText.length;

    // 텍스트 변경 리스너 추가
    _memoController.addListener(() {
      setState(() {
        _currentLength = _memoController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메모'),
        titleTextStyle: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // 저장 버튼
          TextButton(
            onPressed: () {
              // 입력된 메모 텍스트를 이전 화면으로 전달
              Navigator.pop(context, _memoController.text);
            },
            child: Text(
              '저장',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: TextField(
                controller: _memoController,
                maxLength: _maxLength,
                maxLines: null, // 여러 줄 입력 가능
                expands: true, // 사용 가능한 공간을 모두 채우도록
                textAlignVertical: TextAlignVertical.top,
                style: TextStyle(fontSize: 16.sp, color: Colors.black),
                decoration: InputDecoration(
                  hintText: '메모를 입력하세요',
                  hintStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8E8E8E),
                  ),
                  border: InputBorder.none,
                  counterText: '', // 기본 카운터 텍스트 숨기기
                ),
              ),
            ),
            // 커스텀 카운터 (100자 제한)
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                '$_currentLength/$_maxLength',
                style: TextStyle(
                  fontSize: 14.sp,
                  color:
                      _currentLength == _maxLength
                          ? Colors.red
                          : Color(0xFF8E8E8E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
