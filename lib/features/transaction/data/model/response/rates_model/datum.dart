import 'dart:convert';

class RateData {
  String? id;
  String? type;
  String? name;
  String? baseCurrency;
  String? exchangeCurrency;
  int? moq;
  double? rate;
  bool? active;
  String? category;
  int? ecodeRate;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? datumFor;
  String? icon;
  String? symbol;
  String? address;

  RateData({
    this.id,
    this.type,
    this.name,
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
    this.datumFor,
    this.icon,
    this.symbol,
    this.address,
  });

  @override
  String toString() {
    return 'Datum(id: $id, type: $type, name: $name, baseCurrency: $baseCurrency, exchangeCurrency: $exchangeCurrency, moq: $moq, rate: $rate, active: $active, category: $category, ecodeRate: $ecodeRate, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, datumFor: $datumFor, icon: $icon, symbol: $symbol, address: $address)';
  }

  factory RateData.fromMap(Map<String, dynamic> data) => RateData(
        id: data['_id'] as String?,
        type: data['type'] as String?,
        name: data['name'] as String?,
        baseCurrency: data['baseCurrency'] as String?,
        exchangeCurrency: data['exchangeCurrency'] as String?,
        moq: data['moq'] as int?,
        rate: (data['rate'] as num?)?.toDouble(),
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
        datumFor: data['for'] as String?,
        icon: data['icon'] as String?,
        symbol: data['symbol'] as String?,
        address: data['address'] as String?,
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
        'for': datumFor,
        'icon': icon,
        'symbol': symbol,
        'address': address,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Datum].
  factory RateData.fromJson(String data) {
    return RateData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Datum] to a JSON string.
  String toJson() => json.encode(toMap());

  RateData copyWith({
    String? id,
    String? type,
    String? name,
    String? baseCurrency,
    String? exchangeCurrency,
    int? moq,
    double? rate,
    bool? active,
    String? category,
    int? ecodeRate,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    String? datumFor,
    String? icon,
    String? symbol,
    String? address,
  }) {
    return RateData(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
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
      datumFor: datumFor ?? this.datumFor,
      icon: icon ?? this.icon,
      symbol: symbol ?? this.symbol,
      address: address ?? this.address,
    );
  }
}
