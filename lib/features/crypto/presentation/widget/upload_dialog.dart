import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mdiho/common/widgets/custom_buttons.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';

import '../../../../common/res/app_colors.dart';
import '../../../bottomNav/app_router.gr.dart';

class UploadProofDialog extends HookWidget {
  const UploadProofDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final imageFiles = useState<List<File>>([]);
    final picker = ImagePicker();

    Future<void> pickImage() async {
      if (imageFiles.value.length >= 2) return; // Enforce max limit of 3

      final pickedFiles = await picker.pickMultiImage();
      final newImages = pickedFiles
          .map((file) => File(file.path))
          .where((file) => !imageFiles.value.contains(file))
          .toList();

      imageFiles.value = [...imageFiles.value, ...newImages].take(3).toList();
    }

    void removeImage(int index) {
      final updatedList = [...imageFiles.value];
      updatedList.removeAt(index);
      imageFiles.value = updatedList;
    }

    final theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: theme.brightness == Brightness.dark
          ? AppColors.secondaryColor.shade500
          : AppColors.whiteColor.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Step 2",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
            onTap: imageFiles.value.length < 3 ? pickImage : null,
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
                  if (imageFiles.value.isEmpty) ...[
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
                        imageFiles.value.length,
                        (index) => Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                imageFiles.value[index],
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
                    if (imageFiles.value.length < 2) ...[
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
            text: 'Submit Proof',
            width: double.infinity,
            height: 48,
            onPressed: () => showTransactionDialog(context),
            textColor: Colors.white,
            color: AppColors.primaryColor.shade500,
          ),
        ],
      ),
    );
  }

  void showTransactionDialog(BuildContext context) {
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
                    context.router.replaceAll([
                      const CryptoRoute(),
                    ]);
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
}
