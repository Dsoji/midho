import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';
import 'package:mdiho/features/authentication/presentation/registration/presentation/widget/custom_dropdown.dart';

import '../../../../../../common/res/app_colors.dart';
import '../../../../../../common/toast/toast.dart';
import '../../../../../../common/utils/validator.dart';
import '../../../../../../common/widgets/custom_buttons.dart';
import '../../../../../../common/widgets/custom_textfield.dart';
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
    final formattedPhoneNumber = useState('');
    final country = useState('');
    final theme = Theme.of(context);
    final authService = ref.read(authenticationControllerProvider.notifier);
    final formKey = GlobalKey<FormState>();
    final box = Hive.box('data');
    final deviceId = box.get('device_id');

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                    Builder(
                      builder: (_) => CustomDropdown(
                        key: const Key("countryDropdown"),
                        onChanged: (value) {
                          country.value = value!;
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Phone",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : AppColors.greyColor.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Builder(
                      builder: (_) => IntlPhoneField(
                        key: const Key("intlPhoneField"),
                        controller: phoneController,
                        initialCountryCode: "NG",
                        disableLengthCheck: true,
                        decoration: InputDecoration(
                          labelText: "Enter phone number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.red.shade100),
                          ),
                        ),
                        onChanged: (phone) {
                          selectedCountry.value = phone.countryCode;
                          String enteredPhone = phone.number;
                          if (enteredPhone.startsWith('0')) {
                            enteredPhone = enteredPhone.replaceFirst(
                                '0', phone.countryCode);
                          } else {
                            enteredPhone = phone.countryCode + enteredPhone;
                          }
                          formattedPhoneNumber.value = enteredPhone;
                        },
                        validator: (phone) {
                          if (phone == null || phone.number.trim().isEmpty) {
                            return 'Phone number is required';
                          }
                          if (phone.number.length < 10) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
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
                            style: TextStyle(
                                color: AppColors.primaryColor.shade500),
                          ),
                          const TextSpan(text: " and "),
                          TextSpan(
                            text: "Privacy Policy",
                            style: TextStyle(
                                color: AppColors.primaryColor.shade500),
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
                        if (country.value.isEmpty) {
                          ToastService().showToast(NotificationType.info,
                              message: 'Select a country');
                          return;
                        }
                        if (phoneController.text.isEmpty) {
                          ToastService().showToast(NotificationType.info,
                              message: 'Fill all fields');
                          return;
                        }

                        final email = box.get('email');
                        final password = box.get('password');
                        final referral = box.get('referral');
                        final fcmToken = box.get('fcm_token');

                        authService.updateProfileDetails(ProfilePayload(
                          firstname: firstNameController.text.trim(),
                          lastname: lastNameController.text.trim(),
                          phone: phoneController.text.trim(),
                        ));

                        final result = await authService.signUp(SignUpPayload(
                          email: email,
                          password: password,
                          referral: referral,
                          firstname: firstNameController.text.trim(),
                          lastname: lastNameController.text.trim(),
                          country: 'NG',
                          phone: formattedPhoneNumber.value,
                          device: deviceId,
                          fcmToken: fcmToken,
                        ));

                        if (result == true) {
                          final localAuth = LocalAuthentication();
                          final canAuthenticate =
                              await localAuth.canCheckBiometrics ||
                                  await localAuth.isDeviceSupported();

                          if (canAuthenticate) {
                            try {
                              final authenticated =
                                  await localAuth.authenticate(
                                localizedReason:
                                    "Authenticate to complete registration",
                                options: const AuthenticationOptions(
                                    biometricOnly: true),
                              );
                              box.put('biometric_auth', authenticated);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CreatePinScreen(),
                                ),
                              );
                            } catch (e) {
                              box.put('biometric_auth', false);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CreatePinScreen(),
                                ),
                              );
                            }
                          } else {
                            box.put('biometric_auth', false);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CreatePinScreen(),
                              ),
                            );
                          }
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
      ),
    );
  }
}
