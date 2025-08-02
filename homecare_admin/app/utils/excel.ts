import * as XLSX from 'xlsx';
import pkg from 'file-saver';
const { saveAs } = pkg;
import { Caregiver } from '../data/caregivers';

// 엑셀 파일 생성 및 다운로드 함수
export const exportToExcel = (
  data: Record<string, string | number>[],
  filename: string,
  sheetName: string = 'Sheet1'
) => {
  try {
    // 워크북 생성
    const workbook = XLSX.utils.book_new();
    
    // 워크시트 생성
    const worksheet = XLSX.utils.json_to_sheet(data);
    
    // 워크시트를 워크북에 추가
    XLSX.utils.book_append_sheet(workbook, worksheet, sheetName);
    
    // 엑셀 파일 생성
    const excelBuffer = XLSX.write(workbook, { 
      bookType: 'xlsx', 
      type: 'array' 
    });
    
    // Blob 생성
    const blob = new Blob([excelBuffer], { 
      type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' 
    });
    
    // 파일 다운로드
    saveAs(blob, `${filename}.xlsx`);
    
    return true;
  } catch (error) {
    console.error('엑셀 파일 생성 중 오류 발생:', error);
    return false;
  }
};

// 날짜 포맷팅 함수
export const formatDateForExcel = (dateString: string): string => {
  try {
    const date = new Date(dateString);
    return date.toLocaleDateString('ko-KR', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit'
    });
  } catch {
    return dateString;
  }
};

// 통화 포맷팅 함수
export const formatCurrencyForExcel = (amount: number): string => {
  return new Intl.NumberFormat('ko-KR').format(amount);
};

// 요양보호사 데이터를 엑셀 형식으로 변환
export const convertCaregiversToExcelData = (caregivers: Caregiver[]): Record<string, string>[] => {
  return caregivers.map(caregiver => ({
    '이름': caregiver.name,
    '전화번호': caregiver.phone,
    '상태': caregiver.status,
    '근무유형': caregiver.workTypes.join(', '),
    '등록일': formatDateForExcel(caregiver.joinDate),
    '이메일': caregiver.email || '',
    '생년월일': caregiver.birthDate ? formatDateForExcel(caregiver.birthDate) : '',
    '주소': caregiver.address || '',
    '자격증번호': caregiver.licenseNumber || '',
    '자격증취득일': caregiver.licenseDate ? formatDateForExcel(caregiver.licenseDate) : '',
    '교육이수': caregiver.education || '',
    '시급': caregiver.hourlyWage ? formatCurrencyForExcel(caregiver.hourlyWage) : '',
    '근무지역': caregiver.workArea || ''
  }));
};

// 현재 날짜로 파일명 생성
export const generateFilename = (prefix: string): string => {
  const now = new Date();
  const dateStr = now.toISOString().split('T')[0]; // YYYY-MM-DD 형식
  return `${prefix}_${dateStr}`;
}; 