/*
1. Crear un bloque Pl/Sql que solicite el número de empleado usando una variablede sustitución y dependiendo 
del monto de su sueldo incrementar su comisión según el siguiente criterio:
Si el sueldo es menor a 1300 el incremento es de 10%
Si el sueldo está entre 1300 y 1500 el incremento es de 15%
Si el sueldo es mayor a 1500 el incremento es de 20%
Tener en cuenta que puede haber comisiones en NULL
Si el empleado no existe mandar un mensaje de error.
*/
DECLARE
n_emp employee.employee_id%type := :Emp_ID;
v_emp employee.salary%type;

BEGIN
    SELECT salary INTO v_emp FROM EMPLOYEE WHERE employee_id = n_emp;

    IF v_emp <= 1300 THEN
        UPDATE EMPLOYEE SET commission = commission + (commission * 0.10)
        WHERE commission IS NOT NULL;
       
    ELSIF v_emp BETWEEN 1300 AND 1500 THEN
        UPDATE EMPLOYEE SET commission = commission + (commission * 0.15)
        WHERE commission IS NOT NULL;

    ELSE
        UPDATE EMPLOYEE SET commission = commission + (commission * 0.20)
        WHERE commission IS NOT NULL;

    END IF;

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('No existe el empleado con ID: '||n_emp);       
    --SELECT * FROM EMPLOYEE WHERE COMMISSION IS NULL
END;
--Or-----------------------------------------------------------------
DECLARE
n_emp employee.employee_id%type := :Emp_ID;
v_emp employee.salary%type;

BEGIN
    SELECT salary INTO v_emp FROM EMPLOYEE WHERE employee_id = n_emp;

    IF v_emp <= 1300 THEN
        UPDATE EMPLOYEE SET commission = commission + (commission * 0.10)
        WHERE commission IS NOT NULL;
       
    ELSIF v_emp BETWEEN 1300 AND 1500 THEN
        UPDATE EMPLOYEE SET commission = commission + (commission * 0.15)
        WHERE commission IS NOT NULL;

    ELSE
        UPDATE EMPLOYEE SET commission = commission + (commission * 0.20)
        WHERE commission IS NOT NULL;

    END IF;
--Verificamos la cantidad de actualizaciones.
    IF SQL%ROWCOUNT > 0 THEN 
        dbms_output.put_line('Se modificaron: '||sql%rowcount||' filas.');
    ELSE
        dbms_output.put_line('No existe el empleado con ID: '||n_emp);
    END IF;
END;

/*
2. Modificar el ejercicio anterior para actualizar la comisión de todos los empleados de acuerdo
a su sueldo usando los mismos criterios. Desplegar mensajes indicando cuantos registros fueron
actualizados según cada criterio
*/

DECLARE
    v_a NUMBER;
    v_b NUMBER;
    v_c NUMBER;
BEGIN
    UPDATE EMPLOYEE
    SET commission = CASE
                        WHEN salary <= 1300 THEN commission + (commission * 0.10)
                        WHEN salary BETWEEN 1300 AND 1500 THEN commission + (commission * 0.15)
                        ELSE commission + (commission * 0.20)
                    END
    WHERE commission IS NOT NULL;

    SELECT COUNT(*) INTO v_a
    FROM employee
    WHERE salary <= 1300;
    
    SELECT COUNT(*) INTO v_b
    FROM employee
    WHERE salary BETWEEN 1300 AND 1500;
    
    SELECT COUNT(*) INTO v_c
    FROM employee
    WHERE salary > 1500;

    dbms_output.put_line('Se modificaron '||v_a||' filas de sueldos menores a 1300.');
    dbms_output.put_line('Se modificaron '||v_b||' filas de sueldos entre 1300 y 1500.');
    dbms_output.put_line('Se modificaron '||v_c||' filas de sueldos mayores a 1500.');
END;

/*
3. Crear un bloque Pl/Sql que permita dar de baja cargos que ya no se usan (usar latabla JOB):
Eliminar de la tabla JOB aquella fila cuyo Job_Id es ingresado con una variable de sustitución del SqlDeveloper.
Capturar e informar mediante excepciones o atributos del cursor , las siguientes eventualidades: no existe el 
código de cargo ingresado (Sql%Notfound o Sql%Rowcount) no puede eliminar un cargo que está asignado a empleados
(Asociar una excepción con el error correspondiente).
*/
SELECT j.function, COUNT(e.employee_id) FROM JOB j JOIN EMPLOYEE e ON (j.job_id = e.job_id) GROUP BY j.function;

DECLARE
v_j job.job_id%type := :ID_JOB;
j job.function%type;

   not_row_count EXCEPTION; --le asignamos una etiqueta breve.
    --Asociamos el numero de error -20000 con la exception definida anteriormente.
   PRAGMA EXCEPTION_INIT(not_row_count, -20000);

BEGIN
    SELECT function INTO j FROM JOB WHERE job_id = v_j;

        IF SQL%ROWCOUNT > 0 THEN
            DELETE FROM JOB WHERE function = j;
        END IF;

    EXCEPTION

        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('El JOB_ID'||v_j||' ingresado no existe.');
        WHEN not_row_count THEN
            dbms_output.put_line('El rowcount es igual a: '||SQL%ROWCOUNT||'. Es decir que no encontro el ID ingresado.');

END;

----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
--2DA PARTE--

/*
8. Usando un cursor recorrer las tablas Sales_order e Ítem para generar un listado sobre todas las 
órdenes y los productos que se ordenaron en ellas. Mostrar los siguientes datos: Order_id, order_date,
product_id.
*/

DECLARE
    CURSOR c_sales_item_cursor IS
        SELECT s.order_id, s.order_date, i.product_id
        FROM SALES_ORDER s JOIN ITEM i ON (s.order_id = i.order_id);
    --Declaro una variable que herede los atributos del cursor:
    v_sa_or c_sales_item_cursor%Rowtype;
BEGIN
    FOR i IN c_sales_item_cursor LOOP
        dbms_output.put_line('Orden: '||i.order_id||' | Fecha de orden: '||i.order_date||' | ID Producto: '||i.product_id);
    END LOOP;
END;
--Or------------------------------------------------------------------------------------------------------------------------
DECLARE
    CURSOR c_sales_item_cursor IS
        SELECT s.order_id, s.order_date, i.product_id
        FROM SALES_ORDER s JOIN ITEM i ON (s.order_id = i.order_id);
    --Declaro una variable que herede los atributos del cursor:
    v_sa_or c_sales_item_cursor%Rowtype;
BEGIN
    FOR v_sa_or IN c_sales_item_cursor LOOP
        dbms_output.put_line('Orden: '||v_sa_or.order_id||' | Fecha de orden: '||v_sa_or.order_date||' | ID Producto: '||v_sa_or.product_id);
    END LOOP;
END;

