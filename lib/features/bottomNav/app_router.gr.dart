// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i48;
import 'package:flutter/material.dart' as _i49;
import 'package:mdiho/features/authentication/forgot_password/presentation/forgot_password.dart'
    as _i21;
import 'package:mdiho/features/authentication/login/presentation/login_screen.dart'
    as _i26;
import 'package:mdiho/features/authentication/pin_creation/presentation/confirm_pin.dart'
    as _i12;
import 'package:mdiho/features/authentication/pin_creation/presentation/create_pin.dart'
    as _i13;
import 'package:mdiho/features/authentication/registration/presentation/registration_screen.dart'
    as _i35;
import 'package:mdiho/features/bank_network/presentation/bank_network_screen.dart'
    as _i2;
import 'package:mdiho/features/bills/presentation/betting_screen.dart' as _i3;
import 'package:mdiho/features/bills/presentation/buy_airtime.dart' as _i4;
import 'package:mdiho/features/bills/presentation/buy_data.dart' as _i5;
import 'package:mdiho/features/bills/presentation/cable_bill.dart' as _i6;
import 'package:mdiho/features/bills/presentation/electricity_bill.dart'
    as _i16;
import 'package:mdiho/features/bottomNav/mdiho_shell_screen.dart' as _i15;
import 'package:mdiho/features/bottomNav/screen/navbar.dart' as _i27;
import 'package:mdiho/features/crypto/presentation/crypto_screen.dart' as _i14;
import 'package:mdiho/features/crypto/presentation/qr_screen.dart' as _i33;
import 'package:mdiho/features/crypto/presentation/sell_crypto_screen.dart'
    as _i37;
import 'package:mdiho/features/crypto/presentation/widget/standalone_transaction_details.dart'
    as _i38;
import 'package:mdiho/features/gift_card/presentation/card_details_proof.dart'
    as _i7;
import 'package:mdiho/features/gift_card/presentation/enter_card_details_screen.dart'
    as _i19;
import 'package:mdiho/features/gift_card/presentation/gift_card_screen.dart'
    as _i22;
import 'package:mdiho/features/gift_card/presentation/gift_transaction_details.dart'
    as _i23;
import 'package:mdiho/features/home/presentation/home_screen.dart' as _i24;
import 'package:mdiho/features/notification/notification_screen.dart' as _i28;
import 'package:mdiho/features/onboarding/presentation/onboarding_screen.dart'
    as _i29;
import 'package:mdiho/features/profile/presentation/bank/add_bank.dart' as _i1;
import 'package:mdiho/features/profile/presentation/bank/bank_list.dart'
    as _i25;
import 'package:mdiho/features/profile/presentation/personal_info/change_email.dart'
    as _i8;
import 'package:mdiho/features/profile/presentation/personal_info/change_username.dart'
    as _i11;
import 'package:mdiho/features/profile/presentation/personal_info/email_verification.dart'
    as _i17;
import 'package:mdiho/features/profile/presentation/personal_info/personal_information.dart'
    as _i30;
import 'package:mdiho/features/profile/presentation/preference_scren.dart'
    as _i31;
import 'package:mdiho/features/profile/presentation/profile_screen.dart'
    as _i32;
import 'package:mdiho/features/profile/presentation/security_settings/change_password.dart'
    as _i9;
import 'package:mdiho/features/profile/presentation/security_settings/change_pin_screen.dart'
    as _i10;
import 'package:mdiho/features/profile/presentation/security_settings/email.dart'
    as _i44;
import 'package:mdiho/features/profile/presentation/security_settings/email_verify.dart'
    as _i18;
import 'package:mdiho/features/profile/presentation/security_settings/security_settings.dart'
    as _i36;
import 'package:mdiho/features/referral_screen/presentation/referall_screen.dart'
    as _i34;
import 'package:mdiho/features/referral_screen/presentation/withdrawal/withdraw_balance_screen.dart'
    as _i46;
