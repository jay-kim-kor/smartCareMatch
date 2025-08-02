import { Flex, Heading, Card, Text, Button, Badge, ScrollArea, Checkbox, Tabs } from '@radix-ui/themes';
import { useState, useEffect } from 'react';
import { Caregiver } from '../../../data/caregivers';
import { WORK_TYPE_COLORS } from '../../../constants/workTypes';
import { formatCurrency } from '../../../utils/formatters';
import { getCaregiverProfile, getCaregiverCertification, CaregiverProfileApi, CaregiverCertificationApi } from '../../../api/caregiver';

interface CaregiverCardProps {
  selectedCaregiver: string | null;
  caregivers: Caregiver[];
}

// API 데이터를 기존 Caregiver 형식으로 변환
function convertApiDataToCaregiver(apiData: CaregiverProfileApi, certificationData?: CaregiverCertificationApi): Caregiver {
  return {
    caregiverId: '', // API에서 제공되지 않으므로 빈 문자열 사용
    name: apiData.caregiverName,
    phone: apiData.phone,
    status: apiData.status === 'ACTIVE' ? '활동중' : '휴직', // API 상태를 기존 상태로 매핑
    workTypes: apiData.serviceTypes.map(type => {
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
    email: apiData.email,
    birthDate: apiData.birthDate,
    address: apiData.address,
    licenseNumber: certificationData?.certificationNumber || '-',
    licenseDate: certificationData?.certificationDate || '-',
    education: certificationData?.trainStatus ? '완료' : '미완료', // API에서 제공되지 않으므로 기본값 사용
    hourlyWage: 12000, // API에서 제공되지 않으므로 기본값 사용
    workArea: '서울시', // API에서 제공되지 않으므로 기본값 사용
  };
}

// 돌봄을 받는 사람들의 샘플 데이터
const sampleClients = [
  { id: 1, name: '김영수', phone: '010-1111-2222', address: '서울시 강남구', status: '활동중' },
  { id: 2, name: '박미영', phone: '010-3333-4444', address: '서울시 서초구', status: '활동중' },
  { id: 3, name: '이철수', phone: '010-5555-6666', address: '서울시 마포구', status: '활동중' },
  { id: 4, name: '정순자', phone: '010-7777-8888', address: '서울시 용산구', status: '활동중' },
  { id: 5, name: '최민호', phone: '010-9999-0000', address: '서울시 서대문구', status: '활동중' },
];

export default function CaregiverCard({ selectedCaregiver, caregivers }: CaregiverCardProps) {
  const [blacklist, setBlacklist] = useState<number[]>([]);
  const [selectedTab, setSelectedTab] = useState('basic');
  const [apiCaregiver, setApiCaregiver] = useState<Caregiver | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // API에서 인사카드 데이터와 자격증 데이터 가져오기
  useEffect(() => {
    if (!selectedCaregiver) {
      setApiCaregiver(null);
      setError(null);
      return;
    }

    const fetchCaregiverData = async () => {
      setLoading(true);
      setError(null);
      
      let profileData: CaregiverProfileApi | null = null;
      let certificationData: CaregiverCertificationApi | null = null;

      // 인사카드 정보 가져오기
      try {
        profileData = await getCaregiverProfile(selectedCaregiver);
      } catch (err) {
        console.error('Failed to fetch caregiver profile:', err);
      }

      // 자격증 정보 가져오기
      try {
        certificationData = await getCaregiverCertification(selectedCaregiver);
      } catch (err) {
        console.error('Failed to fetch caregiver certification:', err);
        // 자격증 정보 실패는 에러로 처리하지 않음
      }

      // 인사카드 정보가 없으면 에러 처리
      if (!profileData) {
        setError('인사카드 정보를 불러오는데 실패했습니다.');
        setApiCaregiver(null);
      } else {
        const convertedCaregiver = convertApiDataToCaregiver(profileData, certificationData || undefined);
        setApiCaregiver(convertedCaregiver);
      }

      setLoading(false);
    };

    fetchCaregiverData();
  }, [selectedCaregiver]);

  // API 데이터가 있으면 API 데이터를, 없으면 기존 데이터를 사용
  const caregiver = apiCaregiver || caregivers.find(c => c.caregiverId === selectedCaregiver);

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('ko-KR');
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case '활동중': return 'green';
      case '휴직': return 'yellow';
      case '퇴사': return 'red';
      default: return 'gray';
    }
  };

  const handleBlacklistToggle = (clientId: number) => {
    setBlacklist(prev => 
      prev.includes(clientId) 
        ? prev.filter(id => id !== clientId)
        : [...prev, clientId]
    );
  };

  return (
    <Card style={{ flex: 3, display: 'flex', flexDirection: 'column' }}>
      <Flex direction="column" gap="4" p="4" style={{ flex: 1 }}>
        <Flex justify="between" align="center">
          <Heading size="4">인사카드</Heading>
          <Button variant="soft" size="2">편집</Button>
        </Flex>

        {loading ? (
          <Flex justify="center" align="center" style={{ flex: 1 }}>
            <Text size="3" color="gray">로딩 중...</Text>
          </Flex>
        ) : error ? (
          <Flex justify="center" align="center" style={{ flex: 1 }}>
            <Text size="3" color="red">{error}</Text>
          </Flex>
        ) : caregiver ? (
          <Tabs.Root value={selectedTab} onValueChange={setSelectedTab}>
            <Tabs.List>
              <Tabs.Trigger value="basic">인사 정보</Tabs.Trigger>
              <Tabs.Trigger value="blacklist">
                블랙리스트
                {blacklist.length > 0 && (
                  <Badge color="red" size="1" style={{ marginLeft: '4px' }}>
                    {blacklist.length}
                  </Badge>
                )}
              </Tabs.Trigger>
            </Tabs.List>

            <ScrollArea style={{ flex: 1, marginTop: '16px' }}>
              {/* 인사 정보 탭 */}
              {selectedTab === 'basic' && (
                <Flex direction="column" gap="6">
                  {/* 기본 정보 */}
                  <Card>
                    <Heading size="3" mb="3">기본 정보</Heading>
                    <Flex gap="6" wrap="wrap">
                      <Flex direction="column" gap="2" style={{ minWidth: 200 }}>
                        <Text size="2" color="gray">이름</Text>
                        <Text size="3" weight="medium">{caregiver.name}</Text>
                      </Flex>
                      <Flex direction="column" gap="2" style={{ minWidth: 200 }}>
                        <Text size="2" color="gray">생년월일</Text>
                        <Text size="3" weight="medium">{caregiver.birthDate ? formatDate(caregiver.birthDate) : '-'}</Text>
                      </Flex>
                      <Flex direction="column" gap="2" style={{ minWidth: 200 }}>
                        <Text size="2" color="gray">전화번호</Text>
                        <Text size="3" weight="medium">{caregiver.phone}</Text>
                      </Flex>
                      <Flex direction="column" gap="2" style={{ minWidth: 200 }}>
                        <Text size="2" color="gray">이메일</Text>
                        <Text size="3" weight="medium">{caregiver.email || '-'}</Text>
                      </Flex>
                      <Flex direction="column" gap="2" style={{ minWidth: 200 }}>
                        <Text size="2" color="gray">주소</Text>
                        <Text size="3" weight="medium">{caregiver.address || '-'}</Text>
                      </Flex>
                    </Flex>
                  </Card>

                  {/* 근무 정보 */}
                  <Card>
                    <Heading size="3" mb="3">근무 정보</Heading>
                    <Flex gap="6" wrap="wrap">
                      <Flex direction="column" gap="2" style={{ minWidth: 200 }}>
                        <Text size="2" color="gray">상태</Text>
                        <Badge color={getStatusColor(caregiver.status)} size="2">
                          {caregiver.status}
                        </Badge>
                      </Flex>
                      <Flex direction="column" gap="2" style={{ minWidth: 200 }}>
                        <Text size="2" color="gray">근무 유형</Text>
                        <Flex gap="2" wrap="wrap">
                          {caregiver.workTypes.map((workType, index) => (
                            <Badge 
                              key={index} 
                              color={WORK_TYPE_COLORS[workType] as "blue" | "purple" | "green" | "orange" | "yellow" | "red"} 
                              size="2"
                            >
                              {workType}
                            </Badge>
                          ))}
                        </Flex>
                      </Flex>
                      <Flex direction="column" gap="2" style={{ minWidth: 200 }}>
                        <Text size="2" color="gray">입사일</Text>
                        <Text size="3" weight="medium">{formatDate(caregiver.joinDate)}</Text>
                      </Flex>
                      <Flex direction="column" gap="2" style={{ minWidth: 200 }}>
                        <Text size="2" color="gray">근무 지역</Text>
                        <Text size="3" weight="medium">{caregiver.workArea || '-'}</Text>
                      </Flex>
                    </Flex>
                  </Card>

                  {/* 자격 정보 */}
                  <Card>
                    <Heading size="3" mb="3">자격 정보</Heading>
                    <Flex gap="6" wrap="wrap">
                      <Flex direction="column" gap="2" style={{ minWidth: 200 }}>
                        <Text size="2" color="gray">요양보호사 자격증</Text>
                        <Text size="3" weight="medium">{caregiver.licenseNumber || '-'}</Text>
                      </Flex>
                      <Flex direction="column" gap="2" style={{ minWidth: 200 }}>
                        <Text size="2" color="gray">자격 취득일</Text>
                        <Text size="3" weight="medium">{caregiver.licenseDate ? formatDate(caregiver.licenseDate) : '-'}</Text>
                      </Flex>
                      <Flex direction="column" gap="2" style={{ minWidth: 200 }}>
                        <Text size="2" color="gray">교육 이수</Text>
                        <Text size="3" weight="medium">{caregiver.education || '-'}</Text>
                      </Flex>
                    </Flex>
                  </Card>

                  {/* 급여 정보 */}
                  <Card>
                    <Heading size="3" mb="3">급여 정보</Heading>
                    <Flex gap="6" wrap="wrap">
                      <Flex direction="column" gap="2" style={{ minWidth: 200 }}>
                        <Text size="2" color="gray">시급</Text>
                        <Text size="3" weight="medium">{caregiver.hourlyWage ? formatCurrency(caregiver.hourlyWage) : '-'}</Text>
                      </Flex>
                      <Flex direction="column" gap="2" style={{ minWidth: 200 }}>
                        <Text size="2" color="gray">이번달 근무시간</Text>
                        <Text size="3" weight="medium">160시간</Text>
                      </Flex>
                      <Flex direction="column" gap="2" style={{ minWidth: 200 }}>
                        <Text size="2" color="gray">이번달 급여</Text>
                        <Text size="3" weight="medium">
                          {caregiver.hourlyWage ? formatCurrency(caregiver.hourlyWage * 160) : '-'}
                        </Text>
                      </Flex>
                    </Flex>
                  </Card>
                </Flex>
              )}

              {/* 블랙리스트 탭 */}
              {selectedTab === 'blacklist' && (
                <Flex direction="column" gap="4">
                  <Flex direction="column" gap="3">
                    <Text size="2" color="gray" mb="2">
                      이 요양보호사와 매칭되지 않기를 원하는 돌봄 대상자 목록입니다.
                    </Text>
                    <ScrollArea style={{ height: '100%' }}>
                      <Flex direction="column" gap="2">
                        {sampleClients.map(client => (
                          <Flex 
                            key={client.id} 
                            justify="between" 
                            align="center" 
                            p="3" 
                            style={{ 
                              background: blacklist.includes(client.id) ? 'var(--red-2)' : 'var(--gray-2)',
                              borderRadius: '6px',
                              border: blacklist.includes(client.id) ? '1px solid var(--red-6)' : '1px solid var(--gray-6)'
                            }}
                          >
                            <Flex align="center" gap="3">
                              <Checkbox 
                                checked={blacklist.includes(client.id)}
                                onCheckedChange={() => handleBlacklistToggle(client.id)}
                              />
                              <Flex direction="column" gap="1">
                                <Text weight="medium" size="2">{client.name}</Text>
                                <Text size="1" color="gray">{client.phone} • {client.address}</Text>
                              </Flex>
                            </Flex>
                            <Badge 
                              color={blacklist.includes(client.id) ? 'red' : 'green'} 
                              size="1"
                            >
                              {blacklist.includes(client.id) ? '매칭 제외' : '매칭 가능'}
                            </Badge>
                          </Flex>
                        ))}
                      </Flex>
                    </ScrollArea>
                    <Flex justify="between" align="center">
                      <Text size="2" color="gray" mt='2'>
                        총 {sampleClients.length}명 중 {blacklist.length}명 매칭 제외
                      </Text>
                      <Button variant="soft" size="1" color="red">
                        블랙리스트 초기화
                      </Button>
                    </Flex>
                  </Flex>
                </Flex>
              )}
            </ScrollArea>
          </Tabs.Root>
        ) : (
          <Flex justify="center" align="center" style={{ flex: 1 }}>
            <Text size="3" color="gray">보호사를 선택해주세요</Text>
          </Flex>
        )}
      </Flex>
    </Card>
  );
} 