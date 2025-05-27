// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i51;
import 'package:flutter/material.dart' as _i52;
import 'package:mdiho/features/authentication/presentation/forgot_password/presentation/forgot_password.dart'
    as _i23;
import 'package:mdiho/features/authentication/presentation/login/presentation/login_screen.dart'
    as _i29;
import 'package:mdiho/features/authentication/presentation/pin_creation/presentation/confirm_pin.dart'
    as _i14;
import 'package:mdiho/features/authentication/presentation/pin_creation/presentation/create_pin.dart'
    as _i15;
import 'package:mdiho/features/authentication/presentation/registration/presentation/registration_screen.dart'
    as _i38;
import 'package:mdiho/features/bank_network/presentation/bank_network_screen.dart'
    as _i3;
import 'package:mdiho/features/bills/data/model/response/airtime_transaction/airtime_transaction.dart'
    as _i53;
import 'package:mdiho/features/bills/presentation/betting_screen.dart' as _i4;
import 'package:mdiho/features/bills/presentation/bill_transaction_details.dart'
    as _i5;
import 'package:mdiho/features/bills/presentation/buy_airtime.dart' as _i6;
import 'package:mdiho/features/bills/presentation/buy_data.dart' as _i7;
import 'package:mdiho/features/bills/presentation/cable_bill.dart' as _i8;
import 'package:mdiho/features/bills/presentation/electricity_bill.dart'
    as _i18;
import 'package:mdiho/features/bottomNav/mdiho_shell_screen.dart' as _i2;
import 'package:mdiho/features/bottomNav/screen/navbar.dart' as _i30;
import 'package:mdiho/features/crypto/presentation/crypto_screen.dart' as _i16;
import 'package:mdiho/features/crypto/presentation/qr_screen.dart' as _i36;
import 'package:mdiho/features/crypto/presentation/sell_crypto_screen.dart'
    as _i40;
import 'package:mdiho/features/crypto/presentation/widget/standalone_transaction_details.dart'
    as _i42;
import 'package:mdiho/features/gift_card/data/model/response/gift_card_model/datum.dart'
    as _i54;
import 'package:mdiho/features/gift_card/presentation/card_details_proof.dart'
    as _i9;
import 'package:mdiho/features/gift_card/presentation/enter_card_details_screen.dart'
    as _i21;
import 'package:mdiho/features/gift_card/presentation/gift_card_screen.dart'
    as _i24;
import 'package:mdiho/features/gift_card/presentation/gift_transaction_details.dart'
    as _i26;
import 'package:mdiho/features/gift_card/presentation/widget/standAlone.dart'
    as _i25;
import 'package:mdiho/features/home/presentation/home_screen.dart' as _i27;
import 'package:mdiho/features/notification/notification_screen.dart' as _i31;
import 'package:mdiho/features/onboarding/presentation/onboarding_screen.dart'
    as _i32;
import 'package:mdiho/features/profile/data/Model/response/user_profile_model/bank.dart'
    as _i55;
import 'package:mdiho/features/profile/presentation/bank/add_bank.dart' as _i1;
import 'package:mdiho/features/profile/presentation/bank/bank_list.dart'
    as _i28;
import 'package:mdiho/features/profile/presentation/bank/edit_bank.dart'
    as _i17;
import 'package:mdiho/features/profile/presentation/personal_info/change_email.dart'
    as _i10;
import 'package:mdiho/features/profile/presentation/personal_info/change_username.dart'
    as _i13;
import 'package:mdiho/features/profile/presentation/personal_info/email_verification.dart'
    as _i19;
import 'package:mdiho/features/profile/presentation/personal_info/personal_information.dart'
    as _i33;
import 'package:mdiho/features/profile/presentation/preference_scren.dart'
    as _i34;
import 'package:mdiho/features/profile/presentation/profile_screen.dart'
    as _i35;
import 'package:mdiho/features/profile/presentation/security_settings/change_password.dart'
    as _i11;
import 'package:mdiho/features/profile/presentation/security_settings/change_pin_screen.dart'
    as _i12;
import 'package:mdiho/features/profile/presentation/security_settings/email.dart'
    as _i48;
import 'package:mdiho/features/profile/presentation/security_settings/email_verify.dart'
    as _i20;
import 'package:mdiho/features/profile/presentation/security_settings/security_settings.dart'
    as _i39;
import 'package:mdiho/features/referral_screen/presentation/referall_screen.dart'
    as _i37;
import 'package:mdiho/features/referral_screen/presentation/withdrawal/withdraw_balance_screen.dart'
    as _i50;
import 'package:mdiho/features/splash/splash_page.dart' as _i41;
import 'package:mdiho/features/suggestion_box/presentation/suggestion_screen.dart'
    as _i43;
import 'package:mdiho/features/support_faq/presentation/faq_screen.dart'
    as _i22;
