/*COURSE CODE: (UCCD2203 OR UCCD2303) 
PROGRAMME (IA/IB/CS)/DE: CS
GROUP NUMBER e.g. G001: G074
GROUP LEADER NAME & EMAIL: Cheng Puei Ying pueiying@1utar.my
MEMBER 2 NAME: Chin Zi Wei
MEMBER 3 NAME: Look Zheng Hong
MEMBER 4 NAME: Tan Lok Wei
Submission date and time (DD-MON-YY): 16-04-24
*/

DROP TABLE customer CASCADE CONSTRAINTS;
DROP TABLE orders CASCADE CONSTRAINTS;
DROP TABLE item CASCADE CONSTRAINTS;
DROP TABLE receipt CASCADE CONSTRAINTS;
DROP TABLE transaction CASCADE CONSTRAINTS;
DROP TABLE orderstatus CASCADE CONSTRAINTS;
DROP TABLE orderitem CASCADE CONSTRAINTS;
DROP TABLE orderplatform CASCADE CONSTRAINTS;
DROP TABLE transactionmethod CASCADE CONSTRAINTS;
DROP TABLE tables CASCADE CONSTRAINTS;
DROP TABLE staff CASCADE CONSTRAINTS;
DROP TABLE supplier CASCADE CONSTRAINTS;
DROP TABLE supplieditem CASCADE CONSTRAINTS;
DROP TABLE reservation CASCADE CONSTRAINTS;

CREATE TABLE staff
(sta_ID INTEGER,
sta_fname VARCHAR2(30)
CONSTRAINT sta_fname_nn NOT NULL, 
sta_lname VARCHAR2(30)
CONSTRAINT sta_lname_nn NOT NULL,
sta_phone VARCHAR2(15)
CONSTRAINT sta_phone_nn NOT NULL,
sta_email VARCHAR2(30)
CONSTRAINT sta_email_nn NOT NULL,
CONSTRAINT sta_sta_ID_pk PRIMARY KEY(sta_ID));

CREATE TABLE tables
(table_ID INTEGER,
table_capacity INTEGER,
table_position INTEGER,
sta_ID INTEGER,
CONSTRAINT tbl_table_ID_pk PRIMARY KEY(table_ID),
CONSTRAINT tbl_sta_ID_fk FOREIGN KEY(sta_ID) REFERENCES staff(sta_ID));

CREATE TABLE supplier
(sup_ID INTEGER,
sup_name VARCHAR2(30)
CONSTRAINT supp_sup_name_nn NOT NULL,
sup_phone VARCHAR2(15)
CONSTRAINT supp_sup_phone_nn NOT NULL,
sup_email VARCHAR2(30)
CONSTRAINT supp_sup_email_nn NOT NULL,
CONSTRAINT supp_sup_ID_pk PRIMARY KEY(sup_ID));

CREATE TABLE transactionmethod
(method_ID INTEGER,
method_type VARCHAR2(20),
method_desc VARCHAR2(50),
CONSTRAINT transmethod_method_ID_pk PRIMARY KEY(method_ID),
CONSTRAINT transmethod_method_type_cc CHECK ((method_type = 'Cash') OR (method_type = 'Credit Card') OR (method_type = 'Debit Card') OR (method_type = 'E-wallet')));

CREATE TABLE orderplatform
(platform_ID INTEGER,
platform_type VARCHAR2(10),
platform_desc VARCHAR2(50),
CONSTRAINT orderpl_platform_ID_pk PRIMARY KEY(platform_ID),
CONSTRAINT orderpl_platform_type_cc CHECK (platform_type IN ('Physical', 'Online'))
);

CREATE TABLE orderstatus
(status_ID INTEGER,
status_type VARCHAR2(20)
CONSTRAINT ordersta_status_type_nn NOT NULL,
status_desc VARCHAR2(50)
CONSTRAINT ordersta_status_desc_nn NOT NULL,
CONSTRAINT ordersta_status_id_pk PRIMARY KEY(status_ID));

