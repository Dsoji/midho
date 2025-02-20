import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/common/res/assets.dart';
import 'package:mdiho/common/widgets/custom_textfield.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../common/widgets/custom_buttons.dart';
import '../../home/presentation/widget/wallet_balance_card.dart';
import 'widget/bank_info_card.dart';

class WithdrawFundsScreen extends HookConsumerWidget {
  const WithdrawFundsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isBalanceVisible = ref.watch(balanceVisibilityProvider);
    final amountController = useTextEditingController();
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Withdraw Funds",
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
              'Transfer your wallet balance securely to your bank account. Check bank network status before proceeding.',
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
                    'Available Balance',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  const Gap(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        isBalanceVisible ? "₦950,0000" : "••••••••",
                        style: TextStyle(
                          color: theme.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 29,
                          fontWeight: FontWeight.w600,
                          fontFamily: '',
                        ),
                      ),
                      const Gap(8),
                      Container(
                        width: 21,
                        height: 21,
                        decoration: ShapeDecoration(
                          color: theme.brightness == Brightness.dark
                              ? AppColors.secondaryColor.shade400
                              : AppColors.whiteColor.shade50,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        child: GestureDetector(
                          onTap: () => ref
                              .read(balanceVisibilityProvider.notifier)
                              .toggleVisibility(),
                          child: Icon(
                            isBalanceVisible
                                ? IconsaxPlusLinear.eye
                                : IconsaxPlusLinear.eye_slash,
                            size: 12,
                            color: theme.brightness == Brightness.dark
                                ? Colors.white54
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(24),
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
                    image: PlaceholderAssets.gtbank,
                    name: 'GT Bank',
                    color: AppColors.primaryColor.shade500,
                    status: 'Poor Network',
                    percentage: '90',
                    actNumber: '1210125678',
                    actName: 'John Doe',
                  ),
                  const Gap(24),
                  InfoWidget(
                    theme: theme,
                    text:
                        'Select a bank with good network status for faster processing.',
                  ),
                  const Gap(24),
                  CustomTextField(
                    controller: amountController,
                    label: "Amount",
                    // Optional
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const Gap(24),
                  InfoWidget(
                    theme: theme,
                    text:
                        'Enter an amount less than or equal to your wallet balance.',
                  ),
                  const Gap(24),
                  FullButton(
                    text: "Continue",
                    width: double.infinity,
                    height: 48,
                    onPressed: () {
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const NaviBar()));
                    },
                    textColor: Colors.white,
                    color: AppColors.primaryColor.shade500,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoWidget extends StatelessWidget {
  const InfoWidget({
    super.key,
    required this.theme,
    required this.text,
  });

  final ThemeData theme;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: theme.brightness == Brightness.dark
            ? AppColors.secondaryColor.shade400
            : const Color(0xFFF6F6F9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            IconsaxPlusLinear.info_circle,
            size: 16,
          ),
          const Gap(8),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