import 'package:mdiho/features/support_faq/presentation/support_faq_screen.dart'
    as _i44;
import 'package:mdiho/features/transaction/data/model/response/rates_model/datum.dart'
    as _i57;
import 'package:mdiho/features/transaction/data/model/response/transaction_history/datum.dart'
    as _i56;
import 'package:mdiho/features/transaction/presentation/transaction_details.dart'
    as _i45;
import 'package:mdiho/features/transaction/presentation/transaction_history.dart'
    as _i46;
import 'package:mdiho/features/withdrawal/presentation/enter_pin.dart' as _i47;
import 'package:mdiho/features/withdrawal/presentation/withdraw_funds_screen.dart'
    as _i49;

/// generated route for
/// [_i1.AddNewBankScreen]
class AddNewBankRoute extends _i51.PageRouteInfo<AddNewBankRouteArgs> {
  AddNewBankRoute({
    _i52.Key? key,
    bool? isverif = false,
    List<_i51.PageRouteInfo>? children,
  }) : super(
          AddNewBankRoute.name,
          args: AddNewBankRouteArgs(
            key: key,
            isverif: isverif,
          ),
          initialChildren: children,
        );

  static const String name = 'AddNewBankRoute';

  static _i51.PageInfo page = _i51.PageInfo(
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

  final _i52.Key? key;

  final bool? isverif;

  @override
  String toString() {
    return 'AddNewBankRouteArgs{key: $key, isverif: $isverif}';
  }
}

/// generated route for
/// [_i2.AuthShellScreen]
class AuthShellRoute extends _i51.PageRouteInfo<void> {
  const AuthShellRoute({List<_i51.PageRouteInfo>? children})
      : super(
          AuthShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthShellRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i2.AuthShellScreen();
    },
  );
}

/// generated route for
/// [_i3.BankNetworkScreen]
class BankNetworkRoute extends _i51.PageRouteInfo<void> {
  const BankNetworkRoute({List<_i51.PageRouteInfo>? children})
      : super(
          BankNetworkRoute.name,
          initialChildren: children,
        );

  static const String name = 'BankNetworkRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i3.BankNetworkScreen();
    },
  );
}

/// generated route for
/// [_i4.BettingScreen]
class BettingRoute extends _i51.PageRouteInfo<void> {
  const BettingRoute({List<_i51.PageRouteInfo>? children})
      : super(
          BettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'BettingRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i4.BettingScreen();
    },
  );
}

/// generated route for
/// [_i5.BillTransactionDetailsScreen]
class BillTransactionDetailsRoute
    extends _i51.PageRouteInfo<BillTransactionDetailsRouteArgs> {
  BillTransactionDetailsRoute({
    _i52.Key? key,
    required String type,
    required String status,
    required _i53.AirtimeTransaction transaction,
    List<_i51.PageRouteInfo>? children,
  }) : super(
          BillTransactionDetailsRoute.name,
          args: BillTransactionDetailsRouteArgs(
            key: key,
            type: type,
            status: status,
            transaction: transaction,
          ),
          initialChildren: children,
        );

  static const String name = 'BillTransactionDetailsRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BillTransactionDetailsRouteArgs>();
      return _i5.BillTransactionDetailsScreen(
        key: args.key,
        type: args.type,
        status: args.status,
        transaction: args.transaction,
      );
    },
  );
}

class BillTransactionDetailsRouteArgs {
  const BillTransactionDetailsRouteArgs({
    this.key,
    required this.type,
    required this.status,
    required this.transaction,
  });

  final _i52.Key? key;

  final String type;

  final String status;

  final _i53.AirtimeTransaction transaction;

  @override
  String toString() {
    return 'BillTransactionDetailsRouteArgs{key: $key, type: $type, status: $status, transaction: $transaction}';
  }
}

/// generated route for
/// [_i6.BuyAirtimeScreen]
class BuyAirtimeRoute extends _i51.PageRouteInfo<void> {
  const BuyAirtimeRoute({List<_i51.PageRouteInfo>? children})
      : super(
          BuyAirtimeRoute.name,
          initialChildren: children,
        );

  static const String name = 'BuyAirtimeRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i6.BuyAirtimeScreen();
    },
  );
}

/// generated route for
/// [_i7.BuyDataScreen]
class BuyDataRoute extends _i51.PageRouteInfo<void> {
  const BuyDataRoute({List<_i51.PageRouteInfo>? children})
      : super(
          BuyDataRoute.name,
          initialChildren: children,
        );

  static const String name = 'BuyDataRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i7.BuyDataScreen();
    },
  );
}

/// generated route for
/// [_i8.CableBillScreen]
class CableBillRoute extends _i51.PageRouteInfo<void> {
  const CableBillRoute({List<_i51.PageRouteInfo>? children})
      : super(
          CableBillRoute.name,
          initialChildren: children,
        );

