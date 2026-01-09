import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class PostUpdateRequest {
  int? postId;
  String? title;
  String? description;
  List<int>? categories;
  String? wardCode;
  String? provinceCode;
  String? address;
  double? price;
  String? phoneNumber;
  List<String>? oldImages;
  List<XFile>? images;
  int? oldProductPercent;

  PostUpdateRequest({
    this.postId,
    this.title,
    this.description,
    this.categories,
    this.wardCode,
    this.provinceCode,
    this.address,
    this.price,
    this.phoneNumber,
    this.oldImages,
    this.images,
    this.oldProductPercent,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (postId != null) data['postId'] = postId;
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (categories != null) data['categories'] = categories;
    if (wardCode != null) data['wardCode'] = wardCode;
    if (provinceCode != null) data['provinceCode'] = provinceCode;
    if (address != null) data['address'] = address;
    if (price != null) data['price'] = price;
    if (phoneNumber != null) data['phoneNumber'] = phoneNumber;
    if (oldImages != null) data['oldImages'] = oldImages;
    if (oldProductPercent != null) data['oldProductPercent'] = oldProductPercent;
    return data;
  }

  /// Build FormData kiểu:
  /// data: JSON string
  /// images: multiple files with same key 'images'
  Future<FormData> buildPostUpdateFormData() async {
    final Map<String, dynamic> formMap = {};

    // 'data' là JSON string chứa các trường text
    formMap['data'] = jsonEncode(toJson());

    // images là danh sách MultipartFile (cùng key 'images')
    if (images != null && images!.isNotEmpty) {
      final List<MultipartFile> fileList = [];
      for (final XFile x in images!) {
        final file = File(x.path);
        if (await file.exists()) {
          fileList.add(
            await MultipartFile.fromFile(
              x.path,
              filename: p.basename(x.path),
              // contentType: MediaType('image', 'jpeg'), // nếu cần import package:http_parser
            ),
          );
        }
      }
      // Gán danh sách file vào key 'images' — Dio sẽ gửi nhiều phần images: file1, images: file2 ...
      formMap['images'] = fileList;
    }

    return FormData.fromMap(formMap);
  }
}
