import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';

import '../res/app_colors.dart';

void showSuccessDialog({
  required BuildContext context,
  required String title,
  required List<Map<String, String>> details,
  required String buttonText,
  required VoidCallback onButtonPressed,
  required VoidCallback onSecondaryAction,
  Color primaryButtonColor = Colors.orange,
  Color backgroundColor = Colors.white,
  required String secondaryButtonText,
  String? info = 'transaction',
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final theme = Theme.of(context);

      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: theme.brightness == Brightness.dark
            ? AppColors.darkBorder
            : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.secondaryColor.shade700
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const GradientBorderCircle(
                      borderWidth: 4, // thickness
                      child: Icon(
                        HugeIcons.strokeRoundedDocumentValidation,
                        color: Colors.green,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: '',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: details.map((detail) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                detail.keys.first,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: ''),
                              ),
                              Text(
                                detail.values.first,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: ''),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    // View Transaction Details Button
                  ],
                ),
              ),
              const Gap(16),
              InfoWidget(
                  theme: theme,
                  text:
                      'The $info has been sent to your line and should reflect shortly.'),
              const Gap(16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor, // Orange button
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  onButtonPressed();

                  Navigator.pop(context);
                },
                child: Text(
                  buttonText,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const Gap(10),
              TextButton(
                onPressed: () {
                  onSecondaryAction();

                  Navigator.pop(context);
                },
                child: Text(
                  secondaryButtonText,
                  style: TextStyle(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class GradientBorderCircle extends StatelessWidget {
  final Widget child;
  final double size;
  final double borderWidth;

  const GradientBorderCircle({
    super.key,
    required this.child,
    this.size = 64,
    this.borderWidth = 4,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GradientBorderPainter(borderWidth: borderWidth),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  final double borderWidth;

  _GradientBorderPainter({required this.borderWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Paint paint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.green,
          Colors.green.shade900,
          Colors.transparent,
        ],
        startAngle: 0.0,
        endAngle: 3.14 * 2,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final double radius = (size.width / 2) - (borderWidth / 2);
    canvas.drawCircle(size.center(Offset.zero), radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
