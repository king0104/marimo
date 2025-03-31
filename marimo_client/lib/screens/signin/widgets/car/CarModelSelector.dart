import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marimo_client/theme.dart';

class CarModelSelector extends StatefulWidget {
  final List<String> models;
  final Function(String) onSelected;
  final String? initiallySelectedModel;

  const CarModelSelector({
    super.key,
    required this.models,
    required this.onSelected,
    this.initiallySelectedModel,
  });

  @override
  State<CarModelSelector> createState() => _CarModelSelectorState();
}

class _CarModelSelectorState extends State<CarModelSelector> {
  late String selectedModel;

  @override
  void initState() {
    super.initState();
    selectedModel = widget.initiallySelectedModel ?? "직접 입력";
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.models.length,
      separatorBuilder:
          (_, __) => const Divider(thickness: 0.2, height: 1, color: iconColor),
      itemBuilder: (context, index) {
        final model = widget.models[index];
        final isSelected = selectedModel == model;

        return ListTile(
          splashColor: brandColor.withAlpha(14),
          hoverColor: brandColor.withAlpha(14),
          title: Text(
            model,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              color: black,
            ),
          ),
          trailing:
              isSelected
                  ? SvgPicture.asset(
                    'assets/images/icons/icon_check.svg',
                    width: 20.w,
                    height: 20.h,
                  )
                  : null,
          onTap: () {
            setState(() {
              selectedModel = model;
            });
            widget.onSelected(model);
          },
          contentPadding: EdgeInsets.symmetric(horizontal: 18.w),
          minVerticalPadding: 18.h,
        );
      },
    );
  }
}
