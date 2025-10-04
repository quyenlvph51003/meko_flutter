class PageBody {
  PageBody({
    this.page,
    this.pageSize,
  });

  PageBody.fromJson(dynamic json) {
    page = json['page'];
    pageSize = json['page_size'];
  }

  num? page;
  num? pageSize;

  PageBody copyWith({
    num? page,
    num? pageSize,
  }) =>
      PageBody(
        page: page ?? this.page,
        pageSize: pageSize ?? this.pageSize,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page'] = page;
    map['page_size'] = pageSize;
    return map;
  }
}
