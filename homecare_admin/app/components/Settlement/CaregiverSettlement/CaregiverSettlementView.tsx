import { Flex, Text, Card } from '@radix-ui/themes';
import { useState } from 'react';
import CaregiverList from '../../Common/CaregiverList';
import SettlementDetails from '../History/SettlementDetails';
import { sampleCaregivers } from '../../../data/caregivers';
import {
  recentSettlementRecords,
  pendingSettlementRecords
} from '../../../data/settlements';

export default function CaregiverSettlementView() {
  const [selectedCaregiverId, setSelectedCaregiverId] = useState<string | null>(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedStatus, setSelectedStatus] = useState('전체');

  const handleCaregiverSelect = (caregiverId: string) => setSelectedCaregiverId(caregiverId);

  return (
    <Flex gap="6" style={{ flex: 1, minHeight: 0 }}>
      <CaregiverList
        searchTerm={searchTerm}
        selectedStatus={selectedStatus}
        multiSelectMode={false}
        selectedCaregiver={selectedCaregiverId}
        selectedCaregivers={[]}
        onSearchChange={setSearchTerm}
        onStatusChange={setSelectedStatus}
        onCaregiverSelect={handleCaregiverSelect}
      />
      {selectedCaregiverId ? (
        <Card style={{ flex: 3, display: 'flex', flexDirection: 'column' }}>
          <Flex direction="column" gap="4" p="4" style={{ flex: 1 }}>
            <Text size="4" weight="bold">
              {sampleCaregivers.find(c => c.caregiverId === selectedCaregiverId)?.name} 보호사 정산 내역
            </Text>
            <SettlementDetails
              records={[...recentSettlementRecords, ...pendingSettlementRecords].filter(
                record => record.caregiverName === sampleCaregivers.find(c => c.caregiverId === selectedCaregiverId)?.name
              )}
            />
          </Flex>
        </Card>
      ) : (
        <Card style={{ flex: 3, display: 'flex', flexDirection: 'column' }}>
          <Flex direction="column" gap="4" p="4" style={{ flex: 1 }}>
            <Flex justify="center" align="center" style={{ flex: 1 }}>
              <Text size="4" color="gray">보호사를 선택하여 정산 내역을 확인하세요</Text>
            </Flex>
          </Flex>
        </Card>
      )}
    </Flex>
  );
} 