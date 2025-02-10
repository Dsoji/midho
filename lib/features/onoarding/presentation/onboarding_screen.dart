import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:mdiho/features/authentication/registration/presentation/registration_screen.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_buttons.dart';

@RoutePage()
class OnboardingScreen extends HookWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    final currentPage = useState(0);

    final pages = [
      const OnboardingPage(
        image: Icons.currency_bitcoin,
        title: "Sell Your Crypto",
        description:
            "Convert your Bitcoin or other supported tokens to Naira in just a few taps. Enjoy the best rates and instant payments.",
      ),
      const OnboardingPage(
        image: Icons.currency_exchange,
        title: "Trade Gift Cards for Cash",
        description:
            "Got unused gift cards? Trade them for Naira at competitive rates. Support for popular brands like Amazon, Steam, and more.",
      ),
      const OnboardingPage(
        image: Icons.currency_bitcoin,
        title: "Pay Your Bills",
        description:
            "Top up airtime, pay for electricity, subscribe to data bundles, or renew your cable TV, all in a few taps.",
      ),
      const OnboardingPage(
        image: Icons.currency_bitcoin,
        title: "Earn Rewards",
        description:
            "Share your referral code with friends and earn rewards in Naira for every successful signup and transaction.",
      ),
    ];

    return Scaffold(
      body: Column(
        children: [
          const Gap(100),
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: pages.length,
              onPageChanged: (index) => currentPage.value = index,
              itemBuilder: (context, index) => pages[index],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: currentPage.value == index ? 28.0 : 11.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    color: currentPage.value == index
                        ? Colors.orange
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
            ),
          ),
          const Gap(50),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              children: [
                FullButton(
                  text: "Get Started",
                  width: double.infinity,
                  height: 48,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegistrationScreen(),
                      ),
                    );
                  },
                  textColor: Colors.white,
                  color: AppColors.primaryColor.shade500,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {},
                  child: const Text("Sign In",
                      style: TextStyle(color: Colors.black54)),
                ),
                const Gap(24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final IconData image;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // <-- Wrap Column inside SingleChildScrollView
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Gap(44),
            Container(
              height: 300, // Reduced height to fit smaller screens
              width: 300, // Reduced width to maintain proportions
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(30),
              child: Icon(image, size: 80, color: Colors.orange),
            ),
            const Gap(20),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Gap(10),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16), // Add padding
              child: Text(
                description,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
