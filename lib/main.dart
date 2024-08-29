import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:univid_compressor/database/database.dart";
import "package:univid_compressor/skeleton/skeleton.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AppDatabase database = AppDatabase();

  runApp(
    MyApp(
      database: database,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({required this.database, super.key});

  final AppDatabase database;

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
            foregroundColor: const WidgetStatePropertyAll<Color>(_secondary),
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
        textTheme: const TextTheme(
          bodySmall: TextStyle(
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            fontSize: 20,
          ),
          bodyLarge: TextStyle(
            fontSize: 24,
          ),
        ),
        sliderTheme: SliderThemeData(
          overlayShape: SliderComponentShape.noThumb,
        ),
        dropdownMenuTheme: const DropdownMenuThemeData(
          menuStyle: MenuStyle(visualDensity: VisualDensity.compact),
          textStyle: TextStyle(
            fontSize: 16,
          ),
        ),
        radioTheme: const RadioThemeData(
          fillColor: WidgetStatePropertyAll<Color>(_secondary),
        ),
      ),
      home: Skeleton(
        database: database,
      ),
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
