import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/screens/Insurance/InsuranceScreen.dart';
import 'package:marimo_client/screens/Insurance/widgets/InsuranceCalendar.dart';
import 'package:flutter/services.dart';  // TextInputFormatter를 위한 import 추가
import 'package:marimo_client/commons/CustomAppHeader.dart';  // CustomAppHeader 임포트 추가
import 'package:flutter_svg/flutter_svg.dart';  // SVG 패키지 추가
import 'package:flutter/services.dart';  // SystemChrome을 위한 import 추가

class InsuranceInfoScreen extends StatefulWidget {
  final String insuranceName;
  final String insuranceLogo;

  const InsuranceInfoScreen({
    super.key, 
    required this.insuranceName,
    required this.insuranceLogo,
  });

  @override
  State<InsuranceInfoScreen> createState() => _InsuranceInfoScreenState();
}

class _InsuranceInfoScreenState extends State<InsuranceInfoScreen> {
  final TextEditingController _distanceController = TextEditingController();
  final FocusNode _distanceFocusNode = FocusNode();
  
  // 날짜 저장을 위한 변수들 추가
  String _registrationDate = 'YYYY.MM.DD';
  String _insuranceStartDate = 'YYYY.MM.DD';
  String _insuranceEndDate = 'YYYY.MM.DD';

  // 3자리마다 콤마를 추가하는 TextInputFormatter
  static final _numberFormatter = FilteringTextInputFormatter.digitsOnly;
  
  // 보험료 컨트롤러 추가
  final TextEditingController _insuranceAmountController = TextEditingController();
  final FocusNode _insuranceAmountFocusNode = FocusNode();
  
  // 콤마가 포함된 문자열을 숫자로 변환
  String getCleanNumber(String text) {
    return text.replaceAll(',', '');
  }

