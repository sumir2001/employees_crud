class RegisterResponse {
  final int? status;
  final Data? data;
  final String? message;

  RegisterResponse({
    this.status,
    this.data,
    this.message,
  });

  RegisterResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'] as int?,
        data = (json['data'] as Map<String, dynamic>?) != null
            ? Data.fromJson(json['data'] as Map<String, dynamic>)
            : null,
        message = json['message'] as String?;

  Map<String, dynamic> toJson() =>
      {'status': status, 'data': data?.toJson(), 'message': message};
}

class Data {
  final int? id;
  final String? username;

  Data({
    this.id,
    this.username,
  });

  Data.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        username = json['username'] as String?;

  Map<String, dynamic> toJson() => {'id': id, 'username': username};
}
