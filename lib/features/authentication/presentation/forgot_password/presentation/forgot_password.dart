import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/authentication/presentation/registration/presentation/widget/step_progress_indicator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../common/res/app_colors.dart';
import '../../../../../common/toast/toast.dart';
import '../../../../../common/utils/validator.dart';
import '../../../../../common/widgets/custom_buttons.dart';
import '../../../../../common/widgets/custom_textfield.dart';
import '../../../data/controller/authentication_controller.dart';
import '../../login/presentation/login_screen.dart';

final pageControllerProvider = Provider<PageController>((ref) {
  return PageController();
});

var box = Hive.box('data');

final registrationProvider =
    StateNotifierProvider<RegistrationNotifier, RegistrationState>(
  (ref) => RegistrationNotifier(),
);

class RegistrationNotifier extends StateNotifier<RegistrationState> {
  RegistrationNotifier() : super(RegistrationState());

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void updateOtp(String otp) {
    state = state.copyWith(otp: otp);
  }

  void updateUserDetails(
      String firstName, String lastName, String country, String phone) {
    state = state.copyWith(
        firstName: firstName,
        lastName: lastName,
        country: country,
        phone: phone);
  }
}

class RegistrationState {
  final String email;
  final String password;
  final String otp;
  final String firstName;
  final String lastName;
  final String country;
  final String phone;

  RegistrationState({
    this.email = '',
    this.password = '',
    this.otp = '',
    this.firstName = '',
    this.lastName = '',
    this.country = 'Nigeria',
    this.phone = '',
  });

  RegistrationState copyWith({
    String? email,
    String? password,
    String? otp,
    String? firstName,
    String? lastName,
    String? country,
    String? phone,
  }) {
    return RegistrationState(
      email: email ?? this.email,
      password: password ?? this.password,
      otp: otp ?? this.otp,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      country: country ?? this.country,
      phone: phone ?? this.phone,
    );
  }
}

