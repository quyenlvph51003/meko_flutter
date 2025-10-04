class ListStickersRes {
  ListStickersRes({
    this.data,
    this.status,
    this.errorMessage,
  });

  ListStickersRes.fromJson(dynamic json) {
    data = json['Data'] != null ? DataRes.fromJson(json['Data']) : null;
    status = json['Status'];
    errorMessage = json['ErrorMessage'];
  }

  DataRes? data;
  num? status;
  String? errorMessage;

  ListStickersRes copyWith({
    DataRes? data,
    num? status,
    String? errorMessage,
  }) =>
      ListStickersRes(
        data: data ?? this.data,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['Data'] = data?.toJson();
    }
    map['Status'] = status;
    map['ErrorMessage'] = errorMessage;
    return map;
  }
}

class DataRes {
  DataRes({
    this.total,
    this.pageCount,
    this.listData,
  });

  DataRes.fromJson(dynamic json) {
    total = json['Total'];
    pageCount = json['PageCount'];
    if (json['ListData'] != null) {
      listData = [];
      json['ListData'].forEach((v) {
        listData?.add(StickerItem.fromJson(v));
      });
    }
  }

  num? total;
  num? pageCount;
  List<StickerItem>? listData;

  DataRes copyWith({
    num? total,
    num? pageCount,
    List<StickerItem>? listData,
  }) =>
      DataRes(
        total: total ?? this.total,
        pageCount: pageCount ?? this.pageCount,
        listData: listData ?? this.listData,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Total'] = total;
    map['PageCount'] = pageCount;
    if (listData != null) {
      map['ListData'] = listData?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class StickerItem {
  StickerItem({
    this.id,
    this.catId,
    this.name,
    this.thumbPath,
    this.imgPath,
  });

  StickerItem.fromJson(dynamic json) {
    id = json['Id'];
    catId = json['CatId'];
    name = json['Name'];
    thumbPath = json['ThumbPath'];
    imgPath = json['ImgPath'];
  }

  num? id;
  num? catId;
  String? name;
  String? thumbPath;
  String? imgPath;

  StickerItem copyWith({
    num? id,
    num? catId,
    String? name,
    String? thumbPath,
    String? imgPath,
  }) =>
      StickerItem(
        id: id ?? this.id,
        catId: catId ?? this.catId,
        name: name ?? this.name,
        thumbPath: thumbPath ?? this.thumbPath,
        imgPath: imgPath ?? this.imgPath,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = id;
    map['CatId'] = catId;
    map['Name'] = name;
    map['ThumbPath'] = thumbPath;
    map['ImgPath'] = imgPath;
    return map;
  }
}
