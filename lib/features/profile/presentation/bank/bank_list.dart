import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';
import 'package:mdiho/features/transaction/data/controller/transaction_controller.dart';

import '../../../../common/res/app_colors.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../authentication/data/controller/authentication_controller.dart';
import '../../../crypto/presentation/crypto_screen.dart';
import '../../../withdrawal/presentation/widget/bank_info_card.dart';

@RoutePage()
class LinkedBanksScreen extends HookConsumerWidget {
  const LinkedBanksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userProfileAsync =
        ref.watch(authenticationControllerProvider).userDetails;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Linked Bank Accounts",
        showBackButton: true,
        showTitle: true,
        showAction: true,
        actionIcon: Icons.add,
        actionColor: AppColors.primaryColor.shade500,
        onActionPressed: () {
          context.router.push(AddNewBankRoute());
        },
      ),
      body: userProfileAsync.when(
        loading: () => ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          itemCount: 6,
          separatorBuilder: (_, __) => const Gap(8),
          itemBuilder: (_, __) => const CryptoCardShimmer(),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(52),
              const Icon(Icons.warning_amber_rounded,
                  size: 48, color: Colors.red),
              const SizedBox(height: 8),
              Text(
                "Failed to load bank accounts.",
                style: TextStyle(fontSize: 16, color: Colors.red[600]),
              ),
              const SizedBox(height: 6),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        data: (user) {
          final localBanks = useState<List<dynamic>>(user.banks ?? []);

          Future<void> refreshBanks() async {
            await ref
                .read(authenticationControllerProvider.notifier)
                .fetchProfile();

            final newBanks = ref
                    .read(authenticationControllerProvider)
                    .userDetails
                    .value
                    ?.banks ??
                [];
            localBanks.value = newBanks;
          }

          return RefreshIndicator(
            onRefresh: refreshBanks,
            color: AppColors.primaryColor.shade500,
            child: localBanks.value.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 100),
                      Center(child: Text("No linked bank accounts.")),
                    ],
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const Text(
                        "Manage the bank accounts linked to your wallet for withdrawals.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Gap(16),
                      ...List.generate(
                        localBanks.value.length,
                        (index) {
                          final bank = localBanks.value[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: BankInfoCard(
                              name: bank.bankName ?? "Unknown Bank",
                              actNumber: bank.accountNumber ?? "N/A",
                              actName: bank.accountName ?? "N/A",
                              showBorder: false,
                              icon: Icons.more_horiz,
                              showStrength: false,
                              onTap: () {},
                              delete: () async {
                                final result = await ref
                                    .read(
                                        transactionControllerProvider.notifier)
                                    .deleteBanks(acctId: bank.id ?? '');
                                if (result == true) {
                                  localBanks.value = List.from(localBanks.value)
                                    ..removeWhere((b) => b.id == bank.id);
                                  await refreshBanks();
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
