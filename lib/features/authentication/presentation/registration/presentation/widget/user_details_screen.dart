import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:logger/logger.dart';
import 'package:mdiho/features/authentication/presentation/registration/presentation/widget/custom_dropdown.dart';

import '../../../../../../common/res/app_colors.dart';
import '../../../../../../common/utils/validator.dart';
import '../../../../../../common/widgets/custom_buttons.dart';
import '../../../../../../common/widgets/custom_textfield.dart';
import '../../../../data/controller/authentication_controller.dart';
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
    var box = Hive.box('data');
    String? deviceId = box.get('device_id');
    final formKey = GlobalKey<FormState>();
    final country = useState('');
    String formattedPhoneNumber = '';

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
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
                      fontWeight: FontWeight.bold,
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

                  // First Name Field
                  CustomTextField(
                    controller: firstNameController,
                    label: "First Name",
                    hintText: "eg. John",
                    validator: (value) =>
                        Validators.requiredField(value, "First name"),
                  ),
                  const SizedBox(height: 15),

                  // Last Name Field
                  CustomTextField(
                    controller: lastNameController,
                    label: "Last Name",
                    hintText: "eg. Doe",
                    validator: (value) => Validators.requiredField(
                        value, "Last name"), // ✅ CORRECT
                  ),
                  const SizedBox(height: 15),

                  // Country Dropdown
                  Text("Select Country",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : AppColors.greyColor.shade700,
                      )),
                  const SizedBox(height: 8),
                  CustomDropdown(
                    onChanged: (value) {
                      country.value = value!;
                      print(country.value);
                    },
                  ),

                  const SizedBox(height: 15),

                  // Phone Number Field with Country Code
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
                  IntlPhoneField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: "Enter phone number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          width: 0.5,
                          color: theme.brightness == Brightness.light
                              ? AppColors.greyColor.shade50
                              : AppColors.secondaryColor.shade400,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.red.shade100,
                        ),
                      ),
                    ),
                    initialCountryCode: "NG",
                    onChanged: (phone) {
                      selectedCountry.value = phone.countryCode;

                      // Keep the phone number as entered by the user in the controller
                      String enteredPhone = phone.number;

                      // If the phone number starts with '0', replace it with the country code
                      if (enteredPhone.startsWith('0')) {
                        enteredPhone =
                            enteredPhone.replaceFirst('0', phone.countryCode);
                      } else {
                        // If the number doesn't start with '0', prepend the country code
                        enteredPhone = phone.countryCode + enteredPhone;
                      }

                      // Store the final formatted phone number without affecting the text field
                      formattedPhoneNumber = enteredPhone;
                    },
                    disableLengthCheck: true,
                    validator: (phone) {
                      if (phone == null || phone.number.isEmpty) {
                        return 'Phone number is required'; // Custom validation message
                      }
                      // Optionally check if the country code and phone number are valid
                      if (phone.number.length < 10) {
                        return 'Please enter a valid phone number';
                      }
                      return null; // If phone is valid, return null
                    },
                  ),
                  const SizedBox(height: 20),

                  // Terms and Conditions
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "By pressing Sign up securely, you agree to our ",
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : AppColors.greyColor.shade700,
                        height: 16.8 / 12,
                      ),
                      children: [
                        TextSpan(
                          text: "Terms & Conditions",
                          style: TextStyle(
                            color: AppColors.primaryColor.shade500,
                            height: 16.8 / 12,
                          ),
                        ),
                        const TextSpan(text: " and "),
                        TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(
                            color: AppColors.primaryColor.shade500,
                            height: 16.8 / 12,
                          ),
                        ),
                        TextSpan(
                          text:
                              ". Digital-only support available 24/7 via the in-app chat. Your data will be securely encrypted with TLS 🔒",
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.brightness == Brightness.dark
                                ? Colors.white
                                : AppColors.greyColor.shade700,
                            height: 16.8 / 12,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreatePinScreen()),
                      );
                      // if (!formKey.currentState!.validate()) {
                      //   return;
                      // }
                      // if (country.value != '') {
                      //   if (phoneController.text.isNotEmpty) {
                      //     var box = Hive.box('data');
                      //     final String email = box.get('email');
                      //     final String password = box.get('password');
                      //     final String referral = box.get('referral');
                      //     final String storedToken = box.get('fcm_token');
                      //     logger.d(email);
                      //     logger.d(password);
                      //     logger.d(referral);
                      //     logger.d(storedToken);
                      //     authService.updateProfileDetails(ProfilePayload(
                      //       firstname: firstNameController.text.trim(),
                      //       lastname: lastNameController.text.trim(),
                      //       phone: phoneController.text.trim(),
                      //     ));
                      //     final result = await authService.signUp(
                      //       SignUpPayload(
                      //         email: email,
                      //         password: password,
                      //         referral: referral,
                      //         firstname: firstNameController.text.trim(),
                      //         lastname: lastNameController.text.trim(),
                      //         country: 'NG',
                      //         phone: formattedPhoneNumber,
                      //         device: deviceId,
                      //         fcmToken: storedToken,
                      //       ),
                      //     );
                      //     if (result == true) {
                      //       final localAuth = LocalAuthentication();
                      //       final canAuthenticate =
                      //           await localAuth.canCheckBiometrics ||
                      //               await localAuth.isDeviceSupported();

                      //       if (canAuthenticate) {
                      //         final availableBiometrics =
                      //             await localAuth.getAvailableBiometrics();
                      //         if (availableBiometrics.isNotEmpty) {
                      //           try {
                      //             final authenticated =
                      //                 await localAuth.authenticate(
                      //               localizedReason:
                      //                   "Authenticate to complete registration",
                      //               options: const AuthenticationOptions(
                      //                   biometricOnly: true),
                      //             );

                      //             var box = Hive.box('data');
                      //             box.put('biometric_auth', authenticated);

                      //             if (authenticated) {
                      //               Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                     builder: (context) =>
                      //                         const CreatePinScreen()),
                      //               );
                      //             }
                      //           } catch (e) {
                      //             debugPrint(
                      //                 "Biometric authentication failed: $e");
                      //             var box = Hive.box('data');
                      //             box.put('biometric_auth', false);

                      //             Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) =>
                      //                       const CreatePinScreen()),
                      //             );
                      //           }
                      //         } else {
                      //           debugPrint(
                      //               "Biometric authentication is not available on this device.");
                      //           var box = Hive.box('data');
                      //           box.put('biometric_auth', false);

                      //           Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) =>
                      //                     const CreatePinScreen()),
                      //           );
                      //         }
                      //       } else {
                      //         debugPrint(
                      //             "Biometric authentication is not available on this device.");
                      //         var box = Hive.box('data');
                      //         box.put('biometric_auth', false);

                      //         Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) =>
                      //                   const CreatePinScreen()),
                      //         );
                      //       }
                      //     }
                      //   } else {
                      //     ToastService().showToast(
                      //       NotificationType.info,
                      //       message: 'Fill all fields',
                      //     );
                      //   }
                      // } else {
                      //   ToastService().showToast(
                      //     NotificationType.info,
                      //     message: 'Select a country',
                      //   );
                      // }
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
