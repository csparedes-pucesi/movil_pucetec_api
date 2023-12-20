import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movil_pucetec_api/configs/shared_prefs.dart';
import 'package:movil_pucetec_api/models/product_model.dart';

final dioProvider = Provider<Dio>((ref) => Dio());
final productsProvider =
    FutureProvider.autoDispose<List<ProductModel>>((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get(
    'https://pucei.edu.ec:9108/products',
    options: Options(
      validateStatus: (status) => status! < 500,
      headers: {
        "Authorization": "Bearer ${SharedPrefs.prefs.getString('token')}"
      },
    ),
  );

  final List<dynamic> responseData = response.data;
  final List<ProductModel> products = responseData.map((prod) {
    return ProductModel.fromJson(prod);
  }).toList();
  return products;

  // final List<ProductModel> products = [];
  // final List<dynamic> responseData = response.data;
  // for (var i = 0; i < responseData.length; i++) {
  //   final prod = ProductModel.fromJson(responseData[i]);
  //   products.add(prod);
  // }
  // return products;
});
