/// Модель бронирования - footfood_reservation_foodbox
class ReservationModel {
  final int id;
  final int number;
  final int idUser;
  final int idOrder;

  ReservationModel({
    required this.id,
    required this.number,
    required this.idUser,
    required this.idOrder,
  });

  // Из JSON
  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'] as int,
      number: json['number'] as int,
      idUser: json['id_user'] as int,
      idOrder: json['id_order'] as int,
    );
  }

  // В JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'number': number, 'id_user': idUser, 'id_order': idOrder};
  }

  // Копирование с изменениями
  ReservationModel copyWith({int? id, int? number, int? idUser, int? idOrder}) {
    return ReservationModel(
      id: id ?? this.id,
      number: number ?? this.number,
      idUser: idUser ?? this.idUser,
      idOrder: idOrder ?? this.idOrder,
    );
  }

  @override
  String toString() {
    return 'ReservationModel{id: $id, number: $number}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReservationModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
