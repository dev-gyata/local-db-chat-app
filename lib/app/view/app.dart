import 'package:flutter/material.dart';
import 'package:local_db_chat_app/home/home.dart';
import 'package:local_db_chat_app/l10n/l10n.dart';
import 'package:local_db_chat_app/shared/shared.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.getTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
      },
    );
  }
}