CREATE TABLE customer
(cust_ID INTEGER,
cust_fname VARCHAR2(30)
CONSTRAINT cust_cust_fname_nn NOT NULL,
cust_lname VARCHAR2(30)
CONSTRAINT cust_cust_lname_nn NOT NULL,
cust_phone VARCHAR2(15)
CONSTRAINT cust_cust_phone_nn NOT NULL,
cust_email VARCHAR2(30)
CONSTRAINT cust_cust_email_nn NOT NULL,
table_ID INTEGER,
CONSTRAINT cust_cust_ID_pk PRIMARY KEY (cust_ID),
CONSTRAINT cust_table_ID_fk FOREIGN KEY (table_ID) REFERENCES tables(table_ID));

CREATE TABLE orders
( order_ID INTEGER,
order_date DATE DEFAULT SYSDATE,
order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
order_amount DECIMAL(10, 2)
CONSTRAINT ord_order_amount_nn NOT NULL,
order_remark VARCHAR2(50),
cust_id INTEGER,
status_id INTEGER,
platform_ID INTEGER,
CONSTRAINT ord_order_ID_pk PRIMARY KEY (order_ID),
CONSTRAINT ord_cust_ID_fk FOREIGN KEY(cust_ID) REFERENCES customer(cust_ID),
CONSTRAINT ord_status_ID_fk FOREIGN KEY(status_ID) REFERENCES orderstatus(status_ID),
CONSTRAINT ord_platform_ID_fk FOREIGN KEY(platform_ID) REFERENCES orderplatform (platform_ID));

CREATE TABLE item
( item_ID INTEGER,
item_type VARCHAR2(20),
item_price DECIMAL(10,2)
CONSTRAINT it_item_price_nn NOT NULL,
item_desc VARCHAR2(50),
CONSTRAINT it_item_ID_pk PRIMARY KEY(item_ID),
CONSTRAINT it_item_type_cc CHECK (item_type IN ('Food', 'Beverage', 'Merchandise'))
);

CREATE TABLE orderitem
(order_ID INTEGER,
item_ID INTEGER,
orderitem_quantity INTEGER,
CONSTRAINT orderit_order_ID_item_ID_pk PRIMARY KEY(order_ID, item_ID),
CONSTRAINT orderit_order_ID_fk FOREIGN KEY(order_ID) REFERENCES orders(order_ID),
CONSTRAINT orderit_item_ID_fk FOREIGN KEY(item_ID) REFERENCES item(item_ID),
CONSTRAINT orderit_orderitem_quantitiy_cc CHECK (orderitem_quantity > 0));

CREATE TABLE transaction
(trans_ID INTEGER,
trans_date DATE DEFAULT SYSDATE,
trans_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
trans_amount DECIMAL(10,2)
CONSTRAINT trans_trans_amount_nn NOT NULL,
order_ID INTEGER,
method_ID INTEGER,
CONSTRAINT trans_trans_ID_pk PRIMARY KEY(trans_ID),
CONSTRAINT trans_order_ID_fk FOREIGN KEY(order_ID) REFERENCES orders(order_ID),
CONSTRAINT trans_method_ID_fk FOREIGN KEY(method_ID) REFERENCES transactionmethod(method_ID));

CREATE TABLE receipt
(rec_ID INTEGER,
rec_date DATE DEFAULT SYSDATE,
rec_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
rec_amount DECIMAL(10,2)
CONSTRAINT rec_rec_amount_nn NOT NULL,
trans_ID INTEGER,
CONSTRAINT rec_rec_ID_pk PRIMARY KEY(rec_ID),
CONSTRAINT rec_trans_ID_fk FOREIGN KEY(trans_ID) REFERENCES transaction(trans_ID));

