import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movil_pucetec_api/providers/products_provider.dart';
import 'package:movil_pucetec_api/routes/app_routes.dart';

// DashboardPage: A minimalistic and professional-looking dashboard page.
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observing the product provider for changes.
    final productProviderAsync = ref.watch(productProvider);

    // Refresh function to reload data.
    Future<void> onRefresh() async {
      await Future.delayed(const Duration(seconds: 2));
    }

    // Main scaffold with AppBar and Body.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey[700],
            child:
                const Icon(Icons.account_circle_rounded, color: Colors.white),
          ),
        ),
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            iconSize: 30,
            onPressed: () {},
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Center(
            child: productProviderAsync.when(
              data: (products) => Column(
                children: products
                    .map((product) => Card(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(product.name ?? 'Sin nombre',
                                style: const TextStyle(color: Colors.white)),
                            leading: IconButton(
                              onPressed: () {
                                ref.read(routerProvider).push(
                                      RoutesNames.createProduct,
                                      extra: product,
                                    );
                              },
                              icon: const Icon(Icons.edit, color: Colors.white),
                            ),
                            subtitle: Text(
                                product.description ?? 'Sin descripción',
                                style: const TextStyle(color: Colors.grey)),
                            trailing: Text(
                              "\$ ${product.unitPrice?.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              error: (_, __) => const Text('No se pudo cargar la data',
                  style: TextStyle(color: Colors.white)),
              loading: () => const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        label: const Text('Agregar', style: TextStyle(color: Colors.black)),
        onPressed: () {
          ref.read(routerProvider).push(
                RoutesNames.createProduct,
                extra: null,
              );
        },
        icon: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
