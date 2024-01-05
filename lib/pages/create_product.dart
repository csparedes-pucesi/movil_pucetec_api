import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movil_pucetec_api/providers/create_products_provider.dart';
import 'package:movil_pucetec_api/routes/app_routes.dart';

class CreateProduct extends ConsumerWidget {
  const CreateProduct({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final unitPriceController = TextEditingController();
    final descriptionController = TextEditingController();
    final presentationController = TextEditingController();
  

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Productos'),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const HeaderText('Añadir un nuevo producto'),
            const SizedBox(height: 20),
            CustomTextField(
              controller: nameController,
              labelText: 'Nombre del Producto',
              hintText: 'Ejemplo: Manzanas',
            ),
            CustomTextField(
              controller: unitPriceController,
              labelText: 'Precio Unitario',
              hintText: 'Ejemplo: \$0.99',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            CustomTextField(
              controller: descriptionController,
              labelText: 'Descripción',
              hintText: 'Ejemplo: Manzanas rojas frescas',
            ),
            CustomTextField(
              controller: presentationController,
              labelText: 'Presentación',
              hintText: 'Ejemplo: Bolsa de 1 Kg',
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: 'Agregar Producto',
              onPressed: () async {
                await _addProduct(
                  ref,
                  nameController.text,
                  unitPriceController.text,
                  descriptionController.text,
                  presentationController.text,
                );
              },
            ),
            CustomButton(
              label: 'Regresar',
              onPressed: () =>
                  ref.read(routerProvider).go(RoutesNames.dashboard),
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addProduct(
    WidgetRef ref,
    String name,
    String price,
    String description,
    String presentation,
  ) async {
  
    ref.read(nameProvider.notifier).state = name;
    ref.read(unitPriceProvider.notifier).state = price;
    ref.read(descriptionProvider.notifier).state = description;
    ref.read(presentationProvider.notifier).state = presentation;

    
    final response = await ref.read(createProductsProvider.future);

    
    if (response["data"] != null && response["data"]["name"] != null) {
      final msg = "Producto Agregado: ${response["data"]["name"]}";
      _showToast(msg, Colors.green);
    } else {
      _showToast("Error al agregar el producto", Colors.red);
    }
  }

  void _showToast(String message, Color color) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType? keyboardType;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          fillColor: Colors.blueGrey[50],
          filled: true,
        ),
        keyboardType: keyboardType,
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? color;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.blueGrey, // Color de fondo del botón
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

class HeaderText extends StatelessWidget {
  final String text;

  const HeaderText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
