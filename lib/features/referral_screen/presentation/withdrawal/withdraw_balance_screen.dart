import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../../common/res/app_colors.dart';
import '../../../../common/res/assets.dart';
import '../../../../common/toast/toast.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/custom_buttons.dart';
import '../../../../common/widgets/custom_textfield.dart';
import '../../../authentication/data/controller/authentication_controller.dart';
import '../../../bank_network/data/model/response/bank_list/bank_list.dart';
import '../../../bank_network/presentation/bank_network_screen.dart';
import '../../../bottomNav/app_router.gr.dart';
import '../../../profile/data/controller/profile_controller.dart';
import '../../../profile/presentation/bank/add_bank.dart';
import '../../../transaction/data/controller/transaction_controller.dart';
import '../../../withdrawal/presentation/widget/bank_info_card.dart';

final selectedBankProvider =
    StateProvider<Map<String, dynamic>?>((ref) => null);

final logger = Logger();

@RoutePage()
class WithdrawReferallScreen extends HookConsumerWidget {
  const WithdrawReferallScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedBank = ref.watch(selectedBankProvider);
    final amountController = useTextEditingController();
    final userProfileAsync =
        ref.watch(authenticationControllerProvider).userDetails;
    final localBanks = userProfileAsync.valueOrNull?.banks;
    final formKey = GlobalKey<FormState>();
    final userInfo =
        ref.watch(authenticationControllerProvider).userDetails.valueOrNull;
    final banks = ref.watch(profileControllerProvider).banks.valueOrNull;

    final referralBalance = userInfo?.wallet?.referralBalance;
    final filteredBanks = useState<List<BanlList>>(banks ?? []);

    // Update filteredBanks when banks change - use Future.microtask

    // Update filteredBanks when banks change
    useEffect(() {
      filteredBanks.value = banks ?? [];
      return null;
    }, [banks]);

    final bank = filteredBanks.value
        .where((bank) =>
            bank.name ==
            (selectedBank?["name"] ??
                (localBanks?.isNotEmpty == true
                    ? localBanks?.first.bankName
                    : 'Select Bank')))
        .firstOrNull;
    logger.d(bank);

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Withdraw Referral Balance",
        showBackButton: true,
        showTitle: true,
        showAction: false,
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        },
        behavior: HitTestBehavior.translucent,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
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
                        showStrength: false,
                        image:
                            selectedBank?["image"] ?? PlaceholderAssets.gtbank,
                        name: selectedBank?["name"] ??
                            (localBanks?.isNotEmpty == true
                                ? localBanks?.first.bankName
                                : 'Select Bank'),
                        status: bank?.status ?? '',
                        percentage: "${bank?.strength ?? 100}%",
                        actNumber: selectedBank?["actNumber"] ??
                            (localBanks?.isNotEmpty == true
                                ? localBanks?.first.accountNumber
                                : 'N/A'),
                        actName: selectedBank?["actName"] ??
                            (localBanks?.isNotEmpty == true
                                ? localBanks?.first.accountName
                                : 'N/A'),
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
                          if (!formKey.currentState!.validate()) {
                            return;
                          }

                          if (int.parse(amountController.text.trim()) >
                              (referralBalance ?? 0)) {
                            ToastService().showToast(
                              NotificationType.error,
                              message: 'Insufficient balance',
                            );
                            return;
                          }

                          if (int.parse(amountController.text.trim()) < 100 ||
                              int.parse(amountController.text.trim()) >
                                  10000000) {
                            ToastService().showToast(
                              NotificationType.info,
                              message:
                                  'Withdrawal amount must be between NGN 100 and NGN 5,000,000',
                            );
                            return;
                          }
                          final acctNo = selectedBank?["actNumber"] ??
                              localBanks?.first.accountNumber ??
                              '';
                          final acctName = selectedBank?["actName"] ??
                              localBanks?.first.accountName ??
                              '';
                          final bankName = selectedBank?["name"] ??
                              localBanks?.first.bankName ??
                              '';
                          final bankCode = selectedBank?["bankCode"] ??
                              localBanks?.first.bankCode ??
                              '';

                          if (bankName.isEmpty ||
                              acctNo.isEmpty ||
                              acctName.isEmpty ||
                              bankCode.isEmpty) {
                            ToastService().showToast(
                              NotificationType.info,
                              message: 'Please select valid bank details.',
                            );
                            return;
                          }
                          context.router.push(TransactinRoute(
                            onCustomerButtonPressed: () {
                              Navigator.pop(context);
                              context.router.push(const SupportFaqRoute());
                            },
                            isHome: false,
                            acctNo: acctNo,
                            amount: int.parse(amountController.text.trim()),
                            referall: true,
                            accountName: acctName,
                            bankName: bankName,
                            bankCode: bankCode,
                          ));
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
      builder: (context) {
        final height = MediaQuery.of(context).size.height;
        return const FractionallySizedBox(
          heightFactor: 0.85, // 70% of screen height
          child: AddBankScreen(),
        );
      },
    );
  }
}

