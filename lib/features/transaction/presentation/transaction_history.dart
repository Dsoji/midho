import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/common/widgets/custom_buttons.dart';
import 'package:mdiho/features/transaction/data/controller/transaction_controller.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../crypto/presentation/crypto_screen.dart';
import 'widget/transaction_card.dart';

@RoutePage()
class TransactionHistoryScreen extends HookConsumerWidget {
  const TransactionHistoryScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionControllerProvider);
    final tabsRouter = AutoTabsRouter.of(context);

    useEffect(() {
      void listener() {
        if (tabsRouter.activeIndex != 3) {
          ref.read(transactionControllerProvider.notifier).getTransactions();
        }
      }

      tabsRouter.addListener(listener);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        listener();
      });

      return () {
        tabsRouter.removeListener(listener);
      };
    }, [tabsRouter]);

    return PopScope(
      canPop: false, // Prevent default back navigation
      onPopInvoked: (didPop) {
        if (!didPop) {
          final tabsRouter = AutoTabsRouter.of(
            context,
          );

          tabsRouter.setActiveIndex(0);
        }
      },

      child: Scaffold(
        appBar: CustomAppBar(
          title: "Transaction History",
          showBackButton: false,
          showTitle: true,
          showAction: true,
          centerTitle: true,
          onActionPressed: () => showFilterBottomSheet(context),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await ref
                .read(transactionControllerProvider.notifier)
                .getTransactions();
          },
          child: state.transactions.when(
            loading: () => state.transactions.maybeWhen(
              data: (transactions) => ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                itemCount: transactions.data?.length ?? 6,
                separatorBuilder: (_, __) => const Gap(8),
                itemBuilder: (context, index) {
                  if (transactions.data != null) {
                    final transaction = transactions.data![index];
                    return TransactionCard(transactions: transaction);
                  }
                  return const CryptoCardShimmer();
                },
              ),
              orElse: () => ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                itemCount: 6,
                separatorBuilder: (_, __) => const Gap(8),
                itemBuilder: (_, __) => const CryptoCardShimmer(),
              ),
            ),
            error: (error, _) => state.transactions.maybeWhen(
              data: (transactions) => ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                itemCount: transactions.data?.length ?? 0,
                separatorBuilder: (_, __) => const Gap(8),
                itemBuilder: (context, index) {
                  final transaction = transactions.data![index];
                  return TransactionCard(transactions: transaction);
                },
              ),
              orElse: () => Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Gap(52),
                      const Icon(Icons.info_outline,
                          color: Colors.grey, size: 48),
                      const SizedBox(height: 8),
                      Text(
                        "Failed to load transactions.",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            data: (transactions) {
              if (transactions.data == null || transactions.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Gap(52),
                      const Icon(Icons.info_outline,
                          color: Colors.grey, size: 48),
                      const SizedBox(height: 8),
                      Text(
                        "No transactions available.",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: transactions.data!.length,
                      separatorBuilder: (context, index) => const Gap(8),
                      itemBuilder: (context, index) {
                        final transaction = transactions.data![index];
                        return TransactionCard(transactions: transaction);
                      },
                    ),
                  ),
                  const Gap(85),
                ],
              );
            },
          ),
        ),
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

class FilterBottomSheet extends HookConsumerWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTransactionType = useState<String>("All");
    final selectedStatus = useState<String>("All");
    final selectedSortBy = useState<String>("Newest First");
    final fromDate = useState<String>("DD/MM/YY");
    final toDate = useState<String>("DD/MM/YY");
    final isLoading = useState<bool>(false);

    final theme = Theme.of(context);

    String? mapUiTypeToBackend(String type) {
      switch (type) {
        case "Gift Cards":
          return "GIFTCARDSALE";
        case "Crypto":
          return "CRYPTOSALE";
        case "Utilities":
          return "AIRTIMEBUY, INTERNETBUY, ELECTRICITYBUY, BETTINGBUY, CABLEBUY"; // let backend interpret this
        case "All":
        default:
          return null;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SingleChildScrollView(
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            _buildFilterCard(
              title: "Date Range",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(child: _buildDateField(context, "From", fromDate)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildDateField(context, "To", toDate)),
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
                    width: double.infinity,
                    height: 60,
                    onPressed: () async {
                      await ref
                          .read(transactionControllerProvider.notifier)
                          .getTransactions();
                      Navigator.of(context).pop();
                    },
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
                    text: isLoading.value ? 'Applying...' : 'Apply Filters',
                    width: double.infinity,
                    height: 60,
                    isLoading: isLoading.value,
                    onPressed: () async {
                      isLoading.value = true;
                      await ref
                          .read(transactionControllerProvider.notifier)
                          .getTransactions(
                            status: selectedStatus.value == "All"
                                ? null
                                : selectedStatus.value.toUpperCase(),
                            type: mapUiTypeToBackend(
                                selectedTransactionType.value),
                            sortKey: selectedSortBy.value.contains('Amount')
                                ? 'amount'
                                : 'createdAt',
                            sortOrder:
                                selectedSortBy.value.contains('Lowest') ||
                                        selectedSortBy.value.contains('Oldest')
                                    ? 'ASC'
                                    : 'DESC',
                            startDate: fromDate.value != "DD/MM/YY"
                                ? _formatDateForApi(fromDate.value)
                                : null,
                            endDate: toDate.value != "DD/MM/YY"
                                ? _formatDateForApi(toDate.value)
                                : null,
                          );
                      isLoading.value = false;
                      Navigator.of(context).pop();
                    },
                    textColor: Colors.white,
                    color: theme.brightness == Brightness.dark
                        ? AppColors.primaryColor.shade500
                        : Colors.black,
                  ),
                ),
              ],
            ),
            const Gap(75),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterCard({
    required String title,
    required Widget child,
    required BuildContext context,
  }) {
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
        final initialDate = DateTime.now().subtract(const Duration(days: 365));
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
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
            Text(
              dateValue.value,
              style: TextStyle(
                color:
                    dateValue.value == "DD/MM/YY" ? Colors.grey : Colors.black,
              ),
            ),
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

  String _formatDateForApi(String dateString) {
    final parts = dateString.split('/');
    final day = parts[0].padLeft(2, '0');
    final month = parts[1].padLeft(2, '0');
    final year = parts[2];
    return "$year-$month-${day}T00:00:00Z";
  }
}