  static const String name = 'CableBillRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i8.CableBillScreen();
    },
  );
}

/// generated route for
/// [_i9.CardDetailsProofScreen]
class CardDetailsProofRoute
    extends _i51.PageRouteInfo<CardDetailsProofRouteArgs> {
  CardDetailsProofRoute({
    _i52.Key? key,
    required _i54.GiftCardData giftCard,
    required int amount,
    required String? rates,
    required bool isCode,
    required String currency,
    List<_i51.PageRouteInfo>? children,
  }) : super(
          CardDetailsProofRoute.name,
          args: CardDetailsProofRouteArgs(
            key: key,
            giftCard: giftCard,
            amount: amount,
            rates: rates,
            isCode: isCode,
            currency: currency,
          ),
          initialChildren: children,
        );

  static const String name = 'CardDetailsProofRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CardDetailsProofRouteArgs>();
      return _i9.CardDetailsProofScreen(
        key: args.key,
        giftCard: args.giftCard,
        amount: args.amount,
        rates: args.rates,
        isCode: args.isCode,
        currency: args.currency,
      );
    },
  );
}

class CardDetailsProofRouteArgs {
  const CardDetailsProofRouteArgs({
    this.key,
    required this.giftCard,
    required this.amount,
    required this.rates,
    required this.isCode,
    required this.currency,
  });

  final _i52.Key? key;

  final _i54.GiftCardData giftCard;

  final int amount;

  final String? rates;

  final bool isCode;

  final String currency;

  @override
  String toString() {
    return 'CardDetailsProofRouteArgs{key: $key, giftCard: $giftCard, amount: $amount, rates: $rates, isCode: $isCode, currency: $currency}';
  }
}

/// generated route for
/// [_i10.ChangeEmailScreen]
class ChangeEmailRoute extends _i51.PageRouteInfo<void> {
  const ChangeEmailRoute({List<_i51.PageRouteInfo>? children})
      : super(
          ChangeEmailRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangeEmailRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i10.ChangeEmailScreen();
    },
  );
}

/// generated route for
/// [_i11.ChangePasswordScreen]
class ChangePasswordRoute extends _i51.PageRouteInfo<void> {
  const ChangePasswordRoute({List<_i51.PageRouteInfo>? children})
      : super(
          ChangePasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangePasswordRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i11.ChangePasswordScreen();
    },
  );
}

/// generated route for
/// [_i12.ChangePinScreen]
class ChangePinRoute extends _i51.PageRouteInfo<void> {
  const ChangePinRoute({List<_i51.PageRouteInfo>? children})
      : super(
          ChangePinRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangePinRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i12.ChangePinScreen();
    },
  );
}

/// generated route for
/// [_i13.ChangeUsernameScreen]
class ChangeUsernameRoute extends _i51.PageRouteInfo<ChangeUsernameRouteArgs> {
  ChangeUsernameRoute({
    _i52.Key? key,
    required String userame,
    List<_i51.PageRouteInfo>? children,
  }) : super(
          ChangeUsernameRoute.name,
          args: ChangeUsernameRouteArgs(
            key: key,
            userame: userame,
          ),
          initialChildren: children,
        );

  static const String name = 'ChangeUsernameRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChangeUsernameRouteArgs>();
      return _i13.ChangeUsernameScreen(
        key: args.key,
        userame: args.userame,
      );
    },
  );
}

class ChangeUsernameRouteArgs {
  const ChangeUsernameRouteArgs({
    this.key,
    required this.userame,
  });

  final _i52.Key? key;

  final String userame;

  @override
  String toString() {
    return 'ChangeUsernameRouteArgs{key: $key, userame: $userame}';
  }
}

/// generated route for
/// [_i14.ConfirmPinScreen]
class ConfirmPinRoute extends _i51.PageRouteInfo<ConfirmPinRouteArgs> {
  ConfirmPinRoute({
    _i52.Key? key,
    required String pin,
    List<_i51.PageRouteInfo>? children,
  }) : super(
          ConfirmPinRoute.name,
          args: ConfirmPinRouteArgs(
            key: key,
            pin: pin,
          ),
          initialChildren: children,
        );

  static const String name = 'ConfirmPinRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ConfirmPinRouteArgs>();
      return _i14.ConfirmPinScreen(
        key: args.key,
        pin: args.pin,
      );
    },
  );
}

class ConfirmPinRouteArgs {
  const ConfirmPinRouteArgs({
    this.key,
    required this.pin,
  });

  final _i52.Key? key;

  final String pin;

  @override
  String toString() {
    return 'ConfirmPinRouteArgs{key: $key, pin: $pin}';
  }
}

