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
            Colors.blue, // Cambiar el color de la barra de navegación
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Añadir Nuevo Producto',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24.0),
            _buildTextField(
              controller: productNameController,
              labelText: 'Nombre del Producto',
              hintText: 'Ingrese el nombre del producto',
              icon: Icons.shopping_bag_outlined, // Icono de bolsa de compras
            ),
            const SizedBox(height: 16.0),
            _buildTextField(
              controller: unitPriceController,
              labelText: 'Precio del Producto',
              hintText: 'Ingrese el precio',
              icon: Icons.attach_money_outlined, // Icono de dinero
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            _buildTextField(
              controller: descriptionController,
              labelText: 'Descripción del Producto',
              hintText: 'Describa el producto',
              icon: Icons.article_outlined, // Icono de documento de texto
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            _buildTextField(
              controller: presentationController,
              labelText: 'Presentación del Producto',
              hintText: 'Describa la presentación',
              icon: Icons.archive_outlined, // Icono de archivo
              maxLines: 3,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
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
                final message = "Agregado: ${resp["data"]["name"]}";
                Fluttertoast.showToast(
                  msg: message.toString(),
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  fontSize: 16,
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                primary: Colors.blue, // Cambiar el color del botón
              ),
              child: const Text(
                'Guardar',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
    IconData? icon,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: icon != null ? Icon(icon) : null,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
