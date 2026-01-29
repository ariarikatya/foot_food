/// Модель карты - footfood_card
class CardModel {
  final int id;
  final int number;
  final int endTime;
  final int cvc;
  final String? nameUser;
  final int idUser;

  CardModel({
    required this.id,
    required this.number,
    required this.endTime,
    required this.cvc,
    this.nameUser,
    required this.idUser,
  });

  // Из JSON
  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'] as int,
      number: json['number'] as int,
      endTime: json['end_time'] as int,
      cvc: json['cvc'] as int,
      nameUser: json['name_user'] as String?,
      idUser: json['id_user'] as int,
    );
  }

  // В JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'end_time': endTime,
      'cvc': cvc,
      'name_user': nameUser,
      'id_user': idUser,
    };
  }

  // Копирование с изменениями
  CardModel copyWith({
    int? id,
    int? number,
    int? endTime,
    int? cvc,
    String? nameUser,
    int? idUser,
  }) {
    return CardModel(
      id: id ?? this.id,
      number: number ?? this.number,
      endTime: endTime ?? this.endTime,
      cvc: cvc ?? this.cvc,
      nameUser: nameUser ?? this.nameUser,
      idUser: idUser ?? this.idUser,
    );
  }

  // Маскированный номер карты (показываем последние 4 цифры)
  String get maskedNumber {
    final numberStr = number.toString();
    if (numberStr.length >= 4) {
      return '**** **** **** ${numberStr.substring(numberStr.length - 4)}';
    }
    return numberStr;
  }

  @override
  String toString() {
    return 'CardModel{id: $id, maskedNumber: $maskedNumber}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CardModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
