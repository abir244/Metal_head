class ParentInfo {
  final String name;
  final String email;
  final String phone;

  ParentInfo({
    required this.name,
    required this.email,
    required this.phone,
  });

  factory ParentInfo.mock() {
    return ParentInfo(
      name: "Wilfried Mbappé",
      email: "parent@mail.com",
      phone: "+33 123 456 789",
    );
  }

  factory ParentInfo.fromJson(Map<String, dynamic> json) {
    return ParentInfo(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
  };
}
