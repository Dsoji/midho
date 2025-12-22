import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mdiho/common/res/app_colors.dart';
import 'package:mdiho/common/widgets/custom_app_bar.dart';
import 'package:mdiho/common/widgets/custom_buttons.dart';
import 'package:mdiho/common/widgets/custom_textfield.dart';
import 'package:mdiho/features/kyc/bvn_verification.dart';
import 'package:mdiho/features/kyc/selfie_verification.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';

class NINVerificationScreen extends HookConsumerWidget {
  const NINVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final ninController = useTextEditingController();
    final isButtonEnabled = useState(false);

    useEffect(() {
      void listener() {
        isButtonEnabled.value = ninController.text.length == 11;
      }

      ninController.addListener(listener);
      return () => ninController.removeListener(listener);
    }, [ninController]);

    return Scaffold(
      appBar: const CustomAppBar(
        showBackButton: true,
        showTitle: false,
        showAction: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(10),
              Text(
                'National Identification number Verification',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              const Gap(8),
              Text(
                'Enter your National Identification number to proceed',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const Gap(32),

              // Input Field
              CustomTextField(
                controller: ninController,
                label: "National Identification number",
                hintText: "234521345463",
                keyboardType: TextInputType.number,
                maxLength: 11,
              ),

              const Gap(24),

              // Info Box with USSD code
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.secondaryColor.shade500
                      : const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      HugeIcons.strokeRoundedInformationCircle,
                      size: 20,
                      color: theme.iconTheme.color,
                    ),
                    const Gap(12),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text:
                              'You can retrieve your national identity number by dialing ',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text: '*346#',
                              style: const TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle USSD dial intent if needed
                                },
                            ),
                            TextSpan(
                              text:
                                  ' This USSD code works on all Nigerian networks (MTN, Airtel, Glo, 9mobile)',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Gap(140),

              // Submit Button
              FullButton(
                text: "Submit for Verification",
                width: double.infinity,
                height: 50,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SelfieVerificationScreen(),
                    ),
                  );
                },
                textColor: Colors.white,
                color: AppColors.primaryColor,
                isDisabled: !isButtonEnabled.value,
              ),

              const Gap(24),

              // Footer Security Note
              VerifyEncryptWidget(
                theme: theme,
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}
