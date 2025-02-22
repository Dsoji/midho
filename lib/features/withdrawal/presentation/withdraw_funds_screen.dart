import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/common/res/assets.dart';
import 'package:mdiho/common/widgets/custom_textfield.dart';
import 'package:mdiho/features/withdrawal/presentation/enter_pin.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../common/widgets/custom_buttons.dart';
import '../../bank_network/presentation/bank_network_screen.dart';
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
                    onTap: () => _showAddBankDetailsSheet(context),
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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const TransactionPinScreen()));
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

class AddBankScreen extends HookWidget {
  const AddBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> bankList = [
      {
        "name": "GTBank",
        "image": PlaceholderAssets.gtbank, // Use 'image' instead of 'logo'
        "status": "Poor Network",
        "percentage": "49%", // Ensure this is a String
        "color": Colors.red,
        "actNumber": "1234 5678 9012", // Add this field
        "actName": "Savings Account", // Add this field
      },
      {
        "name": "UBA",
        "image": PlaceholderAssets.uba,
        "status": "Fair Network",
        "percentage": "55%",
        "color": Colors.amber,
        "actNumber": "5678 9012 3456",
        "actName": "Checking Account",
      },
      {
        "name": "Opay",
        "image": PlaceholderAssets.opay,
        "status": "Good Network",
        "percentage": "92%",
        "color": Colors.green,
        "actNumber": "9012 3456 7890",
        "actName": "Business Account",
      },
    ];
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
          const Center(
            child: Text(
              "Linked Bank Accounts",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Gap(23),
          const NetworkStatusIndicator(),
          const Gap(16),
          SizedBox(
            height: 248,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: bankList.length,
              separatorBuilder: (context, index) =>
                  const Gap(10), // Space between cards
              itemBuilder: (context, index) {
                final bank = bankList[index];

                return BankInfoCard(
                  image: bank["image"] ??
                      "assets/default.png", // Use a default image if null
                  name: bank["name"] ?? "Unknown Bank",
                  color: bank["color"] ?? Colors.grey,
                  status: bank["status"] ?? "No Status",
                  percentage: bank["percentage"] ?? "0%",
                  actNumber: bank["actNumber"] ?? "N/A",
                  actName: bank["actName"] ?? "N/A",
                  showBorder: false,
                  icon: Icons.more_horiz,
                  onTap: () {
                    final GlobalKey<State<StatefulWidget>> globalKey =
                        GlobalKey();
                    _showPopupMenu(context, globalKey);
                  },
                );
              },
            ),
          ),
          const Gap(150),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const WithdrawFundsScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor.shade500,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: const Text(
                "Add New Bank Account",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          const Gap(50),
        ],
      ),
    );
  }

  void _showPopupMenu(BuildContext context, GlobalKey key) async {
    final RenderBox renderBox =
        key.currentContext?.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final result = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + size.height,
        position.dx + size.width,
        position.dy + size.height + 10,
      ),
      items: [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.blue),
              SizedBox(width: 12),
              Text(
                "Edit",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 12),
              Text(
                "Delete",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
      elevation: 8,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

    if (result == 'edit') {
      print("Edit account selected");
    } else if (result == 'delete') {
      print("Delete account selected");
    }
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
