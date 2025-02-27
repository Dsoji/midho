import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../common/res/app_colors.dart';
import '../../../bottomNav/app_router.gr.dart';

class CryptoCard extends StatelessWidget {
  final String name;
  final String symbol;
  final String rate;
  final String img;

  const CryptoCard(
      {super.key,
      required this.name,
      required this.symbol,
      required this.rate,
      required this.img});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        context.router.push(SellCryptoRoute(
          name: name,
          symbol: symbol,
          rate: rate,
          img: img,
        ));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark
              ? AppColors.secondaryColor.shade500
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.orange,
                  backgroundImage: AssetImage(img),
                ),
                const Gap(12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    Text(
                      symbol,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.brightness == Brightness.dark
                            ? AppColors.secondaryColor.shade200
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              rate,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
