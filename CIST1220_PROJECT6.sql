#=================================================================================
									#1
#   Write a SELECT statement that returns these columns from the Products table:
# The list_price column
# A column that uses the FORMAT function to return the list_price column with 1
# digit to the right of the decimal point
# A column that uses the CONVERT function to return the list_price column as an
# integer
# A column that uses the CAST function to return the list_price column as an integer
# DELIVERABLE
                                
#=================================================================================
SELECT list_price, 
		FORMAT(list_price, 1) AS list_format, 
        CONVERT(list_price, SIGNED) AS list_convert,
        CAST(list_price AS SIGNED) AS list_cast
FROM products;
#=================================================================================
									#2
# Write a SELECT statement that returns these columns from the Products table:
# The date_added column
# A column that uses the CAST function to return the date_added column with its date
# only (year, month, and day)
# A column that uses the CAST function to return the date_added column with just the
# year and the month
# A column that uses the CAST function to return the date_added column with its full
# time only (hour, minutes, and seconds)
# DELIVERABLE                                    
#=================================================================================                                    
SELECT date_added,
		CAST(date_added AS DATE),
        CAST(date_added AS CHAR(7)),
        CAST(date_added AS TIME)
FROM products;