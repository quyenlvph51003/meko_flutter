class ListingItem {
  final int id;
  final int userId;
  final String userNamePoster;
  final String? avatarPoster;
  final String title;
  final String description;
  final String price;
  final String address;
  final String status;
  final String phoneNumber;
  final DateTime? expiredAt;
  final int isPinned;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String wardCode;
  final String provinceCode;
  final List<String> images;
  final List<String> categories;

  const ListingItem({
    required this.id,
    required this.userId,
    required this.userNamePoster,
    required this.avatarPoster,
    required this.title,
    required this.description,
    required this.price,
    required this.address,
    required this.status,
    required this.phoneNumber,
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
    DateTime? parseDate(String? s) => s == null ? null : DateTime.tryParse(s);
    List<String> toStrList(dynamic v) => (v as List? ?? []).map((e) => e.toString()).toList();

    return ListingItem(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      userNamePoster: json['userNamePoster']?.toString() ?? '',
      avatarPoster: json['avatarPoster']?.toString(),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: json['price']?.toString() ?? '0',
      address: json['address']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      expiredAt: parseDate(json['expiredAt']?.toString()),
      isPinned: json['isPinned'] ?? 0,
      createdAt: parseDate(json['createdAt']?.toString()),
      updatedAt: parseDate(json['updatedAt']?.toString()),
      wardCode: json['wardCode']?.toString() ?? '',
      provinceCode: json['provinceCode']?.toString() ?? '',
      images: toStrList(json['images']),
      categories: toStrList(json['categories']),
    );
  }

  Map<String, dynamic> toJson() {
    String? fmt(DateTime? d) => d?.toUtc().toIso8601String();
    return {
      'id': id,
      'userId': userId,
      'userNamePoster': userNamePoster,
      'avatarPoster': avatarPoster,
      'title': title,
      'description': description,
      'price': price,
      'address': address,
      'status': status,
      'phoneNumber': phoneNumber,
      'expiredAt': fmt(expiredAt),
      'isPinned': isPinned,
      'createdAt': fmt(createdAt),
      'updatedAt': fmt(updatedAt),
      'wardCode': wardCode,
      'provinceCode': provinceCode,
      'images': images,
      'categories': categories,
    };
  }
}
