import 'package:flutter/material.dart';
import '../design_system/radix_design_system.dart';

class ScheduleDetailScreen extends StatelessWidget {
  const ScheduleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RadixTokens.slate1,
      appBar: RadixAppBar(
        title: '일정 상세',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 배정 완료 상태 표시
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(RadixTokens.space4),
              color: RadixTokens.grass2,
              child: Row(
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
                  Text(
                    '요양보호사 배정 완료',
                    style: RadixTokens.body1.copyWith(
                      color: RadixTokens.grass11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(RadixTokens.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 서비스 정보 카드
                  RadixCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '방문요양 서비스',
                          style: RadixTokens.heading2.copyWith(
                            color: RadixTokens.slate12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: RadixTokens.space4),
                        
                        _buildDetailRow(Icons.access_time, '방문 시간', '내일 오전 10:00 - 14:00'),
                        _buildDetailRow(Icons.location_on, '방문 위치', '서울시 강남구 테헤란로 123'),
                        _buildDetailRow(Icons.medical_services, '서비스 내용', '일상생활 지원 및 건강 관리'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: RadixTokens.space4),
                  
                  // 요양보호사 정보 카드
                  RadixCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '배정된 요양보호사',
                          style: RadixTokens.heading3.copyWith(
                            color: RadixTokens.slate12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: RadixTokens.space4),
                        
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: RadixTokens.indigo3,
                                borderRadius: BorderRadius.circular(RadixTokens.radius4),
                              ),
                              child: Icon(
                                Icons.person,
                                color: RadixTokens.indigo9,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: RadixTokens.space3),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '김영희',
                                    style: RadixTokens.heading3.copyWith(
                                      color: RadixTokens.slate12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: RadixTokens.space1),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      const SizedBox(width: RadixTokens.space1),
                                      Text(
                                        '4.8 (127)',
                                        style: RadixTokens.body2.copyWith(
                                          color: RadixTokens.slate10,
                                        ),
                                      ),
                                      const SizedBox(width: RadixTokens.space2),
                                      Text(
                                        '경력 8년',
                                        style: RadixTokens.body2.copyWith(
                                          color: RadixTokens.slate10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: RadixTokens.space4),
                        
                        _buildDetailRow(Icons.phone, '연락처', '010-1234-5678'),
                        _buildDetailRow(Icons.work, '전문분야', '치매 케어, 거동 불편, 식사 도움'),
                        _buildDetailRow(Icons.school, '자격증', '요양보호사 1급, 응급처치 자격증'),
                        
                        const SizedBox(height: RadixTokens.space4),
                        
                        Container(
                          padding: const EdgeInsets.all(RadixTokens.space3),
                          decoration: BoxDecoration(
                            color: RadixTokens.slate2,
                            borderRadius: BorderRadius.circular(RadixTokens.radius3),
                          ),
                          child: Text(
                            '8년 경력의 전문 요양보호사입니다. 치매 어르신 전문 케어 경험이 풍부하며, 정성껏 모시겠습니다.',
                            style: RadixTokens.body2.copyWith(
                              color: RadixTokens.slate11,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: RadixTokens.space4),
                  
                  // 특별 요청사항 카드
                  RadixCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '특별 요청사항',
                          style: RadixTokens.heading3.copyWith(
                            color: RadixTokens.slate12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: RadixTokens.space3),
                        Container(
                          padding: const EdgeInsets.all(RadixTokens.space3),
                          decoration: BoxDecoration(
                            color: RadixTokens.blue2,
                            borderRadius: BorderRadius.circular(RadixTokens.radius3),
                            border: Border.all(color: RadixTokens.blue6),
                          ),
                          child: Text(
                            '- 연령: 85세 여성\n- 거동 상태: 휠체어 이용\n- 건강 상태: 치매 초기\n- 특별 요청: 목욕 도움 필요\n- 주의사항: 혈압약 복용 중',
                            style: RadixTokens.body2.copyWith(
                              color: RadixTokens.blue11,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: RadixTokens.space6),
                  
                  // 액션 버튼들
                  Row(
                    children: [
                      Expanded(
                        child: RadixButton(
                          text: '요양보호사에게 연락',
                          variant: RadixButtonVariant.outline,
                          onPressed: () {
                            // TODO: 전화 걸기 또는 메시지 기능
                          },
                        ),
                      ),
                      const SizedBox(width: RadixTokens.space3),
                      Expanded(
                        child: RadixButton(
                          text: '일정 변경 요청',
                          variant: RadixButtonVariant.solid,
                          onPressed: () {
                            // TODO: 일정 수정 기능 구현: 배정 전/후 상태별 수정 프로세스 설계
                            // See: https://github.com/jaegagayo/homecare_app/issues/2
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: RadixTokens.space3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: RadixTokens.slate9,
          ),
          const SizedBox(width: RadixTokens.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: RadixTokens.caption.copyWith(
                    color: RadixTokens.slate9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: RadixTokens.space1),
                Text(
                  value,
                  style: RadixTokens.body2.copyWith(
                    color: RadixTokens.slate11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}