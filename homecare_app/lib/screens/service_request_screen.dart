import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../design_system/radix_design_system.dart';
import '../services/api/service_request_api_service.dart';
import '../services/api/match_api_service.dart';
import '../services/auth_service.dart';
import '../models/service_request_models.dart';
import 'caregiver_selection_screen.dart';

class ServiceRequestScreen extends StatefulWidget {
  const ServiceRequestScreen({super.key});

  @override
  State<ServiceRequestScreen> createState() => _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends State<ServiceRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _specialRequestsController = TextEditingController();
  final _locationController = TextEditingController();
  
  ServiceType? _selectedServiceType;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _serviceTypes = [
    {'type': ServiceType.visitingCare, 'name': '방문요양서비스'},
    {'type': ServiceType.dayNightCare, 'name': '주야간보호서비스'},
    {'type': ServiceType.respiteCare, 'name': '단기보호서비스'},
    {'type': ServiceType.visitingBath, 'name': '방문목욕서비스'},
    {'type': ServiceType.inHomeSupport, 'name': '재가노인지원서비스'},
    {'type': ServiceType.visitingNursing, 'name': '방문간호서비스'},
  ];

  @override
  void dispose() {
    _specialRequestsController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _formatDate() {
    if (_selectedDate == null) return '날짜 선택';
    return DateFormat('yyyy년 MM월 dd일').format(_selectedDate!);
  }

  String _formatTime() {
    if (_selectedTime == null) return '시간 선택';
    final hour = _selectedTime!.hour.toString().padLeft(2, '0');
    final minute = _selectedTime!.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedServiceType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('서비스 유형을 선택해주세요')),
      );
      return;
    }
    
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('방문 날짜를 선택해주세요')),
      );
      return;
    }
    
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('방문 시간을 선택해주세요')),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      final userId = AuthService.currentUserId;
      if (userId == null) {
        throw Exception('로그인이 필요합니다');
      }

      // 서비스 요청 데이터 생성
      final request = ServiceRequestRequest(
        userId: userId,
        address: _locationController.text.trim(),
        location: LocationDto(
          latitude: 37.5665, // TODO: 실제 위치 데이터로 교체
          longitude: 126.9780,
        ),
        preferredTimeStart: LocalTime(
          hour: _selectedTime!.hour,
          minute: _selectedTime!.minute,
        ),
        preferredTimeEnd: LocalTime(
          hour: _selectedTime!.hour + 2, // 2시간 후로 기본 설정
          minute: _selectedTime!.minute,
        ),
        serviceType: _selectedServiceType!,
        personalityType: '친절함', // TODO: 선호 성격 유형 선택 UI 추가
        requestedDays: [DateFormat('yyyy-MM-dd').format(_selectedDate!)],
        additionalInformation: _specialRequestsController.text.trim(),
      );

      // 1단계: 서비스 요청 생성
      final createResponse = await ServiceRequestApiService.createServiceRequest(request);
      final serviceRequestId = createResponse.serviceRequestId;
      
      // 2단계: 매칭 프로세스 실행
      final matchResponse = await MatchApiService.processMatching(serviceRequestId);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '서비스 신청이 완료되었습니다.\n${matchResponse.totalMatches}명의 요양보호사가 매칭되었습니다.'
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        
        // 매칭된 요양보호사 선택 화면으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CaregiverSelectionScreen(
              serviceRequestId: serviceRequestId,
              matchedCaregivers: matchResponse.matchedCaregivers,
            ),
          ),
        );
      }
    } catch (e) {
      // 디버그 로그로 상세한 오류 정보 출력
      print('[DEBUG] Service request failed: ${e.toString()}');
      print('[DEBUG] Error type: ${e.runtimeType}');
      if (e is Exception) {
        print('[DEBUG] Exception details: $e');
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('서비스 신청 중 문제가 발생했습니다. 관리자에게 문의해주세요.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RadixTokens.slate1,
      appBar: RadixAppBar(
        title: '서비스 신청',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(RadixTokens.space4),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '필요한 서비스를 신청하세요',
                style: RadixTokens.heading2.copyWith(
                  color: RadixTokens.slate12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RadixTokens.space2),
              Text(
                '요양보호사가 매칭되면 연락드리겠습니다',
                style: RadixTokens.body1.copyWith(
                  color: RadixTokens.slate11,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: RadixTokens.space6),
              
              RadixCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 서비스 유형 선택
                    Text(
                      '서비스 유형',
                      style: RadixTokens.body1.copyWith(
                        color: RadixTokens.slate12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: RadixTokens.space3),
                    
                    DropdownButtonFormField<ServiceType>(
                      value: _selectedServiceType,
                      decoration: InputDecoration(
                        hintText: '서비스를 선택해주세요',
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: RadixTokens.space4,
                          vertical: RadixTokens.space3,
                        ),
                      ),
                      items: _serviceTypes.map((service) {
                        return DropdownMenuItem<ServiceType>(
                          value: service['type'],
                          child: Text(
                            service['name']!,
                            style: RadixTokens.body2.copyWith(
                              color: RadixTokens.slate12,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedServiceType = value;
                        });
                      },
                    ),
                    
                    const SizedBox(height: RadixTokens.space5),
                    
                    // 방문 일정
                    Text(
                      '방문 일정',
                      style: RadixTokens.body1.copyWith(
                        color: RadixTokens.slate12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: RadixTokens.space3),
                    
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: _isLoading ? null : _selectDate,
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: RadixTokens.slate1,
                                border: Border.all(
                                  color: _selectedDate == null 
                                      ? RadixTokens.slate7 
                                      : RadixTokens.indigo8,
                                ),
                                borderRadius: BorderRadius.circular(RadixTokens.radius3),
                              ),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: RadixTokens.space4),
                                    child: Icon(Icons.calendar_today_outlined),
                                  ),
                                  const SizedBox(width: RadixTokens.space3),
                                  Expanded(
                                    child: Text(
                                      _formatDate(),
                                      style: RadixTokens.body2.copyWith(
                                        color: _selectedDate == null 
                                            ? RadixTokens.slate9 
                                            : RadixTokens.slate12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: RadixTokens.space3),
                        Expanded(
                          child: GestureDetector(
                            onTap: _isLoading ? null : _selectTime,
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: RadixTokens.slate1,
                                border: Border.all(
                                  color: _selectedTime == null 
                                      ? RadixTokens.slate7 
                                      : RadixTokens.indigo8,
                                ),
                                borderRadius: BorderRadius.circular(RadixTokens.radius3),
                              ),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: RadixTokens.space4),
                                    child: Icon(Icons.access_time),
                                  ),
                                  const SizedBox(width: RadixTokens.space3),
                                  Expanded(
                                    child: Text(
                                      _formatTime(),
                                      style: RadixTokens.body2.copyWith(
                                        color: _selectedTime == null 
                                            ? RadixTokens.slate9 
                                            : RadixTokens.slate12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: RadixTokens.space5),
                    
                    // 방문 위치
                    Text(
                      '방문 위치',
                      style: RadixTokens.body1.copyWith(
                        color: RadixTokens.slate12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: RadixTokens.space3),
                    
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        hintText: '서울시 강남구 테헤란로 123',
                        hintStyle: RadixTokens.body2.copyWith(
                          color: RadixTokens.slate9,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.map_outlined),
                          onPressed: () {
                            // TODO: 지도 기반 위치 선택 기능 구현
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('지도 기능은 데모에서 준비 중입니다'),
                              ),
                            );
                          },
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: RadixTokens.space4,
                          vertical: RadixTokens.space3,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '방문 위치를 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: RadixTokens.space5),
                    
                    // 돌봄 대상자 정보 및 특별 요청사항
                    Text(
                      '돌봄이 필요하신 분의 정보 및 특별 요청사항',
                      style: RadixTokens.body1.copyWith(
                        color: RadixTokens.slate12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: RadixTokens.space3),
                    
                    TextFormField(
                      controller: _specialRequestsController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: '예시:\n- 연령: 85세 여성\n- 거동 상태: 휠체어 이용\n- 건강 상태: 치매 초기\n- 특별 요청: 목욕 도움 필요\n- 주의사항: 혈압약 복용 중',
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
                          return '돌봄 대상자 정보를 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: RadixTokens.space6),
                    
                    // 신청 버튼
                    SizedBox(
                      height: 48,
                      child: RadixButton(
                        text: '서비스 신청하기',
                        variant: RadixButtonVariant.solid,
                        size: RadixButtonSize.large,
                        fullWidth: true,
                        loading: _isLoading,
                        onPressed: _isLoading ? null : _submitRequest,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}