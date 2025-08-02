import 'package:flutter/material.dart';
import '../design_system/radix_design_system.dart';
import '../models/user_profile_models.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  final _blacklistReasonController = TextEditingController();
  
  int _rating = 0;
  bool _isLoading = false;
  bool _showBlacklistOption = false;

  @override
  void dispose() {
    _reviewController.dispose();
    _blacklistReasonController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('평점을 선택해주세요')),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        String message = '후기가 등록되었습니다.';
        if (_showBlacklistOption && _blacklistReasonController.text.trim().isNotEmpty) {
          message = '후기 등록 및 블랙리스트 신고가 완료되었습니다.';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('후기 등록에 실패했습니다. 다시 시도해주세요.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _rating = index + 1;
              _showBlacklistOption = _rating <= 2;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: RadixTokens.space1),
            child: Icon(
              index < _rating ? Icons.star : Icons.star_border,
              color: index < _rating ? Colors.amber : RadixTokens.slate7,
              size: 40,
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final schedule = ModalRoute.of(context)?.settings.arguments as WorkSchedule?;
    
    if (schedule == null) {
      return Scaffold(
        appBar: RadixAppBar(title: '후기 작성'),
        body: const Center(child: Text('잘못된 접근입니다.')),
      );
    }

    return Scaffold(
      backgroundColor: RadixTokens.slate1,
      appBar: RadixAppBar(
        title: '후기 작성',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(RadixTokens.space4),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 서비스 정보 카드
              RadixCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '서비스 정보',
                      style: RadixTokens.body1.copyWith(
                        color: RadixTokens.slate12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: RadixTokens.space3),
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: RadixTokens.indigo3,
                            borderRadius: BorderRadius.circular(RadixTokens.radius3),
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
                                schedule.caregiverName,
                                style: RadixTokens.heading3.copyWith(
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
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: RadixTokens.space5),
              
              // 평점 섹션
              RadixCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '서비스 만족도',
                      style: RadixTokens.body1.copyWith(
                        color: RadixTokens.slate12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: RadixTokens.space3),
                    Text(
                      '서비스에 얼마나 만족하셨나요?',
                      style: RadixTokens.body2.copyWith(
                        color: RadixTokens.slate10,
                      ),
                    ),
                    const SizedBox(height: RadixTokens.space4),
                    _buildStarRating(),
                    const SizedBox(height: RadixTokens.space3),
                    Center(
                      child: Text(
                        _rating == 0 
                            ? '별점을 선택해주세요'
                            : '$_rating점 / 5점',
                        style: RadixTokens.body2.copyWith(
                          color: _rating == 0 ? RadixTokens.slate9 : RadixTokens.slate12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: RadixTokens.space5),
              
              // 후기 작성 섹션
              RadixCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '후기 작성',
                      style: RadixTokens.body1.copyWith(
                        color: RadixTokens.slate12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: RadixTokens.space3),
                    TextFormField(
                      controller: _reviewController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: '서비스 경험을 상세히 적어주세요.\n- 요양보호사의 서비스 태도\n- 전문성 및 친절함\n- 개선이 필요한 부분\n- 추천하고 싶은 점',
                        hintStyle: RadixTokens.body2.copyWith(
                          color: RadixTokens.slate9,
                        ),
                        filled: true,
                        fillColor: RadixTokens.slate1,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(RadixTokens.radius3),
                          borderSide: BorderSide(color: RadixTokens.slate7),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(RadixTokens.radius3),
                          borderSide: BorderSide(color: RadixTokens.slate7),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(RadixTokens.radius3),
                          borderSide: BorderSide(color: RadixTokens.indigo8, width: 2),
                        ),
                        contentPadding: const EdgeInsets.all(RadixTokens.space4),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '후기 내용을 입력해주세요';
                        }
                        if (value.trim().length < 10) {
                          return '10자 이상 작성해주세요';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              
              // 블랙리스트 신고 섹션 (평점이 낮을 때만 표시)
              if (_showBlacklistOption) ...[
                const SizedBox(height: RadixTokens.space5),
                RadixCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.warning_outlined,
                            color: Colors.red.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: RadixTokens.space2),
                          Text(
                            '문제점 신고',
                            style: RadixTokens.body1.copyWith(
                              color: RadixTokens.slate12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: RadixTokens.space3),
                      Text(
                        '심각한 문제가 있었다면 상세한 내용을 신고해주세요. 검토 후 해당 요양보호사의 향후 매칭에 반영됩니다.',
                        style: RadixTokens.body2.copyWith(
                          color: RadixTokens.slate10,
                        ),
                      ),
                      const SizedBox(height: RadixTokens.space4),
                      TextFormField(
                        controller: _blacklistReasonController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: '예시:\n- 약속 시간을 지키지 않음\n- 불친절하거나 부적절한 행동\n- 전문성 부족\n- 기타 심각한 문제점',
                          hintStyle: RadixTokens.body2.copyWith(
                            color: RadixTokens.slate9,
                          ),
                          filled: true,
                          fillColor: RadixTokens.slate1,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(RadixTokens.radius3),
                            borderSide: BorderSide(color: Colors.red.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(RadixTokens.radius3),
                            borderSide: BorderSide(color: Colors.red.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(RadixTokens.radius3),
                            borderSide: BorderSide(color: Colors.red.shade500, width: 2),
                          ),
                          contentPadding: const EdgeInsets.all(RadixTokens.space4),
                        ),
                      ),
                      const SizedBox(height: RadixTokens.space3),
                      Container(
                        padding: const EdgeInsets.all(RadixTokens.space3),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(RadixTokens.radius3),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.red.shade600,
                              size: 16,
                            ),
                            const SizedBox(width: RadixTokens.space2),
                            Expanded(
                              child: Text(
                                '신고 내용은 운영팀에서 신중히 검토됩니다.',
                                style: RadixTokens.caption.copyWith(
                                  color: Colors.red.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: RadixTokens.space6),
              
              // 제출 버튼
              SizedBox(
                height: 48,
                child: RadixButton(
                  text: '후기 등록하기',
                  variant: RadixButtonVariant.solid,
                  size: RadixButtonSize.large,
                  fullWidth: true,
                  loading: _isLoading,
                  onPressed: _isLoading ? null : _submitReview,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}