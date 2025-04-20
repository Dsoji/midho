import 'package:flutter/material.dart';

class SidePillShape extends StatelessWidget {
  const SidePillShape({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BulgeClipper(),
      child: Container(
        width: 40,
        height: 200,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }
}

class BulgeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    const double bulgeRadius = 20;

    path.moveTo(0, 0);
    path.arcToPoint(Offset(0, size.height),
        radius: Radius.circular(size.width / 2), clockwise: false);

    // Add bulge in the middle-right
    final double centerY = size.height / 2;
    const double bulgeHeight = 40;

    path.lineTo(size.width * 0.25, centerY - bulgeHeight / 2);
    path.quadraticBezierTo(
      size.width,
      centerY,
      size.width * 0.25,
      centerY + bulgeHeight / 2,
    );

    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
