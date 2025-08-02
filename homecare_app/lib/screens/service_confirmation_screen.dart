import 'package:flutter/material.dart';
import '../design_system/radix_design_system.dart';

class ServiceConfirmationScreen extends StatelessWidget {
  const ServiceConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RadixTokens.slate1,
      appBar: AppBar(
        backgroundColor: RadixTokens.slate1,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          '신청 완료',
          style: RadixTokens.heading3.copyWith(
            color: RadixTokens.slate12,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(RadixTokens.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: RadixTokens.grass3,
                borderRadius: BorderRadius.circular(RadixTokens.radius6),
              ),
              child: Icon(
                Icons.check_circle_outline,
                color: RadixTokens.grass9,
                size: 60,
              ),
            ),
            
            const SizedBox(height: RadixTokens.space6),
            
            Text(
              '서비스 신청이 완료되었습니다',
              style: RadixTokens.heading2.copyWith(
                color: RadixTokens.slate12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: RadixTokens.space4),
            
            RadixCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: RadixTokens.indigo9,
                        size: 20,
                      ),
                      const SizedBox(width: RadixTokens.space2),
                      Text(
                        '다음 단계',
                        style: RadixTokens.body1.copyWith(
                          color: RadixTokens.slate12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: RadixTokens.space3),
                  
                  _buildStepItem(
                    '1. 매칭 진행',
                    '요구사항에 맞는 요양보호사를 찾고 있습니다',
                    isActive: true,
                  ),
                  
                  _buildStepItem(
                    '2. 요양보호사 배정',
                    '적합한 요양보호사를 배정하고 연락드립니다',
                    isActive: false,
                  ),
                  
                  _buildStepItem(
                    '3. 서비스 시작',
                    '예약된 시간에 서비스가 시작됩니다',
                    isActive: false,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: RadixTokens.space6),
            
            Container(
              padding: const EdgeInsets.all(RadixTokens.space4),
              decoration: BoxDecoration(
                color: RadixTokens.blue2,
                borderRadius: BorderRadius.circular(RadixTokens.radius4),
                border: Border.all(color: RadixTokens.blue6),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: RadixTokens.blue9,
                    size: 20,
                  ),
                  const SizedBox(width: RadixTokens.space3),
                  Expanded(
                    child: Text(
                      '요양보호사 배정이 완료되면 홈 화면에서 알려드립니다.\n배정 완료까지 보통 30분~2시간 정도 소요됩니다.',
                      style: RadixTokens.body2.copyWith(
                        color: RadixTokens.blue11,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: RadixTokens.space8),
            
            SizedBox(
              width: double.infinity,
              height: 48,
              child: RadixButton(
                text: '홈으로 돌아가기',
                variant: RadixButtonVariant.solid,
                size: RadixButtonSize.large,
                fullWidth: true,
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(String title, String subtitle, {required bool isActive}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: RadixTokens.space3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: isActive ? RadixTokens.indigo9 : RadixTokens.slate6,
              borderRadius: BorderRadius.circular(RadixTokens.radius6),
            ),
          ),
          const SizedBox(width: RadixTokens.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: RadixTokens.body2.copyWith(
                    color: isActive ? RadixTokens.slate12 : RadixTokens.slate10,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                const SizedBox(height: RadixTokens.space1),
                Text(
                  subtitle,
                  style: RadixTokens.caption.copyWith(
                    color: RadixTokens.slate9,
                    height: 1.3,
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