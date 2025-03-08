// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i38;
import 'package:flutter/material.dart' as _i39;
import 'package:mdiho/features/authentication/forgot_password/presentation/forgot_password.dart'
    as _i17;
import 'package:mdiho/features/authentication/login/presentation/login_screen.dart'
    as _i22;
import 'package:mdiho/features/authentication/pin_creation/presentation/confirm_pin.dart'
    as _i10;
import 'package:mdiho/features/authentication/pin_creation/presentation/create_pin.dart'
    as _i11;
import 'package:mdiho/features/authentication/registration/presentation/registration_screen.dart'
    as _i29;
import 'package:mdiho/features/bills/presentation/betting_screen.dart' as _i2;
import 'package:mdiho/features/bills/presentation/buy_airtime.dart' as _i3;
import 'package:mdiho/features/bills/presentation/buy_data.dart' as _i4;
import 'package:mdiho/features/bills/presentation/cable_bill.dart' as _i5;
import 'package:mdiho/features/bills/presentation/electricity_bill.dart'
    as _i14;
import 'package:mdiho/features/bottomNav/mdiho_shell_screen.dart' as _i13;
import 'package:mdiho/features/bottomNav/screen/navbar.dart' as _i23;
import 'package:mdiho/features/crypto/presentation/crypto_screen.dart' as _i12;
import 'package:mdiho/features/crypto/presentation/qr_screen.dart' as _i28;
import 'package:mdiho/features/crypto/presentation/sell_crypto_screen.dart'
    as _i31;
import 'package:mdiho/features/crypto/presentation/widget/standalone_transaction_details.dart'
    as _i32;
import 'package:mdiho/features/gift_card/presentation/card_details_proof.dart'
    as _i6;
import 'package:mdiho/features/gift_card/presentation/enter_card_details_screen.dart'
    as _i16;
import 'package:mdiho/features/gift_card/presentation/gift_card_screen.dart'
    as _i18;
import 'package:mdiho/features/gift_card/presentation/gift_transaction_details.dart'
    as _i19;
import 'package:mdiho/features/home/presentation/home_screen.dart' as _i20;
import 'package:mdiho/features/onboarding/presentation/onboarding_screen.dart'
    as _i24;
import 'package:mdiho/features/profile/presentation/bank/add_bank.dart' as _i1;
import 'package:mdiho/features/profile/presentation/bank/bank_list.dart'
    as _i21;
import 'package:mdiho/features/profile/presentation/personal_info/change_email.dart'
    as _i7;
import 'package:mdiho/features/profile/presentation/personal_info/email_verification.dart'
    as _i15;
import 'package:mdiho/features/profile/presentation/personal_info/personal_information.dart'
    as _i25;
import 'package:mdiho/features/profile/presentation/preference_scren.dart'
    as _i26;
import 'package:mdiho/features/profile/presentation/profile_screen.dart'
    as _i27;
import 'package:mdiho/features/profile/presentation/security_settings/change_password.dart'
    as _i8;
import 'package:mdiho/features/profile/presentation/security_settings/change_pin_screen.dart'
    as _i9;
import 'package:mdiho/features/profile/presentation/security_settings/security_settings.dart'
    as _i30;
import 'package:mdiho/features/transactio_pin/transaction_pin.dart' as _i35;
import 'package:mdiho/features/transaction/presentation/transaction_details.dart'
    as _i33;
import 'package:mdiho/features/transaction/presentation/transaction_history.dart'
    as _i34;
import 'package:mdiho/features/withdrawal/presentation/widget/success_dialogue.dart'
    as _i37;
import 'package:mdiho/features/withdrawal/presentation/withdraw_funds_screen.dart'
    as _i36;

/// generated route for
/// [_i1.AddNewBankScreen]
class AddNewBankRoute extends _i38.PageRouteInfo<void> {
  const AddNewBankRoute({List<_i38.PageRouteInfo>? children})
      : super(
          AddNewBankRoute.name,
          initialChildren: children,
        );

  static const String name = 'AddNewBankRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i1.AddNewBankScreen();
    },
  );
}

