import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';

import '../../../../../../common/res/app_colors.dart';
import '../../../../../../common/toast/toast.dart';
import '../../../../../../common/utils/validator.dart';
import '../../../../../../common/widgets/custom_buttons.dart';
import '../../../../../../common/widgets/custom_textfield.dart';
import '../../../../../../main.dart';
import '../../../../data/controller/authentication_controller.dart';
import '../../../../data/model/payload/profile_payload.dart';
import '../../../../data/model/payload/sign_up_payload.dart';
import '../../../pin_creation/presentation/create_pin.dart';

final logger = Logger();

class UserDetailsStep extends HookConsumerWidget {
  final VoidCallback onFinish;

  const UserDetailsStep({super.key, required this.onFinish});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final selectedCountry = useState("Nigeria");
    final theme = Theme.of(context);
    final authService = ref.read(authenticationControllerProvider.notifier);
    final formKey = GlobalKey<FormState>();
    final box = Hive.box('data');
    final deviceId = box.get('device_id');

    const countryCodeMap = {'Nigeria': 'NG'};
    final isBio = useState(false);

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: ShapeDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade600
                    : AppColors.whiteColor.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                shadows: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Let's Set Up Your Account",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Provide the following details to set up your account",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: firstNameController,
                    label: "First Name",
                    hintText: "eg. John",
                    validator: (value) =>
                        Validators.requiredField(value, "First name"),
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: lastNameController,
                    label: "Last Name",
                    hintText: "eg. Doe",
                    validator: (value) =>
                        Validators.requiredField(value, "Last name"),
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: phoneController,
                    label: "Phone Number",
                    hintText: "eg. 8023456789",
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(' 🇳🇬 ', style: TextStyle(fontSize: 18)),
                          SizedBox(width: 4),
                          Text('+234', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                    validator: (value) =>
                        Validators.requiredField(value, "Phone number"),
                    onChanged: (_) {}, // Prevent state rebuild
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Select Country",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : AppColors.greyColor.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField2<String>(
                    value: selectedCountry.value,
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          width: 0.5,
                          color: theme.brightness == Brightness.light
                              ? AppColors.greyColor.shade50
                              : AppColors.secondaryColor.shade400,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: theme.brightness == Brightness.dark
                            ? AppColors.secondaryColor.shade400
                            : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      elevation: 3,
                    ),
                    onChanged: (value) {
                      if (value != null) selectedCountry.value = value;
                    },
                    items: ["Nigeria"]
                        .map((country) => DropdownMenuItem(
                              value: country,
                              child: Text(country),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "By pressing Sign up securely, you agree to our ",
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : AppColors.greyColor.shade700,
                        height: 1.4,
                      ),
                      children: [
                        TextSpan(
                          text: "Terms & Conditions",
                          style:
                              TextStyle(color: AppColors.primaryColor.shade500),
                        ),
                        const TextSpan(text: " and "),
                        TextSpan(
                          text: "Privacy Policy",
                          style:
                              TextStyle(color: AppColors.primaryColor.shade500),
                        ),
                        TextSpan(
                          text:
                              ". Digital-only support available 24/7 via the in-app chat. Your data will be securely encrypted with TLS 🔒",
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.brightness == Brightness.dark
                                ? Colors.white
                                : AppColors.greyColor.shade700,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FullButton(
                    isLoading: ref
                        .watch(authenticationControllerProvider)
                        .signUp
                        .isLoading,
                    text: "Sign Up",
                    width: double.infinity,
                    height: 48,
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;

                      final rawPhone = phoneController.text.trim();
                      final formattedPhone =
                          '+234${rawPhone.replaceAll(RegExp(r'^0+'), '')}';

                      final email = box.get('email');
                      final password = box.get('password');
                      final referral = box.get('referral');
                      final fcmToken = box.get('fcm_token');

                      authService.updateProfileDetails(ProfilePayload(
                        firstname: firstNameController.text.trim(),
                        lastname: lastNameController.text.trim(),
                        phone: rawPhone,
                      ));

                      final result = await authService.signUp(SignUpPayload(
                        email: email,
                        password: password,
                        referral: referral,
                        firstname: firstNameController.text.trim(),
                        lastname: lastNameController.text.trim(),
                        country: countryCodeMap[selectedCountry.value] ?? 'NG',
                        phone: formattedPhone,
                        device: deviceId,
                        fcmToken: fcmToken,
                      ));

                      if (result == true) {
                        // 🛡 Temporarily disable splash redirect
                        LifecycleGuard.shouldForceSplashOnResume = false;

                        final localAuth = LocalAuthentication();
                        bool isBiometricEnabled = false;

                        try {
                          final canCheck = await localAuth.canCheckBiometrics;
                          final isSupported =
                              await localAuth.isDeviceSupported();

                          if (canCheck && isSupported) {
                            final authenticated = await localAuth.authenticate(
                              localizedReason:
                                  "Authenticate to enable biometric login",
                              options: const AuthenticationOptions(
                                  biometricOnly: true),
                            );
                            isBiometricEnabled = authenticated;
                          }
                        } catch (e) {
                          logger.e("Biometric auth failed: $e");
                        }

                        // ✅ Delay re-enabling to allow smooth nav
                        Future.delayed(const Duration(milliseconds: 500), () {
                          LifecycleGuard.shouldForceSplashOnResume = true;
                        });

                        await box.put('biometric', isBiometricEnabled);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CreatePinScreen(
                              firstname: firstNameController.text.trim(),
                              lastname: lastNameController.text.trim(),
                              phone: formattedPhone,
                              biometric: isBiometricEnabled,
                            ),
                          ),
                        );
                      } else {
                        ToastService().showToast(NotificationType.error,
                            message: 'Sign-up failed. Please try again.');
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
      ),
    );
  }
}
