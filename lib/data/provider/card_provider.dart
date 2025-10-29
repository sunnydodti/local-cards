import 'package:flutter/material.dart';

import '../../models/card.dart';
import '../../service/card_service.dart';

class CardProvider extends ChangeNotifier {
  final CardService _service = CardService.instance();
  List<CardModel> _cards = [];
  bool _loading = false;

  CardProvider() {
    load();
  }

  List<CardModel> get cards => List.unmodifiable(_cards);
  bool get loading => _loading;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _cards = await _service.listCards();
    _loading = false;
    notifyListeners();
  }

  Future<void> addCard(CardModel card) async {
    await _service.createCard(card);
    await load();
  }

  Future<void> updateCard(CardModel card) async {
    await _service.updateCard(card);
    await load();
  }

  Future<void> deleteCard(String id) async {
    await _service.deleteCard(id);
    _cards.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  Future<void> clearAll() async {
    await _service.clearAll();
    _cards = [];
    notifyListeners();
  }

  CardModel? getById(String id) {
    try {
      return _cards.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