CREATE TABLE supplieditem
(sup_ID INTEGER,
item_ID INTEGER,
supIt_price DECIMAL(10,2)
CONSTRAINT supitem_supIt_price_nn NOT NULL,
supIt_quantity INTEGER,
CONSTRAINT supitem_item_ID_sup_ID_pk PRIMARY KEY(item_ID, sup_ID),
CONSTRAINT supitem_item_ID_fk FOREIGN KEY(item_ID) REFERENCES item(item_ID),
CONSTRAINT supitem_sup_ID_fk FOREIGN KEY(sup_ID) REFERENCES supplier(sup_ID),
CONSTRAINT supitem_supIt_quantity_cc CHECK (supIt_quantity > 0));

CREATE TABLE reservation
(res_ID INTEGER,
res_date DATE DEFAULT SYSDATE,
res_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
res_pax INTEGER,
res_remark VARCHAR2(50),
cust_ID INTEGER,
CONSTRAINT res_res_ID_pk PRIMARY KEY(res_ID),
CONSTRAINT res_cust_ID_fk FOREIGN KEY(cust_ID) REFERENCES customer(cust_ID));

INSERT INTO staff VALUES (301, 'Mark', 'Lee', '0127593657', 'mark@mail.com');
INSERT INTO staff VALUES (302, 'Renjun', 'Huang', '0135224526', 'renjun@mail.com');
INSERT INTO staff VALUES (303, 'Jeno', 'Lee', '0163228224', 'jeno@mail.com');
INSERT INTO staff VALUES (304, 'Haechan', 'Lee', '0125862477', 'haechan@mail.com');
INSERT INTO staff VALUES (305, 'Jaemin', 'Na', '0153287815', 'jaemin@mail.com');
INSERT INTO staff VALUES (306, 'Chenle', 'Zhong', '0162845325', 'chenle@mail.com');
INSERT INTO staff VALUES (307, 'Jisung', 'Park', '0155201565', 'jisung@email.com');

INSERT INTO tables VALUES (201, 2, 1, 301);
INSERT INTO tables VALUES (202, 6, 2, 302);
INSERT INTO tables VALUES (203, 4, 3, 303);
INSERT INTO tables VALUES (204, 2, 4, 304);
INSERT INTO tables VALUES (205, 10, 5, 305);

INSERT INTO supplier VALUES (991, 'SM Supplier', '0125986857', 'sm@email.com');
INSERT INTO supplier VALUES (992, 'YG Supplier', '0175893486', 'yg@email.com');
INSERT INTO supplier VALUES (993, 'JYP Supplier', '0135485256', 'jyp@email.com');
INSERT INTO supplier VALUES (994, 'HYBE Supplier', '0193586288', 'hybe@email.com');
INSERT INTO supplier VALUES (995, 'CUBE Supplier', '0165623356', 'cube@email.com');

INSERT INTO transactionmethod VALUES (1201, 'Cash', 'Payment made in cash');
INSERT INTO transactionmethod VALUES (1202, 'Credit Card', 'Payment made using Maybank Credit Card');
INSERT INTO transactionmethod VALUES (1203, 'Debit Card', 'Payment made using Maybank Debit Card');
INSERT INTO transactionmethod VALUES (1204, 'E-wallet', 'Payment made using TouchNGo');
INSERT INTO transactionmethod VALUES (1205, 'Credit Card', 'Payment made using Public Bank Credit Card');
INSERT INTO transactionmethod VALUES (1206, 'Debit Card', 'Payment made using Public Bank Debit Card');

INSERT INTO orderplatform VALUES (1401, 'Physical', 'In-store');
INSERT INTO orderplatform VALUES (1402, 'Online', 'Food Panda');
INSERT INTO orderplatform VALUES (1403, 'Online', 'Grab Food');
INSERT INTO orderplatform VALUES (1404, 'Online', 'Shopee Food');
INSERT INTO orderplatform VALUES (1405, 'Online', 'Store Website');

