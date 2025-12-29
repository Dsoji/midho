import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:image/image.dart' as img;
import 'package:mdiho/common/res/app_colors.dart';
import 'package:path_provider/path_provider.dart';
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
    final isDisposed = useRef(false);

    Future<void> initializeCamera() async {
      if (!context.mounted || isDisposed.value) return;

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

        if (isDisposed.value || !context.mounted) {
          await cameraController.dispose();
          return;
        }

        // Double check before setting controller
        if (!isDisposed.value) {
          controller.value = cameraController;
          isCameraInitialized.value = true;
        } else {
          await cameraController.dispose();
        }
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
      if (isDisposed.value ||
          controller.value == null ||
          !controller.value!.value.isInitialized) {
        return;
      }

      try {
        final newFlashMode = flashMode.value == FlashMode.off
            ? FlashMode.auto
            : flashMode.value == FlashMode.auto
                ? FlashMode.always
                : FlashMode.off;

        final cameraController = controller.value;
        if (cameraController != null && !isDisposed.value) {
          await cameraController.setFlashMode(newFlashMode);
          if (!isDisposed.value) {
            flashMode.value = newFlashMode;
          }
        }
      } catch (e) {
        debugPrint('Error toggling flash: $e');
      }
    }

    Future<void> flipCamera() async {
      if (isDisposed.value || camerasList.value.length < 2) return;
      if (controller.value == null || !controller.value!.value.isInitialized) {
        return;
      }

      try {
        final currentIndex = currentCameraIndex.value;
        final newIndex = (currentIndex + 1) % camerasList.value.length;

        final oldController = controller.value;
        if (oldController != null) {
          await oldController.dispose();
        }

        if (isDisposed.value || !context.mounted) {
          return;
        }

        final newCameraController = CameraController(
          camerasList.value[newIndex],
          ResolutionPreset.high,
          enableAudio: false,
        );

        await newCameraController.initialize();

        if (isDisposed.value || !context.mounted) {
          await newCameraController.dispose();
          return;
        }

        // Restore flash mode
        await newCameraController.setFlashMode(flashMode.value);

        if (!isDisposed.value) {
          controller.value = newCameraController;
          currentCameraIndex.value = newIndex;
        } else {
          await newCameraController.dispose();
        }
      } catch (e) {
        debugPrint('Error flipping camera: $e');
      }
    }

    // Process image with blur - optimized to prevent crashes
    Future<img.Image> _processImageWithBlur(
      img.Image decodedImage,
      double ovalCenterX,
      double ovalCenterY,
      double ovalRadiusX,
      double ovalRadiusY,
      BuildContext context,
    ) async {
      final imageWidth = decodedImage.width;
      final imageHeight = decodedImage.height;

      // Apply blur to the entire image (with reduced radius for performance)
      final blurred = img.gaussianBlur(decodedImage, radius: 12);

      // Create result image by blending blurred and sharp images
      final resultImage = img.Image(width: imageWidth, height: imageHeight);

      // Feather distance for smooth transition (in pixels)
      const featherDistance = 20.0;

      // Process in chunks to allow periodic context checks
      const chunkSize = 50; // Process 50 rows at a time

      for (int startY = 0; startY < imageHeight; startY += chunkSize) {
        // Check if context is still mounted periodically
        if (startY % (chunkSize * 4) == 0 && !context.mounted) {
          throw Exception('Context no longer mounted');
        }

        final endY = math.min(startY + chunkSize, imageHeight);

        for (int y = startY; y < endY; y++) {
          for (int x = 0; x < imageWidth; x++) {
            // Check if point is inside ellipse
            final dx = (x - ovalCenterX) / ovalRadiusX;
            final dy = (y - ovalCenterY) / ovalRadiusY;
            final distance = dx * dx + dy * dy;

            final originalPixel = decodedImage.getPixel(x, y);
            final blurredPixel = blurred.getPixel(x, y);

            if (distance <= 1.0) {
              // Inside oval - use original sharp image
              resultImage.setPixel(x, y, originalPixel);
            } else {
              // Outside oval - calculate distance from oval edge for smooth transition
              final edgeDistance = (math.sqrt(distance) - 1.0) *
                  math.min(ovalRadiusX, ovalRadiusY);

              if (edgeDistance < featherDistance) {
                // In feather zone - blend between sharp and blurred
                final blendFactor =
                    (edgeDistance / featherDistance).clamp(0.0, 1.0);
                final r = (originalPixel.r * (1 - blendFactor) +
                        blurredPixel.r * blendFactor)
                    .round()
                    .clamp(0, 255);
                final g = (originalPixel.g * (1 - blendFactor) +
                        blurredPixel.g * blendFactor)
                    .round()
                    .clamp(0, 255);
                final b = (originalPixel.b * (1 - blendFactor) +
                        blurredPixel.b * blendFactor)
                    .round()
                    .clamp(0, 255);
                final a = originalPixel.a;
                resultImage.setPixel(x, y,
                    img.ColorRgba8(r.toInt(), g.toInt(), b.toInt(), a.toInt()));
              } else {
                // Far outside oval - use fully blurred image
                resultImage.setPixel(x, y, blurredPixel);
              }
            }
          }
        }
      }

      return resultImage;
    }

    Future<void> captureImage() async {
      // Check if widget is disposed or controller is invalid
      if (isDisposed.value ||
          controller.value == null ||
          !controller.value!.value.isInitialized) {
        return;
      }

      // Store controller reference to avoid accessing disposed controller
      final cameraController = controller.value;
      if (cameraController == null) return;

      try {
        isCapturing.value = true;

        // Check again before taking picture
        if (isDisposed.value || !cameraController.value.isInitialized) {
          isCapturing.value = false;
          return;
        }

        final image = await cameraController.takePicture();

        // Check if disposed after async operation
        if (isDisposed.value || !context.mounted) {
          isCapturing.value = false;
          return;
        }

        // Get screen dimensions (excluding SafeArea)
        if (!context.mounted) {
          isCapturing.value = false;
          return;
        }

        final screenSize = MediaQuery.of(context).size;
        final safeAreaTop = MediaQuery.of(context).padding.top;
        final safeAreaBottom = MediaQuery.of(context).padding.bottom;
        final availableHeight =
            screenSize.height - safeAreaTop - safeAreaBottom;

        // Oval dimensions (from the guide) - this represents the visible preview area
        const ovalWidth = 280.0;
        const ovalHeight = 360.0;

        // Calculate oval position (centered on available screen area)
        final ovalLeft = (screenSize.width - ovalWidth) / 2;
        final ovalTop = (availableHeight - ovalHeight) / 2 + safeAreaTop;

        // Load the captured image
        final imageBytes = await File(image.path).readAsBytes();
        var decodedImage = img.decodeImage(imageBytes);

        if (decodedImage == null) {
          throw Exception('Failed to decode image');
        }

        // Limit image size to prevent memory issues (max 2000px on longest side)
        const maxDimension = 2000;
        if (decodedImage.width > maxDimension ||
            decodedImage.height > maxDimension) {
          final scale =
              maxDimension / math.max(decodedImage.width, decodedImage.height);
          decodedImage = img.copyResize(
            decodedImage,
            width: (decodedImage.width * scale).round(),
            height: (decodedImage.height * scale).round(),
          );
        }

        // Get camera preview size and actual image size
        // Use stored reference instead of accessing controller.value
        if (isDisposed.value || !cameraController.value.isInitialized) {
          isCapturing.value = false;
          return;
        }
        final previewSize = cameraController.value.previewSize;
        final imageWidth = decodedImage.width;
        final imageHeight = decodedImage.height;

        // Validate image dimensions
        if (imageWidth <= 0 || imageHeight <= 0) {
          throw Exception('Invalid image dimensions');
        }

        // Calculate how the preview is displayed on screen
        // The preview fills the screen, so we need to account for aspect ratio
        final previewAspectRatio = previewSize != null
            ? previewSize.height / previewSize.width
            : imageHeight / imageWidth;
        final screenAspectRatio = availableHeight / screenSize.width;

        // Determine if preview is letterboxed or pillarboxed
        double displayWidth, displayHeight, offsetX, offsetY;

        if (previewAspectRatio > screenAspectRatio) {
          // Preview is taller - letterboxed (black bars on top/bottom)
          displayWidth = screenSize.width;
          displayHeight = screenSize.width * previewAspectRatio;
          offsetX = 0;
          offsetY = (availableHeight - displayHeight) / 2;
        } else {
          // Preview is wider - pillarboxed (black bars on left/right)
          displayHeight = availableHeight;
          displayWidth = availableHeight / previewAspectRatio;
          offsetX = (screenSize.width - displayWidth) / 2;
          offsetY = 0;
        }

        // Map oval coordinates from screen space to image space (for blur effect)
        final ovalRelativeX = (ovalLeft - offsetX) / displayWidth;
        final ovalRelativeY = (ovalTop - offsetY - safeAreaTop) / displayHeight;
        final ovalRelativeWidth = ovalWidth / displayWidth;
        final ovalRelativeHeight = ovalHeight / displayHeight;

        // Calculate oval region in image coordinates (for blur effect)
        final ovalX = (ovalRelativeX * imageWidth).round();
        final ovalY = (ovalRelativeY * imageHeight).round();
        final ovalImgWidth = (ovalRelativeWidth * imageWidth).round();
        final ovalImgHeight = (ovalRelativeHeight * imageHeight).round();

        // Calculate oval center and radii in image coordinates (for blur effect)
        final ovalCenterX = ovalX + ovalImgWidth / 2;
        final ovalCenterY = ovalY + ovalImgHeight / 2;
        final ovalRadiusX = ovalImgWidth / 2;
        final ovalRadiusY = ovalImgHeight / 2;

        // Validate radii to prevent division by zero
        if (ovalRadiusX <= 0 || ovalRadiusY <= 0) {
          throw Exception('Invalid oval dimensions');
        }

        // Check again before heavy processing
        if (isDisposed.value || !context.mounted) {
          isCapturing.value = false;
          return;
        }

        // Process image with blur (chunked processing to prevent UI blocking)
        final processedImage = await _processImageWithBlur(
          decodedImage,
          ovalCenterX,
          ovalCenterY,
          ovalRadiusX,
          ovalRadiusY,
          context,
        );

        // Final check before saving
        if (isDisposed.value || !context.mounted) {
          isCapturing.value = false;
          return;
        }

        // Use the full processed image (no cropping) - oval represents the visible preview
        // Save the full image with blurred background outside oval
        final directory = await getTemporaryDirectory();
        final croppedImagePath =
            '${directory.path}/cropped_selfie_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final croppedImageFile = File(croppedImagePath);
        await croppedImageFile
            .writeAsBytes(img.encodeJpg(processedImage, quality: 90));

        // Delete the original full image
        try {
          await File(image.path).delete();
        } catch (e) {
          debugPrint('Error deleting original image: $e');
        }

        isCapturing.value = false;

        if (context.mounted) {
          onImageCaptured(croppedImagePath);
          Navigator.pop(context);
        }
      } catch (e) {
        debugPrint('Error capturing image: $e');
        if (!isDisposed.value) {
          isCapturing.value = false;
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error capturing image: $e'),
              ),
            );
          }
        }
      }
    }

    useEffect(() {
      initializeCamera();
      return () {
        // Mark as disposed first to prevent any new operations
        isDisposed.value = true;

        // Dispose camera controller safely
        final cameraController = controller.value;
        if (cameraController != null) {
          try {
            // Check if already disposed
            if (cameraController.value.isInitialized) {
              cameraController.dispose().catchError((e) {
                debugPrint('Error disposing camera controller: $e');
              });
            }
          } catch (e) {
            debugPrint('Error disposing camera controller: $e');
          }
          controller.value = null;
        }
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
                bottom: 120,
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
                decoration: const BoxDecoration(
                  color: Colors.transparent,
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
