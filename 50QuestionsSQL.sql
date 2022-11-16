-- Questions to test my SQL skills

--Q-1. Write an SQL query to fetch “FIRST_NAME” from Worker table using the alias name as <WORKER_NAME>.

Select first_name as worker_name from worker;

--Q-2. Write an SQL query to fetch “FIRST_NAME” from Worker table in upper case.

Select Upper(first_name) as Worker_Name from worker; 

--Q-3. Write an SQL query to fetch unique values of DEPARTMENT from Worker table.

Select distinct(Department) from Worker;
-- Select distinct Department from worker;

--Q-4. Write an SQL query to print the first three characters of  FIRST_NAME from Worker table.

Select SUBSTRING(first_name,1,3) as first_3_char from worker;

--Q-5. Write an SQL query to find the position of the alphabet (‘a’) in the first name column ‘Amitabh’ from Worker table.

select CHARINDEX('a','Amitabh') from worker;

--Q-6. Write an SQL query to print the FIRST_NAME from Worker table after removing white spaces from the right side.

Select rtrim(first_name) from worker;

--Q-7. Write an SQL query to print the DEPARTMENT from Worker table after removing white spaces from the left side.

Select ltrim(department) from worker;

--Q-8. Write an SQL query that fetches the unique values of DEPARTMENT from Worker table and prints its length.

select distinct(len(department)) from worker
--disctinct can be used on aggregate function

--Q-9. Write an SQL query to print the FIRST_NAME from Worker table after replacing ‘a’ with ‘A’.
Select replace(first_name,'a','A') from worker

--Q-10. Write an SQL query to print the FIRST_NAME and LAST_NAME from Worker table into a single column COMPLETE_NAME. A space char should separate them.
Select first_name + ' ' + last_name as complete_name from worker; 
--Select CONCAT(FIRST_NAME, ' ', LAST_NAME) AS 'COMPLETE_NAME' from Worker;
--concat probably better version

--Q-11. Write an SQL query to print all Worker details from the Worker table order by FIRST_NAME Ascending.
select * from worker
order by first_name asc

--Q-12. Write an SQL query to print all Worker details from the Worker table order by FIRST_NAME Ascending and DEPARTMENT Descending.
select * from worker
order by first_name asc,
department desc

--Q-13. Write an SQL query to print details for Workers with the first name as “Vipul” and “Satish” from Worker table.
Select * from worker
where FIRST_NAME in ('Vipul','Satish')

--Q-14. Write an SQL query to print details of workers excluding first names, “Vipul” and “Satish” from Worker table.
Select * from worker
where FIRST_NAME not in ('Vipul','Satish')

--Q-15. Write an SQL query to print details of Workers with DEPARTMENT name as “Admin”.
Select * from worker
where DEPARTMENT = 'Admin'

--Q-16. Write an SQL query to print details of the Workers whose FIRST_NAME contains ‘a’.

Select * from worker
where first_name like '%a%'

--Q-17. Write an SQL query to print details of the Workers whose FIRST_NAME ends with ‘a’.
Select * from worker
where first_name like '%a'

--Q-18. Write an SQL query to print details of the Workers whose FIRST_NAME ends with ‘h’ and contains six alphabets.
Select * from worker
where FIRST_NAME like '_____h' 

--Q-19. Write an SQL query to print details of the Workers whose SALARY lies between 100000 and 500000.
Select * from worker
where Salary between 100000 and 500000

--Q-20. Write an SQL query to print details of the Workers who have joined in Feb’2014.
Select * from Worker where year(JOINING_DATE) = 2014 and month(JOINING_DATE) = 2;

--Q-21. Write an SQL query to fetch the count of employees working in the department ‘Admin’.
Select Count(*) from worker
where DEPARTMENT = 'Admin'

--q-22 Write an SQL query to fetch worker names with salaries >= 50000 and <= 100000.
Select concat(first_name,' ', last_name), salary from worker
where salary >= 50000 and SALARY <= 100000

SELECT CONCAT(FIRST_NAME, ' ', LAST_NAME) As Worker_Name, Salary
FROM worker 
WHERE WORKER_ID IN 
(SELECT WORKER_ID FROM worker 
WHERE Salary BETWEEN 50000 AND 100000);

--Q-23. Write an SQL query to fetch the no. of workers for each department in the descending order.
select count(worker_id) as No_of_Workers, DEPARTMENT from worker
group by department
order by No_of_Workers desc

--Q-24. Write an SQL query to print details of the Workers who are also Managers.
SELECT distinct  W.*, T.WORKER_TITLE
FROM Worker W
INNER JOIN Title T
ON W.WORKER_ID = T.WORKER_REF_ID
AND T.WORKER_TITLE in ('Manager');

--Q-25. Write an SQL query to fetch duplicate records having matching data in some fields of a table.
SELECT WORKER_TITLE, AFFECTED_FROM, COUNT(*)
FROM Title
GROUP BY WORKER_TITLE, AFFECTED_FROM
HAVING COUNT(*) > 1;

