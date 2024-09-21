class EmployeesResponse {
  final int? status;
  final String? message;
  final List<Data>? data;

  EmployeesResponse({
    this.status,
    this.message,
    this.data,
  });

  EmployeesResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'] as int?,
        message = json['message'] as String?,
        data = (json['data'] as List?)
            ?.map((dynamic e) => Data.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList()
      };
}

class Data {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? countryCode;
  final int? salary;
  final bool? isFulltime;
  final String? gender;
  final String? department;
  final String? createdAt;
  final String? updatedAt;

  Data({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.countryCode,
    this.salary,
    this.isFulltime,
    this.gender,
    this.department,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json)
      : id = json['ID'] as int?,
        firstName = json['first_name'] as String?,
        lastName = json['last_name'] as String?,
        email = json['email'] as String?,
        phone = json['phone'] as String?,
        countryCode = json['country_code'] as String?,
        salary = json['salary'] as int?,
        isFulltime = json['is_fulltime'] as bool?,
        gender = json['gender'] as String?,
        department = json['department'] as String?,
        createdAt = json['CreatedAt'] as String?,
        updatedAt = json['UpdatedAt'] as String?;

  Map<String, dynamic> toJson() => {
        'ID': id,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'country_code': countryCode,
        'salary': salary,
        'is_fulltime': isFulltime,
        'gender': gender,
        'department': department,
        'CreatedAt': createdAt,
        'UpdatedAt': updatedAt
      };
}
