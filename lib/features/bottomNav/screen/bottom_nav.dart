import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({
    super.key,
    required this.icon,
    required this.index,
    required this.onTap,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;
  final int index;
  final void Function()? onTap; // Make final and properly typed

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(size: 24, icon, color: color),
            const Gap(4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(color: color, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}