INSERT INTO orderstatus VALUES (601, 'Pending', 'Order is pending processing');
INSERT INTO orderstatus VALUES (602, 'Confirmed', 'Order is confirmed and being processed');
INSERT INTO orderstatus VALUES (603, 'Delivered', 'Order has been delivered');
INSERT INTO orderstatus VALUES (604, 'Shipped', 'Order is shipped');
INSERT INTO orderstatus VALUES (605, 'Completed', 'Order is completed');

INSERT INTO customer VALUES (1001, 'LokWei', 'Tan', '0129564756', 'lokwei@mail.com', 201);
INSERT INTO customer VALUES (1002, 'PueiYing', 'Cheng', '0168469853', 'pueiying@mail.com', 202);
INSERT INTO customer VALUES (1003, 'ZiWei', 'Chin', '0188962589', 'ziwei@mail.com', 203);
INSERT INTO customer VALUES (1004, 'ZhengHong', 'Look', '0138951479', 'zhenghong@mail.com', 204);
INSERT INTO customer VALUES (1005, 'Wendy', 'Ang', '0165896145', 'wendy@mail.com', 205);
INSERT INTO customer VALUES (1006, 'Jim', 'Ng', '0164862547', 'jim@mail.com', 201);
INSERT INTO customer VALUES (1007, 'Hendry', 'Tong', '0173368864', 'hendry@mail.com', 202);
INSERT INTO customer VALUES (1008, 'Andy', 'Ong', '0183147925', 'andy@mail.com', 205);
INSERT INTO customer VALUES (1009, 'Cindy', 'Cheah', '0142486325', 'cindy@mail.com', 205);
INSERT INTO customer VALUES (1010, 'Stephan', 'Tiew', '0168523487', 'stephan@mail.com', 203);
INSERT INTO customer VALUES (1011, 'Karina', 'You', '0152234895', 'karina@mail.com', 205);
INSERT INTO customer VALUES (1012, 'Winter', 'Kim', '0175325923', 'winter@mail.com', 204);
INSERT INTO customer VALUES (1013, 'Ning', 'Ning', '0159628547', 'ning@mail.com', 201);
INSERT INTO customer VALUES (1014, 'Giselle', 'Kim', '0129587456', 'giselle@mail.com', 205);
INSERT INTO customer VALUES (1015, 'Julie', 'Han', '0158735891', 'julie@mail.com', 205);
INSERT INTO customer VALUES (1016, 'Natty', 'NT', '0186328756', 'natty@mail.com', 202);
INSERT INTO customer VALUES (1017, 'Belle', 'Shim', '0123589523', 'belle@mail.com', 202);
INSERT INTO customer VALUES (1018, 'Haneul', 'Won', '0169863278', 'haneul@mail.com', 203);
INSERT INTO customer VALUES (1019, 'Haewon', 'Oh', '0162224578', 'haewon@mail.com', 204);
INSERT INTO customer VALUES (1020, 'Wonyoung', 'Zhang', '0185235625', 'wonyoung@mail.com', 205);

