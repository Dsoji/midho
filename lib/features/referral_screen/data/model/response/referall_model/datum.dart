import 'dart:convert';

import 'referral.dart';

class Datum {
  String? id;
  String? email;
  String? firstname;
  String? lastname;
  String? phone;
  String? country;
  Referral? referral;
  bool? locked;
  bool? pushAlert;
  bool? emailAlert;
  String? theme;
  bool? biometrics;
  String? username;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Datum({
    this.id,
    this.email,
    this.firstname,
    this.lastname,
    this.phone,
    this.country,
    this.referral,
    this.locked,
    this.pushAlert,
    this.emailAlert,
    this.theme,
    this.biometrics,
    this.username,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  @override
  String toString() {
    return 'Datum(id: $id, email: $email, firstname: $firstname, lastname: $lastname, phone: $phone, country: $country, referral: $referral, locked: $locked, pushAlert: $pushAlert, emailAlert: $emailAlert, theme: $theme, biometrics: $biometrics, username: $username, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  factory Datum.fromMap(Map data) {
    final normalizedData = Map<String, dynamic>.from(data);

    return Datum(
      id: normalizedData['_id'] as String?,
      email: normalizedData['email'] as String?,
      firstname: normalizedData['firstname'] as String?,
      lastname: normalizedData['lastname'] as String?,
      phone: normalizedData['phone'] as String?,
      country: normalizedData['country'] as String?,
      referral: normalizedData['referral'] == null
          ? null
          : Referral.fromMap(
              Map<String, dynamic>.from(normalizedData['referral'] as Map)),
      locked: normalizedData['locked'] as bool?,
      pushAlert: normalizedData['pushAlert'] as bool?,
      emailAlert: normalizedData['emailAlert'] as bool?,
      theme: normalizedData['theme'] as String?,
      biometrics: normalizedData['biometrics'] as bool?,
      username: normalizedData['username'] as String?,
      createdAt: normalizedData['createdAt'] == null
          ? null
          : DateTime.parse(normalizedData['createdAt'] as String),
      updatedAt: normalizedData['updatedAt'] == null
          ? null
          : DateTime.parse(normalizedData['updatedAt'] as String),
      v: normalizedData['__v'] as int?,
    );
  }

  Map<String, dynamic> toMap() => {
        '_id': id,
        'email': email,
        'firstname': firstname,
        'lastname': lastname,
        'phone': phone,
        'country': country,
        'referral': referral?.toMap(),
        'locked': locked,
        'pushAlert': pushAlert,
        'emailAlert': emailAlert,
        'theme': theme,
        'biometrics': biometrics,
        'username': username,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Datum].
  factory Datum.fromJson(String data) {
    return Datum.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Datum] to a JSON string.
  String toJson() => json.encode(toMap());

  Datum copyWith({
    String? id,
    String? email,
    String? firstname,
    String? lastname,
    String? phone,
    String? country,
    Referral? referral,
    bool? locked,
    bool? pushAlert,
    bool? emailAlert,
    String? theme,
    bool? biometrics,
    String? username,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return Datum(
      id: id ?? this.id,
      email: email ?? this.email,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      referral: referral ?? this.referral,
      locked: locked ?? this.locked,
      pushAlert: pushAlert ?? this.pushAlert,
      emailAlert: emailAlert ?? this.emailAlert,
      theme: theme ?? this.theme,
      biometrics: biometrics ?? this.biometrics,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
