-- =========================================================
-- LIMPIEZA DE DATOS - PROYECTO ECOMMERCE
-- =========================================================

-- =========================================================
-- 1. DETECCIÓN DE CustomerID VACÍOS
-- =========================================================
-- Se verifica la cantidad total de registros y cuántos
-- poseen CustomerID válido.

SELECT COUNT(*) AS total_registros,
       COUNT(CustomerID) AS customerid_validos
FROM online_retail;


-- =========================================================
-- 2. BÚSQUEDA DE CustomerID VACÍOS ("")
-- =========================================================
-- Algunos valores no eran NULL, sino strings vacíos.

SELECT *
FROM online_retail
WHERE CustomerID = '';


-- =========================================================
-- 3. CONVERSIÓN DE VALORES VACÍOS A NULL
-- =========================================================
-- Esto permite tratar correctamente los datos faltantes.

UPDATE online_retail
SET CustomerID = NULL
WHERE CustomerID = '';


-- =========================================================
-- 4. DETECCIÓN DE DEVOLUCIONES Y CANCELACIONES
-- =========================================================
-- Las facturas que comienzan con "C"
-- representan cancelaciones o devoluciones.

SELECT *
FROM online_retail
WHERE InvoiceNo LIKE 'C%';


-- =========================================================
-- 5. DETECCIÓN DE CANTIDADES NEGATIVAS
-- =========================================================
-- Las cantidades negativas afectan el análisis de ventas.

SELECT *
FROM online_retail
WHERE Quantity < 0;


-- =========================================================
-- 6. CREACIÓN DE DATASET LIMPIO INICIAL
-- =========================================================
-- Se eliminan:
-- - devoluciones
-- - cancelaciones
-- - cantidades negativas

CREATE TABLE online_retail_clean AS
SELECT *
FROM online_retail
WHERE Quantity > 0
  AND InvoiceNo NOT LIKE 'C%';


-- =========================================================
-- 7. DETECCIÓN DE DESCRIPCIONES FALTANTES
-- =========================================================
-- Productos sin descripción no pueden analizarse correctamente.

SELECT *
FROM online_retail_clean
WHERE Description IS NULL
   OR Description = '';


-- =========================================================
-- 8. CREACIÓN DE DATASET FINAL
-- =========================================================
-- Se eliminan registros con:
-- - descripciones vacías
-- - productos no válidos

CREATE TABLE online_retail_final AS
SELECT *
FROM online_retail_clean
WHERE Description IS NOT NULL
  AND Description <> '';


-- =========================================================
-- 9. DETECCIÓN DE PRECIOS INVÁLIDOS
-- =========================================================
-- UnitPrice <= 0 no representa ventas reales.

SELECT *
FROM online_retail_final
WHERE UnitPrice <= 0;


-- =========================================================
-- 10. ELIMINACIÓN DE DATOS NO COMERCIALES
-- =========================================================
-- Se excluyen:
-- - precios en cero
-- - costos de envío
-- - descuentos

CREATE TABLE online_retail_ready AS
SELECT *
FROM online_retail_final
WHERE UnitPrice > 0
  AND Description NOT LIKE '%POSTAGE%'
  AND Description NOT LIKE '%DISCOUNT%';


-- =========================================================
-- 11. DETECCIÓN DE AJUSTES CONTABLES
-- =========================================================
-- "adjust bad debt" corresponde a ajustes financieros,
-- no ventas reales.

SELECT *
FROM online_retail_ready
WHERE LOWER(Description) LIKE '%debt%';


-- =========================================================
-- 12. DATASET FINAL LISTO PARA ANÁLISIS
-- =========================================================
-- Se eliminan ajustes contables y registros no comerciales.

CREATE TABLE online_retail_final_v2 AS
SELECT *
FROM online_retail_ready
WHERE LOWER(Description) NOT LIKE '%debt%';
