# SmartCareMatch 🏥💙

요양보호사와 노인을 위한 지능형 매칭 시스템

## 📋 프로젝트 개요

SmartCareMatch는 요양이 필요한 고령자(수요자)와 요양보호사를 효율적으로 연결하는 플랫폼 서비스입니다. 지리적 위치를 기반으로 한 스마트 매칭 알고리즘을 통해 최적의 케어서비스 매칭을 제공합니다.

## 🏗️ 시스템 아키텍처

### 전체 아키텍처 다이어그램

```
┌─────────────────┐    ┌─────────────────┐
│   Flutter App   │    │   Center Web    │
│  (Mobile/Web)   │    │   Dashboard     │
└─────────┬───────┘    └─────────┬───────┘
          │                      │
          │                      │
          └──────────────────────┼──────────────────────┐
                                 │                      │
         ┌─────────────────────────────────────────┐    │
         │           API Gateway/LB                │    │
         └─────────────────┬───────────────────────┘    │
                           │                            │
     ┌─────────────────────┼─────────────────────┐      │
     │                     │                     │      │
┌────▼────┐          ┌─────▼──────┐        ┌─────▼──────┐
│Spring   │          │FastAPI     │        │PostgreSQL │
│Boot API │◄────────►│Matching    │◄──────►│Database    │
│Server   │          │Service     │        │            │
│(8000)   │          │(8001)      │        │(5432)     │
└─────────┘          └────────────┘        └─────────▲──┘
                                                     │
                                            ┌────────▼───┐
                                            │pgAdmin     │
                                            │(5050)      │
                                            └────────────┘
```

### 주요 컴포넌트

| 컴포넌트 | 기술 스택 | 포트 | 역할 |
|---------|----------|------|------|
| **Frontend App** | Flutter 3.8+ | - | 모바일/웹 클라이언트 |
| **Admin Dashboard** | Remix + React | 3000 | 요양센터 관리 대시보드 |
| **Backend API** | Spring Boot 3.5 + Java 21 | 8000 | 메인 비즈니스 로직 |
| **Matching Service** | FastAPI + Python | 8001 | 스마트 매칭 알고리즘 |
| **Database** | PostgreSQL 15 | 5432 | 데이터 저장소 |
| **DB Admin** | pgAdmin 4 | 5050 | 데이터베이스 관리 |

## 📱 모듈별 상세 설명

### 1. Frontend App (`homecare_app/`)

**기술 스택:**
- Flutter 3.8.1
- Provider (상태 관리)
- Google Fonts (디자인 시스템)
- Flutter Secure Storage (보안 저장소)

**주요 기능:**
- 🔐 사용자 인증 (로그인/회원가입)
- 🏠 홈 화면 및 대시보드
- 📋 서비스 요청 등록
- 👩‍⚕️ 요양보호사 선택 및 확정
- 📅 스케줄 관리

**디자인 시스템:**
- Radix UI 기반 커스텀 컴포넌트
- 일관된 색상 팔레트 (RadixTokens)

### 2. Admin Dashboard (`homecare_admin/`)

**기술 스택:**
- Remix 2.16.8 (React 메타프레임워크)
- React 18.2
- Radix UI Themes 3.2
- TailwindCSS 3.4
- TypeScript 5.1
- Vite 6.0 (빌드 도구)

**주요 기능:**
- 📊 **현황판 (Dashboard)**: 요양센터 전체 현황 및 통계
  - 실시간 매칭 현황
  - 요양보호사 활동 상태
  - 서비스 요청 및 완료 통계
- 👩‍⚕️ **요양보호사 관리**: 직원 프로필 및 일정 관리
  - 요양보호사 등록/수정/삭제
  - 자격증 및 교육 이력 관리
  - 근무 상태 및 가용시간 설정
- 📅 **캘린더 관리**: 스케줄 및 근무 일정 관리
  - 월별/일별 스케줄 조회
  - 매칭 결과 확인 및 수정
  - 근무 일정 배정 및 변경

**특징:**
- 🎨 Radix UI 기반 일관된 디자인 시스템
- 📊 실시간 데이터 시각화
- 📁 엑셀/이미지 파일 내보내기 기능
- 🔒 센터별 권한 관리

### 3. Backend API (`homecare_BE/`)

**기술 스택:**
- Spring Boot 3.5.3
- Java 21
- Spring Data JPA + QueryDSL
- MapStruct (객체 매핑)
- PostgreSQL Driver
- Swagger/OpenAPI 3

**도메인 구조:**
```
├── caregiver/          # 요양보호사 관리
├── caregiverBlacklist/ # 블랙리스트 관리
├── center/             # 요양센터 관리
├── consumer/           # 수요자(고객) 관리
├── match/              # 매칭 결과 관리
├── matchReview/        # 매칭 리뷰 관리
├── serviceMatch/       # 서비스 매칭 관리
├── serviceRequest/     # 서비스 요청 관리
├── users/              # 공통 사용자 관리
├── WorkLog/            # 근무 기록 관리
└── WorkMatch/          # 근무 매칭 관리
```

**주요 엔티티:**
- **User**: 공통 사용자 정보
- **Caregiver**: 요양보호사 프로필 (위치, 가용시간, 서비스 유형)
- **Consumer**: 수요자 정보
- **ServiceRequest**: 서비스 요청 (위치, 선호시간, 서비스 유형)
- **ServiceMatch**: 매칭 결과
- **WorkLog**: 근무 기록

**API 엔드포인트 주요 그룹:**
- `/api/user/*` - 사용자 인증 및 프로필
- `/api/consumer/*` - 수요자 서비스 요청 및 관리
- `/api/center/*` - 요양센터 및 요양보호사 관리
- `/api/match/*` - 매칭 알고리즘 호출
- `/api/workLog/*` - 근무 기록 관리

### 4. Matching Service (`homecare_matching/`)

**기술 스택:**
- FastAPI 0.116.1
- Pydantic 2.11.7 (데이터 검증)
- Uvicorn (ASGI 서버)

**매칭 알고리즘:**
**거리 기반 매칭**
   - Haversine 공식을 이용한 정확한 거리 계산
   - 지구의 곡률을 고려한 실제 거리 측정
   - 최근접 5명의 요양보호사 추천

**API 엔드포인트:**
- `POST /matching/recommend` - 매칭 추천
- `GET /health-check` - 서비스 상태 확인

### 5. Infrastructure (`homecare_infra/`)

**Docker Compose 구성:**
- 멀티 컨테이너 오케스트레이션
- 서비스 간 네트워크 연결
- 볼륨 퍼시스턴스
- 헬스체크 기능