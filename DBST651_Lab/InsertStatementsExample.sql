drop table orders;
drop table customer;
drop sequence seq_order;

create table customer
(
   Customer_id numeric,
   FirstName   varchar2 (20),
   LastNane    varchar2 (30) ,
   Nickname    varchar2 (20),
   Gender      char (1),
   constraint  pk_customer_id primary key(customer_id)
);

create table orders
(
   Order_id            numeric,
   OrderDate           date,
   ShortDescription    varchar2 (40) ,
   Price               numeric,
   ShippingMethod      varchar2 (20),
   Customer_id         numeric,
   constraint  pk_order_id primary key (order_id),
   constraint  fk_customer_id foreign key (customer_id) references customer (customer_id)
);

create sequence seq_order 
start with 1
increment by 1;

insert into customer
  (Customer_id,  FirstName,  LastNane,     Nickname, Gender)
values 
  (1,            'Yelena',   'Bytenskaya', 'YB',     'F');

insert into customer
  (Customer_id,  FirstName,  LastNane,    Nickname, Gender)
values 
  (2,            'Monna',   'Davis',      'Monna',  'F');

insert into orders
  (Order_id,          OrderDate,                              ShortDescription,   Price, ShippingMethod, Customer_id)
values
  (seq_order.nextval, to_date ('22-May-2014','dd-Mon-yyyy' ), 'DBST 651 textbook', 50,   'USPS Ground',  1);
      
insert into orders
  (Order_id,          OrderDate,                              ShortDescription,   Price, ShippingMethod, Customer_id)
values
  (seq_order.nextval, to_date ('25-Jun-2014','dd-Mon-yyyy' ), 'Bookshelf',        150,   'FedEx',        2);
  
  
  insert into orders
  (Order_id,          OrderDate,                              ShortDescription,   Price, ShippingMethod, Customer_id)
values
  (seq_order.nextval, to_date ('25-Jun-2014','dd-Mon-yyyy' ), 'Bookshelf',        150,   'FedEx',        3);

select * from customer;

select * from orders;