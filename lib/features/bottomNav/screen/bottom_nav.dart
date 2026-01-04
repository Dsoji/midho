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
    this.isSmallScreen = false,
  });

  final IconData? icon; // Icon can be nullable now
  final String? imagePath; // New field for image
  final Color color;
  final String label;
  final int index;
  final void Function()? onTap;
  final bool isSmallScreen;

  @override
  Widget build(BuildContext context) {
    final iconSize = isSmallScreen ? 20.0 : 24.0;
    final fontSize = isSmallScreen ? 10.0 : 12.0;
    final padding = isSmallScreen ? 4.0 : 8.0;
    final gapSize = isSmallScreen ? 2.0 : 4.0;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: iconSize,
                color: color,
              )
            else if (imagePath != null)
              Image.asset(
                imagePath!,
                height: iconSize,
                width: iconSize,
                color: color, // Optional: apply color tint
              ),
            Gap(gapSize),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
