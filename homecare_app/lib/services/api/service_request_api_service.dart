import '../../models/service_request_models.dart';
import 'base_api_service.dart';

class ServiceRequestApiService extends BaseApiService {
  /// 서비스 요청 생성
  static Future<CreateServiceRequestResponse> createServiceRequest(ServiceRequestRequest request) async {
    final response = await BaseApiService.post(
      '/api/consumer/request',
      request.toJson(),
      (json) => CreateServiceRequestResponse.fromJson(json),
    );
    return response;
  }

  /// 사용자의 서비스 요청 목록 조회
  static Future<List<ServiceRequestListResponse>> getServiceRequests(String userId) async {
    final response = await BaseApiService.get(
      '/api/consumer/request',
      (json) => (json as List)
          .map((item) => ServiceRequestListResponse.fromJson(item))
          .toList(),
      queryParameters: {'userId': userId},
    );
    return response;
  }

  /// 특정 서비스 요청 상세 조회
  static Future<ServiceRequestDetailResponse> getServiceRequestById(String serviceRequestId) async {
    final response = await BaseApiService.get(
      '/api/consumer/request/$serviceRequestId',
      (json) => ServiceRequestDetailResponse.fromJson(json),
    );
    return response;
  }

  /// 상태별 서비스 요청 조회
  static Future<List<ServiceRequestListResponse>> getServiceRequestsByStatus(
    String userId,
    ServiceRequestStatus status,
  ) async {
    final response = await BaseApiService.get(
      '/api/consumer/request/status',
      (json) => (json as List)
          .map((item) => ServiceRequestListResponse.fromJson(item))
          .toList(),
      queryParameters: {
        'userId': userId,
        'status': status.value,
      },
    );
    return response;
  }

  /// 요양보호사 선택 확정
  static Future<void> confirmCaregiver(ConfirmCaregiverRequest request) async {
    await BaseApiService.post(
      '/api/consumer/confirm',
      request.toJson(),
      (json) => null,
    );
  }
}