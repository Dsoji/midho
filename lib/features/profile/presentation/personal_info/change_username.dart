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
class ChangeUsernameScreen extends HookConsumerWidget {
  const ChangeUsernameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final usernameController = useTextEditingController();
    final emailController = useTextEditingController();
    final newnameController = useTextEditingController();

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Edit Username",
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
              "Update your username to personalize your profile.",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Gap(10),
            Container(
              decoration: ShapeDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade500
                    : AppColors.whiteColor.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                shadows: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Light shadow color
                    blurRadius: 8, // Soft shadow effect
                    spreadRadius: 1, // Spread of the shadow
                    offset: const Offset(0, 2), // Moves shadow slightly down
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Email Field
                  CustomTextField(
                    controller: usernameController,
                    label: "Current Username",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const Gap(28),
                  CustomTextField(
                    controller: newnameController,
                    label: "New Username",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 28),
                  InfoWidget(
                    theme: theme,
                    text:
                        'Choose a unique username to stand out. This will also be your referral code.',
                  ),
                  const SizedBox(height: 20),
                  // Continue Button
                  FullButton(
                    text: "Save Changes",
                    width: double.infinity,
                    height: 48,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    textColor: Colors.white,
                    color: AppColors.primaryColor.shade500,
                  ),
                  FullButton(
                    text: "Cancel",
                    width: double.infinity,
                    height: 48,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    textColor: theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    color: Colors.transparent,
                  ),
                  const Gap(20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
