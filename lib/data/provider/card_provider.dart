import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import '../constants.dart';

class CardProvider extends ChangeNotifier {
  Box box = Hive.box(Constants.box);
  List<String> _cards = [];

  CardProvider();
  List<String> get cards => _cards;
}
