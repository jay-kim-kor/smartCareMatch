import { Text, Badge, Table, ScrollArea, Button, Flex, Popover } from '@radix-ui/themes';
import { useState } from 'react';
import { WorkSchedule } from '../../../data/schedules';
import { WORK_TYPE_COLORS } from '../../../constants/workTypes';

interface ScheduleListProps {
  schedules: WorkSchedule[];
}

export default function ScheduleList({ schedules }: ScheduleListProps) {
  const [openPopover, setOpenPopover] = useState<string | null>(null);

  const getStatusColor = (status: string) => {
    switch (status) {
      case '완료': return 'green';
      case '배정됨': return 'blue';
      case '미배정': return 'orange';
      case '취소': return 'red';
      default: return 'gray';
    }
  };

  // 스케줄을 날짜순으로 정렬 (최신순)
  const sortedSchedules = [...schedules].sort((a, b) => {
    const dateA = new Date(a.date);
    const dateB = new Date(b.date);
    return dateB.getTime() - dateA.getTime(); // 최신 날짜가 먼저
  });

  return (
    <ScrollArea style={{ height: '100%' }}>
      <Table.Root>
        <Table.Header>
          <Table.Row>
            <Table.ColumnHeaderCell>날짜</Table.ColumnHeaderCell>
            <Table.ColumnHeaderCell>시간</Table.ColumnHeaderCell>
            <Table.ColumnHeaderCell>근무 유형</Table.ColumnHeaderCell>
            <Table.ColumnHeaderCell>대상자</Table.ColumnHeaderCell>
            <Table.ColumnHeaderCell>근무지</Table.ColumnHeaderCell>
            <Table.ColumnHeaderCell>시급</Table.ColumnHeaderCell>
            <Table.ColumnHeaderCell>상태</Table.ColumnHeaderCell>
            <Table.ColumnHeaderCell>특이사항</Table.ColumnHeaderCell>
          </Table.Row>
        </Table.Header>
        <Table.Body>
          {sortedSchedules.length === 0 ? (
            <Table.Row>
              <Table.Cell colSpan={8}>
                <Flex justify="center" align="center" p="4">
                  <Text size="2" color="gray">
                    스케줄이 없습니다.
                  </Text>
                </Flex>
              </Table.Cell>
            </Table.Row>
          ) : (
            sortedSchedules.map(schedule => (
              <Table.Row key={schedule.id}>
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
                  <Text size="2">{schedule.consumer}</Text>
                </Table.Cell>
                <Table.Cell>
                  <Text size="2" color="gray">{schedule.location}</Text>
                </Table.Cell>
                <Table.Cell>
                  <Text size="2">{schedule.hourlyWage.toLocaleString()}원</Text>
                </Table.Cell>
                <Table.Cell>
                  <Badge color={getStatusColor(schedule.status)} size="1">
                    {schedule.status}
                  </Badge>
                </Table.Cell>
                <Table.Cell>
                  {schedule.notes ? (
                    <Popover.Root open={openPopover === schedule.id} onOpenChange={(open) => setOpenPopover(open ? schedule.id : null)}>
                      <Popover.Trigger>
                        <Button 
                          variant="soft" 
                          size="1" 
                          color="blue"
                        >
                          보기
                        </Button>
                      </Popover.Trigger>
                      <Popover.Content>
                        <Flex direction="column" gap="3" style={{ maxWidth: '300px' }}>
                          <Flex justify="between" align="center">
                            <Text size="2" weight="medium">특이사항</Text>
                            <Button 
                              variant="ghost" 
                              size="1"
                              onClick={() => setOpenPopover(null)}
                            >
                              ✕
                            </Button>
                          </Flex>
                          <Text size="2" style={{ lineHeight: '1.6' }}>
                            {schedule.notes}
                          </Text>
                        </Flex>
                      </Popover.Content>
                    </Popover.Root>
                  ) : (
                    <Text size="2" color="gray">-</Text>
                  )}
                </Table.Cell>
              </Table.Row>
            ))
          )}
        </Table.Body>
      </Table.Root>
    </ScrollArea>
  );
} 