INSERT INTO orders VALUES (5001, TO_DATE('2024-03-10', 'YYYY-MM-DD'), TO_TIMESTAMP('10:00:00', 'HH24:MI:SS' ),  35.60, 'Extra Ice', 1012, 605, 1401);
INSERT INTO orders VALUES (5002, TO_DATE('2024-03-10', 'YYYY-MM-DD'), TO_TIMESTAMP('12:00:00', 'HH24:MI:SS'), 90.40, NULL, 1003, 605, 1401);
INSERT INTO orders VALUES (5003, TO_DATE('2024-03-12', 'YYYY-MM-DD'), TO_TIMESTAMP('13:30:00', 'HH24:MI:SS'), 139.00, NULL, 1017, 605, 1401);
INSERT INTO orders VALUES (5004, TO_DATE('2024-03-12', 'YYYY-MM-DD'), TO_TIMESTAMP('15:00:00', 'HH24:MI:SS'), 105.20, 'Extra one set of cutlery', 1019, 603, 1402);
INSERT INTO orders VALUES (5005, TO_DATE('2024-03-13', 'YYYY-MM-DD'), TO_TIMESTAMP('18:00:00', 'HH24:MI:SS'), 275.50, 'No ice for cola', 1010, 605, 1401);
INSERT INTO orders VALUES (5006, TO_DATE('2024-03-14', 'YYYY-MM-DD'), TO_TIMESTAMP('17:00:00', 'HH24:MI:SS'), 238.80, NULL, 1020, 604, 1404);
INSERT INTO orders VALUES (5007, TO_DATE('2024-03-15', 'YYYY-MM-DD'), TO_TIMESTAMP('14:00:00', 'HH24:MI:SS'), 55.60, NULL, 1018, 603, 1403);
INSERT INTO orders VALUES (5008, TO_DATE('2024-03-15', 'YYYY-MM-DD'), TO_TIMESTAMP('18:30:00', 'HH24:MI:SS'), 90.40, 'Double shot latte', 1016, 605, 1401);
INSERT INTO orders VALUES (5009, TO_DATE('2024-03-16', 'YYYY-MM-DD'), TO_TIMESTAMP('12:00:00', 'HH24:MI:SS'), 311.20, NULL, 1014, 604, 1405);
INSERT INTO orders VALUES (5010, TO_DATE('2024-03-17', 'YYYY-MM-DD'), TO_TIMESTAMP('18:00:00', 'HH24:MI:SS'), 63.60, NULL, 1013, 605, 1401);

INSERT INTO item VALUES (8001, 'Food', 18.90, 'Spaghetti');
INSERT INTO item VALUES (8002, 'Beverage', 15.90, 'Latte');
INSERT INTO item VALUES (8003, 'Merchandise', 198.00, 'Tumbler');
INSERT INTO item VALUES (8004, 'Food', 22.90, 'Fish Chop');
INSERT INTO item VALUES (8005, 'Food', 21.90, 'Chicken Chop');
INSERT INTO item VALUES (8006, 'Food', 19.90, 'Fried Chicken');
INSERT INTO item VALUES (8007, 'Beverage', 8.90, 'Cola');
INSERT INTO item VALUES (8008, 'Beverage', 8.90, 'Pepsi');
INSERT INTO item VALUES (8009, 'Beverage', 8.90, 'Orange Juice');
INSERT INTO item VALUES (8010, 'Food', 19.90, 'Carbonara');

INSERT INTO transaction VALUES (11001, TO_DATE('2024-03-10', 'YYYY-MM-DD'), TO_TIMESTAMP('10:00:00', 'HH24:MI:SS'), 35.60, 5001, 1201);
INSERT INTO transaction VALUES (11002, TO_DATE('2024-03-10', 'YYYY-MM-DD'), TO_TIMESTAMP('12:00:00', 'HH24:MI:SS'), 90.40, 5002, 1201);
INSERT INTO transaction VALUES (11003, TO_DATE('2024-03-12', 'YYYY-MM-DD'), TO_TIMESTAMP('13:30:00', 'HH24:MI:SS'), 139.00, 5003, 1201);
INSERT INTO transaction VALUES (11004, TO_DATE('2024-03-12', 'YYYY-MM-DD'), TO_TIMESTAMP('15:00:00', 'HH24:MI:SS'), 105.20, 5004, 1204);
INSERT INTO transaction VALUES (11005, TO_DATE('2024-03-13', 'YYYY-MM-DD'), TO_TIMESTAMP('18:00:00', 'HH24:MI:SS'), 275.50, 5005, 1204);
INSERT INTO transaction VALUES (11006, TO_DATE('2024-03-14', 'YYYY-MM-DD'), TO_TIMESTAMP('17:00:00', 'HH24:MI:SS'), 238.80, 5006, 1203);
INSERT INTO transaction VALUES (11007, TO_DATE('2024-03-15', 'YYYY-MM-DD'), TO_TIMESTAMP('14:00:00', 'HH24:MI:SS'), 55.60, 5007, 1202);
INSERT INTO transaction VALUES (11008, TO_DATE('2024-03-15', 'YYYY-MM-DD'), TO_TIMESTAMP('18:30:00', 'HH24:MI:SS'), 90.40, 5008, 1202);
INSERT INTO transaction VALUES (11009, TO_DATE('2024-03-16', 'YYYY-MM-DD'), TO_TIMESTAMP('12:00:00', 'HH24:MI:SS'), 311.20, 5009, 1204);
INSERT INTO transaction VALUES (11010, TO_DATE('2024-03-17', 'YYYY-MM-DD'), TO_TIMESTAMP('18:00:00', 'HH24:MI:SS'), 63.60, 5010, 1205);

