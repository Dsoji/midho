import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../common/widgets/custom_buttons.dart';
import '../../../common/widgets/custom_textfield.dart';
import '../../withdrawal/presentation/widget/info_widget.dart';

@RoutePage()
class CardDetailsProofScreen extends HookConsumerWidget {
  const CardDetailsProofScreen({
    super.key,
    required this.img,
  });
  final String img;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pinController = useTextEditingController();
    final codeController = useTextEditingController();

    final imageFiles = useState<List<File>>([]);
    final picker = ImagePicker();

    Future<void> pickImage() async {
      if (imageFiles.value.length >= 3) return; // Enforce max limit of 3

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

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Enter Gift Card Details",
        showBackButton: true,
        showTitle: true,
        showAction: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              decoration: ShapeDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade500
                    : AppColors.whiteColor.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(16),
                  const Text(
                    'Enter Card Details',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Gap(16),
                  CustomTextField(
                    controller: codeController,
                    label: "Code (optional)",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const Gap(16),
                  CustomTextField(
                    controller: pinController,
                    label: "Pin",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const Gap(16),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: AppColors.greyColor.shade100,
                          thickness: 0.5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.greyColor.shade100,
                                width: 0.5),
                          ),
                          child: Text(
                            "Upload Gift Card",
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: AppColors.greyColor.shade100,
                          thickness: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),
                  const Text(
                    'Upload clear images of the gift card and provide the necessary details. ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Gap(16),
                  InfoWidget(
                    theme: theme,
                    text:
                        'Enter a valid 10-digit account number linked to your bank.',
                  ),
                  const Gap(16),

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
                            if (imageFiles.value.length < 3) ...[
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
                  const Gap(20),
                  // Continue Button
                  FullButton(
                    text: "Next",
                    width: double.infinity,
                    height: 48,
                    onPressed: () {
                      showTradeSubmittedDialog(context, img);
                    },
                    textColor: Colors.white,
                    color: AppColors.primaryColor.shade500,
                  ),

                  const Gap(20),
                ],
              ),
            ),
            const Gap(150),
          ],
        ),
      ),
    );
  }

  void showTradeSubmittedDialog(BuildContext context, final String img) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);

        return Dialog(
          backgroundColor: theme.brightness == Brightness.dark
              ? AppColors.secondaryColor.shade500
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.black12,
                  backgroundImage: AssetImage(img),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  "Trade Submitted",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  "Your STEAM gift card trade for \$50 is now pending admin review.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black54),
                ),
                const SizedBox(height: 12),

                // Transaction ID
                const Text(
                  "Transaction ID: #TRX123456",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),

                // View Details Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.router.push(
                        StandAloneTransactionDetailsRoute(
                            type: 'Gift Card Purchase', status: 'Pending'),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("View Details",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 12),

                // Sell More Gift Cards (Text Button)
                TextButton(
                  onPressed: () {
                    context.router.replaceAll([const GiftCardRoute()]);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Sell More Gift Cards",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black),
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
