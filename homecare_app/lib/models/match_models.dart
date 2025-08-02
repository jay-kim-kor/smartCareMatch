class MatchResponse {
  final List<MatchingResponseDto> matchedCaregivers;
  final int totalMatches;

  MatchResponse({
    required this.matchedCaregivers,
    required this.totalMatches,
  });

  factory MatchResponse.fromJson(Map<String, dynamic> json) {
    return MatchResponse(
      matchedCaregivers: (json['matchedCaregivers'] as List)
          .map((item) => MatchingResponseDto.fromJson(item))
          .toList(),
      totalMatches: json['totalMatches'],
    );
  }
}

class MatchingResponseDto {
  final String caregiverId;
  final String caregiverName;
  final String availableStartTime;
  final String availableEndTime;
  final String address;
  final List<double> location;
  final double matchScore;
  final String matchReason;

  MatchingResponseDto({
    required this.caregiverId,
    required this.caregiverName,
    required this.availableStartTime,
    required this.availableEndTime,
    required this.address,
    required this.location,
    required this.matchScore,
    required this.matchReason,
  });

  factory MatchingResponseDto.fromJson(Map<String, dynamic> json) {
    return MatchingResponseDto(
      caregiverId: json['caregiverId'],
      caregiverName: json['caregiverName'],
      availableStartTime: json['availableStartTime'],
      availableEndTime: json['availableEndTime'],
      address: json['address'],
      location: (json['location'] as List).cast<double>(),
      matchScore: json['matchScore'].toDouble(),
      matchReason: json['matchReason'],
    );
  }
}