import 'package:mdiho/features/suggestion_box/presentation/suggestion_screen.dart'
    as _i39;
import 'package:mdiho/features/support_faq/presentation/faq_screen.dart'
    as _i20;
import 'package:mdiho/features/support_faq/presentation/support_faq_screen.dart'
    as _i40;
import 'package:mdiho/features/transaction/presentation/transaction_details.dart'
    as _i41;
import 'package:mdiho/features/transaction/presentation/transaction_history.dart'
    as _i42;
import 'package:mdiho/features/withdrawal/presentation/enter_pin.dart' as _i43;
import 'package:mdiho/features/withdrawal/presentation/widget/success_dialogue.dart'
    as _i47;
import 'package:mdiho/features/withdrawal/presentation/withdraw_funds_screen.dart'
    as _i45;

/// generated route for
/// [_i1.AddNewBankScreen]
class AddNewBankRoute extends _i48.PageRouteInfo<AddNewBankRouteArgs> {
  AddNewBankRoute({
    _i49.Key? key,
    bool isverif = false,
    List<_i48.PageRouteInfo>? children,
  }) : super(
          AddNewBankRoute.name,
          args: AddNewBankRouteArgs(
            key: key,
            isverif: isverif,
          ),
          initialChildren: children,
        );

  static const String name = 'AddNewBankRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddNewBankRouteArgs>(
          orElse: () => const AddNewBankRouteArgs());
      return _i1.AddNewBankScreen(
        key: args.key,
        isverif: args.isverif,
      );
    },
  );
}

class AddNewBankRouteArgs {
  const AddNewBankRouteArgs({
    this.key,
    this.isverif = false,
  });

  final _i49.Key? key;

  final bool isverif;

  @override
  String toString() {
    return 'AddNewBankRouteArgs{key: $key, isverif: $isverif}';
  }
}

/// generated route for
/// [_i2.BankNetworkScreen]
class BankNetworkRoute extends _i48.PageRouteInfo<void> {
  const BankNetworkRoute({List<_i48.PageRouteInfo>? children})
      : super(
          BankNetworkRoute.name,
          initialChildren: children,
        );

  static const String name = 'BankNetworkRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i2.BankNetworkScreen();
    },
  );
}

/// generated route for
/// [_i3.BettingScreen]
class BettingRoute extends _i48.PageRouteInfo<void> {
  const BettingRoute({List<_i48.PageRouteInfo>? children})
      : super(
          BettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'BettingRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i3.BettingScreen();
    },
  );
}

/// generated route for
/// [_i4.BuyAirtimeScreen]
class BuyAirtimeRoute extends _i48.PageRouteInfo<void> {
  const BuyAirtimeRoute({List<_i48.PageRouteInfo>? children})
      : super(
          BuyAirtimeRoute.name,
          initialChildren: children,
        );

  static const String name = 'BuyAirtimeRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i4.BuyAirtimeScreen();
    },
  );
}

/// generated route for
/// [_i5.BuyDataScreen]
class BuyDataRoute extends _i48.PageRouteInfo<void> {
  const BuyDataRoute({List<_i48.PageRouteInfo>? children})
      : super(
          BuyDataRoute.name,
          initialChildren: children,
        );

  static const String name = 'BuyDataRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i5.BuyDataScreen();
    },
  );
}

/// generated route for
/// [_i6.CableBillScreen]
class CableBillRoute extends _i48.PageRouteInfo<void> {
  const CableBillRoute({List<_i48.PageRouteInfo>? children})
      : super(
          CableBillRoute.name,
          initialChildren: children,
        );

  static const String name = 'CableBillRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i6.CableBillScreen();
    },
  );
}

