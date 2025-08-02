# System Architecture

## 개요
홈케어 시스템의 전체 시스템 아키텍처는 Kubernetes 클러스터 기반으로 구성되며, Master Node와 Worker Node로 분리된 구조를 가집니다.

## 시스템 구성도

```
┌─────────────────────────────────────────────────────────────┐
│                    Kubernetes Cluster                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────────┐         ┌──────────────────────────┐  │
│  │   Master Node    │◀──────▶│      Worker Node          │  │
│  │      (MSI)       │         │      (Desktop)           │  │
│  │                  │         │                          │  │
│  │ ┌──────────────┐ │         │ ┌──────────────────────┐ │  │
│  │ │   Control    │ │         │ │   Matching Service   │ │  │
│  │ │    Plane     │ │         │ │                      │ │  │
│  │ │              │ │         │ └──────────────────────┘ │  │
│  │ │ • API Server │ │         │                          │  │
│  │ │ • etcd       │ │         │ ┌──────────────────────┐ │  │
│  │ │ • Scheduler  │ │         │ │   Backend Service    │ │  │
│  │ │ • Controller │ │         │ │                      │ │  │
│  │ └──────────────┘ │         │ └──────────────────────┘ │  │
│  └──────────────────┘         │                          │  │
│                               │ ┌──────────────────────┐ │  │
│                               │ │  Frontend Service    │ │  │
│                               │ │     (React)          │ │  │
│                               │ └──────────────────────┘ │  │
│                               └──────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
                ┌────────────────────────────┐
                │     Personal Devices       │
                │                            │
                │  ┌──────────────────────┐  │
                │  │    Flutter App       │  │
                │  │   (Mobile/Tablet)    │  │
                │  └──────────────────────┘  │
                └────────────────────────────┘
```

## 구성 요소

### 1. Master Node (MSI 노트북)
- **역할**: Kubernetes 클러스터의 제어 평면 관리
- **하드웨어**: MSI 노트북
- **주요 구성 요소**:

#### Kubernetes Control Plane
- **API Server**: 
  - 클러스터의 모든 API 요청 처리
  - 인증 및 권한 부여 담당
- **etcd**: 
  - 클러스터 상태 및 설정 정보 저장
  - 분산 키-값 저장소
- **Scheduler**: 
  - Pod를 적절한 노드에 배치하는 스케줄링 담당
- **Controller Manager**: 
  - 다양한 컨트롤러를 통해 클러스터 상태 관리
  - Deployment, Service 등의 리소스 관리

### 2. Worker Node (Desktop)
- **역할**: 실제 애플리케이션 서비스 실행
- **하드웨어**: Desktop 컴퓨터
- **주요 서비스**:

#### Matching Service
- **기능**: 홈케어 서비스 제공자와 이용자 간의 매칭 로직
- **구성**: 
  - 매칭 알고리즘 엔진
  - 사용자 위치 기반 서비스
  - 실시간 매칭 처리
- **배포**: Kubernetes Deployment로 관리

#### Backend Service
- **기능**: 홈케어 시스템의 핵심 비즈니스 로직 처리
- **구성**:
  - REST API 서버
  - 데이터베이스 연동
  - 사용자 인증 및 권한 관리
  - 예약 및 결제 처리
- **배포**: Kubernetes Deployment로 관리

#### Frontend Service (React)
- **기능**: 웹 기반 사용자 인터페이스 제공
- **구성**:
  - React 기반 SPA (Single Page Application)
  - 반응형 웹 디자인
  - 실시간 상태 업데이트
- **배포**: Kubernetes Deployment로 관리
- **노출**: NodePort 또는 LoadBalancer를 통한 외부 접근

### 3. Personal Devices
- **구성**: 개인 모바일 기기 및 태블릿
- **설치 방식**: 개별 단말기에 직접 설치

#### Flutter App
- **플랫폼**: iOS, Android 멀티플랫폼
- **기능**:
  - 홈케어 서비스 예약 및 관리
  - 실시간 서비스 상태 확인
  - 사용자 프로필 관리
  - 푸시 알림 수신
- **연동**: Backend Service API를 통한 데이터 통신

## 서비스 간 통신

### 내부 통신 (Cluster 내부)
- **Matching Service ↔ Backend Service**: Kubernetes Service를 통한 내부 통신
- **Frontend Service ↔ Backend Service**: HTTP/HTTPS 기반 API 통신
- **Master Node ↔ Worker Node**: Kubernetes 내부 통신 프로토콜

### 외부 통신
- **Flutter App ↔ Backend Service**: HTTPS API 통신
- **Web Browser ↔ Frontend Service**: HTTPS 웹 서비스

## 배포 및 관리

### 컨테이너화
- **모든 서비스**: Docker 컨테이너로 패키징
- **이미지 저장소**: Docker Hub 또는 Private Registry 활용

### Kubernetes 리소스
- **Deployments**: 각 서비스의 배포 및 스케일링 관리
- **Services**: 서비스 간 통신을 위한 네트워크 추상화
- **ConfigMaps/Secrets**: 설정 정보 및 민감 정보 관리
- **Ingress**: 외부 트래픽 라우팅 (필요시)

### 모니터링 및 로깅
- **클러스터 모니터링**: Kubernetes 리소스 상태 감시
- **애플리케이션 로깅**: 각 서비스별 로그 수집 및 분석
- **성능 모니터링**: 서비스별 메트릭 수집

## 확장성 및 가용성

### 수평 확장 (Horizontal Scaling)
- **Pod 레플리카**: 트래픽 증가에 따른 Pod 인스턴스 확장
- **노드 확장**: 추가 Worker Node 확장 가능

### 고가용성 (High Availability)
- **서비스 복제**: 중요 서비스의 다중 인스턴스 운영
- **헬스 체크**: Kubernetes Liveness/Readiness Probe 활용
- **롤링 업데이트**: 무중단 서비스 업데이트

### 백업 및 복구
- **etcd 백업**: 클러스터 상태 정기 백업
- **데이터베이스 백업**: 애플리케이션 데이터 백업 전략
- **재해 복구**: 시스템 장애 시 복구 절차

## 보안 고려사항

### 클러스터 보안
- **RBAC**: 역할 기반 접근 제어
- **Network Policies**: 네트워크 트래픽 제어
- **Pod Security**: 컨테이너 보안 정책

### 애플리케이션 보안
- **TLS/SSL**: 모든 외부 통신 암호화
- **API 보안**: 인증 토큰 기반 API 접근 제어
- **데이터 암호화**: 민감 정보 저장 시 암호화

## 개발 및 운영 워크플로우

### CI/CD 파이프라인
- **소스 코드 관리**: Git 기반 버전 관리
- **자동화된 빌드**: Docker 이미지 자동 생성
- **배포 자동화**: Kubernetes 리소스 자동 배포

### 환경 분리
- **개발 환경**: 로컬 개발 및 테스트
- **스테이징 환경**: 배포 전 통합 테스트
- **프로덕션 환경**: 실제 서비스 운영 