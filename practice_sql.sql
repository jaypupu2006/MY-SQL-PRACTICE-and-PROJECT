-- BEGINNER --

SELECT * 
FROM parks_and_recreation.employee_demographics;

SELECT first_name,
	   last_name,
	   birth_date,
       age,
       (age + 10) * 10 + 10
FROM parks_and_recreation.employee_demographics;
# PEMDAS


SELECT DISTINCT first_name , gender
FROM parks_and_recreation.employee_demographics;


-- WHERE CLAUSE

SELECT *
FROM employee_demographics
WHERE gender = 'Female';

-- AND OR NOT -- Logical operator

SELECT *
FROM employee_demographics
WHERE gender = 'Male'
OR birth_date > '1985-01-01'
;


SELECT *
FROM employee_demographics
WHERE (first_name = 'Leslie' AND age = 44 )  OR age > 45
;

-- LIKE statement 
-- % คือ อะไรก็ได้ กับ  _  คือ  _ตัวต่อจากนั้น
SELECT *
FROM employee_demographics
WHERE first_name LIKE '%er__'
;


SELECT *
FROM employee_demographics
WHERE first_name = 'April'
;

-- GROUP BY 

SELECT gender , AVG(age) , MAX(age) , MIN(age) , COUNT(age)
FROM employee_demographics
group by gender
;


SELECT occupation , salary
FROM employee_salary
group by occupation , salary
;


-- ORDER BY
-- ASC a-z
-- DESC

SELECT *
FROM employee_demographics
ORDER BY gender DESC , age 
;

-- หรือ ใช้ ตำแหน่ง collum

SELECT *
FROM employee_demographics
ORDER BY 5 DESC , 4 
;

-- HAVING vs WHERE

SELECT gender , AVG(age)
FROM employee_demographics
GROUP BY gender
# WHERE AVG(age) > 40
HAVING AVG(age) > 40
;


SELECT occupation , AVG(salary)
FROM employee_salary
WHERE occupation like '%manager%'
GROUP BY occupation
HAVING AVG(salary) > 75000
;

-- Limit และ  Aliasing
SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 3 ## จำกัด 3 แถว
## LIMIT 2 , 1 ## ข้าม1แถว แล้วแสดงผลแถวที่ 2 จากนั้น
;

-- ALIASING เปลี่ยนหัวข้อ

SELECT gender , AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 40
;

-- INTERMEDIATE --

-- Joins

SELECT *
FROM employee_demographics
;

SELECT *
FROM employee_salary
;

-- INNER JOINS
--  เลือกอันที่เหมือน  --
# 2 หายไปไหน
SELECT *
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;


-- Outer Joins

-- LEft Joins ตือ FROM
-- ยึดตารางใน from เป็นหลัก
SELECT *
FROM employee_demographics AS dem
LEFT JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;

-- right Joins คือ JOIn
-- ยึดตารางใน joins เป็นหลัก
SELECT *
FROM employee_demographics AS dem
RIGHT JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;




-- SELF JOIN
-- เทียบข้อมูลในตารางเดียวกัน เลือกดูแค่ id fnamne lname
SELECT emp1.employee_id AS emp_santa,
emp1.first_name AS first_name_santa,
emp1.last_name AS last_name_santa,
emp2.employee_id AS emp_name,
emp2.first_name AS first_name_emp,
emp2.last_name AS last_name_emp
FROM employee_salary AS emp1
JOIN employee_salary AS emp2
	ON emp1.employee_id + 1 = emp2.employee_id
;

-- joining multiple table together

SELECT *
FROM parks_departments
;
-- joins 3 ตาราง 
SELECT *
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
INNER JOIN parks_departments AS pd
	ON sal.dept_id = pd.department_id
;





-- Unions
-- เอาตารางมาต่อข้างล่าง

SELECT first_name, last_name
FROM employee_demographics
# UNION DISTINCT
UNION ALL
SELECT first_name, last_name
FROM employee_salary
;

## EXAMPLE				
-- first table
SELECT first_name, last_name , 'Old Male' AS Lable
FROM employee_demographics
WHERE age > 40 AND gender = 'Male'
UNION
-- second table
SELECT first_name, last_name , 'Old Female' AS Lable
FROM employee_demographics
WHERE age > 40 AND gender = 'Female'
UNION
-- last table
SELECT first_name, last_name , 'HIghly Paid Employee' AS Lable
FROM employee_salary
WHERE salary > 70000
ORDER BY first_name, last_name
;


-- String function

