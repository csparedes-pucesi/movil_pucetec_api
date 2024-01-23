import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movil_pucetec_api/providers/create_products_provider.dart';
import 'package:movil_pucetec_api/routes/app_routes.dart';

class CreateProduct extends ConsumerWidget {
  const CreateProduct({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController unitPriceController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController presentationController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Ropa'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Añadir un nuevo producto de categoria Ropa',
              style: TextStyle(fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Ingrese el nombre de la Ropa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextFormField(
                controller: unitPriceController,
                decoration: InputDecoration(
                  labelText: 'Precio',
                  hintText: 'Ingrese el precio unitario de producto',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripcion',
                  hintText: 'Ingrese la descripcion del Producto',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextFormField(
                controller: presentationController,
                decoration: InputDecoration(
                  labelText: 'Presentacion',
                  hintText: 'Ingrese la presentacion del producto',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                onPressed: () async {
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

                  final resp = await ref.read(createProductsProvider.future);
                  // ignore: prefer_interpolation_to_compose_strings
                  final msg = "Producto Agregado: "+resp["data"]["name"];
                  Fluttertoast.showToast(
                        msg: msg.toString(),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        fontSize: 16.0);
                },
                child: const Text('Agregar'),
                
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                onPressed: () async {
                  ref.read(routerProvider).go(RoutesNames.dashboard);
                },
                child: const Text('Regresar'),
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}