/// generated route for
/// [_i7.CardDetailsProofScreen]
class CardDetailsProofRoute
    extends _i48.PageRouteInfo<CardDetailsProofRouteArgs> {
  CardDetailsProofRoute({
    _i49.Key? key,
    required String img,
    List<_i48.PageRouteInfo>? children,
  }) : super(
          CardDetailsProofRoute.name,
          args: CardDetailsProofRouteArgs(
            key: key,
            img: img,
          ),
          initialChildren: children,
        );

  static const String name = 'CardDetailsProofRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CardDetailsProofRouteArgs>();
      return _i7.CardDetailsProofScreen(
        key: args.key,
        img: args.img,
      );
    },
  );
}

class CardDetailsProofRouteArgs {
  const CardDetailsProofRouteArgs({
    this.key,
    required this.img,
  });

  final _i49.Key? key;

  final String img;

  @override
  String toString() {
    return 'CardDetailsProofRouteArgs{key: $key, img: $img}';
  }
}

/// generated route for
/// [_i8.ChangeEmailScreen]
class ChangeEmailRoute extends _i48.PageRouteInfo<void> {
  const ChangeEmailRoute({List<_i48.PageRouteInfo>? children})
      : super(
          ChangeEmailRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangeEmailRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i8.ChangeEmailScreen();
    },
  );
}

/// generated route for
/// [_i9.ChangePasswordScreen]
class ChangePasswordRoute extends _i48.PageRouteInfo<void> {
  const ChangePasswordRoute({List<_i48.PageRouteInfo>? children})
      : super(
          ChangePasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangePasswordRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i9.ChangePasswordScreen();
    },
  );
}

/// generated route for
/// [_i10.ChangePinScreen]
class ChangePinRoute extends _i48.PageRouteInfo<void> {
  const ChangePinRoute({List<_i48.PageRouteInfo>? children})
      : super(
          ChangePinRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangePinRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i10.ChangePinScreen();
    },
  );
}

/// generated route for
/// [_i11.ChangeUsernameScreen]
class ChangeUsernameRoute extends _i48.PageRouteInfo<void> {
  const ChangeUsernameRoute({List<_i48.PageRouteInfo>? children})
      : super(
          ChangeUsernameRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangeUsernameRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i11.ChangeUsernameScreen();
    },
  );
}

/// generated route for
/// [_i12.ConfirmPinScreen]
class ConfirmPinRoute extends _i48.PageRouteInfo<void> {
  const ConfirmPinRoute({List<_i48.PageRouteInfo>? children})
      : super(
          ConfirmPinRoute.name,
          initialChildren: children,
        );

  static const String name = 'ConfirmPinRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i12.ConfirmPinScreen();
    },
  );
}

/// generated route for
/// [_i13.CreatePinScreen]
class CreatePinRoute extends _i48.PageRouteInfo<void> {
  const CreatePinRoute({List<_i48.PageRouteInfo>? children})
      : super(
          CreatePinRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreatePinRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i13.CreatePinScreen();
    },
  );
}

/// generated route for
/// [_i14.CryptoScreen]
class CryptoRoute extends _i48.PageRouteInfo<void> {
  const CryptoRoute({List<_i48.PageRouteInfo>? children})
      : super(
          CryptoRoute.name,
          initialChildren: children,
        );

  static const String name = 'CryptoRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i14.CryptoScreen();
    },
  );
}

/// generated route for
/// [_i15.CryptoShellScreen]
class CryptoShellRoute extends _i48.PageRouteInfo<void> {
  const CryptoShellRoute({List<_i48.PageRouteInfo>? children})
      : super(
          CryptoShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'CryptoShellRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i15.CryptoShellScreen();
    },
  );
}

/// generated route for
/// [_i16.ElectricityBillScreen]
class ElectricityBillRoute extends _i48.PageRouteInfo<void> {
  const ElectricityBillRoute({List<_i48.PageRouteInfo>? children})
      : super(
          ElectricityBillRoute.name,
          initialChildren: children,
        );

