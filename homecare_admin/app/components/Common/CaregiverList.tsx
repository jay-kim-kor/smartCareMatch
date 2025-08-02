import { Flex, Heading, Card, Text, Button, Badge, Separator, ScrollArea, Checkbox } from '@radix-ui/themes';
import { MixerHorizontalIcon } from '@radix-ui/react-icons';
import { useState, useEffect } from 'react';

import { Caregiver } from '../../data/caregivers';
import { getCaregivers, CaregiverApi } from '../../api';

interface CaregiverListProps {
  searchTerm: string;
  selectedStatus: string;
  multiSelectMode: boolean;
  selectedCaregiver: string | null;
  selectedCaregivers: string[];
  onSearchChange: (value: string) => void;
  onStatusChange: (status: string) => void;
  onCaregiverSelect: (caregiverId: string) => void;
  onMultiSelectToggle?: () => void;
  showMultiSelectToggle?: boolean;
}

// API 데이터를 기존 Caregiver 형식으로 변환
function convertApiDataToCaregivers(apiData: CaregiverApi[]): Caregiver[] {
  return apiData.map(caregiver => ({
    caregiverId: caregiver.caregiverId, // UUID 그대로 사용
    name: caregiver.name,
    phone: caregiver.phone,
    status: caregiver.status === 'ACTIVE' ? '활동중' : '휴직', // API 상태를 기존 상태로 매핑
    workTypes: caregiver.serviceTypes.map(type => {
      // API 서비스 타입을 기존 workTypes로 매핑
      switch (type) {
        case 'VISITING_CARE': return '방문요양';
        case 'DAY_NIGHT_CARE': return '주·야간보호';
        case 'RESPITE_CARE': return '단기보호';
        case 'VISITING_BATH': return '방문목욕';
        case 'IN_HOME_SUPPORT': return '재가노인지원';
        case 'VISITING_NURSING': return '방문간호';
        default: return '방문요양';
      }
    }),
    joinDate: new Date().toISOString().split('T')[0], // API에서 제공되지 않으므로 기본값 사용
    avatar: null,
    email: `${caregiver.name}@example.com`, // API에서 제공되지 않으므로 기본값 사용
    birthDate: '1980-01-01', // API에서 제공되지 않으므로 기본값 사용
    address: '기본 주소', // API에서 제공되지 않으므로 기본값 사용
    licenseNumber: '2023-000000', // API에서 제공되지 않으므로 기본값 사용
    licenseDate: '2023-01-01', // API에서 제공되지 않으므로 기본값 사용
    education: '완료', // API에서 제공되지 않으므로 기본값 사용
    hourlyWage: 12000, // API에서 제공되지 않으므로 기본값 사용
    workArea: '서울시', // API에서 제공되지 않으므로 기본값 사용
  }));
}