/// generated route for
/// [_i2.BettingScreen]
class BettingRoute extends _i38.PageRouteInfo<void> {
  const BettingRoute({List<_i38.PageRouteInfo>? children})
      : super(
          BettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'BettingRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i2.BettingScreen();
    },
  );
}

/// generated route for
/// [_i3.BuyAirtimeScreen]
class BuyAirtimeRoute extends _i38.PageRouteInfo<void> {
  const BuyAirtimeRoute({List<_i38.PageRouteInfo>? children})
      : super(
          BuyAirtimeRoute.name,
          initialChildren: children,
        );

  static const String name = 'BuyAirtimeRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i3.BuyAirtimeScreen();
    },
  );
}

/// generated route for
/// [_i4.BuyDataScreen]
class BuyDataRoute extends _i38.PageRouteInfo<void> {
  const BuyDataRoute({List<_i38.PageRouteInfo>? children})
      : super(
          BuyDataRoute.name,
          initialChildren: children,
        );

  static const String name = 'BuyDataRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i4.BuyDataScreen();
    },
  );
}

/// generated route for
/// [_i5.CableBillScreen]
class CableBillRoute extends _i38.PageRouteInfo<void> {
  const CableBillRoute({List<_i38.PageRouteInfo>? children})
      : super(
          CableBillRoute.name,
          initialChildren: children,
        );

  static const String name = 'CableBillRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i5.CableBillScreen();
    },
  );
}

/// generated route for
/// [_i6.CardDetailsProofScreen]
class CardDetailsProofRoute
    extends _i38.PageRouteInfo<CardDetailsProofRouteArgs> {
  CardDetailsProofRoute({
    _i39.Key? key,
    required String img,
    List<_i38.PageRouteInfo>? children,
  }) : super(
          CardDetailsProofRoute.name,
          args: CardDetailsProofRouteArgs(
            key: key,
            img: img,
          ),
          initialChildren: children,
        );

  static const String name = 'CardDetailsProofRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CardDetailsProofRouteArgs>();
      return _i6.CardDetailsProofScreen(
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

  final _i39.Key? key;

  final String img;

  @override
  String toString() {
    return 'CardDetailsProofRouteArgs{key: $key, img: $img}';
  }
}

/// generated route for
/// [_i7.ChangeEmailScreen]
class ChangeEmailRoute extends _i38.PageRouteInfo<void> {
  const ChangeEmailRoute({List<_i38.PageRouteInfo>? children})
      : super(
          ChangeEmailRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangeEmailRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i7.ChangeEmailScreen();
    },
  );
}

/// generated route for
/// [_i8.ChangePasswordScreen]
class ChangePasswordRoute extends _i38.PageRouteInfo<void> {
  const ChangePasswordRoute({List<_i38.PageRouteInfo>? children})
      : super(
          ChangePasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangePasswordRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i8.ChangePasswordScreen();
    },
  );
}

/// generated route for
/// [_i9.ChangePinScreen]
class ChangePinRoute extends _i38.PageRouteInfo<void> {
  const ChangePinRoute({List<_i38.PageRouteInfo>? children})
      : super(
          ChangePinRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangePinRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i9.ChangePinScreen();
    },
  );
}

/// generated route for
/// [_i10.ConfirmPinScreen]
class ConfirmPinRoute extends _i38.PageRouteInfo<void> {
  const ConfirmPinRoute({List<_i38.PageRouteInfo>? children})
      : super(
          ConfirmPinRoute.name,
          initialChildren: children,
        );

  static const String name = 'ConfirmPinRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i10.ConfirmPinScreen();
    },
  );
}

/// generated route for
/// [_i11.CreatePinScreen]
class CreatePinRoute extends _i38.PageRouteInfo<void> {
  const CreatePinRoute({List<_i38.PageRouteInfo>? children})
      : super(
          CreatePinRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreatePinRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i11.CreatePinScreen();
    },
  );
}

/// generated route for
/// [_i12.CryptoScreen]
class CryptoRoute extends _i38.PageRouteInfo<void> {
  const CryptoRoute({List<_i38.PageRouteInfo>? children})
      : super(
          CryptoRoute.name,
          initialChildren: children,
        );

  static const String name = 'CryptoRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i12.CryptoScreen();
    },
  );
}

