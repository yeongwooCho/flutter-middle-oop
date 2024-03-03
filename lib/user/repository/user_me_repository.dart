import 'package:code_factory_middle/common/const/data.dart';
import 'package:code_factory_middle/common/repository/dio/dio.dart';
import 'package:code_factory_middle/user/model/user_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'user_me_repository.g.dart';

final userMeRepositoryProvider = Provider<UserMeRepository>((ref) {
  final dio = ref.watch(dioProvider);

  final repository = UserMeRepository(dio, baseUrl: 'http://$ip/user/me');

  return repository;
});

@RestApi()
abstract class UserMeRepository {
  // baseUrl = http://$ip/user/me
  factory UserMeRepository(Dio dio, {String baseUrl}) = _UserMeRepository;

  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<UserModel> getMe();
}
