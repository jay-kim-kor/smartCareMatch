import { Flex, Heading, Card, Tabs, Button } from '@radix-ui/themes';
import { useState, useRef, useEffect } from 'react';
import { Caregiver } from '../../../data/caregivers';
import ScheduleList from './ScheduleList';
import MonthlyStats from './MonthlyStats';
import ScheduleGrid from './ScheduleGrid';
import { exportAndDownloadSchedule } from '../../../utils/scheduleImageExport';
import { getCaregiverSchedule, ServiceMatch } from '../../../api';
import { WORK_TYPES, WorkType } from '../../../constants/workTypes';

interface CaregiverScheduleProps {
  caregiver: Caregiver;
}

// API 데이터를 기존 스케줄 형식으로 변환
function convertApiDataToSchedules(apiData: ServiceMatch[]) {
  return apiData.map(serviceMatch => ({
    id: serviceMatch.serviceMatchId,
    caregiverId: serviceMatch.caregiverId,
    caregiverName: serviceMatch.caregiverName,
    consumer: serviceMatch.consumerName,
    date: serviceMatch.serviceDate,
    startTime: serviceMatch.startTime.substring(0, 5), // HH:MM:SS -> HH:MM 형식으로 변환
    endTime: serviceMatch.endTime.substring(0, 5), // HH:MM:SS -> HH:MM 형식으로 변환
    workType: serviceMatch.workType.length > 0 ? mapServiceTypeToWorkType(serviceMatch.workType[0]) : WORK_TYPES.VISITING_CARE, // 첫 번째 서비스 타입 사용
    location: serviceMatch.address,
    hourlyWage: serviceMatch.hourlyWage,
    status: (serviceMatch.status === 'PENDING' ? '미배정' : serviceMatch.status === 'PLANNED' ? '배정됨' : '완료') as '배정됨' | '미배정' | '완료' | '취소', // API 상태를 기존 상태로 매핑
    notes: serviceMatch.notes || '', // API에서 제공되지 않으므로 기본값 사용
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

export default function CaregiverSchedule({ caregiver }: CaregiverScheduleProps) {
  const [selectedTab, setSelectedTab] = useState('schedule');
  const [isExporting, setIsExporting] = useState(false);
  const [apiSchedules, setApiSchedules] = useState<ServiceMatch[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const scheduleGridRef = useRef<HTMLDivElement>(null);

  // API에서 요양보호사 스케줄 데이터 가져오기
  useEffect(() => {
    const fetchCaregiverSchedules = async () => {
      setLoading(true);
      setError(null);
      try {
        const data = await getCaregiverSchedule(caregiver.caregiverId);
        setApiSchedules(data);
        console.log('요양보호사 스케줄 데이터 로드 성공:', data);
      } catch (err) {
        setError(err instanceof Error ? err.message : '스케줄 로드 실패');
        console.error('요양보호사 스케줄 로드 실패:', err);
      } finally {
        setLoading(false);
      }
    };

    fetchCaregiverSchedules();
  }, [caregiver.caregiverId]);

  const tabs = [
    { key: 'schedule', label: '스케줄표' },
    { key: 'schedules', label: '스케줄 목록' },
    { key: 'monthly', label: '월별 통계' },
  ];

  // API 데이터를 기존 형식으로 변환
  const convertedApiSchedules = convertApiDataToSchedules(apiSchedules);

  // 이미지 출력 처리
  const handleExportImage = async () => {
    if (selectedTab !== 'schedule') {
      alert('스케줄표 탭에서만 이미지 출력이 가능합니다.');
      return;
    }
    
    if (!scheduleGridRef.current) {
      alert('스케줄 그리드를 찾을 수 없습니다. 잠시 후 다시 시도해주세요.');
      return;
    }

    setIsExporting(true);
    try {
      const filename = `${caregiver.name}_보호사_스케줄_${new Date().toISOString().split('T')[0]}.png`;
      
      await exportAndDownloadSchedule(scheduleGridRef.current, {
        format: 'png',
        quality: 0.95,
        width: 1200,
        filename
      });
    } catch (error) {
      console.error('이미지 출력 실패:', error);
      alert('이미지 출력 중 오류가 발생했습니다.');
    } finally {
      setIsExporting(false);
    }
  };

  return (
    <Card style={{ flex: 3, display: 'flex', flexDirection: 'column', height: '100%', minHeight: 0 }}>
      <Flex direction="column" gap="4" p="4" style={{ flex: 1, minHeight: 0, height: '100%' }}>
        <Flex justify="between" align="center" style={{ flexShrink: 0 }}>
          <Heading size="4">{caregiver.name} 보호사 스케줄</Heading>
          <Button 
            variant="soft" 
            size="2" 
            onClick={handleExportImage}
            disabled={isExporting || selectedTab !== 'schedule'}
          >
            {isExporting ? '출력 중...' : '이미지로 출력'}
          </Button>
        </Flex>

        {/* 로딩 상태 표시 */}
        {loading && (
          <Flex justify="center" align="center" style={{ flex: 1 }}>
            <Heading size="3" color="gray">스케줄 데이터 로딩 중...</Heading>
          </Flex>
        )}

        {/* 에러 상태 표시 */}
        {error && (
          <Flex justify="center" align="center" style={{ flex: 1 }}>
            <Heading size="3" color="red">{error}</Heading>
          </Flex>
        )}

        {/* 스케줄 내용 */}
        {!loading && !error && (
          <Tabs.Root value={selectedTab} onValueChange={setSelectedTab} style={{ flex: 1, display: 'flex', flexDirection: 'column', minHeight: 0 }}>
            <Tabs.List style={{ flexShrink: 0 }}>
              {tabs.map(tab => (
                <Tabs.Trigger key={tab.key} value={tab.key}>
                  {tab.label}
                </Tabs.Trigger>
              ))}
            </Tabs.List>
            
            <div style={{ flex: 1, minHeight: 0, overflow: 'hidden' }}>
              {selectedTab === 'schedule' && (
                <ScheduleGrid ref={scheduleGridRef} schedules={convertedApiSchedules} />
              )}

              {selectedTab === 'schedules' && (
                <ScheduleList schedules={convertedApiSchedules} />
              )}

              {selectedTab === 'monthly' && (
                <MonthlyStats schedules={convertedApiSchedules} />
              )}
            </div>
          </Tabs.Root>
        )}
      </Flex>
    </Card>
  );
} 