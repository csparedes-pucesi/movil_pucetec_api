import 'package:flutter/material.dart';
import 'package:movil_pucetec_api/config/shared_prefs.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              'Welcome to the Dashboard!',
              style: TextStyle(fontSize: 24),
            ),
            const Text('Token'),
            Text(SharedPrefs.prefs.getString('token')!),
          ],
        ),
      ),
    );
  }
}