INSERT INTO receipt VALUES (13001, TO_DATE('2024-03-10', 'YYYY-MM-DD'), TO_TIMESTAMP('10:00:00', 'HH24:MI:SS'), 35.60, 11001);
INSERT INTO receipt VALUES (13002, TO_DATE('2024-03-10', 'YYYY-MM-DD'), TO_TIMESTAMP('12:00:00', 'HH24:MI:SS'), 90.40, 11002);
INSERT INTO receipt VALUES (13003, TO_DATE('2024-03-12', 'YYYY-MM-DD'), TO_TIMESTAMP('13:30:00', 'HH24:MI:SS'), 139.00, 11003);
INSERT INTO receipt VALUES (13004, TO_DATE('2024-03-12', 'YYYY-MM-DD'), TO_TIMESTAMP('15:00:00', 'HH24:MI:SS'), 105.20, 11004);
INSERT INTO receipt VALUES (13005, TO_DATE('2024-03-13', 'YYYY-MM-DD'), TO_TIMESTAMP('18:00:00', 'HH24:MI:SS'), 275.50, 11005);
INSERT INTO receipt VALUES (13006, TO_DATE('2024-03-14', 'YYYY-MM-DD'), TO_TIMESTAMP('17:00:00', 'HH24:MI:SS'), 238.80, 11006);
INSERT INTO receipt VALUES (13007, TO_DATE('2024-03-15', 'YYYY-MM-DD'), TO_TIMESTAMP('14:00:00', 'HH24:MI:SS'), 55.60, 11007);
INSERT INTO receipt VALUES (13008, TO_DATE('2024-03-15', 'YYYY-MM-DD'), TO_TIMESTAMP('18:30:00', 'HH24:MI:SS'), 90.40, 11008);
INSERT INTO receipt VALUES (13009, TO_DATE('2024-03-16', 'YYYY-MM-DD'), TO_TIMESTAMP('12:00:00', 'HH24:MI:SS'), 311.20, 11009);
INSERT INTO receipt VALUES (13010, TO_DATE('2024-03-17', 'YYYY-MM-DD'), TO_TIMESTAMP('18:00:00', 'HH24:MI:SS'), 63.60, 11010);

