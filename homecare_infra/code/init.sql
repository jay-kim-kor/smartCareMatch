-- PostgreSQL 초기화 스크립트
-- 홈케어 매칭 서비스를 위한 기본 데이터베이스 설정

-- UTF-8 인코딩 설정
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

-- 타임존 설정
SET timezone = 'Asia/Seoul';

-- 기본 익스텐션 설치
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 로그 출력
\echo 'Homecare Database initialized successfully!'
\echo 'Database: homecare_db'
\echo 'User: homecare_user'
\echo 'Timezone: Asia/Seoul'
\echo 'Encoding: UTF8'