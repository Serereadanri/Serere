CREATE TABLE _Loans
(
	Book_Status          CHAR(18) NULL,
	Date_Borrowed        DATE NULL,
	Book_ID              INTEGER NULL,
	Loan_ID              INTEGER NOT NULL,
	Date_Due             DATE NULL,
	Status_ID            INTEGER NOT NULL
);



ALTER TABLE _Loans
ADD PRIMARY KEY (Loan_ID);



CREATE TABLE Author
(
	Birth_Date           DATE NULL,
	Death_Date           DATE NULL,
	First_Name           VARCHAR(20) NULL,
	Author_ID            INTEGER NOT NULL,
	Last_Name            VARCHAR(20) NULL
);



ALTER TABLE Author
ADD PRIMARY KEY (Author_ID);



CREATE TABLE Book
(
	Review               VARCHAR(20) NULL,
	Year_Published       DATE NULL,
	ISBN                 INTEGER NULL,
	Book_Name            VARCHAR(20) NULL,
	Book_ID              INTEGER NOT NULL,
	Library_ID           INTEGER NOT NULL,
	Publisher_ID__374    INTEGER NOT NULL
);



ALTER TABLE Book
ADD PRIMARY KEY (Book_ID);



CREATE TABLE Book_Author
(
	Book_ID              INTEGER NOT NULL,
	Author_ID            INTEGER NOT NULL
);



ALTER TABLE Book_Author
ADD PRIMARY KEY (Author_ID,Book_ID);



CREATE TABLE Book_Genre
(
	Book_ID              INTEGER NOT NULL,
	Genre_ID             INTEGER NOT NULL
);



ALTER TABLE Book_Genre
ADD PRIMARY KEY (Book_ID,Genre_ID);



CREATE TABLE Book_Loans
(
	Book_ID              INTEGER NOT NULL,
	Loan_ID              INTEGER NOT NULL
);



ALTER TABLE Book_Loans
ADD PRIMARY KEY (Book_ID,Loan_ID);



CREATE TABLE Employees
(
	Start_Date           DATE NULL,
	End_Date             CHAR(18) NULL,
	DOB                  CHAR(18) NULL,
	Gender               CHAR(18) NULL,
	Phone_Number         CHAR(18) NULL,
	Email_Address        CHAR(18) NULL,
	Position             CHAR(18) NULL,
	Employees_Name       VARCHAR(20) NULL,
	Employees_ID         INTEGER NOT NULL,
	Library_ID           INTEGER NOT NULL
);



ALTER TABLE Employees
ADD PRIMARY KEY (Employees_ID);



CREATE TABLE Genre
(
	Genre                CHAR(18) NULL,
	Genre_ID             INTEGER NOT NULL
);



ALTER TABLE Genre
ADD PRIMARY KEY (Genre_ID);



CREATE TABLE Library
(
	Location             VARCHAR(20) NULL,
	Library_Name         VARCHAR(20) NULL,
	Library_ID           INTEGER NOT NULL
);



ALTER TABLE Library
ADD PRIMARY KEY (Library_ID);



CREATE TABLE Library_Patrons
(
	Address              CHAR(18) NULL,
	User_ID              INTEGER NOT NULL,
	Membership_Date      CHAR(18) NULL,
	Email_Address        CHAR(18) NULL,
	Phone_Number         CHAR(18) NULL,
	First_Name           VARCHAR(20) NULL,
	Library_ID           INTEGER NOT NULL,
	Last_Name            VARCHAR(20) NULL
);



ALTER TABLE Library_Patrons
ADD PRIMARY KEY (User_ID);



CREATE TABLE Library_Patrons__Loans
(
	User_ID              INTEGER NOT NULL,
	Loan_ID              INTEGER NOT NULL
);



ALTER TABLE Library_Patrons__Loans
ADD PRIMARY KEY (User_ID,Loan_ID);