/// generated route for
/// [_i15.CreatePinScreen]
class CreatePinRoute extends _i51.PageRouteInfo<void> {
  const CreatePinRoute({List<_i51.PageRouteInfo>? children})
      : super(
          CreatePinRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreatePinRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i15.CreatePinScreen();
    },
  );
}

/// generated route for
/// [_i16.CryptoScreen]
class CryptoRoute extends _i51.PageRouteInfo<void> {
  const CryptoRoute({List<_i51.PageRouteInfo>? children})
      : super(
          CryptoRoute.name,
          initialChildren: children,
        );

  static const String name = 'CryptoRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i16.CryptoScreen();
    },
  );
}

/// generated route for
/// [_i2.CryptoShellScreen]
class CryptoShellRoute extends _i51.PageRouteInfo<void> {
  const CryptoShellRoute({List<_i51.PageRouteInfo>? children})
      : super(
          CryptoShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'CryptoShellRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i2.CryptoShellScreen();
    },
  );
}

/// generated route for
/// [_i17.EditBankScreen]
class EditBankRoute extends _i51.PageRouteInfo<EditBankRouteArgs> {
  EditBankRoute({
    _i52.Key? key,
    bool? isverif = false,
    required _i55.Bank bankDetails,
    List<_i51.PageRouteInfo>? children,
  }) : super(
          EditBankRoute.name,
          args: EditBankRouteArgs(
            key: key,
            isverif: isverif,
            bankDetails: bankDetails,
          ),
          initialChildren: children,
        );

  static const String name = 'EditBankRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EditBankRouteArgs>();
      return _i17.EditBankScreen(
        key: args.key,
        isverif: args.isverif,
        bankDetails: args.bankDetails,
      );
    },
  );
}

class EditBankRouteArgs {
  const EditBankRouteArgs({
    this.key,
    this.isverif = false,
    required this.bankDetails,
  });

  final _i52.Key? key;

  final bool? isverif;

  final _i55.Bank bankDetails;

  @override
  String toString() {
    return 'EditBankRouteArgs{key: $key, isverif: $isverif, bankDetails: $bankDetails}';
  }
}

/// generated route for
/// [_i18.ElectricityBillScreen]
class ElectricityBillRoute extends _i51.PageRouteInfo<void> {
  const ElectricityBillRoute({List<_i51.PageRouteInfo>? children})
      : super(
          ElectricityBillRoute.name,
          initialChildren: children,
        );

  static const String name = 'ElectricityBillRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i18.ElectricityBillScreen();
    },
  );
}

/// generated route for
/// [_i19.EmailVerificationScreen]
class EmailVerificationRoute
    extends _i51.PageRouteInfo<EmailVerificationRouteArgs> {
  EmailVerificationRoute({
    _i52.Key? key,
    required String email,
    List<_i51.PageRouteInfo>? children,
  }) : super(
          EmailVerificationRoute.name,
          args: EmailVerificationRouteArgs(
            key: key,
            email: email,
          ),
          initialChildren: children,
        );

  static const String name = 'EmailVerificationRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EmailVerificationRouteArgs>();
      return _i19.EmailVerificationScreen(
        key: args.key,
        email: args.email,
      );
    },
  );
}

class EmailVerificationRouteArgs {
  const EmailVerificationRouteArgs({
    this.key,
    required this.email,
  });

  final _i52.Key? key;

  final String email;

  @override
  String toString() {
    return 'EmailVerificationRouteArgs{key: $key, email: $email}';
  }
}

/// generated route for
/// [_i20.EmailVerifyScreen]
class EmailVerifyRoute extends _i51.PageRouteInfo<EmailVerifyRouteArgs> {
  EmailVerifyRoute({
    _i52.Key? key,
    required String type,
    List<_i51.PageRouteInfo>? children,
  }) : super(
          EmailVerifyRoute.name,
          args: EmailVerifyRouteArgs(
            key: key,
            type: type,
          ),
          initialChildren: children,
        );

  static const String name = 'EmailVerifyRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EmailVerifyRouteArgs>();
      return _i20.EmailVerifyScreen(
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

  final _i52.Key? key;

  final String type;

  @override
  String toString() {
    return 'EmailVerifyRouteArgs{key: $key, type: $type}';
  }
}

/// generated route for
/// [_i21.EnterCardDetailsScreen]
class EnterCardDetailsRoute
    extends _i51.PageRouteInfo<EnterCardDetailsRouteArgs> {
  EnterCardDetailsRoute({
    _i52.Key? key,
    required _i54.GiftCardData giftCard,
    List<_i51.PageRouteInfo>? children,
  }) : super(
          EnterCardDetailsRoute.name,
          args: EnterCardDetailsRouteArgs(
            key: key,
            giftCard: giftCard,
          ),
          initialChildren: children,
        );

  static const String name = 'EnterCardDetailsRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EnterCardDetailsRouteArgs>();
      return _i21.EnterCardDetailsScreen(
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

  final _i52.Key? key;

  final _i54.GiftCardData giftCard;

  @override
  String toString() {
    return 'EnterCardDetailsRouteArgs{key: $key, giftCard: $giftCard}';
  }
}

/// generated route for
/// [_i22.FaqScreen]
class FaqRoute extends _i51.PageRouteInfo<void> {
  const FaqRoute({List<_i51.PageRouteInfo>? children})
      : super(
          FaqRoute.name,
          initialChildren: children,
        );

  static const String name = 'FaqRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i22.FaqScreen();
    },
  );
}

