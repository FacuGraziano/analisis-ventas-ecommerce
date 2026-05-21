Revenue = SUMX(
   online_retail_final_v2,
   online_retail_final_v2[Quantity] * online_retail_final_v2[UnitPrice]
)
Total Orders = DISTINCTCOUNT(online_retail_final_v2[InvoiceNo])
Total Customers = DISTINCTCOUNT(online_retail_final_v2[CustomerID])
Avg Ticket = DIVIDE([Revenue], [Total Orders])
Revenue % =
DIVIDE(
   [Revenue],
   CALCULATE([Revenue], ALL(online_retail_final_v2[Country]))
Month = FORMAT(online_retail_final_v2[InvoiceDate], "YYYY-MM")
MonthOrder = YEAR(online_retail_final_v2[InvoiceDate]) * 100 + MONTH(online_retail_final_v2[InvoiceDate])
