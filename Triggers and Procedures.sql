-- Trigger to Update LastReadingDate in Meter Table
DELIMITER //
CREATE TRIGGER update_last_reading_date
AFTER INSERT ON MeterReading
FOR EACH ROW
BEGIN
    UPDATE Meter
    SET LastReadingDate = NEW.ReadingDateTime
    WHERE MeterID = NEW.MeterID;
END//
DELIMITER ;

-- Procedure to Generate Bills
DELIMITER //
CREATE PROCEDURE generate_bills(IN cycleID INT)
BEGIN
    DECLARE consumption DECIMAL(10,2);
    DECLARE amount DECIMAL(10,2);

    -- Calculate consumption and amount for each meter reading
    INSERT INTO Bill (CustomerID, CycleID, TotalConsumption, TotalAmount, PaymentStatus, DueDate)
    SELECT
        M.CustomerID,
        cycleID,
        (MR.ReadingValue - M.LastReadingValue) AS consumption,
        (MR.ReadingValue - M.LastReadingValue) * BR.UnitPrice AS amount,
        'Pending',
        DATE_ADD((SELECT CycleEndDate FROM BillingCycle WHERE CycleID = cycleID), INTERVAL 15 DAY) AS dueDate
    FROM
        MeterReading MR
    INNER JOIN
        Meter M ON MR.MeterID = M.MeterID
    INNER JOIN
        BillingRate BR ON M.MeterType = BR.RateType
    WHERE
        MR.MeterID = M.MeterID
        AND M.LastReadingDate BETWEEN (SELECT CycleStartDate FROM BillingCycle WHERE CycleID = cycleID) AND (SELECT CycleEndDate FROM BillingCycle WHERE CycleID = cycleID)
        AND M.LastReadingValue < MR.ReadingValue;

    -- Update the LastReadingDate and LastReadingValue in Meter table
    UPDATE Meter M
    INNER JOIN
        (
        SELECT
            MeterID,
            MAX(ReadingDateTime) AS LastReadingDateTime,
            MAX(ReadingValue) AS LastReadingValue
        FROM
            MeterReading
        GROUP BY
            MeterID
        ) AS MR ON M.MeterID = MR.MeterID
    SET
        M.LastReadingDate = MR.LastReadingDateTime,
        M.LastReadingValue = MR.LastReadingValue;
END//
DELIMITER ;

-- Procedure to Calculate Total Amount in Bill
DELIMITER //
CREATE PROCEDURE calculate_bill_amount(IN billID INT)
BEGIN
    DECLARE consumption DECIMAL(10,2);
    DECLARE amount DECIMAL(10,2);

    -- Calculate consumption and amount based on meter readings and billing rates
    SELECT
        (MR.ReadingValue - M.LastReadingValue) AS consumption,
        (MR.ReadingValue - M.LastReadingValue) * BR.UnitPrice AS amount
    INTO
        consumption,
        amount
    FROM
        MeterReading MR
    INNER JOIN
        Meter M ON MR.MeterID = M.MeterID
    INNER JOIN
        BillingRate BR ON M.MeterType = BR.RateType
    WHERE
        MR.ReadingID = (SELECT MAX(ReadingID) FROM MeterReading WHERE MeterID = M.MeterID)
        AND M.MeterID = (SELECT MeterID FROM Bill WHERE BillID = billID);

    -- Update the TotalConsumption and TotalAmount in Bill table
    UPDATE Bill
    SET
        TotalConsumption = consumption,
        TotalAmount = amount
    WHERE
        BillID = billID;
END//
DELIMITER ;

