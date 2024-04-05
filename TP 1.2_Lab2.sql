-- SECOND PART 
--1. Insertar un par de filas en la tabla JOB
INSERT INTO JOB
VALUES (673,'LOGISTICS');

INSERT INTO JOB
VALUES (674, 'ENGINEER');

--2.
--COMMIT is the SQL command that is used for storing changes performed by a transaction. 
--When a COMMIT command is issued it saves all the changes since last COMMIT or ROLLBACK.)
---- Remember: When using APEX no need to do COMMIT because to do automatically.

--3. Eliminar las filas insertadas en la tabla JOB.

DELETE JOB WHERE job_id = 673;
--COMMIT

DELETE JOB WHERE function LIKE 'ENGINEER';
--4. ROLLBACK
-- ROLLBACK is the SQL command that is used for reverting changes performed by a transaction. 
--When a ROLLBACK command is issued it reverts all the changes since last COMMIT or ROLLBACK.)

--5. Seleccionar todas las filas de la tabla JOB.
SELECT j.* FROM JOB j
--Or-----------------
SELECT * FROM JOB

--6. Modificar el nombre de un cliente.
UPDATE CUSTOMER
SET name = 'A + T SPORTS'
WHERE name LIKE 'K + T SPORTS';

--7. Crear un SAVEPOINT A
SAVEPOINT A;

--8. Modificar el nombre de otro cliente.
UPDATE CUSTOMER
SET name = 'DANCE ON ICE SPORTS'
WHERE customer_id = 107;

 --9. Crear un SAVEPOINT B
SAVEPOINT B;

--10. Hacer un ROLLBACK hasta el último SAVEPOINT creado.
ROLLBACK TO A;

--11. Hacer un SELECT de toda la tabla CUSTOMER.
SELECT * FROM CUSTOMER

--12. . Si quiero que la primera modificación del nombre de un cliente que hice quede
--asentada definitivamente en la base, debo hacer algo?.
---- Si, se debe hcaer un COMMIT.

-- 13. Eliminar el departamento 10. Se puede? Por que?
---- NO, no se puede, esto debido a que en el departamento 10 contiene empleados registrados.

-- 14. Insertar el departamento 50, ‘EDUCATION’ en la localidad 100. Se puede?
---- NO, ya que no existe la localidad 100. Error: No se ha encotrado ningun dato.

-- 15. Insertar el departamento 43, ‘OPERATIONS’ sin indicar la localidad. Se puede?
---- NO, no se puede ya que existe un departamento con el ID = 43 que corresponde a SALES. 
--De otro modo, puede insertarse con otra ID y considerando que no se indica la localidad, esta queda como NULL.

SELECT *
FROM LOCATION
WHERE location_id = 155
-- 16. Modificar la localidad del departmento 20, para que pertenezca a la localidad 155. Se puede?
---- NO, no es posible ya que no existe la localidad 155. Error: No se ha encontrado ningun dato.

-- 17. Incrementar en un 10% el salario a todos los empleados que ganan menos que el promedio de salarios.
UPDATE EMPLOYEE
SET salary = salary * 0.10 + salary
WHERE salary < (SELECT AVG(salary) FROM EMPLOYEE);

--18. A todos los clientes que han generado más de 5 órdenes, incrementar su límite de crédito en un 5%.

SELECT * FROM CUSTOMER

UPDATE CUSTOMER
SET credit_limit = credit_limit * 0.05 + credit_limit
WHERE customer_id IN (SELECT customer_id FROM SALES_ORDER
                      GROUP BY customer_id HAVING COUNT(order_id) > 5)

--19. Deshacer todos estos cambios.
ROLLBACK

--20.Crear una tabla EMP2 con 4 columnas: id number(3), nombre varchar(10), salario
--number( no puede ser nulo) y depto number(2). Definir id como clave primaria,
--nombre debe ser único y depto debe referenciar a la tabla de Department.

CREATE TABLE EMP2(
    ID NUMBER(3) PRIMARY KEY,
    NOMBRE VARCHAR(10) UNIQUE,
    SALARIO NUMBER NOT NULL,
    DEPTO NUMBER (2) REFERENCES DEPARTMENT(department_id)
)
