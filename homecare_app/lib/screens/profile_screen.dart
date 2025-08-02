import 'package:flutter/material.dart';
import '../design_system/radix_design_system.dart';
import '../services/auth_service.dart';
import '../models/user_profile_models.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? _userProfile;
  ServiceUsageStats? _usageStats;
  List<ServiceRequest> _serviceRequests = [];
  List<WorkSchedule> _workSchedules = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // TODO: API 호출로 실제 데이터 로드
    // 현재는 더미 데이터 사용
    await Future.delayed(const Duration(milliseconds: 500)); // 로딩 시뮬레이션
    
    final userId = AuthService.currentUserId ?? 'dummy_user';
    
    setState(() {
      _userProfile = UserProfile.getDummyProfile(userId);
      _serviceRequests = ServiceRequest.getDummyRequests(userId);
      _workSchedules = WorkSchedule.getDummySchedules(userId);
      _usageStats = ServiceUsageStats.getDummyStats(_serviceRequests, _workSchedules);
      _isLoading = false;
    });
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
        title: '마이페이지',
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings,
              color: RadixTokens.slate11,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(RadixTokens.space4),
        child: Column(
          children: [
            // 프로필 헤더
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(RadixTokens.space5),
              decoration: BoxDecoration(
                color: RadixTokens.slate1,
                borderRadius: BorderRadius.circular(RadixTokens.radius4),
                border: Border.all(
                  color: RadixTokens.slate6,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: RadixTokens.indigo3,
                      borderRadius: BorderRadius.circular(RadixTokens.radius6),
                    ),
                    child: Icon(
                      Icons.person,
                      color: RadixTokens.indigo9,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: RadixTokens.space3),
                  Text(
                    _userProfile?.name ?? '사용자',
                    style: RadixTokens.heading2.copyWith(
                      color: RadixTokens.slate12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: RadixTokens.space1),
                  Text(
                    '만 ${_userProfile?.age ?? 0}세 • ${_userProfile?.address ?? '주소 없음'}',
                    style: RadixTokens.body2.copyWith(
                      color: RadixTokens.slate10,
                    ),
                  ),
                  const SizedBox(height: RadixTokens.space4),
                  RadixButton(
                    text: '프로필 수정',
                    variant: RadixButtonVariant.outline,
                    size: RadixButtonSize.small,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: RadixTokens.space6),
            
            // 서비스 이용 현황
            _buildSectionCard(
              title: '서비스 이용 현황',
              children: [
                _buildStatusRow('총 완료된 서비스', '${_usageStats?.totalCompletedServices ?? 0}회'),
                _buildStatusRow('다음 예약', _usageStats?.upcomingSchedule != null 
                    ? '${_usageStats!.upcomingSchedule!.workDateFormatted} ${_usageStats!.upcomingSchedule!.timeRangeFormatted}'
                    : '예약된 일정 없음'),
                _buildStatusRow('총 이용 금액', _usageStats?.totalSpentFormatted ?? '0원'),
              ],
            ),
            
            const SizedBox(height: RadixTokens.space4),
            
            // 최근 서비스 내역
            if (_workSchedules.isNotEmpty) _buildSectionCard(
              title: '최근 서비스 내역',
              children: _workSchedules.take(3).map((schedule) => 
                Padding(
                  padding: const EdgeInsets.only(bottom: RadixTokens.space3),
                  child: RadixCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                schedule.caregiverName,
                                style: RadixTokens.body1.copyWith(
                                  color: RadixTokens.slate12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: RadixTokens.space1),
                              Text(
                                '${schedule.workDateFormatted} • ${schedule.timeRangeFormatted}',
                                style: RadixTokens.body2.copyWith(
                                  color: RadixTokens.slate10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: RadixTokens.space2,
                                vertical: RadixTokens.space1,
                              ),
                              decoration: BoxDecoration(
                                color: schedule.status == 'COMPLETED' 
                                    ? RadixTokens.grass3
                                    : schedule.status == 'PLANNED'
                                        ? RadixTokens.blue3
                                        : RadixTokens.slate3,
                                borderRadius: BorderRadius.circular(RadixTokens.radius2),
                              ),
                              child: Text(
                                schedule.statusDisplayName,
                                style: RadixTokens.caption.copyWith(
                                  color: schedule.status == 'COMPLETED'
                                      ? RadixTokens.grass11
                                      : schedule.status == 'PLANNED'
                                          ? RadixTokens.blue11
                                          : RadixTokens.slate11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (schedule.status == 'COMPLETED')
                              Row(
                                children: [
                                  const SizedBox(width: RadixTokens.space2),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context, 
                                        '/review',
                                        arguments: schedule,
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: RadixTokens.space2,
                                        vertical: RadixTokens.space1,
                                      ),
                                      decoration: BoxDecoration(
                                        color: RadixTokens.indigo3,
                                        borderRadius: BorderRadius.circular(RadixTokens.radius2),
                                      ),
                                      child: Text(
                                        '후기 작성',
                                        style: RadixTokens.caption.copyWith(
                                          color: RadixTokens.indigo11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ).toList(),
            ),
            
            const SizedBox(height: RadixTokens.space4),
            
            // 메뉴 목록
            _buildSectionCard(
              title: '메뉴',
              children: [
                _buildMenuTile(
                  icon: Icons.history,
                  title: '서비스 이용 내역',
                  onTap: () {},
                ),
                _buildMenuTile(
                  icon: Icons.payment,
                  title: '결제 관리',
                  onTap: () {},
                ),
                _buildMenuTile(
                  icon: Icons.medical_information,
                  title: '건강 기록',
                  onTap: () {},
                ),
                _buildMenuTile(
                  icon: Icons.family_restroom,
                  title: '가족 관리',
                  onTap: () {},
                ),
                _buildMenuTile(
                  icon: Icons.help_outline,
                  title: '고객센터',
                  onTap: () {},
                ),
                _buildMenuTile(
                  icon: Icons.info_outline,
                  title: '앱 정보',
                  onTap: () {},
                ),
              ],
            ),
            
            const SizedBox(height: RadixTokens.space6),
            
            // 로그아웃 버튼
            RadixButton(
              text: '로그아웃',
              variant: RadixButtonVariant.outline,
              fullWidth: true,
              onPressed: () => _showLogoutDialog(context),
            ),
            
            const SizedBox(height: RadixTokens.space8),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return RadixCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: RadixTokens.body1.copyWith(
              color: RadixTokens.slate12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: RadixTokens.space4),
          ...children,
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: RadixTokens.space3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: RadixTokens.body2.copyWith(
              color: RadixTokens.slate10,
            ),
          ),
          Text(
            value,
            style: RadixTokens.body2.copyWith(
              color: RadixTokens.slate12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RadixTokens.radius3),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: RadixTokens.space3,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: RadixTokens.slate9,
                size: 20,
              ),
              const SizedBox(width: RadixTokens.space3),
              Expanded(
                child: Text(
                  title,
                  style: RadixTokens.body2.copyWith(
                    color: RadixTokens.slate11,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: RadixTokens.slate7,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '로그아웃',
            style: RadixTokens.heading3.copyWith(
              color: RadixTokens.slate12,
            ),
          ),
          content: Text(
            '정말 로그아웃하시겠습니까?',
            style: RadixTokens.body1.copyWith(
              color: RadixTokens.slate11,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '취소',
                style: RadixTokens.body2.copyWith(
                  color: RadixTokens.slate11,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await AuthService.logout();
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                  );
                }
              },
              child: Text(
                '로그아웃',
                style: RadixTokens.body2.copyWith(
                  color: Colors.red.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}