import 'package:flutter/material.dart';

class CarWashIcon extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const CarWashIcon({super.key, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 44,
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
            Icons.cleaning_services,
            color: isActive ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
