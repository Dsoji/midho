import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({
    super.key,
    this.icon,
    this.imagePath,
    required this.index,
    required this.onTap,
    required this.color,
    required this.label,
  });

  final IconData? icon; // Icon can be nullable now
  final String? imagePath; // New field for image
  final Color color;
  final String label;
  final int index;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 24,
                color: color,
              )
            else if (imagePath != null)
              Image.asset(
                imagePath!,
                height: 24,
                width: 24,
                color: color, // Optional: apply color tint
              ),
            const Gap(4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(color: color, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
