import 'package:flutter/material.dart';
import '../../views/screens/screens.dart';
import '../../data/models/data_model.dart';

class AppRoute {
  static const String loginRoute = 'login';
  static const String homeRoute = 'home';
  static const String formRoute = 'formscreen';
  static const String viewRoute = 'view';

  static const String intialRoute = loginRoute;

  static Map<String, Widget Function(BuildContext)> routes = {
    loginRoute: (context) => const LoginScreen(),
    homeRoute: (context) => const ListScreen(),
    formRoute: (context) => const FormScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case homeRoute:
        return MaterialPageRoute(builder: (context) => const ListScreen());
      case formRoute:
        final DataModel? initialData = settings.arguments as DataModel?;
        return MaterialPageRoute(builder: (context) => FormScreen(initialData: initialData));
      case viewRoute:
        final dato = settings.arguments as DataModel;
        return MaterialPageRoute(builder: (context) => ViewScreen(dato: dato));
      default:
        return MaterialPageRoute(builder: (context) => const Text('Error: Ruta desconocida'));
    }
  }
}
