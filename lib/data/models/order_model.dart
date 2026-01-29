/// Модель заказа - footfood_order_foodbox
class OrderModel {
  final int id;
  final int idSeller;
  final int numberOrder;
  final DateTime? cookingTime;
  final DateTime? saleTime;
  final DateTime? endTime;
  final String? compositionOrder;
  final String? description;
  final double price;
  final int numberReservation;

  OrderModel({
    required this.id,
    required this.idSeller,
    required this.numberOrder,
    this.cookingTime,
    this.saleTime,
    this.endTime,
    this.compositionOrder,
    this.description,
    required this.price,
    required this.numberReservation,
  });

  // Из JSON
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int,
      idSeller: json['id_seller'] as int,
      numberOrder: json['number_order'] as int,
      cookingTime: json['cooking_time'] != null
          ? DateTime.parse(json['cooking_time'] as String)
          : null,
      saleTime: json['sale_time'] != null
          ? DateTime.parse(json['sale_time'] as String)
          : null,
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'] as String)
          : null,
      compositionOrder: json['composition_order'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      numberReservation: json['number_reservation'] as int,
    );
  }

  // В JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_seller': idSeller,
      'number_order': numberOrder,
      'cooking_time': cookingTime?.toIso8601String(),
      'sale_time': saleTime?.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'composition_order': compositionOrder,
      'description': description,
      'price': price,
      'number_reservation': numberReservation,
    };
  }

  // Копирование с изменениями
  OrderModel copyWith({
    int? id,
    int? idSeller,
    int? numberOrder,
    DateTime? cookingTime,
    DateTime? saleTime,
    DateTime? endTime,
    String? compositionOrder,
    String? description,
    double? price,
    int? numberReservation,
  }) {
    return OrderModel(
      id: id ?? this.id,
      idSeller: idSeller ?? this.idSeller,
      numberOrder: numberOrder ?? this.numberOrder,
      cookingTime: cookingTime ?? this.cookingTime,
      saleTime: saleTime ?? this.saleTime,
      endTime: endTime ?? this.endTime,
      compositionOrder: compositionOrder ?? this.compositionOrder,
      description: description ?? this.description,
      price: price ?? this.price,
      numberReservation: numberReservation ?? this.numberReservation,
    );
  }

  @override
  String toString() {
    return 'OrderModel{id: $id, numberOrder: $numberOrder, price: $price}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
