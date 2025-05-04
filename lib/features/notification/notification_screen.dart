import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:mdiho/common/utils/date_utils.dart';
import 'package:mdiho/features/authentication/data/controller/authentication_controller.dart';
import 'package:mdiho/features/notification/data/model/response/notifcation_list/datum.dart';

import '../../common/res/app_colors.dart';
import '../../common/widgets/custom_app_bar.dart';

@RoutePage()
class NotificationScreen extends HookConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationList =
        ref.watch(authenticationControllerProvider).notification.valueOrNull;
    final notifications = notificationList?.data ?? [];

    Map<String, List<dynamic>> groupedNotifications = {};

    for (var item in notifications) {
      final parsedDate = item.createdAt ?? DateTime.now();
      final now = DateTime.now();
      final difference = now.difference(parsedDate).inDays;

      String key;
      if (difference == 0) {
        key = 'Today';
      } else if (difference == 1) {
        key = 'Yesterday';
      } else {
        key = DateFormat('MMM dd, yyyy').format(parsedDate);
      }

      groupedNotifications.putIfAbsent(key, () => []).add(item);
    }

    final sortedKeys = groupedNotifications.keys.toList()
      ..sort((a, b) {
        // Sort keys by parsed date (today first)
        DateTime parseKey(String k) {
          if (k == 'Today') return DateTime.now();
          if (k == 'Yesterday') {
            return DateTime.now().subtract(const Duration(days: 1));
          }
          return DateFormat('MMM dd, yyyy').parse(k);
        }

        return parseKey(b).compareTo(parseKey(a));
      });

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
            if (notifications.isEmpty)
              const Center(
                child: Text(
                  "No notifications yet.",
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (final key in sortedKeys) ...[
                    Text(
                      key,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const Gap(10),
                    ...groupedNotifications[key]!
                        .map((n) => NotificationCard(notification: n)),
                    const Gap(24),
                  ]
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
  final Datum notification;

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
                    notification.title ?? '',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.description ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (notification.createdAt ?? DateTime.now())
                        .formatToReadableDateTime(),
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
