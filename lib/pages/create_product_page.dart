import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movil_pucetec_api/providers/new_product_provider.dart';
import 'package:movil_pucetec_api/routes/app_routes.dart';

class CreateProductPage extends ConsumerStatefulWidget {
  const CreateProductPage({super.key});

  @override
  ConsumerState<CreateProductPage> createState() => _CreateProductState();
}

class _CreateProductState extends ConsumerState<CreateProductPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController unitPriceController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController presentationController =
        TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Ropa'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Añadir un nuevo producto',
                style: TextStyle(fontSize: 18),
              ),
              _buildTextField(
                controller: nameController,
                labelText: 'Nombre',
                hintText: 'Ingrese el nombre de la Ropa',
                icon: Icons.shopping_bag_outlined,
              ),
              _buildTextField(
                controller: unitPriceController,
                labelText: 'Precio',
                hintText: 'Ingrese el precio unitario de producto',
                icon: Icons.attach_money_outlined,
              ),
              _buildTextField(
                controller: descriptionController,
                labelText: 'Descripcion',
                hintText: 'Ingrese la descripcion del Producto',
                icon: Icons.article_outlined,
              ),
              _buildTextField(
                controller: presentationController,
                labelText: 'Presentacion',
                hintText: 'Ingrese la presentacion del producto',
                icon: Icons.archive_outlined,
              ),
              _buildElevatedButton(
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

                  final resp = await ref.read(newProductProvider.future);
                  final msg = "Producto Agregado: " + resp["data"]["name"];
                  Fluttertoast.showToast(
                    msg: msg.toString(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    fontSize: 16.0,
                  );
                },
                label: 'Agregar',
              ),
              _buildElevatedButton(
                onPressed: () async {
                  ref.read(routerProvider).go(RoutesNames.dashboard);
                },
                label: 'Regresar',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildElevatedButton({
    required VoidCallback onPressed,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
