import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movil_pucetec_api/configs/shared_prefs.dart';
import 'package:movil_pucetec_api/providers/auth_provider.dart';
import 'package:movil_pucetec_api/routes/app_routes.dart';
import 'package:movil_pucetec_api/themes/theme_provider.dart';

final imagePathProvider = Provider<String>((ref) => 'img/logo.jpg');

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final imagePath = ref.watch(imagePathProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to the PUCETEC Shop!',
                style: TextStyle(fontSize: 24),
              ),
              Image.asset(
                imagePath,
                width: 200,
                height: 200,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ElevatedButton(
                    onPressed: () {
                      // Actualizar
                      ref.read(themeProvider.notifier).update(
                        // (state) => !state
                        (state) {
                          return state = !state;
                        },
                      );
                    },
                    child: const Text('Cambiar de Tema')),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Ingrese su email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Ingrese su password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    ref
                        .read(emailProvider.notifier)
                        .update((state) => state = emailController.text);
                    ref
                        .read(passProvider.notifier)
                        .update((state) => state = passwordController.text);
        
                    final resp = await ref.read(loginProvider.future);
        
                    if (resp["status"] == 200) {
                      // 1. capturamos los datos
                      final token = resp["data"]["token"];
                      // 2. guardamos los datos en el shared preferences
                      await SharedPrefs.prefs.setString('token', token);
                      // 3. redireccionamos a la pagina de dashboard
                      ref.read(routerProvider).go(RoutesNames.dashboard);
                    } else {
                      // Capturar el mensaje desde back
                      final msg = resp["data"]["message"];
                      // Guardar el mensaje en el provider
                      ref
                          .read(msgProvider.notifier)
                          .update((state) => msg.toString());
                      Fluttertoast.showToast(
                          msg: msg.toString(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
