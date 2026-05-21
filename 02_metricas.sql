-- =========================================================
-- MÉTRICAS Y ANÁLISIS FINAL - PROYECTO ECOMMERCE
-- =========================================================


-- =========================================================
-- 1. REVENUE TOTAL
-- =========================================================
-- Cálculo de ingresos totales generados.

SELECT 
    ROUND(SUM(Quantity * UnitPrice), 2) AS revenue_total
FROM online_retail_final_v2;


-- =========================================================
-- 2. TOTAL DE ÓRDENES
-- =========================================================
-- Cantidad total de órdenes únicas.

SELECT 
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM online_retail_final_v2;


-- =========================================================
-- 3. TOTAL DE CLIENTES
-- =========================================================
-- Cantidad de clientes únicos.

SELECT 
    COUNT(DISTINCT CustomerID) AS total_customers
FROM online_retail_final_v2;


-- =========================================================
-- 4. TICKET PROMEDIO
-- =========================================================
-- Promedio de ingresos por orden.

SELECT 
    ROUND(
        SUM(Quantity * UnitPrice) /
        COUNT(DISTINCT InvoiceNo),
    2) AS avg_ticket
FROM online_retail_final_v2;


-- =========================================================
-- 5. TOP 10 PAÍSES POR INGRESOS
-- =========================================================
-- Países con mayor revenue generado.

SELECT 
    Country,
    ROUND(SUM(Quantity * UnitPrice), 2) AS revenue
FROM online_retail_final_v2
GROUP BY Country
ORDER BY revenue DESC
LIMIT 10;


-- =========================================================
-- 6. TOP 10 PRODUCTOS POR INGRESOS
-- =========================================================
-- Productos que más ingresos generaron.

SELECT 
    Description,
    ROUND(SUM(Quantity * UnitPrice), 2) AS revenue
FROM online_retail_final_v2
GROUP BY Description
ORDER BY revenue DESC
LIMIT 10;


-- =========================================================
-- 7. TOP 10 CLIENTES POR INGRESOS
-- =========================================================
-- Clientes con mayor volumen de compras.

SELECT 
    CustomerID,
    ROUND(SUM(Quantity * UnitPrice), 2) AS revenue
FROM online_retail_final_v2
GROUP BY CustomerID
ORDER BY revenue DESC
LIMIT 10;


-- =========================================================
-- 8. EVOLUCIÓN MENSUAL DE INGRESOS
-- =========================================================
-- Tendencia de revenue a lo largo del tiempo.

SELECT 
    strftime('%Y-%m', InvoiceDate) AS month,
    ROUND(SUM(Quantity * UnitPrice), 2) AS revenue
FROM online_retail_final_v2
GROUP BY month
ORDER BY month;


-- =========================================================
-- 9. PRODUCTOS MÁS VENDIDOS
-- =========================================================
-- Productos con mayor cantidad de unidades vendidas.

SELECT 
    Description,
    SUM(Quantity) AS total_quantity
FROM online_retail_final_v2
GROUP BY Description
ORDER BY total_quantity DESC
LIMIT 10;


-- =========================================================
-- 10. PARTICIPACIÓN DE INGRESOS POR PAÍS
-- =========================================================
-- Porcentaje del revenue total representado por cada país.

SELECT 
    Country,
    ROUND(SUM(Quantity * UnitPrice), 2) AS revenue,
    ROUND(
        SUM(Quantity * UnitPrice) * 100.0 /
        (
            SELECT SUM(Quantity * UnitPrice)
            FROM online_retail_final_v2
        ),
    2) AS revenue_percentage
FROM online_retail_final_v2
GROUP BY Country
ORDER BY revenue DESC;
