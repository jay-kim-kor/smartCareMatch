import { Card, Flex, Heading, Text, Table } from '@radix-ui/themes';
import { useState, useEffect } from 'react';
import { formatCurrency } from '../../utils/formatters';
import '../../styles/card.css';

export default function DashboardPage() {
  const [currentTime, setCurrentTime] = useState(new Date());

  useEffect(() => {
    const timer = setInterval(() => {
      setCurrentTime(new Date());
    }, 1000);

    return () => clearInterval(timer);
  }, []);

  const formatDate = (date: Date) => {
    return date.toLocaleDateString('ko-KR', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      weekday: 'long'
    });
  };

  const formatTime = (date: Date) => {
    return date.toLocaleTimeString('ko-KR', {
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit'
    });
  };

  return (
    <Flex direction="column" gap="6" p="6">
      {/* 상단: 날짜/시간 헤더 */}
      <Flex justify="between" align="center">
        <Heading size="5">{formatDate(currentTime)}</Heading>
        <Text size="4" weight="bold">{formatTime(currentTime)}</Text>
      </Flex>

      {/* 상단: 요양보호사 현황 + 정산 현황 */}
      <Flex gap="6">
        <Card className="dashboard-card" style={{ flex: 1 }}>
          <Heading size="4" mb="4">요양보호사 현황</Heading>
          <Flex gap="4" wrap="wrap" justify="center">
            <Flex direction="column" align="center" style={{ minWidth: 100 }}>
              <Text size="2" color="gray">전체</Text>
              <Heading size="6">52명</Heading>
            </Flex>
            <Flex direction="column" align="center" style={{ minWidth: 100 }}>
              <Text size="2" color="gray">활동 중</Text>
              <Heading size="6">41명</Heading>
            </Flex>
            <Flex direction="column" align="center" style={{ minWidth: 100 }}>
              <Text size="2" color="gray">휴직</Text>
              <Heading size="6">3명</Heading>
            </Flex>
            <Flex direction="column" align="center" style={{ minWidth: 100 }}>
              <Text size="2" color="gray">퇴사</Text>
              <Heading size="6">8명</Heading>
            </Flex>
            <Flex direction="column" align="center" style={{ minWidth: 100 }}>
              <Text size="2" color="gray">신규(월)</Text>
              <Heading size="6">2명</Heading>
            </Flex>
          </Flex>
        </Card>

        <Card className="dashboard-card" style={{ flex: 1 }}>
          <Heading size="4" mb="4">정산 현황</Heading>
          <Flex gap="6" wrap="wrap" justify="center">
            <Flex direction="column" align="center" style={{ minWidth: 150 }}>
              <Text size="2" color="gray">이번달 누적 정산</Text>
              <Heading size="6">{formatCurrency(12500000)}</Heading>
            </Flex>
            <Flex direction="column" align="center" style={{ minWidth: 150 }}>
              <Text size="2" color="gray">미정산 건수</Text>
              <Heading size="6">2건</Heading>
            </Flex>
            <Flex direction="column" align="center" style={{ minWidth: 150 }}>
              <Text size="2" color="gray">부정행위 알림</Text>
              <Heading size="6">1건</Heading>
            </Flex>
          </Flex>
        </Card>
      </Flex>

      {/* 중간: 근무 현황 + 알림 */}
      <Flex gap="6" style={{ minHeight: 300 }}>
        {/* 왼쪽: 근무 현황 */}
        <Card className="dashboard-card" style={{ flex: 1 }}>
          <Heading size="4" mb="4">근무 현황</Heading>
          <Flex direction="column" gap="4">
            {/* 오늘 근무자 - 클릭 가능한 카드 */}
            <Card 
              style={{ 
                cursor: 'pointer', 
                transition: 'all 0.2s ease'
              }}
              onMouseEnter={(e) => {
                e.currentTarget.style.backgroundColor = 'var(--accent-3)';
              }}
              onMouseLeave={(e) => {
                e.currentTarget.style.backgroundColor = 'transparent';
              }}
              onClick={() => console.log('오늘 근무자 클릭')}
            >
              <Flex justify="between" align="center" p="2">
                <Text size="3" weight="medium">오늘 근무자</Text>
                <Heading size="5">18명</Heading>
              </Flex>
            </Card>

            {/* 미배정 보호사 - 클릭 가능한 카드 */}
            <Card 
              style={{ 
                cursor: 'pointer', 
                transition: 'all 0.2s ease'
              }}
              onMouseEnter={(e) => {
                e.currentTarget.style.backgroundColor = 'var(--accent-3)';
              }}
              onMouseLeave={(e) => {
                e.currentTarget.style.backgroundColor = 'transparent';
              }}
              onClick={() => console.log('미배정 보호사 클릭')}
            >
              <Flex justify="between" align="center" p="2">
                <Text size="3" weight="medium">미배정 보호사</Text>
                <Heading size="5">4명</Heading>
              </Flex>
            </Card>

            {/* 신청자(배정 대기) - 클릭 가능한 카드 */}
            <Card 
              style={{ 
                cursor: 'pointer', 
                transition: 'all 0.2s ease'
              }}
              onMouseEnter={(e) => {
                e.currentTarget.style.backgroundColor = 'var(--accent-3)';
              }}
              onMouseLeave={(e) => {
                e.currentTarget.style.backgroundColor = 'transparent';
              }}
              onClick={() => console.log('신청자 클릭')}
            >
              <Flex justify="between" align="center" p="2">
                <Text size="3" weight="medium">신청자(배정 대기)</Text>
                <Heading size="5">3명</Heading>
              </Flex>
            </Card>
          </Flex>
          
          <Heading size="4" mb="3" mt="6">근무지별 분포</Heading>
          <Flex direction="column" gap="4">
            {/* 센터 */}
            <Flex justify="between" align="center">
              <Text size="3" weight="medium" style={{ minWidth: '60px' }}>센터</Text>
              <Flex align="center" gap="3" style={{ width: '220px' }}>
                <div style={{
                  width: '120px',
                  height: '12px',
                  backgroundColor: 'var(--gray-4)',
                  borderRadius: '6px',
                  overflow: 'hidden'
                }}>
                  <div style={{
                    width: '42%',
                    height: '100%',
                    backgroundColor: 'var(--blue-9)',
                    borderRadius: '6px'
                  }} />
                </div>
                <Text size="2" color="gray" style={{ minWidth: '90px', textAlign: 'right' }}>22명 (42%)</Text>
              </Flex>
            </Flex>

            {/* 재가 */}
            <Flex justify="between" align="center">
              <Text size="3" weight="medium" style={{ minWidth: '60px' }}>재가</Text>
              <Flex align="center" gap="3" style={{ width: '220px' }}>
                <div style={{
                  width: '120px',
                  height: '12px',
                  backgroundColor: 'var(--gray-4)',
                  borderRadius: '6px',
                  overflow: 'hidden'
                }}>
                  <div style={{
                    width: '48%',
                    height: '100%',
                    backgroundColor: 'var(--purple-9)',
                    borderRadius: '6px'
                  }} />
                </div>
                <Text size="2" color="gray" style={{ minWidth: '90px', textAlign: 'right' }}>25명 (48%)</Text>
              </Flex>
            </Flex>

            {/* 방문 */}
            <Flex justify="between" align="center">
              <Text size="3" weight="medium" style={{ minWidth: '60px' }}>방문</Text>
              <Flex align="center" gap="3" style={{ width: '220px' }}>
                <div style={{
                  width: '120px',
                  height: '12px',
                  backgroundColor: 'var(--gray-4)',
                  borderRadius: '6px',
                  overflow: 'hidden'
                }}>
                  <div style={{
                    width: '10%',
                    height: '100%',
                    backgroundColor: 'var(--orange-9)',
                    borderRadius: '6px'
                  }} />
                </div>
                <Text size="2" color="gray" style={{ minWidth: '90px', textAlign: 'right' }}>5명 (10%)</Text>
              </Flex>
            </Flex>
          </Flex>
        </Card>

        {/* 오른쪽: 최근 알림 */}
        <Card className="dashboard-card" style={{ flex: 1 }}>
          <Heading size="4" mb="4">최근 알림</Heading>
          <Table.Root>
            <Table.Header>
              <Table.Row>
                <Table.ColumnHeaderCell>시간</Table.ColumnHeaderCell>
                <Table.ColumnHeaderCell>내용</Table.ColumnHeaderCell>
              </Table.Row>
            </Table.Header>
            <Table.Body>
              <Table.Row>
                <Table.Cell>09:10</Table.Cell>
                <Table.Cell>신규 보호사 등록 승인 완료</Table.Cell>
              </Table.Row>
              <Table.Row>
                <Table.Cell>08:45</Table.Cell>
                <Table.Cell>근무지 배정 미완료 보호사 2명</Table.Cell>
              </Table.Row>
              <Table.Row>
                <Table.Cell>08:30</Table.Cell>
                <Table.Cell>부정행위(중복 근무) 감지</Table.Cell>
              </Table.Row>
              <Table.Row>
                <Table.Cell>08:15</Table.Cell>
                <Table.Cell>급여 정산 완료 - 김○○</Table.Cell>
              </Table.Row>
              <Table.Row>
                <Table.Cell>08:00</Table.Cell>
                <Table.Cell>근무 스케줄 변경 요청</Table.Cell>
              </Table.Row>
            </Table.Body>
          </Table.Root>
        </Card>
      </Flex>
    </Flex>
  );
} 