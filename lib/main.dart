import "package:flutter/material.dart";
import "package:univid_compressor/skeleton/skeleton.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Univid Compressor",
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: _primary,
          onPrimary: _platinum,
          secondary: _primary,
          onSecondary: _platinum,
          error: _error,
          onError: _platinum,
          background: _background,
          onBackground: _platinum,
          surface: _surface,
          onSurface: _platinum,
        ),
        useMaterial3: true,
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStatePropertyAll<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: _primary,
          contentTextStyle: TextStyle(
            color: _platinum,
          ),
        ),
      ),
      home: const Skeleton(),
    );
  }

  static const Color _background = Color(0xFF2d3046);
  static const Color _primary = Color(0xFF1b998b);
  static const Color _surface = Color(0xFFffc83a);
  static const Color _error = Color(0xFFDF2935);
  static const Color _platinum = Color(0xFFE6E8E6);
}
