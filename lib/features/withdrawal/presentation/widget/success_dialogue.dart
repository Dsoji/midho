import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../common/res/app_colors.dart';
import '../../../../common/widgets/custom_buttons.dart';
import '../../../bottomNav/app_router.gr.dart';
import '../../../transaction/presentation/transaction_details.dart';
import 'info_widget.dart';

@RoutePage()
class WithdrawalSuccessDialogScreen extends StatelessWidget {
  const WithdrawalSuccessDialogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: theme.brightness == Brightness.dark
          ? AppColors.secondaryColor.shade500
          : Colors.white, // Dark theme background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Success Icon
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.green.shade100,
            child:
                const Icon(Icons.check_circle, size: 60, color: Colors.green),
          ),
          const SizedBox(height: 16),

          // Title
          const Text(
            "Withdrawal Successful",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Description
          const Text(
            "Your withdrawal of ₦50,000.00 to GTBank - ****5678 has been processed successfully!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontFamily: '',
            ),
          ),
          const Gap(16),

          // Transaction Details
          _buildDetailRow("Transaction ID", "#TRX123456", context),
          _buildDetailRow("Date & Time", "Jan 27, 2025, 11:00 AM", context),
          _buildDetailRow("Bank Account", "GTBank\n****5678", context),
          _buildDetailRow("Withdrawal Amount", "₦50,000.00", context),
          _buildDetailRow("Fee", "₦500.00", context),
          _buildDetailRow("Total Amount Sent", "₦49,500.00", context),

          const Gap(16),

          // Info Banner
          InfoWidget(
            text: "Thank you for using M-Diho!",
            theme: theme,
          ),

          const SizedBox(height: 16),

          // View Transaction Details Button
          FullButton(
            text: "View Transaction Details",
            width: double.infinity,
            height: 48,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TransactionDetailsScreen(
                            type: 'Crypto Sale',
                            status: 'Completed',
                          )));
            },
            textColor: Colors.white,
            color: AppColors.primaryColor.shade500,
          ),
          const SizedBox(height: 12),

          // Back to Dashboard
          TextButton(
            onPressed: () {
              context.router.replaceAll([const HomeRoute()]);
              Navigator.pop(context);
            },
            child: Text(
              "Back to Dashboard",
              style: TextStyle(
                fontSize: 16,
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to Create Detail Row
  Widget _buildDetailRow(String title, String value, BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                fontSize: 12,
                fontFamily: '',
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              )),
          Text(value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: '',
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              )),
        ],
      ),
    );
  }
}
