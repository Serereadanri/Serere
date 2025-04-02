USE SkyBarrelBank_UAT


--THE DIRECTOR OF CREDIT ANALYTICS WANTS A REPORT OF ALL BORROWER WHO HAVE TAKEN A LOAN WITH THE BANK. 
--(WE ARE ONLY INTERESTED IN BORROWERS WHO HAVE A LOAN IN THE LOANSETUP TABLE)
-------BORROWERS WITH LOANS
SELECT [BORROWER'S ID]=BORR.[BorrowerID],
       [BORROWER'S FULL NAME]= CONCAT_WS(' ',BORR.[BorrowerFirstName],BORR.[BorrowerMiddleInitial],BORR.[BorrowerLastName]),
	   [SSN]=CONCAT('*****',RIGHT(BORR.[TaxPayerID_SSN],4)),
	   [YEAR OF PURCHASE]=YEAR(LS.[PurchaseDate]),
	   [PURCHASE AMOUNT(IN THOUSANDS)]=FORMAT(LS.[PurchaseAmount]/1000,'C0')+'K'
	   FROM [dbo].[Borrower] AS BORR
	   INNER JOIN [dbo].[LoanSetupInformation] AS LS
	   ON BORR.BorrowerID=LS.BorrowerID


----(1B)	   
-----BORROWERS WITHOUT LOANS
SELECT BORR.[BorrowerID],
       [BORROWER'S FULL NAME]= CONCAT_WS(' ',BORR.[BorrowerFirstName],BORR.[BorrowerMiddleInitial],BORR.[BorrowerLastName]),
	   [SSN]=CONCAT('*****',RIGHT(BORR.[TaxPayerID_SSN],4)),
	   [YEAR OF PURCHASE]=YEAR(LS.[PurchaseDate]),
	   [PURCHASE AMOUNT(IN THOUSANDS)]=FORMAT(LS.[PurchaseAmount]/1000,'C0')+'K'
	   FROM [dbo].[Borrower] AS BORR
	   LEFT JOIN [dbo].[LoanSetupInformation] AS LS
	   ON BORR.BorrowerID=LS.BorrowerID



-----AGGREGATE THE BORROWERS BY COUNTRY 
SELECT  [Citizenship],[TOTAL PURCHASE AMOUNT]= FORMAT(SUM([PurchaseAmount]),'C0'),
        [AVERAGE PURCHASE AMOUNT]=FORMAT (AVG([PurchaseAmount]),'C0'),
		[AVERAGE LTV]=FORMAT(AVG([LTV]),'P'),
		[MINIMUM LTV]=FORMAT(MIN([LTV]),'P'),
		[MAXIMUM LTV]=FORMAT(MAX([LTV]),'P'),
		[COUNT OF BORROWERS]=COUNT (LSI.[BorrowerID]),
		[AVERAGE AGE OF BORROWERS]= FLOOR(  AVG(FLOOR((DATEDIFF(day, [DOB], GETDATE())) / 365.25)))
FROM[dbo].[Borrower]AS BORR 
INNER JOIN[dbo].[LoanSetupInformation] AS LSI
ON BORR.BorrowerID=LSI.BorrowerID
GROUP BY [Citizenship]
ORDER BY [TOTAL PURCHASE AMOUNT] DESC;



-------------(2B)
-----AGGREGATE THE BORROWERS BY GENDER ( IF THE GENDER IS MISSING OR IS BLANK, PLEASE REPLACE IT WITH X) 
SELECT  [GENDER]=   
        CASE WHEN [Gender] IS NULL OR [Gender]= ' ' THEN 'X'
		ELSE [Gender]
		END, 
		[COUNT OF BORROWERS]=COUNT (LSI.[BorrowerID]),
		[AVERAGE AGE OF BORROWERS]= FLOOR(  AVG(FLOOR((DATEDIFF(day, [DOB], GETDATE())) / 365.25))) ,   
        [TOTAL PURCHASE AMOUNT]= FORMAT(SUM([PurchaseAmount]),'C0'),
        [AVERAGE PURCHASE AMOUNT]=FORMAT (AVG([PurchaseAmount]),'C0'),
		[AVERAGE LTV]=FORMAT(AVG([LTV]),'P'),
		[MINIMUM LTV]=FORMAT(MIN([LTV]),'P'),
		[MAXIMUM LTV]=FORMAT(MAX([LTV]),'P')
		FROM [dbo].[Borrower] AS BORR
		INNER JOIN [dbo].[LoanSetupInformation] AS LSI
		ON BORR.BorrowerID=LSI.BorrowerID
		GROUP BY CASE WHEN [Gender] IS NULL OR [Gender]= ' ' THEN 'X'
				 ELSE [Gender]
				 END		
	    ORDER BY [TOTAL PURCHASE AMOUNT] DESC


---------AGGREGATE THE BORROWERS BY GENDER (ONLY FOR F AND M GENDER) AND SHOW, PER YEAR
SELECT
		[YEAR OF PURCHASE]=YEAR([PurchaseDate]),
		[Gender]=CASE [Gender]
		         WHEN 'F' THEN 'FEMALE'
				 WHEN 'M' THEN 'MALE'
				 END,
		[COUNT OF BORROWERS]=COUNT(*),
		[AVERAGE AGE OF BORROWERS]= FLOOR(  AVG(FLOOR((DATEDIFF(day, [DOB], GETDATE())) / 365.25))),
		[TOTAL PURCHASE AMOUNT]= FORMAT(SUM([PurchaseAmount]),'C0'),
        [AVERAGE PURCHASE AMOUNT]=FORMAT (AVG([PurchaseAmount]),'C0'),
		[AVERAGE LTV]=FORMAT(AVG([LTV]),'P'),
		[MINIMUM LTV]=FORMAT(MIN([LTV]),'P'),
		[MAXIMUM LTV]=FORMAT(MAX([LTV]),'P')
		FROM [dbo].[Borrower] AS BORR
		INNER JOIN[dbo].[LoanSetupInformation] AS LSI
		ON BORR.BorrowerID=LSI.BorrowerID
		WHERE [Gender] IS NOT NULL AND[Gender] <>' '
		GROUP BY YEAR([PurchaseDate]),[Gender]
		ORDER BY YEAR([PurchaseDate]) DESC


-------(3A)	
--------CALCULATE THE YEARS TO MATURITY FOR EACH LOAN( ONLY LOANS THAT HAVE A MATURITY DATE IN THE FUTURE)
--------AND THEN CATEGORIZE THEM IN BINS
WITH CTE_BND AS
	(
		SELECT[MaturityDate],[YEARS LEFT TO MATURITY]= DATEDIFF(YEAR,GETDATE(),[MaturityDate]) 
		FROM[dbo].[LoanSetupInformation]
	    WHERE MaturityDate>=CAST(GETDATE() AS DATE)
		)
		SELECT 
		 [YEARS LEFT TO MATURITY IN BINS]= CASE WHEN [YEARS LEFT TO MATURITY] <=5 THEN '0-5'
		                                       WHEN [YEARS LEFT TO MATURITY] <=10 THEN '6-10'
											   WHEN [YEARS LEFT TO MATURITY] <=15 THEN '11-15'
											   WHEN [YEARS LEFT TO MATURITY] <=20 THEN '16-20'
											   WHEN [YEARS LEFT TO MATURITY] <=25 THEN '21-25'
											   WHEN [YEARS LEFT TO MATURITY] <=29 THEN '26-30'
											   WHEN [YEARS LEFT TO MATURITY] >=30 THEN '>30'
											   ELSE 'ERROR'
											   END,
	    [NO OF LOANS]=  COUNT(distinct[LoanNumber] ),
		[TOTAL PURCHASE AMOUNT]=FORMAT( (SUM(DISTINCT[PurchaseAmount]))/1000000000,'C0')+'B'
					FROM [dbo].[LoanSetupInformation] AS A
					JOIN CTE_BND AS B
					ON A.MaturityDate=B.MaturityDate
					GROUP BY CASE WHEN [YEARS LEFT TO MATURITY] <=5 THEN '0-5'
		                                       WHEN [YEARS LEFT TO MATURITY] <=10 THEN '6-10'
											   WHEN [YEARS LEFT TO MATURITY] <=15 THEN '11-15'
											   WHEN [YEARS LEFT TO MATURITY] <=20 THEN '16-20'
											   WHEN [YEARS LEFT TO MATURITY] <=25 THEN '21-25'
											   WHEN [YEARS LEFT TO MATURITY] <=29 THEN '26-30'
											   WHEN [YEARS LEFT TO MATURITY] >=30 THEN '>30'
											   ELSE 'ERROR'
											   END
			ORDER BY [YEARS LEFT TO MATURITY IN BINS]

 
 --------AGGREGATE THE NUMBER LOANS BY YEAR OF PURCHASE AND THE 
 --------PAYMENT FREQUENCY DESCRIPTION COLUMN FOUND IN THE LU_PAYMENT_FREQUENCY TABLE    	 
SELECT 
[YEAR OF PURCHASE]=YEAR([PurchaseDate]),
[PAYMENT FREQUENCY DESCRIPTION]=[PaymentFrequency_Description],[NO. OF LOANS]=COUNT([LoanNumber])
FROM [dbo].[LoanSetupInformation] AS LSI
LEFT JOIN[dbo].[LU_PaymentFrequency] AS LPF
ON LSI.PaymentFrequency=LPF.PaymentFrequency
GROUP BY YEAR([PurchaseDate]),[PaymentFrequency_Description]
ORDER BY YEAR([PurchaseDate]) DESC