-- หาความยาวตัวอักษร
SELECT LENGTH('skyfall');

SELECT first_name , LENGTH(first_name)
FROM employee_demographics
ORDER BY 2;
;

-- UPPER เปลี่ยนเป็น พิมพ์ใหญ่
-- LOWER เปลี่ยนเป็น พิมพ์เล็ก
SELECT UPPER('sky');
SELECT LOWER('SKY');

SELECT first_name , UPPER(first_name)
FROM employee_demographics
;

-- trim = ลบ ' ' ออก
SELECT TRIM('            sky           ');
SELECT LTRIM('            sky           ');
SELECT RTRIM('            sky           ');

-- ลอง run ดูเลย
SELECT first_name, LEFT(first_name , 4) , RIGHT(first_name , 4) , SUBSTRING(first_name,3,2) ,
       birth_date , SUBSTRING(birth_date,6,2) AS birth_month
FROM employee_demographics
;

-- เปลี่่ยนจาก  a เป็น z
SELECT first_name , REPLACE(first_name, 'a' , 'z' )
FROM employee_demographics
;

-- x เป็นตัวที่เท่าไหร่
SELECT LOCATE('x' , 'Alexander')
;

SELECT first_name , LOCATE('An' , first_name)
FROM employee_demographics
;

-- รวม 2 collum
SELECT first_name , last_name , CONCAT( first_name , ' ' , last_name ) AS full_name
FROM employee_demographics
;



-- CASE STATEMANT = if/else ใน SQL

SELECT first_name,
last_name,
age,
CASE
	WHEN age <= 30 THEN 'YOUNG'
    WHEN age BETWEEN 31 AND 50 THEN 'OLD'
    WHEN age >= 50 THEN "ON DEATH'S DOOR"
END AS AGE_BRACKET
FROM employee_demographics
;

## EXAMPLE
-- Pay increase and bonus
-- < 50000 = 5%
-- > 50000 = 7%
-- Finance = 10% bonus

SELECT first_name , last_name , salary,
CASE 
	WHEN salary < 50000 THEN salary + (salary * 0.05)
    WHEN salary > 50000 THEN salary + (salary * 0.07)
    WHEN salary = 50000 THEN 50000
END AS New_Salary,
CASE 
	WHEN dept_id = 6 THEN salary * .10
END AS Bonus
FROM employee_salary
;


-- Subqueries -- เลือกในวงเล็บแล้วเลือกข้างนอก

-- เลือก emp_salary.TB ที่มี dpt_id เป็น 1 // คำสั่งในวงเล็บ
-- เลือก emp_dem.TB ที่มี emp_id ตามตารางข้างบน  
SELECT *
FROM employee_demographics
WHERE employee_id IN (
					SELECT employee_id
					FROM employee_salary
					WHERE dept_id = 1)
;

-- EXAMPLE
SELECT first_name , salary , AVG(salary),
-- sebsequence 
(SELECT AVG(salary)
FROM employee_salary)
FROM employee_salary
GROUP BY first_name , salary
ORDER BY salary
;

-- EXAMPLE
-- เอาตารางที่ 1 มาเป็น SUBSEQUENCE ของ ตารางที่ 2
SELECT gender , AVG(age) , MAX(age) , MIN(age) , COUNT(age)
FROM employee_demographics
GROUP BY gender
;

SELECT AVG(max_age)
FROM 
(SELECT gender , 
AVG(age) AS avg_age , 
MAX(age) AS max_age, 
MIN(age) AS min_age, 
COUNT(age)
FROM employee_demographics
GROUP BY gender ) AS Agg_table
;


-- WINDOW FUNCTION

 SELECT gender , AVG(salary) AS avg_salary
 FROM employee_demographics dem
 JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
;

-- OVER ใช้แตก avg ที่ปกติจะมาแค่ 1 แถว(error) ให้ออกทุกแถว
 SELECT gender , AVG(salary) OVER()
 FROM employee_demographics dem
 JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
;

-- partition by ใช้แยกประเภท ในที่นี้คือ gender
SELECT dem.first_name , dem.last_name , gender , AVG(salary) OVER(PARTITION BY gender)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
;

-- จาก avg เป๋น sum พอใส่ order by ไปด้วยทำให้เป็นการทบจำนวนเงินก่อนหน้า
SELECT dem.employee_id , dem.first_name , dem.last_name , gender , salary ,
SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) AS ROlling_total
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
;