@RoutePage()
class ForgotPasswordScreen extends HookConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(pageControllerProvider);
    final pageIndex = useState(0);

    void goBack() {
      if (pageIndex.value == 2) {
        // If on page 2, always go back to page 0
        pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else if (pageIndex.value > 0) {
        // Otherwise, go to the previous page normally
        pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }

    return PopScope(
      canPop: pageIndex.value == 0, // Prevents popping when not on first page
      onPopInvoked: (didPop) {
        if (!didPop && pageIndex.value > 0) {
          goBack();
        } else if (!didPop && pageIndex.value > 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: StepProgressIndicator(
            currentStep: pageIndex.value + 1,
            totalSteps: 3,
            onBack: pageIndex.value > 0 ? goBack : null,
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: PageView(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) => pageIndex.value = index,
                  children: [
                    EmailPasswordStep(
                        onNext: () => pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut)),
                    OtpVerificationStep(
                        onNext: () => pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut)),
                    UserDetailsStep(onFinish: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }),
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

class EmailPasswordStep extends HookConsumerWidget {
  final VoidCallback onNext;

  const EmailPasswordStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final referralController = useTextEditingController();
    final obscurePassword = useState(true);
    final passwordStrength = useState("Weak");
    final authService = ref.read(authenticationControllerProvider.notifier);

    bool isValidEmail(String email) {
      return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
          .hasMatch(email);
    }

    final formKey = GlobalKey<FormState>();

    final theme = Theme.of(context);
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
                const Text(
                  "Enter your mail to reset Password",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "We would send a six digit verification code to your email",
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
                    final result = await authService.emailVerify(
                      emailController.text.trim(),
                      referralController.text.trim(),
                      'RESETPASSWORD',
                    );
                    if (result == true) {
                      await box.put('email', emailController.text.trim());

                      onNext(); // Correctly invoke the function
                    }
                  },
                  textColor: Colors.white,
                  color: AppColors.primaryColor.shade500,
                ),
                const Gap(20),
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

class OtpVerificationStep extends HookConsumerWidget {
  final VoidCallback onNext;

  const OtpVerificationStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otpController = useTextEditingController();
    final isOtpFilled = useState(false);
    final countdown = useState(100);
    final isCounting = useState(true);
    final authService = ref.read(authenticationControllerProvider.notifier);

    useEffect(() {
      Timer? timer;

      if (isCounting.value) {
        countdown.value = 100; // Reset countdown when starting
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (countdown.value > 0) {
            countdown.value--;
          } else {
            isCounting.value = false; // Stop timer and show "Resend Code"
            timer.cancel();
          }
        });
      }

      return () => timer?.cancel(); // Cleanup the timer on unmount
    }, [isCounting.value]); // Only restart timer when "Resend Code" is tapped

    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
              const Text(
                "Verify Your Email",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Enter the 6-digit code we just sent to johndoe@gmail.com",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),

              // PIN Code Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: theme.brightness == Brightness.dark
                          ? AppColors.whiteColor.shade50
                          : Colors.black),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 45,
                    fieldWidth: 45,
                    activeFillColor: theme.brightness == Brightness.dark
                        ? AppColors.secondaryColor.shade400
                        : const Color(0x0fffff5f),
                    inactiveFillColor: AppColors.secondaryColor.shade400,
                    selectedFillColor: AppColors.secondaryColor.shade400,
                    selectedColor: AppColors.primaryColor,
                    activeColor: AppColors.primaryColor,
                    inactiveColor: Colors.grey,
                  ),
                  onChanged: (value) {
                    isOtpFilled.value = value.trim().length == 6;
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Resend Timer
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Didn't receive code "),
                  isCounting.value
                      ? Text(
                          "${countdown.value ~/ 60}:${(countdown.value % 60).toString().padLeft(2, '0')}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      : GestureDetector(
                          onTap: () {
                            // Restart countdown
                            isCounting.value = true;
                          },
                          child: Text(
                            "Resend Code",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors
                                  .primaryColor, // Highlight clickable text
                            ),
                          ),
                        ),
                ],
              ),

              const SizedBox(height: 30),

              // Verify Button
              FullButton(
                text: "Verify",
                width: double.infinity,
                height: 48,
                onPressed: () async {
                  if (otpController.text.trim().length != 6) {
                    ToastService().showToast(
                      NotificationType.info,
                      message: 'Please enter a complete OTP.',
                    );
                    return;
                  }
                  await box.put('otp', otpController.text.trim());

                  onNext();
                },
                textColor: Colors.white,
                color: AppColors.primaryColor.shade500,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class UserDetailsStep extends HookConsumerWidget {
  final VoidCallback onFinish;

  const UserDetailsStep({super.key, required this.onFinish});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final selectedCountry = useState("Nigeria");
    final passwordController = useTextEditingController();
    final theme = Theme.of(context);
    final authService = ref.read(authenticationControllerProvider.notifier);
    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
                const Text(
                  "Reset Password",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Enter your new password below",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // First Name Field
                CustomTextField(
                  controller: passwordController,
                  label: "Password",
                  prefixIcon: Icons.lock_outline, // Optional
                  isPassword: true,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCriteriaIcon(passwordController.text.length >= 8,
                        "8 characters long"),
                    _buildCriteriaIcon(
                        RegExp(r'[A-Z]').hasMatch(passwordController.text),
                        "Uppercase"),
                    _buildCriteriaIcon(
                        RegExp(r'[0-9]').hasMatch(passwordController.text),
                        "Number"),
                  ],
                ),
                const Gap(4),
                _buildCriteriaIcon(
                    RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                        .hasMatch(passwordController.text),
                    "Special character"),

                // Last Name Field
                const SizedBox(height: 20),

                FullButton(
                  isLoading: ref
                      .watch(authenticationControllerProvider)
                      .forgotPassword
                      .isLoading,
                  text: "Continue",
                  width: double.infinity,
                  height: 48,
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }
                    final String email = box.get('email');
                    final String code = box.get('otp');
                    final result = await authService.forgotPassword(
                      email,
                      code,
                      passwordController.text.trim(),
                    );
                    if (result == true) {
                      onFinish();
                    }
                  },
                  textColor: Colors.white,
                  color: AppColors.primaryColor.shade500,
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
