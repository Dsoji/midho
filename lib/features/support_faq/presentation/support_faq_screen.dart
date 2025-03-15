import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/common/res/assets.dart';
import 'package:mdiho/features/support_faq/presentation/faq_screen.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';

@RoutePage()
class SupportFaqScreen extends HookConsumerWidget {
  const SupportFaqScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Support & FAQ ",
        showBackButton: true,
        showTitle: true,
        showAction: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "How can we help you today?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Gap(4),
            const Text(
              "Find answers to common questions or reach out to our support team.",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Gap(16),
            const Text(
              "Contact Support",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(16),
            Container(
              decoration: ShapeDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade500
                    : AppColors.whiteColor.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SupportTile(
                    title: "Live Chat",
                    trailing: Image.asset(
                      PlaceholderAssets.whatsapp,
                      height: 18,
                    ),
                    onTap: () {},
                  ),
                  SupportTile(
                    title: "Email Support",
                    subtitle: "support@m-diho.com",
                    trailing: const Icon(
                      IconsaxPlusLinear.sms,
                      size: 18,
                    ),
                    onTap: () async {
                      final Uri emailUri =
                          Uri(scheme: 'mailto', path: 'support@m-diho.com');
                      if (await canLaunchUrl(emailUri)) {
                        await launchUrl(emailUri);
                      }
                    },
                  ),
                  SupportTile(
                    title: "Call Support",
                    subtitle: "+234 800 123 4567",
                    trailing: const Icon(
                      IconsaxPlusLinear.call,
                      size: 18,
                    ),
                    onTap: () async {
                      final Uri url = Uri.parse("tel:+2348001234567");
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                  ),
                  SupportTile(
                    title: "Frequently Asked Questions (FAQ)",
                    trailing: const Icon(
                      IconsaxPlusLinear.arrow_right_3,
                      size: 18,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FaqScreen(),
                        ),
                      );
                    },
                  ),
                  const Gap(10),
                  InfoWidget(
                      theme: theme,
                      text:
                          'Our support team is currently offline. Please send us an email or check the FAQ section.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SupportTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  const SupportTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: AppColors.whiteColor.shade500,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        subtitle: subtitle != null
            ? Text(subtitle!, style: TextStyle(color: Colors.grey.shade600))
            : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