SELECT dem.employee_id , dem.first_name , dem.last_name , gender , salary ,
-- ROW number ใช้ระบุว่าเป็นแถวที่เท่าไหร่
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num,
-- RANK เป็นการจัดอันดับ ถ้าเท่ากัน เท่ากับอันดับเดียวกัน แต่จะข้ามเลขต่อไปด้วย
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_num,
-- DENSE RANK คือ การจัดอันดับ แต่จะไม่ข้ามเลขต่อไป
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS densse_rank_num
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
;



-- ADVANCE --

-- CTE = common table exxpression ทำให้อ่านง่ายและเอามาใช้ง่าย

## EXAMPLE 1
WITH CTE_Example (GEnder , AVGSAL , MAXSAL , MINSAL , COUNT) AS
(
SELECT gender , AVG(salary) avg_sal , MAX(salary) max_sal , MIN(salary) min_sal , COUNT(salary) count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	on dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT *
FROM CTE_Example
;
--  แบบ subsequence
SELECT AVG(avg_sal)
FROM (
SELECT gender , AVG(salary) avg_sal , MAX(salary) max_sal , MIN(salary) min_sal , COUNT(salary) count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	on dem.employee_id = sal.employee_id
GROUP BY gender
) AS example_subquerry
;

## EXAMPLE 2
WITH CTE_Example AS
(
SELECT employee_id , gender , birth_date
FROM employee_demographics
WHERE birth_date > '1985-01-01'
),
CTE_Example2 AS
(
SELECT employee_id , salary
FROM employee_salary
WHERE salary > 50000
)
SELECT *
FROM CTE_Example
JOIN CTE_EXample2
	ON CTE_Example.employee_id = CTE_Example2.employee_id
ORDER BY salary
;


-- Temporary Table เป็น tableชั่วคราว พอปิดแล้วจะหายไป

#fist ex
CREATE TEMPORARY TABLE temp_table
(
first_name varchar(50),
last_name varchar(50),
favorite_movie varchar(100)
)
;

INSERT INTO temp_table
VALUES('jay','pupu','avoogers')
;

SELECT *
FROM temp_table;

#second ex
SELECT *
FROM employee_salary;

CREATE TEMPORARY TABLE salary_over_50k
SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT *
FROM salary_over_50k;


-- stored procedures กลุ่มของคำสั่ง SQL ที่เขียนเก็บไว้ในฐานข้อมูล และสามารถเรียกใช้งานซ้ำ ๆ ได้ เปรียบเสมือน “ฟังก์ชัน” หรือ “สูตรสำเร็จ” ที่เราสามารถเรียกใช้เมื่อไหร่ก็ได้


SELECT *
FROM employee_salary
WHERE salary >= 50000;

-- เอาข้อมูลข้างบนมาใส่ใน procedure
CREATE PROCEDURE large_salaries()
SELECT *
FROM employee_salary
WHERE salary >= 50000;

CALL large_salaries();

-- คนโหด
DELIMITER $$ 
CREATE PROCEDURE large_salaries3()
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >= 50000;
	SELECT *
	FROM employee_demographics
	WHERE age >= 25;
END $$
DELIMITER ;

CALL large_salaries3();


DELIMITER $$ 
CREATE PROCEDURE large_salaries41(p_employee_id int)
BEGIN
	SELECT salary
	FROM employee_salary
	WHERE employee_id = p_employee_id	
    ;
END $$
DELIMITER ;

CALL large_salaries41(1);

-- ลบ stored procedure ที่มีชีอยู่--
DROP PROCEDURE IF EXISTS large_salaries3;


-- TRIGGER and EVENT ระบบอัตโนมัติเมื่อเกิดเหตุการบางอย่าง

-- TRIGGER
SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW 
BEGIN
	INSERT INTO employee_demographics (employee_id , first_name , last_name) 
	VALUES (NEW.employee_id , NEW.first_name , NEW.last_name);
END $$
DELIMITER ;

-- test --
INSERT INTO employee_salary(employee_id , first_name , last_name , occupation , salary , dept_id)
VALUES(13 , 'jay' , 'pupu' , 'fucking number one of programing skill'  ,100000 , NULL)
;

DROP TRIGGER IF EXISTS employee_insert;

-- EVENTS

SELECT *
FROM employee_demographics;

DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 10 SECOND
DO
BEGIN
	DELETE
	FROM employee_demographics
	WHERE age >= 60;
END $$
DELIMITER ;

SHOW VARIABLES LIKE 'event%'; 

DROP EVENT IF EXISTS delete_retirees;


























