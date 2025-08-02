import 'service_request_models.dart';

class ScheduleResponse {
  final String consumerName;
  final String caregiverName;
  final String caregiverAddress;
  final String caregiverPhoneNumber;
  final DateTime serviceDate;
  final LocalTime startTime;
  final LocalTime endTime;
  final String serviceType;

  ScheduleResponse({
    required this.consumerName,
    required this.caregiverName,
    required this.caregiverAddress,
    required this.caregiverPhoneNumber,
    required this.serviceDate,
    required this.startTime,
    required this.endTime,
    required this.serviceType,
  });

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) {
    return ScheduleResponse(
      consumerName: json['consumerName'],
      caregiverName: json['caregiverName'],
      caregiverAddress: json['caregiverAddress'],
      caregiverPhoneNumber: json['caregiverPhoneNumber'],
      serviceDate: DateTime.parse(json['serviceDate']),
      startTime: LocalTime.fromJson(json['startTime']),
      endTime: LocalTime.fromJson(json['endTime']),
      serviceType: json['serviceType'],
    );
  }

  String get serviceTypeDisplayName {
    switch (serviceType) {
      case 'VISITING_CARE':
        return '방문요양';
      case 'VISITING_BATH':
        return '방문목욕';
      case 'VISITING_NURSING':
        return '방문간호';
      case 'DAY_NIGHT_CARE':
        return '주야간보호';
      case 'RESPITE_CARE':
        return '단기보호';
      case 'IN_HOME_SUPPORT':
        return '재가지원';
      default:
        return serviceType;
    }
  }

  String get serviceDateFormatted {
    final month = serviceDate.month;
    final day = serviceDate.day;
    final weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final weekday = weekdays[serviceDate.weekday - 1];
    return '${month}월 ${day}일 ($weekday)';
  }

  String get timeRangeFormatted {
    return '${startTime.toString()} - ${endTime.toString()}';
  }

  bool get isToday {
    final now = DateTime.now();
    return serviceDate.year == now.year &&
        serviceDate.month == now.month &&
        serviceDate.day == now.day;
  }

  bool get isUpcoming {
    return serviceDate.isAfter(DateTime.now());
  }
}