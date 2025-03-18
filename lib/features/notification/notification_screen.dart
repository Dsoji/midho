import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../common/res/app_colors.dart';
import '../../common/widgets/custom_app_bar.dart';

@RoutePage()
class NotificationScreen extends HookConsumerWidget {
  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<NotificationItem> notifications = [
      NotificationItem(
        title: "Crypto Sale Pending",
        message:
            "Your Bitcoin (BTC) sale for ₦495,000.00 is currently under review. You will be notified once it’s approved.",
        date: "Jan 15, 2025, 10:30",
      ),
      NotificationItem(
        title: "Gift Card Trade Approved",
        message:
            "Your STEAM gift card trade for \$50 has been successfully approved. ₦37,000.00 has been credited to your wallet.",
        date: "Jan 15, 2025, 10:30",
      ),
      NotificationItem(
        title: "Utility Bill Payment Failed",
        message:
            "Your payment of ₦10,000.00 to Ikeja Electric failed due to insufficient wallet balance. Please fund your wallet and retry.",
        date: "Jan 15, 2025, 10:30",
      ),
      NotificationItem(
        title: "Withdrawal Processed",
        message:
            "Your withdrawal of ₦100,000.00 to Access Bank account 1234567890 has been successfully processed.",
        date: "Jan 15, 2025, 10:30",
      ),
      NotificationItem(
        title: "Referral Reward Earned",
        message:
            "You earned ₦2,000.00 for referring john_doe! Your reward has been added to your wallet balance.",
        date: "Jan 15, 2025, 10:30",
        isYesterday: true,
      ),
      NotificationItem(
        title: "Gift Card Trade Failed",
        message:
            "Your STEAM gift card trade for \$50 failed due to an invalid card. See details and proof below.",
        date: "Jan 15, 2025, 10:30",
        isYesterday: true,
      ),
    ];

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Notifications",
        showBackButton: true,
        showTitle: true,
        showAction: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Stay updated with your transactions and activities.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Gap(16),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const Text(
                  "Recent Notifications",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                ...notifications
                    .where((n) => !n.isYesterday)
                    .map((n) => NotificationCard(notification: n)),
                const SizedBox(height: 20),
                const Text(
                  "Yesterday",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                ...notifications
                    .where((n) => n.isYesterday)
                    .map((n) => NotificationCard(notification: n)),
              ],
            ),
            const Gap(150),
          ],
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.brightness == Brightness.dark
          ? AppColors.secondaryColor.shade600
          : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: theme.brightness == Brightness.dark
                  ? AppColors.secondaryColor.shade400
                  : const Color(0xFFFEEEE9),
              child: Icon(
                IconsaxPlusLinear.notification_1,
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : AppColors.primaryColor.shade500,
                size: 15,
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 12),
                  Text(
                    notification.title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.message,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.date,
                    style: const TextStyle(
                      fontSize: 10,
                    ),
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

class NotificationItem {
  final String title;
  final String message;
  final String date;
  final bool isYesterday;

  NotificationItem({
    required this.title,
    required this.message,
    required this.date,
    this.isYesterday = false,
  });
}
