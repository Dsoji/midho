import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mdiho/common/widgets/custom_buttons.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../common/widgets/custom_textfield.dart';

@RoutePage()
class SuggestionScreen extends HookConsumerWidget {
  const SuggestionScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final titleController = useTextEditingController();
    final suggestionController = useTextEditingController();
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

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Suggestion Box",
        showBackButton: true,
        showTitle: false,
        showAction: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "We Value Your Feedback",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Gap(4),
            const Text(
              "Help us improve M-Diho by sharing your suggestions.",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Gap(16),
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
                  CustomTextField(
                    controller: titleController,
                    label: "Title (Optional)",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const Gap(12),
                  CustomTextField(
                    controller: suggestionController,
                    label: "Describe Your Suggestion",
                    hintText: 'Explain your idea in detail...',
                    keyboardType: TextInputType.emailAddress,
                    maxLines: 3,
                  ),
                  const Gap(12),
                  Text(' Attach File (Optional)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : AppColors.greyColor.shade700,
                      )),
                  const Gap(4),
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
                            : AppColors.whiteColor.shade50,
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
                                      "Upload screenshots or additional documents \nto support your suggestion",
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
                  const Gap(12),
                  InfoWidget(
                      theme: theme,
                      text:
                          'Be as detailed as possible. The more information you provide, the better we can evaluate your idea.'),
                  const Gap(24),
                  FullButton(
                    text: 'Submit Suggestion',
                    width: double.infinity,
                    height: 48,
                    onPressed: () {},
                    textColor: Colors.white,
                    color: AppColors.primaryColor.shade500,
                  )
                ],
              ),
            ),
            const Gap(150),
          ],
        ),
      ),
    );
  }
}
