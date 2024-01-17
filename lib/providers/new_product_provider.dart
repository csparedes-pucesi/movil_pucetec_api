import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movil_pucetec_api/configs/shared_prefs.dart';
import 'package:movil_pucetec_api/models/category_model.dart';
//import 'package:movil_pucetec_api/providers/new_product_provider.dart';

final dioProvider = Provider<Dio>((ref) => Dio());
final idProvider = StateProvider<String>((ref) => '');
final productNameProvider = StateProvider((ref) => '');
final unitPriceProvider = StateProvider((ref) => '');
final descriptionProvider = StateProvider((ref) => '');
final presentationProvider = StateProvider((ref) => '');
final nameProvider = StateProvider<String>((ref) => '');
final categoryProvider = StateProvider<String>((ref) => '');

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

final categorySelected = StateProvider<String?>((ref) => null);

final categProvider = FutureProvider.autoDispose<List<Category>>((ref) async {
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
