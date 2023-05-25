Create table engineer(id int primary key,name varchar(255),department varchar(255),count int);
Create table data(id int primary key,name varchar(255),type varchar(255),count int);
insert into engineer values(1,'anshu','it',2);
insert into engineer values(2,'gaurav','cs',5);
insert into engineer values(3,'acb','es',8);
insert into engineer values(4,'gvf','cs',6);
insert into data values(1,'fvd','FrontEnd');
insert into data values(2,'fds','datanalyst');
select * from data;
alter table data 
drop column count;
select * from data;
SELECT SUM(COUNT) as A FROM ENGINEER INNER JOIN DATA ON ENGINEER.ID=DATA.ID WHERE TYPE='FrontEnd';
Select * from tablea inner join tableb on 