import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movil_pucetec_api/configs/shared_prefs.dart';
import 'package:movil_pucetec_api/models/product_model.dart';

final productToUpdateProvider = StateProvider<ProductModel?>((ref) => null);

final dioProvider = Provider<Dio>((ref) => Dio());

final nameProvider = StateProvider<String>((ref) => '');
final unitPriceProvider = StateProvider<String>((ref) => '');
final descriptionProvider = StateProvider<String>((ref) => '');
final presentationProvider = StateProvider<String>((ref) => '');

final createProductsProvider = FutureProvider.autoDispose<Map<String, dynamic>>(
  (ref) async {
    final dio = ref.watch(dioProvider);

    final String unitPriceString = ref.watch(unitPriceProvider);

    try {
      final int unitPrice = int.parse(unitPriceString);
      final double doubleUnitPrice = unitPrice.toDouble();

      final ProductModel? productToUpdate = ref.watch(productToUpdateProvider);

      final response = productToUpdate != null
          ? await dio.put(
              'https://pucei.edu.ec:9108/products/${productToUpdate.id}',
              options: Options(
                validateStatus: (status) => status! < 500,
                headers: {
                  "Authorization":
                      "Bearer ${SharedPrefs.prefs.getString('token')}"
                },
              ),
              data: {
                "name": ref.watch(nameProvider),
                "unitPrice": doubleUnitPrice,
                "description": ref.watch(descriptionProvider),
                "presentation": ref.watch(presentationProvider),
                "category": "656f9b5b8e9e07c4d066c190"
              },
            )
          : await dio.post(
              'https://pucei.edu.ec:9108/products',
              options: Options(
                validateStatus: (status) => status! < 500,
                headers: {
                  "Authorization":
                      "Bearer ${SharedPrefs.prefs.getString('token')}"
                },
              ),
              data: {
                "name": ref.watch(nameProvider),
                "unitPrice": doubleUnitPrice,
                "description": ref.watch(descriptionProvider),
                "presentation": ref.watch(presentationProvider),
                "category": "656f9b5b8e9e07c4d066c190"
              },
            );

      if (response.statusCode == 200 || response.statusCode == 201) {
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
      print("Error creating/updating product: $error");
      return <String, dynamic>{
        "data": null,
        "status": 400,
      };
    }
  },
);
