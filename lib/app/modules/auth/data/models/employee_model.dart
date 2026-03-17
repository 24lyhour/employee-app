class EmployeeModel {
  final int id;
  final String uuid;
  final String employeeCode;
  final String firstName;
  final String lastName;
  final String fullName;
  final String? email;
  final String? phoneNumber;
  final String? gender;
  final String? dateOfBirth;
  final String? birthPlace;
  final String? currentAddress;
  final String? avatarUrl;
  final String? jobTitle;
  final String? employeeType;
  final String? hireDate;
  final double? salary;
  final bool status;
  final bool isOnProbation;
  final SchoolModel? school;
  final DepartmentModel? department;
  final EmployeeTypeModel? employeeTypeInfo;
  final UserModel? user;
  final String? createdAt;
  final String? updatedAt;

  EmployeeModel({
    required this.id,
    required this.uuid,
    required this.employeeCode,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    this.email,
    this.phoneNumber,
    this.gender,
    this.dateOfBirth,
    this.birthPlace,
    this.currentAddress,
    this.avatarUrl,
    this.jobTitle,
    this.employeeType,
    this.hireDate,
    this.salary,
    required this.status,
    required this.isOnProbation,
    this.school,
    this.department,
    this.employeeTypeInfo,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] ?? 0,
      uuid: json['uuid'] ?? '',
      employeeCode: json['employee_code'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'],
      phoneNumber: json['phone_number'],
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'],
      birthPlace: json['birth_place'],
      currentAddress: json['current_address'],
      avatarUrl: json['avatar_url'],
      jobTitle: json['job_title'],
      employeeType: json['employee_type'],
      hireDate: json['hire_date'],
      salary: json['salary'] != null
          ? double.tryParse(json['salary'].toString())
          : null,
      status: json['status'] ?? false,
      isOnProbation: json['is_on_probation'] ?? false,
      school:
          json['school'] != null ? SchoolModel.fromJson(json['school']) : null,
      department: json['department'] != null
          ? DepartmentModel.fromJson(json['department'])
          : null,
      employeeTypeInfo: json['employee_type_info'] != null
          ? EmployeeTypeModel.fromJson(json['employee_type_info'])
          : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'employee_code': employeeCode,
      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'birth_place': birthPlace,
      'current_address': currentAddress,
      'avatar_url': avatarUrl,
      'job_title': jobTitle,
      'employee_type': employeeType,
      'hire_date': hireDate,
      'salary': salary,
      'status': status,
      'is_on_probation': isOnProbation,
      'school': school?.toJson(),
      'department': department?.toJson(),
      'employee_type_info': employeeTypeInfo?.toJson(),
      'user': user?.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class SchoolModel {
  final int id;
  final String? uuid;
  final String name;

  SchoolModel({
    required this.id,
    this.uuid,
    required this.name,
  });

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
      id: json['id'] ?? 0,
      uuid: json['uuid'],
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'name': name,
    };
  }
}

class DepartmentModel {
  final int id;
  final String? uuid;
  final String name;
  final double? latitude;
  final double? longitude;
  final int? geofenceRadius;
  final bool enforceGeofence;

  DepartmentModel({
    required this.id,
    this.uuid,
    required this.name,
    this.latitude,
    this.longitude,
    this.geofenceRadius,
    this.enforceGeofence = false,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'] ?? 0,
      uuid: json['uuid'],
      name: json['name'] ?? '',
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      geofenceRadius: json['geofence_radius'],
      enforceGeofence: json['enforce_geofence'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'geofence_radius': geofenceRadius,
      'enforce_geofence': enforceGeofence,
    };
  }

  bool get hasGeofence => latitude != null && longitude != null;
}

class EmployeeTypeModel {
  final int id;
  final String name;

  EmployeeTypeModel({
    required this.id,
    required this.name,
  });

  factory EmployeeTypeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeTypeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

/// Login response from API
class LoginResponse {
  final bool success;
  final String message;
  final String? accessToken;
  final String? tokenType;
  final EmployeeModel? employee;

  LoginResponse({
    required this.success,
    required this.message,
    this.accessToken,
    this.tokenType,
    this.employee,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      employee: json['employee'] != null
          ? EmployeeModel.fromJson(json['employee'])
          : null,
    );
  }
}

/// Profile response from API
class ProfileResponse {
  final bool success;
  final String? message;
  final EmployeeModel? employee;

  ProfileResponse({
    required this.success,
    this.message,
    this.employee,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'] ?? false,
      message: json['message'],
      employee: json['employee'] != null
          ? EmployeeModel.fromJson(json['employee'])
          : null,
    );
  }
}
