import 'package:flutter/material.dart';
import '../design_system/radix_design_system.dart';
import '../services/auth_service.dart';
import '../models/user_profile_models.dart';
import '../models/schedule_models.dart';
import '../services/api/schedule_api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserProfile? _userProfile;
  List<ScheduleResponse> _schedules = [];
  List<ScheduleResponse> _todaySchedules = [];
  bool _isLoading = true;
  bool _hasNewAssignment = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userId = AuthService.currentUserId;
      if (userId == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // 사용자 일정 조회
      final schedules = await ScheduleApiService.getSchedulesByConsumer(userId);
      
      // 오늘 일정 필터링
      final today = DateTime.now();
      final todaySchedules = schedules.where((schedule) => 
        schedule.serviceDate.year == today.year &&
        schedule.serviceDate.month == today.month &&
        schedule.serviceDate.day == today.day
      ).toList();

      // 새로운 배정 확인 (예정된 일정이 있는 경우)
      final hasNewAssignment = schedules.any((schedule) => schedule.isUpcoming);
      
      setState(() {
        _userProfile = UserProfile.getDummyProfile(userId); // TODO: 실제 사용자 프로필 API 연동
        _schedules = schedules;
        _todaySchedules = todaySchedules;
        _hasNewAssignment = hasNewAssignment;
        _isLoading = false;
      });
    } catch (e) {
      print('[DEBUG] Home screen error loading schedules: $e');
      print('[DEBUG] Error type: ${e.runtimeType}');
      
      // 에러 발생 시 더미 데이터로 폴백
      final userId = AuthService.currentUserId ?? 'dummy_user';
      setState(() {
        _userProfile = UserProfile.getDummyProfile(userId);
        _schedules = [];
        _todaySchedules = [];
        _hasNewAssignment = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: RadixTokens.slate1,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: RadixTokens.slate1,
      appBar: RadixAppBar(
        title: '스마트 케어 매치',
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            icon: Icon(
              Icons.person_outline,
              color: RadixTokens.slate11,
              size: 24,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(RadixTokens.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 요양보호사 배정 완료 알림 (있을 때만 표시)
            if (_hasNewAssignment) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(RadixTokens.space4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      RadixTokens.grass2,
                      RadixTokens.grass3,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(RadixTokens.radius4),
                  border: Border.all(
                    color: RadixTokens.grass6,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(RadixTokens.space1),
                          decoration: BoxDecoration(
                            color: RadixTokens.grass9,
                            borderRadius: BorderRadius.circular(RadixTokens.radius6),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: RadixTokens.space2),
                        Expanded(
                          child: Text(
                            '요양보호사 배정 완료!',
                            style: RadixTokens.heading3.copyWith(
                              color: RadixTokens.grass11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _hasNewAssignment = false;
                            });
                          },
                          child: Icon(
                            Icons.close,
                            color: RadixTokens.grass9,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: RadixTokens.space3),
                    if (_schedules.isNotEmpty) ...[
                      Text(
                        '${_schedules.first.caregiverName} 요양보호사님이 배정되었습니다',
                        style: RadixTokens.body1.copyWith(
                          color: RadixTokens.grass11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: RadixTokens.space1),
                      Text(
                        '${_schedules.first.serviceDateFormatted} ${_schedules.first.startTime}에 방문 예정입니다',
                        style: RadixTokens.body2.copyWith(
                          color: RadixTokens.grass10,
                        ),
                      ),
                    ] else ...[
                      Text(
                        '요양보호사 배정 대기 중입니다',
                        style: RadixTokens.body1.copyWith(
                          color: RadixTokens.grass11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: RadixTokens.space3),
                    SizedBox(
                      width: double.infinity,
                      child: RadixButton(
                        text: '배정된 일정 상세보기',
                        variant: RadixButtonVariant.solid,
                        size: RadixButtonSize.small,
                        onPressed: () {
                          // TODO: 일정 상세 화면 데이터 전달 방식 구현 및 라우팅 개선
                          // See: https://github.com/jaegagayo/homecare_app/issues/4
                          Navigator.pushNamed(context, '/schedule-detail');
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: RadixTokens.space4),
            ],
            
            // 인사말 섹션
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(RadixTokens.space5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    RadixTokens.indigo2,
                    RadixTokens.indigo3,
                  ],
                ),
                borderRadius: BorderRadius.circular(RadixTokens.radius4),
                border: Border.all(
                  color: RadixTokens.indigo6,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '안녕하세요, ${_userProfile?.name ?? '사용자'}님',
                    style: RadixTokens.heading2.copyWith(
                      color: RadixTokens.slate12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: RadixTokens.space2),
                  Text(
                    '오늘도 건강한 하루 보내세요!',
                    style: RadixTokens.body1.copyWith(
                      color: RadixTokens.slate11,
                    ),
                  ),
                  const SizedBox(height: RadixTokens.space4),
                                      Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: RadixTokens.indigo9,
                          size: 20,
                        ),
                        const SizedBox(width: RadixTokens.space2),
                        Text(
                          '오늘 일정 ${_todaySchedules.length}건',
                          style: RadixTokens.body2.copyWith(
                            color: RadixTokens.indigo11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: RadixTokens.space6),
                        
            // 오늘의 일정 섹션
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '오늘의 일정',
                  style: RadixTokens.heading3.copyWith(
                    color: RadixTokens.slate12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    '전체 보기',
                    style: RadixTokens.body2.copyWith(
                      color: RadixTokens.indigo11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: RadixTokens.space4),
            
            // 오늘의 일정 목록
            if (_todaySchedules.isEmpty)
              Container(
                padding: const EdgeInsets.all(RadixTokens.space4),
                child: Center(
                  child: Text(
                    '오늘 예정된 일정이 없습니다',
                    style: RadixTokens.body2.copyWith(
                      color: RadixTokens.slate10,
                    ),
                  ),
                ),
              )
            else
              ..._todaySchedules.map((schedule) => 
                Padding(
                  padding: const EdgeInsets.only(bottom: RadixTokens.space3),
                  child: RadixScheduleCard(
                    time: schedule.startTime.toString(),
                    title: schedule.serviceTypeDisplayName,
                    subtitle: schedule.caregiverName,
                    location: schedule.caregiverAddress,
                    status: ScheduleStatus.upcoming,
                    onTap: () {
                      // TODO: 일정 상세 화면으로 이동
                    },
                  ),
                ),
              ),
            
            const SizedBox(height: RadixTokens.space8),
          ],
        ),
      ),
    );
  }
}