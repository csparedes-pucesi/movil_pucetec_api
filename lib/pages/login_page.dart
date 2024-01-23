import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:go_router/go_router.dart';
import 'package:movil_pucetec_api/configs/shared_prefs.dart';
import 'package:movil_pucetec_api/providers/auth_provider.dart';
import 'package:movil_pucetec_api/routes/app_routes.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'data:image/jpeg;base64,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', // Sustituye con la URL de tu imagen
              width: 200,
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
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
                controller: _passwordController,
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
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                onPressed: () async {
                  ref
                      .read(emailProvider.notifier)
                      .update((state) => state = _emailController.text);
                  ref
                      .read(passProvider.notifier)
                      .update((state) => state = _passwordController.text);

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
    );
  }
}
