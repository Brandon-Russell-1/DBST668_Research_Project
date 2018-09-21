SET echo on;
SET serveroutput on;
/* Drop tables, sequence, and other objects you create*/

DROP TABLE Instr_Classes;
DROP TABLE Instr_List;
DROP TABLE Course_List;
DROP TABLE Section_Info;
DROP TABLE Class_Sched;
DROP SEQUENCE SectionNum_Seq;
DROP SEQUENCE InstrNum_Seq;
DROP SEQUENCE CourseNum_Seq;
DROP SEQUENCE SchedNum_Seq;

/* Create 5 tables */

CREATE TABLE Section_Info
(
  Section_Num		INTEGER         NOT NULL,
  Section_Name	VARCHAR (100),	
  Section_Address	VARCHAR (100),	
  Section_FoS		VARCHAR (100),	
  Section_ZipCode	VARCHAR(10),
  CONSTRAINT    pk_section PRIMARY KEY (Section_Num)
);

DESCRIBE Section_Info;

CREATE TABLE Instr_List
(
  Instr_ID		    INTEGER         NOT NULL,
  Instr_Address   VARCHAR (100),
  Instr_PhoneNum  VARCHAR (20),
  Section_Num     INTEGER         NOT NULL,
  Instr_LName     VARCHAR (20),
  Instr_FName     VARCHAR (20),
  Instr_ZipCode   VARCHAR (10),
  CONSTRAINT  pk_Instr PRIMARY KEY (Instr_ID),
  CONSTRAINT  fk_Instr_Section FOREIGN KEY (Section_Num) 
    REFERENCES Section_Info
);

DESCRIBE Instr_List;


CREATE TABLE Course_List
(
  Course_Num            INTEGER         NOT NULL,
  Course_Name           VARCHAR (100),
  Course_Author_FName   VARCHAR (20),
  Course_Author_LName   VARCHAR(20),
  Course_Desc           VARCHAR (1000),
  Course_Hours          INTEGER,
  Section_Num           INTEGER         NOT NULL,
  CONSTRAINT  pk_Course PRIMARY KEY (Course_Num),
  CONSTRAINT fk_Course_Section  FOREIGN KEY (Section_Num)
    REFERENCES Section_Info

);

DESCRIBE Course_List;

CREATE TABLE Class_Sched
(
  Sched_Num       INTEGER       NOT NULL,
  Sched_Day       VARCHAR (100),
  Sched_Time      VARCHAR (10),
  Sched_Day_Off   VARCHAR (100),
  Sched_Notes     VARCHAR (1000),
  CONSTRAINT  pk_Schedule PRIMARY KEY (Sched_Num)
);

DESCRIBE Class_Sched;

CREATE TABLE Instr_Classes
(

  Instr_ID       INTEGER         NOT NULL,
  Sched_Num       INTEGER         NOT NULL,
  Course_Num      INTEGER         NOT NULL,
  Class_Notes     VARCHAR (1000),
  Class_Room      VARCHAR (5),
  CONSTRAINT pk_Class  PRIMARY KEY (Instr_ID, Sched_Num),
  CONSTRAINT fk_Instr  FOREIGN KEY (Instr_ID)
    REFERENCES Instr_List
    ON DELETE CASCADE,
  CONSTRAINT fk_Sched  FOREIGN KEY (Sched_Num)
    REFERENCES Class_Sched
    ON DELETE CASCADE,
  CONSTRAINT fk_Course FOREIGN KEY (Course_Num)
    REFERENCES Course_List
    ON DELETE CASCADE
);

DESCRIBE Instr_Classes;

/* Create indexes on foreign keys*/

CREATE INDEX fk_Course_List on Course_List(Section_Num);
CREATE INDEX fk_Instr on Instr_List(Section_Num);
CREATE INDEX fk_InstrClass on Instr_Classes(Instr_ID);
CREATE INDEX fk_ClassSched on Instr_Classes(Sched_Num);
CREATE INDEX fk_CourseClass on Instr_Classes(Course_Num);

/* Create 2 views */
/*This view shows all classes Instructor 1 is teaching on Schedule 1 */
CREATE OR REPLACE VIEW Instr_Teaching_View AS
  SELECT * from Instr_Classes
  WHERE Instr_ID ='1' AND Sched_Num ='1';
  
