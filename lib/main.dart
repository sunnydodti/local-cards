import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/provider/card_provider.dart';
import 'data/provider/theme_provider.dart';
import 'service/startup_service.dart';
import 'services/security_service.dart';

void main() async {
  await StartupService.init();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => CardProvider()),
      ChangeNotifierProvider(create: (_) => SecurityService()),
    ],
    child: const LocalCards(),
  ));
}
