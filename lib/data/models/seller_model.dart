/// Модель продавца - footfood_seller
class SellerModel {
  final int id;
  final String email;
  final String nameRestaurant;
  final String address;
  final String? logo;
  final String password;
  final String statusOrder;
  final int inn;
  final int ogrn;
  final String? verification;
  final String? photos;

  SellerModel({
    required this.id,
    required this.email,
    required this.nameRestaurant,
    required this.address,
    this.logo,
    required this.password,
    required this.statusOrder,
    required this.inn,
    required this.ogrn,
    this.verification,
    this.photos,
  });

  // Из JSON
  factory SellerModel.fromJson(Map<String, dynamic> json) {
    return SellerModel(
      id: json['id'] as int,
      email: json['email'] as String,
      nameRestaurant: json['name_restaurant'] as String,
      address: json['address'] as String,
      logo: json['logo'] as String?,
      password: json['password'] as String,
      statusOrder: json['status_order'] as String,
      inn: json['inn'] as int,
      ogrn: json['ogrn'] as int,
      verification: json['verification'] as String?,
      photos: json['photos'] as String?,
    );
  }

  // В JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name_restaurant': nameRestaurant,
      'address': address,
      'logo': logo,
      'password': password,
      'status_order': statusOrder,
      'inn': inn,
      'ogrn': ogrn,
      'verification': verification,
      'photos': photos,
    };
  }

  // Копирование с изменениями
  SellerModel copyWith({
    int? id,
    String? email,
    String? nameRestaurant,
    String? address,
    String? logo,
    String? password,
    String? statusOrder,
    int? inn,
    int? ogrn,
    String? verification,
    String? photos,
  }) {
    return SellerModel(
      id: id ?? this.id,
      email: email ?? this.email,
      nameRestaurant: nameRestaurant ?? this.nameRestaurant,
      address: address ?? this.address,
      logo: logo ?? this.logo,
      password: password ?? this.password,
      statusOrder: statusOrder ?? this.statusOrder,
      inn: inn ?? this.inn,
      ogrn: ogrn ?? this.ogrn,
      verification: verification ?? this.verification,
      photos: photos ?? this.photos,
    );
  }

  @override
  String toString() {
    return 'SellerModel{id: $id, email: $email, nameRestaurant: $nameRestaurant}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SellerModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
