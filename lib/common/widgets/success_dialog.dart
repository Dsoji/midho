import 'package:flutter/material.dart';

import '../res/app_colors.dart';
import 'custom_buttons.dart';

void showSuccessDialog({
  required BuildContext context,
  required String title,
  required List<Map<String, String>> details,
  required String buttonText,
  required VoidCallback onButtonPressed,
  required VoidCallback onSecondaryAction,
  Color primaryButtonColor = Colors.orange,
  Color backgroundColor = Colors.white,
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
            ? AppColors.secondaryColor.shade500
            : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 64,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
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
                              fontWeight: FontWeight.w500, fontFamily: ''),
                        ),
                        Text(
                          detail.values.first,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontFamily: ''),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              // View Transaction Details Button
              FullButton(
                text: buttonText,
                width: double.infinity,
                height: 48,
                onPressed: onButtonPressed,
                textColor: Colors.white,
                color: AppColors.primaryColor.shade500,
              ),
              FullButton(
                text: 'Make Another Purchase',
                width: double.infinity,
                height: 48,
                onPressed: () {
                  onSecondaryAction(); // Wait for action to complete
                },
                textColor: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                color: Colors.transparent,
              ),
            ],
          ),
        ),
      );
    },
  );
}
