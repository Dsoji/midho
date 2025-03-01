import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../common/widgets/custom_buttons.dart';
import '../../../common/widgets/custom_textfield.dart';

@RoutePage()
class PersonalInfoScreen extends HookConsumerWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final firstNameController = useTextEditingController();
    final userNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final selectedCountry = useState("Nigeria");
    final emailController = useTextEditingController();

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Personal Information",
        showBackButton: true,
        showTitle: true,
        showAction: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Update your name, or phone number. Keep your details up-to-date to avoid issues.",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Gap(10),
            Container(
              decoration: ShapeDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade600
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
                  CustomTextField(
                    controller: emailController,
                    label: "Email",
                    prefixIcon: Icons.email_outlined, // Optional
                    keyboardType: TextInputType.emailAddress,
                    suffixIcon: Icon(
                      IconsaxPlusLinear.edit_2,
                      size: 16,
                      color: AppColors.primaryColor.shade600,
                    ),
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: userNameController,
                    label: "User Name",
                    hintText: "eg. John",
                    suffixIcon: Icon(
                      IconsaxPlusLinear.edit_2,
                      size: 16,
                      color: AppColors.primaryColor.shade600,
                    ),
                  ),
                  const SizedBox(height: 15),
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
                          borderRadius: BorderRadius.circular(8)),
                    ),
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
                    text: "Save Changes",
                    width: double.infinity,
                    height: 48,
                    onPressed: () {},
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
