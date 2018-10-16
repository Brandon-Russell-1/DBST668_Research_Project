SET ECHO ON;
SET SERVEROUTPUT ON;
/* Drop users, roles, policies, and other objects you create*/
DROP ROLE student_role;
DROP ROLE instructor_role;
DROP ROLE admin_role;
BEGIN
DBMS_RLS.DROP_POLICY(
    object_schema => 'system',
    object_name   => 'Admin_List',
    policy_name   => 'Hide_Admin_Info'
);
END;
/
/*Instructor account drop*/
BEGIN
  FOR x IN (SELECT User_Name FROM Instr_List)
  LOOP
    EXECUTE IMMEDIATE 'DROP USER '||x.User_Name;
  END LOOP;
/*Admin account drop*/
  FOR x IN (SELECT User_Name FROM Admin_List)
  LOOP
    EXECUTE IMMEDIATE 'DROP USER '||x.User_Name;
  END LOOP;
/*Student account drop*/
  FOR x IN (SELECT User_Name FROM Student_List)
  LOOP
    EXECUTE IMMEDIATE 'DROP USER '||x.User_Name;
  END LOOP;
END;
/
/*Username Procedure - Create user names for every user*/
ALTER TABLE Admin_List ADD User_Name VARCHAR2(45);
ALTER TABLE Instr_List ADD User_Name VARCHAR2(45);
ALTER TABLE Student_List ADD User_Name VARCHAR2(45);

UPDATE Admin_List a SET User_Name =
    (SELECT CONCAT(UPPER(CONCAT(SUBSTR(Admin_FName,1,1),Admin_LName)), Admin_Num) 
        FROM Admin_List b WHERE a.Admin_Num = b.Admin_Num); 

UPDATE Instr_List a SET User_Name =
    (SELECT CONCAT(UPPER(CONCAT(SUBSTR(Instr_FName,1,1),Instr_LName)), Instr_Num) 
        FROM Instr_List b WHERE a.Instr_Num = b.Instr_Num); 

UPDATE Student_List a SET User_Name =
    (SELECT CONCAT(UPPER(CONCAT(SUBSTR(Student_FName,1,1),Student_LName)), Student_Num) 
        FROM Student_List b WHERE a.Student_Num = b.Student_Num);         


/*Password Procedure - Create Instructor user accounts*/
DECLARE
s_num INTEGER;
begin
s_num :=0;
  for x in (SELECT User_Name FROM Instr_List)
  loop
    execute immediate 'CREATE USER '||x.User_Name||' IDENTIFIED BY TheSecPass'||s_num;
    s_num := s_num +1;
  end loop;
/*Create Admin user accounts*/
s_num :=0;
  for x in (SELECT User_Name FROM Admin_List)
  loop
    execute immediate 'CREATE USER '||x.User_Name||' IDENTIFIED BY TheSecPass'||s_num;
    s_num := s_num +1;
  end loop;
/*Create Student user accounts*/
s_num :=0;
  for x in (SELECT User_Name FROM Student_List)
  loop
    execute immediate 'CREATE USER '||x.User_Name||' IDENTIFIED BY TheSecPass'||s_num;
    s_num := s_num +1;
  end loop;
/*Connection Prodcedure - grant create session*/
/*Instructor account*/
for x in (SELECT User_Name FROM Instr_List)
  loop
    execute immediate 'GRANT CREATE SESSION TO '||x.User_Name;
  end loop;
/*Admin account*/
  for x in (SELECT User_Name FROM Admin_List)
  loop
    execute immediate 'GRANT CREATE SESSION TO '||x.User_Name;
  end loop;
/*Student account*/
  for x in (SELECT User_Name FROM Student_List)
  loop
    execute immediate 'GRANT CREATE SESSION TO '||x.User_Name;
  end loop;
end;
/
/*Role Assignment Procedure*/
/*Create roles*/
CREATE ROLE admin_role;
CREATE ROLE instructor_role;
CREATE ROLE student_role;
/*Assign roles*/
begin
  for x in (SELECT User_Name FROM Admin_List)
  loop
    execute immediate 'GRANT admin_role TO '||x.User_Name;
  end loop;
  for x in (SELECT User_Name FROM Instr_List)
  loop
    execute immediate 'GRANT instructor_role TO '||x.User_Name;
  end loop;
  for x in (SELECT User_Name FROM Student_List)
  loop
    execute immediate 'GRANT student_role TO '||x.User_Name;
  end loop;
end;
/
/*Account Modify Procedure - Admins can only select & update the Admin_List table. Other User tables they have full rights.*/
GRANT SELECT, UPDATE ON Admin_List TO admin_role;
GRANT SELECT, INSERT, DELETE, UPDATE ON Instr_List TO admin_role;
GRANT SELECT, INSERT, DELETE, UPDATE ON Student_List TO admin_role;