/// generated route for
/// [_i23.ForgotPasswordScreen]
class ForgotPasswordRoute extends _i51.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i51.PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i23.ForgotPasswordScreen();
    },
  );
}

/// generated route for
/// [_i24.GiftCardScreen]
class GiftCardRoute extends _i51.PageRouteInfo<void> {
  const GiftCardRoute({List<_i51.PageRouteInfo>? children})
      : super(
          GiftCardRoute.name,
          initialChildren: children,
        );

  static const String name = 'GiftCardRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i24.GiftCardScreen();
    },
  );
}

/// generated route for
/// [_i2.GiftCardShellScreen]
class GiftCardShellRoute extends _i51.PageRouteInfo<void> {
  const GiftCardShellRoute({List<_i51.PageRouteInfo>? children})
      : super(
          GiftCardShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'GiftCardShellRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i2.GiftCardShellScreen();
    },
  );
}

/// generated route for
/// [_i25.GiftStandAloneTransactionDetailsScreen]
class GiftStandAloneTransactionDetailsRoute
    extends _i51.PageRouteInfo<GiftStandAloneTransactionDetailsRouteArgs> {
  GiftStandAloneTransactionDetailsRoute({
    _i52.Key? key,
    required String type,
    required String status,
    required _i56.TransactionData transaction,
    List<_i51.PageRouteInfo>? children,
  }) : super(
          GiftStandAloneTransactionDetailsRoute.name,
          args: GiftStandAloneTransactionDetailsRouteArgs(
            key: key,
            type: type,
            status: status,
            transaction: transaction,
          ),
          initialChildren: children,
        );

  static const String name = 'GiftStandAloneTransactionDetailsRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GiftStandAloneTransactionDetailsRouteArgs>();
      return _i25.GiftStandAloneTransactionDetailsScreen(
        key: args.key,
        type: args.type,
        status: args.status,
        transaction: args.transaction,
      );
    },
  );
}

class GiftStandAloneTransactionDetailsRouteArgs {
  const GiftStandAloneTransactionDetailsRouteArgs({
    this.key,
    required this.type,
    required this.status,
    required this.transaction,
  });

  final _i52.Key? key;

  final String type;

  final String status;

  final _i56.TransactionData transaction;

  @override
  String toString() {
    return 'GiftStandAloneTransactionDetailsRouteArgs{key: $key, type: $type, status: $status, transaction: $transaction}';
  }
}

/// generated route for
/// [_i26.GiftTransactionDetailsScreen]
class GiftTransactionDetailsRoute
    extends _i51.PageRouteInfo<GiftTransactionDetailsRouteArgs> {
  GiftTransactionDetailsRoute({
    _i52.Key? key,
    required String type,
    required String status,
    bool? showAppBar = true,
    required _i56.TransactionData transaction,
    List<_i51.PageRouteInfo>? children,
  }) : super(
          GiftTransactionDetailsRoute.name,
          args: GiftTransactionDetailsRouteArgs(
            key: key,
            type: type,
            status: status,
            showAppBar: showAppBar,
            transaction: transaction,
          ),
          initialChildren: children,
        );

  static const String name = 'GiftTransactionDetailsRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GiftTransactionDetailsRouteArgs>();
      return _i26.GiftTransactionDetailsScreen(
        key: args.key,
        type: args.type,
        status: args.status,
        showAppBar: args.showAppBar,
        transaction: args.transaction,
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
    required this.transaction,
  });

  final _i52.Key? key;

  final String type;

  final String status;

  final bool? showAppBar;

  final _i56.TransactionData transaction;

  @override
  String toString() {
    return 'GiftTransactionDetailsRouteArgs{key: $key, type: $type, status: $status, showAppBar: $showAppBar, transaction: $transaction}';
  }
}

/// generated route for
/// [_i27.HomeScreen]
class HomeRoute extends _i51.PageRouteInfo<void> {
  const HomeRoute({List<_i51.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i27.HomeScreen();
    },
  );
}

/// generated route for
/// [_i2.HomeShellScreen]
class HomeShellRoute extends _i51.PageRouteInfo<void> {
  const HomeShellRoute({List<_i51.PageRouteInfo>? children})
      : super(
          HomeShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeShellRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomeShellScreen();
    },
  );
}

