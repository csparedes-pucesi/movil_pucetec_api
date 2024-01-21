import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movil_pucetec_api/providers/products_provider.dart';
import 'package:movil_pucetec_api/routes/app_routes.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productProviderAsync = ref.watch(productProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: productProviderAsync.when(
                  data: (products) => Column(
                        children: products
                            .map((product) => ListTile(
                                  title: Text(product.name ?? 'Sin nombre'),
                                  leading: IconButton(
                                      onPressed: () {
                                        // actualizar redireccion a actualizar producto
                                        ref.read(routerProvider).push(
                                          RoutesNames.createProduct,
                                          extra: product,
                                        );
                                      },
                                      icon: const Icon(Icons.edit)),
                                  // const Icon(Icons.shopping_bag_outlined),
                                  subtitle: Text(
                                      product.description ?? 'Sin descripción'),
                                  trailing: Text(
                                    "\$ ${product.unitPrice?.toStringAsFixed(2)}",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ))
                            .toList(),
                      ),
                  error: (_, __) => const Text('No se pudo cargar la data'),
                  loading: () => const CircularProgressIndicator())),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ref.read(routerProvider).push(
              RoutesNames.createProduct,
              extra: null,
            );
          },
          child: const Icon(Icons.add),
        ));
  }
}
