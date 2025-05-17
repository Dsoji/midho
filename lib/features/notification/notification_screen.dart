import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/common/utils/date_utils.dart';
import 'package:mdiho/features/authentication/data/controller/authentication_controller.dart';
import 'package:mdiho/features/notification/data/model/response/notifcation_list/datum.dart';

import '../../common/res/app_colors.dart';
import '../../common/widgets/custom_app_bar.dart';
import '../crypto/presentation/crypto_screen.dart';

@RoutePage()
class NotificationScreen extends HookConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncNotification = ref.watch(
      authenticationControllerProvider.select((state) => state.notification),
    );

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Notifications",
        showBackButton: true,
        showTitle: true,
        showAction: false,
        centerTitle: true,
      ),
      body: asyncNotification.when(
        loading: () => ListView.separated(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          itemCount: 6,
          separatorBuilder: (_, __) => const Gap(8),
          itemBuilder: (_, __) => const CryptoCardShimmer(),
        ),
        error: (error, _) => Center(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(52),
                const Icon(Icons.info_outline, color: Colors.grey, size: 48),
                const SizedBox(height: 8),
                Text(
                  "Failed to load notifications.",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
        data: (notificationList) {
          final notifications = (notificationList.data ?? [])
            ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

          return RefreshIndicator.adaptive(
            onRefresh: () async {
              await ref
                  .read(authenticationControllerProvider.notifier)
                  .fetchNotification();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Gap(52),
                          const Icon(Icons.info_outline,
                              color: Colors.grey, size: 48),
                          const SizedBox(height: 8),
                          Text(
                            "You do not have any notifications.",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: notifications.length,
                      separatorBuilder: (_, __) => const Gap(12),
                      itemBuilder: (context, index) {
                        return NotificationCard(
                          notification: notifications[index],
                        );
                      },
                    ),
                  const Gap(150),
                ],
              ),
            ),
          );
        },
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
