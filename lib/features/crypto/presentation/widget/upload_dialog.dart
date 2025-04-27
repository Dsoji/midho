import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mdiho/common/widgets/custom_buttons.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';

import '../../../../common/res/app_colors.dart';
import '../../../bottomNav/app_router.gr.dart';

void showCryptoDialog({
  required BuildContext context,
  required VoidCallback onSecondaryAction,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          List<File> imageFiles = [];
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

          return Dialog(
            backgroundColor: theme.brightness == Brightness.dark
                ? AppColors.darkBorder
                : AppColors.whiteColor.shade100,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                          : AppColors.whiteColor
                              .shade100, // or adjust for dark mode if needed
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
                                indent: 8,
                              ),
                            ),
                          ],
                        ),
                        const Gap(8),
                        const Text(
                          "Once you’ve sent the BTC, upload your proof of payment below:",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
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
                    text: 'Submit Proof',
                    width: double.infinity,
                    height: 48,
                    onPressed: () {},
                    //  => showTransactionDialog(
                    //   context,
                    //   onSecondaryAction,
                    // ),
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

void showTransactionDialog(
  BuildContext context,
  VoidCallback onTap,
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
                "Transaction ID: #TRX123456",
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
                  context.router.replaceAll([
                    StandAloneTransactionDetailsRoute(
                        type: 'Crypto Sale', status: 'Pending'),
                  ]);

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
