class LoginResponse {
  final int? status;
  final String? data;
  final String? message;

  LoginResponse({
    this.status,
    this.data,
    this.message,
  });

  LoginResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'] as int?,
        data = json['data'] as String?,
        message = json['message'] as String?;

  Map<String, dynamic> toJson() =>
      {'status': status, 'data': data, 'message': message};
}
