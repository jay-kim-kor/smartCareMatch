import { Flex, Text, IconButton, Switch, Separator } from '@radix-ui/themes';
import { useContext } from 'react';
import { DarkModeContext } from '../../root';

interface SettingsPopoverProps {
  onOpenChange: (open: boolean) => void;
}

export default function SettingsPopover({ onOpenChange }: SettingsPopoverProps) {
  const { isDarkMode, toggleDarkMode } = useContext(DarkModeContext);

  return (
    <Flex direction="column" gap="3">
      <Flex justify="between" align="center">
        <Text size="3" weight="medium">설정</Text>
        <IconButton 
          variant="ghost" 
          size="1"
          onClick={() => onOpenChange(false)}
        >
          ✕
        </IconButton>
      </Flex>

      <Separator size="2" />
      
      <Flex direction="column" gap="2">
        <Flex justify="between" align="center">
          <Text size="2">다크 모드</Text>
          <Switch 
            checked={isDarkMode} 
            onCheckedChange={toggleDarkMode}
          />
        </Flex>
      </Flex>
    </Flex>
  );
} 