  static const String name = 'ElectricityBillRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i16.ElectricityBillScreen();
    },
  );
}

/// generated route for
/// [_i17.EmailVerificationScreen]
class EmailVerificationRoute extends _i48.PageRouteInfo<void> {
  const EmailVerificationRoute({List<_i48.PageRouteInfo>? children})
      : super(
          EmailVerificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'EmailVerificationRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i17.EmailVerificationScreen();
    },
  );
}

/// generated route for
/// [_i18.EmailVerifyScreen]
class EmailVerifyRoute extends _i48.PageRouteInfo<EmailVerifyRouteArgs> {
  EmailVerifyRoute({
    _i49.Key? key,
    required String type,
    List<_i48.PageRouteInfo>? children,
  }) : super(
          EmailVerifyRoute.name,
          args: EmailVerifyRouteArgs(
            key: key,
            type: type,
          ),
          initialChildren: children,
        );

  static const String name = 'EmailVerifyRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EmailVerifyRouteArgs>();
      return _i18.EmailVerifyScreen(
        key: args.key,
        type: args.type,
      );
    },
  );
}

class EmailVerifyRouteArgs {
  const EmailVerifyRouteArgs({
    this.key,
    required this.type,
  });

  final _i49.Key? key;

  final String type;

  @override
  String toString() {
    return 'EmailVerifyRouteArgs{key: $key, type: $type}';
  }
}

/// generated route for
/// [_i19.EnterCardDetailsScreen]
class EnterCardDetailsRoute
    extends _i48.PageRouteInfo<EnterCardDetailsRouteArgs> {
  EnterCardDetailsRoute({
    _i49.Key? key,
    required _i22.GiftCard giftCard,
    List<_i48.PageRouteInfo>? children,
  }) : super(
          EnterCardDetailsRoute.name,
          args: EnterCardDetailsRouteArgs(
            key: key,
            giftCard: giftCard,
          ),
          initialChildren: children,
        );

  static const String name = 'EnterCardDetailsRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EnterCardDetailsRouteArgs>();
      return _i19.EnterCardDetailsScreen(
        key: args.key,
        giftCard: args.giftCard,
      );
    },
  );
}

class EnterCardDetailsRouteArgs {
  const EnterCardDetailsRouteArgs({
    this.key,
    required this.giftCard,
  });

  final _i49.Key? key;

  final _i22.GiftCard giftCard;

  @override
  String toString() {
    return 'EnterCardDetailsRouteArgs{key: $key, giftCard: $giftCard}';
  }
}

/// generated route for
/// [_i20.FaqScreen]
class FaqRoute extends _i48.PageRouteInfo<void> {
  const FaqRoute({List<_i48.PageRouteInfo>? children})
      : super(
          FaqRoute.name,
          initialChildren: children,
        );

  static const String name = 'FaqRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i20.FaqScreen();
    },
  );
}

/// generated route for
/// [_i21.ForgotPasswordScreen]
class ForgotPasswordRoute extends _i48.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i48.PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i21.ForgotPasswordScreen();
    },
  );
}

/// generated route for
/// [_i22.GiftCardScreen]
class GiftCardRoute extends _i48.PageRouteInfo<void> {
  const GiftCardRoute({List<_i48.PageRouteInfo>? children})
      : super(
          GiftCardRoute.name,
          initialChildren: children,
        );

  static const String name = 'GiftCardRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i22.GiftCardScreen();
    },
  );
}

/// generated route for
/// [_i15.GiftCardShellScreen]
class GiftCardShellRoute extends _i48.PageRouteInfo<void> {
  const GiftCardShellRoute({List<_i48.PageRouteInfo>? children})
      : super(
          GiftCardShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'GiftCardShellRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i15.GiftCardShellScreen();
    },
  );
}

