// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movil_pucetec_api/models/product_model.dart';
import 'package:movil_pucetec_api/providers/create_products_provider.dart';
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
      body: RefreshIndicator(
        onRefresh: () async {
          final refreshedProducts = ref.refresh(productsProvider);
        },
        child: productProviderAsync.when(
          data: (products) => ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index];
              return ListTile(
                title: Text(product.name ?? 'Sin Nombre'),
                leading: const Icon(Icons.shopping_bag_outlined),
                subtitle: Text(product.description ?? 'Sin Descripcion'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showEditDialog(context, ref, product);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        String idproduct = product.id!;
                        ref
                            .read(idProvider.notifier)
                            .update((state) => state = idproduct);
                        await ref.read(deleteProductProvier.future);
                        final refreshedProducts = ref.refresh(productsProvider);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          error: (_, error) => const Text("Error al conectar con la Base"),
          loading: () => const CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            ref.read(routerProvider).go(RoutesNames.createProduct);
          }),
    );
  }
}

Future<void> _showEditDialog(
    BuildContext context, WidgetRef ref, ProductModel product) async {
  final TextEditingController nameController =
      TextEditingController(text: product.name);
  final TextEditingController descriptionController =
      TextEditingController(text: product.description);
  final TextEditingController unitPriceController =
      TextEditingController(text: product.unitPrice.toString());
  final TextEditingController presentationController =
      TextEditingController(text: product.presentation);
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Editar Producto'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration:
                    const InputDecoration(hintText: "Nombre del Producto"),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(hintText: "Descripción"),
              ),
              TextField(
                controller: unitPriceController,
                decoration: const InputDecoration(hintText: "Precio"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: presentationController,
                decoration: const InputDecoration(hintText: "Presentacion"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          IconButton(
            icon: const Icon(Icons.beenhere_rounded),
            onPressed: () async {
              ref
                  .read(idProvider.notifier)
                  .update((state) => state = product.id!);
              ref
                  .read(nameProvider.notifier)
                  .update((state) => state = nameController.text);
              ref
                  .read(unitPriceProvider.notifier)
                  .update((state) => state = unitPriceController.text);
              ref
                  .read(descriptionProvider.notifier)
                  .update((state) => state = descriptionController.text);
              ref
                  .read(presentationProvider.notifier)
                  .update((state) => state = presentationController.text);
              ref
                  .read(categoryProvider.notifier)
                  .update((state) => state = product.category!.id!);
              final resp = await ref.read(editProductProvier.future);
              final refreshedProducts = ref.refresh(productsProvider);
              // ignore: prefer_interpolation_to_compose_strings
              final msg = "Producto Actualizado: " + resp["data"]["name"];
              Fluttertoast.showToast(
                  msg: msg.toString(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
          ),
        ],
      );
    },
  );
}
