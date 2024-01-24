import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movil_pucetec_api/config/shared_prefs.dart';
import 'package:movil_pucetec_api/theme/app_theme.dart';
import 'package:movil_pucetec_api/theme/theme_provider.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.configPrefs();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerProv = ref.watch(routerProvider);
    final themeProv = ref.watch(themeProvider);
    return MaterialApp.router(
      theme: AppTheme(selectedColor: 2, isDark: themeProv).theme(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routerConfig: routerProv,
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
