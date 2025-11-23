import 'dart:ui';

import 'package:flutter/material.dart';

enum PostStatus { PENDING, APPROVED, HIDDEN, VIOLATION, REJECTED, EXPIRED }

Map<PostStatus, String> postStatusMapStr = {
  PostStatus.PENDING: 'PENDING',
  PostStatus.APPROVED: 'APPROVED',
  PostStatus.HIDDEN: 'HIDDEN',
  PostStatus.VIOLATION: 'VIOLATION',
  PostStatus.REJECTED: 'REJECTED',
  PostStatus.EXPIRED: 'EXPIRED',
};

Map<PostStatus, Color> postStatusColor = {
  PostStatus.PENDING: Colors.orange, // Chờ duyệt
  PostStatus.APPROVED: Colors.green, // Đang hiển thị
  PostStatus.HIDDEN: Colors.grey, // Từ chối / Ẩn
  PostStatus.VIOLATION: Colors.red, // Vi phạm
  PostStatus.REJECTED: Colors.blueGrey, // Đã ẩn
  PostStatus.EXPIRED: Colors.blueGrey, // Đã ẩn
};

Map<PostStatus, String> postStatusMapViStr = {
  PostStatus.PENDING: 'Đang chờ duyệt',
  PostStatus.APPROVED: 'Đang hiển thị',
  PostStatus.HIDDEN: 'Đã Ẩn',
  PostStatus.VIOLATION: 'Vi phạm',
  PostStatus.REJECTED: 'Từ chối',
  PostStatus.EXPIRED: 'Hết hạn',
};

Map<String, Color> postStatusStrColor = {
  'PENDING': Colors.orange, // Chờ duyệt
  'APPROVED': Colors.green, // Đang hiển thị
  'HIDDEN': Colors.grey, // Từ chối / Ẩn
  'VIOLATION': Colors.red, // Vi phạm
  'REJECTED': Colors.blueGrey, // Đã ẩn
  'EXPIRED': Colors.blueGrey, // Đã ẩn
};

Map<String, String> postStatusStrMapViStr = {
  'PENDING': 'Đang chờ duyệt',
  'APPROVED': 'Đang hiển thị',
  'HIDDEN': 'Đã Ẩn',
  'VIOLATION': 'Vi phạm',
  'REJECTED': 'Từ chối',
  'EXPIRED': 'Hết hạn',
};
