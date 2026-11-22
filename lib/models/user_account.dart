class UserAccount {
  final int id;
  final String email;
  final String? createdAt;

  const UserAccount({
    required this.id,
    required this.email,
    this.createdAt,
  });

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) ?? 0 : 0,
      email: json['email']?.toString() ?? '',
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      if (createdAt != null) 'created_at': createdAt,
    };
  }
}
