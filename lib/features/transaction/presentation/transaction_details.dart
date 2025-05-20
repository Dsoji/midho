// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/common/extension/string/string_extension.dart';
import 'package:mdiho/common/utils/date_utils.dart';
import 'package:mdiho/common/widgets/custom_buttons.dart';
import 'package:mdiho/features/transaction/data/model/response/transaction_history/datum.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';
import 'package:screenshot/screenshot.dart';

import '../../../common/mixin/share_mixin.dart';
import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';

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
                transactionDetails["breakdown"],
                context,
              ),
            ),
            if (showAppBar == true)
              Column(
                children: [
                  const Gap(16),
                  FullButton(
                    text:
                        status == 'Failed' ? 'Retry Trade' : "Download Reciept",
                    width: double.infinity,
                    height: 60,
                    onPressed: isProcessing.value == true
                        ? () {}
                        : () async {
                            // if (status != 'Failed') {
                            //   isProcessing.value = true;
                            //   await screenshotController
                            //       .captureFromWidget(
                            //         MediaQuery(
                            //           data: MediaQueryData.fromView(
                            //               WidgetsBinding.instance.window),
                            //           child: InheritedTheme.captureAll(
                            //             context,
                            //             TransactionDetailsScreen(
                            //               type: type,
                            //               status: status,
                            //               showAppBar: false,
                            //             ),
                            //           ),
                            //         ),
                            //       )
                            //       .then(processAndSaveImage)
                            //       .catchError((onError) {
                            //     // Handle error
                            //     debugPrint('Screenshot error: $onError');
                            //   });
                            //   isProcessing.value = false;
                            // }
                          },
                    textColor: AppColors.whiteColor,
                    color: theme.brightness == Brightness.dark
                        ? AppColors.primaryColor.shade500
                        : Colors.black,
                  ),
                  const Gap(4),
                  FullButton(
                    text: "Contact Support",
                    width: double.infinity,
                    height: 60,
                    onPressed: () {},
                    textColor: theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    color: Colors.transparent,
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

  Widget _buildBreakdown(Map<String, dynamic> breakdown, BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Aligns items to the left
      children: [
        ...breakdown.entries.map(
          (entry) => _buildDetailRow(
              entry.key, entry.value.toString(), context, false),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    String title,
    String value,
    BuildContext context,
    bool isCopyable,
  ) {
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
                "${transaction.asset?.name ?? ''} (${transaction.asset?.name ?? ''})",
            "Rate":
                "${transaction.exchangeCurrency} ${transaction.asset?.rate ?? ' '}/${transaction.asset?.baseCurrency ?? ''}"
                    .commaFormat(),
            "Amount Sold":
                "${transaction.amount} ${transaction.asset?.baseCurrency ?? ''}"
                    .commaFormat(),
            "Total Received":
                "${transaction.exchangeCurrency} ${(transaction.amount ?? 0) * (transaction.rate ?? 0) + (transaction.fee ?? 0)}"
                    .commaFormat(),
          }
        };
        break;
      case "GIFTCARDSALE":
        if (transaction.status == "Completed") {
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
                  "${transaction.exchangeCurrency}  ${transaction.asset?.rate ?? ' '}/${transaction.asset?.baseCurrency ?? ''}"
                      .commaFormat(),
              "Amount Sold":
                  "${transaction.amount} ${transaction.asset?.baseCurrency ?? ''}"
                      .commaFormat(),
              "Total Received":
                  "${transaction.exchangeCurrency} ${(transaction.amount ?? 0) * (transaction.rate ?? 0) + (transaction.fee ?? 0)}"
                      .commaFormat(),
            }
          };
        } else if (transaction.status == "Failed") {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount":
                "${transaction.exchangeCurrency} ${(transaction.amount ?? 0) * (transaction.rate ?? 0) - (transaction.fee ?? 0)}"
                    .commaFormat(),
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "Gift Card Sold": "STEAM 10-200",
              "Rate": "${transaction.exchangeCurrency} 750/USD".commaFormat(),
              "Amount Sold": "\$50",
              "Reason for Failure": "Invalid Card - Card has been redeemed",
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
      case "Bill Payment":
        if (transaction.status == "Completed") {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount": "10,000.00",
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "Provider": "Ikeja Electric",
              "Account Number": "1234567890",
              "Total Charged": "10500",
            }
          };
        } else if (transaction.status == "Failed") {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount": "10,000.00",
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "Provider": "Ikeja Electric",
              "Account Number": "1234567890",
              "Total Charged": "10,500.00",
              "Reason for Failure": "Invalid Card - Card has been redeemed",
              "Proof of Failure": "View Screenshot",
            }
          };
        } else {
          details = {
            "transactionId": transaction.id,
            "dateTime": transaction.createdAt!.formatToReadableDateTime(),
            "amount": "10,000.00",
            "fee": '${transaction.exchangeCurrency}  ${transaction.fee}'
                .commaFormat(),
            "breakdown": {
              "Provider": "Ikeja Electric",
              "Account Number": "1234567890",
              "Total Charged": "10500",
            }
          };
        }
        break;
      case "Withdrawal":
        details = {
          "transactionId": transaction.id,
          "dateTime": transaction.createdAt!.formatToReadableDateTime(),
          "amount": "100,000.00",
          "fee": "1,000.00",
          "breakdown": {
            "Bank Name": "Access Bank",
            "Account Number": "1234567890",
            "Total Deducted": "101,000.00",
          }
        };
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
  });
  final String type;
  final String status;

  @override
  Widget build(BuildContext context) {
    final screenshotController = useMemoized(() => ScreenshotController());
    final isProcessing = useState(false);

    final theme = Theme.of(context);
    return OutlinedButton(
      onPressed: isProcessing.value == true
          ? () {}
          : () async {
              // isProcessing.value = true;
              // await screenshotController
              //     .captureFromWidget(
              //   MediaQuery(
              //     data: MediaQueryData.fromView(WidgetsBinding.instance.window),
              //     child: InheritedTheme.captureAll(
              //       context,
              //       TransactionDetailsScreen(
              //         type: type,
              //         status: status,
              //         showAppBar: false,
              //       ),
              //     ),
              //   ),
              // )
              //     .then((image) {
              //   showDialog(
              //     context: context,
              //     builder: (_) => AlertDialog(
              //       backgroundColor: Colors.white,
              //       content: Image.memory(image),
              //     ),
              //   );
              // }).catchError((onError) {
              //   // Handle error
              //   debugPrint('Screenshot error: $onError');
              // });
              // isProcessing.value = false;
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
