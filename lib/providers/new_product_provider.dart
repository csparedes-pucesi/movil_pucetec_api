import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movil_pucetec_api/config/shared_prefs.dart';
import 'package:movil_pucetec_api/model/category_model.dart';

final dioProvider = Provider<Dio>((ref) => Dio());
final productNameProvider = StateProvider((ref) => '');
final unitPriceProvider = StateProvider((ref) => '');
final descriptionProvider = StateProvider((ref) => '');
final presentationProvider = StateProvider((ref) => '');
// final categoryIdProvider = StateProvider((ref) => '');

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
        "category": ref.watch(categorySelected),
      },
    );
    return <String, dynamic>{
      "data": response.data,
      "status": response.statusCode,
    };
  } catch (err) {
    return <String, dynamic>{
      "data": null,
      "status": 400,
      "error": err.toString(),
    };
  }
});

final categorySelected = StateProvider<String?>((ref) => null);

final categoryProvider =
    FutureProvider.autoDispose<List<Category>>((ref) async {
  try {
    final dio = ref.watch(dioProvider);
    final response = await dio.get(
      'https://pucei.edu.ec:9108/categories',
      options: Options(
        validateStatus: (status) => status! < 500,
        headers: {
          "Authorization": "Bearer ${SharedPrefs.prefs.getString('token')}"
        },
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseCategories = response.data;
      final List<Category> categoriesList = responseCategories
          .map(
            (category) => Category.fromJson(category),
          )
          .toList();

      return categoriesList;
    } else {
      return [];
    }
  } catch (e) {
    print(e);
    return [];
  }
});

final updateProductProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, String>((ref, idProduct) async {
  final dio = ref.watch(dioProvider);
  final double unitPrice = double.parse(ref.watch(unitPriceProvider));

  try {
    final response = await dio.patch(
      'https://pucei.edu.ec:9108/products/$idProduct',
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
        // "category": ref.watch(categorySelected),
      },
    );
    return <String, dynamic>{
      "data": response.data,
      "status": response.statusCode,
    };
  } catch (err) {
    return <String, dynamic>{
      "data": null,
      "status": 400,
      "error": err.toString(),
    };
  }
});

final deleteProductProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, String>((ref, idProduct) async {
  final dio = ref.watch(dioProvider);

  try {
    final response = await dio.delete(
      'https://pucei.edu.ec:9108/products/$idProduct',
      options: Options(
        validateStatus: (status) => status! < 500,
        headers: {
          "Authorization": "Bearer ${SharedPrefs.prefs.getString('token')}"
        },
      ),
    );
    return <String, dynamic>{
      "data": response.data,
      "status": response.statusCode,
    };
  } catch (err) {
    return <String, dynamic>{
      "data": null,
      "status": 400,
      "error": err.toString(),
    };
  }
});
