// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mdiho/common/widgets/custom_buttons.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';

class TransactionDetailsPage extends StatelessWidget {
  final String type;
  final String status;

  const TransactionDetailsPage({
    super.key,
    required this.type,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> transactionDetails =
        _getTransactionDetails(type, status);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Transaction History",
        showBackButton: true,
        showTitle: false,
        showAction: false,
      ),
      body: Padding(
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
            const Gap(16),
            FullButton(
              text: "Download Reciept",
              width: double.infinity,
              height: 60,
              onPressed: () {},
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
        _buildDetailRow("Transaction ID", details["transactionId"]),
        _buildDetailRow("Date & Time", details["dateTime"]),
        _buildDetailRow("Type", type),
        _buildDetailRow("Amount", "₦${details["amount"]}"),
        _buildDetailRow("Fee", "₦${details["fee"]}"),
        _buildDetailRow(
          "Status",
          status,
          color: _getStatusColor(status),
        ),
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
          (entry) => _buildDetailRow(entry.key, entry.value.toString()),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String title, String value, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7.5),
      margin: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w400)),
          const Gap(35),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
              softWrap: true,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "completed":
        return Colors.green;
      case "failed":
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  Map<String, dynamic> _getTransactionDetails(String type, String status) {
    switch (type) {
      case "Crypto Sale":
        return {
          "transactionId": "#TRX123456",
          "dateTime": "Jan 15, 2025, 10:30 AM",
          "amount": "500,000.00",
          "fee": "5,000.00",
          "breakdown": {
            "Crypto Sold": "Bitcoin (BTC)",
            "Rate": "₦25,000,000/BTC",
            "Amount Sold": "0.02 BTC",
            "Total Received": "₦500,000.00",
          }
        };
      case "Gift Card Purchase":
        if (status == "Completed") {
          return {
            "transactionId": "#TRX123456",
            "dateTime": "Jan 15, 2025, 10:30 AM",
            "amount": "37,500.00",
            "fee": "500.00",
            "breakdown": {
              "Gift Card Sold": "STEAM 50-500",
              "Rate": "₦750/USD",
              "Amount Sold": "\$50",
              "Total Received": "₦37,000.00",
            }
          };
        } else {
          return {
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
        }
      case "Bill Payment":
        return {
          "transactionId": "#TRX123456",
          "dateTime": "Jan 15, 2025, 10:30 AM",
          "amount": "10,000.00",
          "fee": "500.00",
          "breakdown": {
            "Provider": "Ikeja Electric",
            "Account Number": "1234567890",
            "Total Charged": "₦10,500.00",
          }
        };
      case "Withdrawal":
        return {
          "transactionId": "#TRX123456",
          "dateTime": "Jan 15, 2025, 10:30 AM",
          "amount": "100,000.00",
          "fee": "1,000.00",
          "breakdown": {
            "Bank Name": "Access Bank",
            "Account Number": "1234567890",
            "Total Deducted": "₦101,000.00",
          }
        };
      default:
        return {};
    }
  }
}
