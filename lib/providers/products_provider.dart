import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movil_pucetec_api/configs/shared_prefs.dart';
import 'package:movil_pucetec_api/models/product_model.dart';

final productListProvider = StateProvider((ref) => []);

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

  final List<ProductModel> products = responseData.map((prod){
    return ProductModel.fromJson(prod);
  }).toList(); 
  return products;
});


final productDeletionProvider = FutureProvider.family<void, String>((ref, productId) async {
  final dio = ref.watch(dioProvider);
  await dio.delete(
    'https://pucei.edu.ec:9108/products/$productId',
    options: Options(
      validateStatus: (status) => status! < 500,
      headers: {
        "Authorization": "Bearer ${SharedPrefs.prefs.getString('token')}"
      },
    ),
  );
});
