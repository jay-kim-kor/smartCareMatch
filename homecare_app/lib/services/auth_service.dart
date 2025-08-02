import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_models.dart';
import 'api/user_api_service.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const String _userIdKey = 'user_id';

  static String? _currentUserId;

  /// 로그인 및 사용자 ID 저장
  static Future<UserLoginResponse> login(UserLoginRequest request) async {
    final response = await UserApiService.login(request);
    
    await _saveUserId(response.userId);
    
    return response;
  }

  /// 로그아웃 및 사용자 ID 삭제
  static Future<void> logout() async {
    await _clearUserId();
  }

  /// 사용자 ID 저장
  static Future<void> _saveUserId(String userId) async {
    _currentUserId = userId;
    await _storage.write(key: _userIdKey, value: userId);
  }

  /// 사용자 ID 삭제
  static Future<void> _clearUserId() async {
    _currentUserId = null;
    await _storage.delete(key: _userIdKey);
  }

  /// 저장된 사용자 ID 로드
  static Future<void> loadUserId() async {
    _currentUserId = await _storage.read(key: _userIdKey);
  }

  /// 현재 로그인 상태 확인
  static bool get isLoggedIn {
    return _currentUserId != null;
  }

  /// 현재 사용자 ID
  static String? get currentUserId => _currentUserId;
}