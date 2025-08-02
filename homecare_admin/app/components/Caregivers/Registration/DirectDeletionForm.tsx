import { Flex, Heading, Text, Card, Button, TextArea } from '@radix-ui/themes';
import { useState } from 'react';
import { sampleCaregivers } from '../../../data/caregivers';
import CaregiverSelectionList from '../../Common/CaregiverSelectionList';

interface DirectDeletionFormProps {
  onSubmit: (data: { caregiverId: string; reason: string }) => void;
}

export default function DirectDeletionForm({ onSubmit }: DirectDeletionFormProps) {
  const [deletionStep, setDeletionStep] = useState<'select' | 'reason' | 'confirm'>('select');
  const [selectedCaregiverForDeletion, setSelectedCaregiverForDeletion] = useState<string | null>(null);
  const [deletionReason, setDeletionReason] = useState('');
  const [deletionSearchTerm, setDeletionSearchTerm] = useState('');
  const [deletionSelectedStatus, setDeletionSelectedStatus] = useState('전체');

  const handleSubmit = () => {
    if (!selectedCaregiverForDeletion) return;
    
    onSubmit({
      caregiverId: selectedCaregiverForDeletion,
      reason: deletionReason
    });
    
    // 폼 초기화
    setSelectedCaregiverForDeletion(null);
    setDeletionReason('');
    setDeletionStep('select');
  };

  return (
    <Flex gap="6" style={{ marginTop: '16px' }}>
      {/* 좌측: 단계별 폼 */}
      <Card style={{ flex: 1, padding: '20px' }}>
        <Heading size="3" mb="4">직권 말소</Heading>
        
        {/* 단계 표시 */}
        <Flex gap="2" mb="4">
          <Button 
            variant={deletionStep === 'select' ? 'solid' : 'soft'} 
            size="1"
            onClick={() => setDeletionStep('select')}
          >
            1. 보호사 선택
          </Button>
          <Button 
            variant={deletionStep === 'reason' ? 'solid' : 'soft'} 
            size="1"
            onClick={() => setDeletionStep('reason')}
            disabled={!selectedCaregiverForDeletion}
          >
            2. 사유 작성
          </Button>
          <Button 
            variant={deletionStep === 'confirm' ? 'solid' : 'soft'} 
            size="1"
            onClick={() => setDeletionStep('confirm')}
            disabled={!selectedCaregiverForDeletion || !deletionReason}
          >
            3. 말소 확정
          </Button>
        </Flex>

        {/* 단계별 내용 */}
        {deletionStep === 'select' && (
          <Flex direction="column" gap="4">
            <CaregiverSelectionList
              searchTerm={deletionSearchTerm}
              selectedStatus={deletionSelectedStatus}
              selectedCaregiver={selectedCaregiverForDeletion}
              onSearchChange={setDeletionSearchTerm}
              onStatusChange={setDeletionSelectedStatus}
              onCaregiverSelect={setSelectedCaregiverForDeletion}
            />

            {selectedCaregiverForDeletion && (
              <Button 
                onClick={() => setDeletionStep('reason')}
                style={{ marginTop: '8px' }}
              >
                다음 단계
              </Button>
            )}
          </Flex>
        )}

        {deletionStep === 'reason' && (
          <Flex direction="column" gap="4">
            <Text size="2" weight="medium">말소 사유 작성</Text>
            
            {selectedCaregiverForDeletion && (
              <Card style={{ padding: '12px', backgroundColor: 'var(--blue-2)' }}>
                <Text size="2" weight="medium">
                  선택된 보호사: {sampleCaregivers.find(c => c.caregiverId === selectedCaregiverForDeletion)?.name}
                </Text>
              </Card>
            )}

            <TextArea 
              placeholder="말소 사유를 상세히 입력하세요"
              value={deletionReason}
              onChange={(e) => setDeletionReason(e.target.value)}
              
            />

            <Flex gap="2">
              <Button 
                variant="soft"
                onClick={() => setDeletionStep('select')}
              >
                이전 단계
              </Button>
              <Button 
                onClick={() => setDeletionStep('confirm')}
                disabled={!deletionReason}
              >
                다음 단계
              </Button>
            </Flex>
          </Flex>
        )}

        {deletionStep === 'confirm' && (
          <Flex direction="column" gap="4">
            <Text size="2" weight="medium">말소 확정</Text>
            
            <Card style={{ padding: '16px', backgroundColor: 'var(--red-2)' }}>
              <Flex direction="column" gap="3">
                <Text size="2" weight="medium" color="red">말소 대상</Text>
                {selectedCaregiverForDeletion && (
                  <Text size="2">
                    {sampleCaregivers.find(c => c.caregiverId === selectedCaregiverForDeletion)?.name} 
                    ({sampleCaregivers.find(c => c.caregiverId === selectedCaregiverForDeletion)?.phone})
                  </Text>
                )}
              </Flex>
            </Card>

            <Card style={{ padding: '16px' }}>
              <Flex direction="column" gap="3">
                <Text size="2" weight="medium">말소 사유</Text>
                <Text size="2" color="gray">{deletionReason}</Text>
              </Flex>
            </Card>

            <Flex gap="2">
              <Button 
                variant="soft"
                onClick={() => setDeletionStep('reason')}
              >
                이전 단계
              </Button>
              <Button 
                onClick={handleSubmit}
                color="red"
              >
                말소 확정
              </Button>
            </Flex>
          </Flex>
        )}
      </Card>

      {/* 우측: 안내 텍스트 */}
      <Flex direction="column" gap="4" style={{ flex: 1, padding: '20px' }}>
        <Text size="3" weight="medium" color="red">직권 말소 안내</Text>
        
        <Text size="2" color="gray">
          말소 처리는 되돌릴 수 없으므로 신중하게 진행해주세요.
        </Text>
      </Flex>
    </Flex>
  );
} 