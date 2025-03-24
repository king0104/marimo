import 'package:flutter/material.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Text(
          '필터 기능은 여기에 표시됩니다.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
