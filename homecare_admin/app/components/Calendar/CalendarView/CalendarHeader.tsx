import { Flex, Button, Text, Popover, Select } from '@radix-ui/themes';
import { useState } from 'react';

interface CalendarHeaderProps {
  year: number;
  month: number;
  onPrev: () => void;
  onNext: () => void;
  onToday: () => void;
  onNavigateToDate: (year: number, month: number) => void;
}

export default function CalendarHeader({ 
  year, 
  month, 
  onPrev, 
  onNext, 
  onToday, 
  onNavigateToDate
}: CalendarHeaderProps) {
  const [isPopoverOpen, setIsPopoverOpen] = useState(false);
  const [selectedYear, setSelectedYear] = useState(year);
  const [selectedMonth, setSelectedMonth] = useState(month + 1);

  const handleNavigate = () => {
    onNavigateToDate(selectedYear, selectedMonth - 1);
    setIsPopoverOpen(false);
  };

  return (
    <Flex align="center" justify="between" mb="4" style={{ width: '100%' }}>
      {/* 왼쪽: 월/년 */}
      <Text size="5" weight="bold">{year}년 {month + 1}월</Text>
      
      {/* 오른쪽: 특정 연월로 이동하기 + 네비게이션 */}
      <Flex align="center" gap="4">
        <Popover.Root open={isPopoverOpen} onOpenChange={setIsPopoverOpen}>
          <Popover.Trigger>
            <Button variant="soft" size="2">
              특정 연월로 이동하기
            </Button>
          </Popover.Trigger>
          <Popover.Content>
            <Flex direction="column" gap="4">
              <Text size="3" weight="medium">연월 선택</Text>
              
              <Flex gap="2" align="center">
                <Select.Root value={selectedYear.toString()} onValueChange={(value) => setSelectedYear(parseInt(value))}>
                  <Select.Trigger style={{ width: 'auto' }} />
                  <Select.Content>
                    {Array.from({ length: 11 }, (_, i) => {
                      const yearValue = 2020 + i;
                      return (
                        <Select.Item key={yearValue} value={yearValue.toString()}>
                          {yearValue}년
                        </Select.Item>
                      );
                    })}
                  </Select.Content>
                </Select.Root>
                
                <Select.Root value={selectedMonth.toString()} onValueChange={(value) => setSelectedMonth(parseInt(value))}>
                  <Select.Trigger style={{ width: 'auto' }} />
                  <Select.Content>
                    {Array.from({ length: 12 }, (_, i) => {
                      const monthValue = i + 1;
                      return (
                        <Select.Item key={monthValue} value={monthValue.toString()}>
                          {monthValue}월
                        </Select.Item>
                      );
                    })}
                  </Select.Content>
                </Select.Root>
              </Flex>
              
              <Flex gap="2" justify="end">
                <Button 
                  size="2"
                  style={{ width: '100%' }}
                  onClick={handleNavigate}
                >
                  이동하기
                </Button>
              </Flex>
            </Flex>
          </Popover.Content>
        </Popover.Root>
        
        <Flex align="center" gap="2">
          <Button onClick={onPrev} variant="ghost" size="2">{'<'}</Button>
          <Button onClick={onToday} variant="soft" size="2">오늘</Button>
          <Button onClick={onNext} variant="ghost" size="2">{'>'}</Button>
        </Flex>
      </Flex>
    </Flex>
  );
} 