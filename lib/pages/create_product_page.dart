import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movil_pucetec_api/model/product_model.dart';
// import 'package:movil_pucetec_api/model/category_model.dart';
import 'package:movil_pucetec_api/providers/new_product_provider.dart';
import 'package:movil_pucetec_api/routes/app_routes.dart';

class CreateProductPage extends ConsumerWidget {
  const CreateProductPage(this.product, {super.key});

  final ProductModel? product;
// product = Instance of ProductModel
// product = null
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
        actions: [
          product != null
              ? IconButton(
                  onPressed: () async {
                    // llamar provider para borrar producto
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
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(product == null
                      ? "Seleccione una categoría"
                      : "Categoría:"),
                  DropdownButton(
                      // isExpanded: true,
                      value: categSelected,
                      items: categoryProviderAsync.when(
                          data: (categories) => categories
                              .map((category) => DropdownMenuItem(
                                    value: category.id,
                                    child: Text(category.name ?? 'Sin nombre'),
                                  ))
                              .toList(),
                          error: (_, __) => const [],
                          loading: () => const []),
                      onChanged: (val) {
                        print(val);
                        ref
                            .read(categorySelected.notifier)
                            .update((state) => val as String);

                        // ref.read(categoryIdProvider.notifier).update((state) => null)
                      }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextFormField(
                // initialValue: product == null ? '': product?.name,
                controller: productNameController,
                decoration: InputDecoration(
                  labelText: 'nombre del producto:',
                  hintText: 'mesa cahoba rustica',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: unitPriceController,
                decoration: InputDecoration(
                  labelText: 'Precio del producto:',
                  hintText: '120.00',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción:',
                  hintText: 'Descripción del producto',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextFormField(
                controller: presentationController,
                decoration: InputDecoration(
                  labelText: 'Presentación:',
                  hintText: 'Presentación del producto',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ElevatedButton(
                child: Text(product == null ? 'Guardar' : 'Actualizar'),
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
