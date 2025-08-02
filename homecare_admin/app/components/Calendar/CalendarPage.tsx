import { Flex, Text, Card } from '@radix-ui/themes';
import { useState, useEffect } from 'react';
import PageHeader from '../Common/PageHeader';
import CalendarSidebar from './CalendarView/CalendarSidebar';
import CalendarHeader from './CalendarView/CalendarHeader';
import CalendarGrid from './CalendarView/CalendarGrid';
import ScheduleManagement from './ScheduleManagement/ScheduleManagement';
import CaregiverSchedule from './CaregiverSchedule/CaregiverSchedule';
import CaregiverList from '../Common/CaregiverList';
import { getCaregivers, CaregiverApi } from '../../api';
import { WORK_TYPES, WorkType } from '../../constants/workTypes';

const tabs = [
  { key: 'calendar', label: '캘린더 보기' },
  { key: 'schedule', label: '스케줄 관리' },
  { key: 'caregiver-schedule', label: '요양보호사별 스케줄' },
];

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

export default function CalendarPage() {
  const [tab, setTab] = useState('calendar');
  const [selectedCaregiverId, setSelectedCaregiverId] = useState<string | null>(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedStatus, setSelectedStatus] = useState('전체');
  const [apiCaregivers, setApiCaregivers] = useState<CaregiverApi[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [workTypeFilters, setWorkTypeFilters] = useState<Record<WorkType, boolean>>({
    [WORK_TYPES.VISITING_CARE]: true,
    [WORK_TYPES.DAY_NIGHT_CARE]: true,
    [WORK_TYPES.RESPITE_CARE]: true,
    [WORK_TYPES.VISITING_BATH]: true,
    [WORK_TYPES.IN_HOME_SUPPORT]: true,
    [WORK_TYPES.VISITING_NURSING]: true
  });
  const [date, setDate] = useState(new Date());
  const [selectedDateForSchedule, setSelectedDateForSchedule] = useState<string>('');

  // API에서 요양보호사 데이터 가져오기
  useEffect(() => {
    const fetchCaregivers = async () => {
      setLoading(true);
      setError(null);
      try {
        const data = await getCaregivers();
        setApiCaregivers(data);
        console.log('요양보호사 데이터 로드 성공:', data);
      } catch (err) {
        setError(err instanceof Error ? err.message : '요양보호사 로드 실패');
        console.error('요양보호사 로드 실패:', err);
      } finally {
        setLoading(false);
      }
    };

    fetchCaregivers();
  }, []);

  // API 데이터를 기존 형식으로 변환
  const convertedApiCaregivers = convertApiDataToCaregivers(apiCaregivers);

  const handleViewCaregiverSchedule = (caregiverId: string) => {
    setSelectedCaregiverId(caregiverId);
    setTab('caregiver-schedule');
  };

  const handleCaregiverSelect = (caregiverId: string) => {
    setSelectedCaregiverId(caregiverId);
  };

  const handleTabChange = (newTab: string) => {
    setTab(newTab);
    if (newTab !== 'caregiver-schedule') {
      setSelectedCaregiverId(null);
    }
  };

  const handleWorkTypeFilterChange = (filters: Record<WorkType, boolean>) => {
    setWorkTypeFilters(filters);
  };

  const handleDateClick = (dateStr: string) => {
    setSelectedDateForSchedule(dateStr);
    setTab('schedule');
  };

  const handleNavigateToDate = (year: number, month: number) => {
    setDate(new Date(year, month, 1));
  };

  return (
    <Flex direction="column" gap="5" p="6" style={{ height: '100vh' }}>
      <PageHeader 
        tabs={tabs}
        selectedTab={tab}
        onTabChange={handleTabChange}
      />

      {/* 탭별 내용 */}
      {tab === 'calendar' && (
        <Flex gap="6" style={{ flex: 1, minHeight: 0 }}>
          <CalendarSidebar 
            selectedDate={date} 
            onDateChange={setDate} 
            onWorkTypeFilterChange={handleWorkTypeFilterChange}
          />
          <Flex direction="column" style={{ flex: 1 }}>
            <CalendarHeader
              year={date.getFullYear()}
              month={date.getMonth()}
              onPrev={() => setDate(new Date(date.getFullYear(), date.getMonth() - 1, 1))}
              onNext={() => setDate(new Date(date.getFullYear(), date.getMonth() + 1, 1))}
              onToday={() => setDate(new Date())}
              onNavigateToDate={handleNavigateToDate}
            />
            <CalendarGrid 
              year={date.getFullYear()} 
              month={date.getMonth()} 
              workTypeFilters={workTypeFilters}
              onDateClick={handleDateClick}
            />
          </Flex>
        </Flex>
      )}

      {tab === 'schedule' && (
        <ScheduleManagement 
          onViewCaregiverSchedule={handleViewCaregiverSchedule}
          selectedDate={selectedDateForSchedule}
        />
      )}

      {tab === 'caregiver-schedule' && (
        <Flex gap="6" style={{ flex: 1, minHeight: 0 }}>
          <CaregiverList
            searchTerm={searchTerm}
            selectedStatus={selectedStatus}
            multiSelectMode={false}
            selectedCaregiver={selectedCaregiverId}
            selectedCaregivers={[]}
            onSearchChange={setSearchTerm}
            onStatusChange={setSelectedStatus}
            onCaregiverSelect={handleCaregiverSelect}
            showMultiSelectToggle={false}
          />
          
          {loading && (
            <Card style={{ flex: 3, display: 'flex', flexDirection: 'column' }}>
              <Flex direction="column" gap="4" p="4" style={{ flex: 1 }}>
                <Flex justify="center" align="center" style={{ flex: 1 }}>
                  <Text size="4" color="gray">요양보호사 데이터 로딩 중...</Text>
                </Flex>
              </Flex>
            </Card>
          )}

          {error && (
            <Card style={{ flex: 3, display: 'flex', flexDirection: 'column' }}>
              <Flex direction="column" gap="4" p="4" style={{ flex: 1 }}>
                <Flex justify="center" align="center" style={{ flex: 1 }}>
                  <Text size="4" color="red">오류: {error}</Text>
                </Flex>
              </Flex>
            </Card>
          )}

          {!loading && !error && selectedCaregiverId ? (
            <CaregiverSchedule 
              caregiver={convertedApiCaregivers.find(c => c.caregiverId === selectedCaregiverId)!} 
            />
          ) : !loading && !error && (
            <Card style={{ flex: 3, display: 'flex', flexDirection: 'column' }}>
              <Flex direction="column" gap="4" p="4" style={{ flex: 1 }}>
                <Flex justify="center" align="center" style={{ flex: 1 }}>
                  <Text size="4" color="gray">보호사를 선택하여 스케줄을 확인하세요</Text>
                </Flex>
              </Flex>
            </Card>
          )}
        </Flex>
      )}
    </Flex>
  );
} 