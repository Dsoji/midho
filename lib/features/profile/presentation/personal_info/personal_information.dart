import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';
import 'package:mdiho/features/profile/presentation/personal_info/change_username.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';

import '../../../../common/res/app_colors.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/custom_buttons.dart';
import '../../../../common/widgets/custom_textfield.dart';
import '../../../authentication/data/controller/authentication_controller.dart';
import '../../../authentication/data/model/payload/profile_payload.dart';
import '../../data/controller/profile_controller.dart';

@RoutePage()
class PersonalInfoScreen extends HookConsumerWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final selectedCountry = useState("Nigeria");
    final emailController = useTextEditingController();
    final userInfo =
        ref.watch(authenticationControllerProvider).userDetails.valueOrNull;
    final authService = ref.read(authenticationControllerProvider.notifier);
    final profileService = ref.read(profileControllerProvider.notifier);
    final firstNameController =
        useTextEditingController(text: userInfo?.firstname);
    final userNameController =
        useTextEditingController(text: userInfo?.username);
    final lastNameController =
        useTextEditingController(text: userInfo?.lastname);
    final phoneController = useTextEditingController(text: userInfo?.phone);
    Hive.box('data'); // Replace 'data' with your box name
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Personal Information",
        showBackButton: true,
        showTitle: true,
        showAction: false,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Update your name, or phone number. Keep your details up-to-date to avoid issues.",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const Gap(10),
              Container(
                decoration: ShapeDecoration(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.darkBorder
                      : AppColors.whiteColor.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      readOnly: true,
                      controller: emailController,
                      label: "Email",
                      hintText: '${userInfo?.email}',
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Colors.grey,
                        size: 21,
                      ), // Optional
                      keyboardType: TextInputType.emailAddress,
                      suffixIcon: InkWell(
                        onTap: () {
                          context.router.push(const ChangeEmailRoute());
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const ChangeEmailScreen()));
                        },
                        child: Icon(
                          IconsaxPlusLinear.edit_2,
                          size: 16,
                          color: AppColors.primaryColor.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: userNameController,
                      label: "User Name",
                      hintText: "@${userInfo?.username}",
                      readOnly: true,
                      suffixIcon: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangeUsernameScreen(
                                        userame: '${userInfo?.username}',
                                      )));
                        },
                        child: Icon(
                          IconsaxPlusLinear.edit_2,
                          size: 16,
                          color: AppColors.primaryColor.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // First Name Field
                    CustomTextField(
                      controller: firstNameController,
                      label: "First Name",
                      hintText: "${userInfo?.firstname}",
                    ),
                    const SizedBox(height: 15),

                    // Last Name Field
                    CustomTextField(
                      controller: lastNameController,
                      label: "Last Name",
                      hintText: "${userInfo?.lastname}",
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
                          hintText: "${userInfo?.phone}",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              width: 0.5,
                              color: theme.brightness == Brightness.light
                                  ? AppColors.greyColor.shade50
                                  : AppColors.secondaryColor.shade400,
                            ),
                          )),
                      initialCountryCode: "NG",
                      onChanged: (phone) {
                        selectedCountry.value = phone.countryCode;
                      },
                      disableLengthCheck: true,
                    ),
                    const SizedBox(height: 20),
                    InfoWidget(
                        theme: theme,
                        text:
                            'Ensure your contact details are accurate for transaction and security alerts.'),
                    // Terms and Conditions
                    const SizedBox(height: 20),

                    FullButton(
                      isLoading: ref
                          .watch(profileControllerProvider)
                          .forgotPassword
                          .isLoading,
                      text: "Save Changes",
                      width: double.infinity,
                      height: 48,
                      onPressed: () async {
                        authService.updateProfileDetails(
                          ProfilePayload(
                            firstname: firstNameController.text.trim().isEmpty
                                ? null
                                : firstNameController.text.trim(),
                            lastname: lastNameController.text.trim().isEmpty
                                ? null
                                : lastNameController.text.trim(),
                            phone: phoneController.text.trim().isEmpty
                                ? null
                                : phoneController.text.trim(),
                          ),
                        );
                        final profileDetails = ref
                            .watch(authenticationControllerProvider)
                            .profilePayload
                            .valueOrNull;
                        final result =
                            await profileService.updateProfile(profileDetails!);
                        if (result == true) {
                          await ref
                              .read(authenticationControllerProvider.notifier)
                              .fetchProfile()
                              .then((_) {
                            Navigator.pop(context);
                          });
                        }
                      },
                      textColor: Colors.white,
                      color: AppColors.primaryColor.shade500,
                    ),
                  ],
                ),
              ),
              const Gap(150),
            ],
          ),
        ),
      ),
    );
  }
}
