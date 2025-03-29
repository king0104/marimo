import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/theme.dart';
import 'package:marimo_client/commons/CustomAppHeader.dart';

class CarPaymentMemo extends StatefulWidget {
  final Function(String) onSave;
  final String initialValue;

  const CarPaymentMemo({Key? key, required this.onSave, this.initialValue = ''})
    : super(key: key);

  @override
  State<CarPaymentMemo> createState() => _CarPaymentMemoState();
}

class _CarPaymentMemoState extends State<CarPaymentMemo> {
  final TextEditingController _memoController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final int _maxLength = 20;

  @override
  void initState() {
    super.initState();
    // 초기값 설정
    _memoController.text = widget.initialValue;

    // 화면이 표시되면 자동으로 키보드 표시
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _memoController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // CustomAppHeader 사용
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: Stack(
          children: [
            // CustomAppHeader 배치
            CustomAppHeader(
              title: '메모',
              onBackPressed: () => Navigator.pop(context),
            ),

            // 완료 버튼을 오른쪽에 배치
            Positioned(
              top: MediaQuery.of(context).padding.top + 20.h,
              right: 16.w,
              child: GestureDetector(
                onTap: () {
                  widget.onSave(_memoController.text);
                  Navigator.pop(context);
                },
                child: Text(
                  '완료',
                  style: TextStyle(
                    color: brandColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: TextField(
                controller: _memoController,
                focusNode: _focusNode,
                maxLength: _maxLength,
                decoration: InputDecoration(
                  hintText: '메모를 입력해주세요',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16.sp,
                  ),
                  border: InputBorder.none,
                  counterText: '', // 기본 카운터 제거
                ),
                style: TextStyle(color: Colors.black, fontSize: 16.sp),
                onChanged: (value) {
                  setState(() {}); // 텍스트 변경 시 UI 업데이트
                },
              ),
            ),
          ),

          // 카운터를 오른쪽 하단에 별도로 표시
          Padding(
            padding: EdgeInsets.only(right: 20.w, bottom: 10.h),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                '${_memoController.text.length}/$_maxLength',
                style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
