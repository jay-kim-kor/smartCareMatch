import { Flex, Heading, Text, Card, Tooltip } from '@radix-ui/themes';
import { formatCurrency } from '../../../utils/formatters';

interface SettlementOverviewCardProps {
  totalAmount: number;
  previousMonthChange: number;
  monthlyData: number[];
}

export default function SettlementOverviewCard({ 
  totalAmount, 
  previousMonthChange, 
  monthlyData 
}: SettlementOverviewCardProps) {
  const formatChange = (change: number) => {
    const sign = change >= 0 ? '+' : '';
    return `${sign}${change}%`;
  };

    return (
    <Card style={{ width: '280px', padding: '20px', display: 'flex', flexDirection: 'column', height: '100%' }}>
      <Text size="2" color="gray" weight="medium">이번 달 총 정산</Text>
      <Heading size="5" style={{ color: 'var(--green-9)', marginTop: '8px' }}>
        {formatCurrency(totalAmount)}
      </Heading>
      <Text size="2" color="gray" style={{ marginTop: '4px' }}>
        전월 대비 {formatChange(previousMonthChange)}
      </Text>
      
      {/* 최근 6개월 정산 금액 그래프 */}
      <div style={{ marginTop: '16px', flex: 1, display: 'flex', flexDirection: 'column' }}>
                <Text size="1" color="gray" weight="medium" mb="2">최근 6개월</Text>
                <Flex gap="1" align="end" style={{ flex: 1, minHeight: '80px' }}>
          {monthlyData.map((amount, index) => {
            const monthNames = ['2월', '3월', '4월', '5월', '6월', '7월'];
            return (
              <Tooltip key={index} content={`${monthNames[index]}, ${formatCurrency(amount)}`}>
                <div
                  style={{
                    flex: 1,
                    height: `${(amount / Math.max(...monthlyData)) * 100}%`,
                    backgroundColor: index === monthlyData.length - 1 ? 'var(--green-9)' : 'var(--gray-6)',
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
          <Text size="1" color="gray">2월</Text>
          <Text size="1" color="gray">7월</Text>
        </Flex>
      </div>
    </Card>
  );
} 