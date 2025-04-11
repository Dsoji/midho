import 'dart:convert';

import 'file.dart';

class UploadResponse {
  List<File>? files;

  UploadResponse({this.files});

  @override
  String toString() => 'UploadResponse(files: $files)';

  factory UploadResponse.fromMap(Map<String, dynamic> data) {
    return UploadResponse(
      files: (data['files'] as List<dynamic>?)
          ?.map((e) => File.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'files': files?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UploadResponse].
  factory UploadResponse.fromJson(String data) {
    return UploadResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UploadResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  UploadResponse copyWith({
    List<File>? files,
  }) {
    return UploadResponse(
      files: files ?? this.files,
    );
  }
}
