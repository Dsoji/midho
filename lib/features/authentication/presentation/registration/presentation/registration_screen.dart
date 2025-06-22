import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:mdiho/features/authentication/presentation/registration/presentation/widget/step_progress_indicator.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';

import 'widget/email_password_step.dart';
import 'widget/otp_verification_step.dart';
import 'widget/user_details_screen.dart';

final pageControllerProvider = Provider<PageController>((ref) {
  return PageController();
});

final registrationProvider =
    StateNotifierProvider<RegistrationNotifier, RegistrationState>(
  (ref) => RegistrationNotifier(),
);

class RegistrationNotifier extends StateNotifier<RegistrationState> {
  RegistrationNotifier() : super(RegistrationState());

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void updateOtp(String otp) {
    state = state.copyWith(otp: otp);
  }

  void updateUserDetails(
      String firstName, String lastName, String country, String phone) {
    state = state.copyWith(
        firstName: firstName,
        lastName: lastName,
        country: country,
        phone: phone);
  }
}

class RegistrationState {
  final String email;
  final String password;
  final String otp;
  final String firstName;
  final String lastName;
  final String country;
  final String phone;

  RegistrationState({
    this.email = '',
    this.password = '',
    this.otp = '',
    this.firstName = '',
    this.lastName = '',
    this.country = 'Nigeria',
    this.phone = '',
  });

  RegistrationState copyWith({
    String? email,
    String? password,
    String? otp,
    String? firstName,
    String? lastName,
    String? country,
    String? phone,
  }) {
    return RegistrationState(
      email: email ?? this.email,
      password: password ?? this.password,
      otp: otp ?? this.otp,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      country: country ?? this.country,
      phone: phone ?? this.phone,
    );
  }
}

@RoutePage()
class RegistrationScreen extends HookConsumerWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(pageControllerProvider);
    final pageIndex = useState(0);

    useState(false);
    void goBack() {
      if (pageIndex.value == 2) {
        // If on page 2, always go back to page 0
        pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else if (pageIndex.value > 0) {
        // Otherwise, go to the previous page normally
        pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else if (pageIndex.value == 0) {
        context.router.replaceAll([const OnboardingRoute()]);
      }
    }

    final theme = Theme.of(context);
    return PopScope(
      canPop: pageIndex.value == 0, // Prevents popping when not on first page
      onPopInvoked: (didPop) {
        if (!didPop && pageIndex.value > 0) {
          goBack();
        } else if (!didPop && pageIndex.value > 0) {
          context.router.replaceAll([const OnboardingRoute()]);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: StepProgressIndicator(
            currentStep: pageIndex.value + 1,
            totalSteps: 3,
            onBack: goBack,
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: PageView(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) => pageIndex.value = index,
                  children: [
                    EmailPasswordStep(
                      // isLoading: ref
                      //     .watch(authenticationControllerProvider)
                      //     .emailVerification
                      //     .isLoading,
                      onNext: () {
                        pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      },
                    ),
                    OtpVerificationStep(
                        // isLoading: ref
                        //     .watch(authenticationControllerProvider)
                        //     .emailConfirmation
                        //     .isLoading,
                        onNext: () => pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut)),
                    UserDetailsStep(
                      onFinish: () {},
                    ),
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

final logger = Logger();
