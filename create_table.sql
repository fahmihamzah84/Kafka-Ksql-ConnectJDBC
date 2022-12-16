CREATE TABLE COMPANY(
   ID INT PRIMARY KEY     NOT NULL,
   NAME           TEXT    NOT NULL,
   AGE            INT     NOT NULL,
   ADDRESS        CHAR(50),
   DEPARTMENT CHAR(20),
   SALARY         REAL,
   JOIN_DATE	  DATE
);

INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,DEPARTMENT, SALARY,JOIN_DATE) VALUES (1, 'Paul', 32, 'California','IT', 20000.00,'2011-07-13');
