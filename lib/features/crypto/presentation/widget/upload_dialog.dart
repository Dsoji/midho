import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mdiho/common/widgets/custom_buttons.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';

import '../../../../common/res/app_colors.dart';
import '../../../../common/toast/toast.dart';
import '../../../../common/utils/checksum_helper.dart';
import '../../../authentication/data/controller/authentication_controller.dart';
import '../../../gift_card/data/model/response/gift_cart_transaction/gift_cart_transaction.dart';
import '../../../suggestion_box/data/response/upload_response/upload_response.dart';
import '../../../transaction/data/controller/transaction_controller.dart';
import '../../../transaction/data/model/response/rates_model/datum.dart';

final imageUploadStateProvider =
    StateNotifierProvider<ImageUploadNotifier, List<File>>((ref) {
  return ImageUploadNotifier();
});

class ImageUploadNotifier extends StateNotifier<List<File>> {
  ImageUploadNotifier() : super([]);

  void addImages(List<File> newImages) {
    state = [...state, ...newImages].take(3).toList();
  }

  void removeImage(int index) {
    state = List.from(state)..removeAt(index);
  }

  void clearImages() {
    state = [];
  }
}

void showCryptoDialog({
  required BuildContext context,
  required WidgetRef ref,
  required VoidCallback onSecondaryAction,
  required VoidCallback onDone,
  required double amount,
  required RateData crypto,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return _CryptoDialogContent(
        ref: ref,
        onSecondaryAction: onSecondaryAction,
        onDone: onDone,
        amount: amount,
        crypto: crypto,
      );
    },
  );
}

class _CryptoDialogContent extends HookConsumerWidget {
  final WidgetRef ref;
  final VoidCallback onSecondaryAction;
  final VoidCallback onDone;
  final double amount;
  final RateData crypto;

