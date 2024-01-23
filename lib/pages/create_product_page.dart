import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movil_pucetec_api/model/product_model.dart';
import 'package:movil_pucetec_api/providers/new_product_provider.dart';
import 'package:movil_pucetec_api/routes/app_routes.dart';

class CreateProductPage extends ConsumerWidget {
  const CreateProductPage(this.product, {super.key});

  final ProductModel? product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController productNameController = TextEditingController();
    productNameController.text = product == null ? '' : product!.name!;
    final TextEditingController unitPriceController = TextEditingController();
    unitPriceController.text =
        product == null ? '' : product!.unitPrice!.toStringAsFixed(2);
    final TextEditingController descriptionController = TextEditingController();
    descriptionController.text = product == null ? '' : product!.description!;
    final TextEditingController presentationController =
        TextEditingController();
    presentationController.text = product == null ? '' : product!.presentation!;

    final categoryProviderAsync = ref.watch(categoryProvider);
    final categSelected = ref.watch(categorySelected);

    return Scaffold(
      appBar: AppBar(
        title: product == null
            ? const Text('Crear nuevo producto')
            : const Text('Actualizar producto'),
        backgroundColor: Colors.black87,
        actions: [
          product != null
              ? IconButton(
                  onPressed: () async {
                    final resp = await ref
                        .read(deleteProductProvider(product!.id!).future);
                    final message =
                        "Producto eliminado ${resp["data"]["name"]}";
                    Fluttertoast.showToast(
                        msg: message.toString(),
                        toastLength: Toast.LENGTH_SHORT,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white,
                        fontSize: 14);
                  },
                  icon: const Icon(Icons.delete))
              : const SizedBox(),
        ],
      ),
      body: Container(
        color: Colors.black54,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      product == null
                          ? "Seleccione una categoría"
                          : "Categoría:",
                      style: TextStyle(color: Colors.white),
                    ),
                    DropdownButton(
                        value: categSelected,
                        items: categoryProviderAsync.when(
                            data: (categories) => categories
                                .map((category) => DropdownMenuItem(
                                      value: category.id,
                                      child: Text(
                                        category.name ?? 'Sin nombre',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ))
                                .toList(),
                            error: (_, __) => const [],
                            loading: () => const []),
                        onChanged: (val) {
                          ref
                              .read(categorySelected.notifier)
                              .update((state) => val as String);
                        }),
                  ],
                ),
              ),
              _buildTextFormField(
                  controller: productNameController,
                  label: 'Nombre del producto:',
                  hint: 'mesa cahoba rustica'),
              _buildTextFormField(
                  controller: unitPriceController,
                  label: 'Precio del producto:',
                  hint: '120.00',
                  keyboardType: TextInputType.number),
              _buildTextFormField(
                  controller: descriptionController,
                  label: 'Descripción:',
                  hint: 'Descripción del producto'),
              _buildTextFormField(
                  controller: presentationController,
                  label: 'Presentación:',
                  hint: 'Presentación del producto'),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey,
                  ),
                  child: Text(
                    product == null ? 'Guardar' : 'Actualizar',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    product == null
                        ? onCreateProduct(
                            ref,
                            productNameController,
                            unitPriceController,
                            descriptionController,
                            presentationController)
                        : onUpdateProduct(
                            ref,
                            product!.id!,
                            productNameController,
                            unitPriceController,
                            descriptionController,
                            presentationController);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  // Guardar
  onCreateProduct(
      WidgetRef ref,
      TextEditingController productNameController,
      TextEditingController unitPriceController,
      TextEditingController descriptionController,
      TextEditingController presentationController) async {
    ref
        .read(productNameProvider.notifier)
        .update((state) => state = productNameController.text);
    ref
        .read(unitPriceProvider.notifier)
        .update((state) => state = unitPriceController.text);
    ref
        .read(descriptionProvider.notifier)
        .update((state) => state = descriptionController.text);
    ref
        .read(presentationProvider.notifier)
        .update((state) => state = presentationController.text);

    final resp = await ref.read(newProductProvider.future);
    final message = "Nuevo producto agregado ${resp["data"]["name"]}";
    ref.read(routerProvider).go(RoutesNames.dashboard);
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14);
  }

  // Actualizar
  void onUpdateProduct(
      WidgetRef ref,
      String idProduct,
      TextEditingController productNameController,
      TextEditingController unitPriceController,
      TextEditingController descriptionController,
      TextEditingController presentationController) async {
    ref
        .read(productNameProvider.notifier)
        .update((state) => state = productNameController.text);
    ref
        .read(unitPriceProvider.notifier)
        .update((state) => state = unitPriceController.text);
    ref
        .read(descriptionProvider.notifier)
        .update((state) => state = descriptionController.text);
    ref
        .read(presentationProvider.notifier)
        .update((state) => state = presentationController.text);

    final resp = await ref.read(updateProductProvider(idProduct).future);
    final message = "Producto actualizado ${resp["data"]["name"]}";
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14);
  }
}
