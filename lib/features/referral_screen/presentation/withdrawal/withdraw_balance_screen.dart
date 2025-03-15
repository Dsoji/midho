import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/withdrawal/presentation/enter_pin.dart';

import '../../../../common/res/app_colors.dart';
import '../../../../common/res/assets.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/custom_buttons.dart';
import '../../../../common/widgets/custom_textfield.dart';
import '../../../withdrawal/presentation/widget/bank_info_card.dart';
import '../../../withdrawal/presentation/withdraw_funds_screen.dart';

final selectedBankProvider =
    StateProvider<Map<String, dynamic>?>((ref) => null);

@RoutePage()
class WithdrawReferallScreen extends HookConsumerWidget {
  const WithdrawReferallScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedBank = ref.watch(selectedBankProvider);
    final amountController = useTextEditingController();

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Withdraw Referral Balance",
        showBackButton: true,
        showTitle: true,
        showAction: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Transfer referral earnings to your local bank.',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            const Gap(16),
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: ShapeDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade500
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Bank Account',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  const Gap(8),
                  BankInfoCard(
                    image: selectedBank?["image"] ?? PlaceholderAssets.gtbank,
                    name: selectedBank?["name"] ?? 'GT Bank',
                    color: selectedBank?["color"] ??
                        AppColors.primaryColor.shade500,
                    status: selectedBank?["status"] ?? 'Poor Network',
                    percentage: selectedBank?["percentage"] ?? '90',
                    actNumber: selectedBank?["actNumber"] ?? '1210125678',
                    actName: selectedBank?["actName"] ?? 'John Doe',
                    onTap: () => _showAddBankDetailsSheet(context),
                  ),
                  const Gap(24),
                  CustomTextField(
                    controller: amountController,
                    label: "Amount",
                    // Optional
                    keyboardType: TextInputType.number,
                  ),
                  const Gap(24),
                  FullButton(
                    text: "Continue",
                    width: double.infinity,
                    height: 48,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TransactionPinScreen(
                                    isHome: false,
                                  )));
                    },
                    textColor: Colors.white,
                    color: AppColors.primaryColor.shade500,
                  ),
                ],
              ),
            ),
            const Gap(150),
          ],
        ),
      ),
    );
  }

  void _showAddBankDetailsSheet(BuildContext context) {
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
      builder: (context) => const AddBankScreen(),
    );
  }
}
