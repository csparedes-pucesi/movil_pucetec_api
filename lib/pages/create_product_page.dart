import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movil_pucetec_api/providers/new_product_provider.dart';

class CreateProductPage extends ConsumerWidget {
  const CreateProductPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController productNameController = TextEditingController();
    final TextEditingController unitPriceController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController presentationController =
        TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: const Text('New Product'),
        ),
        body: Center(
          child: Column(
            children: [
              const Text(
                'Añadir nuevo producto',
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextFormField(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextFormField(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ElevatedButton(
                  child: const Text('Guardar'),
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
                        fontSize: 14);
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
