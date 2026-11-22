import 'package:flutter/material.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/theme/app_theme.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/screens/login_screen.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/screens/main_navigation_screen.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/services/session_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isLoggedIn = await SessionService.isLoggedIn();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;

  const MyApp({super.key, this.isLoggedIn = false});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CV Delphin Biarwanga Mugenyi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: widget.isLoggedIn ? const MainNavigationScreen() : const LoginScreen(),
    );
  }
}
