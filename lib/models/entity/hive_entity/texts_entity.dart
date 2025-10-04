import 'package:hive/hive.dart';

part 'texts_entity.g.dart';

@HiveType(typeId: 6)
class TextsEntity {
  @HiveField(0)
  double? size;
  @HiveField(1)
  String? content;
  @HiveField(2)
  List<int>? loc;
  @HiveField(3)
  String? font;
  @HiveField(4)
  List<int>? style;
  @HiveField(5)
  String? idLocal;
  @HiveField(7)
  String? textAlign;
  @HiveField(8)
  String? textStyle;

  TextsEntity({
    this.size,
    this.content,
    this.loc,
    this.font,
    this.style,
    this.idLocal,
    this.textAlign,
    this.textStyle,
  });

  TextsEntity copyWith({
    double? size,
    String? content,
    List<int>? loc,
    String? font,
    List<int>? style,
    String? idLocal,
    String? textAlign,
    String? textStyle,
  }) {
    return TextsEntity(
      size: size ?? this.size,
      content: content ?? this.content,
      loc: loc ?? this.loc,
      font: font ?? this.font,
      idLocal: idLocal ?? this.idLocal,
      textAlign: textAlign ?? this.textAlign,
      textStyle: textStyle ?? this.textStyle,
    );
  }

  TextsEntity.fromJson(dynamic json) {
    idLocal = json['idByDate'];
    size = json['size'];
    content = json['content'];
    textAlign = json['textAlign'];
    textStyle = json['textStyle'];
    loc = json['loc'] != null ? json['loc'].cast<int>() : [];
    font = json['font'];
    style = json['style'] != null ? json['style'].cast<int>() : [];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['size'] = size;
    map['content'] = content;
    map['loc'] = loc;
    map['font'] = font;
    map['style'] = style;
    map['idByDate'] = idLocal;
    map['textAlign'] = textAlign;
    map['textStyle'] = textStyle;
    return map;
  }
}
