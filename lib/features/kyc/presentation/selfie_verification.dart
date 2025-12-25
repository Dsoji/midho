import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mdiho/common/res/app_colors.dart';
import 'package:mdiho/common/widgets/custom_app_bar.dart';
import 'package:mdiho/common/widgets/custom_buttons.dart';
import 'package:mdiho/features/kyc/data/model/kyc_payload.dart';
import 'package:mdiho/features/profile/data/controller/profile_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class SelfieVerificationScreen extends HookConsumerWidget {
  const SelfieVerificationScreen({
    super.key,
    this.bvn,
    this.nin,
  });

  /// Only one of [bvn] or [nin] should be provided.
  final String? bvn;
  final String? nin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final controller = useState<CameraController?>(null);
    final isCameraInitialized = useState(false);
    final isLoading = useState(false);
    final isVerifying = useState(false);
    final capturedImagePath = useState<String?>(null);
    final isCapturing = useState(false);

    final contextRef = useRef<BuildContext?>(null);
    contextRef.value = context;

    useEffect(() {
      return () {
        controller.value?.dispose();
      };
    }, []);

    Future<void> initializeCamera() async {
      final currentContext = contextRef.value;
      if (currentContext == null || !currentContext.mounted) {
        debugPrint('Context not available for camera initialization');
        return;
      }

      try {
        debugPrint('Starting camera initialization...');
        isLoading.value = true;

        // Request camera permission
        debugPrint('Requesting camera permission...');
        final cameraStatus = await Permission.camera.request();
        debugPrint('Camera permission status: $cameraStatus');

        if (!cameraStatus.isGranted) {
          if (cameraStatus.isPermanentlyDenied) {
            if (!currentContext.mounted) return;
            Fluttertoast.showToast(
              msg:
                  'Camera permission is permanently denied. Please enable it in settings.',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          } else {
            if (!currentContext.mounted) return;
            Fluttertoast.showToast(
              msg: 'Camera permission is required to take a selfie.',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          }
          return;
        }

        // Get available cameras
        debugPrint('Getting available cameras...');
        final cameras = await availableCameras();
        debugPrint('Found ${cameras.length} camera(s)');

        if (cameras.isEmpty) {
          if (!currentContext.mounted) return;
          Fluttertoast.showToast(
            msg: 'No cameras available on this device.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          return;
        }

        // Find front camera or use first available
        final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => cameras.first,
        );

        // Initialize camera controller
        debugPrint('Initializing camera controller...');
        final cameraController = CameraController(
          frontCamera,
          ResolutionPreset.high,
          enableAudio: false,
        );

        await cameraController.initialize();
        debugPrint('Camera initialized successfully');

        if (!currentContext.mounted) {
          await cameraController.dispose();
          return;
        }

        controller.value = cameraController;
        isCameraInitialized.value = true;
      } catch (e) {
        debugPrint('Error initializing camera: $e');
        final errorContext = contextRef.value;
        if (errorContext != null && errorContext.mounted) {
          Fluttertoast.showToast(
            msg: 'Failed to initialize camera: ${e.toString()}',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

    Future<void> captureImage() async {
      if (controller.value == null || !controller.value!.value.isInitialized) {
        return;
      }

      try {
        isCapturing.value = true;
        final image = await controller.value!.takePicture();
        capturedImagePath.value = image.path;
      } catch (e) {
        debugPrint('Error capturing image: $e');
        final errorContext = contextRef.value;
        if (errorContext != null && errorContext.mounted) {
          Fluttertoast.showToast(
            msg: 'Error capturing image: $e',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } finally {
        isCapturing.value = false;
      }
    }

    void retakePhoto() {
      capturedImagePath.value = null;
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
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            // Show captured image or live preview
                            capturedImagePath.value != null
                                ? Image.file(
                                    File(capturedImagePath.value!),
                                    fit: BoxFit.cover,
                                  )
                                : CameraPreview(controller.value!),
                            // Capture button overlay (only show if no image captured)
                            if (capturedImagePath.value == null)
                              Positioned(
                                bottom: 20,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: GestureDetector(
                                    onTap: captureImage,
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        border: Border.all(
                                          color: AppColors.primaryColor,
                                          width: 4,
                                        ),
                                      ),
                                      child: isCapturing.value
                                          ? const Center(
                                              child: SizedBox(
                                                width: 30,
                                                height: 30,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 3,
                                                  color: AppColors.primaryColor,
                                                ),
                                              ),
                                            )
                                          : const Icon(
                                              Icons.camera_alt,
                                              size: 35,
                                              color: AppColors.primaryColor,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            // Retake button (only show if image is captured)
                            if (capturedImagePath.value != null)
                              Positioned(
                                bottom: 20,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Retake button
                                    GestureDetector(
                                      onTap: retakePhoto,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.9),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.refresh,
                                              color: AppColors.primaryColor,
                                              size: 20,
                                            ),
                                            Gap(8),
                                            Text(
                                              'Retake',
                                              style: TextStyle(
                                                color: AppColors.primaryColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        )
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
                              isLoading: isLoading.value,
                              isDisabled: isLoading.value,
                              onPressed: () {
                                debugPrint('Start Camera button pressed');
                                if (!isLoading.value) {
                                  initializeCamera();
                                } else {
                                  debugPrint(
                                      'Camera is already loading, ignoring press');
                                }
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
                isLoading: ref
                    .watch(profileControllerProvider)
                    .kycVerification
                    .isLoading,
                onPressed: () async {
                  if (capturedImagePath.value == null) {
                    Fluttertoast.showToast(
                      msg: 'Please capture a selfie first.',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                    return;
                  }

                  try {
                    // Use captured image (commented out for testing with dummy data)
                    final bytes =
                        await File(capturedImagePath.value!).readAsBytes();
                    final selfieBase64 = base64Encode(bytes);

                    // Build payload with dummy data for testing
                    final payload = KycPayload(
                        bvn: bvn ?? '', // Dummy BVN for testing
                        nin: nin ?? '', // Dummy NIN for testing
                        selfie: selfieBase64
                        // Dummy base64 image for testing
                        );
                    print(payload);
                    debugPrint(
                        'KYC Verification: Starting request with payload keys: ${payload.keys}');

                    final controllerNotifier = ref.read(
                      profileControllerProvider.notifier,
                    );

                    debugPrint(
                        'KYC Verification: Calling kycVerification method');
                    final success =
                        await controllerNotifier.kycVerification(payload);
                    debugPrint(
                        'KYC Verification: Request completed with success: $success');

                    if (!context.mounted) return;

                    if (success) {
                      Navigator.of(context).popUntil(
                        (route) => route.isFirst,
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg: 'Failed to submit KYC. Please try again.',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }
                  } catch (e) {
                    print(e);
                    if (!context.mounted) return;
                    Fluttertoast.showToast(
                      msg: 'Error capturing selfie: $e',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  } finally {
                    isVerifying.value = false;
                  }
                },
                textColor: Colors.white,
                color: AppColors.primaryColor,
              ),

              const Gap(24),

              // Footer Security Note
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}
