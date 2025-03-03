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
    final imageFile = useState<File?>(null);
    final picker = ImagePicker();

    Future<void> pickImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imageFile.value = File(pickedFile.path);
      }
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
              onTap: pickImage,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.brightness == Brightness.dark
                          ? AppColors.secondaryColor.shade400
                          : AppColors.greyColor.shade200,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent),
                child: imageFile.value == null
                    ? SizedBox(
                        height: 120,
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
                            Text(
                              "Upload Screenshot or Proof of Payment",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: theme.brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Stack(
                        alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(imageFile.value!,
                                height: 150, fit: BoxFit.cover),
                          ),
                          GestureDetector(
                            onTap: () => imageFile.value = null,
                            child: const CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.red,
                              child: Icon(Icons.close,
                                  color: Colors.white, size: 16),
                            ),
                          ),
                        ],
                      ),
              )),
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
                    context.router.pushAndPopUntil(
                      StandAloneTransactionDetailsRoute(
                          type: 'Crypto Sale', status: 'Pending'),
                      predicate: (route) =>
                          route.settings.name == QrCryptoRoute.name,
                    );
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