DESCRIBE Instr_Teaching_View;
/*This view will show which section each Instructor belongs to*/  
CREATE OR REPLACE VIEW Section_Instructors_View AS
SELECT section_num, s.section_name, i.instr_fname, i.instr_lname
       FROM section_info s
        INNER JOIN Instr_List i
          USING (section_num);

DESCRIBE Section_Instructors_View;

/* Create trigger */
/*This trigger will display a message when a row is added to Instr_Classes*/
CREATE OR REPLACE TRIGGER SchedClass_Trigger AFTER INSERT ON Instr_Classes
  FOR EACH ROW
    BEGIN
      dbms_output.put_line ('A class has been added!!');
    END;
    /
/* Create sequence*/

CREATE SEQUENCE SectionNum_Seq
  START WITH 1
  INCREMENT BY 1;

CREATE SEQUENCE InstrNum_Seq
  START WITH 1
  INCREMENT BY 1;
  
CREATE SEQUENCE CourseNum_Seq
  START WITH 1
  INCREMENT BY 1;

CREATE SEQUENCE SchedNum_Seq
  START WITH 1
  INCREMENT BY 1;
/* Data Dictionary query */
PURGE recyclebin;
/*The next query returns the first 20 characters of all table names and then their tablespace names*/
SELECT /*fixed*/ substr(table_name, 1,20) as name, tablespace_name from user_tables;

/* Insert 10 or more rows into each table */


INSERT INTO Section_Info (Section_Num,            Section_Name,               Section_Address,     Section_FoS,       Section_ZipCode)
    VALUES               (SectionNum_Seq.NEXTVAL, 'Computer Science Section', '110 Finegand Place','Computer Science','31088');
INSERT INTO Section_Info (Section_Num,             Section_Name, Section_Address,     Section_FoS,Section_ZipCode)
    VALUES               (SectionNum_Seq.NEXTVAL, 'Art Section', '111 Finegand Place','Art','31088');
INSERT INTO Section_Info (Section_Num,            Section_Name,       Section_Address,     Section_FoS,Section_ZipCode)
    VALUES               (SectionNum_Seq.NEXTVAL, 'Aircraft Section', '112 Finegand Place','Aircraft','31088');
INSERT INTO Section_Info (Section_Num,            Section_Name,       Section_Address,    Section_FoS,Section_ZipCode)
    VALUES               (SectionNum_Seq.NEXTVAL, 'Robotic Section', '113 Finegand Place','Robotics','31088');
INSERT INTO Section_Info (Section_Num,            Section_Name,       Section_Address,     Section_FoS,          Section_ZipCode)
    VALUES               (SectionNum_Seq.NEXTVAL, 'Database Section', '114 Finegand Place','Database Technology','31088');
INSERT INTO Section_Info (Section_Num,            Section_Name,      Section_Address,     Section_FoS,       Section_ZipCode)
    VALUES               (SectionNum_Seq.NEXTVAL, 'English Section', '115 Finegand Place','English language','31088');
INSERT INTO Section_Info (Section_Num,            Section_Name,      Section_Address,     Section_FoS, Section_ZipCode)
    VALUES               (SectionNum_Seq.NEXTVAL, 'Physics Section', '116 Finegand Place','Physics','31088');
INSERT INTO Section_Info (Section_Num,            Section_Name,        Section_Address,     Section_FoS,Section_ZipCode)
    VALUES               (SectionNum_Seq.NEXTVAL, 'Chemistry Section', '117 Finegand Place','Chemistry','31088');
INSERT INTO Section_Info (Section_Num,            Section_Name,      Section_Address,     Section_FoS,       Section_ZipCode)
    VALUES               (SectionNum_Seq.NEXTVAL, 'Spanish Section', '118 Finegand Place','Spanish language','31088');
INSERT INTO Section_Info (Section_Num,            Section_Name,         Section_Address,     Section_FoS,           Section_ZipCode)
    VALUES               (SectionNum_Seq.NEXTVAL, 'Automotive Section', '119 Finegand Place','Automotive Mechanics','31088');
INSERT INTO Section_Info (Section_Num,            Section_Name,           Section_Address,     Section_FoS,   Section_ZipCode)
    VALUES               (SectionNum_Seq.NEXTVAL, 'Space Travel Section', '120 Finegand Place','Space Travel','31088');

INSERT INTO Instr_List  (Instr_ID,           Instr_Address,     Instr_PhoneNum, Section_Num, Instr_LName, Instr_FName, Instr_ZipCode)
    VALUES              (InstrNum_Seq.NEXTVAL,'101 Apple Street','111-222-3434', '1',         'Roberts',   'John',      '31003');             
