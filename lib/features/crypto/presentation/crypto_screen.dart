import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/home/presentation/widget/kyc_card.dart';
import 'package:mdiho/features/transaction/data/controller/transaction_controller.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../authentication/data/controller/authentication_controller.dart';
import '../../kyc/presentation/verification_method.dart';
import '../../kyc/presentation/widget/kyc_dialog.dart';
import 'widget/crypto_card_widget.dart';

@RoutePage()
class CryptoScreen extends HookConsumerWidget {
  const CryptoScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionControllerProvider).rates;
    final theme = Theme.of(context);

    final userAsync = ref.watch(authenticationControllerProvider).userDetails;
    final kycStatus = userAsync.maybeWhen(
      data: (user) => user.kyc,
      orElse: () => null,
    );
    final enforceKyc = userAsync.maybeWhen(
      data: (user) => user.enforceKyc,
      orElse: () => null,
    );

    // Track if dialog has been shown to prevent duplicates
    final dialogShown = useRef(false);
    final contextRef = useRef<BuildContext?>(null);
    final shouldShowDialog = kycStatus == false && enforceKyc == true;

    // Store context ref during build (safe to do)
    contextRef.value = context;

    // Show dialog every time screen is displayed
    useEffect(() {
      if (!shouldShowDialog) {
        dialogShown.value = false;
        return null;
      }

      // Show dialog after frame is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final currentContext = contextRef.value;
        if (currentContext != null &&
            currentContext.mounted &&
            ModalRoute.of(currentContext)?.isCurrent == true &&
            !dialogShown.value) {
          dialogShown.value = true;
          showDialog(
            context: currentContext,
            barrierDismissible: false,
            builder: (dialogContext) => KycDialog(
              isDismissible: false,
              onCompleteKyc: () {
                dialogShown.value = false; // Reset when dialog is closed
                Navigator.push(
                  dialogContext,
                  MaterialPageRoute(
                    builder: (navContext) => const VerificationMethodScreen(),
                  ),
                );
              },
            ),
          );
        }
      });

      return null;
    }, [shouldShowDialog]);
    return PopScope(
      canPop: false, // Prevent default back navigation
      onPopInvoked: (didPop) {
        if (!didPop) {
          final tabsRouter = AutoTabsRouter.of(
            context,
          );

          tabsRouter.setActiveIndex(0);
        }
      },

      child: Scaffold(
        appBar: CustomAppBar(
          title: "Select Crypto To Sell",
          showBackButton: false,
          showTitle: true,
          showAction: false,
          bckgrndColor: theme.brightness == Brightness.dark
              ? const Color(0xFF151515)
              : AppColors.whiteColor.shade100,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            ref.read(transactionControllerProvider.notifier).getRates();
            return Future.delayed(const Duration(seconds: 1));
          },
          child: state.when(
            loading: () => state.maybeWhen(
              data: (rates) {
                final cryptoRates =
                    rates.data!.where((rate) => rate.type == "CRYPTO").toList();
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cryptoRates.length,
                  separatorBuilder: (context, index) => const Gap(8),
                  itemBuilder: (context, index) {
                    final data = cryptoRates[index];
                    return CryptoCard(rates: data);
                  },
                );
              },
              orElse: () {
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: 6,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, __) => const CryptoCardShimmer(),
                );
              },
            ),
            error: (error, _) => state.maybeWhen(
              data: (rates) {
                final cryptoRates =
                    rates.data!.where((rate) => rate.type == "CRYPTO").toList();
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cryptoRates.length,
                  separatorBuilder: (context, index) => const Gap(8),
                  itemBuilder: (context, index) {
                    final data = cryptoRates[index];
                    return CryptoCard(rates: data);
                  },
                );
              },
              orElse: () => Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Gap(52),
                      const Icon(Icons.info_outline,
                          color: Colors.grey, size: 48),
                      const SizedBox(height: 8),
                      Text(
                        "Failed to load available crypto.",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            data: (rates) {
              final cryptoRates =
                  rates.data!.where((rate) => rate.type == "CRYPTO").toList();
              if (cryptoRates.isEmpty) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CompletedKycCard(radiues: 0),
                      const Gap(52),
                      const Icon(Icons.info_outline,
                          color: Colors.grey, size: 48),
                      const SizedBox(height: 8),
                      Text(
                        "No crypto available.",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  if (kycStatus == false) const CompletedKycCard(radiues: 0),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: cryptoRates.length,
                      separatorBuilder: (context, index) => const Gap(8),
                      itemBuilder: (context, index) {
                        final data = cryptoRates[index];
                        return CryptoCard(rates: data);
                      },
                    ),
                  ),
                  const Gap(90),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class CryptoCardShimmer extends StatelessWidget {
  const CryptoCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primaryColor.shade50,
      highlightColor: AppColors.primaryColor.shade100,
      child: Container(
        height: 80,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
