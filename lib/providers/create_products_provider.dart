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
  final String unitPriceString = ref.watch(unitPriceProvider);

  try {
    final double unitPrice = double.parse(
        unitPriceString); // Cambiado a double para manejar decimales

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
        "unitPrice": unitPrice,
        "description": ref.watch(descriptionProvider),
        "presentation": ref.watch(presentationProvider),
        "category":
            "656f9b2a8e9e07c4d066c18a" // Considera hacerlo dinámico si es necesario
      },
    );

    // Manejo de la respuesta
    if (response.statusCode == 201) {
      // Retorno exitoso
      return {
        "data": response.data,
        "status": response.statusCode,
      };
    } else {
      // Retorno de respuesta no exitosa
      return {
        "data": response.data,
        "status": response.statusCode,
      };
    }
  } on DioError catch (dioError) {
    // Captura de errores específicos de Dio
    return {
      "data": dioError.response?.data,
      "status": dioError.response?.statusCode ??
          500, // Utiliza el estado de la respuesta si está disponible
    };
  } catch (error) {
    // Captura de cualquier otro error
    return {
      "data": null,
      "status": 500, // Estado genérico para errores del servidor
    };
  }
});
