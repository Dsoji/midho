import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../../common/res/app_colors.dart';

class CustomDropdown extends HookWidget {
  final ValueChanged<String?> onChanged; // Callback to notify changes

  const CustomDropdown({
    super.key,
    required this.onChanged, // Required parameter
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField2<String>(
          value: null,
          isExpanded: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                width: 0.5,
                color: theme.brightness == Brightness.light
                    ? AppColors.greyColor.shade50
                    : AppColors.secondaryColor.shade400,
              ),
            ),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 250, // Limits dropdown height
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: theme.brightness == Brightness.dark
                  ? AppColors.secondaryColor.shade400
                  : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            elevation: 3, // Adds a floating effect
          ),
          onChanged: (value) {
            onChanged(value!); // Notify parent widget of the change
          },
          items: ["Nigeria"]
              .map((country) => DropdownMenuItem(
                    value: country,
                    child: Text(country),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
