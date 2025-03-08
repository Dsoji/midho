import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';

class ProviderPhoneInput extends HookWidget {
  final ValueNotifier<Map<String, String>> selectedProvider;
  final TextEditingController controller;
  final List<Map<String, String>> providers;

  const ProviderPhoneInput({
    super.key,
    required this.selectedProvider,
    required this.controller,
    required this.providers,
  });

  void _showProviderMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: 77.5,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: providers.map((provider) {
              final isSelected = provider == selectedProvider.value;

              return GestureDetector(
                onTap: () {
                  selectedProvider.value = provider;
                  Navigator.pop(context);
                },
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.orange, width: 2)
                            : null,
                      ),
                      child: ClipOval(
                        child:
                            Image.asset(provider['logo']!, fit: BoxFit.cover),
                      ),
                    ),
                    if (isSelected)
                      const Positioned(
                        top: 4,
                        right: 4,
                        child: CircleAvatar(
                          backgroundColor: Colors.orange,
                          radius: 10,
                          child:
                              Icon(Icons.check, color: Colors.white, size: 12),
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12), // Full rounded
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.transparent,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showProviderMenu(context),
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(selectedProvider.value['logo']!,
                      width: 30, height: 30),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.keyboard_arrow_down,
                    size: 18, color: Colors.grey),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 24,
            color: Colors.grey.shade300,
            margin: const EdgeInsets.symmetric(horizontal: 10),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Enter phone number",
                hintStyle: TextStyle(color: Colors.grey),
              ),
              keyboardType: TextInputType.phone,
            ),
          ),
          const Gap(8),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: () => controller.clear(),
              child: const Icon(Icons.clear, size: 18, color: Colors.black),
            ),
        ],
      ),
    );
  }
}
