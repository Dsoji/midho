import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mdiho/features/authentication/login/presentation/login_screen.dart';
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
class RegistrationScreen extends HookConsumerWidget {
  const RegistrationScreen({super.key});

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
                "Let's Set Up Your Account",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                "Provide the following details to set up your account",
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

              const SizedBox(height: 5),

              Row(
                children: [
                  const Text("Password Strength: ",
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  Text(
                    passwordStrength.value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: passwordStrength.value == "Weak"
                          ? Colors.red
                          : passwordStrength.value == "Medium"
                              ? Colors.orange
                              : Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Password Criteria
              Row(
                children: [
                  _buildCriteriaIcon(
                      passwordController.text.length >= 8, "8 characters long"),
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
              const SizedBox(height: 20),

              // Referral Code (Optional)
              CustomTextField(
                controller: referralController,
                label: "Referral Code (Optional)",
                suffixIcon: Icons.paste,
                onSuffixTap: () {
                  referralController.text = "REF123"; // Simulate pasting a code
                },
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
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                      children: [
                        TextSpan(
                          text: "Log In",
                          style: TextStyle(
                              color: AppColors.primaryColor,
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
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
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
                "Let's Set Up Your Account",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                "Provide the following details to set up your account",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // First Name Field
              CustomTextField(
                controller: firstNameController,
                label: "First Name",
                hintText: "eg. John",
              ),
              const SizedBox(height: 15),

              // Last Name Field
              CustomTextField(
                controller: lastNameController,
                label: "Last Name",
                hintText: "eg. Doe",
              ),
              const SizedBox(height: 15),

              // Country Dropdown
              const Text("Select Country",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedCountry.value,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) => selectedCountry.value = value!,
                items: ["Nigeria", "Ghana", "Kenya", "South Africa"]
                    .map((country) => DropdownMenuItem(
                          value: country,
                          child: Text(country),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 15),

              // Phone Number Field with Country Code
              const Text("Phone",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              // Phone Number Field using IntlPhoneField
              const Text("Phone",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              IntlPhoneField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: "Enter phone number",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                initialCountryCode: "NG",
                onChanged: (phone) {
                  selectedCountry.value = phone.countryCode;
                },
              ),
              const SizedBox(height: 20),

              // Terms and Conditions
              RichText(
                text: const TextSpan(
                  text: "By pressing Sign up securely, you agree to our ",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  children: [
                    TextSpan(
                      text: "Terms & Conditions",
                      style: TextStyle(
                          color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: " and "),
                    TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(
                          color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                        text:
                            ". Digital-only support available 24/7 via the in-app chat. Your data will be securely encrypted with TLS 🔒"),
                  ],
                ),
              ),
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
}
