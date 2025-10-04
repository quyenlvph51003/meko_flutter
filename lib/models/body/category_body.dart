class CategoryBody {
  CategoryBody({
    this.page,
    this.pageSize,
    this.catid,
  });

  CategoryBody.fromJson(dynamic json) {
    page = json['page'];
    pageSize = json['page_size'];
    catid = json['Catid'];
  }

  num? page;
  num? pageSize;
  num? catid;

  CategoryBody copyWith({
    num? page,
    num? pageSize,
    num? catid,
  }) =>
      CategoryBody(
        page: page ?? this.page,
        pageSize: pageSize ?? this.pageSize,
        catid: catid ?? this.catid,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page'] = page;
    map['page_size'] = pageSize;
    map['Catid'] = catid;
    return map;
  }
}
