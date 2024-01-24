import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Page'),
      ),
      body: const Center(
        child: Text(
          'bienvenido a la página de registro',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
