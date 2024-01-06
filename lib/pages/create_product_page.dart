import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movil_pucetec_api/providers/new_product_provider.dart';

class CreateProductPage extends ConsumerWidget {
  const CreateProductPage({Key? key}) : super(key: key);

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
        backgroundColor:
            Colors.teal, // Cambiar el color de la barra de navegación
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Añadir Nuevo Producto',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: productNameController,
                style:
                    TextStyle(color: Colors.teal), // Cambiar el color del texto
                decoration: InputDecoration(
                  labelText: 'Nombre del Producto:',
                  hintText: 'Ingrese Nombre del Producto',
                  prefixIcon: Icon(Icons.shopping_bag,
                      color: Colors.teal), // Cambiar el color del ícono
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: unitPriceController,
                style: TextStyle(color: Colors.teal),
                decoration: InputDecoration(
                  labelText: 'Precio del Producto:',
                  hintText: 'Ingrese el Precio del Producto',
                  prefixIcon: Icon(Icons.attach_money, color: Colors.teal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: descriptionController,
                style: TextStyle(color: Colors.teal),
                decoration: InputDecoration(
                  labelText: 'Descripción del Producto:',
                  hintText: 'Descripción del Producto',
                  prefixIcon: Icon(Icons.description, color: Colors.teal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: presentationController,
                style: TextStyle(color: Colors.teal),
                decoration: InputDecoration(
                  labelText: 'Presentación del Producto:',
                  hintText: 'Presentación del Producto',
                  prefixIcon: Icon(Icons.shopping_cart, color: Colors.teal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
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
                  backgroundColor:
                      Colors.teal, // Cambiar el color del fondo del mensaje
                  textColor:
                      Colors.white, // Cambiar el color del texto del mensaje
                  fontSize: 14,
                );
              },
              icon: Icon(Icons.save),
              label: const Text('Guardar'),
              style: ElevatedButton.styleFrom(
                primary: Colors.teal, // Cambiar el color del botón
              ),
            ),
          ],
        ),
      ),
    );
  }
}
