import { Flex, Heading, Text, Card, Button, TextField } from '@radix-ui/themes';
import { useState } from 'react';

interface DirectRegistrationFormProps {
  onSubmit: (data: {
    name: string;
    phone: string;
    birthDate: string;
    email: string;
    address: string;
  }) => void;
}

export default function DirectRegistrationForm({ onSubmit }: DirectRegistrationFormProps) {
  const [directName, setDirectName] = useState('');
  const [directPhone, setDirectPhone] = useState('');
  const [directBirthDate, setDirectBirthDate] = useState('');
  const [directEmail, setDirectEmail] = useState('');
  const [directAddress, setDirectAddress] = useState('');

  const handleSubmit = () => {
    onSubmit({
      name: directName,
      phone: directPhone,
      birthDate: directBirthDate,
      email: directEmail,
      address: directAddress
    });
    
    // 폼 초기화
    setDirectName('');
    setDirectPhone('');
    setDirectBirthDate('');
    setDirectEmail('');
    setDirectAddress('');
  };

  return (
    <Flex gap="6" style={{ marginTop: '16px' }}>
      {/* 좌측: 입력 폼 */}
      <Card style={{ flex: 1, padding: '20px' }}>
        <Heading size="3" mb="4">직권 등록</Heading>
        
        <Flex direction="column" gap="4">
          {/* 기본 정보 */}
          <Flex gap="4">
            <Flex direction="column" gap="2" style={{ flex: 1 }}>
              <Text size="2" weight="medium">보호사명 *</Text>
              <TextField.Root 
                placeholder="보호사명을 입력하세요"
                value={directName}
                onChange={(e) => setDirectName(e.target.value)}
              />
            </Flex>
            <Flex direction="column" gap="2" style={{ flex: 1 }}>
              <Text size="2" weight="medium">전화번호 *</Text>
              <TextField.Root 
                placeholder="전화번호를 입력하세요"
                value={directPhone}
                onChange={(e) => setDirectPhone(e.target.value)}
              />
            </Flex>
          </Flex>

          <Flex gap="4">
            <Flex direction="column" gap="2" style={{ flex: 1 }}>
              <Text size="2" weight="medium">생년월일 *</Text>
              <TextField.Root 
                placeholder="YYYY-MM-DD"
                value={directBirthDate}
                onChange={(e) => setDirectBirthDate(e.target.value)}
              />
            </Flex>
            <Flex direction="column" gap="2" style={{ flex: 1 }}>
              <Text size="2" weight="medium">이메일 *</Text>
              <TextField.Root 
                placeholder="이메일을 입력하세요"
                value={directEmail}
                onChange={(e) => setDirectEmail(e.target.value)}
              />
            </Flex>
          </Flex>

          <Flex direction="column" gap="2">
            <Text size="2" weight="medium">주소 *</Text>
            <TextField.Root 
              placeholder="주소를 입력하세요"
              value={directAddress}
              onChange={(e) => setDirectAddress(e.target.value)}
            />
          </Flex>

          <Button 
            onClick={handleSubmit}
            disabled={!directName || !directPhone || !directBirthDate || !directAddress || !directEmail}
            style={{ marginTop: '8px' }}
          >
            등록 처리
          </Button>
        </Flex>
      </Card>

      {/* 우측: 안내 텍스트 */}
      <Flex direction="column" gap="4" style={{ flex: 1, padding: '20px' }}>
        <Text size="3" weight="medium" color="blue">추가 정보 입력 안내</Text>
        
        <Text size="2" color="gray">
          추가 정보는 등록 후 인사카드에서 조회 후 편집을 통해 입력할 수 있습니다.
        </Text>
      </Flex>
    </Flex>
  );
} 