/*Course Management Procedure - Admin have full rights to course information*/
GRANT SELECT, INSERT, DELETE, UPDATE ON Course_List TO admin_role;

/*Section Management Procedure - Admins have full rights to section information*/
GRANT SELECT, INSERT, DELETE, UPDATE ON Section_Info TO admin_role;

/*Class Schedule Modify Procedure - Admins have full rights to the class schedule*/
GRANT SELECT, INSERT, DELETE, UPDATE ON Class_Sched TO admin_role;

/*Admin Support Procedure - Admins have the ability to assist with adding classes for instructors or signing up students
  for classes if necessary.*/
GRANT SELECT, INSERT, DELETE, UPDATE ON Instr_Classes TO admin_role;
GRANT SELECT, INSERT, DELETE, UPDATE ON Student_Class_Signup TO admin_role;

/*Admin Account Restriction Policy*/
/*Use VPD to create policy restricting admin to only be able to view and update their information. Only the SYSTEM user 
  can update this table.*/
CREATE OR REPLACE FUNCTION Get_Admin_Name (
 schema_v IN VARCHAR2, 
 tbl_v IN VARCHAR2)

RETURN VARCHAR2 IS
BEGIN
 RETURN ('User_Name = USER OR USER = ''SYSTEM''') ;
END Get_Admin_Name;
/
BEGIN
 DBMS_RLS.ADD_POLICY (
  object_schema     => 'system', 
  object_name       => 'Admin_List',
  policy_name       => 'Hide_Admin_Info', 
  policy_function   => 'Get_Admin_Name',
  statement_types   => 'select, update');
END;
/

/*Test Admin restriction policy*/

CONNECT bevans1/TheSecPass0; /*Test admin account*/
show user;
SELECT * FROM system.Admin_List;

CONNECT mlopez3/TheSecPass2; /*Test instructor account*/
show user;
SELECT * FROM system.Admin_List;

CONNECT system/brr1wik7 /*Test system account*/
show user;
SELECT * FROM Admin_List;

/*Instructor View Procedure - Personal info, section info, class schedule with course info, name and student number enrolled in classes.
Also, complete class schedule without student names.*/
/*Show personal info*/
CREATE OR REPLACE VIEW Instr_Personal_Info AS
SELECT * FROM Instr_List 
    WHERE Instr_List.User_Name = USER;
GRANT SELECT ON Instr_Personal_Info TO instructor_role;

/*Show section info*/
CREATE OR REPLACE VIEW Instr_Section_Info AS
    SELECT * FROM Section_Info
        INNER JOIN Instr_List USING (Section_Num)
            WHERE Instr_List.User_Name = USER;
GRANT SELECT ON Instr_Section_Info TO instructor_role;

/*Show class schedules info*/
GRANT SELECT ON Class_Sched TO instructor_role;

/*Show course info*/
GRANT SELECT ON Course_List TO instructor_role;

/*Show class schedule and course info*/            
CREATE OR REPLACE VIEW Instr_Class_Course_Info AS
SELECT Course_Name, Course_Desc, Course_Hours, Admin_LName, Admin_FName,
    Sched_Day, Sched_Time, Sched_Day_Off, Sched_Notes, 
        Class_Notes, Class_Room FROM Instr_List INNER JOIN Instr_Classes USING (Instr_Num)
            INNER JOIN Class_Sched USING (Sched_Num)
            INNER JOIN Course_List USING (Course_Num)
            INNER JOIN Admin_List USING (Admin_Num)
                WHERE Instr_List.User_Name = USER;
GRANT SELECT ON Instr_Class_Course_Info TO instructor_role;                

/*Show students enrolled in classes*/
CREATE OR REPLACE VIEW Instr_Student_Class AS
    SELECT Course_Name, Sched_Day, Sched_Time, Sched_Day_Off, Class_Room, 
            Student_Num, Student_LName, Student_FName, Student_Grade FROM Instr_List INNER JOIN Instr_Classes USING (Instr_Num)
                INNER JOIN Class_Sched USING (Sched_Num)
                INNER JOIN Course_List USING (Course_Num)
                INNER JOIN Student_Class_Signup USING (Instr_Num, Sched_Num)
                INNER JOIN Student_List USING (Student_Num)
                    WHERE Instr_List.User_Name = USER;
GRANT SELECT ON Instr_Student_Class TO instructor_role;

