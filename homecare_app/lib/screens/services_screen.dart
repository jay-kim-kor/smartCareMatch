import 'package:flutter/material.dart';
import '../design_system/radix_design_system.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RadixTokens.slate1,
      appBar: RadixAppBar(
        title: '서비스',
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: RadixTokens.slate11,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(RadixTokens.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 카테고리 섹션
            Text(
              '서비스 카테고리',
              style: RadixTokens.heading3.copyWith(
                color: RadixTokens.slate12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: RadixTokens.space4),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: RadixTokens.space3,
              mainAxisSpacing: RadixTokens.space3,
              childAspectRatio: 1.1,
              children: [
                RadixServiceCard(
                  title: '방문 간병',
                  subtitle: '전문 간병사 파견',
                  icon: Icons.medical_services_outlined,
                  iconColor: Colors.blue.shade600,
                  onTap: () => _navigateToServiceDetail(context, '방문 간병'),
                ),
                RadixServiceCard(
                  title: '가사 도우미',
                  subtitle: '청소, 요리, 세탁',
                  icon: Icons.home_outlined,
                  iconColor: Colors.purple.shade600,
                  onTap: () => _navigateToServiceDetail(context, '가사 도우미'),
                ),
                RadixServiceCard(
                  title: '물리 치료',
                  subtitle: '재활 및 물리치료',
                  icon: Icons.fitness_center_outlined,
                  iconColor: Colors.orange.shade600,
                  onTap: () => _navigateToServiceDetail(context, '물리 치료'),
                ),
                RadixServiceCard(
                  title: '건강 상담',
                  subtitle: '전문의 원격 상담',
                  icon: Icons.phone_outlined,
                  iconColor: RadixTokens.indigo9,
                  onTap: () => _navigateToServiceDetail(context, '건강 상담'),
                ),
                RadixServiceCard(
                  title: '응급 서비스',
                  subtitle: '24시간 응급 대응',
                  icon: Icons.local_hospital_outlined,
                  iconColor: Colors.red.shade600,
                  onTap: () => _navigateToServiceDetail(context, '응급 서비스'),
                ),
                RadixServiceCard(
                  title: '약물 관리',
                  subtitle: '복약 지도 및 관리',
                  icon: Icons.medication_outlined,
                  iconColor: Colors.teal.shade600,
                  onTap: () => _navigateToServiceDetail(context, '약물 관리'),
                ),
              ],
            ),
            
            const SizedBox(height: RadixTokens.space6),
            
            // 인기 서비스 섹션
            Text(
              '인기 서비스',
              style: RadixTokens.heading3.copyWith(
                color: RadixTokens.slate12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: RadixTokens.space4),
            
            _buildPopularServiceCard(
              title: '주간 방문 간병 패키지',
              subtitle: '월-금 오전 9시-오후 6시',
              price: '월 280만원',
              rating: 4.8,
              reviewCount: 124,
            ),
            const SizedBox(height: RadixTokens.space3),
            
            _buildPopularServiceCard(
              title: '가사도우미 + 간병 통합서비스',
              subtitle: '청소, 요리, 기본 간병 포함',
              price: '월 320만원',
              rating: 4.9,
              reviewCount: 89,
            ),
            const SizedBox(height: RadixTokens.space3),
            
            _buildPopularServiceCard(
              title: '물리치료 집중 케어',
              subtitle: '주 3회 전문 물리치료사 방문',
              price: '월 180만원',
              rating: 4.7,
              reviewCount: 156,
            ),
            
            const SizedBox(height: RadixTokens.space8),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularServiceCard({
    required String title,
    required String subtitle,
    required String price,
    required double rating,
    required int reviewCount,
  }) {
    return RadixCard(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
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
                    const SizedBox(height: RadixTokens.space1),
                    Text(
                      subtitle,
                      style: RadixTokens.body2.copyWith(
                        color: RadixTokens.slate10,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: RadixTokens.space3,
                  vertical: RadixTokens.space1,
                ),
                decoration: BoxDecoration(
                  color: RadixTokens.indigo3,
                  borderRadius: BorderRadius.circular(RadixTokens.radius2),
                ),
                child: Text(
                  price,
                  style: RadixTokens.body2.copyWith(
                    color: RadixTokens.indigo11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: RadixTokens.space3),
          Row(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.amber.shade500,
                  ),
                  const SizedBox(width: RadixTokens.space1),
                  Text(
                    rating.toString(),
                    style: RadixTokens.caption.copyWith(
                      color: RadixTokens.slate11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: RadixTokens.space3),
              Text(
                '리뷰 $reviewCount개',
                style: RadixTokens.caption.copyWith(
                  color: RadixTokens.slate9,
                ),
              ),
              const Spacer(),
              RadixButton(
                text: '상담 신청',
                size: RadixButtonSize.small,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToServiceDetail(BuildContext context, String serviceName) {
    // 서비스 상세 페이지로 이동
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$serviceName 서비스 상세 페이지로 이동'),
        backgroundColor: RadixTokens.indigo9,
      ),
    );
  }
}