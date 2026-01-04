import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mdiho/common/res/app_colors.dart';
import 'package:mdiho/common/res/assets.dart';
import 'package:mdiho/common/widgets/custom_app_bar.dart';
import 'package:mdiho/common/widgets/custom_buttons.dart';
import 'package:mdiho/common/widgets/custom_textfield.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';
import 'package:permission_handler/permission_handler.dart';

@RoutePage()
class BvnVerificationScreen extends HookConsumerWidget {
  const BvnVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bvnController = useTextEditingController(text: "");
    final isButtonEnabled = useState(false);

    useEffect(() {
      void listener() {
        isButtonEnabled.value = bvnController.text.length >= 11;
      }

      bvnController.addListener(listener);
      return () => bvnController.removeListener(listener);
    }, [bvnController]);

    Future<void> requestCameraPermission() async {
      var status = await Permission.camera.status;

      if (status.isGranted) {
        print("Camera permission is granted");
      } else if (status.isDenied) {
        final Map<Permission, PermissionStatus> statuses = await [
          Permission.camera,
        ].request();
        // Handle the new status
      } else if (status.isPermanentlyDenied) {
        openAppSettings();
      }
    }

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Bank verification number",
        showBackButton: true,
        centerTitle: false,
        showTitle: false,
        showAction: false,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            // Dismiss keyboard when tapping outside
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                Text(
                  'Bank verification number',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                const Gap(8),
                Text(
                  'Enter your bank Bank verification number to proceed',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const Gap(32),

                // Input
                CustomTextField(
                  controller: bvnController,
                  label: "Bank verification number",
                  hintText: "Enter BVN",
                  keyboardType: TextInputType.number,
                  maxLength: 11,
                ),

                const Gap(24),

                // Info Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? AppColors.secondaryColor.shade400
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                text:
                                    'You can retrieve your national identity number by dialing ',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 12,
                                  height: 1.5,
                                ),
                                children: [
                                  TextSpan(
                                    text: '*565*0#',
                                    style: TextStyle(
                                      color: theme.brightness == Brightness.dark
                                          ? Colors.white
                                          : AppColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Handle tap
                                      },
                                  ),
                                ],
                              ),
                            ),
                            const Gap(8),
                            Text(
                              'Important Notes:',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Gap(4),
                            _buildBulletPoint(
                                'It works on MTN, Airtel, Glo, and 9mobile.',
                                theme),
                            _buildBulletPoint(
                                'Your SIM must be the one linked to your BVN.',
                                theme),
                            _buildBulletPoint(
                                'A small service fee usually applies (₦20-₦30 depending on the network).',
                                theme),
                          ],
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
                  onPressed: () async {
                    await requestCameraPermission();
                    var status = await Permission.camera.status;
                    if (status.isGranted) {
                      context.router.push(
                          SelfieVerificationRoute(bvn: bvnController.text));
                    }
                  },
                  textColor: Colors.white,
                  color: AppColors.primaryColor,
                  isDisabled: !isButtonEnabled.value,
                ),

                const Gap(24),

                // Footer
                VerifyEncryptWidget(theme: theme),
                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style:
                theme.textTheme.bodyLarge?.copyWith(fontSize: 12, height: 1.4),
          ),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontSize: 12, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class VerifyEncryptWidget extends StatelessWidget {
  const VerifyEncryptWidget({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? AppColors.primaryColor.shade900.withOpacity(0.3)
            : const Color(0xFFE0F2FE).withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Image.asset(
            ImageAssets.verify,
            width: 18.05,
            height: 24,
          ),
          const Gap(12),
          Expanded(
            child: Text(
              'Your information is encrypted and securely stored in accordance with CBN guidelines',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
