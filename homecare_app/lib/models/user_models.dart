class UserLoginRequest {
  final String email;
  final String password;

  UserLoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class UserLoginResponse {
  final String userId;

  UserLoginResponse({
    required this.userId,
  });

  factory UserLoginResponse.fromJson(Map<String, dynamic> json) {
    return UserLoginResponse(
      userId: json['userId'],
    );
  }
}

class ConsumerCreateRequest {
  final String name;
  final String email;
  final String password;
  final String phone;
  final DateTime birthDate;

  ConsumerCreateRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.birthDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'birthDate': birthDate.toIso8601String().split('T')[0],
    };
  }
}

class ApiError {
  final String message;
  final int? statusCode;

  ApiError({
    required this.message,
    this.statusCode,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      message: json['message'] ?? json['detail'] ?? 'Unknown error',
      statusCode: json['status'],
    );
  }
}