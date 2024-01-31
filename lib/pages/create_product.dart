import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movil_pucetec_api/providers/new_product_provider.dart';
import 'package:movil_pucetec_api/routes/app_routes.dart';

class CreateProduct extends ConsumerStatefulWidget {
  const CreateProduct({super.key});

  @override
  ConsumerState<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends ConsumerState<CreateProduct> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController unitPriceController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController presentationController =
        TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Añadir un nuevo producto  ',
                style: TextStyle(fontSize: 18),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    hintText: 'Ingrese el nombre ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextFormField(
                  controller: unitPriceController,
                  decoration: InputDecoration(
                    labelText: 'Precio',
                    hintText: ' Precio unitario del producto',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Descripcion',
                    hintText: ' Descripcion del Producto',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextFormField(
                  controller: presentationController,
                  decoration: InputDecoration(
                    labelText: 'Presentacion',
                    hintText: ' Presentacion del producto',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                    final msg = "Producto Agregado: " + resp["data"]["name"];
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
      ),
    );
  }
}
