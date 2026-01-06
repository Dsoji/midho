import 'dart:convert';

import 'package:crypto/crypto.dart';

class ChecksumHelper {
  /// Rounds timestamp to nearest 10-second interval
  /// This ensures transactions within the same 10-second window have the same checksum
  /// Rounds timestamp to nearest 10-second interval
  /// This ensures transactions within the same 10-second window have the same checksum
  static int get10SecondTimeWindow() {
    final now = DateTime.now();
    final seconds = now.millisecondsSinceEpoch ~/ 1000;
    // Round down to nearest 10-second interval
    final window = (seconds ~/ 10) * 10;
    return window;
  }

  /// Generates a deterministic checksum for gift card transactions
  /// Includes 30-second time window to allow duplicate transactions within same window
  static String generateGiftCardChecksum({
    required String? assetId,
    required String? name,
    required num? amount,
    String? code,
    String? pin,
    bool? ecode,
    String? comment,
    List<String>? files,
    int? timeWindow,
  }) {
    final window = timeWindow ?? get10SecondTimeWindow();

    // Use file count instead of file paths (URLs change on each upload)
    final fileCount = files?.length ?? 0;

    final Map<String, dynamic> data = {
      'assetId': assetId ?? '',
      'name': name ?? '',
      'amount': amount?.toString() ?? '0',
      'code': code ?? '',
      'pin': pin ?? '',
      'ecode': ecode?.toString() ?? 'false',
      'comment': comment ?? '',
      'fileCount': fileCount.toString(), // Use count instead of paths
      'timeWindow': window.toString(), // 10-second window
    };

    final jsonString = jsonEncode(data);
    final bytes = utf8.encode(jsonString);
    final digest = sha256.convert(bytes);

    return digest.toString();
  }

  /// Generates a deterministic checksum for bill payments (Airtime, Data, Electricity, Cable TV)
  /// Includes 30-second time window to allow duplicate transactions within same window
  static String generateBillChecksum({
    required String? assetId,
    String? amount,
    String? accountNumber,
    required String
        transactionType, // 'Airtime', 'Data', 'Electricity', 'CableTv'
    int? timeWindow,
  }) {
    final window = timeWindow ?? get10SecondTimeWindow();

    final Map<String, dynamic> data = {
      'assetId': assetId ?? '',
      'amount': amount ?? '',
      'accountNumber': accountNumber ?? '',
      'type': transactionType,
      'timeWindow': window.toString(), // 10-second window
    };

    final jsonString = jsonEncode(data);
    final bytes = utf8.encode(jsonString);
    final digest = sha256.convert(bytes);

    return digest.toString();
  }

  /// Generates a deterministic checksum for crypto transactions
  /// Includes 30-second time window to allow duplicate transactions within same window
  static String generateCryptoChecksum({
    required String? id,
    required String? name,
    required double? amount,
    String? comment,
    List<String>? files,
    int? timeWindow,
  }) {
    final window = timeWindow ?? get10SecondTimeWindow();

    // Use file count instead of file paths (URLs change on each upload)
    final fileCount = files?.length ?? 0;

    final Map<String, dynamic> data = {
      'id': id ?? '',
      'name': name ?? '',
      'amount': amount?.toString() ?? '0',
      'comment': comment ?? '',
      'fileCount': fileCount.toString(), // Use count instead of paths
      'timeWindow': window.toString(), // 10-second window
    };

    final jsonString = jsonEncode(data);
    final bytes = utf8.encode(jsonString);
    final digest = sha256.convert(bytes);

    return digest.toString();
  }

  /// Generates a deterministic checksum for withdrawals
  /// Includes 30-second time window to allow duplicate transactions within same window
  static String generateWithdrawalChecksum({
    String? acctNo,
    int? amount,
    bool? referall,
    String? accountName,
    String? bankName,
    String? bankCode,
    required String pin,
    int? timeWindow,
  }) {
    final window = timeWindow ?? get10SecondTimeWindow();

    final Map<String, dynamic> data = {
      'acctNo': acctNo ?? '',
      'amount': amount?.toString() ?? '0',
      'referall': referall?.toString() ?? 'false',
      'accountName': accountName ?? '',
      'bankName': bankName ?? '',
      'bankCode': bankCode ?? '',
      'pin': pin,
      'timeWindow': window.toString(), // 10-second window
    };

    final jsonString = jsonEncode(data);
    final bytes = utf8.encode(jsonString);
    final digest = sha256.convert(bytes);

    return digest.toString();
  }
}
