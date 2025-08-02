import { Flex, Heading, Text, Card, Tooltip } from '@radix-ui/themes';
import { formatCurrency } from '../../../utils/formatters';

interface PendingSettlementCardProps {
  pendingCount: number;
  totalAmount: number;
  weeklyData: number[];
}

export default function PendingSettlementCard({ 
  pendingCount, 
  totalAmount, 
  weeklyData 
}: PendingSettlementCardProps) {
    return (
    <Card style={{ width: '280px', padding: '20px', display: 'flex', flexDirection: 'column', height: '100%' }}>
      <Text size="2" color="gray" weight="medium">미정산 건수</Text>
      <Heading size="5" style={{ color: 'var(--orange-9)', marginTop: '8px' }}>
        {pendingCount}건
      </Heading>
      <Text size="2" color="gray" style={{ marginTop: '4px' }}>
        총 {formatCurrency(totalAmount)}
      </Text>
      
      {/* 최근 7일 미정산 건수 그래프 */}
      <div style={{ marginTop: '16px', flex: 1, display: 'flex', flexDirection: 'column' }}>
                <Text size="1" color="gray" weight="medium" mb="2">최근 7일</Text>
                <Flex gap="1" align="end" style={{ flex: 1, minHeight: '80px' }}>
          {weeklyData.map((count, index) => {
            const daysAgo = weeklyData.length - 1 - index;
            const timeText = daysAgo === 0 ? '오늘' : `${daysAgo}일 전`;
            return (
              <Tooltip key={index} content={`${timeText}, ${count}건`}>
                <div
                  style={{
                    flex: 1,
                    height: `${(count / Math.max(...weeklyData, 1)) * 100}%`,
                    backgroundColor: index === weeklyData.length - 1 ? 'var(--orange-9)' : 'var(--gray-6)',
                    borderRadius: '2px',
                    minHeight: '4px',
                    cursor: 'pointer'
                  }}
                />
              </Tooltip>
            );
          })}
        </Flex>
        <Flex justify="between" mt="2">
          <Text size="1" color="gray">월</Text>
          <Text size="1" color="gray">일</Text>
        </Flex>
      </div>
    </Card>
  );
} 