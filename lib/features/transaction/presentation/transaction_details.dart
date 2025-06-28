// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:logger/logger.dart';
import 'package:mdiho/common/extension/string/string_extension.dart';
import 'package:mdiho/common/utils/date_utils.dart';
import 'package:mdiho/common/widgets/custom_buttons.dart';
import 'package:mdiho/features/transaction/data/model/response/transaction_history/datum.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';
import 'package:screenshot/screenshot.dart';

import '../../../common/mixin/share_mixin.dart';
import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';

final logger = Logger();

@RoutePage()
class TransactionDetailsScreen extends HookWidget with ShareMixin {
  final TransactionData transaction;
  final String type;
  final String status;
  final bool? showAppBar;

  const TransactionDetailsScreen({
    super.key,
    required this.type,
    required this.status,
    this.showAppBar = true,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> transactionDetails =
        _getTransactionDetails(type, status, transaction);
    final screenshotController = useMemoized(() => ScreenshotController());
    final isProcessing = useState(false);
    final proofs = transaction.proofs;
    logger.d(proofs);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: showAppBar == true
          ? const CustomAppBar(
              title: "Transaction History",
              showBackButton: true,
              showTitle: false,
              showAction: false,
            )
          : null,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showAppBar != true) const Gap(72),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Transaction Summary",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.brightness == Brightness.dark
                      ? AppColors.whiteColor
                      : Colors.black,
                ),
              ),
            ),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.darkBorder
                      : Colors.white,
                ),
                child: _buildTransactionSummary(transactionDetails, context)),
            const Gap(20),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Breakdown",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.brightness == Brightness.dark
                      ? AppColors.whiteColor
                      : Colors.black,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.darkBorder
                    : Colors.white,
              ),
              child: _buildBreakdown(
                transactionDetails["breakdown"], context,
                proofs, // Passes any proof screenshots from the transaction details to the breakdown widget
              ),
            ),
            if (showAppBar == true)
              Column(
                children: [
                  const Gap(16),
                  if (status.toLowerCase() != 'failed' &&
                      status.toLowerCase() != 'rejected')
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FullButton(
                        text: "Download Reciept",
                        width: double.infinity,
                        height: 60,
                        isLoading: isProcessing.value,
                        onPressed: isProcessing.value == true
                            ? () {}
                            : () async {
                                if (status != 'Failed') {
                                  isProcessing.value = true;
                                  await screenshotController
                                      .captureFromWidget(
                                        MediaQuery(
                                          data: MediaQueryData.fromView(
                                              WidgetsBinding.instance.window),
                                          child: InheritedTheme.captureAll(
                                            context,
                                            TransactionDetailsScreen(
                                              type: type,
                                              status: status,
                                              showAppBar: false,
                                              transaction: transaction,
                                            ),
                                          ),
                                        ),
                                      )
                                      .then(processAndSaveImage)
                                      .catchError((onError) {
                                    // Handle error
                                    debugPrint('Screenshot error: $onError');
                                  });
                                  isProcessing.value = false;
                                }
                              },
                        textColor: AppColors.whiteColor,
                        color: theme.brightness == Brightness.dark
                            ? AppColors.primaryColor.shade500
                            : Colors.black,
                      ),
                    ),
                  const Gap(4),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FullButton(
                      text: "Contact Support",
                      width: double.infinity,
                      height: 60,
                      onPressed: () {},
                      textColor: theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
            const Gap(150),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionSummary(
      Map<String, dynamic> details, BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
            "Transaction ID", details["transactionId"], context, true),
        _buildDetailRow("Date & Time", details["dateTime"], context, false),
        _buildDetailRow("Type", type, context, false),
        _buildDetailRow("Amount", "${details["amount"]}", context, false),
        _buildDetailRow("Fee", "${details["fee"]}", context, false),
        _buildDetailRow("Status", status, context, false),
        const Gap(20),
        if (status.toUpperCase() == 'PENDING')
          InfoWidget(
              theme: theme,
              text:
                  'The admin team will review your transaction. Once approved, you will receive a notification, and your wallet will be credited promptly.')
      ],
    );
  }

  Widget _buildBreakdown(
    Map<String, dynamic> breakdown,
    BuildContext context,
    List<dynamic>? proofs,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Aligns items to the left
      children: [
        ...breakdown.entries.map(
          (entry) => _buildDetailRow(
            entry.key,
            entry.value.toString(),
            context,
            false,
            proofs: proofs,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    String title,
    String value,
    BuildContext context,
    bool isCopyable, {
    List<dynamic>? proofs,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7.5),
      margin: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: theme.brightness == Brightness.dark
                    ? AppColors.whiteColor
                    : Colors.black,
              )),
          const Gap(35),
          value == 'View Screenshot'
              ? ViewScreenshotButton(
                  type: type,
                  status: status,
                  proofs: proofs,
                )
              : Flexible(
                  child: InkWell(
                    onTap: () {
                      if (!isCopyable) return;
                      Clipboard.setData(ClipboardData(text: value));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Copied to clipboard")),
                      );
                    },
                    child: Text(
                      value,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(value, context),
                        fontFamily: '',
                      ),
                      softWrap: true,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status, BuildContext context) {
    final theme = Theme.of(context);
    switch (status.toLowerCase()) {
      case "completed":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "failed":
        return Colors.red;
      case "rejected":
        return Colors.red;
      default:
        return theme.brightness == Brightness.dark
            ? Colors.white
            : Colors.black;
    }
  }

  Map<String, dynamic> _getTransactionDetails(
    String type,
    String status,
    TransactionData transaction,
  ) {
    Map<String, dynamic> details = {};

    switch (transaction.type) {
      case "CRYPTOSALE":
        if (transaction.status?.toLowerCase() == "completed") {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount":
                "${transaction.exchangeCurrency} ${(transaction.amount ?? 0) * (transaction.rate ?? 0) - (transaction.fee ?? 0)}"
                    .commaFormat(),
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "Crypto Sold":
                  "${transaction.asset?.name ?? ''} (${transaction.asset?.baseCurrency ?? ''})",
              "Rate":
                  "${transaction.exchangeCurrency}  ${transaction.rate ?? ' '}/${transaction.asset?.baseCurrency ?? ''}"
                      .commaFormat(),
              "Amount Sold":
                  "${transaction.amount} ${transaction.asset?.baseCurrency ?? ''}"
                      .commaFormat(),
              "Total Received":
                  "${transaction.exchangeCurrency} ${(transaction.amount ?? 0) * (transaction.rate ?? 0) + (transaction.fee ?? 0)}"
                      .commaFormat(),
            }
          };
        } else if (transaction.status?.toLowerCase() == "failed" ||
            transaction.status?.toLowerCase() == "rejected") {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount":
                "${transaction.exchangeCurrency} ${(transaction.amount ?? 0) * (transaction.rate ?? 0) - (transaction.fee ?? 0)}"
                    .commaFormat(),
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "CryptoSold": transaction.asset?.name ?? '',
              "Rate":
                  "${transaction.exchangeCurrency}  ${transaction.rate ?? ' '}/${transaction.asset?.baseCurrency ?? ''}"
                      .commaFormat(),
              "Amount Sold": "${transaction.baseCurrency} ${transaction.amount}"
                  .commaFormat(),
              "Reason for Failure": transaction.reason ?? '',
              "Proof of Failure": "View Screenshot",
            }
          };
        } else {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount":
                "${transaction.exchangeCurrency} ${(transaction.amount ?? 0) * (transaction.rate ?? 0) - (transaction.fee ?? 0)}"
                    .commaFormat(),
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "Crypto Sold":
                  "${transaction.asset?.name ?? ''} (${transaction.asset?.baseCurrency ?? ''})",
              "Rate":
                  "${transaction.exchangeCurrency}  ${transaction.rate ?? ' '}/${transaction.asset?.baseCurrency ?? ''}"
                      .commaFormat(),
              "Amount Sold":
                  "${transaction.amount} ${transaction.asset?.baseCurrency ?? ''}"
                      .commaFormat(),
              "Total Received":
                  "${transaction.exchangeCurrency} ${(transaction.amount ?? 0) * (transaction.rate ?? 0) + (transaction.fee ?? 0)}"
                      .commaFormat(),
            }
          };
        }
        break;
      case "GIFTCARDSALE":
        if (transaction.status?.toLowerCase() == "completed") {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount":
                "${transaction.exchangeCurrency} ${(transaction.amount ?? 0) * (transaction.rate ?? 0) - (transaction.fee ?? 0)}"
                    .commaFormat(),
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "Gift Card Sold": transaction.asset?.name ?? '',
              "Rate":
                  "${transaction.exchangeCurrency}  ${transaction.rate ?? ' '}/${transaction.asset?.baseCurrency ?? ''}"
                      .commaFormat(),
              "Amount Sold":
                  "${transaction.amount} ${transaction.asset?.baseCurrency ?? ''}"
                      .commaFormat(),
              "Total Received":
                  "${transaction.exchangeCurrency} ${(transaction.amount ?? 0) * (transaction.rate ?? 0) + (transaction.fee ?? 0)}"
                      .commaFormat(),
            }
          };
        } else if (transaction.status?.toLowerCase() == "failed" ||
            transaction.status?.toLowerCase() == "rejected") {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount":
                "${transaction.exchangeCurrency} ${(transaction.amount ?? 0) * (transaction.rate ?? 0) - (transaction.fee ?? 0)}"
                    .commaFormat(),
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "Gift Card Sold": transaction.asset?.name ?? '',
              "Rate":
                  "${transaction.exchangeCurrency}  ${transaction.rate ?? ' '}/${transaction.asset?.baseCurrency ?? ''}"
                      .commaFormat(),
              "Amount Sold": "${transaction.baseCurrency} ${transaction.amount}"
                  .commaFormat(),
              "Reason for Failure": transaction.reason ?? '',
              "Proof of Failure": "View Screenshot",
            }
          };
        } else {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount":
                "${transaction.exchangeCurrency} ${(transaction.amount ?? 0) * (transaction.rate ?? 0) - (transaction.fee ?? 0)}"
                    .commaFormat(),
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "Gift Card Sold": transaction.asset?.name ?? '',
              "Rate":
                  "${transaction.exchangeCurrency} ${transaction.rate}/${transaction.baseCurrency}"
                      .commaFormat(),
              "Amount Sold": "${transaction.baseCurrency} ${transaction.amount}"
                  .commaFormat(),
              "Total Received":
                  "${transaction.exchangeCurrency} ${(transaction.amount ?? 0) * (transaction.rate ?? 0) + (transaction.fee ?? 0)}"
                      .commaFormat(),
            }
          };
        }
        break;
      case "INTERNETBUY":
        if (transaction.status?.toLowerCase() == "completed") {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount": "${transaction.baseCurrency} ${transaction.amount}"
                .commaFormat(),
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "Provider": transaction.metadata?.vendor?.name ?? '',
              "Account Number": transaction.accountNumber ?? '',
              "Total Charged": "10500",
            }
          };
        } else if (transaction.status?.toLowerCase() == "failed" ||
            transaction.status?.toLowerCase() == "rejected") {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount":
                "${transaction.exchangeCurrency} ${(transaction.amount ?? 0) * (transaction.rate ?? 0) - (transaction.fee ?? 0)}"
                    .commaFormat(),
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "Provider": transaction.metadata?.vendor?.name ?? '',
              "Account Number": transaction.accountNumber ?? '',
              "Total Charged": transaction.metadata?.amount ?? '',
              "Reason for Failure": transaction.reason ?? '',
              "Proof of Failure": "View Screenshot",
            }
          };
        } else {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount": "${transaction.baseCurrency} ${transaction.amount}"
                .commaFormat(),
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "Provider": transaction.metadata?.vendor?.name ?? '',
              "Account Number": transaction.accountNumber ?? '',
              "Total Charged": transaction.metadata?.amount ?? '',
            }
          };
        }
        break;
      case "BETTINGBUY":
        if (transaction.status?.toLowerCase() == "completed") {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount": "${transaction.baseCurrency} ${transaction.amount}"
                .commaFormat(),
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "Provider": transaction.metadata?.vendor?.name ?? '',
              "Account Number": transaction.accountNumber ?? '',
              "Total Charged": transaction.metadata?.amount ?? '',
            }
          };
        } else if (transaction.status?.toLowerCase() == "failed" ||
            transaction.status?.toLowerCase() == "rejected") {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount": "${transaction.baseCurrency} ${transaction.amount}"
                .commaFormat(),
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "Provider": transaction.metadata?.vendor?.name ?? '',
              "Account Number": transaction.accountNumber ?? '',
              "Total Charged": transaction.metadata?.amount ?? '',
              "Reason for Failure": transaction.reason ?? '',
              "Proof of Failure": "View Screenshot",
            }
          };
        } else {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount": "${transaction.baseCurrency} ${transaction.amount}"
                .commaFormat(),
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "Provider": transaction.metadata?.vendor?.name ?? '',
              "Account Number": transaction.accountNumber ?? '',
              "Total Charged": transaction.metadata?.amount ?? '',
            }
          };
        }
        break;
      case "CABLEBUY":
        if (transaction.status?.toLowerCase() == "completed") {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount": "${transaction.baseCurrency} ${transaction.amount}"
                .commaFormat(),
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "Provider": transaction.metadata?.vendor?.name ?? '',
              "Account Number": transaction.accountNumber ?? '',
              "Total Charged": transaction.metadata?.amount ?? '',
            }
          };
        } else if (transaction.status?.toLowerCase() == "failed" ||
            transaction.status?.toLowerCase() == "rejected") {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount": "${transaction.baseCurrency} ${transaction.amount}"
                .commaFormat(),
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "Provider": transaction.metadata?.vendor?.name ?? '',
              "Account Number": transaction.accountNumber ?? '',
              "Total Charged": transaction.metadata?.amount ?? '',
              "Reason for Failure": transaction.reason ?? '',
              "Proof of Failure": "View Screenshot",
            }
          };
        } else {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount": "${transaction.baseCurrency} ${transaction.amount}"
                .commaFormat(),
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "Provider": transaction.metadata?.vendor?.name ?? '',
              "Account Number": transaction.accountNumber ?? '',
              "Total Charged": transaction.metadata?.amount ?? '',
            }
          };
        }
        break;
      case "ELECTRICITYBUY":
        if (transaction.status?.toLowerCase() == "completed") {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount": "${transaction.baseCurrency} ${transaction.amount}"
                .commaFormat(),
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "Provider": transaction.metadata?.vendor?.name ?? '',
              "Account Number": transaction.accountNumber ?? '',
              "Total Charged": transaction.metadata?.amount ?? '',
            }
          };
        } else if (transaction.status?.toLowerCase() == "failed" ||
            transaction.status?.toLowerCase() == "rejected") {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount": "${transaction.baseCurrency} ${transaction.amount}"
                .commaFormat(),
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "Provider": transaction.metadata?.vendor?.name ?? '',
              "Account Number": transaction.accountNumber ?? '',
              "Total Charged": transaction.metadata?.amount ?? '',
              "Reason for Failure": transaction.reason ?? '',
              "Proof of Failure": "View Screenshot",
            }
          };
        } else {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount": "${transaction.baseCurrency} ${transaction.amount}"
                .commaFormat(),
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "Provider": transaction.metadata?.vendor?.name ?? '',
              "Account Number": transaction.accountNumber ?? '',
              "Total Charged": transaction.metadata?.amount ?? '',
            }
          };
        }
        break;
      case "AIRTIMEBUY":
        if (transaction.status?.toLowerCase() == "completed") {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount": transaction.metadata?.amount ?? '',
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "Provider": transaction.metadata?.vendor?.name ?? '',
              "Account Number": transaction.accountNumber ?? '',
              "Total Charged": transaction.metadata?.amount ?? '',
            }
          };
        } else if (transaction.status?.toLowerCase() == "failed" ||
            transaction.status?.toLowerCase() == "rejected") {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount": transaction.metadata?.amount ?? '',
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "Provider": transaction.metadata?.vendor?.name ?? '',
              "Account Number": transaction.accountNumber ?? '',
              "Total Charged": transaction.metadata?.amount ?? '',
              "Reason for Failure": transaction.reason ?? '',
              "Proof of Failure": "View Screenshot",
            }
          };
        } else {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount": transaction.metadata?.amount ?? '',
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "Provider": transaction.metadata?.vendor?.name ?? '',
              "Account Number": transaction.accountNumber ?? '',
              "Total Charged": transaction.metadata?.amount ?? '',
            }
          };
        }
        break;
      case "WITHDRAWAL":
        if (transaction.status?.toLowerCase() == "completed") {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount":
                "${transaction.exchangeCurrency} ${(transaction.amount ?? 0) * (transaction.rate ?? 0) - (transaction.fee ?? 0)}"
                    .commaFormat(),
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "Bank Name": transaction.bankName ?? '',
              "Account Number": transaction.accountNumber ?? '',
              "Total Deducted": transaction.metadata?.amount ?? '',
            }
          };
        } else if (transaction.status?.toLowerCase() == "failed" ||
            transaction.status?.toLowerCase() == "rejected") {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount":
                "${transaction.exchangeCurrency} ${(transaction.amount ?? 0) * (transaction.rate ?? 0) - (transaction.fee ?? 0)}"
                    .commaFormat(),
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "Bank Name": transaction.bankName ?? '',
              "Account Number": transaction.accountNumber ?? '',
              "Reason for Failure": transaction.reason ?? '',
              "Proof of Failure": "View Screenshot",
            }
          };
        }
        break;
      default:
        details = {
          "transactionId": "N/A",
          "dateTime": "N/A",
          "amount": "0.00",
          "fee": "0.00",
          "breakdown": {}
        };
    }

    return details;
  }
}

