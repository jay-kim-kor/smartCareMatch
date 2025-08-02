# Network Architecture

## 개요
홈케어 시스템의 네트워크 아키텍처는 ISP로부터 시작하여 Kubernetes 클러스터까지의 전체 네트워크 구성을 다룹니다.

## 네트워크 구성도

```
ISP (인터넷 서비스 제공자)
    ↓
단자함 (통신 단자함)
    ↓
공유기 (홈 라우터)
    ├── MSI (Kubernetes Master Node)
    └── Desktop (Kubernetes Worker Node)
```

## 구성 요소

### 1. ISP (Internet Service Provider)
- **역할**: 인터넷 연결 제공
- **설명**: 외부 인터넷과의 연결을 담당하는 통신사 인프라

### 2. 단자함 (Network Terminal Box)
- **역할**: ISP와 가정 내 네트워크 간의 물리적 연결점
- **설명**: 통신사에서 제공하는 인터넷 신호를 가정 내로 전달하는 중계점

### 3. 공유기 (Home Router)
- **역할**: 홈 네트워크의 중앙 허브
- **기능**:
  - DHCP 서버 (IP 주소 할당)
  - NAT (Network Address Translation)
  - 방화벽
  - WiFi 액세스 포인트
- **설명**: 단일 인터넷 연결을 여러 디바이스가 공유할 수 있도록 하는 네트워크 장비

### 4. MSI (Kubernetes Master Node)
- **역할**: Kubernetes 클러스터의 제어 평면
- **주요 기능**:
  - API Server
  - etcd (클러스터 상태 저장소)
  - Controller Manager
  - Scheduler
- **네트워크 설정**: 공유기로부터 고정 IP 할당 권장

### 5. Desktop (Kubernetes Worker Node)
- **역할**: 실제 워크로드가 실행되는 노드
- **주요 기능**:
  - kubelet (노드 에이전트)
  - kube-proxy (네트워크 프록시)
  - Container Runtime
- **네트워크 설정**: 공유기로부터 IP 할당 (고정 IP 권장)

## 네트워크 설정 권장사항

### IP 주소 할당 방식
- **공유기 네트워크 대역**: 비공개
- **MSI (Master Node)**: 고정 IP 
- **Desktop (Worker Node)**: 고정 IP

### 보안 설정
- 공유기 방화벽에서 필요한 포트만 개방
- Kubernetes 노드 간 통신을 위한 내부 네트워크 보안 설정
- 외부 접근이 필요한 서비스는 NodePort 또는 LoadBalancer 타입으로 노출

## 네트워크 흐름

1. **외부 인터넷 접근**: `ISP → 단자함 → 공유기 → Kubernetes Nodes`
2. **노드 간 통신**: `MSI ↔ Desktop` (내부 네트워크를 통한 직접 통신)
3. **서비스 접근**: `외부 클라이언트 → 공유기 → Worker Node → Pod`

## 확장성 고려사항

향후 시스템 확장 시 고려할 사항:
- 추가 Worker Node 확장 가능성 (07.24 기준 여분 1대 Desktop 보유)
- 로드 밸런서 도입
- 네트워크 보안 강화 (VPN, 네트워크 정책 등)
- 모니터링 및 로깅 시스템 구축 