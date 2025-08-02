import { Card, Flex, Heading, Text } from '@radix-ui/themes';

export default function StatsCards() {
  return (
    <Flex gap="4" wrap="wrap">
      <Card style={{ minWidth: 200 }}>
        <Text size="2" color="gray">총 사용자</Text>
        <Heading size="5">1,234명</Heading>
      </Card>
      <Card style={{ minWidth: 200 }}>
        <Text size="2" color="gray">오늘 매출</Text>
        <Heading size="5">₩2,500,000</Heading>
      </Card>
      <Card style={{ minWidth: 200 }}>
        <Text size="2" color="gray">알림</Text>
        <Heading size="5">5건</Heading>
      </Card>
    </Flex>
  );
} 