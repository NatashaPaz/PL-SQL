--PRACTICA UNIDAD 1

--1. Consultar las tablas existentes en su cuenta, ver su estructura y contenido. 
SELECT *
FROM user_tables;

--2. Mostrar las distintas funciones (jobs) que pueden cumplir los empleados.
SELECT DISTINCT FUNCTION
FROM JOB;

--3. Desplegar el nombre completo de todos los empleados (Ej: Adam, Diane) ordenados por apellido.
SELECT last_name, first_name
FROM EMPLOYEE
ORDER BY 1;

--4. Mostrar el nombre y el apellido de los empleados que ganan entre $1500 y $2850
SELECT first_name, last_name
FROM EMPLOYEE
WHERE salary BETWEEN 1500 AND 2850;

--5. Mostrar el nombre y la fecha de ingreso de todos los empleados que ingresaron en el año 2006.
SELECT first_name, hire_date
FROM EMPLOYEE
WHERE hire_date BETWEEN '1-1-2006' AND '31-12-2006';

--6. Mostrar el id y nombre de todos los departamentos de la localidad 122.
SELECT department_id, name
FROM DEPARTMENT
WHERE location_id = 122;
------------------------------------------------
SELECT e.employee_id, d.name --with employee_id
FROM EMPLOYEE e, DEPARTMENT d
WHERE e.department_id = d.department_id 
AND d.location_id = 122
------------------------------------------------
--7. Modificar el ejercicio anterior para que la localidad pueda ser ingresada en el momento de efectuar la consulta
SELECT department_id, name
FROM DEPARTMENT
WHERE location_id = :pp;--ingresar por teclado

--8. Mostrar el nombre y salario de los empleados que no tienen jefe
SELECT first_name, salary
FRO. M EMPLOYEE
WHERE manager_id IS NULL;

--9. Mostrar el nombre de los empleados, su comisión y un cartel que diga ¨Sin comisión¨ para aquellos empleados que tienen su comisión en nulo.
SELECT first_name,last_name, NVL(TO_CHAR(commission), 'Sin Comision') commission
FROM EMPLOYEE
WHERE commission IS NULL;

--10. . Mostrar el nombre completo de los empleados, el número de departamento y el nombre del departamento donde trabajan.
SELECT e.first_name, e.last_name, d.department_id, d.name
FROM EMPLOYEE e, DEPARTMENT d
WHERE e.department_id = d.department_id;

--11. . Mostrar el nombre y apellido, la función que ejercen, el nombre del departamento y
--el salario de todos los empleados ordenados por su apellido.
SELECT e.first_name, e.last_name, j.function, d.name, e.salary
FROM EMPLOYEE e, DEPARTMENT d, JOB j
WHERE e.department_id = d.department_id
AND e.job_id = j.job_id
ORDER BY 2;
----------------------------------------------------------------
SELECT e.first_name, e.last_name, j.function, d.name, e.salary
FROM EMPLOYEE e JOIN DEPARTMENT d
ON e.department_id = d.department_id JOIN JOB j
ON e.job_id = j.job_id
ORDER BY 2;

--12. Para todos los empleados que cobran comisión, mostrar su nombre, el nombre del
--departamento donde trabajan y el nombre de la región a la que pertenece el
--departamento.
SELECT e.first_name, e.last_name, d.name, l.regional_group
FROM EMPLOYEE e, DEPARTMENT d, LOCATION l
WHERE e.department_id = d.department_id AND d.location_id = l.location_id
AND e.commission IS NOT NULL;
--------------------------------------------------------------------------
SELECT e.first_name, e.last_name, d.name, l.regional_group
FROM EMPLOYEE e JOIN DEPARTMENT d
ON e.department_id = d.department_id JOIN LOCATION l
ON d.location_id = l.location_id
AND e.commission IS NOT NULL;

--13. Para cada empleado mostrar su id, apellido, salario y grado de salario.
SELECT e.employee_id, e.last_name, salary, g.grade_id
FROM EMPLOYEE e JOIN SALARY_GRADE g
ON e.salary BETWEEN g.lower_bound AND g.upper_bound;

--14. Mostrar el número y nombre de cada empleado junto con el número de empleado y 
--nombre de su jefe.
SELECT e.employee_id, e.first_name, j.employee_id, j.first_name
FROM EMPLOYEE e, EMPLOYEE j
WHERE e.manager_id = j.employee_id; 