/// generated route for
/// [_i13.CryptoShellScreen]
class CryptoShellRoute extends _i38.PageRouteInfo<void> {
  const CryptoShellRoute({List<_i38.PageRouteInfo>? children})
      : super(
          CryptoShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'CryptoShellRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i13.CryptoShellScreen();
    },
  );
}

/// generated route for
/// [_i14.ElectricityBillScreen]
class ElectricityBillRoute extends _i38.PageRouteInfo<void> {
  const ElectricityBillRoute({List<_i38.PageRouteInfo>? children})
      : super(
          ElectricityBillRoute.name,
          initialChildren: children,
        );

  static const String name = 'ElectricityBillRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i14.ElectricityBillScreen();
    },
  );
}

/// generated route for
/// [_i15.EmailVerificationScreen]
class EmailVerificationRoute extends _i38.PageRouteInfo<void> {
  const EmailVerificationRoute({List<_i38.PageRouteInfo>? children})
      : super(
          EmailVerificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'EmailVerificationRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i15.EmailVerificationScreen();
    },
  );
}

/// generated route for
/// [_i16.EnterCardDetailsScreen]
class EnterCardDetailsRoute
    extends _i38.PageRouteInfo<EnterCardDetailsRouteArgs> {
  EnterCardDetailsRoute({
    _i39.Key? key,
    required _i18.GiftCard giftCard,
    List<_i38.PageRouteInfo>? children,
  }) : super(
          EnterCardDetailsRoute.name,
          args: EnterCardDetailsRouteArgs(
            key: key,
            giftCard: giftCard,
          ),
          initialChildren: children,
        );

  static const String name = 'EnterCardDetailsRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EnterCardDetailsRouteArgs>();
      return _i16.EnterCardDetailsScreen(
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

  final _i39.Key? key;

  final _i18.GiftCard giftCard;

  @override
  String toString() {
    return 'EnterCardDetailsRouteArgs{key: $key, giftCard: $giftCard}';
  }
}

/// generated route for
/// [_i17.ForgotPasswordScreen]
class ForgotPasswordRoute extends _i38.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i38.PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i17.ForgotPasswordScreen();
    },
  );
}

/// generated route for
/// [_i18.GiftCardScreen]
class GiftCardRoute extends _i38.PageRouteInfo<void> {
  const GiftCardRoute({List<_i38.PageRouteInfo>? children})
      : super(
          GiftCardRoute.name,
          initialChildren: children,
        );

  static const String name = 'GiftCardRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i18.GiftCardScreen();
    },
  );
}

/// generated route for
/// [_i13.GiftCardShellScreen]
class GiftCardShellRoute extends _i38.PageRouteInfo<void> {
  const GiftCardShellRoute({List<_i38.PageRouteInfo>? children})
      : super(
          GiftCardShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'GiftCardShellRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i13.GiftCardShellScreen();
    },
  );
}

/// generated route for
/// [_i19.GiftTransactionDetailsScreen]
class GiftTransactionDetailsRoute
    extends _i38.PageRouteInfo<GiftTransactionDetailsRouteArgs> {
  GiftTransactionDetailsRoute({
    _i39.Key? key,
    required String type,
    required String status,
    bool? showAppBar = true,
    List<_i38.PageRouteInfo>? children,
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

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GiftTransactionDetailsRouteArgs>();
      return _i19.GiftTransactionDetailsScreen(
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

  final _i39.Key? key;

  final String type;

  final String status;

  final bool? showAppBar;

  @override
  String toString() {
    return 'GiftTransactionDetailsRouteArgs{key: $key, type: $type, status: $status, showAppBar: $showAppBar}';
  }
}

/// generated route for
/// [_i20.HomeScreen]
class HomeRoute extends _i38.PageRouteInfo<void> {
  const HomeRoute({List<_i38.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i20.HomeScreen();
    },
  );
}

/// generated route for
/// [_i13.HomeShellScreen]
class HomeShellRoute extends _i38.PageRouteInfo<void> {
  const HomeShellRoute({List<_i38.PageRouteInfo>? children})
      : super(
          HomeShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeShellRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i13.HomeShellScreen();
    },
  );
}

/// generated route for
/// [_i21.LinkedBanksScreen]
class LinkedBanksRoute extends _i38.PageRouteInfo<void> {
  const LinkedBanksRoute({List<_i38.PageRouteInfo>? children})
      : super(
          LinkedBanksRoute.name,
          initialChildren: children,
        );

  static const String name = 'LinkedBanksRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i21.LinkedBanksScreen();
    },
  );
}

