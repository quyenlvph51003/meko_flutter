import 'package:flutter/material.dart';

class ItemText {
  int id;
  double centerX;
  double? angle;
  double centerY;
  String text;
  double width;
  double height;
  double? opacity;
  double? opacityBgr;
  double? size;
  double? shadowX;
  double? shadowY;
  double? blurRadius;
  double? radiusBgr;
  bool? isFlip;
  String? fontFamily;
  Color colorText;
  Color? colorShadow;
  Color? colorBgr;
  TextAlign? textAlign;

  ItemText({
    required this.id,
    required this.centerX,
    this.angle,
    this.textAlign,
    this.shadowX,
    this.shadowY,
    this.blurRadius,
    this.opacity = 1,
    required this.centerY,
    required this.text,
    required this.width,
    required this.height,
    this.isFlip,
    this.radiusBgr,
    this.size,
    required this.colorText,
    this.colorShadow,
    this.fontFamily,
    this.colorBgr,
    this.opacityBgr,
  });

  ItemText copyWith({
    int? id,
    double? centerX,
    double? angle,
    double? centerY,
    String? text,
    double? width,
    double? opacityText,
    double? height,
    double? opacity,
    double? shadowX,
    double? shadowY,
    double? size,
    double? radiusBgr,
    bool? isFlip,
    String? fontFamily,
    TextAlign? textAlign,
    Color? colorShadow,
    Color? colorText,
    Color? colorBgr,
  }) {
    return ItemText(
      radiusBgr: radiusBgr ?? this.radiusBgr,
      centerX: centerX ?? this.centerX,
      angle: angle ?? this.angle,
      centerY: centerY ?? this.centerY,
      text: text ?? this.text,
      width: width ?? this.width,
      height: height ?? this.height,
      id: id ?? this.id,
      colorText: colorText ?? this.colorText,
      opacity: opacity ?? this.opacity,
      textAlign: textAlign ?? this.textAlign,
      isFlip: isFlip ?? this.isFlip,
      fontFamily: fontFamily ?? this.fontFamily,
      shadowX: shadowX ?? this.shadowX,
      opacityBgr: opacityText ?? this.opacityBgr,
      shadowY: shadowY ?? this.shadowY,
      colorShadow: colorShadow ?? this.colorShadow,
      blurRadius: blurRadius ?? this.blurRadius,
      colorBgr: colorBgr ?? this.colorBgr,
      size: size ?? this.size,
    );
  }
}
