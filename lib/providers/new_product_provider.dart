import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movil_pucetec_api/config/shared_prefs.dart';

final dioProvider = Provider<Dio>((ref) => Dio());
final productNameProvider = StateProvider((ref) => '');
final unitPriceProvider = StateProvider((ref) => '');
final descriptionProvider = StateProvider((ref) => '');
final presentationProvider = StateProvider((ref) => '');

final newProductProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final dio = ref.watch(dioProvider);
  final int unitPrice = int.parse(ref.watch(unitPriceProvider));

  try {
    final response = await dio.post(
      'https://pucei.edu.ec:9108/products',
      options: Options(
        validateStatus: (status) => status! < 500,
        headers: {
          "Authorization": "Bearer ${SharedPrefs.prefs.getString('token')}"
        },
      ),
      data: {
        "name": ref.watch(productNameProvider),
        "unitPrice": unitPrice,
        "description": ref.watch(descriptionProvider),
        "presentation": ref.watch(presentationProvider),
        "category": "656f9b908e9e07c4d066c199",
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
  } catch (err) {
    return <String, dynamic>{
      "data": null,
      "status": 400,
    };
  }
});
