import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:mdiho/common/res/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraCaptureScreen extends HookWidget {
  const CameraCaptureScreen({
    super.key,
    required this.onImageCaptured,
  });

  final Function(String imagePath) onImageCaptured;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = useState<CameraController?>(null);
    final isCameraInitialized = useState(false);
    final isLoading = useState(false);
    final isCapturing = useState(false);
    final flashMode = useState<FlashMode>(FlashMode.off);
    final currentCameraIndex = useState<int>(0);
    final camerasList = useState<List<CameraDescription>>([]);

    Future<void> initializeCamera() async {
      if (!context.mounted) return;

      try {
        isLoading.value = true;

        // Check current camera permission status
        final cameraStatus = await Permission.camera.status;

        // If not granted, request permission
        if (!cameraStatus.isGranted) {
          final requestResult = await Permission.camera.request();
          if (!requestResult.isGranted) {
            if (context.mounted) {
              // Show error message if permission is denied
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                      'Camera permission is required to take photos'),
                  action: requestResult.isPermanentlyDenied
                      ? SnackBarAction(
                          label: 'Open Settings',
                          onPressed: () => openAppSettings(),
                        )
                      : null,
                ),
              );
              Navigator.pop(context);
            }
            return;
          }
        }

        // Get available cameras
        final cameras = await availableCameras();
        if (cameras.isEmpty) {
          if (context.mounted) {
            Navigator.pop(context);
          }
          return;
        }

        camerasList.value = cameras;

        // Find front camera or use first available
        final frontCameraIndex = cameras.indexWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
        );
        final initialCameraIndex = frontCameraIndex >= 0 ? frontCameraIndex : 0;
        currentCameraIndex.value = initialCameraIndex;

        // Initialize camera controller
        final cameraController = CameraController(
          cameras[initialCameraIndex],
          ResolutionPreset.high,
          enableAudio: false,
        );

        await cameraController.initialize();

        if (!context.mounted) {
          await cameraController.dispose();
          return;
        }

        controller.value = cameraController;
        isCameraInitialized.value = true;
      } catch (e) {
        debugPrint('Error initializing camera: $e');
        if (context.mounted) {
          Navigator.pop(context);
        }
      } finally {
        isLoading.value = false;
      }
    }

    Future<void> toggleFlash() async {
      if (controller.value == null || !controller.value!.value.isInitialized) {
        return;
      }

      try {
        final newFlashMode = flashMode.value == FlashMode.off
            ? FlashMode.auto
            : flashMode.value == FlashMode.auto
                ? FlashMode.always
                : FlashMode.off;

        await controller.value!.setFlashMode(newFlashMode);
        flashMode.value = newFlashMode;
      } catch (e) {
        debugPrint('Error toggling flash: $e');
      }
    }

    Future<void> flipCamera() async {
      if (camerasList.value.length < 2) return;
      if (controller.value == null || !controller.value!.value.isInitialized) {
        return;
      }

      try {
        final currentIndex = currentCameraIndex.value;
        final newIndex = (currentIndex + 1) % camerasList.value.length;

        await controller.value!.dispose();

        final newCameraController = CameraController(
          camerasList.value[newIndex],
          ResolutionPreset.high,
          enableAudio: false,
        );

        await newCameraController.initialize();

        if (!context.mounted) {
          await newCameraController.dispose();
          return;
        }

        // Restore flash mode
        await newCameraController.setFlashMode(flashMode.value);

        controller.value = newCameraController;
        currentCameraIndex.value = newIndex;
      } catch (e) {
        debugPrint('Error flipping camera: $e');
      }
    }

    Future<void> captureImage() async {
      if (controller.value == null || !controller.value!.value.isInitialized) {
        return;
      }

      try {
        isCapturing.value = true;
        final image = await controller.value!.takePicture();
        isCapturing.value = false;

        if (context.mounted) {
          onImageCaptured(image.path);
          Navigator.pop(context);
        }
      } catch (e) {
        debugPrint('Error capturing image: $e');
        isCapturing.value = false;
      }
    }

    useEffect(() {
      initializeCamera();
      return () {
        controller.value?.dispose();
      };
    }, []);

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.dark
          ? const Color(0xFF1A1A1A)
          : Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera Preview
            if (isCameraInitialized.value && controller.value != null)
              Positioned.fill(
                child: CameraPreview(controller.value!),
              )
            else
              Positioned.fill(
                child: Container(
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            // Dotted border on left and right
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: CustomPaint(
                size: const Size(2, double.infinity),
                painter: DottedLinePainter(
                  color: AppColors.primaryColor.withOpacity(0.5),
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: CustomPaint(
                size: const Size(2, double.infinity),
                painter: DottedLinePainter(
                  color: AppColors.primaryColor.withOpacity(0.5),
                ),
              ),
            ),

            // Face positioning oval guide
            if (isCameraInitialized.value)
              Center(
                child: CustomPaint(
                  painter: OvalGuidePainter(),
                  child: const SizedBox(
                    width: 280,
                    height: 360,
                  ),
                ),
              ),

            // Instructions
            if (isCameraInitialized.value)
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    const Text(
                      'Take a photo of yourself',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Position your face in the oval, make sure your entire face is visible.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Bottom control bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? const Color(0xFF1E3A5F)
                      : const Color(0xFF1E3A5F),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Flash toggle button
                    GestureDetector(
                      onTap: toggleFlash,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.brightness == Brightness.dark
                              ? Colors.blue.withOpacity(0.3)
                              : Colors.blue.withOpacity(0.2),
                        ),
                        child: Icon(
                          flashMode.value == FlashMode.off
                              ? Icons.flash_off
                              : flashMode.value == FlashMode.auto
                                  ? Icons.flash_auto
                                  : Icons.flash_on,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),

                    // Capture button
                    GestureDetector(
                      onTap: isCapturing.value ? null : captureImage,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                        ),
                        child: isCapturing.value
                            ? const Center(
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              )
                            : Container(
                                margin: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                    // Camera flip button
                    GestureDetector(
                      onTap: camerasList.value.length > 1 ? flipCamera : null,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: camerasList.value.length > 1
                              ? (theme.brightness == Brightness.dark
                                  ? Colors.blue.withOpacity(0.3)
                                  : Colors.blue.withOpacity(0.2))
                              : Colors.grey.withOpacity(0.3),
                        ),
                        child: Icon(
                          Icons.flip_camera_ios,
                          color: camerasList.value.length > 1
                              ? Colors.white
                              : Colors.grey,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for the oval guide
class OvalGuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for dotted line
class DottedLinePainter extends CustomPainter {
  final Color color;

  DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0;

    const dashHeight = 5.0;
    const dashSpace = 3.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