class AddBankScreen extends HookConsumerWidget {
  const AddBankScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userProfileAsync =
        ref.watch(authenticationControllerProvider).userDetails;
    final banks = ref.watch(profileControllerProvider).banks.valueOrNull;
    final localBanks = userProfileAsync.valueOrNull?.banks;
    final screenHeight = MediaQuery.of(context).size.height;
    final filteredBanks = useState<List<BanlList>>(banks ?? []);
    useEffect(() {
      filteredBanks.value = banks ?? [];
      return null;
    }, [banks]);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: screenHeight * 0.02, // Adaptive vertical padding
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade500
                    : Colors.grey.shade300,
              ),
            ),
          ),
          Gap(screenHeight * 0.01),
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
          Gap(screenHeight * 0.02),
          const NetworkStatusIndicator(),
          Gap(screenHeight * 0.015),
          RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(authenticationControllerProvider.notifier)
                  .fetchProfile();
            },
            color: AppColors.primaryColor.shade500,
            child: localBanks!.isEmpty
                ? SizedBox(
                    height: screenHeight * 0.25,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: screenHeight * 0.1),
                        const Center(child: Text("No linked bank accounts.")),
                      ],
                    ),
                  )
                : SizedBox(
                    height: screenHeight * 0.4,
                    child: ListView(
                      padding: EdgeInsets.all(screenHeight * 0.015),
                      children: [
                        const Text(
                          "Manage the bank accounts linked to your wallet for withdrawals.",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                        Gap(screenHeight * 0.015),
                        ...List.generate(localBanks.length, (index) {
                          final bank = localBanks[index];
                          return Padding(
                            padding:
                                EdgeInsets.only(bottom: screenHeight * 0.01),
                            child: BankInfoCard(
                              name: bank.bankName ?? "Unknown Bank",
                              actNumber: bank.accountNumber ?? "N/A",
                              actName: bank.accountName ?? "N/A",
                              showBorder: false,
                              icon: Icons.more_horiz,
                              showStrength: false,
                              onTap: () {
                                ref.read(selectedBankProvider.notifier).state =
                                    {
                                  "name": bank.bankName ?? "Unknown Bank",
                                  "image": PlaceholderAssets.gtbank,
                                  "status": "bank.",
                                  "percentage":
                                      "${filteredBanks.value.first.strength ?? 100}%",
                                  "strength":
                                      filteredBanks.value.first.strength ?? 100,
                                  "actNumber": bank.accountNumber ?? "N/A",
                                  "actName": bank.accountName ?? "N/A",
                                  "bankCode": bank.bankCode ?? "N/A",
                                };

                                Navigator.pop(context);
                              },
                              delete: () async {
                                final result = await ref
                                    .read(
                                        transactionControllerProvider.notifier)
                                    .deleteBanks(acctId: bank.id ?? '');
                                await ref
                                    .read(authenticationControllerProvider
                                        .notifier)
                                    .fetchProfile();
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
          ),
          Gap(screenHeight * 0.03),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddNewBankScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor.shade500,
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add, color: Colors.white, size: 20),
              label: const Text(
                "Add New Bank Account",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
          const Gap(80),
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
              Icon(Icons.edit, color: Colors.blue, size: 18),
              SizedBox(width: 8),
              Text(
                "Edit",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red, size: 18),
              SizedBox(width: 8),
              Text(
                "Delete",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
    } else if (result == 'delete') {}
  }
}
