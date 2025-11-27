class PaginatedResult<T> {
  final List<T> content;
  final Pagination pagination;

  PaginatedResult({required this.content, required this.pagination});

  factory PaginatedResult.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    final list = (json['content'] as List? ?? []).map((e) => fromJsonT(e as Map<String, dynamic>)).toList();
    return PaginatedResult<T>(content: list, pagination: Pagination.fromJson(json['pagination'] ?? const {}));
  }
}

class Pagination {
  final int currentPage;
  final int totalPages;
  final int totalElements;
  final int size;

  Pagination({required this.currentPage, required this.totalPages, required this.totalElements, required this.size});

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'] is int ? json['currentPage'] : int.tryParse(json['currentPage']?.toString() ?? '0') ?? 0,
      totalPages: json['totalPages'] ?? 0,
      totalElements: json['totalElements'] ?? 0,
      size: json['size'] ?? 0,
    );
  }
}