/// generated route for
/// [_i28.LinkedBanksScreen]
class LinkedBanksRoute extends _i51.PageRouteInfo<void> {
  const LinkedBanksRoute({List<_i51.PageRouteInfo>? children})
      : super(
          LinkedBanksRoute.name,
          initialChildren: children,
        );

  static const String name = 'LinkedBanksRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i28.LinkedBanksScreen();
    },
  );
}

/// generated route for
/// [_i29.LoginScreen]
class LoginRoute extends _i51.PageRouteInfo<void> {
  const LoginRoute({List<_i51.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i29.LoginScreen();
    },
  );
}

/// generated route for
/// [_i2.MdihoShellScreen]
class MdihoShellRoute extends _i51.PageRouteInfo<void> {
  const MdihoShellRoute({List<_i51.PageRouteInfo>? children})
      : super(
          MdihoShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'MdihoShellRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i2.MdihoShellScreen();
    },
  );
}

/// generated route for
/// [_i30.NaviBarScreen]
class NaviBarRoute extends _i51.PageRouteInfo<void> {
  const NaviBarRoute({List<_i51.PageRouteInfo>? children})
      : super(
          NaviBarRoute.name,
          initialChildren: children,
        );

  static const String name = 'NaviBarRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i30.NaviBarScreen();
    },
  );
}

/// generated route for
/// [_i31.NotificationScreen]
class NotificationRoute extends _i51.PageRouteInfo<void> {
  const NotificationRoute({List<_i51.PageRouteInfo>? children})
      : super(
          NotificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i31.NotificationScreen();
    },
  );
}

/// generated route for
/// [_i32.OnboardingScreen]
class OnboardingRoute extends _i51.PageRouteInfo<void> {
  const OnboardingRoute({List<_i51.PageRouteInfo>? children})
      : super(
          OnboardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i32.OnboardingScreen();
    },
  );
}

/// generated route for
/// [_i33.PersonalInfoScreen]
class PersonalInfoRoute extends _i51.PageRouteInfo<void> {
  const PersonalInfoRoute({List<_i51.PageRouteInfo>? children})
      : super(
          PersonalInfoRoute.name,
          initialChildren: children,
        );

  static const String name = 'PersonalInfoRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i33.PersonalInfoScreen();
    },
  );
}

/// generated route for
/// [_i34.PreferenceScreen]
class PreferenceRoute extends _i51.PageRouteInfo<void> {
  const PreferenceRoute({List<_i51.PageRouteInfo>? children})
      : super(
          PreferenceRoute.name,
          initialChildren: children,
        );

  static const String name = 'PreferenceRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i34.PreferenceScreen();
    },
  );
}

/// generated route for
/// [_i35.ProfileScreen]
class ProfileRoute extends _i51.PageRouteInfo<void> {
  const ProfileRoute({List<_i51.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i35.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i2.ProfileShellScreen]
class ProfileShellRoute extends _i51.PageRouteInfo<void> {
  const ProfileShellRoute({List<_i51.PageRouteInfo>? children})
      : super(
          ProfileShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileShellRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i2.ProfileShellScreen();
    },
  );
}

/// generated route for
/// [_i36.QrCryptoScreen]
class QrCryptoRoute extends _i51.PageRouteInfo<QrCryptoRouteArgs> {
  QrCryptoRoute({
    _i52.Key? key,
    required String amount,
    required _i57.RateData crypto,
    List<_i51.PageRouteInfo>? children,
  }) : super(
          QrCryptoRoute.name,
          args: QrCryptoRouteArgs(
            key: key,
            amount: amount,
            crypto: crypto,
          ),
          initialChildren: children,
        );

  static const String name = 'QrCryptoRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<QrCryptoRouteArgs>();
      return _i36.QrCryptoScreen(
        key: args.key,
        amount: args.amount,
        crypto: args.crypto,
      );
    },
  );
}

class QrCryptoRouteArgs {
  const QrCryptoRouteArgs({
    this.key,
    required this.amount,
    required this.crypto,
  });

  final _i52.Key? key;

  final String amount;

  final _i57.RateData crypto;

  @override
  String toString() {
    return 'QrCryptoRouteArgs{key: $key, amount: $amount, crypto: $crypto}';
  }
}

/// generated route for
/// [_i37.ReferallScreen]
class ReferallRoute extends _i51.PageRouteInfo<void> {
  const ReferallRoute({List<_i51.PageRouteInfo>? children})
      : super(
          ReferallRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReferallRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i37.ReferallScreen();
    },
  );
}

/// generated route for
/// [_i38.RegistrationScreen]
class RegistrationRoute extends _i51.PageRouteInfo<void> {
  const RegistrationRoute({List<_i51.PageRouteInfo>? children})
      : super(
          RegistrationRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegistrationRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i38.RegistrationScreen();
    },
  );
}

