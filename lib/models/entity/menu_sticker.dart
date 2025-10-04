class MenuStickerRes {
  MenuStickerRes({
    this.data,
    this.status,
    this.errorMessage,
  });

  MenuStickerRes.fromJson(dynamic json) {
    if (json['Data'] != null) {
      data = [];
      json['Data'].forEach((v) {
        data?.add(ItemMenuSticker.fromJson(v));
      });
    }
    status = json['Status'];
    errorMessage = json['ErrorMessage'];
  }

  List<ItemMenuSticker>? data;
  num? status;
  String? errorMessage;

  MenuStickerRes copyWith({
    List<ItemMenuSticker>? data,
    num? status,
    String? errorMessage,
  }) =>
      MenuStickerRes(
        data: data ?? this.data,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
      );

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

class ItemMenuSticker {
  ItemMenuSticker({
    this.id,
    this.catName,
    this.imgPath,
    this.showAdmod,
  });

  ItemMenuSticker.fromJson(dynamic json) {
    id = json['Id'];
    catName = json['CatName'];
    imgPath = json['ImgPath'];
    showAdmod = json['Show_admod'];
  }

  num? id;
  String? catName;
  String? imgPath;
  bool? showAdmod;

  ItemMenuSticker copyWith({
    num? id,
    String? catName,
    String? imgPath,
    bool? showAdmod,
  }) =>
      ItemMenuSticker(
        id: id ?? this.id,
        catName: catName ?? this.catName,
        imgPath: imgPath ?? this.imgPath,
        showAdmod: showAdmod ?? this.showAdmod,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = id;
    map['CatName'] = catName;
    map['ImgPath'] = imgPath;
    map['Show_admod'] = showAdmod;
    return map;
  }
}