export default function CaregiverList({
  searchTerm,
  selectedStatus,
  multiSelectMode,
  selectedCaregiver,
  selectedCaregivers,
  onSearchChange,
  onStatusChange,
  onCaregiverSelect,
  onMultiSelectToggle
}: CaregiverListProps) {
  const [apiCaregivers, setApiCaregivers] = useState<CaregiverApi[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // API에서 요양보호사 데이터 가져오기
  useEffect(() => {
    const fetchCaregivers = async () => {
      setLoading(true);
      setError(null);
      try {
        const data = await getCaregivers();
        setApiCaregivers(data);
        console.log('요양보호사 데이터 로드 성공:', data);
      } catch (err) {
        setError(err instanceof Error ? err.message : '요양보호사 로드 실패');
        console.error('요양보호사 로드 실패:', err);
      } finally {
        setLoading(false);
      }
    };

    fetchCaregivers();
  }, []);

  // API 데이터를 기존 형식으로 변환
  const convertedApiCaregivers = convertApiDataToCaregivers(apiCaregivers);

  const getStatusColor = (status: string) => {
    switch (status) {
      case '활동중': return 'green';
      case '휴직': return 'yellow';
      case '퇴사': return 'red';
      default: return 'gray';
    }
  };

  return (
    <Card style={{ flex: 1, display: 'flex', flexDirection: 'column' }}>
      <Flex direction="column" gap="4" p="4" style={{ flex: 1, minHeight: 0 }}>
        {/* 검색 및 필터 */}
        <Flex direction="column" gap="3">
            <Flex justify="between" align="center">
              <Heading size="4">요양보호사 목록</Heading>
              {onMultiSelectToggle && (
                <Button
                  variant={multiSelectMode ? 'solid' : 'soft'}
                  size="2"
                  onClick={onMultiSelectToggle}
                >
                  {multiSelectMode ? '복수 선택 모드 해제' : '복수 선택 모드'}
                </Button>
              )}
            </Flex>
          
          {/* 검색바 */}
          <Flex gap="2" align="center">
            <input
              type="text"
              placeholder="이름 또는 전화번호로 검색"
              value={searchTerm}
              onChange={(e: React.ChangeEvent<HTMLInputElement>) => onSearchChange(e.target.value)}
              style={{
                flex: 1,
                padding: '8px 12px',
                border: '1px solid var(--gray-6)',
                borderRadius: '6px',
                fontSize: '14px',
                backgroundColor: 'var(--color-surface)',
                color: 'var(--color-foreground)',
                height: '32px',
                boxSizing: 'border-box'
              }}
            />
            <Button variant="soft" size="2" style={{ height: '32px' }}>
              <MixerHorizontalIcon />
            </Button>
          </Flex>

          {/* 상태 필터 */}
          <Flex gap="2" wrap="wrap">
            {['전체', '활동중', '휴직', '퇴사'].map(status => (
              <Button
                key={status}
                variant={selectedStatus === status ? 'solid' : 'soft'}
                size="1"
                onClick={() => onStatusChange(status)}
              >
                {status}
              </Button>
            ))}
          </Flex>
        </Flex>

        <Separator />

        {/* 로딩 상태 표시 */}
        {loading && (
          <div style={{ 
            display: 'flex', 
            justifyContent: 'center', 
            alignItems: 'center', 
            padding: '20px',
            fontSize: '14px',
            color: 'var(--gray-11)'
          }}>
            요양보호사 데이터 로딩 중...
          </div>
        )}

        {/* 에러 상태 표시 */}
        {error && (
          <div style={{ 
            display: 'flex', 
            justifyContent: 'center', 
            alignItems: 'center', 
            padding: '20px',
            fontSize: '14px',
            color: 'var(--red-9)'
          }}>
            {error}
          </div>
        )}

        {/* 요양보호사 목록 */}
        {!loading && !error && (
          <ScrollArea type='always' scrollbars='vertical' style={{ flex: 1, minHeight: 0 }}>
            <Flex direction="column" gap="3">
              {convertedApiCaregivers.map(caregiver => (
                <Card
                  key={caregiver.caregiverId}
                  style={{
                    cursor: 'pointer',
                    backgroundColor: (!multiSelectMode && selectedCaregiver === caregiver.caregiverId) ? 'var(--accent-3)' : 'transparent',
                    marginRight: '10%'
                  }}
                  onClick={() => onCaregiverSelect(caregiver.caregiverId)}
                >
                  <Flex gap="2" p="1" align="center">
                    {multiSelectMode && (
                      <Checkbox 
                        checked={selectedCaregivers.includes(caregiver.caregiverId)}
                        onChange={() => onCaregiverSelect(caregiver.caregiverId)}
                        onClick={(e) => e.stopPropagation()}
                        style={{ marginRight: '2%' }}
                      />
                    )}
                    <Flex direction="column" gap="1" style={{ flex: 1 }}>
                      <Text weight="medium" size="2">{caregiver.name}</Text>
                      <Text size="1" color="gray">{caregiver.phone}</Text>
                    </Flex>
                    <Badge color={getStatusColor(caregiver.status)} size="1">
                      {caregiver.status}
                    </Badge>
                  </Flex>
                </Card>
              ))}
            </Flex>
          </ScrollArea>
        )}
      </Flex>
    </Card>
  );
} 