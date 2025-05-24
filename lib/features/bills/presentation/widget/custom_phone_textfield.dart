import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/res/app_colors.dart';
import '../../../transaction/data/controller/transaction_controller.dart';
import '../../data/model/response/data_tv_model/data_tv_model.dart';
import '../../data/model/response/data_tv_model/product.dart';

class DataProviderPhoneInput extends HookConsumerWidget {
  final ValueNotifier<({String name, String logo, List<Product>? products})>
      selectedProvider;
  final TextEditingController controller;
  final List<DataTvModel> providers;
  const DataProviderPhoneInput({
    super.key,
    required this.selectedProvider,
    required this.controller,
    required this.providers,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final theme = Theme.of(context);
    final dataPlans = ref.watch(transactionControllerProvider).dataPlans;
    //
    void showProviderMenu(BuildContext context) {
      final theme = Theme.of(context);
      showMenu(
        context: context,
        position: const RelativeRect.fromLTRB(0, 100, 0, 0),
        color: theme.brightness == Brightness.dark
            ? AppColors.secondaryColor.shade700
            : const Color(0xFFF7F7F7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        items: dataPlans.when(
          data: (plans) => plans.map((provider) {
            final isSelected = provider.name == selectedProvider.value.name;

            return PopupMenuItem(
              onTap: () {
                selectedProvider.value = (
                  name: provider.name ?? '',
                  logo: provider.logo ?? '',
                  products: provider.products ?? [],
                );
              },
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.orange, width: 2)
                          : null,
                    ),
                    child: ClipOval(
                      child: Image.network(
                        provider.logo ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    provider.name ?? '',
                    style: TextStyle(
                      color: isSelected ? Colors.orange : null,
                      fontWeight: isSelected ? FontWeight.bold : null,
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.check, color: Colors.orange, size: 16)
                  ],
                ],
              ),
            );
          }).toList(),
          loading: () => [],
          error: (_, __) => [],
        ),
      );
    }

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12), // Full rounded
        border: Border.all(color: Colors.grey.shade300, width: 0.2),
        color: theme.brightness == Brightness.dark
            ? AppColors.secondaryColor.shade700
            : Colors.transparent,
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => showProviderMenu(context),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(selectedProvider.value.logo),
                  backgroundColor: Colors.transparent,
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
