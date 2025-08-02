import { Flex, Tabs } from '@radix-ui/themes';

interface TabItem {
  key: string;
  label: string;
}

interface PageHeaderProps {
  tabs: TabItem[];
  selectedTab: string;
  onTabChange: (value: string) => void;
}

export default function PageHeader({ tabs, selectedTab, onTabChange }: PageHeaderProps) {
  return (
    <Flex direction="column" style={{ width: '100%' }} mb="4">
      <Tabs.Root value={selectedTab} onValueChange={onTabChange} style={{ width: '100%' }}>
        <Tabs.List style={{ width: '100%' }}>
          {tabs.map(tab => (
            <Tabs.Trigger key={tab.key} value={tab.key}>
              {tab.label}
            </Tabs.Trigger>
          ))}
        </Tabs.List>
      </Tabs.Root>
    </Flex>
  );
} 