CREATE TABLE Loan_Status
(
	Status_ID            INTEGER NOT NULL,
	Book_Status          CHAR(18) NULL
);



ALTER TABLE Loan_Status
ADD PRIMARY KEY (Status_ID);



CREATE TABLE Publisher
(
	Address              CHAR(18) NULL,
	Phone_Number         CHAR(18) NULL,
	Email_Address        CHAR(18) NULL,
	Publisher_Name__358  VARCHAR(20) NULL,
	Publisher_ID__374    INTEGER NOT NULL
);



ALTER TABLE Publisher
ADD PRIMARY KEY (Publisher_ID__374);



CREATE TABLE Return
(
	Return_ID            INTEGER NOT NULL,
	Condition_returned   VARCHAR(20) NULL,
	Loan_ID              INTEGER NOT NULL,
	Overdue_Fine         INTEGER NULL,
	Return_Date          DATE NULL
);



ALTER TABLE Return
ADD PRIMARY KEY (Return_ID);



CREATE TABLE Review
(
	Book_Review          VARCHAR(20) NULL,
	User_ID              INTEGER NULL,
	Rating_Score         CHAR(18) NULL,
	Rating_ID            CHAR(18) NOT NULL,
	Book_ID              INTEGER NOT NULL
);



ALTER TABLE Review
ADD PRIMARY KEY (Rating_ID);



ALTER TABLE _Loans
ADD CONSTRAINT R_33 FOREIGN KEY (Status_ID) REFERENCES Loan_Status (Status_ID);



ALTER TABLE Book
ADD CONSTRAINT R_18 FOREIGN KEY (Library_ID) REFERENCES Library (Library_ID);



ALTER TABLE Book
ADD CONSTRAINT R_34 FOREIGN KEY (Publisher_ID__374) REFERENCES Publisher (Publisher_ID__374);



ALTER TABLE Book_Author
ADD CONSTRAINT R_22 FOREIGN KEY (Book_ID) REFERENCES Book (Book_ID);



ALTER TABLE Book_Author
ADD CONSTRAINT R_24 FOREIGN KEY (Author_ID) REFERENCES Author (Author_ID);



ALTER TABLE Book_Genre
ADD CONSTRAINT R_19 FOREIGN KEY (Book_ID) REFERENCES Book (Book_ID);



ALTER TABLE Book_Genre
ADD CONSTRAINT R_21 FOREIGN KEY (Genre_ID) REFERENCES Genre (Genre_ID);



ALTER TABLE Book_Loans
ADD CONSTRAINT R_28 FOREIGN KEY (Book_ID) REFERENCES Book (Book_ID);



ALTER TABLE Book_Loans
ADD CONSTRAINT R_30 FOREIGN KEY (Loan_ID) REFERENCES _Loans (Loan_ID);



ALTER TABLE Employees
ADD CONSTRAINT R_16 FOREIGN KEY (Library_ID) REFERENCES Library (Library_ID);



ALTER TABLE Library_Patrons
ADD CONSTRAINT R_17 FOREIGN KEY (Library_ID) REFERENCES Library (Library_ID);



ALTER TABLE Library_Patrons__Loans
ADD CONSTRAINT R_37 FOREIGN KEY (User_ID) REFERENCES Library_Patrons (User_ID);



ALTER TABLE Library_Patrons__Loans
ADD CONSTRAINT R_39 FOREIGN KEY (Loan_ID) REFERENCES _Loans (Loan_ID);



ALTER TABLE Return
ADD CONSTRAINT R_32 FOREIGN KEY (Loan_ID) REFERENCES _Loans (Loan_ID);



ALTER TABLE Review
ADD CONSTRAINT R_27 FOREIGN KEY (User_ID) REFERENCES Library_Patrons (User_ID);



ALTER TABLE Review
ADD CONSTRAINT R_35 FOREIGN KEY (Book_ID) REFERENCES Book (Book_ID);


