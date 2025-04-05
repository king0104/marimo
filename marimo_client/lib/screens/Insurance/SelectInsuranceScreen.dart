import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/screens/Insurance/InsuranceInfoScreen.dart';
import 'package:flutter_svg/flutter_svg.dart';  // SVG 패키지 추가
import 'package:flutter/services.dart';  // SystemChrome을 위한 import 추가

class SelectInsuranceScreen extends StatefulWidget {
  static const List<Map<String, dynamic>> insuranceCompanies = [
    {
      'name': 'AXA손해보험',
      'logo': 'assets/images/insurance/image_axa.png',
      'code': 'axa'
    },
    {
      'name': 'DB손해보험',
      'logo': 'assets/images/insurance/image_db.png',
      'code': 'db'
    },
    {
      'name': 'KB손해보험',
      'logo': 'assets/images/insurance/image_kb.png',
      'code': 'kb'
    },
    {
      'name': 'MG손해보험',
      'logo': 'assets/images/insurance/image_mg.png',
      'code': 'mg'
    },
    {
      'name': '롯데손해보험',
      'logo': 'assets/images/insurance/image_lotte.png',
      'code': 'lotte'
    },
    {
      'name': '메리츠화재',
      'logo': 'assets/images/insurance/image_meritz.png',
      'code': 'meritz'
    },
    {
      'name': '삼성화재',
      'logo': 'assets/images/insurance/image_samsung.png',
      'code': 'samsung'
    },
    {
      'name': '캐롯손해보험',
      'logo': 'assets/images/insurance/image_carrot.png',
      'code': 'carrot'
    },
    {
      'name': '하나손해보험',
      'logo': 'assets/images/insurance/image_hana.png',
      'code': 'hana'
    },
    {
      'name': '한화손해보험',
      'logo': 'assets/images/insurance/image_hanhwa.png',
      'code': 'hanwha'
    },
    {
      'name': '현대해상',
      'logo': 'assets/images/insurance/image_hyundai.png',
      'code': 'hyundai'
    },
    {
      'name': '흥국화재',
      'logo': 'assets/images/insurance/image_heungkuk.png',
      'code': 'heungkuk'
    },
  ];

  const SelectInsuranceScreen({super.key});

  @override
  State<SelectInsuranceScreen> createState() => _SelectInsuranceScreenState();
}

class _SelectInsuranceScreenState extends State<SelectInsuranceScreen> {
  int? selectedIndex;  // 선택된 보험사 인덱스

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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '보험사',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4888FF),
                    ),
                  ),
                  TextSpan(
                    text: '를 선택해주세요.',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            Expanded(
              child: ListView.separated(
                itemCount: SelectInsuranceScreen.insuranceCompanies.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final isSelected = selectedIndex == index;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF4888FF).withOpacity(0.1) : Colors.white,
                        border: Border.all(color: Colors.grey[200]!),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            SelectInsuranceScreen.insuranceCompanies[index]['logo']!,
                            width: 32.w,
                            height: 32.w,
                          ),
                          SizedBox(width: 16.w),
                          Text(
                            SelectInsuranceScreen.insuranceCompanies[index]['name']!,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedIndex != null 
                      ? () {
                          final selected = SelectInsuranceScreen.insuranceCompanies[selectedIndex!];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InsuranceInfoScreen(
                                insuranceName: selected['name']!,
                                insuranceCode: selected['code']!,
                                insuranceLogo: selected['logo']!,
                              ),
                            ),
                          );
                        }
                      : null,  // 선택되지 않았을 때는 null
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedIndex != null 
                          ? const Color(0xFF4888FF)
                          : Colors.grey[300],
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      '다음',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: selectedIndex != null ? Colors.white : Colors.grey[500],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 