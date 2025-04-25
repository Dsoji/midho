import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import 'wallet.dart';

class UserProfileModel {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? email;

  @HiveField(2)
  String? firstname;

  @HiveField(3)
  String? lastname;

  @HiveField(4)
  String? phone;

  @HiveField(5)
  String? country;

  @HiveField(6)
  bool? locked;

  @HiveField(7)
  bool? pushAlert;

  @HiveField(8)
  bool? emailAlert;

  @HiveField(9)
  String? theme;

  @HiveField(10)
  bool? biometrics;

  @HiveField(11)
  String? username;

  @HiveField(12)
  DateTime? createdAt;

  @HiveField(13)
  DateTime? updatedAt;

  @HiveField(14)
  Wallet? wallet;

  UserProfileModel({
    this.id,
    this.email,
    this.firstname,
    this.lastname,
    this.phone,
    this.country,
    this.locked,
    this.pushAlert,
    this.emailAlert,
    this.theme,
    this.biometrics,
    this.username,
    this.createdAt,
    this.updatedAt,
    this.wallet,
  });

  @override
  String toString() {
    return 'UserProfileModel(id: $id, email: $email, firstname: $firstname, lastname: $lastname, phone: $phone, country: $country, locked: $locked, pushAlert: $pushAlert, emailAlert: $emailAlert, theme: $theme, biometrics: $biometrics, username: $username, createdAt: $createdAt, updatedAt: $updatedAt, id: $id, wallet: $wallet)';
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> data) {
    return UserProfileModel(
      id: data['_id'] as String?,
      email: data['email'] as String?,
      firstname: data['firstname'] as String?,
      lastname: data['lastname'] as String?,
      phone: data['phone'] as String?,
      country: data['country'] as String?,
      locked: data['locked'] as bool?,
      pushAlert: data['pushAlert'] as bool?,
      emailAlert: data['emailAlert'] as bool?,
      theme: data['theme'] as String?,
      biometrics: data['biometrics'] as bool?,
      username: data['username'] as String?,
      createdAt: data['createdAt'] == null
          ? null
          : DateTime.parse(data['createdAt'] as String),
      updatedAt: data['updatedAt'] == null
          ? null
          : DateTime.parse(data['updatedAt'] as String),
      wallet: data['wallet'] is Map
          ? Wallet.fromMap(
              Map<String, dynamic>.fromEntries(
                (data['wallet'] as Map).entries.map(
                      (e) => MapEntry(e.key.toString(), e.value),
                    ),
              ),
            )
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        '_id': id,
        'email': email,
        'firstname': firstname,
        'lastname': lastname,
        'phone': phone,
        'country': country,
        'locked': locked,
        'pushAlert': pushAlert,
        'emailAlert': emailAlert,
        'theme': theme,
        'biometrics': biometrics,
        'username': username,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'id': id,
        'wallet': wallet?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UserProfileModel].
  factory UserProfileModel.fromJson(String data) {
    return UserProfileModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UserProfileModel] to a JSON string.
  String toJson() => json.encode(toMap());

  UserProfileModel copyWith({
    String? id,
    String? email,
    String? firstname,
    String? lastname,
    String? phone,
    String? country,
    bool? locked,
    bool? pushAlert,
    bool? emailAlert,
    String? theme,
    bool? biometrics,
    String? username,
    DateTime? createdAt,
    DateTime? updatedAt,
    Wallet? wallet,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      locked: locked ?? this.locked,
      pushAlert: pushAlert ?? this.pushAlert,
      emailAlert: emailAlert ?? this.emailAlert,
      theme: theme ?? this.theme,
      biometrics: biometrics ?? this.biometrics,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      wallet: wallet ?? this.wallet,
    );
  }
}
