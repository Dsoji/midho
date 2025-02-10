import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomTextField extends HookWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText.value,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: Colors.grey)
                : null,
            suffixIcon: suffixIcon != null
                ? IconButton(
                    icon: Icon(
                      isPassword
                          ? (obscureText.value
                              ? Icons.visibility_off
                              : Icons.visibility)
                          : suffixIcon,
                      color: Colors.grey,
                    ),
                    onPressed: isPassword
                        ? () => obscureText.value = !obscureText.value
                        : onSuffixTap,
                  )
                : null,
            hintText: hintText ?? "Enter $label",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: validator,
        ),
      ],
    );
  }
}
