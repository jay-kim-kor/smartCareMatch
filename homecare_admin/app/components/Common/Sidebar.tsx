import { IconButton, Popover, Badge } from '@radix-ui/themes';
import { useState, useContext, useEffect } from 'react';
import { MENU } from '../../constants/menu';
import NotificationPopover, { getNotificationCount } from '../Admin/NotificationPopover';
import SettingsPopover from '../Admin/SettingsPopover';
import { DarkModeContext } from '../../root';

interface FloatingActionBarProps {
  onMenuClick: (label: string) => void;
  selected: string;
}

export default function FloatingActionBar({ onMenuClick, selected }: FloatingActionBarProps) {
  const [hovered, setHovered] = useState<number | null>(null);
  const [isNotificationOpen, setIsNotificationOpen] = useState(false);
  const [isSettingsOpen, setIsSettingsOpen] = useState(false);
  const [notificationCount, setNotificationCount] = useState(0);
  const { isDarkMode } = useContext(DarkModeContext);

  // 알림 개수 업데이트
  useEffect(() => {
    const updateNotificationCount = () => {
      const count = getNotificationCount();
      setNotificationCount(count);
    };

    // 초기 로드
    updateNotificationCount();

    // 1초마다 업데이트
    const interval = setInterval(updateNotificationCount, 1000);

    return () => clearInterval(interval);
  }, []);

  const handleMenuClick = (label: string) => {
    if (label === '알림') {
      setIsNotificationOpen(true);
    } else if (label === '설정') {
      setIsSettingsOpen(true);
    } else {
      onMenuClick && onMenuClick(label);
    }
  };

  return (
    <div
      style={{
        position: 'fixed',
        top: '50%',
        left: 24,
        transform: 'translateY(-50%)',
        display: 'flex',
        flexDirection: 'column',
        gap: 24,
        zIndex: 100,
      }}
    >
      {MENU.map((item, idx) => (
        <div key={item.label}>
          <Popover.Root open={(item.label === '알림' ? isNotificationOpen : false) || (item.label === '설정' ? isSettingsOpen : false)} onOpenChange={item.label === '알림' ? setIsNotificationOpen : item.label === '설정' ? setIsSettingsOpen : undefined}>
            <Popover.Trigger>
              <div
                onMouseEnter={() => setHovered(idx)}
                onMouseLeave={() => setHovered(null)}
                onClick={() => handleMenuClick(item.label)}
                role="button"
                tabIndex={0}
                onKeyDown={e => {
                  if (e.key === 'Enter' || e.key === ' ') {
                    handleMenuClick(item.label);
                  }
                }}
                style={{
                  display: 'inline-flex',
                  alignItems: 'center',
                  transition: 'background 0.2s',
                  overflow: 'hidden',
                  cursor: 'pointer',
                  padding: 0,
                  height: 48,
                  background: hovered === idx
                    ? 'linear-gradient(270deg, var(--color-surface) 0%, transparent 100%)'
                    : 'none',
                  boxShadow: 'none',
                  borderRadius: 24,
                  position: 'relative',
                }}
              >
                <IconButton
                  variant="ghost"
                  size="3"
                  tabIndex={-1}
                  aria-label={item.label}
                  style={{ 
                    color: hovered === idx 
                      ? (isDarkMode ? 'white' : 'var(--gray-12)') 
                      : (selected === item.label ? 'var(--accent-10)' : 'gray'),
                    background: 'none',
                    boxShadow: 'none',
                    width: 40,
                    height: 40
                  }}
                >
                  {item.icon}
                </IconButton>
                
                {/* 알림 개수 배지 */}
                {item.label === '알림' && notificationCount > 0 && (
                  <Badge 
                    color="red" 
                    size="1"
                    style={{
                      position: 'absolute',
                      top: '4px',
                      right: '4px',
                      minWidth: '16px',
                      height: '16px',
                      fontSize: '10px',
                      padding: '0 4px',
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                    }}
                  >
                    {notificationCount}
                  </Badge>
                )}
                
                <span
                  style={{
                    opacity: hovered === idx && item.label !== '설정' && item.label !== '알림' ? 1 : 0,
                    maxWidth: hovered === idx && item.label !== '설정' && item.label !== '알림' ? 200 : 0,
                    whiteSpace: 'nowrap',
                    transition: 'opacity 0.15s, margin-left 0.2s, max-width 0.2s, padding 0.2s',
                    fontWeight: 500,
                    color: 'var(--gray-12)',
                    pointerEvents: hovered === idx && item.label !== '설정' && item.label !== '알림' ? 'auto' : 'none',
                    fontSize: 18,
                    lineHeight: 1,
                    display: 'flex',
                    alignItems: 'center',
                    height: 48,
                    background: 'none',
                    overflow: 'hidden',
                    paddingLeft: hovered === idx && item.label !== '설정' && item.label !== '알림' ? 8 : 0,
                    paddingRight: hovered === idx && item.label !== '설정' && item.label !== '알림' ? 20 : 0,
                  }}
                >
                  {item.label}
                </span>
              </div>
            </Popover.Trigger>
            
            {item.label === '알림' && (
              <Popover.Content side="right" align="start" style={{ minWidth: '300px' }}>
                <NotificationPopover onOpenChange={setIsNotificationOpen} />
              </Popover.Content>
            )}

            {item.label === '설정' && (
              <Popover.Content side="right" align="start" style={{ minWidth: '300px' }}>
                <SettingsPopover onOpenChange={setIsSettingsOpen} />
              </Popover.Content>
            )}
          </Popover.Root>
          
          {/* 1차 구현 사항에 정산 관리는 제외 */}
          {/* 이후 2차에서 정산 관리와 설정 사이에 구분선 추가 예정 */}
          {item.label === '캘린더' && (
            <div
              style={{
                width: '32px',
                height: '1px',
                background: 'var(--gray-6)',
                margin: '16px 0 0 0',
                marginLeft: '4px',
              }}
            />
          )}
        </div>
      ))}
    </div>
  );
} 