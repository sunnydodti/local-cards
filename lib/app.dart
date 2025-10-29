import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/constants.dart';
import 'data/provider/theme_provider.dart';
import 'screens/cards_screen.dart';
import 'widgets/mobile_wrapper.dart';

class LocalCards extends StatelessWidget {
  const LocalCards({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appDisplayName,
      theme: context.watch<ThemeProvider>().theme,
      home: MobileWrapper(
        child: CardsScreen(),
      ),
    );
  }
}
