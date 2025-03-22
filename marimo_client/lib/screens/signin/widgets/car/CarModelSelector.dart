import 'package:flutter/material.dart';
import 'package:marimo_client/theme.dart'; // brandColor 등

class CarModelSelector extends StatefulWidget {
  final List<String> models;
  final Function(String) onSelected;

  const CarModelSelector({
    super.key,
    required this.models,
    required this.onSelected,
  });

  @override
  State<CarModelSelector> createState() => _CarModelSelectorState();
}

class _CarModelSelectorState extends State<CarModelSelector> {
  String selectedModel = "직접 입력"; // 기본 선택값

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // 부모 스크롤에 맡김
      itemCount: widget.models.length,
      separatorBuilder:
          (_, __) => const Divider(thickness: 0.2, height: 1, color: iconColor),
      itemBuilder: (context, index) {
        final model = widget.models[index];
        final isSelected = selectedModel == model;

        return ListTile(
          title: Text(
            model,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          trailing:
              isSelected
                  ? Image.asset(
                    'assets/images/icons/icon_selected.png',
                    width: 20,
                    height: 20,
                  )
                  : null,
          onTap: () {
            setState(() {
              selectedModel = model;
            });
            widget.onSelected(model);
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 18),
          minVerticalPadding: 18,
        );
      },
    );
  }
}
