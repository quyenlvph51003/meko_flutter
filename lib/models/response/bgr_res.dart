class BgrRes {
  BgrRes({
    this.data,
    this.status,
    this.errorMessage,
  });

  BgrRes.fromJson(dynamic json) {
    if (json['Data'] != null) {
      data = [];
      json['Data'].forEach((v) {
        data?.add(BackgroundData.fromJson(v));
      });
    }
    status = json['Status'];
    errorMessage = json['ErrorMessage'];
  }

  List<BackgroundData>? data;
  num? status;
  String? errorMessage;

  BgrRes copyWith({
    List<BackgroundData>? data,
    num? status,
    String? errorMessage,
  }) {
    return BgrRes(
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

class BackgroundData {
  BackgroundData({
    this.id,
    this.catName,
    this.iconPath,
    this.showAdmod,
    this.background,
  });

  BackgroundData.fromJson(dynamic json) {
    id = json['Id'];
    catName = json['CatName'];
    iconPath = json['IconPath'];
    showAdmod = json['Show_admod'];
    if (json['Background'] != null) {
      background = [];
      json['Background'].forEach((v) {
        background?.add(Background.fromJson(v));
      });
    }
  }

  num? id;
  String? catName;
  String? iconPath;
  bool? showAdmod;
  List<Background>? background;

  BackgroundData copyWith({
    num? id,
    String? catName,
    String? iconPath,
    bool? showAdmod,
    List<Background>? background,
  }) {
    return BackgroundData(
      id: id ?? this.id,
      catName: catName ?? this.catName,
      iconPath: iconPath ?? this.iconPath,
      showAdmod: showAdmod ?? this.showAdmod,
      background: background ?? this.background,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = id;
    map['CatName'] = catName;
    map['IconPath'] = iconPath;
    map['Show_admod'] = showAdmod;
    if (background != null) {
      map['Background'] = background?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Background {
  Background({
    this.id,
    this.catId,
    this.name,
    this.thumbPath,
    this.imgPath,
  });

  Background.fromJson(dynamic json) {
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

  Background copyWith({
    num? id,
    num? catId,
    String? name,
    String? thumbPath,
    String? imgPath,
  }) =>
      Background(
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