/// generated route for
/// [_i23.GiftTransactionDetailsScreen]
class GiftTransactionDetailsRoute
    extends _i48.PageRouteInfo<GiftTransactionDetailsRouteArgs> {
  GiftTransactionDetailsRoute({
    _i49.Key? key,
    required String type,
    required String status,
    bool? showAppBar = true,
    List<_i48.PageRouteInfo>? children,
  }) : super(
          GiftTransactionDetailsRoute.name,
          args: GiftTransactionDetailsRouteArgs(
            key: key,
            type: type,
            status: status,
            showAppBar: showAppBar,
          ),
          initialChildren: children,
        );

  static const String name = 'GiftTransactionDetailsRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GiftTransactionDetailsRouteArgs>();
      return _i23.GiftTransactionDetailsScreen(
        key: args.key,
        type: args.type,
        status: args.status,
        showAppBar: args.showAppBar,
      );
    },
  );
}

class GiftTransactionDetailsRouteArgs {
  const GiftTransactionDetailsRouteArgs({
    this.key,
    required this.type,
    required this.status,
    this.showAppBar = true,
  });

  final _i49.Key? key;

  final String type;

  final String status;

  final bool? showAppBar;

  @override
  String toString() {
    return 'GiftTransactionDetailsRouteArgs{key: $key, type: $type, status: $status, showAppBar: $showAppBar}';
  }
}

/// generated route for
/// [_i24.HomeScreen]
class HomeRoute extends _i48.PageRouteInfo<void> {
  const HomeRoute({List<_i48.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i24.HomeScreen();
    },
  );
}

/// generated route for
/// [_i15.HomeShellScreen]
class HomeShellRoute extends _i48.PageRouteInfo<void> {
  const HomeShellRoute({List<_i48.PageRouteInfo>? children})
      : super(
          HomeShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeShellRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i15.HomeShellScreen();
    },
  );
}

/// generated route for
/// [_i25.LinkedBanksScreen]
class LinkedBanksRoute extends _i48.PageRouteInfo<void> {
  const LinkedBanksRoute({List<_i48.PageRouteInfo>? children})
      : super(
          LinkedBanksRoute.name,
          initialChildren: children,
        );

  static const String name = 'LinkedBanksRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i25.LinkedBanksScreen();
    },
  );
}

/// generated route for
/// [_i26.LoginScreen]
class LoginRoute extends _i48.PageRouteInfo<void> {
  const LoginRoute({List<_i48.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i26.LoginScreen();
    },
  );
}

/// generated route for
/// [_i15.MdihoShellScreen]
class MdihoShellRoute extends _i48.PageRouteInfo<void> {
  const MdihoShellRoute({List<_i48.PageRouteInfo>? children})
      : super(
          MdihoShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'MdihoShellRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i15.MdihoShellScreen();
    },
  );
}

/// generated route for
/// [_i27.NaviBarScreen]
class NaviBarRoute extends _i48.PageRouteInfo<void> {
  const NaviBarRoute({List<_i48.PageRouteInfo>? children})
      : super(
          NaviBarRoute.name,
          initialChildren: children,
        );

  static const String name = 'NaviBarRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i27.NaviBarScreen();
    },
  );
}

/// generated route for
/// [_i28.NotificationScreen]
class NotificationRoute extends _i48.PageRouteInfo<void> {
  const NotificationRoute({List<_i48.PageRouteInfo>? children})
      : super(
          NotificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i28.NotificationScreen();
    },
  );
}

/// generated route for
/// [_i29.OnboardingScreen]
class OnboardingRoute extends _i48.PageRouteInfo<void> {
  const OnboardingRoute({List<_i48.PageRouteInfo>? children})
      : super(
          OnboardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i29.OnboardingScreen();
    },
  );
}

/// generated route for
/// [_i30.PersonalInfoScreen]
class PersonalInfoRoute extends _i48.PageRouteInfo<void> {
  const PersonalInfoRoute({List<_i48.PageRouteInfo>? children})
      : super(
          PersonalInfoRoute.name,
          initialChildren: children,
        );

