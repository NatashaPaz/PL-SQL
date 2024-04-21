/* 
1. Determinar si estas declaraciones son correctas: 
--- V_var number(8,3); -> Correcta.
--- V_a, V-b number; -> Incorrecta.
--- V_fec_ingreso Date := sysdate +2; -> Correcta.
--- V_nombre varchar2(30) not null; -> Incorrecta. Se debe asignar un valor.
--- V_logico boolean default ‘TRUE’; -> Incorrecta. Sin comillas.
*/

DECLARE
v_a VARCHAR2(100);
v_var number(8,3);
V_fec_ingreso Date := sysdate +2;
v_nombre varchar2(30) not null := 'Pedro';
V_logico boolean default TRUE;

BEGIN
v_a := 'Texto en variable v_a';
DBMS_OUTPUT.PUT_LINE('Pruebas Ej1 Correctas.');
END;


/*
2. Crear un bloque anónimo para desplegar los siguientes mensajes:
‘Hola , soy ‘ username‘ Hoy es: ‘ dd – Mon – yyyy’. (mostrar la fecha del día).
*/

DECLARE
username VARCHAR2(30):= :user;
fecha DATE:= sysdate;     
BEGIN 
    dbms_output.put_line('Hola soy '|| username ||'. Hoy es '||fecha);
END;
--Or----------------------------------------------------------------------
DECLARE
username VARCHAR2(30);
fecha DATE;
BEGIN 
    username := :user;
    fecha := sysdate;
    dbms_output.put_line('Hola soy ' username '. Hoy es '||fecha);
END;

/* 
3. Crear un bloque anónimo para desplegar los primeros n números múltiplos de 3.
El valor de n debe ingresarse por pantalla usando una variable de sustitución del SqlDeveloper. 
Si n > 10 desplegar un mensaje de advertencia y terminar el bloque.
*/

DECLARE
v_n NUMBER := :Num;
V_i NUMBER := 1;
BEGIN
    IF v_n > 10 THEN
        DBMS_OUTPUT.PUT_LINE('El valor de n no puede ser mayor a 10.');
    ELSE
        WHILE V_i <= v_n LOOP
            DBMS_OUTPUT.PUT_LINE(V_i * 3);
            V_i := V_i + 1;
        END LOOP;
    END IF;
END;

/*
4. Crear un bloque Pl/Sql para consultar el salario de un empleado dado: 
Ingresar el id del empleado usando una variable de sustitución 
Desplegar por pantalla el siguiente texto: First_name, Last_name tiene un salario de Salary pesos.
*/

DECLARE
r_emp employee%Rowtype;
v_emp NUMBER := :Empleado_id;

BEGIN
    
    SELECT *
    INTO r_emp
    FROM EMPLOYEE 
    WHERE employee_id = v_emp;

    dbms_output.put_line(r_emp.first_name ||' '||r_emp.last_name ||' tiene un salario de: '||r_emp.salary);

END;
    
/*
5. Escribir un bloque para desplegar todos los datos de una orden dada. 
Ingresar el nro de orden usando una variable de sustitución. 
En una variable de tipo record recuperar toda la información y desplegarla usando Dbms_output.
Que pasa si la orden no existe?
Si la orden no existe lo manejo con la excepcion NO_DATA_FOUND.
*/
DECLARE
v_order 
