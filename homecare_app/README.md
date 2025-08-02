# Homecare App - Radix-UI 스타일 Flutter 앱

Flutter에서 Radix-UI 디자인 시스템을 구현한 홈케어 앱입니다.

## 문제 상황

- 웹 어드민 페이지가 Radix-UI로 작성되어 있음
- Flutter 앱과 디자인 통일성이 필요
- Radix-UI는 웹만 지원하여 Flutter에서 직접 사용 불가

## 해결 방법

### 1. Radix-UI 스타일 디자인 시스템 재구현 (권장)

`lib/design_system/` 폴더에 Radix-UI의 디자인 토큰과 컴포넌트를 Flutter로 재구현했습니다.

#### 구현된 컴포넌트

- **RadixButton**: Solid, Soft, Outline, Ghost 변형과 다양한 크기 지원
- **RadixCard**: 기본 카드와 elevated 카드
- **RadixInput**: 다양한 상태(disabled, error 등)와 아이콘 지원
- **RadixTokens**: Radix Colors 팔레트, 간격, 반지름, 타이포그래피

#### 사용 방법

```dart
import 'design_system/radix_design_system.dart';

// 버튼 사용
RadixButton(
  text: 'Click me',
  variant: RadixButtonVariant.solid,
  onPressed: () {},
)

// 입력 필드 사용
RadixInput(
  placeholder: '이름을 입력하세요',
  prefixIcon: Icon(Icons.person),
  onChanged: (value) => print(value),
)

// 카드 사용
RadixCard(
  child: Text('Card content'),
  onTap: () {},
)
```

### 2. WebView를 통한 하이브리드 접근법

`lib/webview_admin_page.dart`에서 웹 어드민 페이지를 Flutter 앱 내부에 임베드하는 방법을 제공합니다.

#### 특징

- 기존 Radix-UI 어드민 페이지를 그대로 사용
- 네이티브 앱 헤더와 WebView 콘텐츠 조합
- 로딩 상태, 에러 처리, 새로고침 등 기본 기능 제공

#### 사용 방법

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => WebViewAdminPage(
      adminUrl: 'https://your-admin-site.com',
    ),
  ),
);
```

### 3. 색상 시스템

Radix Colors 팔레트를 완전히 구현했습니다:

- **Slate**: 중성 색상 (slate1 ~ slate12)
- **Blue**: 주요 브랜드 색상 (blue1 ~ blue12)
- 각 색상은 명도에 따라 단계별로 구성

### 4. 반응형 디자인

- 다양한 화면 크기 지원
- 터치 및 마우스 인터랙션 모두 고려
- 접근성을 위한 적절한 색상 대비

## 설치 및 실행

```bash
# 의존성 설치
flutter pub get

# 앱 실행
flutter run
```

## 의존성

```yaml
dependencies:
  flutter_svg: ^2.0.9          # SVG 아이콘 지원
  google_fonts: ^6.1.0         # Inter 폰트
  provider: ^6.1.1             # 상태 관리
  flutter_animate: ^4.5.0      # 애니메이션
  webview_flutter: ^4.4.2      # WebView 지원
```

## 장점

1. **완벽한 디자인 통일성**: Radix-UI와 동일한 시각적 언어
2. **네이티브 성능**: 순수 Flutter 위젯으로 구현
3. **확장 가능성**: 필요에 따라 새로운 컴포넌트 추가 가능
4. **타입 안전성**: Dart의 강타입 시스템 활용
5. **접근성**: Flutter의 내장 접근성 기능 활용

## 추가 구현 가능한 컴포넌트

- Dialog/Modal
- Dropdown/Select
- Checkbox/Radio
- Switch/Toggle
- Tabs
- Progress Bar
- Badge
- Avatar
- Navigation

이 구현을 통해 Radix-UI의 뛰어난 디자인을 Flutter 앱에서도 동일하게 사용할 수 있습니다.