/// generated route for
/// [_i39.SecurtiySettingsScreen]
class SecurtiySettingsRoute extends _i51.PageRouteInfo<void> {
  const SecurtiySettingsRoute({List<_i51.PageRouteInfo>? children})
      : super(
          SecurtiySettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SecurtiySettingsRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i39.SecurtiySettingsScreen();
    },
  );
}

/// generated route for
/// [_i40.SellCryptoScreen]
class SellCryptoRoute extends _i51.PageRouteInfo<SellCryptoRouteArgs> {
  SellCryptoRoute({
    _i52.Key? key,
    required _i57.RateData rates,
    List<_i51.PageRouteInfo>? children,
  }) : super(
          SellCryptoRoute.name,
          args: SellCryptoRouteArgs(
            key: key,
            rates: rates,
          ),
          initialChildren: children,
        );

  static const String name = 'SellCryptoRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SellCryptoRouteArgs>();
      return _i40.SellCryptoScreen(
        key: args.key,
        rates: args.rates,
      );
    },
  );
}

class SellCryptoRouteArgs {
  const SellCryptoRouteArgs({
    this.key,
    required this.rates,
  });

  final _i52.Key? key;

  final _i57.RateData rates;

  @override
  String toString() {
    return 'SellCryptoRouteArgs{key: $key, rates: $rates}';
  }
}

/// generated route for
/// [_i41.SplashScreen]
class SplashRoute extends _i51.PageRouteInfo<void> {
  const SplashRoute({List<_i51.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i41.SplashScreen();
    },
  );
}

/// generated route for
/// [_i2.SplashShellScreen]
class SplashShellRoute extends _i51.PageRouteInfo<void> {
  const SplashShellRoute({List<_i51.PageRouteInfo>? children})
      : super(
          SplashShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashShellRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i2.SplashShellScreen();
    },
  );
}

/// generated route for
/// [_i42.StandAloneTransactionDetailsScreen]
class StandAloneTransactionDetailsRoute
    extends _i51.PageRouteInfo<StandAloneTransactionDetailsRouteArgs> {
  StandAloneTransactionDetailsRoute({
    _i52.Key? key,
    required String type,
    required String status,
    required _i56.TransactionData transaction,
    List<_i51.PageRouteInfo>? children,
  }) : super(
          StandAloneTransactionDetailsRoute.name,
          args: StandAloneTransactionDetailsRouteArgs(
            key: key,
            type: type,
            status: status,
            transaction: transaction,
          ),
          initialChildren: children,
        );

  static const String name = 'StandAloneTransactionDetailsRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<StandAloneTransactionDetailsRouteArgs>();
      return _i42.StandAloneTransactionDetailsScreen(
        key: args.key,
        type: args.type,
        status: args.status,
        transaction: args.transaction,
      );
    },
  );
}

class StandAloneTransactionDetailsRouteArgs {
  const StandAloneTransactionDetailsRouteArgs({
    this.key,
    required this.type,
    required this.status,
    required this.transaction,
  });

  final _i52.Key? key;

  final String type;

  final String status;

  final _i56.TransactionData transaction;

  @override
  String toString() {
    return 'StandAloneTransactionDetailsRouteArgs{key: $key, type: $type, status: $status, transaction: $transaction}';
  }
}

/// generated route for
/// [_i43.SuggestionScreen]
class SuggestionRoute extends _i51.PageRouteInfo<void> {
  const SuggestionRoute({List<_i51.PageRouteInfo>? children})
      : super(
          SuggestionRoute.name,
          initialChildren: children,
        );

  static const String name = 'SuggestionRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i43.SuggestionScreen();
    },
  );
}

/// generated route for
/// [_i44.SupportFaqScreen]
class SupportFaqRoute extends _i51.PageRouteInfo<void> {
  const SupportFaqRoute({List<_i51.PageRouteInfo>? children})
      : super(
          SupportFaqRoute.name,
          initialChildren: children,
        );

  static const String name = 'SupportFaqRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i44.SupportFaqScreen();
    },
  );
}

/// generated route for
/// [_i45.TransactionDetailsScreen]
class TransactionDetailsRoute
    extends _i51.PageRouteInfo<TransactionDetailsRouteArgs> {
  TransactionDetailsRoute({
    _i52.Key? key,
    required String type,
    required String status,
    bool? showAppBar = true,
    required _i56.TransactionData transaction,
    List<_i51.PageRouteInfo>? children,
  }) : super(
          TransactionDetailsRoute.name,
          args: TransactionDetailsRouteArgs(
            key: key,
            type: type,
            status: status,
            showAppBar: showAppBar,
            transaction: transaction,
          ),
          initialChildren: children,
        );

  static const String name = 'TransactionDetailsRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TransactionDetailsRouteArgs>();
      return _i45.TransactionDetailsScreen(
        key: args.key,
        type: args.type,
        status: args.status,
        showAppBar: args.showAppBar,
        transaction: args.transaction,
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
    required this.transaction,
  });

  final _i52.Key? key;

  final String type;

  final String status;

  final bool? showAppBar;

  final _i56.TransactionData transaction;

  @override
  String toString() {
    return 'TransactionDetailsRouteArgs{key: $key, type: $type, status: $status, showAppBar: $showAppBar, transaction: $transaction}';
  }
}

