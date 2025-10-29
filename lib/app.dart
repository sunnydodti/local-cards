import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/constants.dart';
import 'data/provider/theme_provider.dart';
import 'widgets/mobile_wrapper.dart';
import 'widgets/my_appbar.dart';

class SoundScript extends StatelessWidget {
  const SoundScript({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appDisplayName,
      theme: context.watch<ThemeProvider>().theme,
      home: MobileWrapper(
        child: Scaffold(appBar: MyAppbar.build(context), body: Placeholder()),
      ),
    );
  }
}
