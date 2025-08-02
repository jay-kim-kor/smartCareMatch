import { Flex, Text, IconButton, Badge, ScrollArea } from '@radix-ui/themes';
import { useState, useEffect } from 'react';
import { AssignApi, getAssignments } from '../../api/caregiver';
import { getStoredCenterId } from '../../api/auth';

interface NotificationPopoverProps {
  onOpenChange: (open: boolean) => void;
}

// 로컬 스토리지 키
const STORAGE_KEYS = {
  ALL_ASSIGNMENTS: 'allAssignments',
  UPDATED_ASSIGNMENTS: 'updatedAssignments',
} as const;

// 매칭 정보를 고유하게 식별하는 함수
const getAssignmentKey = (assignment: AssignApi) => {
  return `${assignment.consumerName}-${assignment.caregiverName}-${assignment.serviceDate}-${assignment.startTime}`;
};

// 로컬 스토리지에서 데이터 가져오기
const getStoredData = (key: string): AssignApi[] => {
  try {
    const data = localStorage.getItem(key);
    return data ? JSON.parse(data) : [];
  } catch (error) {
    console.error(`Failed to get stored data for ${key}:`, error);
    return [];
  }
};

// 로컬 스토리지에 데이터 저장하기
const setStoredData = (key: string, data: AssignApi[]) => {
  try {
    localStorage.setItem(key, JSON.stringify(data));
  } catch (error) {
    console.error(`Failed to set stored data for ${key}:`, error);
  }
};

// localStorage 키들을 초기화하는 함수
const initializeStorageKeys = () => {
  // updatedAssignments 키가 없으면 빈 배열로 초기화
  if (!localStorage.getItem(STORAGE_KEYS.UPDATED_ASSIGNMENTS)) {
    setStoredData(STORAGE_KEYS.UPDATED_ASSIGNMENTS, []);
    console.log('Initialized updatedAssignments storage key');
  }
  
  // allAssignments 키가 없으면 빈 배열로 초기화
  if (!localStorage.getItem(STORAGE_KEYS.ALL_ASSIGNMENTS)) {
    setStoredData(STORAGE_KEYS.ALL_ASSIGNMENTS, []);
    console.log('Initialized allAssignments storage key');
  }
};

// 전역 상태 관리를 위한 이벤트 시스템
const createNotificationEvent = () => {
  const listeners: (() => void)[] = [];
  
  return {
    subscribe: (callback: () => void) => {
      listeners.push(callback);
      return () => {
        const index = listeners.indexOf(callback);
        if (index > -1) {
          listeners.splice(index, 1);
        }
      };
    },
    notify: () => {
      listeners.forEach(callback => callback());
    }
  };
};

const notificationEvent = createNotificationEvent();

// 실시간 매칭 정보 업데이트 함수 (전역에서 사용)
export const startNotificationPolling = () => {
  const centerId = getStoredCenterId();
  if (!centerId) {
    console.log('centerId not found, skipping notification polling');
    return;
  }

  console.log('Starting notification polling with centerId:', centerId);
  
  // localStorage 키들 초기화
  initializeStorageKeys();

  const pollAssignments = async () => {
    try {
      const newAssignments = await getAssignments();
      console.log('Fetched assignments:', newAssignments);
      
      const allAssignments = getStoredData(STORAGE_KEYS.ALL_ASSIGNMENTS);
      console.log('Current allAssignments:', allAssignments);
      
      // 두 스토리지의 길이 비교
      const lengthDifference = newAssignments.length - allAssignments.length;
      console.log('Length difference:', lengthDifference);
      
      if (lengthDifference > 0) {
        // 새로운 데이터가 있으면, 차이나는 개수만큼 앞에서부터 가져와서 updatedAssignments에 추가
        const newItems = newAssignments.slice(0, lengthDifference);
        console.log('New items to add:', newItems);
        
        const updatedAssignments = getStoredData(STORAGE_KEYS.UPDATED_ASSIGNMENTS);
        const newUpdatedAssignments = [...updatedAssignments, ...newItems];
        setStoredData(STORAGE_KEYS.UPDATED_ASSIGNMENTS, newUpdatedAssignments);
        
        console.log('Updated assignments stored:', newUpdatedAssignments);
        console.log('Updated assignments count:', newUpdatedAssignments.length);
        
        // 이벤트 발생
        notificationEvent.notify();
      }

      // 전체 매칭 정보 업데이트
      setStoredData(STORAGE_KEYS.ALL_ASSIGNMENTS, newAssignments);
      console.log('All assignments updated, new count:', newAssignments.length);
    } catch (error) {
      console.error('Failed to fetch assignments:', error);
    }
  };

  // 초기 로드
  pollAssignments();

  // 1초마다 업데이트
  return setInterval(pollAssignments, 1000);
};

// 알림 개수를 가져오는 함수 (외부에서 사용)
export const getNotificationCount = (): number => {
  const updatedAssignments = getStoredData(STORAGE_KEYS.UPDATED_ASSIGNMENTS);
  return updatedAssignments.length;
};

