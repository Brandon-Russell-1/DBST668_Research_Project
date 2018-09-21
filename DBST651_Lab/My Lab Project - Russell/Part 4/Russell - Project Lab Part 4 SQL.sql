SET echo on;
SET serveroutput on;

/*1. Select all columns and all rows from one table.*/
SELECT /*fixed*/ * FROM Instr_Info;

/*2. Select 5 columns and all rows from one table. */
SELECT /*fixed*/ Sched_Num, Sched_Day, Sched_Time, Sched_Day_Off, Sched_Notes FROM Class_Sched;

/*3. Select all columns and all rows from 2 tables (need a join).*/
SELECT /*fixed*/ * FROM Section_Info INNER JOIN Course_List USING (Section_Num);

/*4. Select and Order data retrieved from one table */
SELECT /*fixed*/ * FROM Instr_Info ORDER BY Instr_LName;

/*5. Select 5 columns and 10 rows from 3 tables (need joins).*/
SELECT /*fixed*/ a.Instr_LName, a.Instr_FName, b.Class_Room, c.Sched_Day, c.Sched_Time
  FROM (Instr_Info a INNER JOIN Instr_Classes b ON a.Instr_Num=b.Instr_Num)
       INNER JOIN Class_Sched c ON b.Sched_Num=c.Sched_Num
       WHERE ROWNUM < 11;
      
/*6. Select distinct rows using joins using 3 tables.*/
SELECT DISTINCT /*fixed*/ a.Instr_LName, a.Instr_FName, c.Course_Name
  FROM (Instr_Info a INNER JOIN Instr_Classes b ON a.Instr_Num=b.Instr_Num)
       INNER JOIN Course_List c ON b.Course_Num=c.Course_Num;

/*7. Select all columns and 10 rows from 2 tables (need a join).*/
SELECT /*fixed*/ * FROM Section_Info INNER JOIN Instr_Info ON 
  Section_Info.Section_Num=Instr_Info.Section_Num
    WHERE ROWNUM < 11;

/*8. Use group by & having in a select statement using one or more table(s).*/
SELECT /*fixed*/ Course_Name, AVG(Course_Hours) FROM Course_List 
  GROUP BY Course_Name 
    HAVING AVG(Course_Hours) = 3;

/*9. Use a IN clause to select data from one or more tables*/
SELECT /*fixed*/ * FROM Instr_Info WHERE Instr_LName IN ('Roberts', 'Russell');

/*10. Select Length of one column from one table (use Length function)*/
SELECT /*fixed*/ Course_Desc, LENGTH (Course_Desc) FROM Course_List;

/*11. Use a column alias*/
SELECT /*fixed*/ Instr_FName AS InstructorName FROM Instr_Info;

/*12. Perform an advanced query of your choice from chapter 8 (Database Systems Text Book - Coronel, Morris & Rob)*/
/*Return Instructor Full Name in following format: Last, First*/
SELECT /*fixed*/ Instr_LName || ', ' || Instr_FName AS InstructorName FROM Instr_Info;

/*13. Use an aggregate function and perform another query*/
/*Return total number of course hours taught for each active class*/
SELECT /*fixed*/ Course_Name, SUM(Course_Hours) AS Total_Hours 
  FROM Course_List INNER JOIN Instr_Classes ON Course_List.Course_Num=Instr_Classes.Course_Num
    GROUP BY Course_Name;

/*14. Use the UPDATE command and change some data.*/
SELECT /*fixed*/ * FROM Course_List;

UPDATE Course_List SET Course_Hours=Course_Hours+1;

SELECT /*fixed*/ * FROM Course_List;

ROLLBACK;

/*15. Write an advanced SQL statement with a type I subquery (chapter 8).*/
/*Return list of Instructors teaching classes with "Auto" in course name using Type I query*/
SELECT /*fixed*/ Instr_Num, Instr_LName, Instr_FName 
  FROM Instr_Info
    WHERE Instr_Num IN
      (SELECT Instr_Num FROM Instr_Classes INNER JOIN Course_List 
        ON Instr_Classes.Course_Num=Course_List.Course_Num
          WHERE Course_Name LIKE '%Auto%');

/*16. Write an advanced SQL statement with type II subquery (chapter 8).*/
/*Return list of Instructors teaching classes with "Auto" in course name using Type II query*/
SELECT /*fixed*/ Instr_Num, Instr_LName, Instr_FName
  FROM Instr_Info
    WHERE EXISTS
      (SELECT * FROM Instr_Classes INNER JOIN Course_List
        ON Instr_Classes.Course_Num=Course_List.Course_Num
        WHERE Instr_Info.Instr_Num=Instr_Classes.Instr_Num
        AND Course_Name LIKE '%Auto%');

/*17. Perform additional advanced SQL statement. (chapter 8).*/
/*Return a list of courses and how many times they are currently being taught*/
SELECT /*fixed*/ Course_Name, COUNT(Instr_Classes.Course_Num) AS TimesTaught
  FROM Course_List LEFT JOIN Instr_Classes 
    ON Instr_Classes.Course_Num=Course_List.Course_Num 
      GROUP BY Course_Name
        ORDER BY TimesTaught;

/*18. Perform additional advanced SQL statement. (chapter 8).*/
/*Return all Instructor names, class rooms, and courses taught*/
SELECT /*fixed*/ a.Instr_LName, a.Instr_FName, b.Class_Room, c.Course_Name
  FROM (Instr_Info a LEFT JOIN Instr_Classes b ON a.Instr_Num=b.Instr_Num)
       LEFT JOIN Course_List c ON b.Course_Num=c.Course_Num;
       
/*19. Perform additional advanced SQL statement. (chapter 8).*/
/*Return a list of sections not currently offering any courses*/
SELECT /*fixed*/ Section_Name
  FROM Section_Info
    WHERE NOT EXISTS
      (SELECT Section_Num FROM Course_List
        WHERE Course_List.Section_Num=Section_Info.Section_Num);

/*20. Perform additional advanced SQL statement. (chapter 8).*/ 
/*5 table join-Show all courses being taught with Section & Instructor Name, 
  Class Room, and Schedule; ordered by Section and Instructor last name*/
SELECT /*fixed*/ e.Section_Name, a.Instr_LName || ', ' || a.Instr_FName AS Instructor, 
  b.Class_Room, c.Course_Name, d.Sched_Day || ', ' || d.Sched_Time AS Schedule
    FROM (((Instr_Info a INNER JOIN Instr_Classes b ON a.Instr_Num=b.Instr_Num)
      INNER JOIN Course_List c ON b.Course_Num=c.Course_Num)
      INNER JOIN Class_Sched d ON b.Sched_Num=d.Sched_Num)
      INNER JOIN Section_Info e ON a.Section_Num=e.Section_Num
        ORDER BY e.Section_Name, a.Instr_LName;
        
