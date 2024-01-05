import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movil_pucetec_api/providers/products_provider.dart';
import 'package:movil_pucetec_api/routes/app_routes.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productProviderAsync = ref.watch(productsProvider);
    final PageController pageController = PageController();

    int itemsPerPage = 10; // Número de items por página

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        backgroundColor: Colors.blueGrey, // Color de fondo del AppBar
        elevation: 0, // Remueve la sombra del AppBar
      ),
      body: productProviderAsync.when(
        data: (products) {
          int totalPages = (products.length / itemsPerPage).ceil();

          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: totalPages,
                  itemBuilder: (context, pageIndex) {
                    int startIndex = pageIndex * itemsPerPage;
                    int endIndex = startIndex + itemsPerPage;
                    endIndex = endIndex > products.length ? products.length : endIndex;
                    var productsInPage = products.getRange(startIndex, endIndex).toList();

                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: productsInPage.length,
                      separatorBuilder: (_, __) => const Divider(), // Separador
                      itemBuilder: (context, index) {
                        var product = productsInPage[index];
                        return Card(
                          elevation: 2, // Elevación de la tarjeta
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Bordes redondeados
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                              product.name ?? 'Producto sin nombre',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            leading: const CircleAvatar(
                              // Icono o imagen del producto
                              backgroundColor: Colors.blueGrey,
                              // Icono o imagen del producto
                              child: Icon(Icons.shopping_bag_outlined, color: Colors.white),
                            ),
                            subtitle: Text(product.description ?? 'Sin descripción'),
                            trailing: Text(
                              "\$${product.unitPrice!.toStringAsFixed(2)}",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                color: Colors.white, // Color de fondo para el indicador de páginas
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                    totalPages,
                    (index) => GestureDetector(
                      onTap: () => pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: pageController.hasClients && pageController.page!.round() == index
                              ? Colors.blueGrey // Color cuando la página está activa
                              : Colors.blueGrey.withOpacity(0.5), // Color inactivo
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        error: (_, error) => const Text("Error al conectar con la Base"),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey, // Color del botón
        child: const Icon(Icons.add, color: Colors.white), // Icono del botón
        onPressed: () {
          ref.read(routerProvider).go(RoutesNames.createProduct);
        },
      ),
    );
  }
}