select * from title

--Q-26. Write an SQL query to show only odd rows from a table.
select * from worker
where worker_id in (
select worker_id from worker
group by WORKER_ID
having WORKER_ID % 2 != 0)

--select * from Worker where worker_id%2 <> 0

--Q-28. Write an SQL query to clone a new table from another table.

select * into WorkerClone from Worker
select * from workerClone 

--Q-29. Write an SQL query to fetch intersecting records of two tables.

select * from worker intersect (select * from workerclone)

-- Write an SQL query to show records from one table that another table does not have.

select * from worker except select * from WorkerClone

--Q-31. Write an SQL query to show the current date and time.

select getDate()

--Q-32. Write an SQL query to show the top n (say 5) records of a table.
select top 5 * from worker;

--Q-33. Write an SQL query to determine the nth (say n=5) highest salary from a table.

select top 1 salary from (
	select distinct top 5 salary 
	from worker
	order by SALARY desc 
	) as result
	order by salary asc

-- correlated subquery verison. it is correlated because it uses a value from the outer query and thats why it is repeated a lot in inner query and only once in outer query
--but in a regular subquery we are using the inner query only to allow us to do the outer query. so we run once to determine answer then use it on outer. 
	SELECT Salary
FROM Worker W1
WHERE n-1 = (
 SELECT COUNT( DISTINCT ( W2.Salary ) )
 FROM Worker W2
 WHERE W2.Salary >= W1.Salary
 );


--Q-35. Write an SQL query to fetch the list of employees with the same salary.
Select distinct W.WORKER_ID, W.FIRST_NAME, W.Salary 
from Worker W, Worker W1 
where W.Salary = W1.Salary 
and W.WORKER_ID != W1.WORKER_ID;

-- two tables used to compare salary in both tables but to make sure they also have different workerid

--Q-36. Write an SQL query to show the second highest salary from a table.

--this will the max salary from the list
Select max(salary) from worker 
where SALARY not in( 
	-- it now makes us choose the second max because we dont want the 500000
	select max(salary) from worker
	)

--Q-37. Write an SQL query to show one row twice in results from a table.
select FIRST_NAME, DEPARTMENT from worker W where W.DEPARTMENT='HR' 
union all 
select FIRST_NAME, DEPARTMENT from Worker W1 where W1.DEPARTMENT='HR';


--Q-38. Write an SQL query to fetch intersecting records of two tables.

select * from worker
intersect 
select * from workerclone

--Q-39. Write an SQL query to fetch the first 50% records from a table.
select * from worker
where worker_id < (
	select count(worker_id)/2 from worker
	)
	
--Q-40. Write an SQL query to fetch the departments that have less than five people in it.
select department, count(worker_id) as 'Number of Workers' from worker
group by department
having count(worker_id) < 5

--Q-41. Write an SQL query to show all departments along with the number of people in there.
select department, count(department) as 'Number of workers' from worker
group by department


--Q-42. Write an SQL query to show the last record from a table.

select * from worker where worker_id = (select max(worker_id) from worker)

--Q-43. Write an SQL query to fetch the first row of a table.

select * from worker where worker_id = (select min(worker_id) from worker)

--Q-44. Write an SQL query to fetch the last five records from a table.
select * from worker 
where worker_id > (select count(worker_id) - 5 from worker)

--Q-45. Write an SQL query to print the name of employees having the highest salary in each department.
SELECT t.DEPARTMENT,t.FIRST_NAME,t.Salary from (
SELECT max(Salary) as TotalSalary,DEPARTMENT from Worker group by DEPARTMENT
) as TempNew 
Inner Join Worker t on TempNew.DEPARTMENT=t.DEPARTMENT 
 and TempNew.TotalSalary=t.Salary;

 --Q-46. Write an SQL query to fetch three max salaries from a table.
select distinct top 3 salary from worker
order by salary desc

SELECT distinct Salary from worker a 
WHERE 3 >= (
SELECT count(distinct Salary) from worker b 
WHERE a.Salary <= b.Salary
) order by a.Salary desc;

--Q-47. Write an SQL query to fetch three min salaries from a table.

SELECT distinct Salary from worker a WHERE 3 >= (SELECT count(distinct Salary) from worker b WHERE a.Salary >= b.Salary) order by a.Salary desc;

select distinct top 3  salary from worker 
order by salary 

--Q-48. Write an SQL query to fetch nth max salaries from a table.
select distinct salary from worker a 
where 3 >= (
select count (distinct salarY) from worker b
where a.salary <= b.salary) 
order by salary desc;

--Q-49. Write an SQL query to fetch departments along with the total salaries paid for each of them.
select sum(salary) as totalSalary, department from worker
group by department

--Q-50. Write an SQL query to fetch the names of workers who earn the highest salary.
select salary, concat(first_name,' ', last_name) as Name from worker
where salary = (select max(salary) from worker)
