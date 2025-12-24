import 'dart:collection' show MapView;

import 'package:flutter/foundation.dart' show immutable;

@immutable
class KycPayload extends MapView<String, dynamic> {
  KycPayload({
    String? bvn,
    String? nin,
    required String selfie, // base64
  }) : super(
          {
            "bvn": bvn,
            "nin": nin,
            "selfie": selfie,
          }..removeWhere((key, value) => value == null || value == ''),
        );
}
