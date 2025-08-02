class UserProfile {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final DateTime birthDate;
  final String? address;
  final int age;

  UserProfile({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.birthDate,
    this.address,
  }) : age = DateTime.now().year - birthDate.year;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      birthDate: DateTime.parse(json['birthDate']),
      address: json['address'],
    );
  }

  // 임시 더미 데이터 (API 구현 전까지 사용)
  static UserProfile getDummyProfile(String userId) {
    return UserProfile(
      userId: userId,
      name: '김철수',
      email: 'kim.cs@example.com',
      phone: '010-1234-5678',
      birthDate: DateTime(1948, 5, 15),
      address: '서울시 강남구',
    );
  }
}

class ServiceRequest {
  final String serviceRequestId;
  final String serviceType;
  final DateTime requestDate;
  final String status; // PENDING, ASSIGNED, COMPLETED
  final String address;
  final DateTime serviceDate;
  final String? assignedCaregiverName;
  final double? totalAmount;

  ServiceRequest({
    required this.serviceRequestId,
    required this.serviceType,
    required this.requestDate,
    required this.status,
    required this.address,
    required this.serviceDate,
    this.assignedCaregiverName,
    this.totalAmount,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      serviceRequestId: json['serviceRequestId'],
      serviceType: json['serviceType'],
      requestDate: DateTime.parse(json['requestDate']),
      status: json['status'],
      address: json['address'],
      serviceDate: DateTime.parse(json['serviceDate']),
      assignedCaregiverName: json['assignedCaregiverName'],
      totalAmount: json['totalAmount']?.toDouble(),
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
      default:
        return serviceType;
    }
  }

  String get statusDisplayName {
    switch (status) {
      case 'PENDING':
        return '매칭 대기';
      case 'ASSIGNED':
        return '요양보호사 배정됨';
      case 'COMPLETED':
        return '서비스 완료';
      default:
        return status;
    }
  }

  String get serviceDateFormatted {
    final month = serviceDate.month;
    final day = serviceDate.day;
    return '${month}월 ${day}일';
  }

  // 임시 더미 데이터
  static List<ServiceRequest> getDummyRequests(String userId) {
    final now = DateTime.now();
    return [
      ServiceRequest(
        serviceRequestId: 'req_001',
        serviceType: 'VISITING_CARE',
        requestDate: now.subtract(const Duration(days: 1)),
        status: 'ASSIGNED',
        address: '서울시 강남구',
        serviceDate: now.add(const Duration(days: 2)),
        assignedCaregiverName: '김영희',
        totalAmount: 45000,
      ),
      ServiceRequest(
        serviceRequestId: 'req_002',
        serviceType: 'VISITING_BATH',
        requestDate: now.subtract(const Duration(days: 7)),
        status: 'COMPLETED',
        address: '서울시 강남구',
        serviceDate: now.subtract(const Duration(days: 3)),
        assignedCaregiverName: '박미숙',
        totalAmount: 35000,
      ),
      ServiceRequest(
        serviceRequestId: 'req_003',
        serviceType: 'VISITING_CARE',
        requestDate: now.subtract(const Duration(hours: 2)),
        status: 'PENDING',
        address: '서울시 강남구',
        serviceDate: now.add(const Duration(days: 5)),
      ),
    ];
  }
}

class WorkSchedule {
  final String workMatchId;
  final DateTime workDate;
  final String caregiverName;
  final String serviceType;
  final String status; // PLANNED, COMPLETED, CANCELLED
  final DateTime? startTime;
  final DateTime? endTime;

  WorkSchedule({
    required this.workMatchId,
    required this.workDate,
    required this.caregiverName,
    required this.serviceType,
    required this.status,
    this.startTime,
    this.endTime,
  });

  factory WorkSchedule.fromJson(Map<String, dynamic> json) {
    return WorkSchedule(
      workMatchId: json['workMatchId'],
      workDate: DateTime.parse(json['workDate']),
      caregiverName: json['caregiverName'],
      serviceType: json['serviceType'],
      status: json['status'],
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
    );
  }

