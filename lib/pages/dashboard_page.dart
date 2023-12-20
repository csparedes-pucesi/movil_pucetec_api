import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movil_pucetec_api/configs/shared_prefs.dart';
import 'package:movil_pucetec_api/providers/products_provider.dart';
import 'package:movil_pucetec_api/routes/app_routes.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productProviderAsync = ref.watch(productsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: productProviderAsync.when(
            data: (products) => Column(
                children: products
                    .map((product) => ListTile(
                          title: Text(product.name ?? 'Sin Nombre'),
                          leading: const Icon(Icons.shopping_bag_outlined),
                          subtitle:
                              Text(product.description ?? 'Sin Descripcion'),
                          trailing: Text(
                              "\$ ${product.unitPrice!.toStringAsFixed(2)}",
                              style: const TextStyle(fontSize: 20)), 
                        ))
                    .toList()),
            error: (_, __) => const Text('No se pudo cargar la información'),
            loading: () => const CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
        ref.read(routerProvider).go(RoutesNames.createProduct);
      }),
    );
  }
}
