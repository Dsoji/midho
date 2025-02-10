import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/authentication/registration/presentation/widget/step_progress_indicator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../common/res/app_colors.dart';
import '../../../../common/widgets/custom_buttons.dart';
import '../../../../common/widgets/custom_textfield.dart';
import '../../pin_creation/presentation/create_pin.dart';

final pageControllerProvider = Provider<PageController>((ref) {
  return PageController();
});

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
      if (pageIndex.value > 0) {
        pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      }
    }

    return Scaffold(
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreatePinScreen()));
                  }),
                ],
              ),
            ),
          ],
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

    return Column(
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
                "Enter your mail to reset Password",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "We would send a six digit verification code to your email",
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

              const SizedBox(height: 20),

              // Continue Button
              FullButton(
                text: "Continue",
                width: double.infinity,
                height: 48,
                onPressed: onNext,
                textColor: Colors.white,
                color: AppColors.primaryColor.shade500,
              ),
              const Gap(20),
            ],
          ),
        ),
      ],
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
    final countdown = useState(100); // 1 min 40 seconds

    useEffect(() {
      Future.delayed(const Duration(seconds: 1), () {
        if (countdown.value > 0) {
          countdown.value--;
        }
      });
      return null;
    }, [countdown.value]);

    return Column(
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
                "Verify Your Email",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Enter the 6-digit code we just sent to johndoe@gmail.com",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // PIN Code Field
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: otpController,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 50,
                  fieldWidth: 45,
                  activeFillColor: Colors.white,
                  selectedColor: Colors.orange,
                  activeColor: Colors.orange,
                  inactiveColor: Colors.grey,
                ),
                onChanged: (value) {
                  isOtpFilled.value = value.length == 6;
                },
              ),

              const SizedBox(height: 20),

              // Resend Timer
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Didn't receive code? "),
                  Text(
                    "${countdown.value ~/ 60}:${(countdown.value % 60).toString().padLeft(2, '0')}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Verify Button

              FullButton(
                text: "Verify",
                width: double.infinity,
                height: 48,
                onPressed: onNext,
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

    return Column(
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
                "Reset Password",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
              Wrap(
                spacing: 10, // Horizontal space between items
                runSpacing: 5, // Vertical space between wrapped rows
                alignment: WrapAlignment.start, // Aligns items to the left
                direction: Axis.horizontal,
                children: [
                  _buildCriteriaIcon(
                      passwordController.text.length >= 8, "8 characters long"),
                  _buildCriteriaIcon(
                      RegExp(r'[A-Z]').hasMatch(passwordController.text),
                      "Uppercase"),
                  _buildCriteriaIcon(
                      RegExp(r'[0-9]').hasMatch(passwordController.text),
                      "Number"),
                  _buildCriteriaIcon(
                      RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                          .hasMatch(passwordController.text),
                      "Special character"),
                ],
              ),

              // Last Name Field
              const SizedBox(height: 20),

              FullButton(
                text: "Continue",
                width: double.infinity,
                height: 48,
                onPressed: onFinish,
                textColor: Colors.white,
                color: AppColors.primaryColor.shade500,
              ),
            ],
          ),
        ),
      ],
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
