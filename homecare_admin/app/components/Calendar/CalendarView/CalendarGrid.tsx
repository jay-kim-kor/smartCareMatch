import { Card, Flex, Text } from '@radix-ui/themes';
import { useState, useEffect } from 'react';
import { groupSchedulesByDate } from '../../../utils/scheduleUtils';
import { WORK_TYPES, WorkType } from '../../../constants/workTypes';
import { getScheduleByDate, WorkMatch } from '../../../api';

function getDaysArray(year: number, month: number) {
  const firstDay = new Date(year, month, 1).getDay();
  const lastDate = new Date(year, month + 1, 0).getDate();
  const days = [];
  for (let i = 0; i < firstDay; i++) days.push(null);
  for (let d = 1; d <= lastDate; d++) days.push(d);
  while (days.length % 7 !== 0) days.push(null);
  return days;
}

// 날짜를 YYYY-MM-DD 형식으로 변환
function formatDate(year: number, month: number, day: number): string {
  const monthStr = (month + 1).toString().padStart(2, '0');
  const dayStr = day.toString().padStart(2, '0');
  return `${year}-${monthStr}-${dayStr}`;
}

// 근무 유형별 색상 반환
function getWorkTypeColor(workType: WorkType) {
  const colorMap: Record<WorkType, string> = {
    [WORK_TYPES.VISITING_CARE]: 'var(--blue-9)',
    [WORK_TYPES.DAY_NIGHT_CARE]: 'var(--purple-9)',
    [WORK_TYPES.RESPITE_CARE]: 'var(--green-9)',
    [WORK_TYPES.VISITING_BATH]: 'var(--orange-9)',
    [WORK_TYPES.IN_HOME_SUPPORT]: 'var(--yellow-9)',
    [WORK_TYPES.VISITING_NURSING]: 'var(--red-9)'
  };
  return colorMap[workType] || 'var(--gray-9)';
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
    workType: workMatch.serviceType.length > 0 ? mapServiceTypeToWorkType(workMatch.serviceType[0]) : '방문요양', // 첫 번째 서비스 타입 사용
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

export default function CalendarGrid({ 
  year, 
  month, 
  workTypeFilters = { 
    [WORK_TYPES.VISITING_CARE]: true,
    [WORK_TYPES.DAY_NIGHT_CARE]: true,
    [WORK_TYPES.RESPITE_CARE]: true,
    [WORK_TYPES.VISITING_BATH]: true,
    [WORK_TYPES.IN_HOME_SUPPORT]: true,
    [WORK_TYPES.VISITING_NURSING]: true
  },
  onDateClick
}: { 
  year: number; 
  month: number; 
  workTypeFilters?: Record<WorkType, boolean>;
  onDateClick?: (date: string) => void;
}) {
  const [apiSchedules, setApiSchedules] = useState<WorkMatch[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // API에서 스케줄 데이터 가져오기
  useEffect(() => {
    const fetchSchedules = async () => {
      setLoading(true);
      setError(null);
      try {
        const data = await getScheduleByDate(year, month);
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
  }, [year, month]);

  const days = getDaysArray(year, month);
  const weekCount = days.length / 7;
  
  // 오늘 날짜 확인
  const today = new Date();
  const isCurrentMonth = year === today.getFullYear() && month === today.getMonth();
  
  // API 데이터를 기존 형식으로 변환
  const convertedApiSchedules = convertApiDataToSchedules(apiSchedules);
  
  // 해당 월의 스케줄만 필터링
  const monthSchedules = convertedApiSchedules.filter(schedule => {
    const scheduleDate = new Date(schedule.date);
    return scheduleDate.getFullYear() === year && scheduleDate.getMonth() === month;
  });

  // 근무 유형별 필터링
  const filteredSchedules = monthSchedules.filter(schedule => {
    return workTypeFilters[schedule.workType] || false;
  });

  // 날짜별로 스케줄 그룹화
  const schedulesByDate = groupSchedulesByDate(filteredSchedules);

  return (
    <Card style={{ background: 'var(--gray-2)', flex: 1, height: '100%', padding: 0, overflow: 'hidden' }}>
      <div style={{ padding: 24, height: '100%', boxSizing: 'border-box', display: 'flex', flexDirection: 'column' }}>
        <Flex gap="2" mb="2">
          {['일', '월', '화', '수', '목', '금', '토'].map(d => (
            <Text key={d} size="3" style={{ flex: 1, textAlign: 'center' }}>{d}</Text>
          ))}
        </Flex>
        
        {/* 로딩 상태 표시 */}
        {loading && (
          <div style={{ 
            display: 'flex', 
            justifyContent: 'center', 
            alignItems: 'center', 
            height: '100%',
            fontSize: '14px',
            color: 'var(--gray-11)'
          }}>
            스케줄 로딩 중...
          </div>
        )}
        
        {/* 에러 상태 표시 */}
        {error && (
          <div style={{ 
            display: 'flex', 
            justifyContent: 'center', 
            alignItems: 'center', 
            height: '100%',
            fontSize: '14px',
            color: 'var(--red-9)'
          }}>
            {error}
          </div>
        )}
        
        {/* 캘린더 그리드 */}
        {!loading && !error && (
          <div
            style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(7, 1fr)',
              gridTemplateRows: `repeat(${weekCount}, 1fr)`,
              gap: 8,
              flex: 1,
              height: '100%',
              boxSizing: 'border-box',
              minHeight: 0,
              minWidth: 0,
              overflow: 'hidden',
            }}
          >
            {days.map((d, i) => {
              const dateStr = d ? formatDate(year, month, d) : '';
              const daySchedules = d ? schedulesByDate[dateStr] || [] : [];
              const isToday = d && isCurrentMonth && d === today.getDate();
              
              return (
                <Card
                  key={i}
                  style={{
                    width: '100%',
                    height: '100%',
                    minHeight: 0,
                    minWidth: 0,
                    boxSizing: 'border-box',
                    overflow: 'hidden',
                    background: d ? (isToday ? 'var(--accent-4)' : 'var(--gray-4)') : 'transparent',
                    color: d ? 'var(--gray-12)' : 'transparent',
                    position: 'relative',
                    display: 'flex',
                    flexDirection: 'column',
                    alignItems: 'flex-start',
                    justifyContent: 'flex-start',
                    padding: 8,
                    cursor: d ? 'pointer' : 'default',
                    transition: 'all 0.2s ease',
                  }}
                  onMouseEnter={(e) => {
                    if (d) {
                      e.currentTarget.style.backgroundColor = 'var(--accent-3)';
                    }
                  }}
                  onMouseLeave={(e) => {
                    if (d) {
                      e.currentTarget.style.backgroundColor = isToday ? 'var(--accent-4)' : 'var(--gray-4)';
                    }
                  }}
                  onClick={() => {
                    if (d && onDateClick) {
                      const dateStr = formatDate(year, month, d);
                      onDateClick(dateStr);
                    }
                  }}
                >
                  {d && (
                    <>
                      <Text 
                        size="4" 
                        weight="bold" 
                        style={{ 
                          marginBottom: 4,
                          color: isToday ? 'var(--accent-11)' : 'var(--gray-12)',
                          fontWeight: 600
                        }}
                      >
                        {d}
                      </Text>
                      
                      {/* 근무 현황 요약 */}
                      {daySchedules.length > 0 && (
                        <Flex direction="column" gap="1" style={{ width: '100%' }}>
                          <Text size="1" color="gray" style={{ marginBottom: 2 }}>
                            근무: {daySchedules.length}명
                          </Text>
                          
                          {/* 근무 유형별 인원수 계산 */}
                          {(() => {
                            const workTypeCounts = daySchedules.reduce((acc, schedule) => {
                              acc[schedule.workType] = (acc[schedule.workType] || 0) + 1;
                              return acc;
                            }, {} as Record<string, number>);
                            
                            const workTypes = Object.values(WORK_TYPES);
                            return (
                              <Flex gap="1" wrap="wrap">
                                {workTypes.map(workType => {
                                  const count = workTypeCounts[workType] || 0;
                                  if (count === 0) return null;
                                  
                                  return (
                                    <div
                                      key={workType}
                                      style={{
                                        display: 'flex',
                                        alignItems: 'center',
                                        justifyContent: 'center',
                                        background: getWorkTypeColor(workType),
                                        color: 'white',
                                        borderRadius: '50%',
                                        width: '18px',
                                        height: '18px',
                                        fontSize: 12,
                                        fontWeight: 'bold',
                                      }}
                                      title={`${workType}: ${count}명`}
                                    >
                                      {count}
                                    </div>
                                  );
                                }).filter(Boolean)}
                              </Flex>
                            );
                          })()}
                        </Flex>
                      )}
                    </>
                  )}
                </Card>
              );
            })}
          </div>
        )}
      </div>
    </Card>
  );
} 