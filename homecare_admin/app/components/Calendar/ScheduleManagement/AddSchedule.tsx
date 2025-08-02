import { Flex, Card, Heading, Text, Button, Select } from '@radix-ui/themes';
import { useState, useEffect } from 'react';
import { getCaregivers, CaregiverApi } from '../../../api';
import CaregiverSelectionList from '../../Common/CaregiverSelectionList';
import { formatCurrency } from '../../../utils/formatters';
import { WORK_TYPES, WORK_TYPE_COLORS } from '../../../constants/workTypes';

interface AddScheduleProps {
  onScheduleAdded?: () => void;
}

// API 데이터를 기존 Caregiver 형식으로 변환
function convertApiDataToCaregivers(apiData: CaregiverApi[]) {
  return apiData.map(caregiver => ({
    caregiverId: caregiver.caregiverId, // UUID 그대로 사용
    name: caregiver.name,
    phone: caregiver.phone,
    status: caregiver.status === 'ACTIVE' ? '활동중' : '휴직', // API 상태를 기존 상태로 매핑
    workTypes: caregiver.serviceTypes.map(type => {
      // API 서비스 타입을 기존 workTypes로 매핑
      switch (type) {
        case 'VISITING_CARE': return '방문요양';
        case 'DAY_NIGHT_CARE': return '주·야간보호';
        case 'RESPITE_CARE': return '단기보호';
        case 'VISITING_BATH': return '방문목욕';
        case 'IN_HOME_SUPPORT': return '재가노인지원';
        case 'VISITING_NURSING': return '방문간호';
        default: return '방문요양';
      }
    }),
    joinDate: new Date().toISOString().split('T')[0], // API에서 제공되지 않으므로 기본값 사용
    avatar: null,
    email: `${caregiver.name}@example.com`, // API에서 제공되지 않으므로 기본값 사용
    birthDate: '1980-01-01', // API에서 제공되지 않으므로 기본값 사용
    address: '기본 주소', // API에서 제공되지 않으므로 기본값 사용
    licenseNumber: '2023-000000', // API에서 제공되지 않으므로 기본값 사용
    licenseDate: '2023-01-01', // API에서 제공되지 않으므로 기본값 사용
    education: '완료', // API에서 제공되지 않으므로 기본값 사용
    hourlyWage: 12000, // API에서 제공되지 않으므로 기본값 사용
    workArea: '서울시', // API에서 제공되지 않으므로 기본값 사용
  }));
}

