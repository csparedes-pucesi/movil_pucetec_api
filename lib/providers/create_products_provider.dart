import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movil_pucetec_api/configs/shared_prefs.dart';
final nameProvider = StateProvider<String>((ref) => '');
final unitPriceProvider = StateProvider<String>((ref) => '');

final descriptionProvider = StateProvider<String>((ref) => ''); 
final presentationProvider = StateProvider<String>((ref) => ''); 
final dioProvider = Provider<Dio>((ref) => Dio());
final createProductsProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final dio = ref.watch(dioProvider);

  // Obtén el valor como String desde el StateProvider
  final String unitPriceString = ref.watch(unitPriceProvider);

  try {
    // Intenta convertir la cadena a un número antes de incluirlo en la solicitud POST
    final int unitPrice = int.parse(unitPriceString);

    final response = await dio.post(
      'https://pucei.edu.ec:9108/products',
      options: Options(
        validateStatus: (status) => status! < 500,
        headers: {
          "Authorization": "Bearer ${SharedPrefs.prefs.getString('token')}"
        },
      ),
      data: {
        "name": ref.watch(nameProvider),
        "unitPrice": unitPrice, // Utiliza el valor numérico convertido
        "description": ref.watch(descriptionProvider),
        "presentation": ref.watch(presentationProvider),
        "category": "656f9afb8e9e07c4d066c184"
      },
    );

    if (response.statusCode == 201) {
      return <String, dynamic>{
        "data": response.data,
        "status": response.statusCode,
      };
    } else {
      return <String, dynamic>{
        "data": response.data,
        "status": response.statusCode,
      };
    }
  } catch (error) {
    return <String, dynamic>{
      "data": null,
      "status": 400, // Puedes ajustar el código de estado según sea necesario
    };
  }
});
