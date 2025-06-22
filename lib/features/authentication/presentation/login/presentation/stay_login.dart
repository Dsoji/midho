import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mdiho/features/authentication/data/controller/authentication_controller.dart';
import 'package:mdiho/main.dart';

import '../../../../../common/res/app_colors.dart';
import '../../../../../common/toast/toast.dart';
import '../../../../../common/utils/validator.dart';
import '../../../../../common/widgets/custom_buttons.dart';
import '../../../../../common/widgets/custom_textfield.dart';
import '../../../../bottomNav/app_router.gr.dart';

@RoutePage()
class StayLoginScreen extends HookConsumerWidget {
  const StayLoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authentication = ref.read(authenticationControllerProvider.notifier);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final rememberMe = useState<bool>(false);

    final theme = Theme.of(context);
    final formKey = GlobalKey<FormState>();

    // Load saved email and rememberMe status
    useEffect(() {
      final box = Hive.box('data');
      rememberMe.value = box.get('remember_me') == true;
      final savedEmail = box.get('saved_email');
      if (rememberMe.value && savedEmail != null) {
        emailController.text = savedEmail;
      }
      return null;
    }, []);

    useEffect(() {
      LifecycleGuard.shouldForceSplashOnResume = true;
      return null;
    }, []);

    final showBiometric = rememberMe.value;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          context.router.replaceAll([const OnboardingRoute()]);
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
              context.router.replaceAll([const OnboardingRoute()]);
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
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 18),
                  padding: const EdgeInsets.all(16),
                  decoration: ShapeDecoration(
                    color: theme.brightness == Brightness.dark
                        ? const Color(0xFF151515)
                        : AppColors.whiteColor.shade100,
                    shape: const RoundedRectangleBorder(),
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 3,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Welcome back boss!",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: "Sign in to Swift Swap with your email: \n",
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                          children: [
                            TextSpan(
                              text: emailController.text,
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Password Field
                      CustomTextField(
                        controller: passwordController,
                        label: "Password",
                        prefixIcon: const Icon(IconsaxPlusLinear.lock,
                            color: Colors.grey, size: 21),
                        isPassword: true,
                        validator: Validators.passwordValidator,
                      ),
                      const Gap(8),

                      // Remember Me + Forgot Password
                      Row(
                        children: [
                          Checkbox(
                            value: rememberMe.value,
                            onChanged: (value) {
                              rememberMe.value = value ?? false;
                            },
                            activeColor: AppColors.primaryColor,
                          ),
                          const Text("Remember Me",
                              style: TextStyle(fontSize: 14)),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              // TODO: Navigate to ForgotPasswordScreen
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
                        ],
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
                          if (!formKey.currentState!.validate()) return;

                          final result = await authentication.signIn(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );

                          if (result == true) {
                            final box = Hive.box('data');
                            await box.put('remember_me', rememberMe.value);

                            if (rememberMe.value) {
                              await box.put(
                                  'saved_email', emailController.text.trim());
                            } else {
                              await box.delete('saved_email');
                            }

                            // ref.read(sessionTimerProvider).startTimer(() {
                            context.router.replaceAll([const LoginRoute()]);
                            // });
                            await box.put('login_time',
                                DateTime.now().millisecondsSinceEpoch);

                            context.router.replaceAll([const NaviBarRoute()]);
                          }
                        },
                        textColor: Colors.white,
                        color: AppColors.primaryColor.shade500,
                      ),

                      const SizedBox(height: 20),

                      // Register Text
                      GestureDetector(
                        onTap: () {
                          context.router.push(const RegistrationRoute());
                        },
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Not your account? ",
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.brightness == Brightness.dark
                                    ? Colors.white
                                    : AppColors.greyColor.shade700,
                              ),
                              children: const [
                                TextSpan(
                                  text: "Log Out",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(12),
                Align(
                  alignment: Alignment.center,
                  child: IconButton(
                      icon: const Icon(Icons.fingerprint, size: 36),
                      tooltip: 'Login with biometrics',
                      color: AppColors.primaryColor.shade400,
                      onPressed: () async {
                        final localAuth = LocalAuthentication();
                        final canCheck = await localAuth.canCheckBiometrics;

                        if (!canCheck) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Biometric not available on this device."),
                            ),
                          );
                          return;
                        }

                        // 🛡️ Disable splash redirect during biometric auth
                        LifecycleGuard.shouldForceSplashOnResume = false;

                        final didAuthenticate = await localAuth.authenticate(
                          localizedReason: 'Please authenticate to continue',
                          options:
                              const AuthenticationOptions(biometricOnly: true),
                        );

                        // ✅ Re-enable splash after biometric completes
                        LifecycleGuard.shouldForceSplashOnResume = true;

                        if (didAuthenticate) {
                          if (emailController.text.isEmpty) {
                            ToastService().showToast(
                              NotificationType.info,
                              message: 'Please enter your email',
                            );
                            return;
                          }

                          final result = await authentication.signIn(
                            emailController.text.trim(),
                            '',
                            biometric: true,
                          );

                          if (result == true) {
                            final box = Hive.box('data');
                            await box.put('remember_me', rememberMe.value);

                            if (rememberMe.value) {
                              await box.put(
                                  'saved_email', emailController.text.trim());
                            } else {
                              await box.delete('saved_email');
                            }

                            context.router.replaceAll([const NaviBarRoute()]);
                          }
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
