import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../../common/res/app_colors.dart';
import '../../../../common/toast/toast.dart';
import '../../../../common/utils/debouncer.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/custom_buttons.dart';
import '../../../../common/widgets/custom_textfield.dart';
import '../../../authentication/data/controller/authentication_controller.dart';
import '../../../bank_network/data/model/response/bank_list/bank_list.dart';
import '../../../bank_network/presentation/bank_network_screen.dart';
import '../../../transaction/data/controller/transaction_controller.dart';
import '../../../withdrawal/presentation/widget/bank_info_card.dart';
import '../../../withdrawal/presentation/widget/info_widget.dart';
import '../../data/controller/profile_controller.dart';

final logger = Logger();
final selectedBankProvider = StateProvider<BanlList?>((ref) => null);

@RoutePage()
class AddNewBankScreen extends HookConsumerWidget {
  const AddNewBankScreen({
    super.key,
    this.isverif = false,
  });
  final bool? isverif;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bankController = useTextEditingController();
    final theme = Theme.of(context);
    final acctNumberController = useTextEditingController();
    final acctNameController = useTextEditingController();
    final isVerify = useState(isverif);
    final selectedBank = ref.watch(selectedBankProvider);
    final banks = ref.watch(profileControllerProvider).banks.valueOrNull;
    final debouncer =
        useMemoized(() => Debouncer(delay: const Duration(milliseconds: 100)));
    useEffect(() => debouncer.dispose, [debouncer]);
    final isLoadingName = useState(false);

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
                  BankInfoCard(
                    isAddBank: true,
                    name: selectedBank?.name ?? 'GT Bank',
                    status: selectedBank?.status ?? 'Poor Network',
                    percentage: '${selectedBank?.strength ?? 0}%',
                    actNumber: '1210125678',
                    actName: 'John Doe',
                    onTap: () => _showAddBankDetailsSheet(context),
                  ),
                  const SizedBox(height: 28),
                  CustomTextField(
                    controller: acctNumberController,
                    label: "Account Number",
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (value.trim().length == 10) {
                        isLoadingName.value = true; // 🔄 Start loading
                        debouncer(() async {
                          acctNameController.clear();
                          final result = await ref
                              .read(transactionControllerProvider.notifier)
                              .acctName(
                                acctNo: value.trim(),
                                bankCode: selectedBank?.code ?? '',
                              );

                          if (result == true) {
                            final acctname = ref
                                .watch(transactionControllerProvider)
                                .acctName
                                .valueOrNull
                                ?.accountName;
                            acctNameController.text = acctname ?? '';
                          }

                          isLoadingName.value = false; // ✅ Stop loading
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 18),
                  isLoadingName.value
                      ? Row(
                          children: [
                            Text(
                              "Account name: ",
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.brightness == Brightness.dark
                                    ? Colors.white
                                    : AppColors.greyColor.shade700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.brightness == Brightness.dark
                                    ? Colors.white
                                    : AppColors.greyColor.shade700,
                              ),
                            ),
                          ],
                        )
                      : RichText(
                          maxLines: 2,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.brightness == Brightness.dark
                                  ? Colors.white
                                  : AppColors.greyColor.shade700,
                            ),
                            children: [
                              const TextSpan(text: 'Account name: '),
                              TextSpan(
                                text: acctNameController.text,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.brightness == Brightness.dark
                                      ? Colors.white
                                      : AppColors.greyColor.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                  const SizedBox(height: 18),
                  InfoWidget(
                    theme: theme,
                    text:
                        'Enter a valid 10-digit account number linked to your bank.',
                  ),

                  const SizedBox(height: 20),
                  // Continue Button
                  FullButton(
                    isLoading: ref
                        .watch(transactionControllerProvider)
                        .addBank
                        .isLoading,
                    text: "Confirm",
                    width: double.infinity,
                    height: 48,
                    onPressed: () async {
                      if (acctNameController.text.isNotEmpty) {
                        final result = await ref
                            .read(transactionControllerProvider.notifier)
                            .addBanks(
                              acctName: acctNameController.text.trim(),
                              acctNo: acctNumberController.text.trim(),
                              bankName: selectedBank?.name ?? '',
                              bankCode: selectedBank?.code ?? '',
                            );
                        if (result == true) {
                          await ref
                              .read(authenticationControllerProvider.notifier)
                              .fetchProfile();
                          ref
                              .read(authenticationControllerProvider)
                              .userDetails
                              .value
                              ?.banks;

                          Navigator.of(context).pop();
                        }
                      } else {
                        ToastService().showToast(
                          NotificationType.info,
                          message: 'Confirm details before proceeding.',
                        );
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
      builder: (context) {
        final height = MediaQuery.of(context).size.height;
        return const FractionallySizedBox(
          heightFactor: 0.85, // 70% of screen height
          child: AddBankScreen(),
        );
      },
    );
  }
}

class AddBankScreen extends HookConsumerWidget {
  const AddBankScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banks = ref.watch(profileControllerProvider).banks.valueOrNull;
    final theme = Theme.of(context);
    final searchController = useTextEditingController();
    final filteredBanks = useState<List<BanlList>>(banks ?? []);

    useEffect(() {
      if (banks != null) filteredBanks.value = banks;
      return null;
    }, [banks]);

    if (banks == null) return const Center(child: CircularProgressIndicator());

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
          CustomTextField(
            controller: searchController,
            label: "Search Bank",
            keyboardType: TextInputType.text,
            onChanged: (value) {
              final query = value.toLowerCase();
              filteredBanks.value = banks
                  .where((bank) =>
                      bank.name?.toLowerCase().contains(query) ?? false)
                  .toList();
            },
          ),
          const Gap(16),
          Expanded(
            child: ListView.separated(
              itemCount: filteredBanks.value.length,
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (context, index) => const Gap(10),
              itemBuilder: (context, index) {
                final bank = filteredBanks.value[index];

                return BankInfoCard2(
                  name: bank.name ?? "Unknown Bank",
                  status: bank.status ?? "No Status",
                  percentage: '${bank.strength ?? 0}%',
                  showBorder: false,
                  onTap: () {
                    ref.read(selectedBankProvider.notifier).state = bank;
                    final GlobalKey<State<StatefulWidget>> globalKey =
                        GlobalKey();
                    _showPopupMenu(context, globalKey);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
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
              Text("Edit",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 12),
              Text("Delete",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
      elevation: 8,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    if (result == 'edit') {
      // Edit logic here
    } else if (result == 'delete') {
      // Delete logic here
    }
  }
}
