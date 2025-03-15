import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../res/app_colors.dart';

class CustomTextField extends HookWidget {
  final TextEditingController controller;
  final String? label;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon; // Now supports any widget, not just IconData
  final bool isPassword;
  final bool isOptional;
  final String? Function(String?)? validator;
  final VoidCallback? onSuffixTap;
  final TextInputType keyboardType;
  final Color? fillColor;
  final double? borderRadius;
  final int? maxLines;
  final int? maxLength;

  const CustomTextField({
    super.key,
    this.maxLines = 1,
    this.maxLength,
    required this.controller,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.isOptional = false,
    this.validator,
    this.onSuffixTap,
    this.keyboardType = TextInputType.text,
    this.fillColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final obscureText = useState(isPassword);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null && label!.isNotEmpty)
          Text(label!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : AppColors.greyColor.shade700,
              )),
        const SizedBox(height: 8),
        SizedBox(
          height: maxLines == 1 ? 52 : null,
          child: TextFormField(
            controller: controller,
            obscureText: obscureText.value,
            keyboardType: keyboardType,
            maxLines: maxLines,
            maxLength: maxLength,
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
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 12),
                borderSide: BorderSide(
                  width: 0.5,
                  color: theme.brightness == Brightness.light
                      ? AppColors.greyColor.shade50
                      : AppColors.secondaryColor.shade400,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 12),
                borderSide: BorderSide(
                  width: 0.5,
                  color: theme.brightness == Brightness.light
                      ? AppColors.greyColor.shade50
                      : AppColors.secondaryColor.shade400,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 12),
                borderSide: BorderSide(
                  width: 0.5,
                  color: theme.brightness == Brightness.light
                      ? AppColors.greyColor.shade50
                      : AppColors.secondaryColor.shade400,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 12),
                borderSide: BorderSide(
                  width: 0.5,
                  color: theme.brightness == Brightness.light
                      ? AppColors.greyColor.shade50
                      : AppColors.secondaryColor.shade400,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 12),
                borderSide: BorderSide(
                  width: 0.5,
                  color: theme.brightness == Brightness.light
                      ? AppColors.greyColor.shade50
                      : AppColors.secondaryColor.shade400,
                ),
              ),
              filled: true,
              fillColor: fillColor ?? Colors.transparent,
              counterText: "", // Hides maxLength counter
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}
