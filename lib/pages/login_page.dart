import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movil_pucetec_api/configs/shared_prefs.dart';
import 'package:movil_pucetec_api/providers/auth_provider.dart';
import 'package:movil_pucetec_api/routes/app_routes.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    
    final inputDecorationTheme = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      
    );

    
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.blueGrey, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        backgroundColor:
            Colors.blueGrey, 
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the PUCETEC Shop!',
              style: TextStyle(fontSize: 24),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextFormField(
                controller: _emailController,
                decoration: inputDecorationTheme.copyWith(
                    labelText: 'Email', hintText: 'Ingrese su email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _passwordController,
                obscureText: true,
                decoration: inputDecorationTheme.copyWith(
                    labelText: 'Password', hintText: 'Ingrese su password'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ElevatedButton(
                style: buttonStyle,
                onPressed: () async {
                  ref
                      .read(emailProvider.notifier)
                      .update((state) => state = _emailController.text);
                  ref
                      .read(passProvider.notifier)
                      .update((state) => state = _passwordController.text);

                  final resp = await ref.read(loginProvider.future);

                  if (resp["status"] == 200) {
                    final token = resp["data"]["token"];
                    await SharedPrefs.prefs.setString('token', token);
                    ref.read(routerProvider).go(RoutesNames.dashboard);
                  } else {
                    final msg = resp["data"]["message"];
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