/// generated route for
/// [_i22.LoginScreen]
class LoginRoute extends _i38.PageRouteInfo<void> {
  const LoginRoute({List<_i38.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i22.LoginScreen();
    },
  );
}

/// generated route for
/// [_i13.MdihoShellScreen]
class MdihoShellRoute extends _i38.PageRouteInfo<void> {
  const MdihoShellRoute({List<_i38.PageRouteInfo>? children})
      : super(
          MdihoShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'MdihoShellRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i13.MdihoShellScreen();
    },
  );
}

/// generated route for
/// [_i23.NaviBarScreen]
class NaviBarRoute extends _i38.PageRouteInfo<void> {
  const NaviBarRoute({List<_i38.PageRouteInfo>? children})
      : super(
          NaviBarRoute.name,
          initialChildren: children,
        );

  static const String name = 'NaviBarRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i23.NaviBarScreen();
    },
  );
}

/// generated route for
/// [_i24.OnboardingScreen]
class OnboardingRoute extends _i38.PageRouteInfo<void> {
  const OnboardingRoute({List<_i38.PageRouteInfo>? children})
      : super(
          OnboardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i24.OnboardingScreen();
    },
  );
}

/// generated route for
/// [_i25.PersonalInfoScreen]
class PersonalInfoRoute extends _i38.PageRouteInfo<void> {
  const PersonalInfoRoute({List<_i38.PageRouteInfo>? children})
      : super(
          PersonalInfoRoute.name,
          initialChildren: children,
        );

  static const String name = 'PersonalInfoRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i25.PersonalInfoScreen();
    },
  );
}

/// generated route for
/// [_i26.PreferenceScreen]
class PreferenceRoute extends _i38.PageRouteInfo<void> {
  const PreferenceRoute({List<_i38.PageRouteInfo>? children})
      : super(
          PreferenceRoute.name,
          initialChildren: children,
        );

  static const String name = 'PreferenceRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i26.PreferenceScreen();
    },
  );
}

/// generated route for
/// [_i27.ProfileScreen]
class ProfileRoute extends _i38.PageRouteInfo<void> {
  const ProfileRoute({List<_i38.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i27.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i13.ProfileShellScreen]
class ProfileShellRoute extends _i38.PageRouteInfo<void> {
  const ProfileShellRoute({List<_i38.PageRouteInfo>? children})
      : super(
          ProfileShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileShellRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i13.ProfileShellScreen();
    },
  );
}

/// generated route for
/// [_i28.QrCryptoScreen]
class QrCryptoRoute extends _i38.PageRouteInfo<void> {
  const QrCryptoRoute({List<_i38.PageRouteInfo>? children})
      : super(
          QrCryptoRoute.name,
          initialChildren: children,
        );

  static const String name = 'QrCryptoRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i28.QrCryptoScreen();
    },
  );
}

/// generated route for
/// [_i29.RegistrationScreen]
class RegistrationRoute extends _i38.PageRouteInfo<void> {
  const RegistrationRoute({List<_i38.PageRouteInfo>? children})
      : super(
          RegistrationRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegistrationRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i29.RegistrationScreen();
    },
  );
}

/// generated route for
/// [_i30.SecurtiySettingsScreen]
class SecurtiySettingsRoute extends _i38.PageRouteInfo<void> {
  const SecurtiySettingsRoute({List<_i38.PageRouteInfo>? children})
      : super(
          SecurtiySettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SecurtiySettingsRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i30.SecurtiySettingsScreen();
    },
  );
}

