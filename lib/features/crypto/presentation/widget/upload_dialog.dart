import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mdiho/common/widgets/custom_buttons.dart';
import 'package:mdiho/features/transaction/data/model/response/transaction_history/datum.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';

import '../../../../common/res/app_colors.dart';
import '../../../../common/toast/toast.dart';
import '../../../authentication/data/controller/authentication_controller.dart';
import '../../../suggestion_box/data/response/upload_response/upload_response.dart';
import '../../../transaction/data/controller/transaction_controller.dart';
import '../../../transaction/data/model/response/rates_model/datum.dart';

void showCryptoDialog({
  required BuildContext context,
  required WidgetRef ref,
  required VoidCallback onSecondaryAction,
  required VoidCallback onDone,
  required int amount,
  required RateData crypto,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      List<File> imageFiles = [];
      return StatefulBuilder(
        builder: (context, setState) {
          final picker = ImagePicker();

          Future<void> pickImage() async {
            if (imageFiles.length >= 3) return;

            final pickedFiles = await picker.pickMultiImage();
            final newImages = pickedFiles
                .map((file) => File(file.path))
                .where((file) => !imageFiles.contains(file))
                .toList();

            setState(() {
              imageFiles = [...imageFiles, ...newImages].take(3).toList();
            });
          }

          void removeImage(int index) {
            setState(() {
              imageFiles.removeAt(index);
            });
          }

          final theme = Theme.of(context);
          final transactionService =
              ref.read(transactionControllerProvider.notifier);

          return Dialog(
            backgroundColor: theme.brightness == Brightness.dark
                ? AppColors.secondaryColor.shade500
                : AppColors.whiteColor.shade100,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Step 2",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text(
                    "Once you’ve sent the BTC, upload your proof of payment below:",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
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
                            ? Colors.transparent
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
                                        color:
                                            theme.brightness == Brightness.dark
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
                                        backgroundColor: Colors.red,
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
                                      Icon(IconsaxPlusLinear.add_circle,
                                          size: 20),
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
                    isLoading: ref
                        .watch(authenticationControllerProvider)
                        .imageUpload
                        .isLoading,
                    text: 'Submit Proof',
                    width: double.infinity,
                    height: 48,
                    onPressed: () async {
                      if (imageFiles.isNotEmpty) {
                        final result = await ref
                            .read(authenticationControllerProvider.notifier)
                            .uploadMultipleFiles(
                              imageFiles,
                            );
                        if (result == true) {
                          final uploadedFiles = ref
                              .read(authenticationControllerProvider)
                              .imageUpload
                              .valueOrNull;
                          List<String> paths =
                              getPathsFromUploadResponse(uploadedFiles);
                          final result = await transactionService.sellCrypto(
                            id: crypto.id ?? '',
                            name: crypto.name ?? '',
                            amount: amount,
                            files: paths,
                            comment: 'Just a comment',
                          );
                          if (result == true) {
                            final transaction = ref
                                .watch(transactionControllerProvider)
                                .sellCrypto;
                            showTransactionDialog(
                              context,
                              onSecondaryAction,
                              onDone,
                              transaction.valueOrNull,
                            );
                          }
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
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

List<String> getPathsFromUploadResponse(UploadResponse? uploadResponse) {
  return uploadResponse?.files?.map((file) => file.path ?? '').toList() ?? [];
}

void showTransactionDialog(
  BuildContext context,
  VoidCallback onTap,
  VoidCallback onDone,
  TransactionData? transaction,
) {
  Navigator.pop(context);
  showDialog(
    context: context,
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
                  backgroundColor: const Color(0xFFE95A3B), // Orange button
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