/// generated route for
/// [_i46.TransactionHistoryScreen]
class TransactionHistoryRoute extends _i51.PageRouteInfo<void> {
  const TransactionHistoryRoute({List<_i51.PageRouteInfo>? children})
      : super(
          TransactionHistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'TransactionHistoryRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i46.TransactionHistoryScreen();
    },
  );
}

/// generated route for
/// [_i47.TransactionPinScreen]
class TransactionPinRoute extends _i51.PageRouteInfo<TransactionPinRouteArgs> {
  TransactionPinRoute({
    _i52.Key? key,
    required bool isHome,
    required String acctNo,
    required int amount,
    required bool referall,
    required String accountName,
    required String bankName,
    required String bankCode,
    List<_i51.PageRouteInfo>? children,
  }) : super(
          TransactionPinRoute.name,
          args: TransactionPinRouteArgs(
            key: key,
            isHome: isHome,
            acctNo: acctNo,
            amount: amount,
            referall: referall,
            accountName: accountName,
            bankName: bankName,
            bankCode: bankCode,
          ),
          initialChildren: children,
        );

  static const String name = 'TransactionPinRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TransactionPinRouteArgs>();
      return _i47.TransactionPinScreen(
        key: args.key,
        isHome: args.isHome,
        acctNo: args.acctNo,
        amount: args.amount,
        referall: args.referall,
        accountName: args.accountName,
        bankName: args.bankName,
        bankCode: args.bankCode,
      );
    },
  );
}

class TransactionPinRouteArgs {
  const TransactionPinRouteArgs({
    this.key,
    required this.isHome,
    required this.acctNo,
    required this.amount,
    required this.referall,
    required this.accountName,
    required this.bankName,
    required this.bankCode,
  });

  final _i52.Key? key;

  final bool isHome;

  final String acctNo;

  final int amount;

  final bool referall;

  final String accountName;

  final String bankName;

  final String bankCode;

  @override
  String toString() {
    return 'TransactionPinRouteArgs{key: $key, isHome: $isHome, acctNo: $acctNo, amount: $amount, referall: $referall, accountName: $accountName, bankName: $bankName, bankCode: $bankCode}';
  }
}

/// generated route for
/// [_i2.TransactionShellScreen]
class TransactionShellRoute extends _i51.PageRouteInfo<void> {
  const TransactionShellRoute({List<_i51.PageRouteInfo>? children})
      : super(
          TransactionShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'TransactionShellRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i2.TransactionShellScreen();
    },
  );
}

/// generated route for
/// [_i48.VerifyEmailScreen]
class VerifyEmailRoute extends _i51.PageRouteInfo<VerifyEmailRouteArgs> {
  VerifyEmailRoute({
    _i52.Key? key,
    required String type,
    List<_i51.PageRouteInfo>? children,
  }) : super(
          VerifyEmailRoute.name,
          args: VerifyEmailRouteArgs(
            key: key,
            type: type,
          ),
          initialChildren: children,
        );

  static const String name = 'VerifyEmailRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VerifyEmailRouteArgs>();
      return _i48.VerifyEmailScreen(
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

  final _i52.Key? key;

  final String type;

  @override
  String toString() {
    return 'VerifyEmailRouteArgs{key: $key, type: $type}';
  }
}

/// generated route for
/// [_i49.WithdrawFundsScreen]
class WithdrawFundsRoute extends _i51.PageRouteInfo<void> {
  const WithdrawFundsRoute({List<_i51.PageRouteInfo>? children})
      : super(
          WithdrawFundsRoute.name,
          initialChildren: children,
        );

  static const String name = 'WithdrawFundsRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i49.WithdrawFundsScreen();
    },
  );
}

/// generated route for
/// [_i50.WithdrawReferallScreen]
class WithdrawReferallRoute extends _i51.PageRouteInfo<void> {
  const WithdrawReferallRoute({List<_i51.PageRouteInfo>? children})
      : super(
          WithdrawReferallRoute.name,
          initialChildren: children,
        );

  static const String name = 'WithdrawReferallRoute';

  static _i51.PageInfo page = _i51.PageInfo(
    name,
    builder: (data) {
      return const _i50.WithdrawReferallScreen();
    },
  );
}
