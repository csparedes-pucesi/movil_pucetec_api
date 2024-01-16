import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movil_pucetec_api/providers/create_products_provider.dart';
import 'package:movil_pucetec_api/routes/app_routes.dart';
import 'package:movil_pucetec_api/configs/shared_prefs.dart';
import 'package:movil_pucetec_api/models/product_model.dart';
import 'package:dio/dio.dart';

class EditProductPage extends ConsumerWidget {
  final ProductModel productToEdit;

  EditProductPage({required this.productToEdit, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController nameController =
        TextEditingController(text: productToEdit.name ?? '');
    final TextEditingController unitPriceController =
        TextEditingController(text: productToEdit.unitPrice?.toString() ?? '');
    final TextEditingController descriptionController =
        TextEditingController(text: productToEdit.description ?? '');
    final TextEditingController presentationController =
        TextEditingController(text: productToEdit.presentation ?? '');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Edit the product',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Edit the product name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: unitPriceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    hintText: 'Edit the product price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Edit the product description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: presentationController,
                  decoration: InputDecoration(
                    labelText: 'Presentation',
                    hintText: 'Edit the product presentation',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    // Obtén los valores de los controladores
                    final name = nameController.text;
                    final unitPrice = unitPriceController.text;
                    final description = descriptionController.text;
                    final presentation = presentationController.text;

                    // Llama a la función de actualización con estos valores
                    await ref
                        .read(nameProvider.notifier)
                        .update((state) => state = name);
                    await ref
                        .read(unitPriceProvider.notifier)
                        .update((state) => state = unitPrice);
                    await ref
                        .read(descriptionProvider.notifier)
                        .update((state) => state = description);
                    await ref
                        .read(presentationProvider.notifier)
                        .update((state) => state = presentation);

                    // Call the provider for updating the product
                    final resp = await ref.read(createProductsProvider).value!;

                    final msg = "Product updated: ${resp["data"]["name"]}";
                    Fluttertoast.showToast(
                      msg: msg.toString(),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );

                    // Refresh the product list
                    ref.read(routerProvider).go(RoutesNames.dashboard);
                  },
                  child: const Text('Update'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    ref.read(routerProvider).go(RoutesNames.dashboard);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
