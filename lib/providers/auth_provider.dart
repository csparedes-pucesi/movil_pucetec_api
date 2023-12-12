import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final emailProvider = StateProvider<String>((ref) => '');
final passProvider = StateProvider<String>((ref) => '');

final loginProvider = FutureProvider.autoDispose((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.post('https://pucei.edu.ec:9108/auth/login',
      data: {
        "email": ref.watch(emailProvider),
        "password": ref.watch(passProvider)
      });
  return response.data;
});
