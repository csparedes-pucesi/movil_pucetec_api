import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movil_pucetec_api/providers/products_provider.dart';
import 'package:movil_pucetec_api/routes/app_routes.dart';
import 'package:movil_pucetec_api/configs/shared_prefs.dart';
import 'package:movil_pucetec_api/models/product_model.dart';
import 'package:dio/dio.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productProviderAsync = ref.watch(productsProvider);

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
              return ListTile(
                title: Text(product.name ?? 'Sin nombre'),
                leading: const Icon(Icons.shopping_bag_outlined),
                subtitle: Text(product.description ?? 'Sin Descripcion'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProductPage(productToEdit: product),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final resp = await Dio().delete(
                          'https://pucei.edu.ec:9108/products/${product.id}',
                          options: Options(
                            validateStatus: (status) => status! < 500,
                            headers: {
                              "Authorization":
                                  "Bearer ${SharedPrefs.prefs.getString('token')}"
                            },
                          ),
                        );
                        if (resp.statusCode == 200) {
                          ref.refresh(productsProvider);
                          Fluttertoast.showToast(
                            msg: "Producto eliminado",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: "Error al eliminar el producto",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          error: (_, error) => const Text("No se pudo cargar la información"),
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

class EditProductPage extends StatelessWidget {
  final ProductModel productToEdit;

  const EditProductPage({required this.productToEdit, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController unitPriceController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController presentationController =
        TextEditingController();

    nameController.text = productToEdit.name ?? '';
    unitPriceController.text = productToEdit.unitPrice?.toString() ?? '';
    descriptionController.text = productToEdit.description ?? '';
    presentationController.text = productToEdit.presentation ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Add the product name',
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
                  hintText: 'Add the product price',
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
                  hintText: 'Add the product description',
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
                  hintText: 'Add the product presentation',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
