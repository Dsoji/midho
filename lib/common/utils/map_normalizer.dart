Map<String, dynamic> normalizeMap(dynamic raw) {
  final result = <String, dynamic>{};

  if (raw is Map) {
    raw.forEach((key, value) {
      final normalizedKey = key.toString();

      if (value is Map) {
        result[normalizedKey] = normalizeMap(value);
      } else if (value is List) {
        result[normalizedKey] =
            value.map((e) => e is Map ? normalizeMap(e) : e).toList();
      } else {
        result[normalizedKey] = value;
      }
    });
  }

  return result;
}