/*Show entire class schedule*/
CREATE OR REPLACE VIEW Instr_All_Class AS
SELECT Instr_LName, Instr_FName, Course_Name, Course_Desc, Course_Hours, Admin_LName, Admin_FName,
    Sched_Day, Sched_Time, Sched_Day_Off, Sched_Notes, 
        Class_Notes, Class_Room FROM Instr_List INNER JOIN Instr_Classes USING (Instr_Num)
            INNER JOIN Class_Sched USING (Sched_Num)
            INNER JOIN Course_List USING (Course_Num)
            INNER JOIN Admin_List USING (Admin_Num);
GRANT SELECT ON Instr_All_Class TO instructor_role;  


/*Test Instructor View Policy*/
CONNECT mlopez3/TheSecPass2;
show user;
SELECT /*fixed*/* FROM system.Instr_Personal_Info;
SELECT /*fixed*/* FROM system.Instr_Section_Info;
SELECT /*fixed*/* FROM system.Instr_Class_Course_Info;
SELECT /*fixed*/* FROM system.Instr_Student_Class;
SELECT /*fixed*/* FROM system.Instr_All_Class;
SELECT /*fixed*/* FROM system.Class_Sched;
SELECT /*fixed*/* FROM system.Course_List;

CONNECT sgilbert1/TheSecPass0;
show user;
SELECT /*fixed*/* FROM system.Instr_Personal_Info;
SELECT /*fixed*/* FROM system.Instr_Section_Info;
SELECT /*fixed*/* FROM system.Instr_Class_Course_Info;
SELECT /*fixed*/* FROM system.Instr_Student_Class;
SELECT /*fixed*/* FROM system.Instr_All_Class;
SELECT /*fixed*/* FROM system.Class_Sched;
SELECT /*fixed*/* FROM system.Course_List;

CONNECT system/brr1wik7;    
show user;
/*Instructor Modify Procedure*/

/*Update personal info*/
GRANT UPDATE ON Instr_Personal_Info TO instructor_role;

/*Update their class schedule*/
CREATE OR REPLACE VIEW Instr_Classes_Update AS
    SELECT * FROM Instr_Classes INNER JOIN Instr_List USING (Instr_Num)
        WHERE Instr_List.User_Name = USER;
GRANT SELECT, UPDATE ON Instr_Classes_Update TO instructor_role;  

/*Update student grade enrolled in their classes. Remove students from their classes*/
CREATE OR REPLACE VIEW Instr_Student_Modify AS
    SELECT Student_Num, Instr_Num, Sched_Num, Student_Grade FROM Instr_List INNER JOIN Instr_Classes USING (Instr_Num)
        INNER JOIN Student_Class_Signup USING (Instr_Num, Sched_Num)
            WHERE Instr_List.User_Name = USER;
GRANT SELECT, UPDATE, DELETE ON Instr_Student_Modify TO instructor_role;

/*Test instructor update on personal info*/
CONNECT mlopez3/TheSecPass2;
show user;
UPDATE system.Instr_Personal_Info SET Instr_Address = '867 Orange St';
SELECT /*fixed*/* FROM system.Instr_Personal_Info;

/*Test student account access*/
CONNECT sgilbert1/TheSecPass0;
show user;
UPDATE system.Instr_Personal_Info SET Instr_Address = '867 Orange St';
SELECT /*fixed*/* FROM system.Instr_Personal_Info;

/*Test instructor ability to select and update on their class schedule*/
CONNECT mlopez3/TheSecPass2;
show user;
SELECT /*fixed*/* FROM system.Instr_Classes_Update;
UPDATE system.Instr_Classes_Update SET Class_Notes = 'A/C Broke' WHERE Instr_Num = 3 AND Sched_Num = 3;
SELECT /*fixed*/* FROM system.Instr_Classes_Update;

/*Test Select & Update with instructor trying to update another instructor's class*/
CONNECT brussell2/TheSecPass1;
show user;
SELECT /*fixed*/* FROM system.Instr_Classes_Update;
UPDATE system.Instr_Classes_Update SET Class_Notes = 'A/C Broke' WHERE Instr_Num = 3 AND Sched_Num = 3;
SELECT /*fixed*/* FROM system.Instr_Classes_Update;


/*Test instructor ability to select, update, and delete students from their class*/
CONNECT mlopez3/TheSecPass2;
show user;
SELECT /*fixed*/* FROM system.Instr_Student_Modify;
UPDATE system.Instr_Student_Modify SET Student_Grade = 'F' WHERE Student_Num = 2;
SELECT /*fixed*/* FROM system.Instr_Student_Modify;
DELETE FROM system.Instr_Student_Modify WHERE Student_Num = 2;
SELECT /*fixed*/* FROM system.Instr_Student_Modify;

