import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_goldens/flutter_test_goldens.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_db_chat_app/l10n/l10n.dart';
import 'package:local_db_chat_app/shared/shared.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget) async {
    await loadMaterialIconsFont();
    GoogleFonts.config.allowRuntimeFetching = false;
    return pumpWidget(
      MaterialApp(
        theme: AppTheme.getTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: widget,
      ),
    );
  }
}