  static const String name = 'PersonalInfoRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i30.PersonalInfoScreen();
    },
  );
}

/// generated route for
/// [_i31.PreferenceScreen]
class PreferenceRoute extends _i48.PageRouteInfo<void> {
  const PreferenceRoute({List<_i48.PageRouteInfo>? children})
      : super(
          PreferenceRoute.name,
          initialChildren: children,
        );

  static const String name = 'PreferenceRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i31.PreferenceScreen();
    },
  );
}

/// generated route for
/// [_i32.ProfileScreen]
class ProfileRoute extends _i48.PageRouteInfo<void> {
  const ProfileRoute({List<_i48.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i32.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i15.ProfileShellScreen]
class ProfileShellRoute extends _i48.PageRouteInfo<void> {
  const ProfileShellRoute({List<_i48.PageRouteInfo>? children})
      : super(
          ProfileShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileShellRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i15.ProfileShellScreen();
    },
  );
}

/// generated route for
/// [_i33.QrCryptoScreen]
class QrCryptoRoute extends _i48.PageRouteInfo<void> {
  const QrCryptoRoute({List<_i48.PageRouteInfo>? children})
      : super(
          QrCryptoRoute.name,
          initialChildren: children,
        );

  static const String name = 'QrCryptoRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i33.QrCryptoScreen();
    },
  );
}

/// generated route for
/// [_i34.ReferallScreen]
class ReferallRoute extends _i48.PageRouteInfo<void> {
  const ReferallRoute({List<_i48.PageRouteInfo>? children})
      : super(
          ReferallRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReferallRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i34.ReferallScreen();
    },
  );
}

/// generated route for
/// [_i35.RegistrationScreen]
class RegistrationRoute extends _i48.PageRouteInfo<void> {
  const RegistrationRoute({List<_i48.PageRouteInfo>? children})
      : super(
          RegistrationRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegistrationRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i35.RegistrationScreen();
    },
  );
}

/// generated route for
/// [_i36.SecurtiySettingsScreen]
class SecurtiySettingsRoute extends _i48.PageRouteInfo<void> {
  const SecurtiySettingsRoute({List<_i48.PageRouteInfo>? children})
      : super(
          SecurtiySettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SecurtiySettingsRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i36.SecurtiySettingsScreen();
    },
  );
}

/// generated route for
/// [_i37.SellCryptoScreen]
class SellCryptoRoute extends _i48.PageRouteInfo<SellCryptoRouteArgs> {
  SellCryptoRoute({
    _i49.Key? key,
    required String name,
    required String symbol,
    required String rate,
    required String img,
    List<_i48.PageRouteInfo>? children,
  }) : super(
          SellCryptoRoute.name,
          args: SellCryptoRouteArgs(
            key: key,
            name: name,
            symbol: symbol,
            rate: rate,
            img: img,
          ),
          initialChildren: children,
        );

  static const String name = 'SellCryptoRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SellCryptoRouteArgs>();
      return _i37.SellCryptoScreen(
        key: args.key,
        name: args.name,
        symbol: args.symbol,
        rate: args.rate,
        img: args.img,
      );
    },
  );
}

class SellCryptoRouteArgs {
  const SellCryptoRouteArgs({
    this.key,
    required this.name,
    required this.symbol,
    required this.rate,
    required this.img,
  });

  final _i49.Key? key;

  final String name;

  final String symbol;

  final String rate;

  final String img;

  @override
  String toString() {
    return 'SellCryptoRouteArgs{key: $key, name: $name, symbol: $symbol, rate: $rate, img: $img}';
  }
}

