import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movil_pucetec_api/config/shared_prefs.dart';

final productListProvider = StateProvider<List<dynamic>>((ref) => []);

final dioProvider = Provider<Dio>((ref) => Dio());
final productProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('https://pucei.edu.ec:9108/products',
      options: Options(
        validateStatus: (status) => status! < 500,
        headers: {
          "Authorization": "Bearer ${SharedPrefs.prefs.getString('token')}"
        },
      ));
  return <String, dynamic> {
    "data": response.data,
    "status": response.statusCode,
  };
});
