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

class Obd2InfoList extends StatefulWidget {
  final VoidCallback? onToggleWidgets;
  const Obd2InfoList({super.key, this.onToggleWidgets});

  @override
  _Obd2InfoListState createState() => _Obd2InfoListState();
}

class _Obd2InfoListState extends State<Obd2InfoList> {
  bool showDtcInfo = true;
  int? selectedIndex;
  List<String> dtcCodes = [];

  @override
  void initState() {
    super.initState();
    _loadDtcCodes();
  }

  Future<void> _loadDtcCodes() async {
    final provider = context.read<ObdPollingProvider>();
    final fetchedCodes = await provider.fetchStoredDtcCodes();
    setState(() {
      dtcCodes = fetchedCodes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final responses = context.watch<ObdPollingProvider>().responses;
    final data = parseObdResponses(responses);

    final analysisProvider = context.read<ObdAnalysisProvider>();
    analysisProvider.analyze(data);
    final statusItems = context.watch<ObdAnalysisProvider>().statusItems;

    final isDtcEmpty = showDtcInfo && dtcCodes.isEmpty;

    return Container(
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
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent, // ✅ 빈 공간도 클릭되게
              onTap: widget.onToggleWidgets,
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 80.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: lightgrayColor,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h), // ✅ 아래 여백도 클릭 영역에 포함
                ],
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
                      builder: (context) => const Obd2DetailScreen(),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
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

          // 리스트 영역
          Expanded(
            child:
                isDtcEmpty
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 8.h,
                            left: 6.w,
                            right: 6.w,
                          ),
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
                            "그렇지만 만약 고장코드가 발생한다면,\n👇 고장코드를 다음과 같이 확인할 수 있어요. ",
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
                            description:
                                dtcDescriptions["P0219"] ?? "엔진 속도 초과 상태",
                            isSelected: selectedIndex == 999,
                            onTap: () {
                              setState(() {
                                selectedIndex =
                                    selectedIndex == 999 ? null : 999;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                    : ListView.builder(
                      padding: EdgeInsets.only(bottom: 32.h),
                      itemCount:
                          showDtcInfo ? dtcCodes.length : statusItems.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          child:
                              showDtcInfo
                                  ? (() {
                                    final code = dtcCodes[index];
                                    final desc =
                                        dtcDescriptions[code] ?? "알 수 없는 고장 코드";
                                    return DtcInfoCard(
                                      code: code,
                                      description: desc,
                                      isSelected: selectedIndex == index,
                                      onTap: () {
                                        setState(() {
                                          selectedIndex =
                                              selectedIndex == index
                                                  ? null
                                                  : index;
                                        });
                                      },
                                    );
                                  })()
                                  : StatusInfoCard(
                                    icon: statusItems[index].icon,
                                    title: statusItems[index].title,
                                    description: statusItems[index].description,
                                    status: statusItems[index].status,
                                  ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
