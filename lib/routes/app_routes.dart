import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movil_pucetec_api/pages/create_product.dart';
import 'package:movil_pucetec_api/pages/dashboard_page.dart';
import 'package:movil_pucetec_api/pages/login_page.dart';
import 'package:movil_pucetec_api/pages/register_page.dart';

class RoutesNames {
  static String login = '/';
  static String register = '/register';
  static String dashboard = '/dashboard';
  static String createProduct = '/create';
  static String editProduct = '/edit';
}

final routerProvider = Provider((ref) => routerConfig);

final routerConfig = GoRouter(routes: [
  GoRoute(
    path: RoutesNames.login,
    builder: (context, state) => const LoginPage(),
  ),
  GoRoute(
    path: RoutesNames.createProduct,
    builder: (context, state) => const CreateProduct(),
  ),
  GoRoute(
    path: RoutesNames.register,
    builder: (context, state) => const RegisterPage(),
  ),
  GoRoute(
    path: RoutesNames.dashboard,
    builder: (context, state) => const DashboardPage(),
  ),
]);
