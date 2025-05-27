import 'dart:convert';

import 'bank.dart';

class User {
  String? id;
  String? email;
  String? firstname;
  String? lastname;
  String? phone;
  String? country;
  bool? locked;
  bool? pushAlert;
  bool? emailAlert;
  String? theme;
  bool? biometrics;
  String? username;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? fcmToken;
  List<Bank>? banks;

  User({
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
    this.v,
    this.fcmToken,
    this.banks,
  });

  @override
  String toString() {
    return 'User(id: $id, email: $email, firstname: $firstname, lastname: $lastname, phone: $phone, country: $country, locked: $locked, pushAlert: $pushAlert, emailAlert: $emailAlert, theme: $theme, biometrics: $biometrics, username: $username, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, fcmToken: $fcmToken, banks: $banks)';
  }

  factory User.fromMap(Map<String, dynamic> data) => User(
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
        v: data['__v'] as int?,
        fcmToken: data['fcmToken'] as String?,
        banks: (data['banks'] as List<dynamic>?)
            ?.map((e) => Bank.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

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
        '__v': v,
        'fcmToken': fcmToken,
        'banks': banks?.map((e) => e.toMap()).toList(),
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
    bool? locked,
    bool? pushAlert,
    bool? emailAlert,
    String? theme,
    bool? biometrics,
    String? username,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    String? fcmToken,
    List<Bank>? banks,
  }) {
    return User(
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
      v: v ?? this.v,
      fcmToken: fcmToken ?? this.fcmToken,
      banks: banks ?? this.banks,
    );
  }
}
