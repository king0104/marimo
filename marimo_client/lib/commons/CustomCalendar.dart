// CarPaymentCalendar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marimo_client/theme.dart';

Future<void> showCustomCalendarPopup({
  required BuildContext context,
  required DateTime initialDate,
  required Function(DateTime) onDateSelected,
}) async {
  // 초기 선택 날짜를 initialDate로 설정 (null로 시작하지 않음)
  DateTime selectedDate = initialDate;
  DateTime currentViewDate = initialDate;
  final DateTime today = DateTime.now();

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        backgroundColor: Colors.transparent,
        child: StatefulBuilder(
          builder: (context, setState) {
            // 이전 달로 이동하는 함수
            void previousMonth() {
              setState(() {
                currentViewDate = DateTime(
                  currentViewDate.year,
                  currentViewDate.month - 1,
                  1,
                );
              });
            }

            // 다음 달로 이동하는 함수
            void nextMonth() {
              setState(() {
                currentViewDate = DateTime(
                  currentViewDate.year,
                  currentViewDate.month + 1,
                  1,
                );
              });
            }

            return Container(
              width: double.infinity,
              height: 331.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 11.8,
                    spreadRadius: 4,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1.w,
                  ),
                ),
                color: Colors.white,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 월/년도 선택 헤더
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: SvgPicture.asset(
                              'assets/images/icons/icon_calendar_left.svg',
                              width: 6.w,
                              height: 10.w,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(
                              minWidth: 24.w,
                              minHeight: 24.w,
                            ),
                            onPressed: previousMonth,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildMonthDropdown(
                                  context,
                                  currentViewDate,
                                  selectedDate ?? today,
                                  (newMonth) {
                                    setState(() {
                                      currentViewDate = DateTime(
                                        currentViewDate.year,
                                        newMonth,
                                        1,
                                      );
                                    });
                                  },
                                ),
                                SizedBox(width: 8.w),
                                _buildYearDropdown(
                                  context,
                                  currentViewDate,
                                  selectedDate ?? today,
                                  (newYear) {
                                    setState(() {
                                      currentViewDate = DateTime(
                                        newYear,
                                        currentViewDate.month,
                                        1,
                                      );
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: SvgPicture.asset(
                              'assets/images/icons/icon_calendar_right.svg',
                              width: 6.w,
                              height: 10.w,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(
                              minWidth: 24.w,
                              minHeight: 24.w,
                            ),
                            onPressed: nextMonth,
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children:
                            ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'].map((
                              day,
                            ) {
                              final isSunday = day == 'Su';
                              return Expanded(
                                child: Center(
                                  child: Text(
                                    day,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          isSunday
                                              ? Colors.red[300]
                                              : Colors.grey[600],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                      Expanded(
                        child: _buildFixedCalendarGrid(
                          currentViewDate,
                          today,
                          selectedDate,
                          (newDate) {
                            setState(() {
                              selectedDate = newDate;
                            });
                          },
                        ),
                      ),
                      // 여백 조정: 위 여백 제거, 아래 여백 12
                      // 버튼 섹션만 수정
                      Padding(
                        padding: EdgeInsets.only(bottom: 0), // 아래 여백 제거
                        child: // 버튼 부분만 수정
                            Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // 닫기 버튼 수정
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                                minimumSize: Size.zero, // 최소 크기 제한 제거
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 8.h,
                                ), // 패딩으로 크기 제어
                                tapTargetSize:
                                    MaterialTapTargetSize
                                        .shrinkWrap, // 탭 영역 줄이기
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.27.r),
                                ),
                              ),
                              child: SizedBox(
                                width: 33.w, // 확인 버튼과 동일한 너비 지정
                                child: Center(
                                  child: Text(
                                    '닫기',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            // 확인 버튼
                            ElevatedButton(
                              onPressed: () {
                                // 날짜가 선택되지 않았다면 오늘 날짜를 반환
                                onDateSelected(selectedDate ?? today);
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                minimumSize: Size.zero, // 최소 크기 제한 제거
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 8.h,
                                ), // 패딩으로 크기 제어
                                tapTargetSize:
                                    MaterialTapTargetSize
                                        .shrinkWrap, // 탭 영역 줄이기
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.27.r),
                                ),
                                elevation: 0,
                              ),
                              child: SizedBox(
                                width: 33.w, // 명시적 너비 지정
                                child: Center(
                                  child: Text(
                                    '확인',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

// 월 드롭다운 위젯
Widget _buildMonthDropdown(
  BuildContext context,
  DateTime currentDate,
  DateTime selectedDate,
  Function(int) onMonthSelected,
) {
  final LayerLink _monthLayerLink = LayerLink();

  return CustomDropdown(
    layerLink: _monthLayerLink,
    value: _getMonthName(currentDate.month),
    options: _getMonthList(),
    selectedIndex: selectedDate.month - 1,
    onSelected: (value) {
      final index = _getMonthList().indexOf(value);
      if (index >= 0) {
        onMonthSelected(index + 1);
      }
    },
    width: 50.w, // 너비 좁힘
  );
}

// 연도 드롭다운 위젯
Widget _buildYearDropdown(
  BuildContext context,
  DateTime currentDate,
  DateTime selectedDate,
  Function(int) onYearSelected,
) {
  final LayerLink _yearLayerLink = LayerLink();
  final yearList = _getYearList();
  final selectedIndex = yearList.indexOf(selectedDate.year);

  return CustomDropdown(
    layerLink: _yearLayerLink,
    value: currentDate.year.toString(),
    options: yearList.map((e) => e.toString()).toList(),
    selectedIndex:
        selectedIndex >= 0 ? selectedIndex : yearList.indexOf(currentDate.year),
    onSelected: (value) {
      final year = int.tryParse(value);
      if (year != null) {
        onYearSelected(year);
      }
    },
    width: 50.w, // 너비 좁힘
  );
}

// 커스텀 드롭다운 위젯
class CustomDropdown extends StatefulWidget {
  final LayerLink layerLink;
  final String value;
  final List<String> options;
  final int selectedIndex;
  final Function(String) onSelected;
  final double width;

  const CustomDropdown({
    Key? key,
    required this.layerLink,
    required this.value,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
    required this.width,
  }) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  OverlayEntry? _overlayEntry;
  final ScrollController _scrollController = ScrollController();

  void _toggleDropdown() {
    if (_overlayEntry != null) {
      _removeOverlay();
      return;
    }
    _showOverlay();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay() {
    _overlayEntry = OverlayEntry(
      builder:
          (context) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _removeOverlay,
            child: Stack(
              children: [
                Positioned(
                  width: widget.width,
                  child: CompositedTransformFollower(
                    link: widget.layerLink,
                    showWhenUnlinked: false,
                    offset: Offset(0, 25.h), // 텍스트에 더 가깝게 배치
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        height: 150.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9.41.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            // 드롭다운이 표시될 때 선택된 항목이 중앙에 위치하도록 스크롤 위치 계산
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (widget.selectedIndex >= 0 &&
                                  _scrollController.hasClients) {
                                final itemHeight = 30.h;
                                final scrollPosition =
                                    (widget.selectedIndex * itemHeight) -
                                    (constraints.maxHeight / 2) +
                                    (itemHeight / 2);

                                _scrollController.jumpTo(
                                  scrollPosition.clamp(
                                    0,
                                    _scrollController.position.maxScrollExtent,
                                  ),
                                );
                              }
                            });

                            return ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              itemCount: widget.options.length,
                              itemExtent: 30.h, // 각 항목 높이 고정
                              itemBuilder: (context, index) {
                                final option = widget.options[index];
                                final isSelected = option == widget.value;

                                return InkWell(
                                  onTap: () {
                                    widget.onSelected(option);
                                    _removeOverlay();
                                  },
                                  child: Container(
                                    height: 30.h,
                                    alignment: Alignment.center,
                                    color:
                                        isSelected
                                            ? Colors.grey[200]
                                            : Colors.white,
                                    child: Text(
                                      option,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            isSelected
                                                ? brandColor
                                                : Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  void dispose() {
    _removeOverlay();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: widget.layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.value,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 7.w),
            SvgPicture.asset(
              'assets/images/icons/icon_calendar_down.svg',
              width: 8.w,
              height: 5.h,
            ),
          ],
        ),
      ),
    );
  }
}

// _buildFixedCalendarGrid 함수 수정
Widget _buildFixedCalendarGrid(
  DateTime currentViewDate,
  DateTime today,
  DateTime? selectedDate,
  Function(DateTime) onSelectDate,
) {
  final daysInMonth =
      DateTime(currentViewDate.year, currentViewDate.month + 1, 0).day;
  final firstDayOfMonth =
      DateTime(currentViewDate.year, currentViewDate.month, 1).weekday;
  final firstDayPosition = firstDayOfMonth % 7;

  List<List<DateTime?>> calendarDays = List.generate(
    6,
    (_) => List.filled(7, null),
  );

  int day = 1;
  for (int week = 0; week < 6; week++) {
    for (int dayOfWeek = 0; dayOfWeek < 7; dayOfWeek++) {
      if (week == 0 && dayOfWeek < firstDayPosition) {
        calendarDays[week][dayOfWeek] = null;
      } else if (day <= daysInMonth) {
        calendarDays[week][dayOfWeek] = DateTime(
          currentViewDate.year,
          currentViewDate.month,
          day,
        );
        day++;
      } else {
        calendarDays[week][dayOfWeek] = null;
      }
    }
  }

  return Column(
    children:
        calendarDays.map((week) {
          return Expanded(
            child: Row(
              children:
                  week.asMap().entries.map((entry) {
                    final dayOfWeek = entry.key;
                    final date = entry.value;

                    if (date == null) {
                      return Expanded(child: Container());
                    }

                    // 날짜가 선택되었는지 확인
                    final isSelectedDay =
                        selectedDate != null &&
                        date.day == selectedDate.day &&
                        date.month == selectedDate.month &&
                        date.year == selectedDate.year;

                    // 오늘 날짜인지 확인
                    final isToday =
                        date.day == today.day &&
                        date.month == today.month &&
                        date.year == today.year;

                    // 오늘 또는 오늘 이후 날짜인지 확인
                    final todayDate = DateTime(
                      today.year,
                      today.month,
                      today.day,
                    );
                    final currentDate = DateTime(
                      date.year,
                      date.month,
                      date.day,
                    );
                    final isBeforeToday = currentDate.isBefore(todayDate);
                    final isFuture = currentDate.isAfter(todayDate);

                    // 선택 가능한 날짜인지 확인 (오늘 포함 이전 날짜만 선택 가능)
                    final isSelectable = !currentDate.isAfter(todayDate);

                    // 선택된 날짜가 없으면 오늘 날짜를 강조표시, 선택된 날짜가 있으면 그 날짜를 강조표시
                    final shouldHighlight =
                        isSelectedDay || (selectedDate == null && isToday);

                    final isSunday = dayOfWeek == 0;

                    // 선택된 일요일 또는 일요일인지 체크
                    final isSelectedSunday = isSunday && isSelectedDay;

                    return Expanded(
                      child: GestureDetector(
                        onTap: isSelectable ? () => onSelectDate(date) : null,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            // InkWell 추가해서 터치 피드백 제공
                            splashColor: Colors.transparent, // 스플래시 효과 없애기
                            highlightColor: Colors.transparent, // 하이라이트 효과 없애기
                            // 터치 영역을 최대한 확장
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              margin: EdgeInsets.all(2.w), // 약간의 여백 추가
                              decoration:
                                  shouldHighlight
                                      ? BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2.w,
                                        ),
                                      )
                                      : null,
                              child: Center(
                                child: Text(
                                  date.day.toString(),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight:
                                        isSelectedSunday
                                            ? FontWeight.w600
                                            : (shouldHighlight
                                                ? FontWeight.w600
                                                : FontWeight.w400),
                                    color:
                                        shouldHighlight
                                            ? (isSunday
                                                ? Colors.red[300]
                                                : Colors.black)
                                            : (isFuture
                                                ? Colors.grey[400] // 미래 날짜는 회색
                                                : (isSunday
                                                    ? Colors
                                                        .red[300] // 일요일은 빨간색
                                                    : Colors
                                                        .black)), // 과거 날짜는 검정색
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          );
        }).toList(),
  );
}

List<String> _getMonthList() {
  return [
    '1월',
    '2월',
    '3월',
    '4월',
    '5월',
    '6월',
    '7월',
    '8월',
    '9월',
    '10월',
    '11월',
    '12월',
  ];
}

String _getMonthName(int month) {
  return _getMonthList()[month - 1];
}

// 연도 리스트 생성 함수 수정 - 1990년부터 현재까지
List<int> _getYearList() {
  final currentYear = DateTime.now().year;
  final yearCount = currentYear - 1990 + 1; // 1990부터 현재 연도까지 포함
  return List.generate(yearCount, (index) => 1990 + index);
}
