CREATE TABLE products(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    category TEXT NOT NULL ,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    currentPrice INTEGER NOT NULL CHECK ( currentPrice >= 0 ),
    stock INTEGER NOT NULL CHECK ( stock >=0 ),
    status TEXT --NULL for removed, AVAILABLE/COMING SOON/CAN ORDER
);

-- users that are not registered provide phone and name, but get no pass their actions are limited (in service)
-- and they can't view previous purchases, save shipment address, so on.
CREATE TABLE customers(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL ,
    phone TEXT NOT NULL , --used for login too
    passwordHash TEXT,
    shipmentAddress TEXT
);

CREATE TABLE orders(
    id INTEGER PRIMARY KEY AUTOINCREMENT ,
    customerId INTEGER REFERENCES customers(id), --initially this can be null in case it is an unregistered user, but
    -- it is filled later, once they provide name and phone
    total INTEGER, --not to dig through sales every time. it should be updated after the order is finished
    status TEXT --Completed/Shipped/Paid/Issued/Cart/Cancelled
);

CREATE TABLE invoices(
    id INTEGER PRIMARY KEY AUTOINCREMENT ,
    ordersId INTEGER NOT NULL REFERENCES orders(id),
    status TEXT NOT NULL --Issued/Processing/Done/Rejected/ErrorCode
);

CREATE TABLE sales (
    id INTEGER PRIMARY KEY  AUTOINCREMENT,
    productId INTEGER NOT NULL REFERENCES products(id),
    orderId INTEGER NOT NULL REFERENCES orders(id),
    price INTEGER NOT NULL CHECK ( price >= 0 ),
    amountSold INTEGER NOT NULL CHECK ( amountSold > 0 ),
    dateSold INTEGER NOT NULL CHECK ( dateSold > 0) --UTC, or even formatted as yyyymmdd (20191029)
);

INSERT INTO products (category, title, description, currentPrice, stock, status)
VALUES (
        'phone',
        'Xiaomi Redmi GO 1/8Gb black',
        'Metal case',
        5550,
        1,
        'AVAILABLE'
       );

INSERT INTO products (category, title, description, currentPrice, stock, status)
VALUES (
           'phone',
           'Nokia 5.1 Plus DS TA-1105',
           'Display 5.8"',
           7050,
           0,
           'CAN ORDER'
       );

INSERT INTO products (category, title, description, currentPrice, stock, status)
VALUES (
           'phone',
           'CAT S60 Black',
           'Strong case',
           39990,
           0,
           NULL
       );

--OK. the password is not a hash here for now, but it shouldn't be stored in plain text in real life case
INSERT INTO customers (name, phone, passwordHash, shipmentAddress)
VALUES ('Andrew', '9012345678', 'asdfrewwq', 'default city ...');

-- This here is an unregistered user. Name and phone are used to identify him when he picks up the order
INSERT INTO customers (name, phone, passwordHash, shipmentAddress)
VALUES ('Boris', '9012123243', NULL, NULL);

INSERT INTO orders (customerId, total, status)
VALUES(1, 39990, 'COMPLETED');

INSERT INTO orders (customerId, total, status)
VALUES(1, 5550, 'ISSUED');

INSERT INTO orders (customerId, total, status)
VALUES(2,  12600, 'ISSUED');

INSERT INTO invoices (ordersId, status)VALUES (1, 'PAID');
INSERT INTO invoices (ordersId, status)VALUES (2, 'PAID');
INSERT INTO invoices (ordersId, status)VALUES (3, 'ISSUED');

INSERT INTO sales (productId, orderId, price, amountSold, dateSold)
VALUES (3, 1, 39900, 1, 20190101);

INSERT INTO sales (productId, orderId, price, amountSold, dateSold)
VALUES (1, 2, 5500, 1, 20190211);

INSERT INTO sales (productId, orderId, price, amountSold, dateSold)
VALUES (1, 3, 5550, 1, 20190123);

INSERT INTO sales (productId, orderId, price, amountSold, dateSold)
VALUES (2, 3, 7050, 1, 20190123);
