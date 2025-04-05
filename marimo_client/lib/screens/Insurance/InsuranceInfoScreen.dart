import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/screens/Insurance/InsuranceScreen.dart';
import 'package:marimo_client/screens/Insurance/widgets/InsuranceCalendar.dart';
import 'package:flutter/services.dart';  // TextInputFormatter를 위한 import 추가
import 'package:marimo_client/commons/CustomAppHeader.dart';  // CustomAppHeader 임포트 추가
import 'package:flutter_svg/flutter_svg.dart';  // SVG 패키지 추가
import 'package:flutter/services.dart';  // SystemChrome을 위한 import 추가
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_provider.dart';
import 'package:marimo_client/providers/member/auth_provider.dart';
import 'package:marimo_client/services/insurance/Insurance_service.dart';

class InsuranceInfoScreen extends StatefulWidget {
  final String insuranceName;    // 화면 표시용 한글 이름
  final String insuranceCode;    // API 요청용 영문 코드
  final String insuranceLogo;

  const InsuranceInfoScreen({
    super.key, 
    required this.insuranceName,
    required this.insuranceCode,  // 추가
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
  
  // 로딩 상태 추가
  bool _isLoading = false;

  // totalDistance 저장 변수 추가
  int? _maxDistance;

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
    
    // 차량 정보 로드
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final accessToken = context.read<AuthProvider>().accessToken;
        if (accessToken != null) {
          await context.read<CarProvider>().fetchCarsFromServer(accessToken);
          
          // 디버깅을 위한 로그 추가
          final carProvider = context.read<CarProvider>();
          final cars = carProvider.cars;
          final firstCarId = carProvider.firstCarId;  // firstCarId 사용
          
          print('📱 Fetched cars length: ${cars.length}');
          print('📱 First car ID: $firstCarId');

          // totalDistance 가져오기
          final firstCar = carProvider.cars.firstOrNull;
          if (firstCar != null) {
            setState(() {
              _maxDistance = firstCar.totalDistance;
            });
          }
        }
      } catch (e) {
        print('🚨 Error fetching cars: $e');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('차량 정보를 불러오는데 실패했습니다: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
    
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
                      _buildDateInput('보험 개시일'),
                      SizedBox(height: 16.h),
                      _buildDateInput('보험 만기일'),
                      SizedBox(height: 16.h),
                      _buildDateInput('최초 주행거리 등록일'),
                      SizedBox(height: 16.h),
                      _buildDistanceInput('최초 등록 주행거리'),
                      SizedBox(height: 16.h),
                      _buildInsuranceAmountInput('자동차 보험료'),
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
                        // isAllFieldsFilled()가 true이고 로딩 중이 아닐 때만 활성화
                        onPressed: (isAllFieldsFilled() && !_isLoading) 
                          ? () async {
                              setState(() {
                                _isLoading = true;  // 로딩 시작
                              });
                              
                              try {
                                // Provider에서 필요한 정보 가져오기
                                final carId = context.read<CarProvider>().firstCarId;  // firstCarId 사용
                                final accessToken = context.read<AuthProvider>().accessToken;

                                print('Debug - carId: $carId, accessToken: $accessToken');
                                print('Debug - Cars list: ${context.read<CarProvider>().cars}');

                                if (carId == null || accessToken == null) {
                                  print('Debug - Car or token is null');
                                  throw Exception("차량 정보를 찾을 수 없습니다");
                                }

                                // 거리와 보험료에서 콤마 제거
                                final cleanDistance = getCleanNumber(_distanceController.text);
                                final cleanAmount = getCleanNumber(_insuranceAmountController.text);

                                print('🚨 Debug - API Request Data:');
                                final requestData = {
                                  'carId': carId,
                                  'insuranceCompanyName': widget.insuranceCode,
                                  'startDate': _formatToDateTime(_insuranceStartDate),
                                  'endDate': _formatToDateTime(_insuranceEndDate, isEndDate: true),
                                  'distanceRegistrationDate': _formatToDateTime(_registrationDate),
                                  'registeredDistance': int.parse(cleanDistance),
                                  'insurancePremium': int.parse(cleanAmount),
                                };
                                print(requestData);

                                // 보험 등록 API 호출
                                await InsuranceService.registerInsurance(
                                  carId: carId,
                                  accessToken: accessToken,
                                  insuranceCompanyName: widget.insuranceCode,
                                  startDate: _formatToDateTime(_insuranceStartDate),
                                  endDate: _formatToDateTime(_insuranceEndDate, isEndDate: true),
                                  distanceRegistrationDate: _formatToDateTime(_registrationDate),
                                  registeredDistance: int.parse(cleanDistance),
                                  insurancePremium: int.parse(cleanAmount),
                                );

                                if (!mounted) return;

                                // 성공 시 화면 이동
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const InsuranceScreen(),
                                  ),
                                  (route) => false,
                                );
                              } catch (e) {
                                print('🚨 Error in insurance registration: $e'); // 에러 로그 추가
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('보험 등록 중 오류가 발생했습니다: $e')),
                                );
                              } finally {
                                if (mounted) {
                                  setState(() {
                                    _isLoading = false;  // 로딩 종료
                                  });
                                }
                              }
                            }
                          : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4888FF),
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          disabledBackgroundColor: Colors.grey[300],
                        ),
                        child: _isLoading
                          ? SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
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
          return _registrationDate;  // 기본값 자동 설정 제거
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
                const SnackBar(
                  content: Text('보험 개시일을 먼저 선택해주세요.'),
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }

            if (label == '최초 주행거리 등록일' && _insuranceStartDate == 'YYYY.MM.DD') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('보험 개시일을 먼저 선택해주세요.'),
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }

            DateTime? initialDate;

            if (label == '보험 만기일' && _insuranceStartDate != 'YYYY.MM.DD') {
              initialDate = DateTime.parse(_insuranceStartDate.replaceAll('.', '-'))
                  .add(const Duration(days: 365));
            } else if (label == '최초 주행거리 등록일' && _insuranceStartDate != 'YYYY.MM.DD') {
              // 캘린더의 초기값으로만 보험 개시일 + 15일 설정
              final startDate = DateTime.parse(_insuranceStartDate.replaceAll('.', '-'));
              initialDate = startDate.add(const Duration(days: 15));
            } else {
              initialDate = DateTime.now();
            }

            showCustomCalendarPopup(
              context: context,
              initialDate: initialDate ?? DateTime.now(),
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
        if (_maxDistance != null) ...[
          SizedBox(height: 4.h),
          Text(
            '현재 총 주행거리: ${addCommas(_maxDistance.toString())}km',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
        SizedBox(height: 8.h),
        TextField(
          controller: _distanceController,
          focusNode: _distanceFocusNode,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          maxLength: 9,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
          ),
          inputFormatters: [
            _numberFormatter,
            TextInputFormatter.withFunction((oldValue, newValue) {
              // 숫자만 추출
              final cleanText = newValue.text.replaceAll(',', '');
              
              // 빈 문자열 체크
              if (cleanText.isEmpty) {
                return newValue;
              }
              
              // 숫자로 변환
              final number = int.tryParse(cleanText);
              if (number == null) {
                return oldValue;
              }
              
              // totalDistance 체크
              if (_maxDistance != null && number > _maxDistance!) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('현재 총 주행거리(${addCommas(_maxDistance.toString())}km)보다 큰 값은 입력할 수 없습니다.'),
                    duration: const Duration(seconds: 2),
                  ),
                );
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

  // 날짜 형식 변환 메서드 추가
  String _formatToDateTime(String date, {bool isEndDate = false}) {
    final parts = date.split('.');
    final time = isEndDate ? "23:59:59" : "00:00:00";
    return "${parts[0]}-${parts[1].padLeft(2, '0')}-${parts[2].padLeft(2, '0')}T$time";
  }
} 