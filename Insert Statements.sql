INSERT INTO Customer (FirstName, LastName, Address, City, State, ZIPCode, Email, Phone, AccountNumber)
VALUES ('John', 'Doe', '123 Main St', 'Cityville', 'Stateville', '12345', 'john.doe@example.com', '123-456-7890', 'ACCT001');
INSERT INTO Customer (FirstName, LastName, Address, City, State, ZIPCode, Email, Phone, AccountNumber)
VALUES ('Jane', 'Smith', '456 Elm St', 'Townville', 'Stateville', '54321', 'jane.smith@example.com', '987-654-3210', 'ACCT002');

INSERT INTO Meter (MeterNumber, MeterType, InstallationDate, LastReadingDate, LastReadingValue, CustomerID)
VALUES ('MTR001', 'Residential', '2022-01-01', '2023-05-01', 100.50, 1);
INSERT INTO Meter (MeterNumber, MeterType, InstallationDate, LastReadingDate, LastReadingValue, CustomerID)
VALUES ('MTR002', 'Commercial', '2022-02-01', '2023-05-01', 500.25, 2);

INSERT INTO BillingRate (RateType, RateDescription, UnitPrice)
VALUES ('Residential', 'Standard Rate', 0.10);
INSERT INTO BillingRate (RateType, RateDescription, UnitPrice)
VALUES ('Commercial', 'Peak Hours Rate', 0.15);

INSERT INTO BillingCycle (CycleStartDate, CycleEndDate)
VALUES ('2023-05-01', '2023-05-31');
INSERT INTO BillingCycle (CycleStartDate, CycleEndDate)
VALUES ('2023-04-01', '2023-04-30');

INSERT INTO MeterReading (MeterID, ReadingValue, ReadingDateTime)
VALUES (1, 150.25, '2023-05-15 12:00:00');
INSERT INTO MeterReading (MeterID, ReadingValue, ReadingDateTime)
VALUES (2, 700.50, '2023-05-15 12:00:00');

INSERT INTO Bill (CustomerID, CycleID, TotalConsumption, TotalAmount, PaymentStatus, DueDate)
VALUES (1, 1, 50.75, 5.08, 'Pending', '2023-06-15');
INSERT INTO Bill (CustomerID, CycleID, TotalConsumption, TotalAmount, PaymentStatus, DueDate)
VALUES (2, 1, 200.25, 30.04, 'Paid', '2023-06-15');

INSERT INTO Payment (BillID, PaymentAmount, PaymentDate)
VALUES (1, 5.08, '2023-06-01');
INSERT INTO Payment (BillID, PaymentAmount, PaymentDate)
VALUES (2, 30.04, '2023-05-20');

INSERT INTO AdminUser (Username, Password)
VALUES ('admin', 'password');
