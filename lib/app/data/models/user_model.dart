class UserModel {
  final String id;
  final String name;
  final String email;
  final String employeeId;
  final String department;
  final String? avatarUrl;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.employeeId,
    required this.department,
    this.avatarUrl,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      employeeId: json['employee_id'] ?? '',
      department: json['department'] ?? '',
      avatarUrl: json['avatar_url'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'employee_id': employeeId,
      'department': department,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? employeeId,
    String? department,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      employeeId: employeeId ?? this.employeeId,
      department: department ?? this.department,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Mock user for testing
  static UserModel mock() {
    return UserModel(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@company.com',
      employeeId: 'EMP001',
      department: 'Engineering',
      avatarUrl: null,
      createdAt: DateTime.now(),
    );
  }
}
