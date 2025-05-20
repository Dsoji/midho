import 'dart:convert';

class User {
  String? id;
  String? email;
  String? password;
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
  List<dynamic>? banks;
  String? username;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  User({
    this.id,
    this.email,
    this.password,
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
    this.banks,
    this.username,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  @override
  String toString() {
    return 'User(id: $id, email: $email, password: $password, firstname: $firstname, lastname: $lastname, phone: $phone, country: $country, referral: $referral, locked: $locked, pushAlert: $pushAlert, emailAlert: $emailAlert, theme: $theme, biometrics: $biometrics, fcmToken: $fcmToken, device: $device, banks: $banks, username: $username, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  factory User.fromMap(Map<String, dynamic> data) => User(
        id: data['_id'] as String?,
        email: data['email'] as String?,
        password: data['password'] as String?,
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
        banks: data['banks'] as List<dynamic>?,
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
        'password': password,
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
        'banks': banks,
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
    String? password,
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
    List<dynamic>? banks,
    String? username,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
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
      banks: banks ?? this.banks,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
