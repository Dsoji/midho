import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mdiho/features/transaction/data/model/response/rates_model/datum.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../common/res/app_colors.dart';
import '../../../bottomNav/app_router.gr.dart';

class CryptoCard extends StatelessWidget {
  final RateData rates;

  const CryptoCard({
    super.key,
    required this.rates,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        context.router.push(SellCryptoRoute(
          rates: rates,
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
                  radius: 24,
                  backgroundColor: Colors.transparent,
                  child: CachedNetworkImage(
                    imageUrl: rates.icon ?? '',
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.error,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Gap(12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rates.name ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    Text(
                      rates.symbol ?? '',
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
              '${rates.rate ?? ''}/1 USD',
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
