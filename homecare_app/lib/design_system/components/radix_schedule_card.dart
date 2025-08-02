import 'package:flutter/material.dart';
import '../tokens.dart';

class RadixScheduleCard extends StatelessWidget {
  final String time;
  final String title;
  final String? subtitle;
  final String? location;
  final ScheduleStatus status;
  final VoidCallback? onTap;

  const RadixScheduleCard({
    super.key,
    required this.time,
    required this.title,
    this.subtitle,
    this.location,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RadixTokens.radius4),
        child: Container(
          padding: const EdgeInsets.all(RadixTokens.space4),
          decoration: BoxDecoration(
            color: RadixTokens.slate1,
            border: Border.all(
              color: RadixTokens.slate6,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(RadixTokens.radius4),
          ),
          child: Row(
            children: [
              // 시간 표시
              Container(
                width: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      time,
                      style: RadixTokens.body2.copyWith(
                        color: RadixTokens.slate11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: RadixTokens.space3),
              
              // 상태 인디케이터
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: _getStatusColor(),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: RadixTokens.space3),
              
              // 내용
              Expanded(
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
                    if (subtitle != null) ...[
                      const SizedBox(height: RadixTokens.space1),
                      Text(
                        subtitle!,
                        style: RadixTokens.body2.copyWith(
                          color: RadixTokens.slate10,
                        ),
                      ),
                    ],
                    if (location != null) ...[
                      const SizedBox(height: RadixTokens.space1),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: RadixTokens.slate9,
                          ),
                          const SizedBox(width: RadixTokens.space1),
                          Text(
                            location!,
                            style: RadixTokens.caption.copyWith(
                              color: RadixTokens.slate9,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              
              // 상태 배지
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: RadixTokens.space2,
                  vertical: RadixTokens.space1,
                ),
                decoration: BoxDecoration(
                  color: _getStatusBackgroundColor(),
                  borderRadius: BorderRadius.circular(RadixTokens.radius2),
                ),
                child: Text(
                  _getStatusText(),
                  style: RadixTokens.caption.copyWith(
                    color: _getStatusTextColor(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case ScheduleStatus.pending:
        return Colors.orange.shade400;
      case ScheduleStatus.upcoming:
        return RadixTokens.grass9;
      case ScheduleStatus.inProgress:
        return RadixTokens.blue9;
      case ScheduleStatus.completed:
        return RadixTokens.slate9;
      case ScheduleStatus.cancelled:
        return Colors.red.shade400;
    }
  }

  Color _getStatusBackgroundColor() {
    switch (status) {
      case ScheduleStatus.pending:
        return Colors.orange.shade50;
      case ScheduleStatus.upcoming:
        return RadixTokens.grass3;
      case ScheduleStatus.inProgress:
        return RadixTokens.blue3;
      case ScheduleStatus.completed:
        return RadixTokens.slate3;
      case ScheduleStatus.cancelled:
        return Colors.red.shade50;
    }
  }

  Color _getStatusTextColor() {
    switch (status) {
      case ScheduleStatus.pending:
        return Colors.orange.shade700;
      case ScheduleStatus.upcoming:
        return RadixTokens.grass11;
      case ScheduleStatus.inProgress:
        return RadixTokens.blue11;
      case ScheduleStatus.completed:
        return RadixTokens.slate11;
      case ScheduleStatus.cancelled:
        return Colors.red.shade700;
    }
  }

  String _getStatusText() {
    switch (status) {
      case ScheduleStatus.pending:
        return '매칭중';
      case ScheduleStatus.upcoming:
        return '예정';
      case ScheduleStatus.inProgress:
        return '진행중';
      case ScheduleStatus.completed:
        return '완료';
      case ScheduleStatus.cancelled:
        return '취소';
    }
  }
}

enum ScheduleStatus {
  pending,      // TODO: 배정 전 일정 상태 관리 및 매칭 진행 상황 API 구현
                // See: https://github.com/jaegagayo/homecare_app/issues/3
  upcoming,
  inProgress,
  completed,
  cancelled,
}