/// generated route for
/// [_i31.SellCryptoScreen]
class SellCryptoRoute extends _i38.PageRouteInfo<SellCryptoRouteArgs> {
  SellCryptoRoute({
    _i39.Key? key,
    required String name,
    required String symbol,
    required String rate,
    required String img,
    List<_i38.PageRouteInfo>? children,
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

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SellCryptoRouteArgs>();
      return _i31.SellCryptoScreen(
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

  final _i39.Key? key;

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
/// [_i32.StandAloneTransactionDetailsScreen]
class StandAloneTransactionDetailsRoute
    extends _i38.PageRouteInfo<StandAloneTransactionDetailsRouteArgs> {
  StandAloneTransactionDetailsRoute({
    _i39.Key? key,
    required String type,
    required String status,
    List<_i38.PageRouteInfo>? children,
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

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<StandAloneTransactionDetailsRouteArgs>();
      return _i32.StandAloneTransactionDetailsScreen(
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

  final _i39.Key? key;

  final String type;

  final String status;

  @override
  String toString() {
    return 'StandAloneTransactionDetailsRouteArgs{key: $key, type: $type, status: $status}';
  }
}

/// generated route for
/// [_i33.TransactionDetailsScreen]
class TransactionDetailsRoute
    extends _i38.PageRouteInfo<TransactionDetailsRouteArgs> {
  TransactionDetailsRoute({
    _i39.Key? key,
    required String type,
    required String status,
    bool? showAppBar = true,
    List<_i38.PageRouteInfo>? children,
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

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TransactionDetailsRouteArgs>();
      return _i33.TransactionDetailsScreen(
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

  final _i39.Key? key;

  final String type;

  final String status;

  final bool? showAppBar;

  @override
  String toString() {
    return 'TransactionDetailsRouteArgs{key: $key, type: $type, status: $status, showAppBar: $showAppBar}';
  }
}

/// generated route for
/// [_i34.TransactionHistoryScreen]
class TransactionHistoryRoute extends _i38.PageRouteInfo<void> {
  const TransactionHistoryRoute({List<_i38.PageRouteInfo>? children})
      : super(
          TransactionHistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'TransactionHistoryRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i34.TransactionHistoryScreen();
    },
  );
}

/// generated route for
/// [_i35.TransactionPinScreen]
class TransactionPinRoute extends _i38.PageRouteInfo<TransactionPinRouteArgs> {
  TransactionPinRoute({
    _i39.Key? key,
    required String info,
    List<_i38.PageRouteInfo>? children,
  }) : super(
          TransactionPinRoute.name,
          args: TransactionPinRouteArgs(
            key: key,
            info: info,
          ),
          initialChildren: children,
        );

  static const String name = 'TransactionPinRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TransactionPinRouteArgs>();
      return _i35.TransactionPinScreen(
        key: args.key,
        info: args.info,
      );
    },
  );
}

class TransactionPinRouteArgs {
  const TransactionPinRouteArgs({
    this.key,
    required this.info,
  });

  final _i39.Key? key;

  final String info;

  @override
  String toString() {
    return 'TransactionPinRouteArgs{key: $key, info: $info}';
  }
}

/// generated route for
/// [_i13.TransactionShellScreen]
class TransactionShellRoute extends _i38.PageRouteInfo<void> {
  const TransactionShellRoute({List<_i38.PageRouteInfo>? children})
      : super(
          TransactionShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'TransactionShellRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i13.TransactionShellScreen();
    },
  );
}

/// generated route for
/// [_i36.WithdrawFundsScreen]
class WithdrawFundsRoute extends _i38.PageRouteInfo<void> {
  const WithdrawFundsRoute({List<_i38.PageRouteInfo>? children})
      : super(
          WithdrawFundsRoute.name,
          initialChildren: children,
        );

  static const String name = 'WithdrawFundsRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i36.WithdrawFundsScreen();
    },
  );
}

/// generated route for
/// [_i37.WithdrawalSuccessDialogScreen]
class WithdrawalSuccessDialogRoute extends _i38.PageRouteInfo<void> {
  const WithdrawalSuccessDialogRoute({List<_i38.PageRouteInfo>? children})
      : super(
          WithdrawalSuccessDialogRoute.name,
          initialChildren: children,
        );

  static const String name = 'WithdrawalSuccessDialogRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i37.WithdrawalSuccessDialogScreen();
    },
  );
}
