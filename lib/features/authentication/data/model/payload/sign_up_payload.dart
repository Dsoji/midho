import 'dart:collection' show MapView;

import 'package:flutter/foundation.dart' show immutable;
import 'package:hive_flutter/hive_flutter.dart';

var box = Hive.box('data');
String storedToken = box.get('fcm_token') ?? '';

@immutable
class SignUpPayload extends MapView<String, dynamic> {
  SignUpPayload({
    String? firstname,
    String? lastname,
    String? country,
    String? phone,
    String? email,
    String? password,
    String? referral,
    String? device,
    String? medium,
    dynamic fcmToken,
  }) : super({
          'firstname': firstname,
          'lastname': lastname,
          'country': country,
          'phone': phone,
          'email': email,
          'password': password,
          'referral': referral,
          'device': device,
          'medium': medium,
          'fcmToken': storedToken,
        });
}
