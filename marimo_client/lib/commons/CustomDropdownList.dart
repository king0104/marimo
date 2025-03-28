// CustomDropdownList.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/theme.dart';

class DropdownList extends StatefulWidget {
  final List<String> items;
  final String? selectedItem;
  final Function(String) onItemSelected;
  final double width;
  final double height;
  final double itemHeight;
  final TextStyle? itemTextStyle;
  final LayerLink layerLink;
  final Offset offset;

  const DropdownList({
    Key? key,
    required this.items,
    required this.selectedItem,
    required this.onItemSelected,
    required this.layerLink,
    this.width = 73,
    this.height = 152,
    this.itemHeight = 0, // 기본값은 계산하도록 설정
    this.itemTextStyle,
    this.offset = const Offset(0, 45),
  }) : super(key: key);

  @override
  State<DropdownList> createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDropdown();
    });
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showDropdown() {
    final selectedItem = widget.selectedItem;
    final calculatedItemHeight =
        widget.itemHeight > 0
            ? widget.itemHeight
            : (widget.height - 24.h) / widget.items.length;

    _overlayEntry = OverlayEntry(
      builder:
          (context) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              _removeOverlay();
              Navigator.of(context).pop();
            },
            child: Stack(
              children: [
                Positioned(
                  width: widget.width.w,
                  height: widget.height.h,
                  child: CompositedTransformFollower(
                    link: widget.layerLink,
                    showWhenUnlinked: false,
                    offset: Offset(widget.offset.dx, widget.offset.dy.h),
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        // SizedBox로 감싸서 높이를 명확하게 제어
                        child: SizedBox(
                          height: widget.height.h,
                          child: Column(
                            // mainAxisAlignment 추가로 아이템들을 균등하게 배치
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:
                                widget.items.map((item) {
                                  final isSelected = selectedItem == item;
                                  return InkWell(
                                    onTap: () {
                                      widget.onItemSelected(item);
                                      _removeOverlay();
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      height: calculatedItemHeight,
                                      alignment: Alignment.center,
                                      child: Text(
                                        item,
                                        style:
                                            widget.itemTextStyle ??
                                            TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  isSelected
                                                      ? brandColor
                                                      : Colors.black,
                                            ),
                                      ),
                                    ),
                                  );
                                }).toList(),
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

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

// 드롭다운 리스트를 표시하는 함수
Future<void> showDropdownList({
  required BuildContext context,
  required List<String> items,
  required String? selectedItem,
  required Function(String) onItemSelected,
  required LayerLink layerLink,
  double width = 73,
  double height = 152,
  double itemHeight = 0,
  TextStyle? itemTextStyle,
  Offset offset = const Offset(0, 45),
}) async {
  await Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.transparent,
      pageBuilder: (BuildContext context, _, __) {
        return DropdownList(
          items: items,
          selectedItem: selectedItem,
          onItemSelected: onItemSelected,
          layerLink: layerLink,
          width: width,
          height: height,
          itemHeight: itemHeight,
          itemTextStyle: itemTextStyle,
          offset: offset,
        );
      },
    ),
  );
}
