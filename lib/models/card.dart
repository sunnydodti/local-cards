import 'dart:convert';

/// Type of a stored card.
enum CardType { credit, debit, other }

extension CardTypeX on CardType {
  String get name {
    switch (this) {
      case CardType.credit:
        return 'credit';
      case CardType.debit:
        return 'debit';
      case CardType.other:
        return 'other';
    }
  }

  static CardType fromString(String? s) {
    if (s == null) return CardType.other;
    switch (s) {
      case 'credit':
        return CardType.credit;
      case 'debit':
        return CardType.debit;
      default:
        return CardType.other;
    }
  }
}

class CardModel {
  final String id;
  final String holderName;
  final String cardNumber;
  final int expiryMonth;
  final int expiryYear;
  final String? brand;
  final CardType type;
  final DateTime createdAt;
  final DateTime updatedAt;

  CardModel({
    required this.id,
    required this.holderName,
    required this.cardNumber,
    required this.expiryMonth,
    required this.expiryYear,
    this.brand,
    this.type = CardType.other,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Returns a masked card number suitable for UI (keeps last 4 digits).
  String get maskedNumber {
    if (cardNumber.length <= 4) return cardNumber;
    final last = cardNumber.substring(cardNumber.length - 4);
    return '**** **** **** $last';
  }

  CardModel copyWith({
    String? holderName,
    String? cardNumber,
    int? expiryMonth,
    int? expiryYear,
    String? brand,
    CardType? type,
    DateTime? updatedAt,
  }) {
    return CardModel(
      id: id,
      holderName: holderName ?? this.holderName,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      brand: brand ?? this.brand,
      type: type ?? this.type,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'holderName': holderName,
      'cardNumber': cardNumber,
      'expiryMonth': expiryMonth,
      'expiryYear': expiryYear,
      'brand': brand,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      id: map['id'] as String,
      holderName: map['holderName'] as String,
      cardNumber: map['cardNumber'] as String,
      expiryMonth: (map['expiryMonth'] as num).toInt(),
      expiryYear: (map['expiryYear'] as num).toInt(),
      brand: map['brand'] as String?,
      type: CardTypeX.fromString(map['type'] as String?),
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CardModel.fromJson(String source) => CardModel.fromMap(json.decode(source));
}