--15. Modificar el ejercicio anterior para mostrar también aquellos empleados que no
--tienen jefe.
SELECT e.employee_id, e.first_name, j.employee_id, j.first_name
FROM EMPLOYEE e LEFT OUTER JOIN EMPLOYEE j
ON e.employee_id = j.manager_id; 
-- El left join nos permite obtener tambien aquellos empleados que no tienen un manager.
--OR-------------------------------------------------------------
SELECT e.employee_id "Nro MANAGER", e.first_name AS MANAGER, j.employee_id, j.first_name
FROM EMPLOYEE e, EMPLOYEE j
WHERE e.employee_id = j.manager_id(+)

--16. Mostrar las órdenes de venta, el nombre del cliente al que se vendió y la descripción
--de los productos. Ordenar la consulta por nro. de orden.

SELECT s.order_id "N° ORDEN", c.name, p.description
FROM CUSTOMER c JOIN SALES_ORDER s
ON (c.customer_id = s.customer_id) JOIN ITEM i
ON (s.order_id = i.order_id) JOIN PRODUCT p
ON (i.product_id = p.product_id)
ORDER BY 1;
--Or---------------------------------------------------
SELECT s.order_id "N° ORDEN", c.name, p.description
FROM SALES_ORDER s JOIN CUSTOMER c 
ON c.customer_id = s.customer_id JOIN PRODUCT p 
ON p.product_id IN (
    SELECT i.product_id
    FROM ITEM i
    WHERE s.order_id = i.order_id
)
ORDER BY s.order_id;

--17. Mostrar la cantidad de clientes.
SELECT COUNT(DISTINCT CUSTOMER_ID)
FROM CUSTOMER

--18. Mostrar la cantidad de clientes del estado de Nueva York (NY).
SELECT COUNT(DISTINCT customer_id)
FROM CUSTOMER
WHERE state LIKE 'NY'

--19. Mostrar la cantidad de empleados que son jefes. Nombrar a la columna JEFES.
SELECT COUNT(DISTINCT e.employee_id) AS JEFES
FROM EMPLOYEE e JOIN JOB j
ON e.job_id = j.job_id 
WHERE j.function LIKE 'MANAGER' 
OR j.function LIKE 'PRESIDENT';
--Or---------------------------------------
SELECT COUNT(DISTINCT e.employee_id) AS JEFES
FROM EMPLOYEE e JOIN JOB j
ON e.job_id = j.job_id 
WHERE j.function IN ('MANAGER','PRESIDENT');

--20. Mostrar toda la información del empleado más antiguo.
SELECT *
FROM EMPLOYEE
WHERE hire_date = (SELECT MIN(DISTINCT hire_date) FROM EMPLOYEE) ;

--21.  Generar un listado con el nombre completo de los empleados, el salario, y el nombre
--de su departamento para todos los empleados que tengan el mismo cargo que John
--Smith. Ordenar la salida por salario y apellido.
SELECT e.first_name, e.last_name, e.salary, d.name
FROM DEPARTMENT d JOIN EMPLOYEE e
ON d.department_id = e.department_id
WHERE e.job_id = (SELECT job_id 
                    FROM EMPLOYEE 
                    WHERE first_name LIKE 'John'
                    AND last_name LIKE 'Smith')
ORDER BY e.salary, e.last_name;

--22. Seleccionar los nombres completos, el nombre del departamento y el salario de
--aquellos empleados que ganan más que el promedio de salarios.

SELECT e.first_name, e.last_name, d.name, e.salary
FROM DEPARTMENT d JOIN EMPLOYEE e
ON d.department_id = e.department_id
WHERE salary > (SELECT AVG(salary) FROM EMPLOYEE);

--23. Mostrar los datos de las ordenes maxima y minima.
SELECT s.*
FROM SALES_ORDER s                                                  
WHERE s.order_id IN (SELECT MAX(order_id) FROM SALES_ORDER UNION
                     SELECT MIN(order_id) FROM SALES_ORDER)
--UNION: se utiliza para combinar los resultados de dos o más 
--consultas en una sola lista de resultados. La consulta devuelve
--todas las filas de ambas consultas y elimina cualquier duplicado
--que pueda haber entre ellas.

--24. Mostrar la cantidad de ordenes agrupadas por el cliente.
SELECT customer_id, COUNT(order_id)
FROM SALES_ORDER 
GROUP BY customer_id;

--25. Modificar el ejercicio anterior para desplegar también el
--nombre y teléfono del cliente. 
SELECT s.customer_id, c.name, c.phone_number, COUNT(s.order_id) "CANT_ORDENES"
FROM SALES_ORDER s, CUSTOMER c
WHERE s.customer_id = c.customer_id
GROUP BY s.customer_id, c.name, c.phone_number;

