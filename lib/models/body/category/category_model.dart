import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final String avatar;
  final int is_active;

  const Category({
    required this.id,
    required this.name,
    required this.avatar,
    required this.is_active,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      is_active: json['is_active'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'is_active': is_active,
    };
  }

  Category copyWith({
    int? id,
    String? name,
    String? avatar,
    int? is_active,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      is_active: is_active ?? this.is_active,
    );
  }

  @override
  List<Object?> get props => [id, name, avatar,is_active];
}