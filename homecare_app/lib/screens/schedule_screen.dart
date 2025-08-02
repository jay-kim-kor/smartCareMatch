import 'package:flutter/material.dart';
import '../design_system/radix_design_system.dart';
import '../models/schedule_models.dart';
import '../services/api/schedule_api_service.dart';
import '../services/auth_service.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedTabIndex = 0;
  List<ScheduleResponse> _schedules = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    try {
      final userId = AuthService.currentUserId;
      if (userId == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final schedules = await ScheduleApiService.getSchedulesByConsumer(userId);
      
      setState(() {
        _schedules = schedules;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _schedules = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RadixTokens.slate1,
      appBar: RadixAppBar(
        title: '일정 관리',
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.calendar_month,
              color: RadixTokens.slate11,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 탭 섹션
          Container(
            padding: const EdgeInsets.all(RadixTokens.space4),
            child: Row(
              children: [
                _buildTab('오늘', 0),
                const SizedBox(width: RadixTokens.space3),
                _buildTab('이번 주', 1),
                const SizedBox(width: RadixTokens.space3),
                _buildTab('전체', 2),
              ],
            ),
          ),
          
          // 일정 목록
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildScheduleList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: RadixTokens.indigo9,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildScheduleList() {
    if (_schedules.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: RadixTokens.slate9,
            ),
            const SizedBox(height: RadixTokens.space4),
            Text(
              '등록된 일정이 없습니다',
              style: RadixTokens.body1.copyWith(
                color: RadixTokens.slate11,
              ),
            ),
          ],
        ),
      );
    }

    final filteredSchedules = _getFilteredSchedules();
    final groupedSchedules = _groupSchedulesByDate(filteredSchedules);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: RadixTokens.space4),
      children: [
        ...groupedSchedules.entries.map((entry) {
          final dateKey = entry.key;
          final schedules = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateHeader(dateKey),
              const SizedBox(height: RadixTokens.space3),
              ...schedules.map((schedule) => 
                Padding(
                  padding: const EdgeInsets.only(bottom: RadixTokens.space3),
                  child: RadixScheduleCard(
                    time: schedule.startTime.toString(),
                    title: schedule.serviceTypeDisplayName,
                    subtitle: schedule.caregiverName,
                    location: schedule.caregiverAddress,
                    status: schedule.isToday ? ScheduleStatus.inProgress : ScheduleStatus.upcoming,
                    onTap: () => _showScheduleDetail(context, schedule),
                  ),
                ),
              ),
              const SizedBox(height: RadixTokens.space6),
            ],
          );
        }),
      ],
    );
  }

  List<ScheduleResponse> _getFilteredSchedules() {
    final now = DateTime.now();
    switch (_selectedTabIndex) {
      case 0: // 오늘
        return _schedules.where((schedule) => schedule.isToday).toList();
      case 1: // 이번 주
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 6));
        return _schedules.where((schedule) =>
          schedule.serviceDate.isAfter(weekStart.subtract(const Duration(days: 1))) &&
          schedule.serviceDate.isBefore(weekEnd.add(const Duration(days: 1)))
        ).toList();
      case 2: // 전체
      default:
        return _schedules;
    }
  }

  Map<String, List<ScheduleResponse>> _groupSchedulesByDate(List<ScheduleResponse> schedules) {
    final Map<String, List<ScheduleResponse>> grouped = {};
    
    for (final schedule in schedules) {
      final dateKey = schedule.serviceDateFormatted;
      grouped.putIfAbsent(dateKey, () => []).add(schedule);
    }
    
    return grouped;
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: RadixTokens.space4,
          vertical: RadixTokens.space2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? RadixTokens.indigo9 : Colors.transparent,
          borderRadius: BorderRadius.circular(RadixTokens.radius6),
          border: Border.all(
            color: isSelected ? RadixTokens.indigo9 : RadixTokens.slate6,
            width: 1,
          ),
        ),
        child: Text(
          title,
          style: RadixTokens.body2.copyWith(
            color: isSelected ? Colors.white : RadixTokens.slate11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDateHeader(String date) {
    return Text(
      date,
      style: RadixTokens.heading3.copyWith(
        color: RadixTokens.slate12,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  void _showScheduleDetail(BuildContext context, ScheduleResponse schedule) {
    showModalBottomSheet(
      context: context,
      backgroundColor: RadixTokens.slate1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadixTokens.radius4),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(RadixTokens.space6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 핸들 바
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: RadixTokens.slate6,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: RadixTokens.space4),
            
            Text(
              schedule.serviceTypeDisplayName,
              style: RadixTokens.heading2.copyWith(
                color: RadixTokens.slate12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: RadixTokens.space3),
            
            _buildDetailRow(Icons.person, schedule.caregiverName),
            _buildDetailRow(Icons.access_time, schedule.timeRangeFormatted),
            _buildDetailRow(Icons.location_on, schedule.caregiverAddress),
            _buildDetailRow(Icons.phone, schedule.caregiverPhoneNumber),
            
            const SizedBox(height: RadixTokens.space6),
            
            Row(
              children: [
                Expanded(
                  child: RadixButton(
                    text: '연락하기',
                    variant: RadixButtonVariant.outline,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: RadixTokens.space3),
                Expanded(
                  child: RadixButton(
                    text: '위치 확인',
                    variant: RadixButtonVariant.solid,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: RadixTokens.space3),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: RadixTokens.slate9,
          ),
          const SizedBox(width: RadixTokens.space3),
          Text(
            text,
            style: RadixTokens.body2.copyWith(
              color: RadixTokens.slate11,
            ),
          ),
        ],
      ),
    );
  }
}