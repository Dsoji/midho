import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/kyc/bvn_verification.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mdiho/common/res/app_colors.dart';
import 'package:mdiho/common/widgets/custom_app_bar.dart';
import 'package:mdiho/common/widgets/custom_buttons.dart';

class SelfieVerificationScreen extends HookConsumerWidget {
  const SelfieVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final controller = useState<CameraController?>(null);
    final isCameraInitialized = useState(false);
    final isLoading = useState(false);

    useEffect(() {
      return () {
        controller.value?.dispose();
      };
    }, []);

    Future<void> initializeCamera() async {
      final cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        // Show permission denied dialog or snackbar
        return;
      }

      try {
        isLoading.value = true;
        final cameras = await availableCameras();
        final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => cameras.first,
        );

        final cameraController = CameraController(
          frontCamera,
          ResolutionPreset.high,
          enableAudio: false,
        );

        await cameraController.initialize();
        if (!context.mounted) return;

        controller.value = cameraController;
        isCameraInitialized.value = true;
      } catch (e) {
        debugPrint('Error initializing camera: $e');
        // Handle error (show snackbar etc)
      } finally {
        isLoading.value = false;
      }
    }

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
                'Selfie Verification',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              const Gap(8),
              Text(
                'Take a selfie to verify your identity',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const Gap(24),

              // Camera Area
              Container(
                height: 400,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.dividerColor,
                    width: 0.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: isCameraInitialized.value && controller.value != null
                      ? CameraPreview(controller.value!)
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              HugeIcons.strokeRoundedCamera02,
                              size: 40,
                              color: theme.iconTheme.color,
                            ),
                            const Gap(16),
                            Text(
                              'Take a clear selfie for verification',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Gap(24),
                            FullButton(
                              text: 'Start Camera',
                              width: 150,
                              height: 45,
                              onPressed: () {
                                isLoading.value ? null : initializeCamera;
                              },
                              textColor: Colors.black,
                            ),
                          ],
                        ),
                ),
              ),

              const Gap(24),

              // Instruction Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Position your face in the frame and ensure good lighting. Remove any glasses or hats if possible.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    height: 1.4,
                    color: theme.brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.9)
                        : const Color(0xFF333333),
                  ),
                ),
              ),

              const Gap(40),

              // Verify Button
              FullButton(
                text: "Verify",
                width: double.infinity,
                height: 50,
                onPressed: () {
                  // Handle verification logic (e.g. capture image)
                },
                textColor: Colors.white,
                color: AppColors.primaryColor,
              ),

              const Gap(24),

              // Footer Security Note
              VerifyEncryptWidget(theme: theme), const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}
