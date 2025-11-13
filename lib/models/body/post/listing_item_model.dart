class ListingItem {
  final int id;
  final int userPostId;
  final String userNamePoster;
  final String? avatarPoster;
  final String? emailPoster;
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
  final bool? isFavorite;
  final int? favoriteId;
  final int? postId; //phục vụ cho call api favorite
  final String? wardName;
  final String? provinceName;
  final String? reasonReject;
  final String? reasonViolation;
  const ListingItem({
    required this.id,
    required this.userPostId,
    required this.userNamePoster,
    required this.avatarPoster,
    required this.title,
    required this.emailPoster,
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
    this.isFavorite,
    this.favoriteId,
    this.postId,
    this.wardName,
    this.provinceName,
    this.reasonReject,
    this.reasonViolation,
  });

  factory ListingItem.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? s) => s == null ? null : DateTime.tryParse(s);
    List<String> toStrList(dynamic v) => (v as List? ?? []).map((e) => e.toString()).toList();

    return ListingItem(
      id: json['id'] ?? 0,
      userPostId: json['userPostId'] ?? 0,
      userNamePoster: json['userNamePoster']?.toString() ?? '',
      avatarPoster: json['avatarPoster']?.toString(),
      title: json['title']?.toString() ?? '',
      emailPoster: json['emailPoster']?.toString(),
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
      isFavorite: json['isFavorite'] ?? false,
      favoriteId: json['favoriteId'] ?? 0,
      postId: json['postId'] ?? 0,
      wardName: json['wardName']?.toString(),
      provinceName: json['provinceName']?.toString(),
      reasonReject: json['reasonReject']?.toString(),
      reasonViolation: json['reasonViolation']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    String? fmt(DateTime? d) => d?.toUtc().toIso8601String();
    return {
      'id': id,
      'userPostId': userPostId,
      'userNamePoster': userNamePoster,
      'avatarPoster': avatarPoster,
      'title': title,
      'emailPoster': emailPoster,
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
      'isFavorite': isFavorite,
      'favoriteId': favoriteId,
      'postId': postId,
      'wardName': wardName,
      'provinceName': provinceName,
      'reasonReject': reasonReject,
      'reasonViolation': reasonViolation,
    };
  }
}
