import 'dart:convert';

class File {
  String? originalname;
  String? mimetype;
  int? size;
  String? path;

  File({this.originalname, this.mimetype, this.size, this.path});

  @override
  String toString() {
    return 'File(originalname: $originalname, mimetype: $mimetype, size: $size, path: $path)';
  }

  factory File.fromMap(Map<String, dynamic> data) => File(
        originalname: data['originalname'] as String?,
        mimetype: data['mimetype'] as String?,
        size: data['size'] as int?,
        path: data['path'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'originalname': originalname,
        'mimetype': mimetype,
        'size': size,
        'path': path,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [File].
  factory File.fromJson(String data) {
    return File.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [File] to a JSON string.
  String toJson() => json.encode(toMap());

  File copyWith({
    String? originalname,
    String? mimetype,
    int? size,
    String? path,
  }) {
    return File(
      originalname: originalname ?? this.originalname,
      mimetype: mimetype ?? this.mimetype,
      size: size ?? this.size,
      path: path ?? this.path,
    );
  }
}
