/* SELECT문 해석 순서
  5 : SELECT 컬럼명 AS 별칭, 계산식, 함수식
  1 : FROM 참조할 테이블명
  2 : WHERE 컬럼명 | 함수식 비교연산자 비교값
  3 : GROUP BY 그룹을 묶을 컬럼명
  4 : HAVING 그룹함수식 비교연산자 비교값
  6 : ORDER BY 컬럼명 | 별칭 | 컬럼순번 정렬방식 [NULLS FIRST | LAST];
*/

-----------------------------------------------------------------------------------------------------------------------------------------

-- * GROUP BY절 : 같은 값들이 여러개 기록된 컬럼을 가지고 같은 값들을
--              하나의 그룹으로 묶음
-- GROUP BY 컬럼명 | 함수식, ....
-- 여러개의 값을 묶어서 하나로 처리할 목적으로 사용함
-- 그룹으로 묶은 값에 대해서 SELECT절에서 그룹함수를 사용함

-- 그룹 함수는 단 한개의 결과 값만 산출하기 때문에 그룹이 여러 개일 경우 오류 발생
-- 여러 개의 결과 값을 산출하기 위해 그룹 함수가 적용된 그룹의 기준을 ORDER BY절에 기술하여 사용

-- EMPLOYEE 테이블에서 부서코드, 부서별 급여 합 조회

-- 1) 부서코드만 조회
SELECT DEPT_CODE FROM EMPLOYEE; -- 23행

-- 2) 전체 급여 합 조회
SELECT SUM(SALARY) FROM EMPLOYEE; -- 1행

SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE; --> DEPT_CODE가 같은 행 끼리 하나의 그룹이됨
-- ORA-00937: 단일 그룹의 그룹 함수가 아닙니다

-- EMPLOYEE 테이블에서
-- 직급 코드가 같은 사람의 직급코드, 급여 평균, 인원 수를
-- 직급 코드 오름 차순으로 조회

SELECT JOB_CODE, ROUND(AVG(SALARY)), COUNT(*)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- EMPLOYEE 테이블에서
-- 성별(남/여)과 각 성별 별 인원 수, 급여 합을
-- 인원 수 오름차순으로 조회
SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') 성별, COUNT(*) AS "인원 수", SUM(SALARY) AS "급여 합"
FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') -- 별칭 사용 X (별칭 해석이 아직 안됨)
ORDER BY "인원 수"; -- 별칭 사용 O (SELECT절 해석 완료)


-----------------------------------------------------------------------------------------------------------------------------------------

-- * WHERE절 GROUP BY절을 혼합하여 사용
--> WHERE절은 각 컬럼 값에 대한 조건 (SELECT문 해석 순서를 잘 기억하는 것이 중요!!)

/*
 
 5 : SELECT
 1 : FROM
 2 : WHERE
 3 : GROUP BY
 4 : HAVING
 6 : ORDER BY
 
 */

-- EMPLOYEE 테이블에서 부서코드가 D5, D6인 부서의 평균 급여, 인원 수 조회
SELECT DEPT_CODE, ROUND(AVG(SALARY)), COUNT(*) 
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6')
GROUP BY DEPT_CODE;

-- EMPLOYEE 테이블서 직급 별 2000년도 이후 입사자들의 급여 합을 조회
SELECT JOB_CODE "직급번호", SUM(SALARY) "급여 합"
FROM EMPLOYEE
WHERE HIRE_DATE >= '2000-01-01'
-- WHERE HIRE_DATE >= TO_DATE('2000-01-01') : 자동으로 데이터 형변환, 속도가 늦음
-- EXTRACT(YEAR FROM HIRE_DATE)>= 2000      : 형변환 아예 없음, 가장 효율적
-- SUBSTR(HIRE_DATE, 1, 4) >= 2000          : 형변환이 2번 일어남, 속도 제일 늦음
GROUP BY JOB_CODE
ORDER BY 1;


-----------------------------------------------------------------------------------------------------------------------------------------

-- * 여러 컬럼을 묶어서 그룹으로 지정 가능 --> 그룹내 그룹 이 가능하다!
-- *** GROUP BY 사용시 주의사항
--> SELECT문에 GROUP BY절을 사용할 경우
--  SELECT절에 명시한 조회할려면 컬럼 중
--  그룹함수가 적용되지 않은 컬럼을 
--  모두 GROUP BY절에 작성해야함.



--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------


-- * HAVING 절 : 그룹함수로 구해 올 그룹에 대한 조건을 설정할 때 사용
-- HAVING 컬럼명 | 함수식 비교연산자 비교값