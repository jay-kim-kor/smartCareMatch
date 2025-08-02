import { Flex } from '@radix-ui/themes';
import { useState } from 'react';
import PageHeader from '../Common/PageHeader';
import SettlementOverviewCard from './Overview/SettlementOverviewCard';
import PendingSettlementCard from './Overview/PendingSettlementCard';
import SettlementHistoryTable from './History/SettlementHistoryTable';
import SettlementDetails from './History/SettlementDetails';
import CaregiverSettlementView from './CaregiverSettlement/CaregiverSettlementView';
import {
  settlementOverviewData,
  pendingSettlementData,
  recentSettlementRecords,
  pendingSettlementRecords
} from '../../data/settlements';

export default function SettlementPage() {
  const [selectedTab, setSelectedTab] = useState('overview');

  const tabs = [
    { key: 'overview', label: '정산 현황' },
    { key: 'details', label: '정산 내역' },
    { key: 'caregiver-settlement', label: '요양보호사별 정산' },
  ];

  return (
    <Flex direction="column" gap="5" p="6" style={{ height: '100vh' }}>
      <PageHeader tabs={tabs} selectedTab={selectedTab} onTabChange={setSelectedTab} />
      
      {selectedTab === 'overview' && (
        <Flex direction="column" gap="6" style={{ flex: 1, minHeight: 0 }}>
          {/* 상단: 이번 달 총 정산 + 최근 정산 내역 */}
          <Flex gap="6" style={{ flex: 1 }}>
            <SettlementOverviewCard
              totalAmount={settlementOverviewData.totalAmount}
              previousMonthChange={settlementOverviewData.previousMonthChange}
              monthlyData={settlementOverviewData.monthlyData}
            />
            
            <SettlementHistoryTable 
              title="최근 정산 내역"
              records={recentSettlementRecords}
            />
          </Flex>

          {/* 하단: 미정산 건수 + 미정산 내역 */}
          <Flex gap="6" style={{ flex: 1 }}>
            <PendingSettlementCard
              pendingCount={pendingSettlementData.pendingCount}
              totalAmount={pendingSettlementData.totalAmount}
              weeklyData={pendingSettlementData.weeklyData}
            />
            
            <SettlementHistoryTable
              title="미정산 내역"
              records={pendingSettlementRecords}
            />
          </Flex>
        </Flex>
      )}

      {selectedTab === 'details' && (
        <SettlementDetails records={[...recentSettlementRecords, ...pendingSettlementRecords]} />
      )}

      {selectedTab === 'caregiver-settlement' && (
        <CaregiverSettlementView />
      )}
    </Flex>
  );
} 