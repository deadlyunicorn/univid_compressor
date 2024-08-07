import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:univid_compressor/skeleton/skeleton.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[DeviceOrientation.landscapeLeft],
    );

    return MaterialApp(
      title: "Univid Compressor",
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: _primary,
          onPrimary: _platinum,
          secondary: _secondary,
          onSecondary: _secondary,
          error: _error,
          onError: _platinum,
          surface: _surface,
          onSurface: _platinum,
        ),
        useMaterial3: true,
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll<OutlinedBorder>(
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
        iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll<OutlinedBorder>(_buttonShape),
          ),
        ),
        buttonTheme: const ButtonThemeData(
          shape: _buttonShape,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: _secondary,
          linearTrackColor: Colors.red,
        ),
      ),
      home: const Skeleton(),
    );
  }

  static const Color _primary = Color(0xFF1b998b);
  static const Color _secondary = Color(0xFFffc83a);
  static const Color _error = Colors.red;
  static const Color _surface = Color(0xFF2d3046);
  static const Color _platinum = Color(0xFFE6E8E6);

  static const OutlinedBorder _buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(4)),
  );
}
