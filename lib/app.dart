import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:sultanpos/ui/splashscreen.dart';
import 'package:sultanpos/util/color.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: createMaterialColor(const Color(0xff3D928A)),
        primaryColor: const Color(0xff3D928A),
        fontFamily: 'Ubuntu',
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: createMaterialColor(const Color(0xff3D928A)),
        primaryColor: const Color(0xff3D928A),
        fontFamily: 'Ubuntu',
        inputDecorationTheme: const InputDecorationTheme(
          isDense: true,
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(gapPadding: 0, borderSide: BorderSide(width: 0)),
          contentPadding: EdgeInsets.all(12),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 18),
          titleMedium: TextStyle(fontSize: 14),
          labelLarge: TextStyle(fontSize: 14),
          bodyLarge: TextStyle(fontSize: 14),
          bodyMedium: TextStyle(fontSize: 14),
        ),
      ),
      initial: AdaptiveThemeMode.dark,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        theme: theme,
        darkTheme: darkTheme,
        title: "Sultan POS 2",
      ),
    );
  }
}