--26. Mostrar aquellos empleados que tienen dos ó más personas a su cargo.
SELECT e.first_name, e.last_name, COUNT(e.employee_id) AS CANTIDAD
FROM EMPLOYEE e, EMPLOYEE m
WHERE e.employee_id = m.manager_id
GROUP BY e.first_name, e.last_name
HAVING COUNT(e.employee_id) >= 2;

--27. Desplegar el nombre del empleado más antiguo y del empleado más nuevo, 
--(según su fecha de ingreso).

SELECT first_name, last_name, hire_date
FROM EMPLOYEE
WHERE hire_date IN (SELECT MAX(hire_date) FROM EMPLOYEE UNION
                   SELECT MIN(hire_date) FROM EMPLOYEE)

--28.Mostrar la cantidad de empleados que tiene los departamentos 20 y 30.
SELECT department_id, COUNT(department_id) "CANT_EMPLOYEE"
FROM EMPLOYEE
WHERE department_id IN (20,30)
GROUP BY department_id;

--29. Mostrar el promedio de salarios de los empleados de los departamentos 
--de investigación (Research). Redondear el promedio a dos decimales.
SELECT ROUND(AVG(e.salary),2)
FROM EMPLOYEE e JOIN DEPARTMENT d
ON e.department_id = d.department_id
WHERE d.name LIKE 'RESEARCH'
--Or------------------------------------
SELECT ROUND(AVG(salary),2)
FROM EMPLOYEE 
WHERE department_id IN (SELECT department_id FROM DEPARTMENT
                        WHERE name LIKE 'RESEARCH')

--30. Por cada departamento desplegar su id, su nombre y el promedio de 
--salarios (sin decimales) de sus empleados. El resultado ordenarlo por 
--promedio.

SELECT d.department_id, d.name, ROUND(AVG(e.salary),0) AS PROMEDIO
FROM EMPLOYEE e JOIN DEPARTMENT d
ON e.department_id = d.department_id
GROUP BY d.department_id, d.name
ORDER BY 3;

--31. Modificar el ejercicio anterior para mostrar solamente los departamentos 
--que tienen más de 3 empleados.

SELECT DISTINCT d.name, COUNT(e.employee_id) AS CANTIDAD
FROM EMPLOYEE e JOIN DEPARTMENT d
ON e.department_id = d.department_id
GROUP BY d.name
HAVING COUNT(e.employee_id) > 3

--32. Por cada producto (incluir todos los productos) mostrar la 
--cantidad de unidades que se han pedido y el precio máximo que se 
--ha facturado. 

SELECT p.product_id, p.description, SUM(quantity) CANTIDAD, MAX(actual_price) MAX_PRICE
FROM PRODUCT p JOIN ITEM i
ON p.product_id = i.product_id
GROUP BY p.product_id, p.description;

--33. Para cada cliente mostrar nombre, teléfono, la cantidad de órdenes emitidas y la
--fecha de su última orden. Ordenar el resultado por nombre de cliente.
SELECT c.name, c.phone_number, COUNT(s.order_id) CANT_ORDER, MAX(s.order_date) LAST_DATE
FROM CUSTOMER c JOIN SALES_ORDER s
ON c.customer_id = s.customer_id
GROUP BY c.name, c.phone_number
ORDER BY c.name;

--34. Para todas las localidades mostrar sus datos, la cantidad de empleados que tiene y el
--total de salarios de sus empleados. Ordenar por cantidad de empleados.
SELECT l.location_id, l.regional_group, COUNT(e.employee_id) CANTIDAD_EM, SUM(e.salary) TOTAL_SALARY
FROM LOCATION l JOIN DEPARTMENT d
ON (l.location_id = d.location_id) JOIN EMPLOYEE e
ON (d.department_id = e.department_id)
GROUP BY l.location_id, l.regional_group
ORDER BY 3; 

--35. Mostrar los empleados que ganan más que su jefe. El reporte debe mostrar el nombre
--completo del empleado, su salario, el nombre del departamento al que pertenece y la 
--función que ejerce.
SELECT e.first_name, e.last_name, e.salary, d.name, j.function
FROM JOB j JOIN EMPLOYEE e
ON (j.job_id = e.job_id) JOIN DEPARTMENT d
ON (e.department_id = d.department_id)
WHERE e.salary > (SELECT salary FROM EMPLOYEE WHERE employee_id = e.manager_id);



