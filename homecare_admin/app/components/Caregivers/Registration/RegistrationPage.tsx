import { Flex, Heading, Tabs } from '@radix-ui/themes';
import { useState } from 'react';
import RequestManagementTable from './RequestManagementTable';
import DirectRegistrationForm from './DirectRegistrationForm';
import DirectDeletionForm from './DirectDeletionForm';
import { sampleRegistrationRecords } from '../../../data/registrations';

export default function RegistrationPage() {
  const [selectedTab, setSelectedTab] = useState('pending');

  const getTabCount = (tab: string) => {
    switch (tab) {
      case 'pending': return sampleRegistrationRecords.filter(r => r.status === 'pending').length;
      case 'approved': return sampleRegistrationRecords.filter(r => r.status === 'approved').length;
      case 'rejected': return sampleRegistrationRecords.filter(r => r.status === 'rejected').length;
      default: return 0;
    }
  };

  const handleDirectRegistrationSubmit = (data: {
    name: string;
    phone: string;
    birthDate: string;
    email: string;
    address: string;
  }) => {
    console.log('직권 등록:', data);
  };

  const handleDirectDeletionSubmit = (data: { caregiverId: number; reason: string }) => {
    console.log('직권 말소:', data);
  };

  return (
    <Flex direction="column" gap="5" style={{ height: '100vh' }}>
        <Heading size="4" mb="4">등록/말소 요청 관리</Heading>
        
        <Tabs.Root value={selectedTab} onValueChange={setSelectedTab}>
          <Tabs.List>
            <Tabs.Trigger value="pending">대기 중 ({getTabCount('pending')})</Tabs.Trigger>
            <Tabs.Trigger value="approved">승인됨 ({getTabCount('approved')})</Tabs.Trigger>
            <Tabs.Trigger value="rejected">반려됨 ({getTabCount('rejected')})</Tabs.Trigger>
            <Tabs.Trigger value="direct-registration">직권 등록</Tabs.Trigger>
            <Tabs.Trigger value="direct-deletion">직권 말소</Tabs.Trigger>
          </Tabs.List>
        </Tabs.Root>

      {/* 등록/말소 요청 관리 */}
      <Flex direction="column" style={{ flex: 1 }}>
        {selectedTab === 'direct-registration' ? (
          <DirectRegistrationForm onSubmit={handleDirectRegistrationSubmit} />
        ) : selectedTab === 'direct-deletion' ? (
          <DirectDeletionForm onSubmit={handleDirectDeletionSubmit} />
        ) : (
          <RequestManagementTable selectedTab={selectedTab} />
        )}
      </Flex>
    </Flex>
  );
} 