import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';

import '../../../../common/res/app_colors.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/custom_buttons.dart';
import '../../../../common/widgets/custom_textfield.dart';

@RoutePage()
class ChangePasswordScreen extends HookConsumerWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pswrdController = useTextEditingController();
    final newPswrdController = useTextEditingController();
    final confirmPswrdController = useTextEditingController();

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Personal Information",
        showBackButton: true,
        showTitle: true,
        showAction: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Create a strong password to protect your account.",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Gap(10),
            Container(
              decoration: ShapeDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade600
                    : AppColors.whiteColor.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: pswrdController,
                    label: "Current Password",
                    prefixIcon: Icons.lock_outline, // Optional
                    isPassword: true,
                  ),
                  const Gap(28),
                  InfoWidget(
                    theme: theme,
                    text:
                        "Use at least 8 characters, including numbers and special characters",
                  ),
                  const Gap(40),
                  CustomTextField(
                    controller: newPswrdController,
                    label: "New Password",
                    prefixIcon: Icons.lock_outline, // Optional
                    isPassword: true,
                  ),
                  const Gap(28),
                  CustomTextField(
                    controller: confirmPswrdController,
                    label: "Confirm New Password",
                    prefixIcon: Icons.lock_outline, // Optional
                    isPassword: true,
                  ),
                  const Gap(28),
                  InfoWidget(
                    theme: theme,
                    text:
                        "Avoid using easily guessable information like names or birthdates.",
                  ),
                  const Gap(25),
                  FullButton(
                    text: "Save Changes",
                    width: double.infinity,
                    height: 48,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    textColor: Colors.white,
                    color: AppColors.primaryColor.shade500,
                  ),
                  FullButton(
                    text: "Cancel",
                    width: double.infinity,
                    height: 48,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    textColor: theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    color: Colors.transparent,
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
