use org;


CREATE TABLE Worker (
	WORKER_ID INT NOT NULL PRIMARY KEY identity(1,1),
	FIRST_NAME CHAR(25),
	LAST_NAME CHAR(25),
	SALARY INT,
	JOINING_DATE DATETIME,
	DEPARTMENT CHAR(25)
);

SET IDENTITY_INSERT Worker ON

--set identity allows user to insert into the identity column which is the worker id
-- then  you turn off when it is done

INSERT INTO Worker 
	(WORKER_ID, FIRST_NAME, LAST_NAME, SALARY, JOINING_DATE, DEPARTMENT) VALUES
		(001, 'Monika', 'Arora', 100000, convert(datetime,'14-02-20 09:00:00 AM',5), 'HR'),
		(002, 'Niharika', 'Verma', 80000, convert(datetime,'14-06-11 09:00:00 AM',5), 'Admin'),
		(003, 'Vishal', 'Singhal', 300000, convert(datetime,'14-02-20 09:00:00 AM',5), 'HR'),
		(004, 'Amitabh', 'Singh', 500000, convert(datetime,'14-02-20 09:00:00 AM',5), 'Admin'),
		(005, 'Vivek', 'Bhati', 500000, convert(datetime,'14-06-11 09:00:00 AM',5), 'Admin'),
		(006, 'Vipul', 'Diwan', 200000, convert(datetime,'14-06-11 09:00:00 AM',5), 'Account'),
		(007, 'Satish', 'Kumar', 75000, convert(datetime,'14-01-20 09:00:00 AM',5), 'Account'),
		(008, 'Geetika', 'Chauhan', 90000, convert(datetime,'14-04-11 09:00:00 AM',5), 'Admin');

SET IDENTITY_INSERT Worker off


CREATE TABLE Bonus (
	WORKER_REF_ID INT,
	BONUS_AMOUNT INT,
	BONUS_DATE date,
	FOREIGN KEY (WORKER_REF_ID)
		REFERENCES Worker(WORKER_ID)
        ON DELETE CASCADE
		--on cascade means when parent table deleted so will the child table
);

INSERT INTO Bonus 
	(WORKER_REF_ID, BONUS_AMOUNT, BONUS_DATE) VALUES
	-- 5 is the style for dd-mm-yy
		(001, 5000, convert(date,'16-02-20',5)),
		(002, 3000, convert(date,'16-06-11',5)),
		(003, 4000, convert(date,'16-02-20',5)),
		(001, 4500, convert(date,'16-02-20',5)),
		(002, 3500, convert(date,'16-06-11', 5));

use org

CREATE TABLE Title (
	WORKER_REF_ID INT,
	WORKER_TITLE CHAR(25),
	AFFECTED_FROM DATETIME,
	FOREIGN KEY (WORKER_REF_ID)
		REFERENCES Worker(WORKER_ID)
        ON DELETE CASCADE
);

INSERT INTO Title 
	(WORKER_REF_ID, WORKER_TITLE, AFFECTED_FROM) VALUES
 (001, 'Manager', '2016-02-20 00:00:00'),
 (002, 'Executive', '2016-06-11 00:00:00'),
 (008, 'Executive', '2016-06-11 00:00:00'),
 (005, 'Manager', '2016-06-11 00:00:00'),
 (004, 'Asst. Manager', '2016-06-11 00:00:00'),
 (007, 'Executive', '2016-06-11 00:00:00'),
 (006, 'Lead', '2016-06-11 00:00:00'),
 (003, 'Lead', '2016-06-11 00:00:00');