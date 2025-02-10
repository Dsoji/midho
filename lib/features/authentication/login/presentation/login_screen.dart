import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/authentication/forgot_password/presentation/forgot_password.dart';

import '../../../../common/res/app_colors.dart';
import '../../../../common/widgets/custom_buttons.dart';
import '../../../../common/widgets/custom_textfield.dart';

@RoutePage()
class LoginScreen extends HookConsumerWidget {
  const LoginScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final referralController = useTextEditingController();
    final obscurePassword = useState(true);
    final passwordStrength = useState("Weak");

    bool isValidEmail(String email) {
      return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
          .hasMatch(email);
    }

    bool isPasswordStrong(String password) {
      return password.length >= 8 &&
          RegExp(r'[A-Z]').hasMatch(password) &&
          RegExp(r'[0-9]').hasMatch(password) &&
          RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    }

    void validatePassword(String password) {
      if (password.length < 8) {
        passwordStrength.value = "Weak";
      } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
        passwordStrength.value = "Medium";
      } else if (!RegExp(r'[0-9]').hasMatch(password)) {
        passwordStrength.value = "Strong";
      } else {
        passwordStrength.value = "Very Strong";
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: ShapeDecoration(
              color: AppColors.whiteColor.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome back boss!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Sign in to M-Diho",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // Email Field
                CustomTextField(
                  controller: emailController,
                  label: "Email",
                  prefixIcon: Icons.email_outlined, // Optional
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      isValidEmail(value!) ? null : "Enter a valid email",
                ),

                const SizedBox(height: 15),

                // Password Field
                CustomTextField(
                  controller: passwordController,
                  label: "Password",
                  prefixIcon: Icons.lock_outline, // Optional
                  isPassword: true,
                ),
                const Gap(8),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen()));
                    },
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                const Gap(28),

                // Continue Button
                FullButton(
                  text: "Continue",
                  width: double.infinity,
                  height: 48,
                  onPressed: () {},
                  textColor: Colors.white,
                  color: AppColors.primaryColor.shade500,
                ),

                const SizedBox(height: 20),

                // Already have an account?
                Center(
                  child: RichText(
                    text: const TextSpan(
                      text: "Don't Have An Account? ",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      children: [
                        TextSpan(
                          text: "Sign Up",
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCriteriaIcon(bool isMet, String label) {
    return Row(
      children: [
        Icon(isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isMet ? Colors.green : Colors.grey, size: 18),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
