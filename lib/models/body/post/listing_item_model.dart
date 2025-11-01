class ListingItem {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String price;
  final String address;
  final String status;
  final DateTime? expiredAt;
  final int isPinned;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String wardCode;
  final String provinceCode;
  final List<String> images;
  final List<String> categories;

  ListingItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.price,
    required this.address,
    required this.status,
    required this.expiredAt,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
    required this.wardCode,
    required this.provinceCode,
    required this.images,
    required this.categories,
  });

  factory ListingItem.fromJson(Map<String, dynamic> json) {
    DateTime? _parse(String? s) => s == null ? null : DateTime.tryParse(s);

    return ListingItem(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price']?.toString() ?? '0',
      address: json['address'] ?? '',
      status: json['status'] ?? '',
      expiredAt: _parse(json['expiredAt']),
      isPinned: json['isPinned'] ?? 0,
      createdAt: _parse(json['createdAt']),
      updatedAt: _parse(json['updatedAt']),
      wardCode: json['wardCode'] ?? '',
      provinceCode: json['provinceCode'] ?? '',
      images: (json['images'] as List? ?? []).map((e) => e.toString()).toList(),
      categories: (json['categories'] as List? ?? []).map((e) => e.toString()).toList(),
    );
  }
}
