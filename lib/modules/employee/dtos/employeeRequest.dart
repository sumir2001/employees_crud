class EmployeeRequest {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? countryCode;
  final int? salary;
  final bool? isFulltime;
  final String? gender;

  EmployeeRequest({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.countryCode,
    this.salary,
    this.isFulltime,
    this.gender,
  });

  EmployeeRequest.fromJson(Map<String, dynamic> json)
      : firstName = json['first_name'] as String?,
        lastName = json['last_name'] as String?,
        email = json['email'] as String?,
        phone = json['phone'] as String?,
        countryCode = json['country_code'] as String?,
        salary = json['salary'] as int?,
        isFulltime = json['is_fulltime'] as bool?,
        gender = json['gender'] as String?;

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'country_code': countryCode,
        'salary': salary,
        'is_fulltime': isFulltime,
        'gender': gender
      };
}
