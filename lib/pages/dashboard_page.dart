import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movil_pucetec_api/models/product_model.dart';
import 'package:movil_pucetec_api/providers/new_product_provider.dart';
import 'package:movil_pucetec_api/providers/products_provider.dart';
import 'package:movil_pucetec_api/routes/app_routes.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productProviderAsync = ref.watch(productsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: productProviderAsync.when(
            data: (products) => Column(
              children: products
                  .asMap()
                  .entries
                  .map(
                    (entry) =>
                        _buildProductCard(entry.value, entry.key, context, ref),
                  )
                  .toList(),
            ),
            error: (_, __) => const Text('No se pudo cargar la data'),
            loading: () => const CircularProgressIndicator(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(routerProvider).push(RoutesNames.createProduct);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductCard(
    ProductModel product,
    int index,
    BuildContext context,
    WidgetRef ref,
  ) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.shopping_bag, color: Colors.white),
        ),
        title: Text('${index + 1}. ${product.name ?? 'Sin nombre'}'),
        subtitle: Text(product.description ?? 'Sin descripción'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                _showEditDialog(context, ref, product);
              },
              child: const Icon(Icons.edit, color: Colors.white),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () async {
                String idproduct = product.id!;
                ref.read(idProvider.notifier)
                  ..update((state) => state = idproduct);
                await ref.read(deleteProductProvier.future);
                final refreshedProducts = ref.refresh(productsProvider);
              },
              child: const Icon(Icons.delete, color: Colors.white),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    ProductModel product,
  ) async {
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
          title: Text('Editar Producto', style: TextStyle(color: Colors.blue)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Nombre del Producto",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: "Descripción",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: unitPriceController,
                  decoration: InputDecoration(
                    hintText: "Precio",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: presentationController,
                  decoration: InputDecoration(
                    hintText: "Presentacion",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                ref.read(idProvider.notifier)
                  ..update((state) => state = product.id!);
                ref.read(nameProvider.notifier)
                  ..update((state) => state = nameController.text);
                ref.read(unitPriceProvider.notifier)
                  ..update((state) => state = unitPriceController.text);
                ref.read(descriptionProvider.notifier)
                  ..update((state) => state = descriptionController.text);
                ref.read(presentationProvider.notifier)
                  ..update((state) => state = presentationController.text);
                ref.read(categoryProvider.notifier)
                  ..update((state) => state = product.category!.id!);
                final resp = await ref.read(editProductProvier.future);

                final refreshedProducts = ref.refresh(productsProvider);
                final msg =
                    "Producto editado con éxito: " + resp["data"]["name"];
                Fluttertoast.showToast(
                  msg: msg.toString(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                Navigator.of(context)
                    .pop(); // Cerrar el diálogo después de editar
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(Icons.save, color: Colors.white),
                  SizedBox(width: 8.0),
                  Text('Guardar',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
