import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/profile/presentation/personal_info/email_verification.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';

import '../../../../common/res/app_colors.dart';
import '../../../../common/toast/toast.dart';
import '../../../../common/utils/validator.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/custom_buttons.dart';
import '../../../../common/widgets/custom_textfield.dart';
import '../../../authentication/data/controller/authentication_controller.dart';

@RoutePage()
class ChangeEmailScreen extends HookConsumerWidget {
  const ChangeEmailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final emailController = useTextEditingController();
    final authService = ref.read(authenticationControllerProvider.notifier);
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Personal Information",
        showBackButton: true,
        showTitle: true,
        showAction: false,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Update your email",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const Gap(10),
              Container(
                decoration: ShapeDecoration(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.darkBorder
                      : AppColors.whiteColor.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  shadows: [
                    BoxShadow(
                      color:
                          Colors.black.withOpacity(0.1), // Light shadow color
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
                      controller: emailController,
                      label: "Email",
                      prefixIcon: Icons.email_outlined, // Optional
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.emailValidator,
                    ),

                    const SizedBox(height: 28),
                    InfoWidget(
                      theme: theme,
                      text:
                          'Ensure your new email is valid. A verification code will be sent to confirm the change.',
                    ),
                    const SizedBox(height: 20),
                    // Continue Button
                    FullButton(
                      isLoading: ref
                          .watch(authenticationControllerProvider)
                          .emailVerification
                          .isLoading,
                      text: "Update Email",
                      width: double.infinity,
                      height: 48,
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        if (emailController.text.isNotEmpty) {
                          final result = await authService.emailVerify(
                            emailController.text.trim(),
                            null,
                            'CHANGEEMAIL',
                          );
                          if (result == true) {
                            if (result == true) {
                              await ref
                                  .read(
                                      authenticationControllerProvider.notifier)
                                  .fetchProfile()
                                  .then((_) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EmailVerificationScreen(
                                      email: emailController.text.trim(),
                                    ),
                                  ),
                                );
                              });
                            }
                          }
                        } else {
                          ToastService().showToast(
                            NotificationType.info,
                            message: 'Please Fill all necessary fields.',
                          );
                        }
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
      ),
    );
  }
}
