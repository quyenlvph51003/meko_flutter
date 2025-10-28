import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final String avatar;

  const Category({
    required this.id,
    required this.name,
    required this.avatar,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
    };
  }

  Category copyWith({
    int? id,
    String? name,
    String? avatar,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  List<Object?> get props => [id, name, avatar];
}