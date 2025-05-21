import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/routes/app_routes.dart';
import 'config/themes/app_themes.dart';
import 'data/repositories/fake_data_repository.dart';
import 'domain/providers/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else {
    databaseFactory = databaseFactoryFfi;
  }

  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getString('username') != null;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DataProvider(FakeDataRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(isLoggedIn: isLoggedIn),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestor de tareas',
      theme: AppThemes.lighTheme,
      initialRoute: authProvider.isLoggedIn ? AppRoute.homeRoute : AppRoute.loginRoute,
      onGenerateRoute: AppRoute.onGenerateRoute,
    );
  }
}
