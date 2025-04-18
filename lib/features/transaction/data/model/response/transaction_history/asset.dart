import 'dart:convert';

class Asset {
  String? id;
  String? type;
  String? name;
  String? symbol;
  String? baseCurrency;
  String? exchangeCurrency;
  int? moq;
  int? rate;
  bool? active;
  String? category;
  int? ecodeRate;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Asset({
    this.id,
    this.type,
    this.name,
    this.symbol,
    this.baseCurrency,
    this.exchangeCurrency,
    this.moq,
    this.rate,
    this.active,
    this.category,
    this.ecodeRate,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  @override
  String toString() {
    return 'Asset(id: $id, type: $type, name: $name, baseCurrency: $baseCurrency, exchangeCurrency: $exchangeCurrency, moq: $moq, rate: $rate, active: $active, category: $category, ecodeRate: $ecodeRate, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  factory Asset.fromMap(Map<String, dynamic> data) => Asset(
        id: data['_id'] as String?,
        type: data['type'] as String?,
        name: data['name'] as String?,
        symbol: data['symbol'] as String?,
        baseCurrency: data['baseCurrency'] as String?,
        exchangeCurrency: data['exchangeCurrency'] as String?,
        moq: data['moq'] as int?,
        rate: data['rate'] as int?,
        active: data['active'] as bool?,
        category: data['category'] as String?,
        ecodeRate: data['ecodeRate'] as int?,
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
        'type': type,
        'name': name,
        'baseCurrency': baseCurrency,
        'exchangeCurrency': exchangeCurrency,
        'moq': moq,
        'rate': rate,
        'active': active,
        'category': category,
        'ecodeRate': ecodeRate,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Asset].
  factory Asset.fromJson(String data) {
    return Asset.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Asset] to a JSON string.
  String toJson() => json.encode(toMap());

  Asset copyWith({
    String? id,
    String? type,
    String? name,
    String? symbol,
    String? baseCurrency,
    String? exchangeCurrency,
    int? moq,
    int? rate,
    bool? active,
    String? category,
    int? ecodeRate,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return Asset(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      exchangeCurrency: exchangeCurrency ?? this.exchangeCurrency,
      moq: moq ?? this.moq,
      rate: rate ?? this.rate,
      active: active ?? this.active,
      category: category ?? this.category,
      ecodeRate: ecodeRate ?? this.ecodeRate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
