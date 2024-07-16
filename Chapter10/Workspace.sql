-- 1. Produce a list of all customer names in which the first letter of the first and last names is in uppercase and the rest are in lowercase.
SELECT
    INITCAP(LastName) || ' ' || INITCAP(FirstName) AS CustomerName
FROM
    Customers;

-- 2. Create a list of all customer numbers along with text indicating whether the customer has been referred by another customer. Display the text “NOT REFERRED” if the customer wasn’t referred to JustLee Books by another customer or “REFERRED” if the customer was referred.
SELECT
    Customer#,
    CASE
        WHEN Referred IS NULL THEN 'NOT REFERRED'
        ELSE 'REFERRED'
    END AS ReferralStatus
FROM
    Customers;

-- 3. Determine the amount of total profit generated by the book purchased on order 1002. Display the book title and profit. The profit should be formatted to display a dollar sign and two decimal places. Take into account that the customer might not pay the full retail price, and each item ordered can involve multiple copies.
SELECT
    B.Title,
    TO_CHAR(
        SUM(OI.Quantity * (B.Retail - B.Cost)),
        '$9,999.00'
    ) AS Profit
FROM
    Orders O
    JOIN OrderItems OI ON O.Order# = OI.Order#
    JOIN Books B ON OI.ISBN = B.ISBN
WHERE
    O.Order# = 1002
GROUP BY
    B.Title;

-- 4. Display a list of all book titles and the percentage of markup for each book. The percentage of markup should be displayed as a whole number (that is, multiplied by 100) with no decimal position, followed by a percent sign (for example, .2793 = 28%). (The percentage of markup should reflect the difference between the retail and cost amounts as a percent of the cost.).
SELECT
    Title,
    TO_CHAR(((Retail - Cost) / Cost) * 100, '999') || '%' AS MarkupPercentage
FROM
    Books;

-- 5. Display the current day of the week, hour, minutes, and seconds of the current date setting on the computer you’re using.
SELECT
    TO_CHAR(SYSDATE, 'Day') AS DayOfWeek,
    TO_CHAR(SYSDATE, 'HH24') AS Hour,
    TO_CHAR(SYSDATE, 'MI') AS Minutes,
    TO_CHAR(SYSDATE, 'SS') AS Seconds
FROM
    dual;

-- 6. Create a list of all book titles and costs. Precede each book’s cost with asterisks so that the width of the displayed Cost field is 12.
SELECT
    Title,
    LPAD(TO_CHAR(Cost, '99.99'), 12, '*') AS DisplayedCost
FROM
    Books;

-- 7. Determine the length of data stored in the ISBN field of the BOOKS table. Make sure each different length value is displayed only once (not once for each book).
SELECT DISTINCT
    LENGTH(ISBN) AS ISBN_Length
FROM
    BOOKS;

-- 7. Determine the length of data stored in the ISBN field of the BOOKS table. Make sure each different length value is displayed only once (not once for each book).
SELECT DISTINCT
    LENGTH(ISBN) AS ISBN_Length
FROM
    BOOKS;

-- 8. Using today’s date, determine the age (in months) of each book that JustLee sells. Make sure only whole months are displayed; ignore any portions of months. Display the book title, publication date, current date, and age.
SELECT
    Title,
    PubDate AS PublicationDate,
    SYSDATE AS CurrentDate,
    FLOOR(MONTHS_BETWEEN(SYSDATE, PubDate)) AS AgeInMonths
FROM
    Books;

-- 9. Determine the calendar date of the next occurrence of Wednesday, based on today’s date.
SELECT
    SYSDATE AS CurrentDate,
    NEXT_DAY(SYSDATE, 'WEDNESDAY') AS NextWednesday
FROM
    dual;