  const _CryptoDialogContent({
    required this.ref,
    required this.onSecondaryAction,
    required this.onDone,
    required this.amount,
    required this.crypto,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final transactionService = ref.read(transactionControllerProvider.notifier);
    final isLoading =
        ref.watch(authenticationControllerProvider).imageUpload.isLoading;

    // Generate a fixed time window for the duration of this dialog's lifecycle
    final timeWindow =
        useMemoized(() => ChecksumHelper.get10SecondTimeWindow());

    return Dialog(
      backgroundColor: theme.brightness == Brightness.dark
          ? AppColors.darkBorder
          : AppColors.whiteColor.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade700
                    : AppColors.whiteColor.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                          endIndent: 8,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.brightness == Brightness.dark
                              ? AppColors.darkBorder
                              : AppColors.whiteColor.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "Step 2",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                          endIndent: 0,
                          indent: 8,
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  Text(
                    "Once you've sent the ${crypto.symbol}, upload your proof of payment below:",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ImageUploadWidget(
              isLoading: isLoading,
              onImagesUploaded: (paths) async {
                // Generate checksum right before API call with current time window
                final checksum = ChecksumHelper.generateCryptoChecksum(
                  id: crypto.id,
                  name: crypto.name,
                  amount: amount,
                  comment: 'Just a comment',
                  files: paths,
                  timeWindow: timeWindow,
                );

                final result = await transactionService.sellCrypto(
                  id: crypto.id ?? '',
                  name: crypto.name ?? '',
                  amount: amount,
                  files: paths,
                  comment: 'Just a comment',
                  checksum: checksum,
                );
                if (result == true) {
                  final transaction =
                      ref.watch(transactionControllerProvider).sellCrypto;
                  showTransactionDialog(
                    context,
                    onSecondaryAction,
                    onDone,
                    transaction.valueOrNull,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

List<String> getPathsFromUploadResponse(UploadResponse? uploadResponse) {
  return uploadResponse?.files?.map((file) => file.path ?? '').toList() ?? [];
}

void showTransactionDialog(
  BuildContext context,
  VoidCallback onTap,
  VoidCallback onDone,
  GiftCartTransaction? transaction,
) {
  Navigator.pop(context);
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissing by tapping outside
    builder: (BuildContext context) {
      final theme = Theme.of(context);
      return Dialog(
        backgroundColor: theme.brightness == Brightness.dark
            ? AppColors.secondaryColor.shade500
            : AppColors.whiteColor.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Your transaction is now pending",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "The admin team will review your transaction.\n"
                "Once approved, you will receive a notification,\n"
                "and your wallet will be credited promptly.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Transaction ID: ${transaction?.id != null && transaction!.id!.length > 12 ? '${transaction.id?.substring(0, 12)}...' : transaction?.id ?? ''}",
                style: TextStyle(
                  color: theme.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor, // Orange button
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  onDone();

                  Navigator.pop(context);
                },
                child: const Text(
                  "View Details",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  onTap();
                  Navigator.pop(context);
                },
                child: Text(
                  "Sell More Crypto",
                  style: TextStyle(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class ImageUploadWidget extends HookConsumerWidget {
  final Function(List<String> paths) onImagesUploaded;
  final bool isLoading;

  const ImageUploadWidget({
    super.key,
    required this.onImagesUploaded,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final imageFiles = ref.watch(imageUploadStateProvider);
    final picker = ImagePicker();

    useEffect(() {
      return () {
        // Clear images when widget is disposed
        ref.read(imageUploadStateProvider.notifier).clearImages();
      };
    }, []);

    Future<void> pickImage() async {
      if (imageFiles.length >= 3) return;

      final pickedFiles = await picker.pickMultiImage();
      final newImages = pickedFiles
          .map((file) => File(file.path))
          .where((file) => !imageFiles.contains(file))
          .toList();

      ref.read(imageUploadStateProvider.notifier).addImages(newImages);
    }

    void removeImage(int index) {
      ref.read(imageUploadStateProvider.notifier).removeImage(index);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoWidget(
          theme: theme,
          text:
              "Upload a clear screenshot showing the transaction details as proof.",
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: imageFiles.length < 3 ? pickImage : null,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade400
                    : AppColors.greyColor.shade200,
              ),
              borderRadius: BorderRadius.circular(10),
              color: theme.brightness == Brightness.dark
                  ? AppColors.darkBorder
                  : AppColors.greyColor.shade50,
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (imageFiles.isEmpty) ...[
                  SizedBox(
                    height: 98,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          IconsaxPlusLinear.image,
                          size: 24,
                          color: theme.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        const SizedBox(height: 8),
                        Flexible(
                          child: Text(
                            "Upload Screenshot or Proof \nof Payment",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: theme.brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ] else ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      imageFiles.length,
                      (index) => Stack(
                        alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              imageFiles[index],
                              height: 150,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => removeImage(index),
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: AppColors.primaryColor,
                              child: Icon(Icons.close,
                                  color: Colors.white, size: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (imageFiles.length < 3) ...[
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        height: 150,
                        width: 100,
                        margin: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 8),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: theme.brightness == Brightness.dark
                                ? Colors.white
                                : AppColors.greyColor.shade100,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent,
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(IconsaxPlusLinear.add_circle, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ]
                ]
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        FullButton(
          isLoading: isLoading,
          text: 'Submit Proof',
          width: double.infinity,
          height: 48,
          onPressed: () async {
            if (imageFiles.isNotEmpty) {
              final result = await ref
                  .read(authenticationControllerProvider.notifier)
                  .uploadMultipleFiles(imageFiles);

              if (result == true) {
                final uploadedFiles = ref
                    .read(authenticationControllerProvider)
                    .imageUpload
                    .valueOrNull;
                List<String> paths = getPathsFromUploadResponse(uploadedFiles);
                onImagesUploaded(paths);
                ref.read(imageUploadStateProvider.notifier).clearImages();
              }
            } else {
              ToastService().showToast(
                NotificationType.info,
                message: 'You need to upload proof of transaction',
              );
            }
          },
          textColor: Colors.white,
          color: AppColors.primaryColor.shade500,
        ),
        const SizedBox(height: 10),
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Go Back",
              style: TextStyle(
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