INSERT INTO reservation VALUES (4001,	TO_DATE('2024-03-10', 'YYYY-MM-DD'), TO_TIMESTAMP('10:00:00', 'HH24:MI:SS' ), '2', NULL, 1012);
INSERT INTO reservation VALUES (4002, TO_DATE('2024-03-10', 'YYYY-MM-DD'), TO_TIMESTAMP('12:00:00', 'HH24:MI:SS'), 3, NULL, 1003);
INSERT INTO reservation VALUES (4003, TO_DATE('2024-03-12', 'YYYY-MM-DD'), TO_TIMESTAMP('13:30:00', 'HH24:MI:SS'), 6, 'Birthday', 1017);
INSERT INTO reservation VALUES (4004, TO_DATE('2024-03-12', 'YYYY-MM-DD'), TO_TIMESTAMP('15:00:00', 'HH24:MI:SS'), 2, 'Window', 1019);
INSERT INTO reservation VALUES (4005, TO_DATE('2024-03-13', 'YYYY-MM-DD'), TO_TIMESTAMP('18:00:00', 'HH24:MI:SS'), 4, NULL, 1010);
INSERT INTO reservation VALUES (4006, TO_DATE('2024-03-14', 'YYYY-MM-DD'), TO_TIMESTAMP('17:00:00', 'HH24:MI:SS'), 7, 'Window', 1020);
INSERT INTO reservation VALUES (4007, TO_DATE('2024-03-15', 'YYYY-MM-DD'), TO_TIMESTAMP('14:00:00', 'HH24:MI:SS'), 3, 'Corner', 1018);
INSERT INTO reservation VALUES (4008, TO_DATE('2024-03-15', 'YYYY-MM-DD'), TO_TIMESTAMP('18:30:00', 'HH24:MI:SS'), 5, 'Corner', 1016);
INSERT INTO reservation VALUES (4009, TO_DATE('2024-03-16', 'YYYY-MM-DD'), TO_TIMESTAMP('12:00:00', 'HH24:MI:SS'), 7, NULL, 1014);
INSERT INTO reservation VALUES (4010, TO_DATE('2024-03-17', 'YYYY-MM-DD'), TO_TIMESTAMP('18:00:00', 'HH24:MI:SS'), 2, NULL, 1013);

INSERT INTO orderitem VALUES (5001, 8007, 4);
INSERT INTO orderitem VALUES (5002, 8002, 1);
INSERT INTO orderitem VALUES (5002, 8001, 3);
INSERT INTO orderitem VALUES (5002, 8007, 2);
INSERT INTO orderitem VALUES (5003, 8001, 5);
INSERT INTO orderitem VALUES (5003, 8007, 5);
INSERT INTO orderitem VALUES (5004, 8001, 2);
INSERT INTO orderitem VALUES (5004, 8007, 2);
INSERT INTO orderitem VALUES (5004, 8008, 3);
INSERT INTO orderitem VALUES (5004, 8004, 1);
INSERT INTO orderitem VALUES (5005, 8007, 2);
INSERT INTO orderitem VALUES (5005, 8003, 1);
INSERT INTO orderitem VALUES (5005, 8006, 3);
INSERT INTO orderitem VALUES (5006, 8006, 12);
INSERT INTO orderitem VALUES (5007, 8001, 2);
INSERT INTO orderitem VALUES (5007, 8009, 2);
INSERT INTO orderitem VALUES (5008, 8002, 1);
INSERT INTO orderitem VALUES (5008, 8009, 2);
INSERT INTO orderitem VALUES (5008, 8001, 3);
INSERT INTO orderitem VALUES (5009, 8001, 4);
INSERT INTO orderitem VALUES (5009, 8007, 2);
INSERT INTO orderitem VALUES (5009, 8008, 2);
INSERT INTO orderitem VALUES (5009, 8010, 2);
INSERT INTO orderitem VALUES (5010, 8004, 2);
INSERT INTO orderitem VALUES (5010, 8008, 2);

INSERT INTO supplieditem VALUES (991, 8001, 10.00, 1000);
INSERT INTO supplieditem VALUES (991, 8002, 5.00, 1000);
INSERT INTO supplieditem VALUES (992, 8003, 100.00, 100);
INSERT INTO supplieditem VALUES (993, 8004, 12.00, 1000);
INSERT INTO supplieditem VALUES (994, 8005, 12.00, 1000);
INSERT INTO supplieditem VALUES (994, 8006, 12.00, 1000);
INSERT INTO supplieditem VALUES (995, 8007, 3.00, 1000);
INSERT INTO supplieditem VALUES (995, 8008, 3.00, 1000);
INSERT INTO supplieditem VALUES (991, 8009, 3.00, 1000);
INSERT INTO supplieditem VALUES (992, 8010, 10.00, 1000);