export default function AddSchedule({ onScheduleAdded }: AddScheduleProps) {
  const [scheduleStep, setScheduleStep] = useState<'select' | 'form' | 'confirm'>('select');
  const [selectedCaregiverForSchedule, setSelectedCaregiverForSchedule] = useState<string | null>(null);
  const [scheduleSearchTerm, setScheduleSearchTerm] = useState('');
  const [scheduleSelectedStatus, setScheduleSelectedStatus] = useState('전체');
  const [apiCaregivers, setApiCaregivers] = useState<CaregiverApi[]>([]);
  
  // 스케줄 폼 데이터
  const [selectedDate, setSelectedDate] = useState('');
  const [startTime, setStartTime] = useState('');
  const [endTime, setEndTime] = useState('');
  const [workType, setWorkType] = useState('');
  const [location, setLocation] = useState('');
  const [hourlyWage, setHourlyWage] = useState('');

  // API에서 요양보호사 데이터 가져오기
  useEffect(() => {
    const fetchCaregivers = async () => {
      try {
        const data = await getCaregivers();
        setApiCaregivers(data);
        console.log('요양보호사 데이터 로드 성공:', data);
      } catch (err) {
        console.error('요양보호사 로드 실패:', err);
      }
    };

    fetchCaregivers();
  }, []);

  // API 데이터를 기존 형식으로 변환
  const convertedApiCaregivers = convertApiDataToCaregivers(apiCaregivers);

  const workTypes = [
    { value: WORK_TYPES.VISITING_CARE, label: WORK_TYPES.VISITING_CARE },
    { value: WORK_TYPES.DAY_NIGHT_CARE, label: WORK_TYPES.DAY_NIGHT_CARE },
    { value: WORK_TYPES.RESPITE_CARE, label: WORK_TYPES.RESPITE_CARE },
    { value: WORK_TYPES.VISITING_BATH, label: WORK_TYPES.VISITING_BATH },
    { value: WORK_TYPES.IN_HOME_SUPPORT, label: WORK_TYPES.IN_HOME_SUPPORT },
    { value: WORK_TYPES.VISITING_NURSING, label: WORK_TYPES.VISITING_NURSING },
  ];

  const getWorkTypeColor = (type: string) => {
    return WORK_TYPE_COLORS[type as keyof typeof WORK_TYPE_COLORS] as "blue" | "purple" | "green" | "orange" | "yellow" | "red" || 'gray';
  };

  const calculateTotalAmount = () => {
    if (!hourlyWage || !startTime || !endTime) return 0;
    
    const hourlyWageNum = parseInt(hourlyWage);
    if (isNaN(hourlyWageNum)) return 0;
    
    // 시간을 분으로 변환
    const startMinutes = parseInt(startTime.split(':')[0]) * 60 + parseInt(startTime.split(':')[1]);
    const endMinutes = parseInt(endTime.split(':')[0]) * 60 + parseInt(endTime.split(':')[1]);
    
    // 근무 시간 계산 (시간 단위)
    const workHours = (endMinutes - startMinutes) / 60;
    
    // 총 금액 계산
    return Math.round(hourlyWageNum * workHours);
  };

  const handleSubmit = () => {
    if (!selectedCaregiverForSchedule || !selectedDate || !startTime || !endTime || !workType || !location || !hourlyWage) {
      alert('모든 필드를 입력해주세요.');
      return;
    }

    // 스케줄 추가 로직 (실제로는 API 호출)
    console.log('새 스케줄 추가:', {
      caregiverId: selectedCaregiverForSchedule,
      date: selectedDate,
      startTime,
      endTime,
      workType,
      location,
      hourlyWage: parseInt(hourlyWage)
    });

    // 폼 초기화
    setSelectedCaregiverForSchedule(null);
    setSelectedDate('');
    setStartTime('');
    setEndTime('');
    setWorkType('');
    setLocation('');
    setHourlyWage('');
    setScheduleStep('select');

    // 콜백 호출
    if (onScheduleAdded) {
      onScheduleAdded();
    }

    alert('스케줄이 추가되었습니다.');
  };



  return (
    <Flex gap="6" style={{ marginTop: '16px' }}>
      {/* 좌측: 단계별 폼 */}
      <Card style={{ flex: 1, padding: '20px' }}>
        <Heading size="3" mb="4">스케줄 추가</Heading>
        
        {/* 단계 표시 */}
        <Flex gap="2" mb="4">
          <Button 
            variant={scheduleStep === 'select' ? 'solid' : 'soft'} 
            size="1"
            onClick={() => setScheduleStep('select')}
          >
            1. 보호사 선택
          </Button>
          <Button 
            variant={scheduleStep === 'form' ? 'solid' : 'soft'} 
            size="1"
            onClick={() => setScheduleStep('form')}
            disabled={!selectedCaregiverForSchedule}
          >
            2. 스케줄 입력
          </Button>
          <Button 
            variant={scheduleStep === 'confirm' ? 'solid' : 'soft'} 
            size="1"
            onClick={() => setScheduleStep('confirm')}
            disabled={!selectedCaregiverForSchedule || !selectedDate || !startTime || !endTime || !workType || !location || !hourlyWage}
          >
            3. 등록 확인
          </Button>
        </Flex>

        {/* 단계별 내용 */}
        {scheduleStep === 'select' && (
          <Flex direction="column" gap="4">
            <CaregiverSelectionList
              searchTerm={scheduleSearchTerm}
              selectedStatus={scheduleSelectedStatus}
              selectedCaregiver={selectedCaregiverForSchedule}
              onSearchChange={setScheduleSearchTerm}
              onStatusChange={setScheduleSelectedStatus}
              onCaregiverSelect={setSelectedCaregiverForSchedule}
            />

            {selectedCaregiverForSchedule && (
              <Button 
                onClick={() => setScheduleStep('form')}
                style={{ marginTop: '8px' }}
              >
                다음 단계
              </Button>
            )}
          </Flex>
        )}

        {scheduleStep === 'form' && (
          <Flex direction="column" gap="4">
            <Text size="2" weight="medium">스케줄 정보 입력</Text>
            
            {selectedCaregiverForSchedule && (
              <Card style={{ padding: '12px', backgroundColor: 'var(--blue-2)' }}>
                <Text size="2" weight="medium">
                  선택된 보호사: {convertedApiCaregivers.find(c => c.caregiverId === selectedCaregiverForSchedule)?.name}
                </Text>
              </Card>
            )}

            <Flex direction="column" gap="4">
              {/* 날짜 및 시간 */}
              <Flex gap="4">
                <Flex direction="column" gap="2" style={{ flex: 1 }}>
                  <Text size="2" weight="medium">근무일 *</Text>
                  <input
                    type="date"
                    value={selectedDate}
                    onChange={(e) => setSelectedDate(e.target.value)}
                    style={{
                      padding: '8px 12px',
                      border: '1px solid var(--gray-6)',
                      borderRadius: '6px',
                      fontSize: '14px',
                      backgroundColor: 'var(--color-surface)',
                      color: 'var(--color-foreground)',
                      height: '32px',
                      boxSizing: 'border-box'
                    }}
                  />
                </Flex>
                <Flex direction="column" gap="2" style={{ flex: 1 }}>
                  <Text size="2" weight="medium">시작 시간 *</Text>
                  <input
                    type="time"
                    value={startTime}
                    onChange={(e) => setStartTime(e.target.value)}
                    style={{
                      padding: '8px 12px',
                      border: '1px solid var(--gray-6)',
                      borderRadius: '6px',
                      fontSize: '14px',
                      backgroundColor: 'var(--color-surface)',
                      color: 'var(--color-foreground)',
                      height: '32px',
                      boxSizing: 'border-box'
                    }}
                  />
                </Flex>
                <Flex direction="column" gap="2" style={{ flex: 1 }}>
                  <Text size="2" weight="medium">종료 시간 *</Text>
                  <input
                    type="time"
                    value={endTime}
                    onChange={(e) => setEndTime(e.target.value)}
                    style={{
                      padding: '8px 12px',
                      border: '1px solid var(--gray-6)',
                      borderRadius: '6px',
                      fontSize: '14px',
                      backgroundColor: 'var(--color-surface)',
                      color: 'var(--color-foreground)',
                      height: '32px',
                      boxSizing: 'border-box'
                    }}
                  />
                </Flex>
              </Flex>

              {/* 근무 유형 및 근무지 */}
              <Flex gap="4">
                <Flex direction="column" gap="2" style={{ flex: 1 }}>
                  <Text size="2" weight="medium">근무 유형 *</Text>
                  <Select.Root value={workType} onValueChange={setWorkType}>
                    <Select.Trigger placeholder="근무 유형을 선택하세요" />
                    <Select.Content>
                      {workTypes.map(type => (
                        <Select.Item key={type.value} value={type.value}>
                          <Flex align="center" gap="2">
                            <div
                              style={{
                                width: '12px',
                                height: '12px',
                                borderRadius: '50%',
                                backgroundColor: `var(--${getWorkTypeColor(type.value)}-9)`,
                              }}
                            />
                            {type.label}
                          </Flex>
                        </Select.Item>
                      ))}
                    </Select.Content>
                  </Select.Root>
                </Flex>
                <Flex direction="column" gap="2" style={{ flex: 1 }}>
                  <Text size="2" weight="medium">근무지 *</Text>
                  <input
                    type="text"
                    placeholder="근무지를 입력하세요"
                    value={location}
                    onChange={(e) => setLocation(e.target.value)}
                    style={{
                      padding: '8px 12px',
                      border: '1px solid var(--gray-6)',
                      borderRadius: '6px',
                      fontSize: '14px',
                      backgroundColor: 'var(--color-surface)',
                      color: 'var(--color-foreground)',
                      height: '32px',
                      boxSizing: 'border-box'
                    }}
                  />
                </Flex>
                <Flex direction="column" gap="2" style={{ flex: 1 }}>
                  <Text size="2" weight="medium">시급 (원) *</Text>
                  <input
                    type="text"
                    placeholder="시급을 입력하세요"
                    value={hourlyWage}
                    onChange={(e) => setHourlyWage(e.target.value)}
                    style={{
                      padding: '8px 12px',
                      border: '1px solid var(--gray-6)',
                      borderRadius: '6px',
                      fontSize: '14px',
                      backgroundColor: 'var(--color-surface)',
                      color: 'var(--color-foreground)',
                      height: '32px',
                      boxSizing: 'border-box'
                    }}
                  />
                  {hourlyWage && startTime && endTime && (
                    <Text size="1" color="gray">
                      총 금액: {formatCurrency(calculateTotalAmount())}
                    </Text>
                  )}
                </Flex>
              </Flex>
            </Flex>

            <Flex gap="2">
              <Button 
                variant="soft"
                onClick={() => setScheduleStep('select')}
              >
                이전 단계
              </Button>
              <Button 
                onClick={() => setScheduleStep('confirm')}
                disabled={!selectedDate || !startTime || !endTime || !workType || !location || !hourlyWage}
              >
                다음 단계
              </Button>
            </Flex>
          </Flex>
        )}

        {scheduleStep === 'confirm' && (
          <Flex direction="column" gap="4">
            <Text size="2" weight="medium">스케줄 등록 확인</Text>
            
            <Card style={{ padding: '16px', backgroundColor: 'var(--green-2)' }}>
              <Flex direction="column" gap="3">
                <Text size="2" weight="medium" color="green">스케줄 대상</Text>
                {selectedCaregiverForSchedule && (
                  <Text size="2">
                    {convertedApiCaregivers.find(c => c.caregiverId === selectedCaregiverForSchedule)?.name} 
                    ({convertedApiCaregivers.find(c => c.caregiverId === selectedCaregiverForSchedule)?.phone})
                  </Text>
                )}
              </Flex>
            </Card>

            <Card style={{ padding: '16px' }}>
              <Flex direction="column" gap="3">
                <Text size="2" weight="medium">스케줄 정보</Text>
                <Flex direction="column" gap="2">
                  <Text size="2" color="gray">근무일: {selectedDate}</Text>
                  <Text size="2" color="gray">시간: {startTime} ~ {endTime}</Text>
                  <Text size="2" color="gray">근무 유형: {workType}</Text>
                  <Text size="2" color="gray">근무지: {location}</Text>
                  <Text size="2" color="gray">시급: {formatCurrency(hourlyWage)} (총 {formatCurrency(calculateTotalAmount())})</Text>
                </Flex>
              </Flex>
            </Card>

            <Flex gap="2">
              <Button 
                variant="soft"
                onClick={() => setScheduleStep('form')}
              >
                이전 단계
              </Button>
              <Button 
                onClick={handleSubmit}
                color="green"
              >
                스케줄 등록
              </Button>
            </Flex>
          </Flex>
        )}
      </Card>

      {/* 우측: 안내 텍스트 */}
      <Flex direction="column" gap="4" style={{ flex: 1, padding: '20px' }}>
        <Text size="3" weight="medium" color="green">스케줄 추가 안내</Text>
        
        <Text size="2" color="gray">
          요양보호사의 근무 스케줄은 &quot;미배정&quot; 상태로 등록됩니다.
        </Text>
        
        <Text size="2" color="gray">
          이후 스케줄 목록에서 확인 후 배정할 수 있습니다.
        </Text>
      </Flex>
    </Flex>
  );
} 