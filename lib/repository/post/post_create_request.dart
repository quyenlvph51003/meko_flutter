import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class PostCreateRequest {
  String? title;
  String? description;
  List<int>? categories;
  int? userId;
  String? wardCode;
  String? provinceCode;
  String? address;
  double? price;
  String? phoneNumber;
  int? paymentId;
  List<XFile>? images;
  int? oldProductPercent;

  PostCreateRequest({
    this.title,
    this.description,
    this.categories,
    this.userId,
    this.wardCode,
    this.provinceCode,
    this.address,
    this.price,
    this.phoneNumber,
    this.paymentId,
    this.images,
    this.oldProductPercent,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (categories != null) data['categories'] = categories;
    if (userId != null) data['userId'] = userId;
    if (wardCode != null) data['wardCode'] = wardCode;
    if (provinceCode != null) data['provinceCode'] = provinceCode;
    if (address != null) data['address'] = address;
    if (price != null) data['price'] = price;
    if (phoneNumber != null) data['phoneNumber'] = phoneNumber;
    if (paymentId != null) data['paymentId'] = paymentId;
    if (oldProductPercent != null) data['oldProductPercent'] = oldProductPercent;
    return data;
  }

  Future<FormData> buildPostCreateFormData() async {
    final Map<String, dynamic> formMap = {};

    formMap['data'] = jsonEncode(toJson());

    if (images != null && images!.isNotEmpty) {
      final List<MultipartFile> fileList = [];
      for (final XFile x in images!) {
        final file = File(x.path);
        if (await file.exists()) {
          fileList.add(await MultipartFile.fromFile(x.path, filename: p.basename(x.path)));
        }
      }
      formMap['images'] = fileList;
    }

    return FormData.fromMap(formMap);
  }
}
