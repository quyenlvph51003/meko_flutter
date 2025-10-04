class StickerAndBgrRes {
  StickerAndBgrRes({
    this.data,
    this.status,
    this.errorMessage,
  });

  StickerAndBgrRes.fromJson(dynamic json) {
    if (json['Data'] != null) {
      data = [];
      json['Data'].forEach((v) {
        data?.add(StickerAndBgr.fromJson(v));
      });
    }
    status = json['Status'];
    errorMessage = json['ErrorMessage'];
  }

  List<StickerAndBgr>? data;
  num? status;
  String? errorMessage;

  StickerAndBgrRes copyWith({
    List<StickerAndBgr>? data,
    num? status,
    String? errorMessage,
  }) =>
      StickerAndBgrRes(
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

class StickerAndBgr {
  StickerAndBgr({
    this.id,
    this.title,
    this.imgPath,
    this.type,
    this.itemCount,
    this.showAdmod,
  });

  StickerAndBgr.fromJson(dynamic json) {
    id = json['Id'];
    title = json['Title'];
    imgPath = json['ImgPath'];
    type = json['Type'];
    itemCount = json['ItemCount'];
    showAdmod = json['Show_admod'];
  }

  num? id;
  String? title;
  String? imgPath;
  num? type;
  num? itemCount;
  bool? showAdmod;

  StickerAndBgr copyWith({
    num? id,
    String? title,
    String? imgPath,
    num? type,
    num? itemCount,
    bool? showAdmod,
  }) =>
      StickerAndBgr(
        id: id ?? this.id,
        title: title ?? this.title,
        imgPath: imgPath ?? this.imgPath,
        type: type ?? this.type,
        itemCount: itemCount ?? this.itemCount,
        showAdmod: showAdmod ?? this.showAdmod,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = id;
    map['Title'] = title;
    map['ImgPath'] = imgPath;
    map['Type'] = type;
    map['ItemCount'] = itemCount;
    map['Show_admod'] = showAdmod;
    return map;
  }
}