-- 10. Produce a list of each customer number and the third and fourth digits of his or her zip code. The query should also display the position of the first occurrence of a 3 in the customer number, if it exists.
SELECT
    Customer#,
    SUBSTR(Zip, 3, 2) AS ThirdAndFourthDigitsOfZip,
    CASE
        WHEN INSTR(TO_CHAR(Customer#), '3') > 0 THEN INSTR(TO_CHAR(Customer#), '3')
        ELSE NULL
    END AS PositionOfFirst3
FROM
    Customers;

-- ### Advanced Challenge
-- Management is proposing to increase the price of each book. The amount of the increase will be based on each book’s category, according to the following scale: Computer books, 10%; Fitness books, 15%; Self-Help books, 25%; all other categories, 3%. Create a list that displays each book’s title, category, current retail price, and revised retail price. The prices should be displayed with two decimal places. The column headings for the output should be as follows: Title, Category, Current Price, and Revised Price. Sort the results by category. If there’s more than one book in a category, a secondary sort should be performed on the book’s title. Create a document to show management the SELECT statement used to generate the results and the results of the statement.
SELECT
    Title,
    Category,
    TO_CHAR(Retail, '$9999.99') AS "Current Price",
    TO_CHAR(
        Retail * CASE
            WHEN Category = 'Computer' THEN 1.10
            WHEN Category = 'Fitness' THEN 1.15
            WHEN Category = 'Self Help' THEN 1.25
            ELSE 1.03
        END,
        '$9999.99'
    ) AS "Revised Price"
FROM
    Books
ORDER BY
    Category,
    Title;

-- 1. List the following information for all crimes that have a period greater than 14 days between the date charged and the hearing date: crime ID, classification, date charged, hearing date, and number of days between the date charged and the hearing date.
SELECT
  c.crime_id,
  c.classification,
  c.date_charged,
  c.hearing_date,
  c.hearing_date - c.date_charged AS days_between
FROM
  crimes c
WHERE
  c.hearing_date - c.date_charged > 14;

-- 2. Produce a list showing each active police officer and his or her community assignment, indicated by the second letter of the precinct code. Display the community description listed in the following chart, based on the second letter of the precinct code.
SELECT
  o.officer_id,
  o.last || ', ' || o.first AS officer_name,
  o.precinct,
  CASE SUBSTR(o.precinct, 2, 1)
    WHEN 'C' THEN 'City Center'
    WHEN 'H' THEN 'Harbor'
    WHEN 'A' THEN 'Airport'
    WHEN 'W' THEN 'Westside'
    ELSE 'Unknown'
  END AS community_assignment
FROM
  officers o
WHERE
  o.status = 'A';

-- 3. Produce a list of sentencing information to include criminal ID, name (displayed in all uppercase letters), sentence ID, sentence start date, and length in months of the sentence. The number of months should be shown as a whole number. The start date should be displayed in the format “December 17, 2009.”
SELECT
  s.criminal_id,
  UPPER(c.last) || ', ' || UPPER(c.first) AS criminal_name,
  s.sentence_id,
  TO_CHAR(s.start_date, 'Month DD, YYYY') AS start_date,
  MONTHS_BETWEEN(s.end_date, s.start_date) AS sentence_length_months
FROM
  sentences s
  JOIN criminals c ON s.criminal_id = c.criminal_id;

-- 4. A list of all amounts owed is needed. Create a list showing each criminal name, charge ID, total amount owed (fine amount plus court fee), amount paid, amount owed, and payment due date. If nothing has been paid to date, the amount paid is NULL. Include only criminals who owe some amount of money. Display the dollar amounts with a dollar sign and two decimals.
SELECT
  UPPER(c.last) || ', ' || UPPER(c.first) AS criminal_name,
  cc.charge_id,
  TO_CHAR(cc.fine_amount + cc.court_fee, '$99999.99') AS total_amount_owed,
  TO_CHAR(cc.amount_paid, '$99999.99') AS amount_paid,
  TO_CHAR(
    (cc.fine_amount + cc.court_fee) - NVL(cc.amount_paid, 0),
    '$99999.99'
  ) AS amount_owed,
  TO_CHAR(cc.pay_due_date, 'Month DD, YYYY') AS payment_due_date
FROM
  crime_charges cc
  JOIN crimes cr ON cc.crime_id = cr.crime_id
  JOIN criminals c ON cr.criminal_id = c.criminal_id
WHERE
  (cc.fine_amount + cc.court_fee) - NVL(cc.amount_paid, 0) > 0;

-- 5. Display the criminal name and probation start date for all criminals who have a probation period greater than two months. Also, display the date that’s two months from the beginning of the probation period, which will serve as a review date.
SELECT
  c.last || ', ' || c.first AS criminal_name,
  s.start_date AS probation_start_date,
  ADD_MONTHS(s.start_date, 2) AS review_date
FROM
  criminals_dw c
  JOIN sentences s ON c.criminal_id = s.criminal_id
WHERE
  s.type = 'P'
  AND MONTHS_BETWEEN(s.end_date, s.start_date) > 2;

-- 6. An INSERT statement is needed to support users adding a new appeal. Create an INSERT statement using substitution variables. Note that users will be entering dates in the format of a two-digit month, a two-digit day, and a four-digit year, such as “12 17 2009.” In addition, a sequence named APPEALS_ID_SEQ exists to supply values for the Appeal_ID column, and the default setting for the Status column should take effect (that is, the DEFAULT option on the column should be used). Test the statement by adding the following appeal: crime_ID ¼ 25344031, filing date ¼ 02 13 2009, and hearing date ¼ 02 27 2009.
SET
  SERVEROUTPUT ON ACCEPT crime_id CHAR DEFAULT 25344031 PROMPT 'Enter Crime_ID [Default: 25344031]: ' ACCEPT filing_date CHAR DEFAULT '02 13 2009' PROMPT 'Enter Filing_Date (MM DD YYYY) [Default: 02 13 2009]: ' ACCEPT hearing_date CHAR DEFAULT '02 27 2009' PROMPT 'Enter Hearing_Date (MM DD YYYY) [Default: 02 27 2009]: '
DECLARE V_CRIME_ID NUMBER := &CRIME_ID;

V_FILING_DATE DATE := TO_DATE('&filing_date', 'MM DD YYYY');

V_HEARING_DATE DATE := TO_DATE('&hearing_date', 'MM DD YYYY');

BEGIN
INSERT INTO
  APPEALS (APPEAL_ID, CRIME_ID, FILING_DATE, HEARING_DATE)
VALUES
  (
    APPEALS_ID_SEQ.NEXTVAL,
    V_CRIME_ID,
    V_FILING_DATE,
    V_HEARING_DATE
  );

DBMS_OUTPUT.PUT_LINE ('Appeal successfully added.');

EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE ('Error: ' || SQLERRM);

END;

/
