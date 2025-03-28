import 'package:flutter/material.dart';

class GasStationIcon extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const GasStationIcon({
    super.key,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Colors.black12,
              offset: Offset(0, 1),
            ),
          ],
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Icon(
            Icons.local_gas_station,
            color: isActive ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
