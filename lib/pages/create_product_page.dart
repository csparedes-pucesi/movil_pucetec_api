import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movil_pucetec_api/providers/new_product_provider.dart';

class CreateProductPage extends ConsumerWidget {
  const CreateProductPage({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController productNameController = TextEditingController();
    final TextEditingController unitPriceController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController presentationController =
        TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Producto'),
        backgroundColor: Colors.red, // Cambiar el color del AppBar a rojo
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Añadir nuevo producto',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: productNameController,
              decoration: InputDecoration(
                labelText: 'Nombre del producto:',
                hintText: 'Nombre del producto',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: unitPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Precio del producto:',
                hintText: 'Precio del producto',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Descripción:',
                hintText: 'Descripción del producto',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: presentationController,
              decoration: InputDecoration(
                labelText: 'Presentación:',
                hintText: 'Presentación del producto',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Cambiar el color del botón a rojo
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () async {
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
                final message =
                    "Nuevo producto agregado ${resp["data"]["name"]}";
                Fluttertoast.showToast(
                  msg: message.toString(),
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 14,
                );
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
