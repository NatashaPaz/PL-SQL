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
