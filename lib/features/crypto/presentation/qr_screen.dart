import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/crypto/presentation/widget/upload_dialog.dart';
import 'package:mdiho/features/transaction/data/model/response/rates_model/datum.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../common/widgets/custom_buttons.dart';
import '../../bottomNav/app_router.gr.dart';
import '../../transaction/data/controller/transaction_controller.dart';

@RoutePage()
class QrCryptoScreen extends HookConsumerWidget {
  const QrCryptoScreen({
    super.key,
    required this.amount,
    required this.crypto,
  });
  final String amount;
  final RateData crypto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final duration = useState(const Duration(minutes: 15));
    String walletAddress = "${crypto.address}";
    String shortenedWalletAddress = walletAddress.length > 16
        ? '${walletAddress.substring(0, 15)}...${walletAddress.substring(walletAddress.length - 8)}'
        : walletAddress;
    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (duration.value.inSeconds > 0) {
          duration.value = Duration(seconds: duration.value.inSeconds - 1);
        } else {
          t.cancel();
        }
      });

      return timer.cancel;
    }, []);

    String formatDuration(Duration d) {
      String minutes = d.inMinutes.toString().padLeft(2, '0');
      String seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
      return "$minutes:$seconds";
    }

    return Scaffold(
        appBar: const CustomAppBar(
          title: "Transaction Details",
          showBackButton: true,
          showTitle: true,
          showAction: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.secondaryColor.shade500
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 17,
                            color: theme.brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                          children: [
                            const TextSpan(
                                text:
                                    "To proceed with this transaction, send\n"),
                            TextSpan(
                              text:
                                  "$amount ${crypto.baseCurrency} worth of ${crypto.symbol}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const TextSpan(
                                text: " to the wallet address below"),
                          ],
                        ),
                      ),
                    ),
                    const Gap(16),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            const TextSpan(
                                text: "Wallet address is valid for "),
                            TextSpan(
                              text: formatDuration(duration.value),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(16),
                    Center(
                      child: Text(
                        'Scan the QR code:',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Gap(16),
                    Center(
                      child: QrImageView(
                        data: walletAddress,
                        version: QrVersions.auto,
                        size: 130.0,
                        dataModuleStyle: QrDataModuleStyle(
                          color: theme.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          dataModuleShape: QrDataModuleShape.square,
                        ),
                        eyeStyle: QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: theme.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    const Gap(24),
                    _waaletAddressCard(
                        context, walletAddress, shortenedWalletAddress),
                    const Gap(24),
                    InfoWidget(
                      theme: theme,
                      text:
                          "Use the wallet address or QR code to send the specified amount of Bitcoin.",
                    ),
                    const Gap(24),
                    InfoWidget(
                      theme: theme,
                      text: "Ensure the exact amount is sent to avoid delays.",
                    ),
                    const Gap(24),
                    FullButton(
                      text: "SENT",
                      width: double.infinity,
                      height: 48,
                      onPressed: () {
                        showUploadProofDialog(
                            context, int.parse(amount), crypto, ref);
                      },
                      textColor: Colors.white,
                      color: AppColors.primaryColor.shade500,
                    ),
                    const Gap(24),
                  ],
                ),
              ),
              const Gap(150),
            ],
          ),
        ));
  }

  Widget _waaletAddressCard(
      BuildContext context, String walletAddress, String address) {
    final copied = useState(false);

    void copyToClipboard() {
      Clipboard.setData(ClipboardData(text: walletAddress));
      copied.value = true;
      Future.delayed(const Duration(seconds: 2), () {
        copied.value = false;
      });
    }

    final theme = Theme.of(context);

    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark
              ? AppColors.secondaryColor.shade700
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: theme.brightness == Brightness.dark
                  ? Colors.transparent
                  : AppColors.whiteColor.shade600),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Wallet address",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                const Gap(4),
                Text(
                  address,
                  style: TextStyle(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: copyToClipboard,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.secondaryColor.shade400,
                  ),
                  color: copied.value
                      ? Colors.green
                      : theme.brightness == Brightness.dark
                          ? AppColors.secondaryColor.shade500
                          : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  copied.value ? "Copied" : "Copy",
                  style: TextStyle(
                    color: copied.value
                        ? Colors.white
                        : theme.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show the dialog
  void showUploadProofDialog(
    BuildContext context,
    int amount,
    RateData crypto,
    WidgetRef ref,
  ) {
    showCryptoDialog(
      amount: amount,
      crypto: crypto,
      context: context,
      onDone: () {
        final transaction =
            ref.watch(transactionControllerProvider).sellCrypto.valueOrNull;
        AutoRouter.of(context).replaceAll([
          StandAloneTransactionDetailsRoute(
            type: transaction?.type ?? '',
            status: transaction?.status ?? '',
            transaction: transaction!,
          ),
        ]);
      },
      onSecondaryAction: () {
        context.router.replaceAll([
          const CryptoRoute(),
        ]);
        Navigator.pop(context);
      },
      ref: ref,
    );
  }
}
