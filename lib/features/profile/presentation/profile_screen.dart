import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../common/widgets/custom_buttons.dart';
import '../../authentication/data/controller/authentication_controller.dart';
import '../../home/presentation/home_screen.dart';
import 'widget/profile_option.dart';

@RoutePage()
class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetails = ref.watch(authenticationControllerProvider).userDetails;
    final theme = Theme.of(context);
    var box = Hive.box('data'); // Replace 'data' with your box name
    final cached = box.get('userProfile');
    final currentScreen = useState<String>("app");
    return PopScope(
      canPop: false, // Prevent default back navigation
      onPopInvoked: (didPop) {
        if (!didPop) {
          final tabsRouter = AutoTabsRouter.of(
            context,
          );

          tabsRouter.setActiveIndex(0);
        }
      },

      child: Scaffold(
        appBar: CustomAppBar(
          title: "Profile",
          showBackButton: false,
          showTitle: true,
          showAction: true,
          actionIcon: IconsaxPlusLinear.trash,
          actionColor: Colors.red,
          onActionPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (BuildContext context) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const Text(
                          "Delete Account",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Are you sure you want to delete your account?",
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancel"),
                            ),
                            FullButton(
                              isLoading: ref
                                  .watch(authenticationControllerProvider)
                                  .deleteAccount
                                  .isLoading,
                              text: "Yes",
                              width: 120,
                              height: 48,
                              color: Colors.red,
                              textColor: Colors.white,
                              onPressed: () async {
                                final result = await ref
                                    .read(authenticationControllerProvider
                                        .notifier)
                                    .deleteAccount();

                                if (result == true) {
                                  await box.put('remember_me', false);
                                  await box.delete('accessToken');
                                  await box.delete('userProfile');
                                  await box.delete('userDetails');
                                  await box.delete('userReferral');
                                  await box.delete('userReferralCode');
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                    context.router
                                        .replaceAll([const OnboardingRoute()]);
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                        const Gap(100),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        body: RefreshIndicator.adaptive(
          onRefresh: () async {
            await ref
                .read(authenticationControllerProvider.notifier)
                .fetchProfile();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Manage your personal information, security settings, and linked accounts all in one place.",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                // User Info Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? AppColors.darkBorder
                        : Colors.white,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: userDetails.when(
                          loading: () => userDetails.maybeWhen(
                            data: (userInfo) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${userInfo.firstname ?? ''} ${userInfo.lastname ?? ''}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: theme.brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                Text(
                                  userInfo.email ?? '',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            ),
                            orElse: () => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Shimmer.fromColors(
                                  baseColor: AppColors.primaryColor.shade50,
                                  highlightColor:
                                      AppColors.primaryColor.shade100,
                                  child: Container(
                                    height: 12,
                                    width: 120,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Shimmer.fromColors(
                                  baseColor: AppColors.primaryColor.shade50,
                                  highlightColor:
                                      AppColors.primaryColor.shade100,
                                  child: Container(
                                    height: 10,
                                    width: 160,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          error: (error, _) => const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Error loading profile",
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                          data: (userInfo) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${userInfo.firstname ?? ''} ${userInfo.lastname ?? ''}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: theme.brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              Text(
                                userInfo.email ?? '',
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const ReferralButton(),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Profile Options List (Fixed: Using SizedBox instead of Expanded)
                // Adjust height as needed
                const ProfileOption(),
                const Gap(20),

                // Sign Out Section in a Separate Container
                Container(
                  height: 54,
                  padding: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? AppColors.darkBorder
                        : Colors.white,
                  ),
                  child: buildProfileOption(
                    IconsaxPlusLinear.logout,
                    "Sign Out",
                    context,
                    () async {
                      await box.put('remember_me', false);
                      await box.delete('accessToken').then((_) async {
                        currentScreen.value = "onboarding";
                        context.router.replaceAll([const OnboardingRoute()]);
                      });
                    },
                    isDestructive: true,
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

  Widget buildProfileOption(
      IconData icon, String title, BuildContext context, VoidCallback onTap,
      {bool isDestructive = false}) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onTap,
      splashColor: Colors.transparent, // Removes splash effect
      hoverColor: Colors.transparent, // Removes splash effect
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : AppColors.primaryColor.shade500,
        size: 16,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          color:
              theme.brightness == Brightness.dark ? Colors.white : Colors.black,
        ),
      ),
      trailing: isDestructive
          ? null
          : Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
    );
  }
}
