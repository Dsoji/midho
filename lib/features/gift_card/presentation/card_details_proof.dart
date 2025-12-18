import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';
import 'package:mdiho/features/gift_card/presentation/widget/standAlone.dart';
import 'package:mdiho/features/transaction/data/controller/transaction_controller.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/toast/toast.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../common/widgets/custom_buttons.dart';
import '../../../common/widgets/custom_textfield.dart';
import '../../authentication/data/controller/authentication_controller.dart';
import '../../suggestion_box/data/response/upload_response/upload_response.dart';
import '../../withdrawal/presentation/widget/info_widget.dart';
import '../data/model/response/gift_card_model/datum.dart';

final logger = Logger();

@RoutePage()
class CardDetailsProofScreen extends HookConsumerWidget {
  const CardDetailsProofScreen({
    super.key,
    required this.giftCard,
    required this.amount,
    required this.rates,
    required this.isCode,
    required this.currency,
  });
  final GiftCardData giftCard;
  final num amount;
  final String? rates;
  final bool isCode;
  final String currency;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pinController = useTextEditingController();
    final codeController = useTextEditingController();
    final transactionService = ref.read(transactionControllerProvider.notifier);

    final imageFiles = useState<List<File>>([]);
    final picker = ImagePicker();

    Future<void> pickImage() async {
      if (imageFiles.value.length >= 12) return; // Enforce max limit of 3

      final pickedFiles = await picker.pickMultiImage();
      final newImages = pickedFiles
          .map((file) => File(file.path))
          .where((file) => !imageFiles.value.contains(file))
          .toList();

      imageFiles.value = [...imageFiles.value, ...newImages].take(12).toList();
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
                    ? AppColors.darkBorder
                    : AppColors.whiteColor.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(16),
                  if (isCode == true) ...[
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
                      label: "Code ",
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const Gap(16),
                    CustomTextField(
                      controller: pinController,
                      label: "Pin (Optional)",
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const Gap(16),
                  ],
                  if (isCode != true) ...[
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
                      text: isCode
                          ? 'Ensure the codes are visible to avoid delays.'
                          : 'Maximum of 12 images allowed.',
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
                        child: Column(
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
                                        "Upload Screenshot or Proof of Payment",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: theme.brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ] else ...[
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: 0.67, // width/height ratio
                                ),
                                itemCount: imageFiles.value.length,
                                itemBuilder: (context, index) => Stack(
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
                              if (imageFiles.value.length < 12) ...[
                                Center(
                                  child: OutlinButton(
                                    text: "Upload More",
                                    onPressed: pickImage,
                                    width: 150,
                                    height: 40,
                                    color: theme.brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                    bgColor: Colors.transparent,
                                  ),
                                ),
                              ]
                            ]
                          ],
                        ),
                      ),
                    ),
                  ],
                  const Gap(20),
                  // Continue Button

                  FullButton(
                    isLoading: isCode == false
                        ? ref
                            .watch(authenticationControllerProvider)
                            .imageUpload
                            .isLoading
                        : ref
                            .watch(transactionControllerProvider)
                            .sellGiftCards
                            .isLoading,
                    text: "Next",
                    width: double.infinity,
                    height: 48,
                    onPressed: () async {
                      if (isCode != true) {
                        if (imageFiles.value.isNotEmpty) {
                          final result = await ref
                              .read(authenticationControllerProvider.notifier)
                              .uploadMultipleFiles(
                                imageFiles.value,
                              );
                          if (result == true) {
                            final uploadedFiles = ref
                                .read(authenticationControllerProvider)
                                .imageUpload
                                .valueOrNull;
                            List<String> paths =
                                getPathsFromUploadResponse(uploadedFiles);
                            final result =
                                await transactionService.sellGiftCards(
                                    id: rates ?? '',
                                    name: giftCard.name ?? '',
                                    amount: amount,
                                    pin: pinController.text.trim().isEmpty
                                        ? null
                                        : pinController.text.trim(),
                                    code: codeController.text.trim().isEmpty
                                        ? null
                                        : codeController.text.trim(),
                                    files: paths,
                                    ecode: false,
                                    comment: 'Just a comment');
                            if (result == true) {
                              await ref
                                  .read(transactionControllerProvider.notifier)
                                  .getTransactions();
                              final transaction = ref
                                  .watch(transactionControllerProvider)
                                  .sellGiftCards
                                  .valueOrNull;
                              showTradeSubmittedDialog(
                                context,
                                giftCard.icon ?? '',
                                () {
                                  context.router
                                      .replaceAll([const GiftCardRoute()]);
                                  Navigator.pop(context);
                                },
                                () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          GiftStandAloneTransactionDetailsScreen(
                                        type: transaction?.type ?? '',
                                        status: transaction?.status ?? '',
                                        transaction: transaction!,
                                      ),
                                    ),
                                  );
                                },
                                transaction?.id ?? '',
                                giftCard.name ?? '',
                                transaction?.amount.toString() ?? '',
                                currency,
                              );
                            }
                          }
                          await ref
                              .read(transactionControllerProvider.notifier)
                              .getTransactions();
                        } else {
                          ToastService().showToast(
                            NotificationType.info,
                            message: 'You need to upload proof of transaction',
                          );
                        }
                      } else {
                        logger.d(amount);
                        if (codeController.text.isNotEmpty) {
                          final result = await transactionService.sellGiftCards(
                              id: rates ?? '',
                              name: giftCard.name ?? '',
                              amount: amount,
                              pin: pinController.text.trim().isEmpty
                                  ? null
                                  : pinController.text.trim(),
                              code: codeController.text.trim().isEmpty
                                  ? null
                                  : codeController.text.trim(),
                              files: [],
                              ecode: true,
                              comment: 'Just a comment');
                          if (result == true) {
                            final transaction = ref
                                .watch(transactionControllerProvider)
                                .sellGiftCards
                                .valueOrNull;
                            showTradeSubmittedDialog(
                              context,
                              giftCard.icon ?? '',
                              () {
                                context.router
                                    .replaceAll([const GiftCardRoute()]);
                                Navigator.pop(context);
                              },
                              () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        GiftStandAloneTransactionDetailsScreen(
                                      type: transaction?.type ?? '',
                                      status: transaction?.status ?? '',
                                      transaction: transaction!,
                                    ),
                                  ),
                                );
                                // context.router.push(
                                //   GiftStandAloneTransactionDetailsRoute(
                                //     type: transaction?.type ?? '',
                                //     status: transaction?.status ?? '',
                                //     transaction: transaction!,
                                //   ),
                                // );
                              },
                              transaction?.id ?? '',
                              giftCard.name ?? '',
                              transaction?.amount.toString() ?? '',
                              currency,
                            );
                          }
                          await ref
                              .read(transactionControllerProvider.notifier)
                              .getTransactions();
                        } else {
                          ToastService().showToast(
                            NotificationType.info,
                            message: 'You need to fill the code field.',
                          );
                        }
                      }
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

  List<String> getPathsFromUploadResponse(UploadResponse? uploadResponse) {
    return uploadResponse?.files?.map((file) => file.path ?? '').toList() ?? [];
  }

  void showTradeSubmittedDialog(
    BuildContext context,
    final String img,
    final VoidCallback onTap,
    final VoidCallback onDone,
    final String id,
    final String giftcard,
    final String amount,
    final String currency,
  ) {
    showDialog(
      barrierDismissible: false,
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
                  backgroundColor: Colors.transparent,
                  child: CachedNetworkImage(
                    imageUrl: img,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.error,
                        color: Colors.white,
                      ),
                    ),
                  ),
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
                  "Your $giftcard gift card trade for $currency $amount is now pending admin review.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black54),
                ),
                const SizedBox(height: 12),

                // Transaction ID
                Text(
                  "Transaction ID: ${id.length > 12 ? '${id.substring(0, 12)}...' : id}",
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      onDone();
                      Navigator.pop(context);
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
                    onTap();
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
