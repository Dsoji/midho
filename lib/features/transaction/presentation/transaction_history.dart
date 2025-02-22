import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/common/widgets/custom_buttons.dart';
import 'package:mdiho/features/transaction/presentation/widget/transaction_card.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';

class TransactionHistory extends HookConsumerWidget {
  const TransactionHistory({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = [
      {
        "icon": IconsaxPlusLinear.arrow_down_1,
        "title": "Crypto Sale",
        "date": "Jan 15, 2025",
        "amount": 500000.00,
        "status": "Completed",
        "statusColor": Colors.green,
      },
      {
        "icon": IconsaxPlusLinear.arrow_up,
        "title": "Gift Card Purchase",
        "date": "Jan 10, 2025",
        "amount": 120000.00,
        "status": "Pending",
        "statusColor": Colors.orange,
      },
      {
        "icon": IconsaxPlusLinear.arrow_down_1,
        "title": "Bill Payment",
        "date": "Jan 5, 2025",
        "amount": 30000.00,
        "status": "Failed",
        "statusColor": Colors.red,
      },
    ];
    return Scaffold(
      appBar: CustomAppBar(
        title: "Transaction History",
        showBackButton: true,
        showTitle: true,
        showAction: true,
        centerTitle: true,
        onActionPressed: () => showFilterBottomSheet(context),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: transactions.length,
        separatorBuilder: (context, index) => const Gap(8),
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return TransactionCard(
            icon: transaction["icon"] as IconData,
            title: transaction["title"] as String,
            date: transaction["date"] as String,
            amount: transaction["amount"] as double,
            status: transaction["status"] as String,
            statusColor: transaction["statusColor"] as Color,
          );
        },
      ),
    );
  }

  void showFilterBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.brightness == Brightness.dark
          ? AppColors.secondaryColor.shade700
          : AppColors.scaffoldColorLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      builder: (context) => const FilterBottomSheet(),
    );
  }
}

class FilterBottomSheet extends HookWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTransactionType = useState<String>("All");
    final selectedStatus = useState<String>("All");
    final selectedSortBy = useState<String>("Newest First");
    final fromDate = useState<String>("DD/MM/YY");
    final toDate = useState<String>("DD/MM/YY");
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade500
                    : Colors.grey.shade300,
              ),
            ),
          ),
          const Gap(10),
          const Text(
            "Filters",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildFilterCard(
            title: "Date Range",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: _buildDateField(context, "From", fromDate),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDateField(context, "To", toDate),
                ),
              ],
            ),
            context: context,
          ),
          const SizedBox(height: 8),
          _buildFilterCard(
            title: "Transaction Type",
            child: _buildRadioGroup(
              ["All", "Gift Cards", "Utilities", "Crypto"],
              selectedTransactionType,
            ),
            context: context,
          ),
          const SizedBox(height: 8),
          _buildFilterCard(
            title: "Status",
            child: _buildRadioGroup(
              ["All", "Completed", "Pending", "Failed"],
              selectedStatus,
            ),
            context: context,
          ),
          const SizedBox(height: 8),
          _buildFilterCard(
            title: "Sort By",
            child: _buildRadioGroup(
              [
                "Newest First",
                "Oldest First",
                "Lowest Amount",
                "Highest Amount"
              ],
              selectedSortBy,
            ),
            context: context,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: FullButton(
                  text: 'Clear Filters',
                  width: 173,
                  height: 60,
                  onPressed: () {},
                  textColor: theme.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  color: theme.brightness == Brightness.dark
                      ? AppColors.secondaryColor.shade500
                      : Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FullButton(
                  text: 'Apply Filters',
                  width: 173,
                  height: 60,
                  onPressed: () {},
                  textColor: Colors.white,
                  color: theme.brightness == Brightness.dark
                      ? AppColors.primaryColor.shade500
                      : Colors.black,
                ),
              ),
            ],
          ),
          const Gap(34),
        ],
      ),
    );
  }

  Widget _buildFilterCard(
      {required String title,
      required Widget child,
      required BuildContext context}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? AppColors.secondaryColor.shade500
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildDateField(
      BuildContext context, String label, ValueNotifier<String> dateValue) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (pickedDate != null) {
          dateValue.value =
              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(dateValue.value),
            const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioGroup(
      List<String> options, ValueNotifier<String> selectedValue) {
    return Wrap(
      spacing: 12,
      children: options.map((option) {
        return GestureDetector(
          onTap: () => selectedValue.value = option,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<String>(
                value: option,
                groupValue: selectedValue.value,
                onChanged: (value) => selectedValue.value = value!,
                activeColor: AppColors.primaryColor.shade500,
              ),
              Text(option),
            ],
          ),
        );
      }).toList(),
    );
  }
}
