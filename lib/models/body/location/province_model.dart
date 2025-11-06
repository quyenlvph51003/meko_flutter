class ProvinceModel {
  String? code;
  String? name;
  String? nameEn;
  String? fullName;
  String? fullNameEn;
  String? codeName;
  int? administrativeUnitId;

  ProvinceModel({this.code, this.name, this.nameEn, this.fullName, this.fullNameEn, this.codeName, this.administrativeUnitId});

  ProvinceModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    nameEn = json['name_en'];
    fullName = json['full_name'];
    fullNameEn = json['full_name_en'];
    codeName = json['code_name'];
    administrativeUnitId = json['administrative_unit_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    data['full_name'] = this.fullName;
    data['full_name_en'] = this.fullNameEn;
    data['code_name'] = this.codeName;
    data['administrative_unit_id'] = this.administrativeUnitId;
    return data;
  }
}
