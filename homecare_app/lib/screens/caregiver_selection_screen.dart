import 'package:flutter/material.dart';
import '../design_system/radix_design_system.dart';
import '../models/match_models.dart';
import '../models/service_request_models.dart';
import '../services/api/service_request_api_service.dart';

class CaregiverSelectionScreen extends StatefulWidget {
  final String serviceRequestId;
  final List<MatchingResponseDto> matchedCaregivers;

  const CaregiverSelectionScreen({
    super.key,
    required this.serviceRequestId,
    required this.matchedCaregivers,
  });

  @override
  State<CaregiverSelectionScreen> createState() => _CaregiverSelectionScreenState();
}

class _CaregiverSelectionScreenState extends State<CaregiverSelectionScreen> {
  List<MatchingResponseDto> _caregivers = [];
  String? _selectedCaregiverId;
  final bool _isLoading = false;
  bool _isConfirming = false;

  @override
  void initState() {
    super.initState();
    _caregivers = widget.matchedCaregivers;
  }

  Future<void> _confirmSelection() async {
    if (_selectedCaregiverId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('요양보호사를 선택해주세요')),
      );
      return;
    }

    setState(() => _isConfirming = true);

    try {
      final confirmRequest = ConfirmCaregiverRequest(
        serviceRequestId: widget.serviceRequestId,
        caregiverId: _selectedCaregiverId!,
      );

      await ServiceRequestApiService.confirmCaregiver(confirmRequest);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('요양보호사 선택이 완료되었습니다. 곧 연락드리겠습니다.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('선택 확정에 실패했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isConfirming = false);
      }
    }
  }

  Widget _buildCaregiverCard(MatchingResponseDto caregiver) {
    final isSelected = _selectedCaregiverId == caregiver.caregiverId;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCaregiverId = caregiver.caregiverId;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: RadixTokens.space4),
        decoration: BoxDecoration(
          color: RadixTokens.slate1,
          borderRadius: BorderRadius.circular(RadixTokens.radius4),
          border: Border.all(
            color: isSelected ? RadixTokens.indigo8 : RadixTokens.slate6,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: RadixTokens.indigo9.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(RadixTokens.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        Row(
                          children: [
                            Text(
                              caregiver.caregiverName,
                              style: RadixTokens.heading3.copyWith(
                                color: RadixTokens.slate12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: RadixTokens.space2),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: RadixTokens.space2,
                                vertical: RadixTokens.space1,
                              ),
                              decoration: BoxDecoration(
                                color: RadixTokens.grass3,
                                borderRadius: BorderRadius.circular(RadixTokens.radius2),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: RadixTokens.space1),
                        Row(
                          children: [
                            Text(
                              '근무시간: ${caregiver.availableStartTime} - ${caregiver.availableEndTime}',
                              style: RadixTokens.body2.copyWith(
                                color: RadixTokens.slate10,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: RadixTokens.space1),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: RadixTokens.slate9,
                              size: 16,
                            ),
                            const SizedBox(width: RadixTokens.space1),
                            Expanded(
                              child: Text(
                                caregiver.address,
                                style: RadixTokens.body2.copyWith(
                                  color: RadixTokens.slate10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.all(RadixTokens.space1),
                      decoration: BoxDecoration(
                        color: RadixTokens.indigo9,
                        borderRadius: BorderRadius.circular(RadixTokens.radius6),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: RadixTokens.space3),
              
              Text(
                caregiver.matchReason,
                style: RadixTokens.body2.copyWith(
                  color: RadixTokens.slate11,
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: RadixTokens.space3),
              
              Row(
                children: [
                  Text(
                    '위치:',
                    style: RadixTokens.body2.copyWith(
                      color: RadixTokens.slate10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: RadixTokens.space2),
                  Text(
                    '위도: ${caregiver.location[0].toStringAsFixed(4)}, 경도: ${caregiver.location[1].toStringAsFixed(4)}',
                    style: RadixTokens.body2.copyWith(
                      color: RadixTokens.slate11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RadixTokens.slate1,
      appBar: RadixAppBar(
        title: '요양보호사 선택',
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: RadixTokens.space4),
                  Text('매칭 알고리즘을 통해\n최적의 요양보호사를 찾고 있습니다...'),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(RadixTokens.space4),
                  color: RadixTokens.indigo2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '추천 요양보호사',
                        style: RadixTokens.heading2.copyWith(
                          color: RadixTokens.slate12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: RadixTokens.space2),
                      Text(
                        '매칭 알고리즘을 통해 선별된 ${_caregivers.length}명의 요양보호사입니다.\n원하시는 분을 선택해주세요.',
                        style: RadixTokens.body1.copyWith(
                          color: RadixTokens.slate11,
                        ),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(RadixTokens.space4),
                    itemCount: _caregivers.length,
                    itemBuilder: (context, index) {
                      return _buildCaregiverCard(_caregivers[index]);
                    },
                  ),
                ),
                
                Container(
                  padding: const EdgeInsets.all(RadixTokens.space4),
                  decoration: BoxDecoration(
                    color: RadixTokens.slate1,
                    border: Border(
                      top: BorderSide(
                        color: RadixTokens.slate6,
                        width: 1,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: RadixButton(
                        text: '선택 확정',
                        variant: RadixButtonVariant.solid,
                        size: RadixButtonSize.large,
                        fullWidth: true,
                        loading: _isConfirming,
                        onPressed: _isConfirming || _selectedCaregiverId == null 
                            ? null 
                            : _confirmSelection,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}