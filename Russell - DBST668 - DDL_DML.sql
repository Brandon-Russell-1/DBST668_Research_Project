SET echo on;
SET serveroutput on;
connect sys/brr1wik7 as sysdba;
show user;
/*Drop and Create a DBA*/
DROP USER InstructorDBA cascade;
Create user InstructorDBA identified by brr1wik7;
grant create session to InstructorDBA;
grant dba to InstructorDBA;
grant execute on dbms_rls to InstructorDBA;
connect InstructorDBA/brr1wik7;
show user;
/* Drop tables, sequence, and other objects you create*/

DROP TABLE Student_Class_Signup;
DROP TABLE Instr_Classes;
DROP TABLE Student_List;
DROP TABLE Instr_List;
DROP TABLE Course_List;
DROP TABLE Admin_List;
DROP TABLE Section_Info;
DROP TABLE Class_Sched;
DROP SEQUENCE SectionNum_Seq;
DROP SEQUENCE InstrNum_Seq;
DROP SEQUENCE CourseNum_Seq;
DROP SEQUENCE AdminNum_Seq;
DROP SEQUENCE SchedNum_Seq;
DROP SEQUENCE StudentNum_Seq;

/* Create tables */

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

CREATE TABLE Admin_List
(
  Admin_Num		  INTEGER         NOT NULL,
  Admin_Address   VARCHAR (100),
  Admin_PhoneNum  VARCHAR (20),
  Section_Num     INTEGER         NOT NULL,
  Admin_LName     VARCHAR (20),
  Admin_FName     VARCHAR (20),
  Admin_ZipCode   VARCHAR (10),
  CONSTRAINT  pk_Admin PRIMARY KEY (Admin_Num),
  CONSTRAINT  fk_Admin_Section FOREIGN KEY (Section_Num) 
    REFERENCES Section_Info
);

DESCRIBE Admin_List;


CREATE TABLE Student_List
(
  Student_Num		  INTEGER         NOT NULL,
  Student_Address   VARCHAR (100),
  Student_PhoneNum  VARCHAR (20),
  Student_LName     VARCHAR (20),
  Student_FName     VARCHAR (20),
  Student_ZipCode   VARCHAR (10),
  CONSTRAINT  pk_Student PRIMARY KEY (Student_Num)
);

DESCRIBE Student_List;


CREATE TABLE Instr_List
(
  Instr_Num		    INTEGER         NOT NULL,
  Instr_Address   VARCHAR (100),
  Instr_PhoneNum  VARCHAR (20),
  Section_Num     INTEGER         NOT NULL,
  Instr_LName     VARCHAR (20),
  Instr_FName     VARCHAR (20),
  Instr_ZipCode   VARCHAR (10),
  CONSTRAINT  pk_Instr PRIMARY KEY (Instr_Num),
  CONSTRAINT  fk_Instr_Section FOREIGN KEY (Section_Num) 
    REFERENCES Section_Info
);

DESCRIBE Instr_List;


