create table VVV_t(
    id number(3) primary key,
    description varchar2(50)
    );
    
insert into VVV_t(id, description) values(1, 'Первая строка');
insert into VVV_t(id, description) values(2, 'Вторая строка');
insert into VVV_t(id, description) values(3, 'Третья строка');
 
update VVV_t
set description = 'Изменённая строка 1'
where id = 1;

update VVV_t
set description = 'Изменённая строка 2'
where id = 2;

commit  ;

select * from VVV_t where id > 1;
select 
    count(*) as total_rows ,
    avg(length(description)) as avg_lenght 
from VVV_t;

delete from VVV_t where id = 2;

rollback;


create table VVV_t_child(
    id number(3) primary key,
    parent_id number(3),
    description varchar2(50),
    constraint fk_vvv FOREIGN key (parent_id) references VVV_t(id) on delete cascade
    );
    
INSERT INTO VVV_t_child(id, parent_id, description) VALUES (1, 1, 'Дочерняя строка 1');
INSERT INTO VVV_t_child(id, parent_id, description) VALUES (2, 1, 'Дочерняя строка 2');
INSERT INTO VVV_t_child(id, parent_id, description) VALUES (3, 2, 'Дочерняя строка 3');

COMMIT;

select 
    p.id as parent_id,
    p.description as parent_Description,
    c.id as child_id,
    c.description as child_description
from VVV_t p
left join VVV_t_child c on p.id = c.parent_id;

select 
    p.id as parent_id,
    p.description as parent_Description,
    c.id as child_id,
    c.description as child_description
from VVV_t p
INNER join VVV_t_child c on p.id = c.parent_id;



drop table VVV_t_child;
drop table VVV_t;

commit;