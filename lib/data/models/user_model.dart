/// Модель пользователя (покупателя) - footfood_users
class UserModel {
  final int id;
  final String phone;
  final String password;
  final String? city;

  UserModel({
    required this.id,
    required this.phone,
    required this.password,
    this.city,
  });

  // Из JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      phone: json['phone'] as String,
      password: json['password'] as String,
      city: json['city'] as String?,
    );
  }

  // В JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'phone': phone, 'password': password, 'city': city};
  }

  // Копирование с изменениями
  UserModel copyWith({int? id, String? phone, String? password, String? city}) {
    return UserModel(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      city: city ?? this.city,
    );
  }

  @override
  String toString() {
    return 'UserModel{id: $id, phone: $phone, city: $city}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
