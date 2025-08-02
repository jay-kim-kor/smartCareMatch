# Homecare Docker Compose

홈케어 매칭 서비스의 Docker Compose 설정입니다.

## 서비스 구성

- **matching-api**: FastAPI 기반 매칭 API 서버 (`http://localhost:8000`)
- **postgres**: PostgreSQL 데이터베이스 서버 (`http://localhost:5432`)
- **pgadmin**: PostgreSQL 관리 도구 (`http://localhost:5050`) - 선택사항

## 사용법

### 1. 서비스 시작
```bash
# 백그라운드에서 모든 서비스 실행
docker-compose up -d

# 또는 포그라운드에서 로그 확인하며 실행
docker-compose up
```

### 2. 서비스 중지
```bash
docker-compose down
```

### 3. 데이터와 함께 완전 삭제
```bash
docker-compose down -v
```

### 4. 로그 확인
```bash
# 모든 서비스 로그
docker-compose logs -f

# 특정 서비스 로그
docker-compose logs -f matching-api
docker-compose logs -f postgres
```

## 접속 정보

### PostgreSQL 데이터베이스
- **Host**: localhost (외부) / postgres (컨테이너 내부)
- **Port**: 5432
- **Database**: homecare_db
- **User**: homecare_user
- **Password**: homecare_password

### pgAdmin 웹 인터페이스
- **URL**: http://localhost:5050
- **Email**: admin@homecare.com
- **Password**: admin123

### Matching API
- **URL**: http://localhost:8000
- **API 문서**: http://localhost:8000/docs (Swagger UI)

## 주의사항
1. **환경변수 설정**
   
   매칭 API 코드에서 다음 환경변수를 사용할 수 있습니다:
   - `DATABASE_URL`: postgresql://homecare_user:homecare_password@postgres:5432/homecare_db

2. **데이터 영속성**
   
   PostgreSQL 데이터는 Docker 볼륨(`postgres_data`)에 저장되어 컨테이너 재시작 시에도 유지됩니다.

## 개발 환경 설정

로컬 개발 시에는 다음과 같이 환경변수를 설정하세요:

```bash
export DATABASE_URL="postgresql://homecare_user:homecare_password@localhost:5432/homecare_db"
```