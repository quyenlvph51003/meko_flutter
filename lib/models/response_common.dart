class ResponseCommon<T> {
  final String datetime;
  final int errorCode;
  final String message;
  final T? data;
  final bool success;
  final List<T>? content;

  ResponseCommon({
    required this.datetime,
    required this.errorCode,
    required this.message,
    this.data,
    this.content,
    required this.success,
  });

  /// Parse single object hoặc data đơn giản
  factory ResponseCommon.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic)? fromJsonT,
      ) {
    return ResponseCommon<T>(
      datetime: json['datetime'] ?? '',
      errorCode: json['errorCode'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'],
      content: null,
      success: json['success'] ?? false,
    );
  }

  /// Parse danh sách (list)
  factory ResponseCommon.fromJsonList(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    final listData = json['data'];
    return ResponseCommon<T>(
      datetime: json['datetime'] ?? '',
      errorCode: json['errorCode'] ?? 0,
      message: json['message'] ?? '',
      data: null,
      content: listData is List
          ? listData
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList()
          : <T>[],
      success: json['success'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'datetime': datetime,
      'errorCode': errorCode,
      'message': message,
      'data': data,
      'content': content,
      'success': success,
    };
  }

  bool get isSuccess => success && errorCode == 200;
}
