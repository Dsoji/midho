import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../common/widgets/custom_textfield.dart';
import '../../crypto/presentation/crypto_screen.dart';
import '../../profile/data/controller/profile_controller.dart';
import '../../withdrawal/presentation/widget/bank_info_card.dart';
import '../data/model/response/bank_list/bank_list.dart';

@RoutePage()
class BankNetworkScreen extends HookConsumerWidget {
  const BankNetworkScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final banks = ref.watch(profileControllerProvider).banks.valueOrNull;

    final theme = Theme.of(context);
    final filteredBanks = useState<List<BanlList>>(banks ?? []);

    useEffect(() {
      if (banks != null) filteredBanks.value = banks;
      return null;
    }, [banks]);

    if (banks == null)
      return SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          itemCount: 6,
          separatorBuilder: (_, __) => const Gap(8),
          itemBuilder: (_, __) => const CryptoCardShimmer(),
        ),
      );

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Bank Network strength",
        showBackButton: true,
        showTitle: true,
        showAction: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const NetworkStatusIndicator(),
            const Gap(16),
            CustomTextField(
              controller: searchController,
              label: "Search Bank",
              keyboardType: TextInputType.text,
              onChanged: (value) {
                final query = value.toLowerCase();
                filteredBanks.value = banks
                    .where((bank) =>
                        bank.name?.toLowerCase().contains(query) ?? false)
                    .toList();
              },
            ),
            const Gap(16),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await ref.read(profileControllerProvider.notifier).getBanks();
                },
                child: ListView.separated(
                  itemCount: filteredBanks.value.length,
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) => const Gap(10),
                  itemBuilder: (context, index) {
                    final bank = filteredBanks.value[index];

                    return BankInfoCard2(
                      name: bank.name ?? "Unknown Bank",
                      status: bank.status ?? "No Status",
                      percentage: '${bank.strength ?? 0}%',
                      showBorder: false,
                      onTap: () {},
                    );
                  },
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