/// generated route for
/// [_i38.StandAloneTransactionDetailsScreen]
class StandAloneTransactionDetailsRoute
    extends _i48.PageRouteInfo<StandAloneTransactionDetailsRouteArgs> {
  StandAloneTransactionDetailsRoute({
    _i49.Key? key,
    required String type,
    required String status,
    List<_i48.PageRouteInfo>? children,
  }) : super(
          StandAloneTransactionDetailsRoute.name,
          args: StandAloneTransactionDetailsRouteArgs(
            key: key,
            type: type,
            status: status,
          ),
          initialChildren: children,
        );

  static const String name = 'StandAloneTransactionDetailsRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<StandAloneTransactionDetailsRouteArgs>();
      return _i38.StandAloneTransactionDetailsScreen(
        key: args.key,
        type: args.type,
        status: args.status,
      );
    },
  );
}

class StandAloneTransactionDetailsRouteArgs {
  const StandAloneTransactionDetailsRouteArgs({
    this.key,
    required this.type,
    required this.status,
  });

  final _i49.Key? key;

  final String type;

  final String status;

  @override
  String toString() {
    return 'StandAloneTransactionDetailsRouteArgs{key: $key, type: $type, status: $status}';
  }
}

/// generated route for
/// [_i39.SuggestionScreen]
class SuggestionRoute extends _i48.PageRouteInfo<void> {
  const SuggestionRoute({List<_i48.PageRouteInfo>? children})
      : super(
          SuggestionRoute.name,
          initialChildren: children,
        );

  static const String name = 'SuggestionRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i39.SuggestionScreen();
    },
  );
}

/// generated route for
/// [_i40.SupportFaqScreen]
class SupportFaqRoute extends _i48.PageRouteInfo<void> {
  const SupportFaqRoute({List<_i48.PageRouteInfo>? children})
      : super(
          SupportFaqRoute.name,
          initialChildren: children,
        );

  static const String name = 'SupportFaqRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i40.SupportFaqScreen();
    },
  );
}

/// generated route for
/// [_i41.TransactionDetailsScreen]
class TransactionDetailsRoute
    extends _i48.PageRouteInfo<TransactionDetailsRouteArgs> {
  TransactionDetailsRoute({
    _i49.Key? key,
    required String type,
    required String status,
    bool? showAppBar = true,
    List<_i48.PageRouteInfo>? children,
  }) : super(
          TransactionDetailsRoute.name,
          args: TransactionDetailsRouteArgs(
            key: key,
            type: type,
            status: status,
            showAppBar: showAppBar,
          ),
          initialChildren: children,
        );

  static const String name = 'TransactionDetailsRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TransactionDetailsRouteArgs>();
      return _i41.TransactionDetailsScreen(
        key: args.key,
        type: args.type,
        status: args.status,
        showAppBar: args.showAppBar,
      );
    },
  );
}

class TransactionDetailsRouteArgs {
  const TransactionDetailsRouteArgs({
    this.key,
    required this.type,
    required this.status,
    this.showAppBar = true,
  });

  final _i49.Key? key;

  final String type;

  final String status;

  final bool? showAppBar;

  @override
  String toString() {
    return 'TransactionDetailsRouteArgs{key: $key, type: $type, status: $status, showAppBar: $showAppBar}';
  }
}

/// generated route for
/// [_i42.TransactionHistoryScreen]
class TransactionHistoryRoute extends _i48.PageRouteInfo<void> {
  const TransactionHistoryRoute({List<_i48.PageRouteInfo>? children})
      : super(
          TransactionHistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'TransactionHistoryRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i42.TransactionHistoryScreen();
    },
  );
}

/// generated route for
/// [_i43.TransactionPinScreen]
class TransactionPinRoute extends _i48.PageRouteInfo<TransactionPinRouteArgs> {
  TransactionPinRoute({
    _i49.Key? key,
    required bool isHome,
    List<_i48.PageRouteInfo>? children,
  }) : super(
          TransactionPinRoute.name,
          args: TransactionPinRouteArgs(
            key: key,
            isHome: isHome,
          ),
          initialChildren: children,
        );

