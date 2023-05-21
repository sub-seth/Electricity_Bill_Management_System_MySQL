-- Query to Calculate Total Amount Paid by Each Customer
SELECT
    C.CustomerID,
    CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
    SUM(P.PaymentAmount) AS TotalAmountPaid
FROM
    Customer C
INNER JOIN
    Bill B ON C.CustomerID = B.CustomerID
INNER JOIN
    Payment P ON B.BillID = P.BillID
GROUP BY
    C.CustomerID, CustomerName;

-- Query to Retrieve Billing History for a Customer
SELECT
    B.BillID,
    B.CycleID,
    B.TotalConsumption,
    B.TotalAmount,
    B.PaymentStatus,
    B.DueDate
FROM
    Bill B
WHERE
    B.CustomerID = 1;

-- Query to Get Top 5 Customers with the Highest Total Consumption
SELECT
    C.CustomerID,
    CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
    SUM(B.TotalConsumption) AS TotalConsumption
FROM
    Customer C
INNER JOIN
    Bill B ON C.CustomerID = B.CustomerID
GROUP BY
    C.CustomerID, CustomerName
ORDER BY
    TotalConsumption DESC
LIMIT 5;

-- Query to Calculate Average Consumption per Meter Type
SELECT
    M.MeterType,
    ROUND(AVG(MR.ReadingValue - M.LastReadingValue),2) AS AverageConsumption
FROM
    Meter M
INNER JOIN
    MeterReading MR ON M.MeterID = MR.MeterID
GROUP BY
    M.MeterType;

-- Query to Retrieve Unpaid Bills Past Their Due Date
SELECT
    B.BillID,
    CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
    B.DueDate
FROM
    Bill B
INNER JOIN
    Customer C ON B.CustomerID = C.CustomerID
WHERE
    B.PaymentStatus = 'Pending'
    AND B.DueDate < CURDATE();