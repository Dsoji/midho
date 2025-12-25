import 'dart:convert';

import 'data.dart';

class PlatformDetails {
  bool? status;
  String? message;
  Data? data;

  PlatformDetails({this.status, this.message, this.data});

  @override
  String toString() {
    return 'PlatformDetails(status: $status, message: $message, data: $data)';
  }

  factory PlatformDetails.fromMap(Map<String, dynamic> data) {
    return PlatformDetails(
      status: data['status'] as bool?,
      message: data['message'] as String?,
      data: data['data'] == null
          ? null
          : Data.fromMap(data['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'message': message,
        'data': data?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PlatformDetails].
  factory PlatformDetails.fromJson(String data) {
    return PlatformDetails.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PlatformDetails] to a JSON string.
  String toJson() => json.encode(toMap());

  PlatformDetails copyWith({
    bool? status,
    String? message,
    Data? data,
  }) {
    return PlatformDetails(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
