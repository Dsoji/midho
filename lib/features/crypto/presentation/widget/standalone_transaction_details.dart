// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/common/extension/string/string_extension.dart';
import 'package:mdiho/common/utils/date_utils.dart';
import 'package:mdiho/common/widgets/custom_buttons.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';

import '../../../../common/res/app_colors.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../gift_card/data/model/response/gift_cart_transaction/gift_cart_transaction.dart';

@RoutePage()
class StandAloneTransactionDetailsScreen extends StatelessWidget {
  final String type;
  final String status;
  final GiftCartTransaction transaction;

  const StandAloneTransactionDetailsScreen({
    super.key,
    required this.type,
    required this.status,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> transactionDetails =
        _getTransactionDetails(type, status, transaction);
    final theme = Theme.of(context);
    return PopScope(
      canPop: false, // Prevent default back navigation
      onPopInvoked: (didPop) {
        if (!didPop) {
          context.router.replaceAll([const CryptoRoute()]);

          final tabsRouter = AutoTabsRouter.of(
            context,
          );

          tabsRouter.setActiveIndex(0);
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Transaction History",
          showBackButton: true,
          showTitle: false,
          showAction: false,
          onBackPressed: () {
            context.router.replaceAll([const CryptoRoute()]);

            final tabsRouter = AutoTabsRouter.of(
              context,
            );

            tabsRouter.setActiveIndex(0);
          },
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? AppColors.secondaryColor.shade500
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _buildTransactionSummary(transactionDetails, context),
                      const Gap(20),
                      InfoWidget(
                        theme: theme,
                        text:
                            "The admin team will review your transaction. Once approved, you will receive a notification, and your wallet will be credited promptly.",
                      ),
                    ],
                  )),
              const Gap(12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.secondaryColor.shade500
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _buildBreakdown(
                  transactionDetails["breakdown"],
                  context,
                ),
              ),
              const Gap(16),
              FullButton(
                text: "Go Home",
                width: double.infinity,
                height: 60,
                onPressed: () {
                  context.router.replaceAll([const CryptoRoute()]);

                  final tabsRouter = AutoTabsRouter.of(
                    context,
                  );

                  tabsRouter.setActiveIndex(0);
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
                onPressed: () {
                  context.router.push(const SupportFaqRoute());
                },
                textColor: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                color: Colors.transparent,
              ),
              const Gap(150),
            ],
          ),
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
        Text(
          "Transaction Summary",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: theme.brightness == Brightness.dark
                ? AppColors.whiteColor
                : Colors.black,
          ),
        ),
        const Gap(20),
        _buildDetailRow(
            "Transaction ID", details["transactionId"], context, true),
        _buildDetailRow("Date & Time", details["dateTime"], context, false),
        _buildDetailRow("Type", type, context, false),
        _buildDetailRow("Amount", " ${details["amount"]}", context, false),
        _buildDetailRow("Fee", "${details["fee"]}", context, false),
        _buildDetailRow("Status", status, context, false),
      ],
    );
  }

  Widget _buildBreakdown(Map<String, dynamic> breakdown, BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Aligns items to the left
      children: [
        Text(
          "Breakdown",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: theme.brightness == Brightness.dark
                ? AppColors.whiteColor
                : Colors.black,
          ),
        ),
        const Gap(20),
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
              ? const ViewScreenshotButton()
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
    GiftCartTransaction transaction,
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
                "${transaction.asset?.name ?? ''} (${transaction.asset?.baseCurrency ?? ''})",
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

class ViewScreenshotButton extends StatelessWidget {
  const ViewScreenshotButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OutlinedButton(
      onPressed: () {
        // Handle button click
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
