class SuccessResponse {
  final String? message;
  final int? status;

  SuccessResponse({
    this.message,
    this.status,
  });

  SuccessResponse.fromJson(Map<String, dynamic> json)
      : message = json['message'] as String?,
        status = json['status'] as int?;

  Map<String, dynamic> toJson() => {'message': message, 'status': status};
}