INSERT INTO Instr_List  (Instr_ID,           Instr_Address,     Instr_PhoneNum, Section_Num, Instr_LName, Instr_FName, Instr_ZipCode)
    VALUES              (InstrNum_Seq.NEXTVAL,'102 Apple Street','111-222-3435', '2',         'Russell',   'Brandon',      '31003');   
INSERT INTO Instr_List  (Instr_ID,           Instr_Address,     Instr_PhoneNum, Section_Num, Instr_LName, Instr_FName, Instr_ZipCode)
    VALUES              (InstrNum_Seq.NEXTVAL,'103 Apple Street','111-222-3436', '3',         'Lopez',     'Mike',      '31003');   
INSERT INTO Instr_List  (Instr_ID,           Instr_Address,     Instr_PhoneNum, Section_Num, Instr_LName, Instr_FName, Instr_ZipCode)
    VALUES              (InstrNum_Seq.NEXTVAL,'104 Apple Street','111-222-3437', '4',         'Monteor',   'Jim',      '31003');   
INSERT INTO Instr_List  (Instr_ID,           Instr_Address,     Instr_PhoneNum, Section_Num, Instr_LName, Instr_FName, Instr_ZipCode)
    VALUES              (InstrNum_Seq.NEXTVAL,'105 Apple Street','111-222-3438', '5',         'Hamm',      'Patricia',  '31003');   
INSERT INTO Instr_List  (Instr_ID,           Instr_Address,     Instr_PhoneNum, Section_Num, Instr_LName, Instr_FName,  Instr_ZipCode)
    VALUES              (InstrNum_Seq.NEXTVAL,'106 Apple Street','111-222-3439', '6',         'Ingle',     'Tammy',      '31003');   
INSERT INTO Instr_List  (Instr_ID,           Instr_Address,     Instr_PhoneNum, Section_Num, Instr_LName, Instr_FName, Instr_ZipCode)
    VALUES              (InstrNum_Seq.NEXTVAL,'107 Apple Street','111-222-3440', '7',         'Jordan',    'Keith',     '31003');   
INSERT INTO Instr_List  (Instr_ID,           Instr_Address,     Instr_PhoneNum, Section_Num, Instr_LName, Instr_FName, Instr_ZipCode)
    VALUES              (InstrNum_Seq.NEXTVAL,'108 Apple Street','111-222-3441', '8',         'Cooper',    'Adam',      '31003');   
INSERT INTO Instr_List  (Instr_ID,           Instr_Address,     Instr_PhoneNum, Section_Num, Instr_LName, Instr_FName, Instr_ZipCode)
    VALUES              (InstrNum_Seq.NEXTVAL,'109 Apple Street','111-222-3442', '9',         'McCoy',     'Amber',     '31003');   
INSERT INTO Instr_List  (Instr_ID,           Instr_Address,     Instr_PhoneNum, Section_Num, Instr_LName, Instr_FName, Instr_ZipCode)
    VALUES              (InstrNum_Seq.NEXTVAL,'110 Apple Street','111-222-3443', '10',        'Fuller',    'Jana',      '31003');   
INSERT INTO Instr_List  (Instr_ID,           Instr_Address,     Instr_PhoneNum, Section_Num, Instr_LName, Instr_FName, Instr_ZipCode)
    VALUES              (InstrNum_Seq.NEXTVAL,'111 Apple Street','111-222-3444', '10',        'Xavier',    'Mark',      '31003');

INSERT INTO Course_List (Course_Num,            Course_Name,                Course_Author_FName,Course_Author_LName, Course_Desc,                       Course_Hours, Section_Num)
    VALUES              (CourseNum_Seq.NEXTVAL, 'Intro to Computer Science','Bob',              'Evans',             'Introduction to Computer Science','3',          '1');          
INSERT INTO Course_List (Course_Num,            Course_Name,                   Course_Author_FName, Course_Author_LName,    Course_Desc,                          Course_Hours, Section_Num)
    VALUES              (CourseNum_Seq.NEXTVAL, 'Intro to Database Technology','Mike',              'Johnson',              'Introduction to Database Technology','3',          '2');   
INSERT INTO Course_List (Course_Num,            Course_Name,   Course_Author_FName, Course_Author_LName,    Course_Desc,   Course_Hours, Section_Num)
    VALUES              (CourseNum_Seq.NEXTVAL, 'Intro to Art','Mary',              'Jenkins',              'Advanced Art','3',          '3');   
