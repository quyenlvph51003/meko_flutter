class GHNDistrict {
  final int districtId;
  final int provinceId;
  final String districtName;
  final String? nameExtension;
  final int? type;
  final int? supportType;

  GHNDistrict({
    required this.districtId,
    required this.provinceId,
    required this.districtName,
    this.nameExtension,
    this.type,
    this.supportType,
  });

  factory GHNDistrict.fromJson(Map<String, dynamic> json) {
    return GHNDistrict(
      districtId: json['DistrictID'] as int,
      provinceId: json['ProvinceID'] as int,
      districtName: json['DistrictName'] as String,
      nameExtension: (json['NameExtension'] as List?)?.join(', '),
      type: json['Type'] as int?,
      supportType: json['SupportType'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'DistrictID': districtId,
    'ProvinceID': provinceId,
    'DistrictName': districtName,
    'NameExtension': nameExtension,
    'Type': type,
    'SupportType': supportType,
  };

  @override
  String toString() => districtName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GHNDistrict && districtId == other.districtId;

  @override
  int get hashCode => districtId.hashCode;
}
