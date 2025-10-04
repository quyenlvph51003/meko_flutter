class CollageCatRes {
  CollageCatRes({
    this.data,
    this.status,
    this.errorMessage,
  });

  CollageCatRes.fromJson(dynamic json) {
    if (json['Data'] != null) {
      data = [];
      json['Data'].forEach((v) {
        data?.add(ItemCategory.fromJson(v));
      });
    }
    status = json['Status'];
    errorMessage = json['ErrorMessage'];
  }

  List<ItemCategory>? data;
  num? status;
  String? errorMessage;

  CollageCatRes copyWith({
    List<ItemCategory>? data,
    num? status,
    String? errorMessage,
  }) {
    return CollageCatRes(
      data: data ?? this.data,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['Data'] = data?.map((v) => v.toJson()).toList();
    }
    map['Status'] = status;
    map['ErrorMessage'] = errorMessage;
    return map;
  }
}

class ItemCategory {
  ItemCategory({
    this.id,
    this.catName,
  });

  ItemCategory.fromJson(dynamic json) {
    id = json['Id'];
    catName = json['CatName'];
  }

  num? id;
  String? catName;

  ItemCategory copyWith({num? id, String? catName}) {
    return ItemCategory(
      id: id ?? this.id,
      catName: catName ?? this.catName,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = id;
    map['CatName'] = catName;
    return map;
  }
}
