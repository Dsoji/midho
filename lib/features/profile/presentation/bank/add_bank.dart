import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/res/app_colors.dart';
import '../../../../common/res/assets.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/custom_buttons.dart';
import '../../../../common/widgets/custom_textfield.dart';
import '../../../bank_network/presentation/bank_network_screen.dart';
import '../../../withdrawal/presentation/widget/bank_info_card.dart';
import '../../../withdrawal/presentation/widget/info_widget.dart';

@RoutePage()
class AddNewBankScreen extends HookConsumerWidget {
  const AddNewBankScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bankController = useTextEditingController();
    final theme = Theme.of(context);
    final isVerify = useState(false);

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Add Bank Accounts",
        showBackButton: true,
        showTitle: true,
        showAction: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Customize your app experience and notification preferences.",
              style: TextStyle(
                fontSize: 14,
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
                  // Email Field
                  GestureDetector(
                    onTap: () => _showAddBankDetailsSheet(context),
                    child: AbsorbPointer(
                      child: CustomTextField(
                        controller: bankController,
                        label: "Select Bank",
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),
                  CustomTextField(
                    controller: bankController,
                    label: "Account Number",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 28),
                  if (isVerify.value == true)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.brightness == Brightness.dark
                                ? AppColors.secondaryColor.shade700
                                : const Color(
                                    0xFFEDFCFE), // Dark navy blue background
                            borderRadius:
                                BorderRadius.circular(12), // Rounded corners
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Account Name",
                                style: TextStyle(
                                  // Light grey text
                                  fontSize: 14,
                                  color: theme.brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "John Doe",
                                style: TextStyle(
                                  color: theme.brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black, // Bright white text
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),
                  InfoWidget(
                    theme: theme,
                    text:
                        'Enter a valid 10-digit account number linked to your bank.',
                  ),

                  const SizedBox(height: 20),
                  // Continue Button
                  FullButton(
                    text:
                        isVerify.value == false ? "Verify Account" : "Confirm",
                    width: double.infinity,
                    height: 48,
                    onPressed: () {
                      if (isVerify.value == false) {
                        isVerify.value = true;
                      } else if (isVerify.value == true) {
                        Navigator.of(context).pop();
                      }
                    },
                    textColor: Colors.white,
                    color: AppColors.primaryColor.shade500,
                  ),
                  FullButton(
                    text: "Cancel",
                    width: double.infinity,
                    height: 48,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    textColor: theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    color: Colors.transparent,
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

  void _showAddBankDetailsSheet(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.brightness == Brightness.dark
          ? AppColors.secondaryColor.shade700
          : AppColors.scaffoldColorLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      builder: (context) => const AddBankScreen(),
    );
  }
}

class AddBankScreen extends HookWidget {
  const AddBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> bankList = [
      {
        "name": "GTBank",
        "image": PlaceholderAssets.gtbank, // Use 'image' instead of 'logo'
        "status": "Poor Network",
        "percentage": "49%", // Ensure this is a String
        "color": Colors.red,
        "actNumber": "1234 5678 9012", // Add this field
        "actName": "Savings Account", // Add this field
      },
      {
        "name": "UBA",
        "image": PlaceholderAssets.uba,
        "status": "Fair Network",
        "percentage": "55%",
        "color": Colors.amber,
        "actNumber": "5678 9012 3456",
        "actName": "Checking Account",
      },
      {
        "name": "Opay",
        "image": PlaceholderAssets.opay,
        "status": "Good Network",
        "percentage": "92%",
        "color": Colors.green,
        "actNumber": "9012 3456 7890",
        "actName": "Business Account",
      },
    ];
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade500
                    : Colors.grey.shade300,
              ),
            ),
          ),
          const Gap(23),
          const NetworkStatusIndicator(),
          const Gap(16),
          SizedBox(
            height: 248,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: bankList.length,
              separatorBuilder: (context, index) =>
                  const Gap(10), // Space between cards
              itemBuilder: (context, index) {
                final bank = bankList[index];

                return BankInfoCard2(
                  image: bank["image"] ??
                      "assets/default.png", // Use a default image if null
                  name: bank["name"] ?? "Unknown Bank",
                  color: bank["color"] ?? Colors.grey,
                  status: bank["status"] ?? "No Status",
                  percentage: bank["percentage"] ?? "0%",
                  actNumber: bank["actNumber"] ?? "N/A",
                  actName: bank["actName"] ?? "N/A",
                  showBorder: false,
                  icon: Icons.more_horiz,
                  onTap: () {
                    final GlobalKey<State<StatefulWidget>> globalKey =
                        GlobalKey();
                    _showPopupMenu(context, globalKey);
                  },
                );
              },
            ),
          ),
          const Gap(100),
        ],
      ),
    );
  }

  void _showPopupMenu(BuildContext context, GlobalKey key) async {
    final RenderBox renderBox =
        key.currentContext?.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final result = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + size.height,
        position.dx + size.width,
        position.dy + size.height + 10,
      ),
      items: [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.blue),
              SizedBox(width: 12),
              Text(
                "Edit",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 12),
              Text(
                "Delete",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
      elevation: 8,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

    if (result == 'edit') {
      print("Edit account selected");
    } else if (result == 'delete') {
      print("Delete account selected");
    }
  }
}
