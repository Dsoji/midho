import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../common/widgets/custom_textfield.dart';

@RoutePage()
class FaqScreen extends HookConsumerWidget {
  const FaqScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Frequently Asked Questions (FAQ)",
        showBackButton: true,
        showTitle: true,
        showAction: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: searchController,
              hintText: 'Search Provider',
              isPassword: false,
              suffixIcon: const Icon(Icons.search),
              fillColor: theme.brightness == Brightness.dark
                  ? AppColors.secondaryColor.shade500
                  : Colors.white,
              borderRadius: 12,
            ),
            const Gap(16),
            const FAQItem(
              title: "Why is my withdrawal delayed?",
              content:
                  "Withdrawals are usually processed instantly, but bank network issues can cause delays. If your withdrawal is still pending after 10 minutes, contact support.",
            ),
            const FAQItem(
              title: "How do I sell a gift card?",
              content: "",
            ),
            const FAQItem(
              title: "What happens if my crypto trade is not approved?",
              content:
                  "If your trade is rejected, you will receive a notification with the reason. Common reasons include incorrect transaction details or network confirmation failures.",
            ),
            const FAQItem(
              title: "How do I reset my transaction PIN?",
              content:
                  "Go to Profile > Security > Reset PIN. Enter your current PIN and set a new one. If you forgot your PIN, select ‘Forgot PIN’ and follow the instructions.",
            ),
            const FAQItem(
              title: "Why is my bank not available for withdrawal?",
              content:
                  "Some banks experience network downtimes that may prevent withdrawals. If your bank is unavailable, try again later or use a different bank.",
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String title;
  final String content;

  const FAQItem({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: ShapeDecoration(
        color: theme.brightness == Brightness.dark
            ? AppColors.secondaryColor.shade600
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, // Removes the border
        ),
        child: ExpansionTile(
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                content,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
