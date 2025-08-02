import { Heading, Card, Table, ScrollArea, Badge, Button } from '@radix-ui/themes';
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

interface SettlementHistoryTableProps {
  title: string;
  records: SettlementRecord[];
}

export default function SettlementHistoryTable({ title, records }: SettlementHistoryTableProps) {
  const getStatusColor = (status: string) => {
    switch (status) {
      case 'completed': return 'green';
      case 'pending': return 'orange';
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

  return (
    <Card style={{ flex: 1, padding: '20px' }}>
      <Heading size="4" mb="4">{title}</Heading>
      <ScrollArea style={{ height: '200px' }}>
        <Table.Root>
          <Table.Header>
            <Table.Row>
              <Table.ColumnHeaderCell>보호사명</Table.ColumnHeaderCell>
              <Table.ColumnHeaderCell>근무 기간</Table.ColumnHeaderCell>
              <Table.ColumnHeaderCell>근무 시간</Table.ColumnHeaderCell>
              <Table.ColumnHeaderCell>정산 금액</Table.ColumnHeaderCell>
              <Table.ColumnHeaderCell>상태</Table.ColumnHeaderCell>
              <Table.ColumnHeaderCell>작업</Table.ColumnHeaderCell>
            </Table.Row>
          </Table.Header>
          <Table.Body>
            {records.map(record => (
              <Table.Row key={record.id}>
                <Table.Cell>{record.caregiverName}</Table.Cell>
                <Table.Cell>{record.workDate}</Table.Cell>
                <Table.Cell>{record.workHours}</Table.Cell>
                <Table.Cell>{formatCurrency(record.amount)}</Table.Cell>
                <Table.Cell>
                  <Badge color={getStatusColor(record.status)} size="1">
                    {getStatusText(record.status)}
                  </Badge>
                </Table.Cell>
                <Table.Cell>
                  <Button variant="soft" size="1">{record.action}</Button>
                </Table.Cell>
              </Table.Row>
            ))}
          </Table.Body>
        </Table.Root>
      </ScrollArea>
    </Card>
  );
} 