  String get statusDisplayName {
    switch (status) {
      case 'PLANNED':
        return '예정됨';
      case 'COMPLETED':
        return '완료됨';
      case 'CANCELLED':
        return '취소됨';
      default:
        return status;
    }
  }

  String get workDateFormatted {
    final month = workDate.month;
    final day = workDate.day;
    return '${month}월 ${day}일';
  }

  String get timeRangeFormatted {
    if (startTime == null || endTime == null) return '시간 미정';
    
    final startHour = startTime!.hour;
    final startMinute = startTime!.minute.toString().padLeft(2, '0');
    final endHour = endTime!.hour;
    final endMinute = endTime!.minute.toString().padLeft(2, '0');
    
    return '$startHour:$startMinute - $endHour:$endMinute';
  }

  // 임시 더미 데이터
  static List<WorkSchedule> getDummySchedules(String userId) {
    final now = DateTime.now();
    return [
      WorkSchedule(
        workMatchId: 'match_001',
        workDate: now.add(const Duration(days: 2)),
        caregiverName: '김영희',
        serviceType: 'VISITING_CARE',
        status: 'PLANNED',
        startTime: now.add(const Duration(days: 2)).copyWith(hour: 10, minute: 0),
        endTime: now.add(const Duration(days: 2)).copyWith(hour: 14, minute: 0),
      ),
      WorkSchedule(
        workMatchId: 'match_002',
        workDate: now.subtract(const Duration(days: 3)),
        caregiverName: '박미숙',
        serviceType: 'VISITING_BATH',
        status: 'COMPLETED',
        startTime: now.subtract(const Duration(days: 3)).copyWith(hour: 9, minute: 0),
        endTime: now.subtract(const Duration(days: 3)).copyWith(hour: 11, minute: 0),
      ),
      WorkSchedule(
        workMatchId: 'match_003',
        workDate: now.add(const Duration(days: 5)),
        caregiverName: '이수진',
        serviceType: 'VISITING_CARE',
        status: 'PLANNED',
        startTime: now.add(const Duration(days: 5)).copyWith(hour: 15, minute: 0),
        endTime: now.add(const Duration(days: 5)).copyWith(hour: 18, minute: 0),
      ),
    ];
  }
}

class ServiceUsageStats {
  final int totalCompletedServices;
  final double totalSpentAmount;
  final WorkSchedule? upcomingSchedule;
  final ServiceRequest? latestRequest;

  ServiceUsageStats({
    required this.totalCompletedServices,
    required this.totalSpentAmount,
    this.upcomingSchedule,
    this.latestRequest,
  });

  factory ServiceUsageStats.fromJson(Map<String, dynamic> json) {
    return ServiceUsageStats(
      totalCompletedServices: json['totalCompletedServices'],
      totalSpentAmount: json['totalSpentAmount']?.toDouble() ?? 0.0,
      upcomingSchedule: json['upcomingSchedule'] != null 
          ? WorkSchedule.fromJson(json['upcomingSchedule'])
          : null,
      latestRequest: json['latestRequest'] != null
          ? ServiceRequest.fromJson(json['latestRequest'])
          : null,
    );
  }

  String get totalSpentFormatted {
    return '${totalSpentAmount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}원';
  }

  // 임시 더미 데이터
  static ServiceUsageStats getDummyStats(List<ServiceRequest> requests, List<WorkSchedule> schedules) {
    final completedServices = requests.where((r) => r.status == 'COMPLETED').toList();
    final upcomingSchedules = schedules.where((s) => 
      s.status == 'PLANNED' && s.workDate.isAfter(DateTime.now())
    ).toList();
    
    upcomingSchedules.sort((a, b) => a.workDate.compareTo(b.workDate));
    
    final totalAmount = completedServices
        .where((r) => r.totalAmount != null)
        .fold<double>(0, (sum, r) => sum + r.totalAmount!);

    return ServiceUsageStats(
      totalCompletedServices: completedServices.length,
      totalSpentAmount: totalAmount,
      upcomingSchedule: upcomingSchedules.isNotEmpty ? upcomingSchedules.first : null,
      latestRequest: requests.isNotEmpty ? requests.first : null,
    );
  }
}