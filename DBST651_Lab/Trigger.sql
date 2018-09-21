set serveroutput on;
drop table dbst_student;
create table dbst_student
(stud_id numeric,
fname varchar (10),
lname varchar (20),
constraint pk_student_id primary key (stud_id)
);

create or replace trigger trig_student after insert on dbst_student
for each row
begin
dbms_output.put_line ('**This is the message from the trigger - New row inserted**');
end;
/

insert into dbst_student  (stud_id, fname, lname)
values (1, 'Yelena', 'Bytenskaya');
