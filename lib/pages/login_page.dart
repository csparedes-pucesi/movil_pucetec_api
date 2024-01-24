import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movil_pucetec_api/config/shared_prefs.dart';
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
            Image.asset(
              'img/tech_logo_3.png',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            const Text(
              'Welcome to the PUCETEC Shop!',
              style: TextStyle(fontSize: 24),
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
                  backgroundColor: MaterialStateProperty.all(Colors.teal),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                onPressed: () async {
                  // Navigator.pushNamed(context, '/dashboard');
                  print(
                      "${_emailController.text}: ${_passwordController.text}");

                  ref
                      .read(emailProvider.notifier)
                      .update((state) => state = _emailController.text);
                  ref
                      .read(passProvider.notifier)
                      .update((state) => state = _passwordController.text);

                  final resp = await ref.read(loginProvider.future);
                  print(resp);
                  if (resp['status'] == 200) {
                    // capturamos los datos
                    final token = resp['data']['token'];
                    // guardar los datos en el shared preferences
                    await SharedPrefs.prefs.setString('token', token);
                    // redireccionamos a la pagina de dashboard
                    ref.read(routerProvider).go(RoutesNames.dashboard);
                  } else {
                    // capturar los mensajes desde backend
                    final msg = resp['data']['message'];
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
                child:
                    const Text('Login', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
