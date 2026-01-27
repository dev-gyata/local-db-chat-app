import 'package:flutter/material.dart';
import 'package:local_db_chat_app/home/view/home_page.dart';
import 'package:local_db_chat_app/l10n/l10n.dart';
import 'package:local_db_chat_app/shared/shared.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.getTheme(context),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}
