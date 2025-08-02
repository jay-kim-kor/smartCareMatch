import '../../models/user_models.dart';
import 'base_api_service.dart';

class UserApiService extends BaseApiService {  
  static Future<UserLoginResponse> login(UserLoginRequest request) async {
    try {
      return await BaseApiService.post(
        '/api/user/login',
        request.toJson(),
        (json) => UserLoginResponse.fromJson(json),
      );
    } on ApiException catch (e) {
      throw ApiException(message: e.message);
    }
  }

  static Future<void> registerConsumer(ConsumerCreateRequest request) async {
    try {
      return await BaseApiService.postVoid(
        '/api/consumer/register',
        request.toJson(),
        successCodes: [204],
      );
    } on ApiException catch (e) {
      throw ApiException(message: e.message);
    }
  }

  static Future<void> logout() async {
    try {
      return await BaseApiService.postVoid(
        '/api/user/logout',
        {},
        successCodes: [200],
      );
    } on ApiException catch (e) {
      throw ApiException(message: e.message);
    }
  }
}