  // 숫자에 콤마 추가d
  String addCommas(String text) {
    text = text.replaceAll(',', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && (text.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(text[i]);
    }
    return buffer.toString();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    
    // 포커스 리스너 추가
    _distanceFocusNode.addListener(() {
      if (!_distanceFocusNode.hasFocus) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  void dispose() {
    _distanceFocusNode.removeListener(() {});  // 리스너 제거
    _distanceFocusNode.dispose();
    _distanceController.dispose();
    _insuranceAmountFocusNode.removeListener(() {});
    _insuranceAmountFocusNode.dispose();
    _insuranceAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        leading: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: Center(
              child: SvgPicture.asset(
                'assets/images/icons/icon_back.svg',
                width: 18.sp,
                height: 18.sp,
                color: Colors.black,
              ),
            ),
          ),
        ),
        leadingWidth: 44.w,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '기본 ',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: '주행거리 정보',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4888FF),
                        ),
                      ),
                      TextSpan(
                        text: '를 입력해주세요.',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            widget.insuranceLogo,
                            width: 32.w,
                            height: 32.w,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            widget.insuranceName,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      _buildDateInput('최초 주행거리 등록일'),
                      SizedBox(height: 16.h),
                      _buildDistanceInput('최초 등록 주행거리'),
                      SizedBox(height: 16.h),
                      _buildDateInput('보험 개시일'),
                      SizedBox(height: 16.h),
                      _buildDateInput('보험 만기일'),
                      SizedBox(height: 16.h),
                      _buildInsuranceAmountInput('자동차 보험료'),  // 보험료 입력 필드 추가
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isAllFieldsFilled() 
                          ? () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const InsuranceScreen(isInsuranceRegistered: true),
                                ),
                                (route) => false,
                              );
                            }
                          : null,  // null이면 버튼이 비활성화됨
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4888FF),
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          // 비활성화 상태의 스타일 추가
                          disabledBackgroundColor: Colors.grey[300],
                        ),
                        child: Text(
                          '완료',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateInput(String label) {
    String getDateValue() {
      switch (label) {
        case '최초 주행거리 등록일':
          return _registrationDate;
        case '보험 개시일':
          return _insuranceStartDate;
        case '보험 만기일':
          return _insuranceEndDate;
        default:
          return 'YYYY.MM.DD';
      }
    }

    void updateDate(String formattedDate) {
      setState(() {
        switch (label) {
          case '최초 주행거리 등록일':
            _registrationDate = formattedDate;
            break;
          case '보험 개시일':
            _insuranceStartDate = formattedDate;
            break;
          case '보험 만기일':
            _insuranceEndDate = formattedDate;
            break;
        }
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            
            if (label == '보험 만기일' && _insuranceStartDate == 'YYYY.MM.DD') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('보험 개시일을 먼저 선택해주세요.'),
                  duration: const Duration(seconds: 2),
                ),
              );
              return;
            }

            DateTime? initialDate;
            if (label == '보험 만기일' && _insuranceStartDate != 'YYYY.MM.DD') {
              initialDate = DateTime.parse(_insuranceStartDate.replaceAll('.', '-'))
                  .add(const Duration(days: 365));
            } else {
              initialDate = DateTime.now();
            }

            showCustomCalendarPopup(
              context: context,
              initialDate: initialDate ?? DateTime.now(),
              minDate: label == '보험 만기일' && _insuranceStartDate != 'YYYY.MM.DD'
                  ? DateTime.parse(_insuranceStartDate.replaceAll('.', '-')).add(const Duration(days: 1))
                  : null,
              onDateSelected: (DateTime selectedDate) {
                final formattedDate = 
                    '${selectedDate.year}.${selectedDate.month.toString().padLeft(2, '0')}.${selectedDate.day.toString().padLeft(2, '0')}';
                updateDate(formattedDate);
              },
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  getDateValue(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: getDateValue() == 'YYYY.MM.DD' 
                        ? Colors.grey[400] 
                        : Colors.black,
                  ),
                ),
                Icon(Icons.calendar_today, size: 20.w, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDistanceInput(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: _distanceController,
          focusNode: _distanceFocusNode,
          autofocus: false,
          enableInteractiveSelection: true,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          maxLength: 9,  // 콤마를 포함한 최대 길이 (예: 999,999)
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
          ),
          inputFormatters: [
            _numberFormatter,
            TextInputFormatter.withFunction((oldValue, newValue) {
              // 숫자만 추출
              final cleanText = newValue.text.replaceAll(',', '');
              
              // 7자리 초과 검사
              if (cleanText.length > 7) {
                return oldValue;
              }
              
              // 9,999,999 초과 검사
              if (cleanText.isNotEmpty && int.parse(cleanText) > 9999999) {
                return oldValue;
              }
              
              // 콤마 추가
              final formatted = addCommas(cleanText);
              
              return TextEditingValue(
                text: formatted,
                selection: TextSelection.collapsed(offset: formatted.length),
              );
            }),
          ],
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            suffixText: 'Km',
            suffixStyle: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
            ),
            counterText: "",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInsuranceAmountInput(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: _insuranceAmountController,
          focusNode: _insuranceAmountFocusNode,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          maxLength: 11,  // 99,999,999 + 3개의 콤마
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            TextInputFormatter.withFunction((oldValue, newValue) {
              // 숫자만 추출
              final cleanText = newValue.text.replaceAll(',', '');
              
              // 8자리 초과 검사
              if (cleanText.length > 8) {
                return oldValue;
              }
              
              // 99,999,999 초과 검사
              if (cleanText.isNotEmpty && int.parse(cleanText) > 99999999) {
                return oldValue;
              }
              
              // 콤마 추가
              final formatted = addCommas(cleanText);
              
              return TextEditingValue(
                text: formatted,
                selection: TextSelection.collapsed(offset: formatted.length),
              );
            }),
          ],
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            suffixText: '원',
            suffixStyle: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
            ),
            counterText: "",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
      ],
    );
  }

  // API 요청 시 사용할 수 있는 메서드 수정
  String getInsuranceAmountForApi() {
    return getCleanNumber(_insuranceAmountController.text);
  }

  // 모든 필수 입력값이 입력되었는지 확인하는 메서드 수정
  bool isAllFieldsFilled() {
    return _registrationDate != 'YYYY.MM.DD' &&
        _insuranceStartDate != 'YYYY.MM.DD' &&
        _insuranceEndDate != 'YYYY.MM.DD' &&
        _distanceController.text.isNotEmpty &&
        _insuranceAmountController.text.isNotEmpty;  // 보험료 입력 확인 추가
  }
} 