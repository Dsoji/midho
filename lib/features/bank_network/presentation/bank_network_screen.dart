import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/res/assets.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../common/widgets/custom_textfield.dart';

class BankNetworkScreen extends HookConsumerWidget {
  const BankNetworkScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();

    final List<Map<String, dynamic>> banks = [
      {
        "name": "GTBank",
        "logo": PlaceholderAssets.gtbank, // Replace with actual asset path
        "status": "Poor Network",
        "percentage": 49,
        "color": Colors.red,
      },
      {
        "name": "UBA",
        "logo": PlaceholderAssets.uba, // Replace with actual asset path
        "status": "Fair Network",
        "percentage": 55,
        "color": Colors.amber,
      },
      {
        "name": "Opay",
        "logo": PlaceholderAssets.opay, // Replace with actual asset path
        "status": "Good Network",
        "percentage": 92,
        "color": Colors.green,
      },
    ];
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Bank Network strength",
        showBackButton: true,
        showTitle: true,
        showAction: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const NetworkStatusIndicator(),
            const Gap(16),
            CustomTextField(
              controller: searchController,
              hintText: 'Search for your bank',
              suffixIcon: const Icon(Icons.search), // Optional
              isPassword: false,
            ),
            const Gap(12),
            Container(
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade500
                    : Colors.white, // Dark theme color
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.separated(
                itemCount: banks.length,
                shrinkWrap: true,
                separatorBuilder: (context, index) => Divider(
                  color: theme.brightness == Brightness.dark
                      ? Colors.black
                      : AppColors.greyColor.shade100,
                  thickness: 0.5,
                ),
                itemBuilder: (context, index) => buildBankItem(
                  banks[index],
                  context,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBankItem(
    Map<String, dynamic> bank,
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(bank["logo"]),
            radius: 14,
          ),
          const Gap(12),
          Text(
            bank["name"],
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          const Gap(12),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: bank["color"] // Light background matching status color
                  .withOpacity(0.1), // Light background matching status color
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: bank["color"],
                  radius: 3,
                ),
                const Gap(4),
                Text(
                  bank["status"],
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  ' ${bank["percentage"]}%',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NetworkStatusIndicator extends StatelessWidget {
  const NetworkStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const Center(
          child: Text(
            'Bank Network strength availability',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ),
        ),
        const Gap(8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark
                ? AppColors.secondaryColor.shade500
                : Colors.white,
            borderRadius: BorderRadius.circular(25), // Rounded edges
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIndicator(Colors.red, "0% - 49%"),
              const Gap(18),
              _buildIndicator(Colors.amber, "50% - 79%"),
              const Gap(18),
              _buildIndicator(Colors.green, "80% - 100%"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIndicator(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const Gap(8),
        Text(
          text,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