  static const String name = 'TransactionPinRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TransactionPinRouteArgs>();
      return _i43.TransactionPinScreen(
        key: args.key,
        isHome: args.isHome,
      );
    },
  );
}

class TransactionPinRouteArgs {
  const TransactionPinRouteArgs({
    this.key,
    required this.isHome,
  });

  final _i49.Key? key;

  final bool isHome;

  @override
  String toString() {
    return 'TransactionPinRouteArgs{key: $key, isHome: $isHome}';
  }
}

/// generated route for
/// [_i15.TransactionShellScreen]
class TransactionShellRoute extends _i48.PageRouteInfo<void> {
  const TransactionShellRoute({List<_i48.PageRouteInfo>? children})
      : super(
          TransactionShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'TransactionShellRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i15.TransactionShellScreen();
    },
  );
}

/// generated route for
/// [_i44.VerifyEmailScreen]
class VerifyEmailRoute extends _i48.PageRouteInfo<VerifyEmailRouteArgs> {
  VerifyEmailRoute({
    _i49.Key? key,
    required String type,
    List<_i48.PageRouteInfo>? children,
  }) : super(
          VerifyEmailRoute.name,
          args: VerifyEmailRouteArgs(
            key: key,
            type: type,
          ),
          initialChildren: children,
        );

  static const String name = 'VerifyEmailRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VerifyEmailRouteArgs>();
      return _i44.VerifyEmailScreen(
        key: args.key,
        type: args.type,
      );
    },
  );
}

class VerifyEmailRouteArgs {
  const VerifyEmailRouteArgs({
    this.key,
    required this.type,
  });

  final _i49.Key? key;

  final String type;

  @override
  String toString() {
    return 'VerifyEmailRouteArgs{key: $key, type: $type}';
  }
}

/// generated route for
/// [_i45.WithdrawFundsScreen]
class WithdrawFundsRoute extends _i48.PageRouteInfo<void> {
  const WithdrawFundsRoute({List<_i48.PageRouteInfo>? children})
      : super(
          WithdrawFundsRoute.name,
          initialChildren: children,
        );

  static const String name = 'WithdrawFundsRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i45.WithdrawFundsScreen();
    },
  );
}

/// generated route for
/// [_i46.WithdrawReferallScreen]
class WithdrawReferallRoute extends _i48.PageRouteInfo<void> {
  const WithdrawReferallRoute({List<_i48.PageRouteInfo>? children})
      : super(
          WithdrawReferallRoute.name,
          initialChildren: children,
        );

  static const String name = 'WithdrawReferallRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i46.WithdrawReferallScreen();
    },
  );
}

/// generated route for
/// [_i47.WithdrawalSuccessDialogScreen]
class WithdrawalSuccessDialogRoute
    extends _i48.PageRouteInfo<WithdrawalSuccessDialogRouteArgs> {
  WithdrawalSuccessDialogRoute({
    _i49.Key? key,
    bool? isHome,
    List<_i48.PageRouteInfo>? children,
  }) : super(
          WithdrawalSuccessDialogRoute.name,
          args: WithdrawalSuccessDialogRouteArgs(
            key: key,
            isHome: isHome,
          ),
          initialChildren: children,
        );

  static const String name = 'WithdrawalSuccessDialogRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WithdrawalSuccessDialogRouteArgs>(
          orElse: () => const WithdrawalSuccessDialogRouteArgs());
      return _i47.WithdrawalSuccessDialogScreen(
        key: args.key,
        isHome: args.isHome,
      );
    },
  );
}

class WithdrawalSuccessDialogRouteArgs {
  const WithdrawalSuccessDialogRouteArgs({
    this.key,
    this.isHome,
  });

  final _i49.Key? key;

  final bool? isHome;

  @override
  String toString() {
    return 'WithdrawalSuccessDialogRouteArgs{key: $key, isHome: $isHome}';
  }
}
