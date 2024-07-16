-- 1. Create a view that lists the name and phone number of the contact person
-- at each publisher. Don’t include the publisher’s ID in the view. Name the
-- view CONTACT.
CREATE VIEW
    CONTACT AS
SELECT
    NAME AS PUBLISHER_NAME,
    CONTACT AS CONTACT_PERSON,
    PHONE AS CONTACT_PHONE
FROM
    PUBLISHER;

-- 2. Change the CONTACT view so that no users can accidentally perform DML
-- operations on the view.
CREATE VIEW
    CONTACT AS
SELECT
    NAME AS PUBLISHER_NAME,
    CONTACT AS CONTACT_PERSON,
    PHONE AS CONTACT_PHONE
FROM
    PUBLISHER
WITH
    READ ONLY;

-- SQL> CREATE VIEW CONTACT AS
--     SELECT
--         NAME      2    3  AS PUBLISHER_NAME,
--         CONTACT AS CONTACT_PERS  4  ON,
--         PHONE   AS CONTACT_PHONE
--     FROM
--       5    6    7      PUBLISHER WITH READ ONLY;
-- CREATE VIEW CONTACT AS
--             *
-- ERROR at line 1:
-- ORA-00955: name is already used by an existing object

-- 3. Create a view called HOMEWORK13 that includes the columns named Col1 and
-- Col2 from the FIRSTATTEMPT table. Make sure the view is created even if the
-- FIRSTATTEMPT table doesn’t exist.
CREATE FORCE VIEW
    HOMEWORK13 AS
SELECT
    COL1,
    COL2
FROM
    FIRSTATTEMPT;

-- Warning: View created with compilation errors.

-- 4. Attempt to view the structure of the HOMEWORK13 view.
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    DATA_LENGTH
FROM
    ALL_TAB_COLUMNS
WHERE
    TABLE_NAME = 'HOMEWORK13';

-- COLUMN_NAME
-- --------------------------------------------------------------------------------
-- DATA_TYPE
-- --------------------------------------------------------------------------------
-- DATA_LENGTH
-- -----------
-- COL1
-- UNDEFINED
--           0
-- COL2
-- UNDEFINED
--           0
-- COLUMN_NAME
-- --------------------------------------------------------------------------------
-- DATA_TYPE
-- --------------------------------------------------------------------------------
-- DATA_LENGTH
-- -----------

-- 5. Create a view that lists the ISBN and title for each book in inventory
-- along with the name and phone number of the person to contact if the book
-- needs to be reordered. Name the view REORDERINFO.
CREATE VIEW
    REORDERINFO AS
SELECT
    B.ISBN,
    B.TITLE,
    P.NAME AS PUBLISHERNAME,
    P.PHONE AS PUBLISHERPHONE
FROM
    BOOKS B
    JOIN PUBLISHER P ON B.PUBID = P.PUBID;

-- 6. Try to change the name of a contact person in the REORDERINFO view to your
-- name. Was an error message displayed when performing this step? If so, what
-- was the cause of the error message?
UPDATE REORDERINFO
SET
    PUBLISHERNAME = 'YourName'
WHERE
    ISBN = '1059831198';

-- PUBLISHERNAME = 'YourName'
--     *
-- ERROR at line 3:
-- ORA-01779: cannot modify a column which maps to a non key-preserved table

-- 7. Select one of the books in the REORDERINFO view and try to change its
-- ISBN. Was an error message displayed when performing this step? If so, what
-- was the cause of the error message?
UPDATE REORDERINFO
SET
    ISBN = '1059831199'
WHERE
    ISBN = '1059831198';

-- UPDATE REORDERINFO
-- *
-- ERROR at line 1:
-- ORA-02292: integrity constraint (COMP214_W24_NIC_12.ORDERITEMS_ISBN_FK)
-- violated - child record found

-- 8. Delete the record in the REORDERINFO view containing your name. (If you
-- weren’t able to perform #6 successfully, delete one of the contacts already
-- listed in the table.) Was an error message displayed when performing this
-- step? If so, what was the cause of the error message?
DELETE FROM REORDERINFO
WHERE
    PUBLISHERNAME = 'YourName'
    
-- 9. Issue a rollback command to undo any changes made with the preceding
-- DML operations.
ROLLBACK;

-- 10. Delete the REORDERINFO view.
DROP VIEW REORDERINFO;

