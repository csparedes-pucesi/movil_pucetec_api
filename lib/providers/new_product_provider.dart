import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movil_pucetec_api/config/shared_prefs.dart';

final productNameProvider = StateProvider<String>((ref) => '');
final idProvider = StateProvider<String>((ref) => '');
final nameProvider = StateProvider<String>((ref) => '');
final unitPriceProvider = StateProvider<String>((ref) => '');
final descriptionProvider = StateProvider<String>((ref) => '');
final presentationProvider = StateProvider<String>((ref) => '');
final categoryProvider = StateProvider<String>((ref) => '');
final dioProvider = Provider<Dio>((ref) => Dio());
final newProductProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final dio = ref.watch(dioProvider);
  final String unitPriceString = ref.watch(unitPriceProvider);
  try {
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
        "unitPrice": unitPrice,
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
      "status": 400,
    };
  }
});

final editProductProvier = FutureProvider.autoDispose((ref) async {
  final String idProduct = ref.watch(idProvider);
  final dio = ref.watch(dioProvider);
  final String unitPriceString = ref.watch(unitPriceProvider);
  try {
    final double unitPrice = double.parse(unitPriceString);
    final resp = await dio.patch(
      'https://pucei.edu.ec:9108/products/$idProduct',
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
        "category": ref.watch(categoryProvider),
      },
    );
    return <String, dynamic>{
      "data": resp.data,
      "status": resp.statusCode,
    };
  } catch (error) {
    return <String, dynamic>{
      "data": error,
      "status": 400,
    };
  }
});

final deleteProductProvier = FutureProvider.autoDispose((ref) async {
  final String idProduct = ref.watch(idProvider);
  final dio = ref.watch(dioProvider);
  try {
    await dio.delete(
      'https://pucei.edu.ec:9108/products/$idProduct',
      options: Options(
        validateStatus: (status) => status! < 500,
        headers: {
          "Authorization": "Bearer ${SharedPrefs.prefs.getString('token')}"
        },
      ),
    );
  } catch (error) {
    return <String, dynamic>{
      "data": error,
      "status": 400,
    };
  }
});
