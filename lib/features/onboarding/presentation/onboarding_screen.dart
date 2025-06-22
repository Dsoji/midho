import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/res/assets.dart';
import '../../../common/toast/toast.dart';
import '../../../common/widgets/custom_buttons.dart';
import '../../bottomNav/app_router.gr.dart';

@RoutePage()
class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final currentPage = useState(0);
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.8;
    // Get the current theme mode
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        PermissionStatus notificationPermission =
            await Permission.notification.request();

        if (notificationPermission.isDenied) {
          // Handle denied permission (show dialog, snackbar, etc.)
        } else if (notificationPermission.isPermanentlyDenied) {
          // Show settings prompt
          // openAppSettings();
          ToastService().showToast(
            NotificationType.info,
            message:
                'Please enable notification permission from settings to receive notifications',
          );
        }
      });
      return null;
    }, []);

    final pages = [
      OnboardingPage(
        image: theme.brightness == Brightness.dark
            ? ImageAssets.donboard1
            : ImageAssets.onboard1,
        title: "Sell Your Crypto",
        description:
            "Convert your Bitcoin or other supported tokens to Naira in just a few taps. Enjoy the best rates and instant payments.",
      ),
      OnboardingPage(
        image: theme.brightness == Brightness.dark
            ? ImageAssets.donboard2
            : ImageAssets.onboard2,
        title: "Trade Gift Cards for Cash",
        description:
            "Got unused gift cards? Trade them for Naira at competitive rates. Support for popular brands like Amazon, Steam, and more.",
      ),
      OnboardingPage(
        image: theme.brightness == Brightness.dark
            ? ImageAssets.donboard3
            : ImageAssets.onboard3,
        title: "Pay Your Bills",
        description:
            "Top up airtime, pay for electricity, subscribe to data bundles, or renew your cable TV, all in a few taps.",
      ),
      OnboardingPage(
        image: theme.brightness == Brightness.dark
            ? ImageAssets.donboard4
            : ImageAssets.onboard4,
        imgHeight: double.infinity,
        title: "Earn Rewards",
        description:
            "Share your referral code with friends and earn rewards in Naira for every successful signup and transaction.",
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

    int backPressCounter = 0;
    DateTime? lastBackPressTime;
    return PopScope(
      canPop: false, // Prevent default back navigation
      onPopInvoked: (didPop) async {
        DateTime now = DateTime.now();

        // Reset counter if last press was more than 2 seconds ago
        if (lastBackPressTime == null ||
            now.difference(lastBackPressTime!) > const Duration(seconds: 2)) {
          backPressCounter = 0;
        }

        lastBackPressTime = now;
        backPressCounter++;

        if (backPressCounter < 2) {
          Fluttertoast.showToast(
            msg: "Swipe back again to exit",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0,
          );
        } else {
          Navigator.of(context).pop(); // Allow exit on second back swipe
        }
      },
      child: Scaffold(
        backgroundColor: theme.brightness == Brightness.dark
            ? AppColors.secondaryColor.shade600
            : const Color(0xFFF7F7F7),
        body: SafeArea(
          child: Column(
            children: [
              const Gap(50),
              Container(
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.secondaryColor.shade600
                      : Colors.white, // Dynamic Background
                  borderRadius: BorderRadius.circular(20),
                ),
                width: containerWidth,
                height: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                                  : theme.brightness == Brightness.dark
                                      ? AppColors.whiteColor.shade800
                                      : AppColors.whiteColor.shade600,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(20),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Column(
                  children: [
                    FullButton(
                      text: "Get Started",
                      width: double.infinity,
                      height: 48,
                      onPressed: () async {
                        final box = Hive.box('data');
                        await box.put('onboarding_seen', true);
                        context.router.push(const RegistrationRoute());
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const RegistrationScreen(),
                        //   ),
                        // );
                      },
                      textColor: Colors.white,
                      color: AppColors.primaryColor.shade500,
                    ),
                    const SizedBox(height: 10),
                    FullButton(
                      text: "Sign In",
                      width: double.infinity,
                      height: 48,
                      onPressed: () async {
                        final box = Hive.box('data');
                        await box.put('onboarding_seen', true);
                        context.router.push(const LoginRoute());
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const LoginScreen(),
                        //   ),
                        // );
                      },
                      textColor: theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      color: theme.brightness == Brightness.dark
                          ? AppColors.secondaryColor.shade400
                          : const Color(0xFFFAFAFA),
                    ),
                    const Gap(24),
                  ],
                ),
              ),
            ],
          ),
        ),
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

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    this.imgHeight = 147,
    this.imgWidth = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.8;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 300, // Adjusted for smaller screens
            width: containerWidth,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  image,
                ),
              ),
              // Dynamic Background
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const Gap(12),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : AppColors.primaryColor,
            ),
            textAlign: TextAlign.center,
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
                      : AppColors.secondaryColor.shade200),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
