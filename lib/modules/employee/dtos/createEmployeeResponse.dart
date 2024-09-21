class CreateEmployeeResponse {
  final Data? data;
  final String? message;
  final int? status;

  CreateEmployeeResponse({
    this.data,
    this.message,
    this.status,
  });

  CreateEmployeeResponse.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as Map<String, dynamic>?) != null
            ? Data.fromJson(json['data'] as Map<String, dynamic>)
            : null,
        message = json['message'] as String?,
        status = json['status'] as int?;

  Map<String, dynamic> toJson() =>
      {'data': data?.toJson(), 'message': message, 'status': status};
}

class Data {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? countryCode;
  final int? salary;
  final bool? isFulltime;
  final String? gender;
  final String? department;
  final int? iD;
  final String? createdAt;
  final String? updatedAt;
  final dynamic deletedAt;

  Data({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.countryCode,
    this.salary,
    this.isFulltime,
    this.gender,
    this.department,
    this.iD,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Data.fromJson(Map<String, dynamic> json)
      : firstName = json['first_name'] as String?,
        lastName = json['last_name'] as String?,
        email = json['email'] as String?,
        phone = json['phone'] as String?,
        countryCode = json['country_code'] as String?,
        salary = json['salary'] as int?,
        isFulltime = json['is_fulltime'] as bool?,
        gender = json['gender'] as String?,
        department = json['department'] as String?,
        iD = json['ID'] as int?,
        createdAt = json['CreatedAt'] as String?,
        updatedAt = json['UpdatedAt'] as String?,
        deletedAt = json['DeletedAt'];

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'country_code': countryCode,
        'salary': salary,
        'is_fulltime': isFulltime,
        'gender': gender,
        'department': department,
        'ID': iD,
        'CreatedAt': createdAt,
        'UpdatedAt': updatedAt,
        'DeletedAt': deletedAt
      };
}
