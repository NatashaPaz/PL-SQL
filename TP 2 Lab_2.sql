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
v_order SALES_ORDER%Rowtype;
v_nro NUMBER := :Nro_Order;

Type tipo_r IS RECORD(id NUMBER, fecha DATE, idcliente NUMBER, envio DATE, total NUMBER(8,1));
new_order tipo_r;

BEGIN

    SELECT * INTO v_order FROM SALES_ORDER WHERE order_id = v_nro;
    new_order.id := v_order.order_id;
    new_order.fecha := v_order.order_date;
    new_order.idcliente := v_order.customer_id;
    new_order.envio := v_order.ship_date;
    new_order.total := v_order.total;

    dbms_output.put_line(new_order.id||' '||new_order.fecha||' '||new_order.idcliente||
                    ' '||new_order.envio||' '||new_order.total);

    EXCEPTION
    WHEN NO_DATA_FOUND THEN 
    dbms_output.put_line('No existe la orden con el ID: '||v_nro);

END;

/*
6.Escribir un bloque para mostrar la cantidad de órdenes que emitió un cliente dado siguiendo las siguientes consignas:
Ingresar el id del cliente una variable de sustitución
Si el cliente emitió menos de 3 órdenes desplegar:
“El cliente nombre ES REGULAR”.
Si emitió entre 4 y 6“
El cliente nombre ES BUENO”.
Si emitió más:
“El cliente nombre ES MUY BUENO”
*/

DECLARE
cus customer%Rowtype;
c_id NUMBER := :Cliente_ID;
c_order NUMBER;

BEGIN
    SELECT COUNT(order_id) INTO c_order
    FROM SALES_ORDER WHERE customer_id = c_id;

IF c_order <= 3 THEN
    BEGIN dbms_output.put_line('El cliente '||cus.name||' ES REGULAR'); 
    END;
ELSIF c_order BETWEEN 4 AND 6 THEN
    BEGIN dbms_output.put_line('El cliente '||cus.name||' ES BUENO');
    END;
ELSE
    BEGIN dbms_output.put_line('El cliente '||cus.name||' ES MUY BUENO');
    END;
    END IF;
END;

/*
7. Ingresar un número de departamento n y mostrar el nombre del departamento
y la cantidad de empleados que trabajan en él.
Si no tiene empleados sacar un mensaje “Sin empleados” 
Si tiene entre 1 y 10 empleados desplegar “Normal”
Si tiene más de 10 empleados, desplegar “Muchos”
*/
DECLARE
n department.department_id%type := :ID_DPTO;
v_dpto department.name%type;
c_emp NUMBER;

BEGIN
    SELECT d.name, COUNT(e.employee_id) INTO v_dpto, c_emp 
    FROM DEPARTMENT d JOIN EMPLOYEE e 
    ON (d.department_id = e.department_id)
    WHERE d.department_id = n GROUP BY d.name; 

    dbms_output.put_line('El departamento: '||v_dpto||' tiene: '||c_emp||' empleados.');

    IF c_emp = 0 THEN
        BEGIN
        dbms_output.put_line('SIN EMPLEADOS');
        END;   
    ELsIF c_emp BETWEEN 1 AND 10 THEN
        BEGIN
        dbms_output.put_line('NORMAL');
        END;
    ELSE
        BEGIN
        dbms_output.put_line('MUCHOS');
        END;
    END IF;
END;


