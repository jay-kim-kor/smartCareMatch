class Caregiver {
  final String caregiverId;
  final String name;
  final int age;
  final String gender;
  final int experienceYears;
  final double rating;
  final int reviewCount;
  final String profileImageUrl;
  final String introduction;
  final List<String> specialties;
  final List<String> certifications;
  final String location;
  final bool isAvailable;
  final double matchScore;

  Caregiver({
    required this.caregiverId,
    required this.name,
    required this.age,
    required this.gender,
    required this.experienceYears,
    required this.rating,
    required this.reviewCount,
    required this.profileImageUrl,
    required this.introduction,
    required this.specialties,
    required this.certifications,
    required this.location,
    required this.isAvailable,
    required this.matchScore,
  });

  factory Caregiver.fromJson(Map<String, dynamic> json) {
    return Caregiver(
      caregiverId: json['caregiverId'],
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      experienceYears: json['experienceYears'],
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'],
      profileImageUrl: json['profileImageUrl'] ?? '',
      introduction: json['introduction'],
      specialties: List<String>.from(json['specialties'] ?? []),
      certifications: List<String>.from(json['certifications'] ?? []),
      location: json['location'],
      isAvailable: json['isAvailable'] ?? true,
      matchScore: json['matchScore']?.toDouble() ?? 0.0,
    );
  }

  String get genderDisplayName {
    switch (gender) {
      case 'MALE':
        return '남성';
      case 'FEMALE':
        return '여성';
      default:
        return gender;
    }
  }

  String get ratingFormatted {
    return rating.toStringAsFixed(1);
  }

  String get matchScoreFormatted {
    return '${(matchScore * 100).toInt()}%';
  }

  static List<Caregiver> getDummyRecommendations() {
    return [
      Caregiver(
        caregiverId: 'cg_001',
        name: '김영희',
        age: 45,
        gender: 'FEMALE',
        experienceYears: 8,
        rating: 4.8,
        reviewCount: 127,
        profileImageUrl: '',
        introduction: '8년 경력의 전문 요양보호사입니다. 치매 어르신 전문 케어 경험이 풍부하며, 정성껏 모시겠습니다.',
        specialties: ['치매 케어', '거동 불편', '식사 도움'],
        certifications: ['요양보호사 1급', '응급처치 자격증'],
        location: '강남구',
        isAvailable: true,
        matchScore: 0.95,
      ),
      Caregiver(
        caregiverId: 'cg_002',
        name: '박미숙',
        age: 52,
        gender: 'FEMALE',
        experienceYears: 12,
        rating: 4.9,
        reviewCount: 203,
        profileImageUrl: '',
        introduction: '12년 경력으로 다양한 케이스를 경험했습니다. 어르신과의 소통을 중시하며 따뜻한 마음으로 돌봄을 제공합니다.',
        specialties: ['목욕 서비스', '물리치료 보조', '약물 관리'],
        certifications: ['요양보호사 1급', '간병사 자격증'],
        location: '서초구',
        isAvailable: true,
        matchScore: 0.92,
      ),
      Caregiver(
        caregiverId: 'cg_003',
        name: '이수진',
        age: 38,
        gender: 'FEMALE',
        experienceYears: 5,
        rating: 4.7,
        reviewCount: 89,
        profileImageUrl: '',
        introduction: '젊은 나이지만 전문성 있는 케어를 제공합니다. 밝은 성격으로 어르신들께 활력을 드리겠습니다.',
        specialties: ['일상생활 지원', '외출 동행', '건강 관리'],
        certifications: ['요양보호사 1급'],
        location: '강남구',
        isAvailable: true,
        matchScore: 0.88,
      ),
      Caregiver(
        caregiverId: 'cg_004',
        name: '정혜란',
        age: 49,
        gender: 'FEMALE',
        experienceYears: 10,
        rating: 4.6,
        reviewCount: 156,
        profileImageUrl: '',
        introduction: '10년간 다양한 어르신들을 모신 경험이 있습니다. 세심한 관찰력과 꼼꼼한 케어가 저의 장점입니다.',
        specialties: ['중증 환자 케어', '재활 보조', '가사 도움'],
        certifications: ['요양보호사 1급', '치매전문케어'],
        location: '송파구',
        isAvailable: true,
        matchScore: 0.85,
      ),
      Caregiver(
        caregiverId: 'cg_005',
        name: '최순자',
        age: 55,
        gender: 'FEMALE',
        experienceYears: 15,
        rating: 4.5,
        reviewCount: 298,
        profileImageUrl: '',
        introduction: '15년 베테랑 요양보호사입니다. 풍부한 경험으로 어떤 상황에서도 안정적인 케어를 제공합니다.',
        specialties: ['노인성 질환', '심리적 지원', '가족 상담'],
        certifications: ['요양보호사 1급', '사회복지사 2급'],
        location: '강동구',
        isAvailable: true,
        matchScore: 0.82,
      ),
    ];
  }
}