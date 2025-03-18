import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';

import '../../../../common/res/app_colors.dart';
import '../../../../common/res/assets.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../withdrawal/presentation/widget/bank_info_card.dart';

@RoutePage()
class LinkedBanksScreen extends HookConsumerWidget {
  const LinkedBanksScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final List<Map<String, dynamic>> bankList = [
      {
        "name": "GTBank",
        "image": PlaceholderAssets.gtbank, // Use 'image' instead of 'logo'
        "status": "Poor Network",
        "percentage": "49%", // Ensure this is a String
        "color": Colors.red,
        "actNumber": "1234 5678 9012", // Add this field
        "actName": "John Doe", // Add this field
      },
      {
        "name": "UBA",
        "image": PlaceholderAssets.uba,
        "status": "Fair Network",
        "percentage": "55%",
        "color": Colors.amber,
        "actNumber": "5678 9012 3456",
        "actName": "Doe John",
      },
      {
        "name": "Opay",
        "image": PlaceholderAssets.opay,
        "status": "Good Network",
        "percentage": "92%",
        "color": Colors.green,
        "actNumber": "9012 3456 7890",
        "actName": "John Doe",
      },
    ];
    return Scaffold(
      appBar: CustomAppBar(
        title: "Linked Bank Accounts",
        showBackButton: true,
        showTitle: true,
        showAction: true,
        actionIcon: Icons.add,
        actionColor: AppColors.primaryColor.shade500,
        onActionPressed: () {
          context.router.push(
            AddNewBankRoute(),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Manage the bank accounts linked to your wallet for withdrawals.",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
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
                    showStrength: false,
                    onTap: () {
                      final GlobalKey<State<StatefulWidget>> globalKey =
                          GlobalKey();
                      // _showPopupMenu(context, globalKey);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