INSERT INTO Course_List (Course_Num,            Course_Name,        Course_Author_FName, Course_Author_LName,   Course_Desc,              Course_Hours, Section_Num)
    VALUES              (CourseNum_Seq.NEXTVAL, 'Intro to Robotics','Jim',               'Russell',            'Introduction to Robotics','3',          '4');   
INSERT INTO Course_List (Course_Num,            Course_Name,       Course_Author_FName, Course_Author_LName,         Course_Desc,                           Course_Hours, Section_Num)
    VALUES              (CourseNum_Seq.NEXTVAL, 'Intro to English','Patricia',          'Barugeno',                  'Introduction to the English language','3',          '5');   
INSERT INTO Course_List (Course_Num,            Course_Name,       Course_Author_FName, Course_Author_LName,    Course_Desc,               Course_Hours, Section_Num)
    VALUES              (CourseNum_Seq.NEXTVAL, 'Intro to Spanish','John',              'Hopkins',             'Advanced Spanish language','3',          '6');   
INSERT INTO Course_List (Course_Num,            Course_Name,        Course_Author_FName, Course_Author_LName,  Course_Desc,                         Course_Hours, Section_Num)
    VALUES              (CourseNum_Seq.NEXTVAL, 'Intro to Aircraft','Will',              'Smith',              'Introduction to Aircraft mechanics','3',          '7');   
INSERT INTO Course_List (Course_Num,            Course_Name,       Course_Author_FName, Course_Author_LName,  Course_Desc,              Course_Hours, Section_Num)
    VALUES              (CourseNum_Seq.NEXTVAL, 'Intro to Physics','Adam',              'Brown',              'Introduction to Physics','3',          '8');   
INSERT INTO Course_List (Course_Num,            Course_Name,         Course_Author_FName, Course_Author_LName,      Course_Desc,               Course_Hours, Section_Num)
    VALUES              (CourseNum_Seq.NEXTVAL, 'Intro to Chemistry','Shane',             'Williams',              'Introduction to Chemistry','3',          '9');   
INSERT INTO Course_List (Course_Num,            Course_Name,           Course_Author_FName, Course_Author_LName,    Course_Desc,                           Course_Hours, Section_Num)
    VALUES              (CourseNum_Seq.NEXTVAL, 'Intro to Math','Amber',             'Robins',               'Introduction to Automotive mechanics','3',          '10');   
INSERT INTO Course_List (Course_Num,            Course_Name,        Course_Author_FName, Course_Author_LName,     Course_Desc,        Course_Hours, Section_Num)
    VALUES              (CourseNum_Seq.NEXTVAL, 'Advanced Robotics','Tim',               'Hawkins',               'Advanced Robotics','6',          '4');   

INSERT INTO Class_Sched (Sched_Num,           Sched_Day,     Sched_Time, Sched_Day_Off, Sched_Notes)
    VALUES              (SchedNum_Seq.NEXTVAL,'Mon-Tues-Wed','0900-1100','Oct. 13th',   'This is the one of the main schedules');
INSERT INTO Class_Sched (Sched_Num,           Sched_Day,      Sched_Time, Sched_Day_Off, Sched_Notes)
    VALUES              (SchedNum_Seq.NEXTVAL,'Mon-Tues-Thur','0900-1100','Oct. 13th',   'This is the one of the main schedules');
INSERT INTO Class_Sched (Sched_Num,           Sched_Day, Sched_Time, Sched_Day_Off, Sched_Notes)
    VALUES              (SchedNum_Seq.NEXTVAL,'Mon-Wed','1000-1200','Oct. 14th',   'This is the one of the main schedules');
INSERT INTO Class_Sched (Sched_Num,           Sched_Day,     Sched_Time, Sched_Day_Off, Sched_Notes)
    VALUES              (SchedNum_Seq.NEXTVAL,'Mon-Wed-Fri','1000-1200','Oct. 15th',   'This a alternative schedules');
INSERT INTO Class_Sched (Sched_Num,           Sched_Day, Sched_Time, Sched_Day_Off, Sched_Notes)
    VALUES              (SchedNum_Seq.NEXTVAL,'Mon-Tues','0800-0900','Oct. 16th',   'This a alternative schedules');
INSERT INTO Class_Sched (Sched_Num,           Sched_Day,  Sched_Time, Sched_Day_Off, Sched_Notes)
    VALUES              (SchedNum_Seq.NEXTVAL,'Tues-Wed','1300-1500','Oct. 17th',   'This a alternative schedules');
