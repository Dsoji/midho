import 'dart:convert';

class Pagination {
  int? page;
  int? limit;
  int? pages;

  Pagination({this.page, this.limit, this.pages});

  @override
  String toString() {
    return 'Pagination(page: $page, limit: $limit, pages: $pages)';
  }

  factory Pagination.fromMap(Map<String, dynamic> data) => Pagination(
        page: (data['page'] as num?)?.toInt(),
        limit: (data['limit'] as num?)?.toInt(),
        pages: (data['pages'] as num?)?.toInt(),
      );

  Map<String, dynamic> toMap() => {
        'page': page,
        'limit': limit,
        'pages': pages,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Pagination].
  factory Pagination.fromJson(String data) {
    return Pagination.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Pagination] to a JSON string.
  String toJson() => json.encode(toMap());

  Pagination copyWith({
    int? page,
    int? limit,
    int? pages,
  }) {
    return Pagination(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      pages: pages ?? this.pages,
    );
  }
}
