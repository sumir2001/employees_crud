class ErrorResponse {
  final int? status;
  final String? message;

  ErrorResponse({
    this.status,
    this.message,
  });

  ErrorResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'] as int?,
        message = json['message'] as String?;

  Map<String, dynamic> toJson() => {'status': status, 'message': message};
}
