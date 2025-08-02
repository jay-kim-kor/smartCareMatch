import { Flex, Text } from '@radix-ui/themes';
import { useState } from 'react';
import { WorkSchedule } from '../../../data/schedules';

interface MonthlyStatsProps {
  schedules: WorkSchedule[];
}

export default function MonthlyStats({ schedules }: MonthlyStatsProps) {
  const [selectedMonth, setSelectedMonth] = useState(new Date().getMonth());
  const [selectedYear, setSelectedYear] = useState(new Date().getFullYear());

  // 선택된 월의 스케줄
  const monthlySchedules = schedules.filter(schedule => {
    const scheduleDate = new Date(schedule.date);
    return scheduleDate.getMonth() === selectedMonth && 
           scheduleDate.getFullYear() === selectedYear;
  });

  const calculateMonthlyStats = () => {
    const stats = {
      totalDays: monthlySchedules.length,
      completedDays: monthlySchedules.filter(s => s.status === '완료').length,
      totalHours: monthlySchedules.reduce((sum, s) => {
        const start = new Date(`2000-01-01T${s.startTime}`);
        const end = new Date(`2000-01-01T${s.endTime}`);
        return sum + (end.getTime() - start.getTime()) / (1000 * 60 * 60);
      }, 0),
      totalWage: monthlySchedules.reduce((sum, s) => sum + s.hourlyWage * 8, 0)
    };
    return stats;
  };

  const monthlyStats = calculateMonthlyStats();

  return (
    <Flex direction="column" gap="4" style={{ width: '100%' }}>
      <Flex direction="column" gap="4" style={{ marginTop: 16 }}>
        <Flex justify="between" align="center">
          <Text size="2" color="gray">선택 월</Text>
          <select
            value={`${selectedYear}-${selectedMonth}`}
            onChange={(e) => {
              const [year, month] = e.target.value.split('-');
              setSelectedYear(parseInt(year));
              setSelectedMonth(parseInt(month));
            }}
            style={{
              padding: '8px 12px',
              border: '1px solid var(--gray-6)',
              borderRadius: '6px',
              fontSize: '14px',
              backgroundColor: 'var(--gray-1)'
            }}
          >
            {Array.from({ length: 12 }, (_, i) => {
              const date = new Date(selectedYear, i);
              return (
                <option key={i} value={`${selectedYear}-${i}`}>
                  {date.toLocaleDateString('ko-KR', { month: 'long' })}
                </option>
              );
            })}
          </select>
        </Flex>
        
        <Flex direction="column" gap="3">
          <Flex justify="between" align="center" p="3" style={{ 
            backgroundColor: 'var(--gray-1)', 
            borderRadius: '6px' 
          }}>
            <Text size="2" color="gray">총 근무일</Text>
            <Text size="3" weight="medium">{monthlyStats.totalDays}일</Text>
          </Flex>
          <Flex justify="between" align="center" p="3" style={{ 
            backgroundColor: 'var(--gray-1)', 
            borderRadius: '6px' 
          }}>
            <Text size="2" color="gray">완료일</Text>
            <Text size="3" weight="medium">{monthlyStats.completedDays}일</Text>
          </Flex>
          <Flex justify="between" align="center" p="3" style={{ 
            backgroundColor: 'var(--gray-1)', 
            borderRadius: '6px' 
          }}>
            <Text size="2" color="gray">총 근무시간</Text>
            <Text size="3" weight="medium">{monthlyStats.totalHours.toFixed(1)}시간</Text>
          </Flex>
          <Flex justify="between" align="center" p="3" style={{ 
            backgroundColor: 'var(--accent-1)', 
            borderRadius: '6px' 
          }}>
            <Text size="2" color="gray">예상 급여</Text>
            <Text size="3" weight="medium" color="green">
              {monthlyStats.totalWage.toLocaleString()}원
            </Text>
          </Flex>
        </Flex>
      </Flex>
    </Flex>
  );
} 