INSERT INTO Class_Sched (Sched_Num,           Sched_Day,  Sched_Time, Sched_Day_Off, Sched_Notes)
    VALUES              (SchedNum_Seq.NEXTVAL,'Thur-Fri','1300-1500','Oct. 18th',   'This a alternative schedules');
INSERT INTO Class_Sched (Sched_Num,           Sched_Day, Sched_Time, Sched_Day_Off, Sched_Notes)
    VALUES              (SchedNum_Seq.NEXTVAL,'Wed-Fri','1600-1800','Oct. 19th',   'This a alternative schedules');
INSERT INTO Class_Sched (Sched_Num,           Sched_Day, Sched_Time, Sched_Day_Off, Sched_Notes)
    VALUES              (SchedNum_Seq.NEXTVAL,'Sat',     '0900-1100','Oct. 20th',   'Weekend Schedule');
INSERT INTO Class_Sched (Sched_Num,           Sched_Day, Sched_Time, Sched_Day_Off, Sched_Notes)
    VALUES              (SchedNum_Seq.NEXTVAL,'Sun',     '0900-1100','Oct. 21st',   'Weekend Schedule');
    
INSERT INTO Instr_Classes (Instr_ID, Sched_Num, Course_Num, Class_Notes,                        Class_Room)
    VALUES                ('1',       '1',       '1',        'Computer one is broke in this room','A');
INSERT INTO Instr_Classes (Instr_ID, Sched_Num, Course_Num, Class_Notes, Class_Room)
    VALUES                ('2',       '2',       '2',        'Room Ready','B');
INSERT INTO Instr_Classes (Instr_ID, Sched_Num, Course_Num, Class_Notes,                    Class_Room)
    VALUES                ('3',       '3',       '3',        'The Instructor Chair is broke','C');
INSERT INTO Instr_Classes (Instr_ID, Sched_Num, Course_Num, Class_Notes,         Class_Room)
    VALUES                ('4',       '4',       '4',        'A/C is not working','D');
INSERT INTO Instr_Classes (Instr_ID, Sched_Num, Course_Num, Class_Notes,                         Class_Room)
    VALUES                ('5',       '5',       '5',        'Computer two is broke in this room','E');
INSERT INTO Instr_Classes (Instr_ID, Sched_Num, Course_Num, Class_Notes,                 Class_Room)
    VALUES                ('6',       '6',       '6',        'No whiteboard in this room','F');
INSERT INTO Instr_Classes (Instr_ID, Sched_Num, Course_Num, Class_Notes,                              Class_Room)
    VALUES                ('7',       '7',       '7',        'Student station 3 is missing a keyboard','G');
INSERT INTO Instr_Classes (Instr_ID, Sched_Num, Course_Num, Class_Notes, Class_Room)
    VALUES                ('8',       '8',       '8',        'Room Ready','H');
INSERT INTO Instr_Classes (Instr_ID, Sched_Num, Course_Num, Class_Notes, Class_Room)
    VALUES                ('9',       '9',       '9',        'Room Ready','I');
INSERT INTO Instr_Classes (Instr_ID, Sched_Num, Course_Num,    Class_Notes, Class_Room)
    VALUES                ('10',       '10',       '10',        'Room Ready','J');
INSERT INTO Instr_Classes (Instr_ID, Sched_Num, Course_Num,    Class_Notes, Class_Room)
    VALUES                ('10',       '9',       '10',        'Room Ready','J');
INSERT INTO Instr_Classes (Instr_ID, Sched_Num, Course_Num,  Class_Notes, Class_Room)
    VALUES                ('9',       '8',       '10',        'Room Ready','X');
INSERT INTO Instr_Classes (Instr_ID, Sched_Num, Course_Num, Class_Notes, Class_Room)
    VALUES                ('1',       '2',       '9',        'Room Ready','Z');
commit;

/* Verify that each table has 10 or more rows of data */

SELECT /*fixed*/ * FROM Section_Info;
SELECT /*fixed*/ * FROM Instr_List;
SELECT /*fixed*/ * FROM Course_List;
SELECT /*fixed*/ * FROM Class_Sched;
SELECT /*fixed*/ * FROM Instr_Classes;


/*1. Select all columns and all rows from one table.*/
SELECT /*fixed*/ * FROM Instr_List;

