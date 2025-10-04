class ItemSticker {
  int id;
  double centerX;
  double? angle;
  double centerY;
  String image;
  double width;
  double height;
  bool? isFlip;

  ItemSticker({
    required this.id,
    required this.centerX,
    this.angle,
    required this.centerY,
    required this.image,
    required this.width,
    required this.height,
    this.isFlip,
  });

  ItemSticker copyWith({
    int? id,
    double? centerX,
    double? angle,
    double? centerY,
    String? image,
    double? width,
    double? height,
    bool? isFlip,
  }) {
    return ItemSticker(
      centerX: centerX ?? this.centerX,
      angle: angle ?? this.angle,
      centerY: centerY ?? this.centerY,
      image: image ?? this.image,
      width: width ?? this.width,
      height: height ?? this.height,
      id: id ?? this.id,
      isFlip: isFlip ?? this.isFlip,
    );
  }
}
