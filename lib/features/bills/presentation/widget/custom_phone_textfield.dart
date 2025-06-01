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
      showModalBottomSheet(
        context: context,
        backgroundColor: theme.brightness == Brightness.dark
            ? AppColors.secondaryColor.shade700
            : const Color(0xFFF7F7F7),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Select Provider",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                dataPlans.when(
                  data: (plans) => ListView.separated(
                    shrinkWrap: true,
                    itemCount: plans.length,
                    separatorBuilder: (context, index) =>
                        Divider(color: Colors.grey.shade100),
                    itemBuilder: (context, index) {
                      final provider = plans[index];
                      final isSelected =
                          provider.name == selectedProvider.value.name;

                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(
                                    color: AppColors.primaryColor, width: 2)
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
                        title: Text(
                          provider.name ?? '',
                          style: TextStyle(
                            color: isSelected ? AppColors.primaryColor : null,
                            fontWeight: isSelected ? FontWeight.bold : null,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check,
                                color: AppColors.primaryColor)
                            : null,
                        onTap: () {
                          selectedProvider.value = (
                            name: provider.name ?? '',
                            logo: provider.logo ?? '',
                            products: provider.products ?? [],
                          );
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stack) => Center(
                    child: Text('Error: $error'),
                  ),
                ),
              ],
            ),
          );
        },
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
