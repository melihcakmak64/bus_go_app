class UserModel {
  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? password;
  final bool marketingOptIn;
  final String createdAt;

  const UserModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.password,
    this.marketingOptIn = false,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['Id'] as int?,
      firstName: map['FirstName'] as String,
      lastName: map['LastName'] as String,
      email: map['Email'] as String,
      phone: map['Phone'] as String?,
      password: map['Password'] as String?,
      marketingOptIn: (map['MarketingOptIn'] as int? ?? 0) == 1,
      createdAt: map['CreatedAt'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'Id': id,
      'FirstName': firstName,
      'LastName': lastName,
      'Email': email,
      'Phone': phone,
      if (password != null) 'Password': password,
      'MarketingOptIn': marketingOptIn ? 1 : 0,
      'CreatedAt': createdAt,
    };
  }
}