/// Модель истории заказов - footfood_order_history
class OrderHistoryModel {
  final int id;
  final int idUser;
  final int idSeller;
  final int numberOrder;
  final int numberReservation;
  final DateTime? cookingTime;
  final DateTime? saleTime;
  final DateTime? endTime;
  final DateTime? bayTime;
  final String? compositionOrder;
  final String? description;
  final double price;

  OrderHistoryModel({
    required this.id,
    required this.idUser,
    required this.idSeller,
    required this.numberOrder,
    required this.numberReservation,
    this.cookingTime,
    this.saleTime,
    this.endTime,
    this.bayTime,
    this.compositionOrder,
    this.description,
    required this.price,
  });

  // Геттер для получения основной даты заказа
  DateTime? get date => bayTime ?? endTime ?? saleTime ?? cookingTime;

  // Из JSON
  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderHistoryModel(
      id: json['id'] as int,
      idUser: json['id_user'] as int,
      idSeller: json['id_seller'] as int,
      numberOrder: json['number_order'] as int,
      numberReservation: json['number_reservation'] as int,
      cookingTime: json['cooking_time'] != null
          ? DateTime.parse(json['cooking_time'] as String)
          : null,
      saleTime: json['sale_time'] != null
          ? DateTime.parse(json['sale_time'] as String)
          : null,
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'] as String)
          : null,
      bayTime: json['bay_time'] != null
          ? DateTime.parse(json['bay_time'] as String)
          : null,
      compositionOrder: json['composition_order'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
    );
  }

  // В JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_user': idUser,
      'id_seller': idSeller,
      'number_order': numberOrder,
      'number_reservation': numberReservation,
      'cooking_time': cookingTime?.toIso8601String(),
      'sale_time': saleTime?.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'bay_time': bayTime?.toIso8601String(),
      'composition_order': compositionOrder,
      'description': description,
      'price': price,
    };
  }

  // Копирование с изменениями
  OrderHistoryModel copyWith({
    int? id,
    int? idUser,
    int? idSeller,
    int? numberOrder,
    int? numberReservation,
    DateTime? cookingTime,
    DateTime? saleTime,
    DateTime? endTime,
    DateTime? bayTime,
    String? compositionOrder,
    String? description,
    double? price,
  }) {
    return OrderHistoryModel(
      id: id ?? this.id,
      idUser: idUser ?? this.idUser,
      idSeller: idSeller ?? this.idSeller,
      numberOrder: numberOrder ?? this.numberOrder,
      numberReservation: numberReservation ?? this.numberReservation,
      cookingTime: cookingTime ?? this.cookingTime,
      saleTime: saleTime ?? this.saleTime,
      endTime: endTime ?? this.endTime,
      bayTime: bayTime ?? this.bayTime,
      compositionOrder: compositionOrder ?? this.compositionOrder,
      description: description ?? this.description,
      price: price ?? this.price,
    );
  }

  @override
  String toString() {
    return 'OrderHistoryModel{id: $id, numberOrder: $numberOrder, price: $price}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderHistoryModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}