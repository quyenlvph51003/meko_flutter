class ResponseCommon<T> {
  final String datetime;
  final int errorCode;
  final String message;
  final T? data;
  final bool success;

  ResponseCommon({
    required this.datetime,
    required this.errorCode,
    required this.message,
    this.data,
    required this.success,
  });

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
      success: json['success'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'datetime': datetime,
      'errorCode': errorCode,
      'message': message,
      'data': data,
      'success': success,
    };
  }

  bool get isSuccess => success && errorCode == 200;
}