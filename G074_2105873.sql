/*GROUP NUMBER : G074
PROGRAMME : CS
STUDENT ID : 2105873
STUDENT NAME : Chin Zi Wei
Submission date and time: 16-Apr-2024
*/

--Query 1
SELECT (sta_fname || ' ' || sta_lname) AS "Name", sta_phone AS "Phone", sta_email AS "Email Address", table_id
FROM staff s, tables t
WHERE s.sta_id=t.sta_id;
--

--Query2
SELECT (c.cust_fname || ' ' || c.cust_lname) AS "Customer", (o.order_date || ' ' || order_time )AS "Order Time" , o.order_amount AS "Amount"
FROM customer c, orders o
WHERE c.cust_id=o.cust_id;
--

--Procedure1
CREATE OR REPLACE PROCEDURE new_staff
 (sta_id IN INTEGER, sta_fname IN VARCHAR2, sta_lname IN VARCHAR2,sta_phone IN VARCHAR2, sta_email IN VARCHAR2)
IS
BEGIN
INSERT INTO staff VALUES
(sta_id,sta_fname,sta_lname,sta_phone,sta_email);
COMMIT;
END;
/

exec new_staff(300,'Karina','Yu','5201314','aespa4eva@my.com');
--
--Procedure2
CREATE OR REPLACE PROCEDURE delete_staff(delete_id staff.sta_id%TYPE)
AS
BEGIN
       DELETE FROM staff
       WHERE sta_id = delete_id;
COMMIT;
END;
/

exec delete_staff(300);
--

SET SERVEROUTPUT ON

--Function1
CREATE OR REPLACE FUNCTION calc_ttl_quantity(cur_order IN INTEGER)
RETURN INTEGER
IS
total_quantity INTEGER :=0;
BEGIN
SELECT SUM(orderitem_quantity)
INTO total_quantity
FROM orderitem oi
WHERE oi.order_id = cur_order;
RETURN total_quantity;
END;
/

DECLARE
total_quantity_ordered INTEGER;
BEGIN
FOR order_id IN 5001..5010 LOOP
total_quantity_ordered := calc_ttl_quantity(order_id);
DBMS_OUTPUT.PUT_LINE('Total quantity ordered for order ' || order_id || ' : ' || total_quantity_ordered);
END LOOP;
END;
/
--

--Function2
CREATE OR REPLACE FUNCTION calc_ttl_amount(cur_cust_id IN INTEGER)
RETURN DECIMAL
IS
total_amount DECIMAL :=0;
BEGIN
SELECT SUM (order_amount)
INTO total_amount
FROM orders
WHERE cust_id = cur_cust_id;
RETURN total_amount;
END;
/

DECLARE
total_order_amount DECIMAL;
BEGIN
FOR cust_id IN 1000..1020 LOOP
total_order_amount := calc_ttl_amount(cust_id);
DBMS_OUTPUT.PUT_LINE('Customer ID: ' || cust_id || ', Total Order Amoun
t: ' || total_order_amount);
END LOOP;
END;
/
--


