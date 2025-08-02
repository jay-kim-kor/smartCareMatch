import { Flex, Text, Button, Badge, Table, ScrollArea } from '@radix-ui/themes';
import { sampleRegistrationRecords } from '../../../data/registrations';

interface RequestManagementTableProps {
  selectedTab: string;
}

export default function RequestManagementTable({ selectedTab }: RequestManagementTableProps) {
  const getStatusColor = (status: string) => {
    switch (status) {
      case 'approved': return 'green';
      case 'rejected': return 'red';
      case 'pending': return 'orange';
      default: return 'gray';
    }
  };

  const getStatusText = (status: string) => {
    switch (status) {
      case 'approved': return '승인';
      case 'rejected': return '반려';
      case 'pending': return '대기';
      default: return '알 수 없음';
    }
  };

  const getRequestTypeText = (type: string) => {
    switch (type) {
      case 'registration': return '등록';
      case 'deletion': return '말소';
      default: return '알 수 없음';
    }
  };

  const getRequestTypeColor = (type: string) => {
    switch (type) {
      case 'registration': return 'blue';
      case 'deletion': return 'red';
      default: return 'gray';
    }
  };

  const filteredRecords = sampleRegistrationRecords.filter(record => {
    if (selectedTab === 'pending') return record.status === 'pending';
    if (selectedTab === 'approved') return record.status === 'approved';
    if (selectedTab === 'rejected') return record.status === 'rejected';
    return true;
  });

  const handleApprove = (id: string) => {
    console.log('승인:', id);
  };

  const handleReject = (id: string) => {
    console.log('반려:', id);
  };

  return (
    <ScrollArea style={{ height: '400px', marginTop: '16px' }}>
      <Table.Root>
        <Table.Header>
          <Table.Row>
            <Table.ColumnHeaderCell>보호사명</Table.ColumnHeaderCell>
            <Table.ColumnHeaderCell>전화번호</Table.ColumnHeaderCell>
            <Table.ColumnHeaderCell>요청 유형</Table.ColumnHeaderCell>
            <Table.ColumnHeaderCell>요청 일자</Table.ColumnHeaderCell>
            <Table.ColumnHeaderCell>상태</Table.ColumnHeaderCell>
            <Table.ColumnHeaderCell>사유</Table.ColumnHeaderCell>
            <Table.ColumnHeaderCell>작업</Table.ColumnHeaderCell>
          </Table.Row>
        </Table.Header>
        <Table.Body>
          {filteredRecords.map(record => (
            <Table.Row key={record.id}>
              <Table.Cell>
                <Text weight="medium">{record.caregiverName}</Text>
              </Table.Cell>
              <Table.Cell>
                <Text size="2" color="gray">{record.phone}</Text>
              </Table.Cell>
              <Table.Cell>
                <Badge color={getRequestTypeColor(record.requestType)} size="1">
                  {getRequestTypeText(record.requestType)}
                </Badge>
              </Table.Cell>
              <Table.Cell>
                <Text size="2">{record.requestDate}</Text>
              </Table.Cell>
              <Table.Cell>
                <Badge color={getStatusColor(record.status)} size="1">
                  {getStatusText(record.status)}
                </Badge>
              </Table.Cell>
              <Table.Cell>
                <Text size="2" color="gray">{record.reason}</Text>
              </Table.Cell>
              <Table.Cell>
                {record.status === 'pending' ? (
                  <Flex gap="2">
                    <Button 
                      variant="soft" 
                      size="1" 
                      color="green"
                      onClick={() => handleApprove(record.id)}
                    >
                      승인
                    </Button>
                    <Button 
                      variant="soft" 
                      size="1" 
                      color="red"
                      onClick={() => handleReject(record.id)}
                    >
                      반려
                    </Button>
                  </Flex>
                ) : (
                  <Text size="2" color="gray">-</Text>
                )}
              </Table.Cell>
            </Table.Row>
          ))}
        </Table.Body>
      </Table.Root>
    </ScrollArea>
  );
} 