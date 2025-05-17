import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/common/utils/validator.dart';
import 'package:mdiho/features/authentication/data/controller/authentication_controller.dart';
import 'package:mdiho/features/authentication/presentation/login/presentation/login_screen.dart';

import '../../../../../../common/res/app_colors.dart';
import '../../../../../../common/widgets/custom_buttons.dart';
import '../../../../../../common/widgets/custom_textfield.dart';
import '../../../../data/model/payload/sign_up_payload.dart';

class EmailPasswordStep extends HookConsumerWidget {
  final VoidCallback onNext;
  final bool isLoading;

  const EmailPasswordStep(
      {super.key, required this.onNext, this.isLoading = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final referralController = useTextEditingController();
    final obscurePassword = useState(true);
    final passwordStrength = useState("Weak");
    final authService = ref.read(authenticationControllerProvider.notifier);

    final theme = Theme.of(context);
    return SingleChildScrollView(
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
                    color: Colors.black.withOpacity(0.1), // Light shadow color
                    blurRadius: 3, // Soft shadow effect
                    spreadRadius: 1, // Spread of the shadow
                    offset: const Offset(0, 2), // Moves shadow slightly down
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Let's Set Up Your Account",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Provide the following details to set up your account",
                    style: TextStyle(
                      fontSize: 14,
                    ),
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

                  const SizedBox(height: 20),

                  // Referral Code (Optional)
                  CustomTextField(
                    controller: referralController,
                    label: "Referral Code (Optional)",
                    hintText: "Enter referral code",
                    suffixIcon: PasteButton(
                      onTap: () async {
                        ClipboardData? data =
                            await Clipboard.getData('text/plain');
                        if (data != null) {
                          referralController.text = data.text!;
                        }
                      },
                    ),
                    onSuffixTap: () {
                      referralController.text =
                          "REF123"; // Simulate pasting a code
                    },
                    prefixIcon: Icons.people_outline,
                  ),

                  const SizedBox(height: 20),

                  // Continue Button
                  FullButton(
                    isLoading: ref
                        .watch(authenticationControllerProvider)
                        .emailVerification
                        .isLoading,
                    text: "Continue",
                    width: double.infinity,
                    height: 48,
                    onPressed: () async {
                      // onNext();
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      var box = Hive.box('data');
                      box.put('email', emailController.text.trim());
                      box.put('password', passwordController.text.trim());
                      box.put('referral', referralController.text.trim());
                      authService.updateSignUpDetails(
                        SignUpPayload(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          referral: referralController.text.trim(),
                        ),
                      );

                      final result = await authService.emailVerify(
                        emailController.text.trim(),
                        referralController.text.trim(),
                        'SIGNUP',
                      );

                      if (result == true) {
                        onNext(); // Correctly invoke the function
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
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Already Have An Account? ",
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.brightness == Brightness.dark
                                ? Colors.white
                                : AppColors.greyColor.shade700,
                          ),
                          children: [
                            TextSpan(
                              text: "Log In",
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
    );
  }
}

class PasteButton extends StatelessWidget {
  final VoidCallback? onTap;

  const PasteButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark
              ? AppColors.secondaryColor.shade400
              : AppColors.whiteColor.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: theme.brightness == Brightness.dark
                  ? AppColors.secondaryColor.shade300
                  : AppColors.whiteColor.shade600,
              width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Paste",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: theme.brightness == Brightness.dark
                    ? AppColors.whiteColor.shade500
                    : AppColors.greyColor.shade500,
              ),
            ),
            const SizedBox(width: 6),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(3.1416), // Flip horizontally
              child: Icon(
                IconsaxPlusLinear.copy,
                size: 20,
                color: theme.brightness == Brightness.dark
                    ? AppColors.whiteColor.shade500
                    : AppColors.greyColor.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
