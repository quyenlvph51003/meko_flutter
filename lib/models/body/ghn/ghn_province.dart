class GHNProvince {
  final int provinceId;
  final String provinceName;
  final String? nameExtension;
  final int? countryId;

  GHNProvince({
    required this.provinceId,
    required this.provinceName,
    this.nameExtension,
    this.countryId,
  });

  factory GHNProvince.fromJson(Map<String, dynamic> json) {
    return GHNProvince(
      provinceId: json['ProvinceID'] as int,
      provinceName: json['ProvinceName'] as String,
      nameExtension: (json['NameExtension'] as List?)?.join(', '),
      countryId: json['CountryID'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'ProvinceID': provinceId,
    'ProvinceName': provinceName,
    'NameExtension': nameExtension,
    'CountryID': countryId,
  };

  @override
  String toString() => provinceName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GHNProvince && provinceId == other.provinceId;

  @override
  int get hashCode => provinceId.hashCode;
}
