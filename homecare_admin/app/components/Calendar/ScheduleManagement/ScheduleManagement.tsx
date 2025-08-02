import { Flex, Heading, Text, Card, Button, Badge, Table, ScrollArea, Tabs, Select } from '@radix-ui/themes';
import { useState, useEffect } from 'react';
import { getCaregivers, CaregiverApi, getScheduleByDay, WorkMatch } from '../../../api';
import AddSchedule from './AddSchedule';
import { WORK_TYPE_COLORS, WORK_TYPES, WorkType } from '../../../constants/workTypes';

interface ScheduleManagementProps {
  onViewCaregiverSchedule?: (caregiverId: string) => void;
  selectedDate?: string;
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

// API 데이터를 기존 스케줄 형식으로 변환
function convertApiDataToSchedules(apiData: WorkMatch[]) {
  return apiData.map(workMatch => ({
    id: workMatch.workMatchId,
    caregiverId: workMatch.caregiverId,
    caregiverName: workMatch.caregiverName,
    consumer: '기본 수급자', // API에서 제공되지 않으므로 기본값 사용
    date: workMatch.workDate,
    startTime: workMatch.startTime.substring(0, 5), // HH:MM:SS -> HH:MM 형식으로 변환
    endTime: workMatch.endTime.substring(0, 5), // HH:MM:SS -> HH:MM 형식으로 변환
    workType: workMatch.serviceType.length > 0 ? mapServiceTypeToWorkType(workMatch.serviceType[0]) : WORK_TYPES.VISITING_CARE, // 첫 번째 서비스 타입 사용
    location: workMatch.address,
    hourlyWage: 12000, // API에서 제공되지 않으므로 기본값 사용
    status: (workMatch.status === 'PLANNED' ? '배정됨' : '미배정') as '배정됨' | '미배정' | '완료' | '취소', // API 상태를 기존 상태로 매핑
    notes: '', // API에서 제공되지 않으므로 기본값 사용
  }));
}

// API 서비스 타입을 기존 workType으로 매핑
function mapServiceTypeToWorkType(serviceType: string): WorkType {
  switch (serviceType) {
    case 'VISITING_CARE': return WORK_TYPES.VISITING_CARE;
    case 'DAY_NIGHT_CARE': return WORK_TYPES.DAY_NIGHT_CARE;
    case 'RESPITE_CARE': return WORK_TYPES.RESPITE_CARE;
    case 'VISITING_BATH': return WORK_TYPES.VISITING_BATH;
    case 'IN_HOME_SUPPORT': return WORK_TYPES.IN_HOME_SUPPORT;
    case 'VISITING_NURSING': return WORK_TYPES.VISITING_NURSING;
    default: return WORK_TYPES.VISITING_CARE;
  }
}

export default function ScheduleManagement({ onViewCaregiverSchedule, selectedDate: initialSelectedDate }: ScheduleManagementProps) {
  const [selectedTab, setSelectedTab] = useState('list');
  const [selectedDate, setSelectedDate] = useState(initialSelectedDate || new Date().toISOString().split('T')[0]);
  const [selectedCaregiver, setSelectedCaregiver] = useState('all');
  const [selectedStatus, setSelectedStatus] = useState('all');
  const [apiSchedules, setApiSchedules] = useState<WorkMatch[]>([]);
  const [apiCaregivers, setApiCaregivers] = useState<CaregiverApi[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

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

  // initialSelectedDate가 변경될 때 selectedDate 상태 업데이트
  useEffect(() => {
    if (initialSelectedDate) {
      setSelectedDate(initialSelectedDate);
    }
  }, [initialSelectedDate]);

  // 선택된 날짜에 따라 API에서 스케줄 데이터 가져오기
  useEffect(() => {
    const fetchSchedules = async () => {
      if (!selectedDate) return;
      
      setLoading(true);
      setError(null);
      try {
        const date = new Date(selectedDate);
        const year = date.getFullYear();
        const month = date.getMonth();
        const day = date.getDate();
        
        const data = await getScheduleByDay(year, month, day);
        setApiSchedules(data);
        console.log('스케줄 데이터 로드 성공:', data);
      } catch (err) {
        setError(err instanceof Error ? err.message : '스케줄 로드 실패');
        console.error('스케줄 로드 실패:', err);
      } finally {
        setLoading(false);
      }
    };

    fetchSchedules();
  }, [selectedDate]);

  const tabs = [
    { key: 'list', label: '스케줄 목록' },
    { key: 'add', label: '스케줄 추가' },
  ];

  const getStatusColor = (status: string) => {
    switch (status) {
      case '완료': return 'green';
      case '배정됨': return 'blue';
      case '미배정': return 'orange';
      case '취소': return 'red';
      default: return 'gray';
    }
  };

  const getStatusText = (status: string) => {
    switch (status) {
      case '완료': return '완료';
      case '배정됨': return '배정됨';
      case '미배정': return '미배정';
      case '취소': return '취소';
      default: return '알 수 없음';
    }
  };

  // API 데이터를 기존 형식으로 변환
  const convertedApiSchedules = convertApiDataToSchedules(apiSchedules);
  const convertedApiCaregivers = convertApiDataToCaregivers(apiCaregivers);

  const filteredSchedules = convertedApiSchedules.filter(schedule => {
    const matchesDate = selectedDate === '' || schedule.date === selectedDate;
    const matchesCaregiver = selectedCaregiver === 'all' || 
                            schedule.caregiverId === selectedCaregiver;
    const matchesStatus = selectedStatus === 'all' || schedule.status === selectedStatus;
    return matchesDate && matchesCaregiver && matchesStatus;
  });

  const handleApprove = (id: string) => {
    console.log('스케줄 승인:', id);
  };

  const handleReject = (id: string) => {
    console.log('스케줄 반려:', id);
  };

  const handleViewCaregiverSchedule = (caregiverId: string) => {
    if (onViewCaregiverSchedule) {
      onViewCaregiverSchedule(caregiverId);
    }
  };

  return (
    <Flex direction="column" gap="4" style={{ flex: 1, minHeight: 0 }}>
      <Heading size="4">스케줄 관리</Heading>

      <Tabs.Root value={selectedTab} onValueChange={setSelectedTab}>
        <Tabs.List>
          {tabs.filter(tab => tab.key !== 'approval').map(tab => (
            <Tabs.Trigger key={tab.key} value={tab.key}>
              {tab.label}
            </Tabs.Trigger>
          ))}
        </Tabs.List>
      </Tabs.Root>

      {selectedTab === 'list' && (
        <>
          {/* 필터 */}
          <Card style={{ padding: '16px' }}>
            <Flex gap="4" align="end">
              <Flex direction="column" gap="2">
                <Text size="2" weight="medium">날짜</Text>
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

              <Flex direction="column" gap="2">
                <Text size="2" weight="medium">보호사</Text>
                <Select.Root value={selectedCaregiver} onValueChange={setSelectedCaregiver}>
                  <Select.Trigger style={{ width: '150px' }} />
                  <Select.Content>
                    <Select.Item value="all">전체</Select.Item>
                    {convertedApiCaregivers.map(caregiver => (
                      <Select.Item key={caregiver.caregiverId} value={caregiver.caregiverId}>
                        {caregiver.name}
                      </Select.Item>
                    ))}
                  </Select.Content>
                </Select.Root>
              </Flex>

              <Flex direction="column" gap="2">
                <Text size="2" weight="medium">상태</Text>
                <Select.Root value={selectedStatus} onValueChange={setSelectedStatus}>
                  <Select.Trigger style={{ width: '120px' }} />
                  <Select.Content>
                    <Select.Item value="all">전체</Select.Item>
                    <Select.Item value="미배정">미배정</Select.Item>
                    <Select.Item value="배정됨">배정됨</Select.Item>
                    <Select.Item value="완료">완료</Select.Item>
                    <Select.Item value="취소">취소</Select.Item>
                  </Select.Content>
                </Select.Root>
              </Flex>

              <Button variant="soft">필터 적용</Button>
            </Flex>
          </Card>

          {/* 로딩 상태 표시 */}
          {loading && (
            <Card style={{ padding: '20px' }}>
              <Flex justify="center" align="center">
                <Text size="2" color="gray">스케줄 데이터 로딩 중...</Text>
              </Flex>
            </Card>
          )}

          {/* 에러 상태 표시 */}
          {error && (
            <Card style={{ padding: '20px' }}>
              <Flex justify="center" align="center">
                <Text size="2" color="red">{error}</Text>
              </Flex>
            </Card>
          )}

          {/* 스케줄 목록 */}
          {!loading && !error && (
            <Card style={{ flex: 1, minHeight: 0 }}>
              <ScrollArea style={{ height: '100%' }}>
                <Table.Root>
                  <Table.Header>
                    <Table.Row>
                      <Table.ColumnHeaderCell>보호사명</Table.ColumnHeaderCell>
                      <Table.ColumnHeaderCell>날짜</Table.ColumnHeaderCell>
                      <Table.ColumnHeaderCell>시간</Table.ColumnHeaderCell>
                      <Table.ColumnHeaderCell>근무 유형</Table.ColumnHeaderCell>
                      <Table.ColumnHeaderCell>근무지</Table.ColumnHeaderCell>
                      <Table.ColumnHeaderCell>시급</Table.ColumnHeaderCell>
                      <Table.ColumnHeaderCell>상태</Table.ColumnHeaderCell>
                      <Table.ColumnHeaderCell>작업</Table.ColumnHeaderCell>
                    </Table.Row>
                  </Table.Header>
                  <Table.Body>
                    {filteredSchedules.length === 0 ? (
                      <Table.Row>
                        <Table.Cell colSpan={8}>
                          <Flex justify="center" align="center" p="4">
                            <Text size="2" color="gray">
                              해당 날짜의 스케줄이 없습니다.
                            </Text>
                          </Flex>
                        </Table.Cell>
                      </Table.Row>
                    ) : (
                      filteredSchedules.map(schedule => (
                        <Table.Row key={schedule.id}>
                          <Table.Cell>
                              <Text weight="medium">{schedule.caregiverName}</Text>
                          </Table.Cell>
                          <Table.Cell>
                            <Text size="2">{schedule.date}</Text>
                          </Table.Cell>
                          <Table.Cell>
                            <Text size="2">{schedule.startTime} - {schedule.endTime}</Text>
                          </Table.Cell>
                          <Table.Cell>
                            <Badge 
                              color={WORK_TYPE_COLORS[schedule.workType] as "blue" | "purple" | "green" | "orange" | "yellow" | "red"} 
                              size="1"
                            >
                              {schedule.workType}
                            </Badge>
                          </Table.Cell>
                          <Table.Cell>
                            <Text size="2" color="gray">{schedule.location}</Text>
                          </Table.Cell>
                          <Table.Cell>
                            <Text size="2">{schedule.hourlyWage.toLocaleString()}원</Text>
                          </Table.Cell>
                          <Table.Cell>
                            <Badge color={getStatusColor(schedule.status)} size="1">
                              {getStatusText(schedule.status)}
                            </Badge>
                          </Table.Cell>
                          <Table.Cell>
                              <Flex gap="2">
                              <Button 
                                variant="soft" 
                                size="1" 
                                color="blue"
                                onClick={() => handleViewCaregiverSchedule(schedule.caregiverId)}
                              >
                                조회
                              </Button>
                              {schedule.status === '미배정' && (
                                <>
                                <Button 
                                  variant="soft" 
                                  size="1" 
                                  color="green"
                                  onClick={() => handleApprove(schedule.id)}
                                >
                                  배정
                                </Button>
                                <Button 
                                  variant="soft" 
                                  size="1" 
                                  color="red"
                                  onClick={() => handleReject(schedule.id)}
                                >
                                  취소
                                </Button>
                                </>
                              )}
                              </Flex>
                          </Table.Cell>
                        </Table.Row>
                      ))
                    )}
                  </Table.Body>
                </Table.Root>
              </ScrollArea>
            </Card>
          )}
        </>
      )}

      {selectedTab === 'add' && (
        <AddSchedule />
      )}
    </Flex>
  );
} 