class StickerBody {
  StickerBody({
    this.page,
    this.pageSize,
    this.catid,
  });

  StickerBody.fromJson(dynamic json) {
    page = json['Page'];
    pageSize = json['PageSize'];
    catid = json['Catid'];
  }

  num? page;
  num? pageSize;
  num? catid;

  StickerBody copyWith({
    num? page,
    num? pageSize,
    num? catid,
  }) =>
      StickerBody(
        page: page ?? this.page,
        pageSize: pageSize ?? this.pageSize,
        catid: catid ?? this.catid,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Page'] = page;
    map['PageSize'] = pageSize;
    map['Catid'] = catid;
    return map;
  }
}
