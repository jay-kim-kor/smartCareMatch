import { Flex, Card, Text, Badge, Table, ScrollArea, Button, Select } from '@radix-ui/themes';
import { useState } from 'react';
import { formatCurrency } from '../../../utils/formatters';

interface SettlementRecord {
  id: string;
  caregiverName: string;
  workDate: string;
  workHours: string;
  amount: number;
  status: 'completed' | 'pending' | 'rejected';
  action: string;
}

interface SettlementDetailsProps {
  records: SettlementRecord[];
}

export default function SettlementDetails({ records }: SettlementDetailsProps) {
  const [selectedStatus, setSelectedStatus] = useState('all');
  const [selectedMonth, setSelectedMonth] = useState('all');
  const [searchTerm, setSearchTerm] = useState('');

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'completed': return 'green';
      case 'pending': return 'yellow';
      case 'rejected': return 'red';
      default: return 'gray';
    }
  };

  const getStatusText = (status: string) => {
    switch (status) {
      case 'completed': return '완료';
      case 'pending': return '대기';
      case 'rejected': return '반려';
      default: return '알 수 없음';
    }
  };

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('ko-KR');
  };

  // 필터링된 데이터
  const filteredRecords = records.filter(record => {
    const matchesStatus = selectedStatus === 'all' || record.status === selectedStatus;
    const matchesMonth = selectedMonth === 'all' || 
                        new Date(record.workDate).getMonth() === parseInt(selectedMonth);
    const matchesSearch = searchTerm === '' || 
                         record.caregiverName.includes(searchTerm);
    
    return matchesStatus && matchesMonth && matchesSearch;
  });

  // 통계 계산
  const totalAmount = filteredRecords.reduce((sum, record) => sum + record.amount, 0);
  const completedCount = filteredRecords.filter(r => r.status === 'completed').length;
  const pendingCount = filteredRecords.filter(r => r.status === 'pending').length;
  const rejectedCount = filteredRecords.filter(r => r.status === 'rejected').length;

  return (
    <Flex direction="column" gap="4" style={{ flex: 1, minHeight: 0 }}>
      {/* 상단 통계 */}
      <Flex gap="6" align="center" wrap="wrap">
        <Flex direction="column" gap="1">
          <Text size="2" color="gray">총 정산 금액</Text>
          <Text size="4" weight="bold">{formatCurrency(totalAmount)}</Text>
        </Flex>
        <Flex direction="column" gap="1">
          <Text size="2" color="gray">완료</Text>
          <Text size="4" weight="bold" color="green">{completedCount}건</Text>
        </Flex>
        <Flex direction="column" gap="1">
          <Text size="2" color="gray">대기</Text>
          <Text size="4" weight="bold" color="yellow">{pendingCount}건</Text>
        </Flex>
        <Flex direction="column" gap="1">
          <Text size="2" color="gray">반려</Text>
          <Text size="4" weight="bold" color="red">{rejectedCount}건</Text>
        </Flex>
      </Flex>

      {/* 필터 및 검색 */}
      <Card style={{ padding: '16px' }}>
        <Flex gap="4" align="end">
          <Flex direction="column" gap="2">
            <Text size="2" weight="medium">상태</Text>
            <Select.Root value={selectedStatus} onValueChange={setSelectedStatus}>
              <Select.Trigger />
              <Select.Content>
                <Select.Item value="all">전체</Select.Item>
                <Select.Item value="completed">완료</Select.Item>
                <Select.Item value="pending">대기</Select.Item>
                <Select.Item value="rejected">반려</Select.Item>
              </Select.Content>
            </Select.Root>
          </Flex>

          <Flex direction="column" gap="2">
            <Text size="2" weight="medium">월</Text>
            <Select.Root value={selectedMonth} onValueChange={setSelectedMonth}>
              <Select.Trigger />
              <Select.Content>
                <Select.Item value="all">전체</Select.Item>
                {Array.from({ length: 12 }, (_, i) => {
                  const date = new Date(2025, i);
                  return (
                    <Select.Item key={i} value={i.toString()}>
                      {date.toLocaleDateString('ko-KR', { month: 'long' })}
                    </Select.Item>
                  );
                })}
              </Select.Content>
            </Select.Root>
          </Flex>

          <Flex direction="column" gap="2" style={{ flex: 1 }}>
            <Text size="2" weight="medium">검색</Text>
            <input
              type="text"
              placeholder="보호사명 또는 근무 유형으로 검색"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
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

          <Button variant="soft" size="2">
            엑셀 다운로드
          </Button>
        </Flex>
      </Card>

      {/* 정산 내역 테이블 */}
      <Card style={{ flex: 1, minHeight: 0 }}>
        <ScrollArea style={{ height: '100%' }}>
          <Table.Root>
            <Table.Header>
              <Table.Row>
                <Table.ColumnHeaderCell>보호사명</Table.ColumnHeaderCell>
                <Table.ColumnHeaderCell>근무일</Table.ColumnHeaderCell>
                <Table.ColumnHeaderCell>근무시간</Table.ColumnHeaderCell>
                <Table.ColumnHeaderCell>정산금액</Table.ColumnHeaderCell>
                <Table.ColumnHeaderCell>상태</Table.ColumnHeaderCell>
                <Table.ColumnHeaderCell>작업</Table.ColumnHeaderCell>
              </Table.Row>
            </Table.Header>
            <Table.Body>
              {filteredRecords.map(record => (
                <Table.Row key={record.id}>
                  <Table.Cell>
                    <Text size="2" weight="medium">{record.caregiverName}</Text>
                  </Table.Cell>
                  <Table.Cell>
                    <Text size="2">{formatDate(record.workDate)}</Text>
                  </Table.Cell>
                  <Table.Cell>
                    <Text size="2">{record.workHours}</Text>
                  </Table.Cell>
                  <Table.Cell>
                    <Text size="2" weight="medium">{formatCurrency(record.amount)}</Text>
                  </Table.Cell>
                  <Table.Cell>
                    <Badge color={getStatusColor(record.status)} size="1">
                      {getStatusText(record.status)}
                    </Badge>
                  </Table.Cell>
                  <Table.Cell>
                    <Button variant="soft" size="1">
                      {record.action}
                    </Button>
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table.Body>
          </Table.Root>
        </ScrollArea>
      </Card>
    </Flex>
  );
} 