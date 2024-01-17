// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movil_pucetec_api/model/product_model.dart';
import 'package:movil_pucetec_api/providers/new_product_provider.dart';
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
      body: Center(
        child: productProviderAsync.when(
          data: (products) => ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(product.name ?? 'Sin Nombre'),
                  leading: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.indigo, // Cambia el color del borde aquí
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: const Icon(Icons.shopping_cart),
                    ),
                  ),
                  subtitle: Text(product.description ?? 'Sin Descripcion'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          _showEditDialog(context, ref, product);
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text(
                          'Editar',
                          style: TextStyle(fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.indigo,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () async {
                          String idproduct = product.id!;
                          ref
                              .read(idProvider.notifier)
                              .update((state) => state = idproduct);
                          await ref.read(deleteProductProvier.future);
                          final refreshedProducts =
                              ref.refresh(productProvider);
                        },
                        icon: const Icon(Icons.remove_circle),
                        label: const Text(
                          'Eliminar',
                          style: TextStyle(fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          error: (_, error) =>
              Center(child: Text("Error al conectar con la Base")),
          loading: () => const CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          ref.read(routerProvider).go(RoutesNames.createProduct);
        },
      ),
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
              TextFormField(
                controller: nameController,
                decoration:
                    const InputDecoration(labelText: "Nombre del Producto"),
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Descripción"),
              ),
              TextFormField(
                controller: unitPriceController,
                decoration: const InputDecoration(labelText: "Precio"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: presentationController,
                decoration: const InputDecoration(labelText: "Presentacion"),
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
          ElevatedButton.icon(
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
              final refreshedProducts = ref.refresh(productProvider);
              final msg = "Producto Agregado: ${resp["data"]["name"]}";
              Fluttertoast.showToast(
                msg: msg.toString(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            },
            icon: const Icon(Icons.save),
            label: const Text(
              'Guardar',
              style: TextStyle(fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.teal,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
            ),
          ),
        ],
      );
    },
  );
}