/*Test student access*/
CONNECT sgilbert1/TheSecPass0;
show user;
SELECT /*fixed*/* FROM system.Instr_Student_Modify;
UPDATE system.Instr_Student_Modify SET Student_Grade = 'F' WHERE Student_Num = 2;
DELETE FROM system.Instr_Student_Modify WHERE Student_Num = 2;
SELECT /*fixed*/* FROM system.Instr_Student_Modify;

CONNECT system/brr1wik7;    
show user;
/*Student View Procedure*/
/*Show personal info*/
CREATE OR REPLACE VIEW Student_Personal_Info AS
SELECT * FROM Student_List 
    WHERE Student_List.User_Name = USER;
GRANT SELECT ON Student_Personal_Info TO student_role;

/*View the instructor class schedule*/
GRANT SELECT ON Instr_All_Class TO student_role; 


/*See what classes they are enrolled in and their grade*/
CREATE OR REPLACE VIEW Student_Class_Grade_View AS
    SELECT Student_LName, Student_FName, Course_Name, Student_Grade,
                Instr_LName, Instr_FName, Sched_Day, Sched_Time, Sched_Day_Off, Class_Room 
                    FROM Student_List INNER JOIN Student_Class_Signup USING (Student_Num)
                        INNER JOIN Instr_Classes USING (Instr_Num, Sched_Num)
                        INNER JOIN Class_Sched USING (Sched_Num)
                        INNER JOIN Course_List USING (Course_Num)
                        INNER JOIN Instr_List USING (Instr_Num)
                            WHERE Student_List.User_Name = USER;
GRANT SELECT ON Student_Class_Grade_View TO student_role;


/*Test Student View personal info*/
CONNECT sgilbert1/TheSecPass0;
show user;
SELECT /*fixed*/* FROM system.Student_Personal_Info;

/*Test instructor access*/
CONNECT mlopez3/TheSecPass2;
show user;
SELECT /*fixed*/* FROM system.Student_Personal_Info;

/*Test Student View instructor clas schedule*/
CONNECT sgilbert1/TheSecPass0;
show user;
SELECT /*fixed*/* FROM system.Instr_All_Class;

/*Test Student View classes enrolled in and grade*/
CONNECT sgilbert1/TheSecPass0;
show user;
SELECT /*fixed*/* FROM system.Student_Class_Grade_View;
/*Test instructor access*/
CONNECT mlopez3/TheSecPass2;
show user;
SELECT /*fixed*/* FROM system.Student_Class_Grade_View;

CONNECT system/brr1wik7;    
show user;
/*Student Modify Procedure*/
  
/*Student update personal information*/
GRANT UPDATE ON Student_Personal_Info TO student_role;
/*Student enroll in classes*/
/*Trigger for Student class enrollment - Prevent students from signing other students up for class.*/
CREATE OR REPLACE TRIGGER Student_Class_Signup_Trigger
BEFORE INSERT
   ON Student_Class_Signup
   FOR EACH ROW

DECLARE
   Tmp_Counter INTEGER;
   Tmp_Student_Num INTEGER;
BEGIN
    /*Only run code for Student users*/
    SELECT count(*) into Tmp_Counter FROM Student_List WHERE Student_List.User_Name = USER;
    IF Tmp_Counter > 0 THEN
        SELECT Student_Num INTO Tmp_Student_Num FROM Student_List WHERE Student_List.User_Name = USER;
            :new.Student_Num := Tmp_Student_Num;
    END IF;
END;
/
GRANT INSERT  ON Student_Class_Signup TO student_role;

/*Test update personal info*/
CONNECT sgilbert1/TheSecPass0;
show user;
UPDATE system.Student_Personal_Info SET Student_ZipCode = '90210';

/*Test instructor access*/
CONNECT mlopez3/TheSecPass2;
show user;
UPDATE system.Student_Personal_Info SET Student_ZipCode = '90210';


/*Test enroll in class*/
CONNECT sgilbert1/TheSecPass0;
show user;
INSERT INTO system.Student_Class_Signup (Student_Num, Instr_Num, Sched_Num,  Student_Grade)
        VALUES                ( 3,6, 6,  'A');

/*Test instructor access*/
CONNECT mlopez3/TheSecPass2;
show user;
INSERT INTO system.Student_Class_Signup (Student_Num, Instr_Num, Sched_Num,  Student_Grade)
        VALUES                ( 3,6, 6,  'A');

/*Test admin access*/
CONNECT bevans1/TheSecPass0;
show user;
INSERT INTO system.Student_Class_Signup (Student_Num, Instr_Num, Sched_Num,  Student_Grade)
        VALUES                ( 3,6, 6,  'A');

CONNECT system/brr1wik7
show user;        


