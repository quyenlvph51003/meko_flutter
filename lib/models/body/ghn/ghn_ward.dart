class GHNWard {
  final String wardCode;
  final int districtId;
  final String wardName;
  final String? nameExtension;

  GHNWard({
    required this.wardCode,
    required this.districtId,
    required this.wardName,
    this.nameExtension,
  });

  factory GHNWard.fromJson(Map<String, dynamic> json) {
    return GHNWard(
      wardCode: json['WardCode'] as String,
      districtId: json['DistrictID'] as int,
      wardName: json['WardName'] as String,
      nameExtension: (json['NameExtension'] as List?)?.join(', '),
    );
  }

  Map<String, dynamic> toJson() => {
    'WardCode': wardCode,
    'DistrictID': districtId,
    'WardName': wardName,
    'NameExtension': nameExtension,
  };

  @override
  String toString() => wardName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GHNWard && wardCode == other.wardCode;

  @override
  int get hashCode => wardCode.hashCode;
}
