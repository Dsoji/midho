import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../res/app_colors.dart';

class CustomTextField extends HookWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon; // Now supports any widget, not just IconData
  final bool isPassword;
  final bool isOptional;
  final String? Function(String?)? validator;
  final VoidCallback? onSuffixTap;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.isOptional = false,
    this.validator,
    this.onSuffixTap,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final obscureText = useState(isPassword);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : AppColors.greyColor.shade700,
            )),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText.value,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: Colors.grey,
                    size: 21,
                  )
                : null,
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () => obscureText.value = !obscureText.value,
                  )
                : (suffixIcon != null
                    ? GestureDetector(
                        onTap: onSuffixTap, // Allow suffix tap action
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: suffixIcon,
                        ),
                      )
                    : null),
            hintText: hintText ?? "Enter $label",
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                width: 1,
                color: theme.brightness == Brightness.dark
                    ? AppColors.greyColor.shade50
                    : AppColors.secondaryColor.shade400,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                width: 1,
                color: theme.brightness == Brightness.dark
                    ? AppColors.greyColor.shade50
                    : AppColors.secondaryColor.shade400,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                width: 1,
                color: theme.brightness == Brightness.dark
                    ? AppColors.greyColor.shade50
                    : AppColors.secondaryColor.shade400,
              ),
            ),
            filled: true,
            fillColor: Colors.transparent,
          ),
          validator: validator,
        ),
      ],
    );
  }
}
