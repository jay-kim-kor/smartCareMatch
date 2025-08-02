import { Card, Heading, Table } from '@radix-ui/themes';

export default function RecentActivityTable() {
  return (
    <Card mt="6">
      <Heading size="4" mb="4">최근 활동</Heading>
      <Table.Root>
        <Table.Header>
          <Table.Row>
            <Table.ColumnHeaderCell>시간</Table.ColumnHeaderCell>
            <Table.ColumnHeaderCell>유형</Table.ColumnHeaderCell>
            <Table.ColumnHeaderCell>내용</Table.ColumnHeaderCell>
          </Table.Row>
        </Table.Header>
        <Table.Body>
          <Table.Row>
            <Table.Cell>10:01</Table.Cell>
            <Table.Cell>로그인</Table.Cell>
            <Table.Cell>관리자 계정 로그인</Table.Cell>
          </Table.Row>
          <Table.Row>
            <Table.Cell>09:45</Table.Cell>
            <Table.Cell>수정</Table.Cell>
            <Table.Cell>상품 정보 수정</Table.Cell>
          </Table.Row>
          <Table.Row>
            <Table.Cell>09:30</Table.Cell>
            <Table.Cell>등록</Table.Cell>
            <Table.Cell>신규 사용자 등록</Table.Cell>
          </Table.Row>
        </Table.Body>
      </Table.Root>
    </Card>
  );
} 