export default function NotificationPopover({ onOpenChange }: NotificationPopoverProps) {
  const [updatedAssignments, setUpdatedAssignments] = useState<AssignApi[]>([]);

  // 초기 데이터 로드 및 실시간 업데이트 구독
  useEffect(() => {
    const storedUpdatedAssignments = getStoredData(STORAGE_KEYS.UPDATED_ASSIGNMENTS);
    setUpdatedAssignments(storedUpdatedAssignments);

    // 실시간 업데이트 구독
    const unsubscribe = notificationEvent.subscribe(() => {
      const newUpdatedAssignments = getStoredData(STORAGE_KEYS.UPDATED_ASSIGNMENTS);
      setUpdatedAssignments(newUpdatedAssignments);
    });

    return unsubscribe;
  }, []);

  // 알림 클릭 시 해당 알림 제거
  const handleNotificationClick = (clickedAssignment: AssignApi) => {
    const filteredAssignments = updatedAssignments.filter(
      assignment => getAssignmentKey(assignment) !== getAssignmentKey(clickedAssignment)
    );
    setUpdatedAssignments(filteredAssignments);
    setStoredData(STORAGE_KEYS.UPDATED_ASSIGNMENTS, filteredAssignments);
  };

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('ko-KR');
  };

  const formatTime = (timeString: string) => {
    return timeString.substring(0, 5); // HH:MM 형식으로 변환
  };

  const getServiceTypeColor = (serviceType: string) => {
    switch (serviceType) {
      case 'VISITING_CARE': return 'blue';
      case 'DAY_NIGHT_CARE': return 'purple';
      case 'RESPITE_CARE': return 'green';
      case 'VISITING_BATH': return 'orange';
      case 'IN_HOME_SUPPORT': return 'yellow';
      case 'VISITING_NURSING': return 'red';
      default: return 'gray';
    }
  };

  const getServiceTypeText = (serviceType: string) => {
    switch (serviceType) {
      case 'VISITING_CARE': return '방문요양';
      case 'DAY_NIGHT_CARE': return '주·야간보호';
      case 'RESPITE_CARE': return '단기보호';
      case 'VISITING_BATH': return '방문목욕';
      case 'IN_HOME_SUPPORT': return '재가노인지원';
      case 'VISITING_NURSING': return '방문간호';
      default: return serviceType;
    }
  };

  // const getStatusColor = (status: string) => {
  //   switch (status) {
  //     case 'PENDING': return 'yellow';
  //     case 'CONFIRMED': return 'green';
  //     case 'CANCELLED': return 'red';
  //     default: return 'gray';
  //   }
  // };

  // const getStatusText = (status: string) => {
  //   switch (status) {
  //     case 'PENDING': return '대기중';
  //     case 'CONFIRMED': return '확정';
  //     case 'CANCELLED': return '취소';
  //     default: return status;
  //   }
  // };

  return (
    <Flex direction="column" gap="3" style={{ width: '400px', maxHeight: '500px' }}>
      <Flex justify="between" align="center">
        <Text size="3" weight="medium">알림</Text>
        <IconButton 
          variant="ghost" 
          size="1"
          onClick={() => onOpenChange(false)}
        >
          ✕
        </IconButton>
      </Flex>
      
      <ScrollArea style={{ maxHeight: '400px' }}>
        <Flex direction="column" gap="2">
          {updatedAssignments.length === 0 ? (
            <Text size="2" color="gray">새로운 알림이 없습니다.</Text>
          ) : (
            updatedAssignments.map((assignment, index) => (
              <Flex 
                key={index}
                direction="column" 
                gap="2" 
                p="3" 
                style={{ 
                  background: 'var(--gray-2)', 
                  borderRadius: '6px',
                  cursor: 'pointer',
                  border: '1px solid var(--gray-6)'
                }}
                onClick={() => handleNotificationClick(assignment)}
              >
                <Flex justify="between" align="center">
                  <Text size="2" weight="medium">
                    {assignment.consumerName} → {assignment.caregiverName}
                  </Text>
                  {/* <Badge 
                    color={getStatusColor(assignment.status) as "yellow" | "green" | "red" | "gray"} 
                    size="1"
                  >
                    {getStatusText(assignment.status)}
                  </Badge> */}
                </Flex>
                
                <Flex direction="column" gap="1">
                  <Text size="1" color="gray">
                    {formatDate(assignment.serviceDate)} {formatTime(assignment.startTime)} - {formatTime(assignment.endTime)}
                  </Text>
                  <Badge 
                    color={getServiceTypeColor(assignment.serviceType) as "blue" | "purple" | "green" | "orange" | "yellow" | "red" | "gray"} 
                    size="1"
                    style={{ alignSelf: 'flex-start' }}
                  >
                    {getServiceTypeText(assignment.serviceType)}
                  </Badge>
                </Flex>
              </Flex>
            ))
          )}
        </Flex>
      </ScrollArea>
    </Flex>
  );
} 