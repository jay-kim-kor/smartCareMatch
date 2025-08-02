import Sidebar from './Common/Sidebar';

interface LayoutProps {
  children: React.ReactNode;
  selected: string;
  onMenuClick: (label: string) => void;
}

export default function Layout({ children, selected, onMenuClick }: LayoutProps) {
  return (
    <div style={{ position: 'relative', minHeight: '100vh'}}>
      <Sidebar onMenuClick={onMenuClick} selected={selected} />
      <div style={{ marginInline: '8vw', justifyContent: 'center' }}>
        {children}
      </div>
    </div>
  );
} 