/*2. Select 5 columns and all rows from one table. */
SELECT /*fixed*/ Sched_Num, Sched_Day, Sched_Time, Sched_Day_Off, Sched_Notes FROM Class_Sched;

/*3. Select all columns and all rows from 2 tables (need a join).*/
SELECT /*fixed*/ * FROM Section_Info INNER JOIN Course_List USING (Section_Num);

/*4. Select and Order data retrieved from one table */
SELECT /*fixed*/ * FROM Instr_List ORDER BY Instr_LName;

/*5. Select 5 columns and 10 rows from 3 tables (need joins).*/
SELECT /*fixed*/ a.Instr_LName, a.Instr_FName, b.Class_Room, c.Sched_Day, c.Sched_Time
  FROM (Instr_List a INNER JOIN Instr_Classes b ON a.Instr_ID=b.Instr_ID)
       INNER JOIN Class_Sched c ON b.Sched_Num=c.Sched_Num
       WHERE ROWNUM < 11;
      
/*6. Select distinct rows using joins using 3 tables.*/
SELECT DISTINCT /*fixed*/ a.Instr_LName, a.Instr_FName, c.Course_Name
  FROM (Instr_List a INNER JOIN Instr_Classes b ON a.Instr_ID=b.Instr_ID)
       INNER JOIN Course_List c ON b.Course_Num=c.Course_Num;

/*7. Select all columns and 10 rows from 2 tables (need a join).*/
SELECT /*fixed*/ * FROM Section_Info INNER JOIN Instr_List ON 
  Section_Info.Section_Num=Instr_List.Section_Num
    WHERE ROWNUM < 11;

/*8. Use group by & having in a select statement using one or more table(s).*/
/*Return a list of sections with 2 active classes being taught.*/
SELECT /*fixed*/ Section_Name, COUNT(Instr_Classes.Instr_ID) AS Number_Of_Classes 
  FROM (Section_Info INNER JOIN Instr_List ON
    Section_Info.Section_Num=Instr_List.Section_Num) INNER JOIN Instr_Classes ON
      Instr_List.Instr_ID=Instr_Classes.Instr_ID
        GROUP BY Section_Name
          HAVING COUNT(Instr_Classes.Instr_ID) = 2;

/*9. Use a IN clause to select data from one or more tables*/
SELECT /*fixed*/ * FROM Instr_List WHERE Instr_LName IN ('Roberts', 'Russell');

/*10. Select Length of one column from one table (use Length function)*/
SELECT /*fixed*/ Course_Desc, LENGTH (Course_Desc) FROM Course_List;

/*11. Use a column alias*/
SELECT /*fixed*/ Instr_FName AS InstructorName FROM Instr_List;

/*12. Perform an advanced query of your choice from chapter 8 (Database Systems Text Book - Coronel, Morris & Rob)*/
/*Return Instructor Full Name in following format: Last, First*/
SELECT /*fixed*/ Instr_LName || ', ' || Instr_FName AS InstructorName FROM Instr_List;

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
SELECT /*fixed*/ Instr_ID, Instr_LName, Instr_FName 
  FROM Instr_List
    WHERE Instr_ID IN
      (SELECT Instr_ID FROM Instr_Classes INNER JOIN Course_List 
        ON Instr_Classes.Course_Num=Course_List.Course_Num
          WHERE Course_Name LIKE '%Math%');

/*16. Write an advanced SQL statement with type II subquery (chapter 8).*/
/*Return list of Instructors teaching classes with "Auto" in course name using Type II query*/
SELECT /*fixed*/ Instr_ID, Instr_LName, Instr_FName
  FROM Instr_List
    WHERE EXISTS
      (SELECT * FROM Instr_Classes INNER JOIN Course_List
        ON Instr_Classes.Course_Num=Course_List.Course_Num
        WHERE Instr_List.Instr_ID=Instr_Classes.Instr_ID
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
  FROM (Instr_List a LEFT JOIN Instr_Classes b ON a.Instr_ID=b.Instr_ID)
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
    FROM (((Instr_List a INNER JOIN Instr_Classes b ON a.Instr_ID=b.Instr_ID)
      INNER JOIN Course_List c ON b.Course_Num=c.Course_Num)
      INNER JOIN Class_Sched d ON b.Sched_Num=d.Sched_Num)
      INNER JOIN Section_Info e ON a.Section_Num=e.Section_Num
        ORDER BY e.Section_Name, a.Instr_LName;
        


