import '../../models/match_models.dart';
import 'base_api_service.dart';

class MatchApiService extends BaseApiService {
  /// 매칭 알고리즘 프로세스 실행
  static Future<MatchResponse> processMatching(String serviceRequestId) async {
    // POST이지만 serviceRequestId는 쿼리 파라미터로 전달
    final url = '/api/match/process?serviceRequestId=$serviceRequestId';
    final response = await BaseApiService.post(
      url,
      {}, // 빈 body
      (json) => MatchResponse.fromJson(json),
    );
    return response;
  }
}