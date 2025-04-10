import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/screens/monitoring/Obd2DetailScreen.dart';
import 'package:marimo_client/screens/monitoring/widgets/DtcInfoCard.dart';
import 'package:marimo_client/screens/monitoring/widgets/StatusInfoCard.dart';
import 'package:marimo_client/screens/monitoring/widgets/ListToggle.dart';
import 'package:marimo_client/theme.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/obd_polling_provider.dart';
import 'package:marimo_client/providers/obd_analysis_provider.dart';
import 'package:marimo_client/utils/obd_response_parser.dart';
import 'package:marimo_client/constants/obd_dtcs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Obd2InfoList extends StatefulWidget {
  final VoidCallback? onToggleWidgets;
  const Obd2InfoList({super.key, this.onToggleWidgets});

  @override
  _Obd2InfoListState createState() => _Obd2InfoListState();
}

class _Obd2InfoListState extends State<Obd2InfoList> {
  bool isLoadingDtc = true;
  bool showDtcInfo = true;
  bool isExpanded = false;
  bool isListScrolling = false;
  int? selectedIndex;
  List<String> dtcCodes = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDtcCodes();
      _analyzeObdData();
      // saveTestDtcCodesOnce();
    });
  }

  void _analyzeObdData() {
    final responses = context.read<ObdPollingProvider>().responses;
    final data = parseObdResponses(responses);
    context.read<ObdAnalysisProvider>().analyze(data);
  }

  Future<void> _loadDtcCodes() async {
    final provider = context.read<ObdPollingProvider>();

    try {
      setState(() => isLoadingDtc = true); // ✅ 로딩 시작
      await Future.delayed(const Duration(seconds: 1));

      List<String> fetchedCodes;

      if (provider.isConnected) {
        fetchedCodes = await provider.fetchStoredDtcCodes();
      } else {
        fetchedCodes = await provider.loadDtcCodesFromLocal();
      }

      setState(() {
        dtcCodes = fetchedCodes;
      });
    } catch (e) {
      debugPrint('❌ DTC 코드 로딩 실패: $e');
    } finally {
      setState(() => isLoadingDtc = false); // ✅ 로딩 끝
    }
  }

  // // Obd2InfoList.dart
  // Future<void> saveTestDtcCodesOnce() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   const key = 'stored_dtc_codes'; // ✅ 이 키로 저장
  //   final testDtcCodes = [
  //     'P007E',
  //     'B0024',
  //     'P3007',
  //     'U2902',
  //     'C0300',
  //     'C3EA0',
  //     'P2430',
  //     'P07EB',
  //     'P0243',
  //   ];
  //   await prefs.setStringList(key, testDtcCodes);
  //   debugPrint('✅ 테스트 DTC 코드 저장 완료: $testDtcCodes');
  // }

  @override
  Widget build(BuildContext context) {
    final responses = context.watch<ObdPollingProvider>().responses;
    final data = parseObdResponses(responses);

    final statusItems = context.watch<ObdAnalysisProvider>().statusItems;

    final isDtcEmpty = showDtcInfo && dtcCodes.isEmpty;

    return // 추가할 상태 변수
    Listener(
      behavior: HitTestBehavior.translucent,
      onPointerMove: (event) {
        // 리스트 스크롤 중에는 이벤트 무시
        if (isListScrolling) return;

        if (event.delta.dy < -5 && !isExpanded) {
          setState(() => isExpanded = true);
          widget.onToggleWidgets?.call();
        } else if (event.delta.dy > 5 && isExpanded) {
          setState(() => isExpanded = false);
          widget.onToggleWidgets?.call();
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 80.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.r),
            topRight: Radius.circular(8.r),
          ),
          border: Border.all(color: const Color(0xFFD7D7D7), width: 0.2),
          boxShadow: [
            BoxShadow(
              color: const Color(0x1A000000),
              blurRadius: 3.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() => isExpanded = !isExpanded);
                widget.onToggleWidgets?.call();
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(bottom: 12.h),
                child: Center(
                  child: Container(
                    width: 80.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: lightgrayColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 180.w,
                  child: ListToggle(
                    isLeftSelected: showDtcInfo,
                    onLeftTap: () => setState(() => showDtcInfo = true),
                    onRightTap: () => setState(() => showDtcInfo = false),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Obd2DetailScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.h,
                      horizontal: 8.w,
                    ),
                    child: Text(
                      "OBD2 상세",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF747474),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollStartNotification) {
                    setState(() => isListScrolling = true);
                  } else if (notification is ScrollEndNotification) {
                    setState(() => isListScrolling = false);
                  }
                  return true; // 이벤트 전파 방지
                },
                child: GestureDetector(
                  onVerticalDragUpdate: (_) {},
                  child:
                      isLoadingDtc
                          ? const Center(
                            child: CircularProgressIndicator(color: brandColor),
                          ) // ✅ 스피너
                          : isDtcEmpty
                          ? _buildNoDtcWidget()
                          : ListView.builder(
                            padding: EdgeInsets.only(bottom: 32.h),
                            itemCount:
                                showDtcInfo
                                    ? dtcCodes.length
                                    : statusItems.length,
                            itemBuilder:
                                (context, index) => Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.h),
                                  child:
                                      showDtcInfo
                                          ? _buildDtcCard(index)
                                          : StatusInfoCard(
                                            icon: statusItems[index].icon,
                                            title: statusItems[index].title,
                                            description:
                                                statusItems[index].description,
                                            status: statusItems[index].status,
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

  Widget _buildNoDtcWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8.h, left: 6.w, right: 6.w),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "차량에 고장코드가 없어요.\n",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: backgroundBlackColor,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
                TextSpan(
                  children: [
                    TextSpan(
                      text: "자동차가 매우 ",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: backgroundBlackColor,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                    TextSpan(
                      text: "건강한 상태",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: brandColor,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                    TextSpan(
                      text: "입니다! 🤗",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: backgroundBlackColor,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 28.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Text(
            "그렇지만 만약 고장코드가 발생한다면,\n👇 고장코드를 다음과 같이 확인할 수 있어요.",
            style: TextStyle(
              fontSize: 14.sp,
              color: iconColor,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: DtcInfoCard(
            code: "P0219",
            description: dtcDescriptions["P0219"] ?? "엔진 속도 초과 상태",
            isSelected: selectedIndex == 999,
            onTap: () {
              setState(() {
                selectedIndex = selectedIndex == 999 ? null : 999;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDtcCard(int index) {
    final code = dtcCodes[index];
    final desc = dtcDescriptions[code] ?? "알 수 없는 고장 코드";
    return DtcInfoCard(
      code: code,
      description: desc,
      isSelected: selectedIndex == index,
      onTap: () {
        setState(() {
          selectedIndex = selectedIndex == index ? null : index;
        });
      },
    );
  }
}
