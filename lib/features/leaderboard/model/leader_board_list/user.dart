import 'dart:convert';

import 'bank.dart';

class User {
  String? id;
  String? email;
  String? firstname;
  String? lastname;
  String? phone;
  String? country;
  String? referral;
  bool? locked;
  bool? pushAlert;
  bool? emailAlert;
  String? theme;
  bool? biometrics;
  String? fcmToken;
  String? device;
  String? medium;
  bool? deleted;
  bool? ecode;
  List<Bank>? banks;
  String? username;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  User({
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
    this.fcmToken,
    this.device,
    this.medium,
    this.deleted,
    this.ecode,
    this.banks,
    this.username,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  @override
  String toString() {
    return 'User(id: $id, email: $email, firstname: $firstname, lastname: $lastname, phone: $phone, country: $country, referral: $referral, locked: $locked, pushAlert: $pushAlert, emailAlert: $emailAlert, theme: $theme, biometrics: $biometrics, fcmToken: $fcmToken, device: $device, medium: $medium, deleted: $deleted, ecode: $ecode, banks: $banks, username: $username, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  factory User.fromMap(Map<String, dynamic> data) => User(
        id: data['_id'] as String?,
        email: data['email'] as String?,
        firstname: data['firstname'] as String?,
        lastname: data['lastname'] as String?,
        phone: data['phone'] as String?,
        country: data['country'] as String?,
        referral: data['referral'] as String?,
        locked: data['locked'] as bool?,
        pushAlert: data['pushAlert'] as bool?,
        emailAlert: data['emailAlert'] as bool?,
        theme: data['theme'] as String?,
        biometrics: data['biometrics'] as bool?,
        fcmToken: data['fcmToken'] as String?,
        device: data['device'] as String?,
        medium: data['medium'] as String?,
        deleted: data['deleted'] as bool?,
        ecode: data['ecode'] as bool?,
        banks: (data['banks'] as List<dynamic>?)
            ?.map((e) => Bank.fromMap(e as Map<String, dynamic>))
            .toList(),
        username: data['username'] as String?,
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        updatedAt: data['updatedAt'] == null
            ? null
            : DateTime.parse(data['updatedAt'] as String),
        v: data['__v'] as int?,
      );

  Map<String, dynamic> toMap() => {
        '_id': id,
        'email': email,
        'firstname': firstname,
        'lastname': lastname,
        'phone': phone,
        'country': country,
        'referral': referral,
        'locked': locked,
        'pushAlert': pushAlert,
        'emailAlert': emailAlert,
        'theme': theme,
        'biometrics': biometrics,
        'fcmToken': fcmToken,
        'device': device,
        'medium': medium,
        'deleted': deleted,
        'ecode': ecode,
        'banks': banks?.map((e) => e.toMap()).toList(),
        'username': username,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [User].
  factory User.fromJson(String data) {
    return User.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [User] to a JSON string.
  String toJson() => json.encode(toMap());

  User copyWith({
    String? id,
    String? email,
    String? firstname,
    String? lastname,
    String? phone,
    String? country,
    String? referral,
    bool? locked,
    bool? pushAlert,
    bool? emailAlert,
    String? theme,
    bool? biometrics,
    String? fcmToken,
    String? device,
    String? medium,
    bool? deleted,
    bool? ecode,
    List<Bank>? banks,
    String? username,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return User(
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
      fcmToken: fcmToken ?? this.fcmToken,
      device: device ?? this.device,
      medium: medium ?? this.medium,
      deleted: deleted ?? this.deleted,
      ecode: ecode ?? this.ecode,
      banks: banks ?? this.banks,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