CREATE TABLE Course_List
(
  Course_Num            INTEGER         NOT NULL,
  Course_Name           VARCHAR (100),
  Admin_Num             INTEGER         NOT NULL,
  Course_Desc           VARCHAR (1000),
  Course_Hours          INTEGER,
  Section_Num           INTEGER         NOT NULL,
  CONSTRAINT  pk_Course PRIMARY KEY (Course_Num),
  CONSTRAINT fk_Course_Section  FOREIGN KEY (Section_Num)
    REFERENCES Section_Info,
  CONSTRAINT fk_Admin  FOREIGN KEY (Admin_Num)
    REFERENCES Admin_List

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

  Instr_Num       INTEGER         NOT NULL,
  Sched_Num       INTEGER         NOT NULL,
  Course_Num      INTEGER         NOT NULL,
  Class_Notes     VARCHAR (1000),
  Class_Room      VARCHAR (5),
  CONSTRAINT pk_Class  PRIMARY KEY (Instr_Num, Sched_Num),
  CONSTRAINT fk_Instr  FOREIGN KEY (Instr_Num)
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


CREATE TABLE Student_Class_Signup
(
  Student_Num	  INTEGER         NOT NULL,
  Instr_Num       INTEGER         NOT NULL,
  Sched_Num       INTEGER         NOT NULL,
  Student_Grade   VARCHAR (5),
  CONSTRAINT pk_StudentSignup  PRIMARY KEY (Student_Num, Instr_Num, Sched_Num),
  CONSTRAINT fk_Student FOREIGN KEY (Student_Num)
    REFERENCES Student_List
    ON DELETE CASCADE,
  CONSTRAINT fk_S_InstrClasses  FOREIGN KEY (Instr_Num, Sched_Num)
    REFERENCES Instr_Classes(Instr_Num, Sched_Num)
    ON DELETE CASCADE
);
/* Create indexes on foreign keys*/

CREATE INDEX fk_Course_List_Index on Course_List(Section_Num);
CREATE INDEX fk_Course_Admin_Index on Course_List(Admin_Num);
CREATE INDEX fk_Instr_Index on Instr_List(Section_Num);
CREATE INDEX fk_Admin_Index on Admin_List(Section_Num);
CREATE INDEX fk_InstrClass_Index on Instr_Classes(Instr_Num);
CREATE INDEX fk_ClassSched_Index on Instr_Classes(Sched_Num);
CREATE INDEX fk_CourseClass_Index on Instr_Classes(Course_Num);
CREATE INDEX fk_Student_StudentSignup_Index on Student_Class_Signup(Student_Num);
CREATE INDEX fk_Instr_StudentSignup_Index on Student_Class_Signup(Instr_Num);
CREATE INDEX fk_Sched_StudentSignup_Index on Student_Class_Signup(Sched_Num);

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
  
CREATE SEQUENCE AdminNum_Seq
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

CREATE SEQUENCE StudentNum_Seq
  START WITH 1
  INCREMENT BY 1;

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

INSERT INTO Admin_List  (Admin_Num,           Admin_Address,     Admin_PhoneNum, Section_Num, Admin_LName, Admin_FName, Admin_ZipCode)
    VALUES              (AdminNum_Seq.NEXTVAL,'501 Orange Park','111-333-3434', '1',         'Evans',   'Bob',      '31004');             
INSERT INTO Admin_List  (Admin_Num,           Admin_Address,     Admin_PhoneNum, Section_Num, Admin_LName, Admin_FName, Admin_ZipCode)
    VALUES              (AdminNum_Seq.NEXTVAL,'502 Orange Park','111-333-3435', '2',         'Johnson',   'Mike',      '31004');   
INSERT INTO Admin_List  (Admin_Num,           Admin_Address,     Admin_PhoneNum, Section_Num, Admin_LName, Admin_FName, Admin_ZipCode)
    VALUES              (AdminNum_Seq.NEXTVAL,'503 Orange Park','111-333-3436', '3',         'Jenkins',     'Mary',      '31004');   
INSERT INTO Admin_List  (Admin_Num,           Admin_Address,     Admin_PhoneNum, Section_Num, Admin_LName, Admin_FName, Admin_ZipCode)
    VALUES              (AdminNum_Seq.NEXTVAL,'504 Orange Park','111-333-3437', '4',         'Russell',   'Jim',      '31004');   
INSERT INTO Admin_List  (Admin_Num,           Admin_Address,     Admin_PhoneNum, Section_Num, Admin_LName, Admin_FName, Admin_ZipCode)
    VALUES              (AdminNum_Seq.NEXTVAL,'505 Orange Park','111-333-3438', '5',         'Bargueno',      'Patricia',  '31004');   
INSERT INTO Admin_List  (Admin_Num,           Admin_Address,     Admin_PhoneNum, Section_Num, Admin_LName, Admin_FName, Admin_ZipCode)
    VALUES              (AdminNum_Seq.NEXTVAL,'506 Orange Park','111-333-3439', '6',         'Hopkins',     'John',      '31004');   
INSERT INTO Admin_List  (Admin_Num,           Admin_Address,     Admin_PhoneNum, Section_Num, Admin_LName, Admin_FName, Admin_ZipCode)
    VALUES              (AdminNum_Seq.NEXTVAL,'507 Orange Park','111-333-3440', '7',         'Smith',    'Will',     '31004');   
INSERT INTO Admin_List  (Admin_Num,           Admin_Address,     Admin_PhoneNum, Section_Num, Admin_LName, Admin_FName, Admin_ZipCode)
    VALUES              (AdminNum_Seq.NEXTVAL,'508 Orange Park','111-333-3441', '8',         'Brown',    'Adam',      '31004');   
INSERT INTO Admin_List  (Admin_Num,           Admin_Address,     Admin_PhoneNum, Section_Num, Admin_LName, Admin_FName, Admin_ZipCode)
    VALUES              (AdminNum_Seq.NEXTVAL,'509 Orange Park','111-333-3442', '9',         'Williams',     'Shane',     '31004');   
INSERT INTO Admin_List  (Admin_Num,           Admin_Address,     Admin_PhoneNum, Section_Num, Admin_LName, Admin_FName, Admin_ZipCode)
    VALUES              (AdminNum_Seq.NEXTVAL,'510 Orange Park','111-333-3443', '10',        'Robins',    'Amber',      '31004');   
INSERT INTO Admin_List  (Admin_Num,           Admin_Address,     Admin_PhoneNum, Section_Num, Admin_LName, Admin_FName, Admin_ZipCode)
    VALUES              (AdminNum_Seq.NEXTVAL,'511 Orange Park','111-333-3444', '4',        'Hawkins',    'Tim',      '31004');

INSERT INTO Student_List  (Student_Num,           Student_Address,     Student_PhoneNum, Student_LName, Student_FName, Student_ZipCode)
    VALUES              (StudentNum_Seq.NEXTVAL,'Dorm 1','222-333-3434',       'Gilbert',   'Sarah',      '31005');             
INSERT INTO Student_List  (Student_Num,           Student_Address,     Student_PhoneNum, Student_LName, Student_FName, Student_ZipCode)
    VALUES              (StudentNum_Seq.NEXTVAL,'Dorm 2','222-333-3435',         'Myers',   'James',      '31005');   
INSERT INTO Student_List  (Student_Num,           Student_Address,     Student_PhoneNum, Student_LName, Student_FName, Student_ZipCode)
    VALUES              (StudentNum_Seq.NEXTVAL,'Dorm 3','222-333-3436',          'Howard',     'Rico',      '31005');   
INSERT INTO Student_List  (Student_Num,           Student_Address,     Student_PhoneNum, Student_LName, Student_FName, Student_ZipCode)
    VALUES              (StudentNum_Seq.NEXTVAL,'Dorm 4','222-333-3437',          'Bush',   'Donald',      '31005');   
INSERT INTO Student_List  (Student_Num,           Student_Address,     Student_PhoneNum, Student_LName, Student_FName, Student_ZipCode)
    VALUES              (StudentNum_Seq.NEXTVAL,'Dorm 5','222-333-3438',          'Simmons',      'Bill',  '31005');   
INSERT INTO Student_List  (Student_Num,           Student_Address,     Student_PhoneNum, Student_LName, Student_FName, Student_ZipCode)
    VALUES              (StudentNum_Seq.NEXTVAL,'Dorm 6','222-333-3439',          'Aultman',     'Richard',      '31005');   
INSERT INTO Student_List  (Student_Num,           Student_Address,     Student_PhoneNum, Student_LName, Student_FName, Student_ZipCode)
    VALUES              (StudentNum_Seq.NEXTVAL,'Dorm 7','222-333-3440',          'Ruger',    'Victoria',     '31005');   
INSERT INTO Student_List  (Student_Num,           Student_Address,     Student_PhoneNum, Student_LName, Student_FName, Student_ZipCode)
    VALUES              (StudentNum_Seq.NEXTVAL,'Dorm 8','222-333-3441',          'Thomas',    'Melissa',      '31005');   
INSERT INTO Student_List  (Student_Num,           Student_Address,     Student_PhoneNum, Student_LName, Student_FName, Student_ZipCode)
    VALUES              (StudentNum_Seq.NEXTVAL,'Dorm 9','222-333-3442',          'Synder',     'Jennifer',     '31005');   
INSERT INTO Student_List  (Student_Num,           Student_Address,     Student_PhoneNum, Student_LName, Student_FName, Student_ZipCode)
    VALUES              (StudentNum_Seq.NEXTVAL,'Dorm 10','222-333-3443',         'Baker',    'Elizabeth',      '31005');   
INSERT INTO Student_List  (Student_Num,           Student_Address,     Student_PhoneNum, Student_LName, Student_FName, Student_ZipCode)
    VALUES              (StudentNum_Seq.NEXTVAL,'Dorm 11','222-333-3444',         'Pines',    'Matt',      '31005');



INSERT INTO Instr_List  (Instr_Num,           Instr_Address,     Instr_PhoneNum, Section_Num, Instr_LName, Instr_FName, Instr_ZipCode)
    VALUES              (InstrNum_Seq.NEXTVAL,'101 Apple Street','111-222-3434', '1',         'Roberts',   'John',      '31003');             
INSERT INTO Instr_List  (Instr_Num,           Instr_Address,     Instr_PhoneNum, Section_Num, Instr_LName, Instr_FName, Instr_ZipCode)
    VALUES              (InstrNum_Seq.NEXTVAL,'102 Apple Street','111-222-3435', '2',         'Russell',   'Brandon',      '31003');   
INSERT INTO Instr_List  (Instr_Num,           Instr_Address,     Instr_PhoneNum, Section_Num, Instr_LName, Instr_FName, Instr_ZipCode)
    VALUES              (InstrNum_Seq.NEXTVAL,'103 Apple Street','111-222-3436', '3',         'Lopez',     'Mike',      '31003');   
INSERT INTO Instr_List  (Instr_Num,           Instr_Address,     Instr_PhoneNum, Section_Num, Instr_LName, Instr_FName, Instr_ZipCode)
    VALUES              (InstrNum_Seq.NEXTVAL,'104 Apple Street','111-222-3437', '4',         'Monteor',   'Jim',      '31003');   
INSERT INTO Instr_List  (Instr_Num,           Instr_Address,     Instr_PhoneNum, Section_Num, Instr_LName, Instr_FName, Instr_ZipCode)
    VALUES              (InstrNum_Seq.NEXTVAL,'105 Apple Street','111-222-3438', '5',         'Hamm',      'Patricia',  '31003');   
INSERT INTO Instr_List  (Instr_Num,           Instr_Address,     Instr_PhoneNum, Section_Num, Instr_LName, Instr_FName,  Instr_ZipCode)
    VALUES              (InstrNum_Seq.NEXTVAL,'106 Apple Street','111-222-3439', '6',         'Ingle',     'Tammy',      '31003');   
INSERT INTO Instr_List  (Instr_Num,           Instr_Address,     Instr_PhoneNum, Section_Num, Instr_LName, Instr_FName, Instr_ZipCode)
    VALUES              (InstrNum_Seq.NEXTVAL,'107 Apple Street','111-222-3440', '7',         'Jordan',    'Keith',     '31003');   
INSERT INTO Instr_List  (Instr_Num,           Instr_Address,     Instr_PhoneNum, Section_Num, Instr_LName, Instr_FName, Instr_ZipCode)
    VALUES              (InstrNum_Seq.NEXTVAL,'108 Apple Street','111-222-3441', '8',         'Cooper',    'Adam',      '31003');   
INSERT INTO Instr_List  (Instr_Num,           Instr_Address,     Instr_PhoneNum, Section_Num, Instr_LName, Instr_FName, Instr_ZipCode)
    VALUES              (InstrNum_Seq.NEXTVAL,'109 Apple Street','111-222-3442', '9',         'McCoy',     'Amber',     '31003');   
INSERT INTO Instr_List  (Instr_Num,           Instr_Address,     Instr_PhoneNum, Section_Num, Instr_LName, Instr_FName, Instr_ZipCode)
    VALUES              (InstrNum_Seq.NEXTVAL,'110 Apple Street','111-222-3443', '10',        'Fuller',    'Jana',      '31003');   
INSERT INTO Instr_List  (Instr_Num,           Instr_Address,     Instr_PhoneNum, Section_Num, Instr_LName, Instr_FName, Instr_ZipCode)
    VALUES              (InstrNum_Seq.NEXTVAL,'111 Apple Street','111-222-3444', '10',        'Xavier',    'Mark',      '31003');

INSERT INTO Course_List (Course_Num,            Course_Name,                Admin_Num , Course_Desc,                       Course_Hours, Section_Num)
    VALUES              (CourseNum_Seq.NEXTVAL, 'Intro to Computer Science',1,             'Intro to Computer Science','3',          '1');          
INSERT INTO Course_List (Course_Num,            Course_Name,                Admin_Num , Course_Desc,                       Course_Hours, Section_Num)
    VALUES              (CourseNum_Seq.NEXTVAL, 'Intro to Art',2,              'Intro to Art','3',          '2');   
INSERT INTO Course_List (Course_Num,            Course_Name,                Admin_Num , Course_Desc,                       Course_Hours, Section_Num)
    VALUES              (CourseNum_Seq.NEXTVAL, 'Intro to Aircraft mechanics',3,              'Intro to Aircraft mechanics','3',          '3');   
INSERT INTO Course_List (Course_Num,            Course_Name,                Admin_Num , Course_Desc,                       Course_Hours, Section_Num)
    VALUES              (CourseNum_Seq.NEXTVAL, 'Intro to Robotics',4,            'Intro to Robotics','3',          '4');   
INSERT INTO Course_List (Course_Num,            Course_Name,                Admin_Num , Course_Desc,                       Course_Hours, Section_Num)
    VALUES              (CourseNum_Seq.NEXTVAL, 'Intro to Databases',5,                  'Intro to Databases','3',          '5');   
INSERT INTO Course_List (Course_Num,            Course_Name,                Admin_Num , Course_Desc,                       Course_Hours, Section_Num)
    VALUES              (CourseNum_Seq.NEXTVAL, 'Advanced English',6,             'Advanced English','3',          '6');   
INSERT INTO Course_List (Course_Num,            Course_Name,                Admin_Num , Course_Desc,                       Course_Hours, Section_Num)
    VALUES              (CourseNum_Seq.NEXTVAL, 'Intro to Physics',7,              'Intro to Physics','3',          '7');   
INSERT INTO Course_List (Course_Num,            Course_Name,                Admin_Num , Course_Desc,                       Course_Hours, Section_Num)
    VALUES              (CourseNum_Seq.NEXTVAL, 'Intro to Chemistry',8,              'Intro to Chemistry','3',          '8');   
INSERT INTO Course_List (Course_Num,            Course_Name,                Admin_Num , Course_Desc,                       Course_Hours, Section_Num)
    VALUES              (CourseNum_Seq.NEXTVAL, 'Intro to Spanish',9,              'Intro to Spanish','3',          '9');   
INSERT INTO Course_List (Course_Num,            Course_Name,                Admin_Num , Course_Desc,                       Course_Hours, Section_Num)
    VALUES              (CourseNum_Seq.NEXTVAL, 'Automotive mechanics Intro',10,               'Automotive mechanics Intro','3',          '10');   
INSERT INTO Course_List (Course_Num,            Course_Name,                Admin_Num , Course_Desc,                       Course_Hours, Section_Num)
    VALUES              (CourseNum_Seq.NEXTVAL, 'Advanced Robotics',11,               'Advanced Robotics','6',          '4');   

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
INSERT INTO Class_Sched (Sched_Num,           Sched_Day, Sched_Time, Sched_Day_Off, Sched_Notes)
    VALUES              (SchedNum_Seq.NEXTVAL,'Mon',     '0900-0930','6 days a week',   'Beta');
INSERT INTO Class_Sched (Sched_Num,           Sched_Day, Sched_Time, Sched_Day_Off, Sched_Notes)
    VALUES              (SchedNum_Seq.NEXTVAL,'Tues',     '1100-1115','6 days a week',   'Beta');    
    
INSERT INTO Instr_Classes (Instr_Num, Sched_Num, Course_Num, Class_Notes,                        Class_Room)
    VALUES                ('1',       '1',       '1',        'Computer one broke','A');
INSERT INTO Instr_Classes (Instr_Num, Sched_Num, Course_Num, Class_Notes, Class_Room)
    VALUES                ('2',       '2',       '2',        'Room Ready','B');
INSERT INTO Instr_Classes (Instr_Num, Sched_Num, Course_Num, Class_Notes,                    Class_Room)
    VALUES                ('3',       '3',       '3',        'Instructor Chair broke','C');
INSERT INTO Instr_Classes (Instr_Num, Sched_Num, Course_Num, Class_Notes,         Class_Room)
    VALUES                ('4',       '4',       '4',        'A/C not working','D');
INSERT INTO Instr_Classes (Instr_Num, Sched_Num, Course_Num, Class_Notes,                         Class_Room)
    VALUES                ('5',       '5',       '5',        'Computer two broke','E');
INSERT INTO Instr_Classes (Instr_Num, Sched_Num, Course_Num, Class_Notes,                 Class_Room)
    VALUES                ('6',       '6',       '6',        'No whiteboard','F');
INSERT INTO Instr_Classes (Instr_Num, Sched_Num, Course_Num, Class_Notes,                              Class_Room)
    VALUES                ('7',       '7',       '7',        'station 3 missing keyboard','G');
INSERT INTO Instr_Classes (Instr_Num, Sched_Num, Course_Num, Class_Notes, Class_Room)
    VALUES                ('8',       '8',       '8',        'Room Ready','H');
INSERT INTO Instr_Classes (Instr_Num, Sched_Num, Course_Num, Class_Notes, Class_Room)
    VALUES                ('9',       '9',       '9',        'Room Ready','I');
INSERT INTO Instr_Classes (Instr_Num, Sched_Num, Course_Num,    Class_Notes, Class_Room)
    VALUES                ('10',       '10',       '10',        'Room Ready','J');
INSERT INTO Instr_Classes (Instr_Num, Sched_Num, Course_Num,    Class_Notes, Class_Room)
    VALUES                ('10',       '9',       '10',        'Room Ready','J');
INSERT INTO Instr_Classes (Instr_Num, Sched_Num, Course_Num,  Class_Notes, Class_Room)
    VALUES                ('9',       '8',       '10',        'Room Ready','X');
INSERT INTO Instr_Classes (Instr_Num, Sched_Num, Course_Num, Class_Notes, Class_Room)
    VALUES                ('1',       '2',       '9',        'Room Ready','Z');
    
    
INSERT INTO Student_Class_Signup (Student_Num, Instr_Num, Sched_Num,  Student_Grade)
    VALUES                (1, 1, 1,  'A');
INSERT INTO Student_Class_Signup (Student_Num, Instr_Num, Sched_Num,  Student_Grade)
    VALUES                (1, 2, 2,  'B');
INSERT INTO Student_Class_Signup (Student_Num, Instr_Num, Sched_Num,  Student_Grade)
    VALUES                (2, 3, 3,  'A');
INSERT INTO Student_Class_Signup (Student_Num, Instr_Num, Sched_Num,  Student_Grade)
    VALUES                (3, 3, 3,  'C');
INSERT INTO Student_Class_Signup (Student_Num, Instr_Num, Sched_Num,Student_Grade)
    VALUES                (4, 4, 4,  'C');
INSERT INTO Student_Class_Signup (Student_Num, Instr_Num, Sched_Num, Student_Grade)
    VALUES                (5, 5, 5,  'B');
INSERT INTO Student_Class_Signup (Student_Num, Instr_Num, Sched_Num, Student_Grade)
    VALUES                (6, 6, 6,  'D');
INSERT INTO Student_Class_Signup (Student_Num, Instr_Num, Sched_Num,  Student_Grade)
    VALUES                (7, 7, 7,  'F');
INSERT INTO Student_Class_Signup (Student_Num, Instr_Num, Sched_Num,  Student_Grade)
    VALUES                (8, 8, 8,  '');
INSERT INTO Student_Class_Signup (Student_Num, Instr_Num, Sched_Num,  Student_Grade)
    VALUES                (9, 9, 9,  'A');
INSERT INTO Student_Class_Signup (Student_Num, Instr_Num, Sched_Num,  Student_Grade)
    VALUES                (10, 10, 10,  'A');
    
commit;

/* Verify that each table has 10 or more rows of data */

SELECT /*fixed*/ * FROM Section_Info;
SELECT /*fixed*/ * FROM Instr_List;
SELECT /*fixed*/ * FROM Admin_List;
SELECT /*fixed*/ * FROM Student_List;
SELECT /*fixed*/ * FROM Course_List;
SELECT /*fixed*/ * FROM Class_Sched;
SELECT /*fixed*/ * FROM Instr_Classes;
SELECT /*fixed*/ * FROM Student_Class_Signup;


