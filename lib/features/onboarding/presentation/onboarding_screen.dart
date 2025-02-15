import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/authentication/login/presentation/login_screen.dart';
import 'package:mdiho/features/authentication/registration/presentation/registration_screen.dart';

import '../../../common/app_theme.dart';
import '../../../common/res/app_colors.dart';
import '../../../common/res/assets.dart';
import '../../../common/widgets/custom_buttons.dart';

@RoutePage()
class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final currentPage = useState(0);

    // Get the current theme mode
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;

    final pages = [
      OnboardingPage(
        image: ImageAssets.onboard1,
        title: "Sell Your Crypto",
        description:
            "Convert your Bitcoin or other supported tokens to Naira in just a few taps. Enjoy the best rates and instant payments.",
        isDarkMode: isDarkMode,
      ),
      OnboardingPage(
        image: ImageAssets.onboard2,
        title: "Trade Gift Cards for Cash",
        description:
            "Got unused gift cards? Trade them for Naira at competitive rates. Support for popular brands like Amazon, Steam, and more.",
        isDarkMode: isDarkMode,
      ),
      OnboardingPage(
        image: ImageAssets.onboard3,
        title: "Pay Your Bills",
        description:
            "Top up airtime, pay for electricity, subscribe to data bundles, or renew your cable TV, all in a few taps.",
        isDarkMode: isDarkMode,
      ),
      OnboardingPage(
        image: ImageAssets.onboard4,
        imgHeight: double.infinity,
        title: "Earn Rewards",
        description:
            "Share your referral code with friends and earn rewards in Naira for every successful signup and transaction.",
        isDarkMode: isDarkMode,
      ),
    ];

    useEffect(() {
      Timer? timer = Timer.periodic(const Duration(seconds: 2), (timer) {
        if (pageController.hasClients) {
          int nextPage = (pageController.page!.toInt() + 1) % pages.length;
          pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });

      return () => timer.cancel(); // Cleanup when widget unmounts
    }, []);

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
                        ? AppColors.primaryColor.shade500
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
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Sign In",
                    style: TextStyle(),
                  ),
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
  final String image;
  final String title;
  final String description;
  final double? imgHeight;
  final double? imgWidth;
  final bool isDarkMode;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    this.imgHeight = 147,
    this.imgWidth = double.infinity,
    required this.isDarkMode, // Add isDarkMode
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.8;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Gap(44),
            Container(
              height: 360, // Adjusted for smaller screens
              width: containerWidth,
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade600
                    : const Color(0xFFFEEEE9), // Dynamic Background
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    SvgAssets.onboardSvg,
                    width: double.infinity,
                    height: double.infinity,
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : AppColors.primaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      image,
                      height: imgHeight,
                      width: containerWidth - 0.2,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(20),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: theme.brightness == Brightness.dark
                    ? [Colors.white70, Colors.white]
                    : [
                        const Color(0xFF672510),
                        const Color(0xFFCD4A20)
                      ], // Dark mode gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Gap(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                description,
                style: TextStyle(
                    fontSize: 16,
                    color: theme.brightness == Brightness.dark
                        ? AppColors.secondaryColor.shade100
                        : Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
