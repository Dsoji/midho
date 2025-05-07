import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/common/extension/string/string_extension.dart';
import 'package:mdiho/common/utils/date_utils.dart';
import 'package:mdiho/features/transaction/data/model/response/transaction_history/datum.dart';

import '../../../../common/res/app_colors.dart';
import '../transaction_details.dart';

class TransactionCard extends StatelessWidget {
  final TransactionData transactions;

  const TransactionCard({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionDetailsScreen(
              transaction: transactions,
              status: transactions.status ?? 'Unknown',
              type: transactions.type ?? '',
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark
              ? AppColors.secondaryColor.shade500
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Transaction Icon with Background
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: theme.brightness == Brightness.dark
                          ? AppColors.secondaryColor.shade700
                          : AppColors.whiteColor.shade500,
                      child: Icon(
                          (transactions.type == 'GIFTCARDSALE' ||
                                  transactions.type == 'CRYPTOSALE')
                              ? IconsaxPlusLinear.arrow_down_1
                              : IconsaxPlusLinear.arrow_up,
                          size: 18),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: theme.brightness == Brightness.dark
                            ? AppColors.secondaryColor.shade400
                            : const Color(0xFFFEEEE9),
                        child: Icon(IconsaxPlusLinear.bitcoin_convert,
                            color: theme.brightness == Brightness.dark
                                ? AppColors.whiteColor
                                : AppColors.primaryColor.shade500,
                            size: 8.11),
                      ),
                    ),
                  ],
                ),
                const Gap(7),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transactions.type ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.brightness == Brightness.dark
                            ? AppColors.whiteColor
                            : Colors.black,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      transactions.createdAt!.getFormattedDate(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Amount and Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${transactions.exchangeCurrency} ${(transactions.amount ?? 0) * (transactions.rate ?? 0) - (transactions.fee ?? 0)}"
                      .commaFormat(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.brightness == Brightness.dark
                        ? AppColors.whiteColor
                        : Colors.black,
                    fontFamily: '',
                  ),
                ),
                const Gap(4),
                Text(
                  transactions.status ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 12,
                    color: transactions.status!.toLowerCase() == 'pending'
                        ? Colors.orange
                        : transactions.status!.toLowerCase() == 'completed'
                            ? Colors.green
                            : transactions.status!.toLowerCase() == 'failed'
                                ? Colors.red
                                : Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
