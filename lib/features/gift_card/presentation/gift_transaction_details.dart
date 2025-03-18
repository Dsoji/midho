// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/common/extension/string/string_extension.dart';
import 'package:mdiho/common/widgets/custom_buttons.dart';
import 'package:screenshot/screenshot.dart';

import '../../../common/mixin/share_mixin.dart';
import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../transaction/presentation/transaction_details.dart';

@RoutePage()
class GiftTransactionDetailsScreen extends HookWidget with ShareMixin {
  final String type;
  final String status;
  final bool? showAppBar;

  const GiftTransactionDetailsScreen({
    super.key,
    required this.type,
    required this.status,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> transactionDetails =
        _getTransactionDetails(type, status);
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showAppBar != true) const Gap(72),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.secondaryColor.shade500
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _buildTransactionSummary(transactionDetails, context)),
            const Gap(12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              )
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
        _buildDetailRow("Transaction ID", details["transactionId"], context),
        _buildDetailRow("Date & Time", details["dateTime"], context),
        _buildDetailRow("Type", type, context),
        _buildDetailRow("Amount", "₦${details["amount"]}", context),
        _buildDetailRow("Fee", "₦${details["fee"]}", context),
        _buildDetailRow("Status", status, context),
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
          (entry) =>
              _buildDetailRow(entry.key, entry.value.toString(), context),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    String title,
    String value,
    BuildContext context,
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
                  child: Text(
                    value.formatAsNaira(),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(value, context),
                      fontFamily: '',
                    ),
                    softWrap: true,
                    textAlign: TextAlign.end,
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

  Map<String, dynamic> _getTransactionDetails(String type, String status) {
    Map<String, dynamic> details = {};

    switch (type) {
      case "Crypto Sale":
        details = {
          "transactionId": "#TRX123456",
          "dateTime": "Jan 15, 2025, 10:30 AM",
          "amount": "500,000.00",
          "fee": "5,000.00",
          "breakdown": {
            "Crypto Sold": "Bitcoin (BTC)",
            "Rate": "₦25,000,000/BTC",
            "Amount Sold": "0.02 BTC",
            "Total Received": "500000",
          }
        };
        break;
      case "Gift Card Purchase":
        if (status == "Completed") {
          details = {
            "transactionId": "#TRX123456",
            "dateTime": "Jan 15, 2025, 10:30 AM",
            "amount": "37,500.00",
            "fee": "500.00",
            "breakdown": {
              "Gift Card Sold": "STEAM 50-500",
              "Rate": "₦750/USD",
              "Amount Sold": "\$50",
              "Total Received": "37,000.00",
            }
          };
        } else if (status == "Failed") {
          details = {
            "transactionId": "#TRX123456",
            "dateTime": "Jan 15, 2025, 10:30 AM",
            "amount": "37,500.00",
            "fee": "500.00",
            "breakdown": {
              "Gift Card Sold": "STEAM 10-200",
              "Rate": "₦750/USD",
              "Amount Sold": "\$50",
              "Reason for Failure": "Invalid Card - Card has been redeemed",
              "Proof of Failure": "View Screenshot",
            }
          };
        } else {
          details = {
            "transactionId": "#TRX123456",
            "dateTime": "Jan 15, 2025, 10:30 AM",
            "amount": "37,500.00",
            "fee": "500.00",
            "breakdown": {
              "Gift Card Sold": "STEAM 50-500",
              "Rate": "₦750/USD",
              "Amount Sold": "\$50",
              "Total Received": "37000",
            }
          };
        }
        break;
      case "Bill Payment":
        if (status == "Completed") {
          details = {
            "transactionId": "#TRX123456",
            "dateTime": "Jan 15, 2025, 10:30 AM",
            "amount": "10,000.00",
            "fee": "500.00",
            "breakdown": {
              "Provider": "Ikeja Electric",
              "Account Number": "1234567890",
              "Total Charged": "10500",
            }
          };
        } else if (status == "Failed") {
          details = {
            "transactionId": "#TRX123456",
            "dateTime": "Jan 15, 2025, 10:30 AM",
            "amount": "10,000.00",
            "fee": "500.00",
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
            "transactionId": "#TRX123456",
            "dateTime": "Jan 15, 2025, 10:30 AM",
            "amount": "10,000.00",
            "fee": "500.00",
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
          "transactionId": "#TRX123456",
          "dateTime": "Jan 15, 2025, 10:30 AM",
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

    final theme = Theme.of(context);
    return OutlinedButton(
      onPressed: () async {
        await screenshotController
            .captureFromWidget(
          MediaQuery(
            data: MediaQueryData.fromView(WidgetsBinding.instance.window),
            child: InheritedTheme.captureAll(
              context,
              TransactionDetailsScreen(
                type: type,
                status: status,
                showAppBar: false,
              ),
            ),
          ),
        )
            .then((image) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: Colors.white,
              content: Image.memory(image),
            ),
          );
        }).catchError((onError) {
          // Handle error
          debugPrint('Screenshot error: $onError');
        });
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
