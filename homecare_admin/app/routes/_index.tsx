import { useState, useEffect } from 'react';
import Layout from '../components/Layout';
import DashboardPage from '../components/Dashboard/DashboardPage';
import CaregiversPage from '../components/Caregivers/CaregiversPage';
import CalendarPage from '../components/Calendar/CalendarPage';
import SettlementPage from '../components/Settlement/SettlementPage';
import { login, getStoredCenterId } from '../api';

const MENU = {
  DASHBOARD: '현황판',
  USERS: '요양보호사',
  CALENDAR: '캘린더',
  SETTLEMENT: '정산 관리',
};

export default function AdminAppShell() {
  const [selected, setSelected] = useState(MENU.DASHBOARD);
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [loginStatus, setLoginStatus] = useState<'idle' | 'loading' | 'success' | 'error'>('idle');

  const handleMenuClick = (label: string) => setSelected(label);

  // 페이지 로드 시 자동 로그인
  useEffect(() => {
    const performAutoLogin = async () => {
      // 이미 로그인되어 있는지 확인
      const existingCenterId = getStoredCenterId();
      if (existingCenterId) {
        setIsLoggedIn(true);
        setLoginStatus('success');
        console.log('이미 로그인되어 있습니다. centerId:', existingCenterId);
        return;
      }

      // 자동 로그인 수행
      setLoginStatus('loading');
      try {
        // 테스트용 이메일과 패스워드 (실제 구현 시 변경 필요)
        const result = await login('test@example.com', 'password123');
        setIsLoggedIn(true);
        setLoginStatus('success');
        console.log('자동 로그인 성공. centerId:', result.centerId);
      } catch (error) {
        setLoginStatus('error');
        console.error('자동 로그인 실패:', error);
      }
    };

    performAutoLogin();
  }, []);

  let content = null;
  if (selected === MENU.DASHBOARD) content = <DashboardPage />;
  else if (selected === MENU.USERS) content = <CaregiversPage />;
  else if (selected === MENU.CALENDAR) content = <CalendarPage />;
  else if (selected === MENU.SETTLEMENT) content = <SettlementPage />;

  // 로그인 중일 때 로딩 표시
  if (loginStatus === 'loading') {
    return (
      <div style={{ 
        display: 'flex', 
        justifyContent: 'center', 
        alignItems: 'center', 
        height: '100vh',
        fontSize: '18px'
      }}>
        로그인 중...
      </div>
    );
  }

  // 로그인 실패 시 에러 표시
  // if (loginStatus === 'error') {
  //   return (
  //     <div style={{ 
  //       display: 'flex', 
  //       justifyContent: 'center', 
  //       alignItems: 'center', 
  //       height: '100vh',
  //       fontSize: '18px',
  //       color: 'red'
  //     }}>
  //       로그인에 실패했습니다. 서버를 확인해주세요.
  //     </div>
  //   );
  // }

  // 로그인 성공 시 메인 앱 렌더링
  return (
    <Layout selected={selected} onMenuClick={handleMenuClick}>
      {content}
    </Layout>
  );
}
