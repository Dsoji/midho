import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/features/authentication/data/controller/authentication_controller.dart';
import 'package:mdiho/features/onboarding/presentation/onboarding_screen.dart';

import '../../../../../common/res/app_colors.dart';
import '../../../../../common/utils/validator.dart';
import '../../../../../common/widgets/custom_buttons.dart';
import '../../../../../common/widgets/custom_textfield.dart';
import '../../../../bottomNav/app_router.gr.dart';
import '../../registration/presentation/registration_screen.dart';

@RoutePage()
class LoginScreen extends HookConsumerWidget {
  const LoginScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authentication = ref.read(authenticationControllerProvider.notifier);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    useState("Weak");

    final theme = Theme.of(context);
    final formKey = GlobalKey<FormState>();

    return PopScope(
      canPop: false, // Prevent default back navigation
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const OnboardingScreen(),
            ),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              IconsaxPlusLinear.arrow_left_1,
              size: 20,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 18),
                  decoration: ShapeDecoration(
                    color: theme.brightness == Brightness.dark
                        ? const Color(0xFF151515)
                        : AppColors.whiteColor.shade100,
                    shape: const RoundedRectangleBorder(),
                    shadows: [
                      BoxShadow(
                        color:
                            Colors.black.withOpacity(0.1), // Light shadow color
                        blurRadius: 3, // Soft shadow effect
                        spreadRadius: 1, // Spread of the shadow
                        offset:
                            const Offset(0, 2), // Moves shadow slightly down
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome back boss!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Sign in to  Swift Swap",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),

                      // Email Field
                      CustomTextField(
                        controller: emailController,
                        label: "Email",
                        prefixIcon: Icons.email_outlined, // Optional
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.emailValidator,
                      ),

                      const SizedBox(height: 15),

                      // Password Field
                      CustomTextField(
                        controller: passwordController,
                        label: "Password",
                        prefixIcon: IconsaxPlusLinear.lock, // Optional
                        isPassword: true,
                        validator: Validators.passwordValidator,
                      ),
                      const Gap(8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             const ForgotPasswordScreen()));
                          },
                          child: Text(
                            "Forgot Password",
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.brightness == Brightness.dark
                                  ? AppColors.blueColor
                                  : AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      const Gap(28),

                      // Continue Button
                      FullButton(
                        isLoading: ref
                            .watch(authenticationControllerProvider)
                            .login
                            .isLoading,
                        text: "Continue",
                        width: double.infinity,
                        height: 48,
                        onPressed: () async {
                          // context.router.replace(const NaviBarRoute());
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          final result = await authentication.signIn(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );
                          if (result == true) {
                            context.router.replace(const NaviBarRoute());
                          }
                        },
                        textColor: Colors.white,
                        color: AppColors.primaryColor.shade500,
                      ),

                      const SizedBox(height: 20),

                      // Already have an account?
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegistrationScreen(),
                            ),
                          );
                        },
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Don't Have An Account? ",
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.brightness == Brightness.dark
                                    ? Colors.white
                                    : AppColors.greyColor.shade700,
                              ),
                              children: [
                                TextSpan(
                                  text: "Sign Up",
                                  style: TextStyle(
                                      color: theme.brightness == Brightness.dark
                                          ? AppColors.blueColor
                                          : AppColors.primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
