import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_db_chat_app/shared/shared.dart';

abstract class AppTheme {
  static ThemeData getTheme(BuildContext context) => ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
    ),
    dividerColor: AppColors.borderColor,
    primaryColor: AppColors.primary,
    textTheme: GoogleFonts.robotoTextTheme(
      Theme.of(context).textTheme,
    ),
    useMaterial3: true,
  );
}
