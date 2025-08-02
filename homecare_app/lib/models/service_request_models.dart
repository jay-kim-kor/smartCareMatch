class ServiceRequestRequest {
  final String userId;
  final String address;
  final LocationDto location;
  final LocalTime preferredTimeStart;
  final LocalTime preferredTimeEnd;
  final ServiceType serviceType;
  final String personalityType;
  final List<String> requestedDays; // ISO date strings (YYYY-MM-DD)
  final String additionalInformation;
  
  ServiceRequestRequest({
    required this.userId,
    required this.address,
    required this.location,
    required this.preferredTimeStart,
    required this.preferredTimeEnd,
    required this.serviceType,
    required this.personalityType,
    required this.requestedDays,
    required this.additionalInformation,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'address': address,
      'location': location.toJson(),
      'preferred_time_start': preferredTimeStart.toTimeString(),
      'preferred_time_end': preferredTimeEnd.toTimeString(),
      'serviceType': serviceType.value,
      'personalityType': personalityType,
      'requestedDays': requestedDays, // ISO date strings array
      'additionalInformation': additionalInformation,
    };
  }
}

class LocationDto {
  final double latitude;
  final double longitude;

  LocationDto({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory LocationDto.fromJson(Map<String, dynamic> json) {
    return LocationDto(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

class LocalTime {
  final int hour;
  final int minute;
  final int second;

  LocalTime({
    required this.hour,
    required this.minute,
    this.second = 0,
  });

  String toTimeString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';
  }

  factory LocalTime.fromJson(dynamic json) {
    if (json is String) {
      // "HH:mm:ss" 형태의 문자열을 파싱
      final parts = json.split(':');
      return LocalTime(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
        second: parts.length > 2 ? int.parse(parts[2]) : 0,
      );
    } else if (json is Map<String, dynamic>) {
      // 기존 객체 형태도 지원
      return LocalTime(
        hour: json['hour'],
        minute: json['minute'],
        second: json['second'] ?? 0,
      );
    } else {
      throw ArgumentError('Invalid LocalTime format: $json');
    }
  }

  @override
  String toString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}

enum ServiceType {
  visitingCare('VISITING_CARE'),
  visitingBath('VISITING_BATH'),
  visitingNursing('VISITING_NURSING'),
  dayNightCare('DAY_NIGHT_CARE'),
  respiteCare('RESPITE_CARE'),
  inHomeSupport('IN_HOME_SUPPORT');

  const ServiceType(this.value);
  final String value;
}

enum ServiceRequestStatus {
  pending('PENDING'),
  assigned('ASSIGNED'),
  completed('COMPLETED');

  const ServiceRequestStatus(this.value);
  final String value;
}

class ServiceRequestResponse {
  final String serviceRequestId;

  ServiceRequestResponse({
    required this.serviceRequestId,
  });

  factory ServiceRequestResponse.fromJson(Map<String, dynamic> json) {
    return ServiceRequestResponse(
      serviceRequestId: json['serviceRequestId'] ?? 'unknown',
    );
  }
}

// 백엔드 GetCreateServiceResponse와 일치하는 모델
class CreateServiceRequestResponse {
  final String serviceRequestId;

  CreateServiceRequestResponse({required this.serviceRequestId});

  factory CreateServiceRequestResponse.fromJson(Map<String, dynamic> json) {
    return CreateServiceRequestResponse(
      serviceRequestId: json['serviceRequestId'],
    );
  }
}

class ServiceRequestListResponse {
  final String serviceRequestId;
  final String address;
  final LocalTime preferredTimeStart;
  final LocalTime preferredTimeEnd;
  final String serviceType;
  final ServiceRequestStatus status;
  final String personalityType;
  final List<String> requestedDays;

  ServiceRequestListResponse({
    required this.serviceRequestId,
    required this.address,
    required this.preferredTimeStart,
    required this.preferredTimeEnd,
    required this.serviceType,
    required this.status,
    required this.personalityType,
    required this.requestedDays,
  });

  factory ServiceRequestListResponse.fromJson(Map<String, dynamic> json) {
    return ServiceRequestListResponse(
      serviceRequestId: json['serviceRequestId'],
      address: json['address'],
      preferredTimeStart: LocalTime.fromJson(json['preferred_time_start']),
      preferredTimeEnd: LocalTime.fromJson(json['preferred_time_end']),
      serviceType: json['serviceType'],
      status: ServiceRequestStatus.values.firstWhere(
        (e) => e.value == json['status'],
      ),
      personalityType: json['personalityType'],
      requestedDays: List<String>.from(json['requestedDays']),
    );
  }
}

class ServiceRequestDetailResponse {
  final String serviceRequestId;
  final String address;
  final LocalTime preferredTimeStart;
  final LocalTime preferredTimeEnd;
  final String serviceType;
  final ServiceRequestStatus status;
  final String personalityType;
  final List<String> requestedDays;
  final LocationDto location;

  ServiceRequestDetailResponse({
    required this.serviceRequestId,
    required this.address,
    required this.preferredTimeStart,
    required this.preferredTimeEnd,
    required this.serviceType,
    required this.status,
    required this.personalityType,
    required this.requestedDays,
    required this.location,
  });

  factory ServiceRequestDetailResponse.fromJson(Map<String, dynamic> json) {
    return ServiceRequestDetailResponse(
      serviceRequestId: json['serviceRequestId'],
      address: json['address'],
      preferredTimeStart: LocalTime.fromJson(json['preferred_time_start']),
      preferredTimeEnd: LocalTime.fromJson(json['preferred_time_end']),
      serviceType: json['serviceType'],
      status: ServiceRequestStatus.values.firstWhere(
        (e) => e.value == json['status'],
      ),
      personalityType: json['personalityType'],
      requestedDays: List<String>.from(json['requestedDays']),
      location: LocationDto.fromJson(json['location']),
    );
  }
}

class ConfirmCaregiverRequest {
  final String serviceRequestId;
  final String caregiverId;

  ConfirmCaregiverRequest({
    required this.serviceRequestId,
    required this.caregiverId,
  });

  Map<String, dynamic> toJson() {
    return {'serviceRequestId': serviceRequestId, 'caregiverId': caregiverId};
  }
}
