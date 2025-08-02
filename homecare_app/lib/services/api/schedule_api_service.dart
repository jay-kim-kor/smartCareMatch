import '../../models/schedule_models.dart';
import 'base_api_service.dart';

class ScheduleApiService extends BaseApiService {
  /// 특정 수요자의 매칭 스케줄 조회
  static Future<List<ScheduleResponse>> getSchedulesByConsumer(String consumerId) async {
    final response = await BaseApiService.get(
      '/api/consumer/schedule/$consumerId',
      (json) {
        print('[DEBUG] Schedule API Raw Response: $json');
        return (json as List)
            .map((item) {
              print('[DEBUG] Processing schedule item: $item');
              try {
                return ScheduleResponse.fromJson(item);
              } catch (e) {
                print('[DEBUG] Error parsing schedule item: $e');
                print('[DEBUG] Failed item: $item');
                rethrow;
              }
            })
            .toList();
      },
    );
    return response;
  }
}