class ViewScreenshotButton extends HookWidget with ShareMixin {
  const ViewScreenshotButton({
    super.key,
    required this.type,
    required this.status,
    this.proofs,
  });
  final String type;
  final String status;
  final List<dynamic>? proofs;
  @override
  Widget build(BuildContext context) {
    final screenshotController = useMemoized(() => ScreenshotController());
    final isProcessing = useState(false);
    final scrollController = useMemoized(() => ScrollController());
    final scrollController2 = useMemoized(() => ScrollController());
    final theme = Theme.of(context);
    return OutlinedButton(
      onPressed: isProcessing.value == true
          ? () {}
          : () async {
              if (proofs == null || proofs!.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No screenshots available'),
                  ),
                );
                return;
              }

              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Proof of failure',
                              style: theme.textTheme.bodyLarge,
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Stack(
                          children: [
                            SizedBox(
                              height:
                                  200, // Fixed height for the horizontal list
                              child: Builder(builder: (context) {
                                return ListView.separated(
                                  controller: scrollController2,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: proofs!.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(width: 12),
                                  itemBuilder: (context, index) {
                                    return Image.network(
                                      proofs![index].toString(),
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Center(
                                          child: Text('Failed to load image'),
                                        );
                                      },
                                    );
                                  },
                                );
                              }),
                            ),
                            Positioned.fill(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    color: Colors.black26,
                                    child: IconButton(
                                      icon: const Icon(Icons.arrow_back_ios),
                                      color: Colors.white,
                                      onPressed: () {
                                        final currentPosition =
                                            scrollController2.position.pixels;
                                        scrollController2.animateTo(
                                          currentPosition - 200,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    color: Colors.black26,
                                    child: IconButton(
                                      icon: const Icon(Icons.arrow_forward_ios),
                                      color: Colors.white,
                                      onPressed: () {
                                        final currentPosition =
                                            scrollController2.position.pixels;
                                        scrollController2.animateTo(
                                          currentPosition + 200,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
      style: OutlinedButton.styleFrom(
        backgroundColor: theme.brightness == Brightness.dark
            ? AppColors.secondaryColor.shade400
            : AppColors.primaryColor.shade50, // Light pink background
        side: BorderSide.none, // Remove border
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Button Text
          Flexible(
            child: Text(
              "View Screenshot",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                // Dark text color
              ),
              softWrap: true,
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(width: 8),

          // Screenshot Icon
          Icon(
            IconsaxPlusLinear.image, // Replace with actual screenshot icon
            color: theme.brightness == Brightness.dark
                ? Colors.white
                : AppColors.primaryColor.shade500,
            size: 22,
          ),
        ],
      ),
    );
  }
}