-- 1. Create a sequence for populating the Customer# column of the CUSTOMERS 
-- table. When setting the start and increment values, keep in mind that data 
-- already exists in this table. 
SELECT
    MAX(Customer#)
FROM
    CUSTOMERS;

-- MAX(CUSTOMER#)
-- --------------
--           1020
-- The options should be set to not cycle the values and not cache any values, 
-- and no minimum or maximum values should be declared.
CREATE SEQUENCE CUSTOMERS_CUSTOMER#_seq
START WITH 1021 INCREMENT BY 1 NOCACHE NOCYCLE;

-- 2. Add a new customer row by using the sequence created in Question 1. The 
-- only data currently available for the customer is as follows: last name = 
-- Shoulders, first name = Frank, and zip = 23567.
INSERT INTO
    CUSTOMERS (CUSTOMER#, LASTNAME, FIRSTNAME, ZIP)
VALUES
    (
        CUSTOMERS_CUSTOMER#_seq.NEXTVAL,
        'Shoulders',
        'Frank',
        '23567'
    );

-- 3. Create a sequence that generates integers starting with the value 5. Each 
-- value should be three less than the previous value generated. The lowest 
-- possible value should be 0, and the sequence shouldn’t be allowed to cycle. 
-- Name the sequence MY_FIRST_SEQ.
CREATE SEQUENCE MY_FIRST_SEQ
START WITH 5 INCREMENT BY -3 MINVALUE 0 MAXVALUE 5 NOCYCLE;

-- 4. Issue a SELECT statement that displays NEXTVAL for MY_FIRST_SEQ three 
-- times. Because the value isn’t being placed in a table, use the DUAL table in 
-- the FROM clause of the SELECT statement. What causes the error on the third 
-- SELECT?
SELECT
    MY_FIRST_SEQ.NEXTVAL
FROM
    DUAL;

SELECT
    MY_FIRST_SEQ.NEXTVAL
FROM
    DUAL;

SELECT
    MY_FIRST_SEQ.NEXTVAL
FROM
    DUAL;

-- SELECT
-- *
-- ERROR at line 1:
-- ORA-08004: sequence MY_FIRST_SEQ.NEXTVAL goes below MINVALUE and cannot be
-- instantiated

-- 5. Change the setting of MY_FIRST_SEQ so that the minimum value that can be 
-- generated is -1000.
ALTER SEQUENCE MY_FIRST_SEQ MINVALUE -1000;

-- 6. Create a private synonym that enables you to reference the MY_FIRST_SEQ 
-- object as NUMGEN.
CREATE SYNONYM NUMGEN FOR MY_FIRST_SEQ;

-- SQL> CREATE SYNONYM NUMGEN FOR MY_FIRST_SEQ;
-- CREATE SYNONYM NUMGEN FOR MY_FIRST_SEQ
-- *
-- ERROR at line 1:
-- ORA-01031: insufficient privileges
-- SQL> GRANT CREATE SYNONYM TO yourCOMP214_W24_nic_12;
-- GRANT CREATE SYNONYM TO yourCOMP214_W24_nic_12
-- *
-- ERROR at line 1:
-- ORA-01031: insufficient privileges

-- 7. Use a SELECT statement to view the CURRVAL of NUMGEN. Delete the NUMGEN 
-- synonym and MY_FIRST_SEQ.
SELECT
    NUMGEN.CURRVAL
FROM
    DUAL;

-- 8. Create a bitmap index on the CUSTOMERS table to speed up queries that 
-- search for customers based on their state of residence. 
CREATE BITMAP INDEX IDX_CUSTOMERS_STATE ON CUSTOMERS (STATE);

-- 8. Verify that the index exists, and then delete the index.
SELECT
    INDEX_NAME
FROM
    USER_INDEXES;

-- 9. Create a B-tree index on the customer’s Lastname column.
CREATE INDEX IDX_CUSTOMERS_LASTNAME ON CUSTOMERS (LASTNAME);

-- 9. Verify that the index exists by querying the data dictionary.
SELECT
    INDEX_NAME
FROM
    USER_INDEXES;

-- 9. Remove the index from the database.
DROP INDEX IDX_CUSTOMERS_LASTNAME;

-- 10. Many queries search by the number of days to ship (number of days between 
-- the order and shipping dates). Create an index that might improve the 
-- performance of these queries.
CREATE INDEX IDX_DAYS_TO_SHIP ON ORDERS (SHIPDATE - ORDERDATE);

-- ## Advanced Challenge
-- To perform the following activity, refer to the tables in the JustLee Books 
-- database. Using the training you have received and speculating on query 
-- needs, determine appropriate uses for indexes and sequences in the JustLee 
-- Books database. Assume all tables will grow quite large in the number of 
-- rows. Identify at least three sequences and three indexes that can address 
-- needed functionality for the JustLee Books database. In a memo to 
-- management, you should identify each sequence and index that you propose and 
-- the rationale supporting your suggestions. You should also state any 
-- drawbacks that might affect database performance if the changes are 
-- implemented.
CREATE SEQUENCE CUSTOMER_SEQ START WITH 1000 INCREMENT BY 1;

INSERT INTO CUSTOMERS VALUES (
  CUSTOMER_SEQ.NEXTVAL,
  'LASTNAME',
  'FIRSTNAME',
  'ADDRESS',
  'CITY',
  'STATE',
  'ZIP',
  REFERRED,
  'REGION',
  'EMAIL'
);

CREATE SEQUENCE ORDER_SEQ START WITH 1000 INCREMENT BY 1;

INSERT INTO ORDERS VALUES (
  ORDER_SEQ.NEXTVAL,
  CUSTOMER#,
  ORDERDATE,
  SHIPDATE,
  'SHIPSTREET',
  'SHIPCITY',
  'SHIPSTATE',
  'SHIPZIP',
  SHIPCOST
);

CREATE SEQUENCE BOOKS_SEQ START WITH 1000000000 INCREMENT BY 1;

INSERT INTO BOOKS VALUES (
  BOOKS_SEQ.NEXTVAL,
  'TITLE',
  PUBDATE,
  PUBID,
  COST,
  RETAIL,
  DISCOUNT,
  'CATEGORY'
);

CREATE INDEX CUSTOMER_NAME_IDX ON CUSTOMERS(LASTNAME, FIRSTNAME);

CREATE INDEX ORDER_DATE_IDX ON ORDERS(ORDERDATE);

CREATE INDEX BOOK_CATEGORY_IDX ON BOOKS(CATEGORY);

-- 1. The head DBA has requested the creation of a sequence for the primary key 
-- columns of the Criminals and Crimes tables. After creating the sequences, add 
-- a new criminal named Johnny Capps to the Criminals table by using the correct 
-- sequence. (Use any values for the remainder of columns.) A crime needs to be 
-- added for the criminal, too. Add a row to the Crimes table, referencing the 
-- sequence value already generated for the Criminal_ID and using the correct 
-- sequence to generate the Crime_ID value. (Use any values for the remainder of 
-- columns).
CREATE TABLE
    Criminals (
        Criminal_ID NUMBER,
        FirstName VARCHAR2(50),
        LastName VARCHAR2(50),
        -- other columns
        CONSTRAINT Criminals_PK PRIMARY KEY (Criminal_ID)
    );

CREATE TABLE
    Crimes (
        Crime_ID NUMBER,
        Criminal_ID NUMBER,
        CrimeType VARCHAR2(50),
        -- other columns
        CONSTRAINT Crimes_PK PRIMARY KEY (Crime_ID),
        CONSTRAINT Crimes_FK FOREIGN KEY (Criminal_ID) REFERENCES Criminals (Criminal_ID)
    );

-- Creating sequences
CREATE SEQUENCE seq_criminals
START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE seq_crimes
START WITH 1 INCREMENT BY 1;

-- Adding a new criminal named Johnny Capps
INSERT INTO
    Criminals (Criminal_ID, FirstName, LastName)
VALUES
    (seq_criminals.NEXTVAL, 'Johnny', 'Capps');

-- Adding a crime for the criminal
INSERT INTO
    Crimes (Crime_ID, Criminal_ID, CrimeType)
VALUES
    (
        seq_crimes.NEXTVAL,
        seq_criminals.CURRVAL,
        'Burglary'
    );

-- 2. The last name, street, and phone number columns of the Criminals table are used quite often in the WHERE clause condition of queries. Create objects that might improve data retrieval for these queries.
-- Creating an index on the LastName column
CREATE INDEX idx_criminals_last_name ON Criminals (LastName);

-- Creating an index on the Street column
CREATE INDEX idx_criminals_street ON Criminals (Street);

-- Creating an index on the PhoneNumber column
CREATE INDEX idx_criminals_phone_number ON Criminals (PhoneNumber);

-- 3. Would a bitmap index be appropriate for any columns in the City Jail database (assuming the columns are used in search and/or sort operations)? If so, identify the columns and explain why a bitmap index is appropriate for them.
CREATE BITMAP INDEX idx_criminals_gender ON Criminals (Gender);

CREATE BITMAP INDEX idx_crimes_crime_type ON Crimes (CrimeType);

CREATE BITMAP INDEX idx_prison_cells_status ON PrisonCells (PrisonCellStatus);

-- 4. Would using the City Jail database be any easier with the creation of synonyms? Explain why or why not.
CREATE SYNONYM CriminalData FOR Criminals;

-- Querying the Criminals table
SELECT
    Criminal_ID,
    First_Name,
    Last_Name
FROM
    Criminals
WHERE
    Last_Name = 'Capps';

-- Querying using the Synonym
SELECT
    Criminal_ID,
    First_Name,
    Last_Name
FROM
    CriminalData
WHERE
    Last_Name = 'Capps';
