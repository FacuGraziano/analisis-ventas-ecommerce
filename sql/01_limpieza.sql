-- =========================================================
-- LIMPIEZA DE DATOS - PROYECTO ECOMMERCE
-- =========================================================

-- =========================================================
-- 1. Deteccion de CustomerID vacios
-- =========================================================
-- Se verifica la cantidad total de registros y cuántos
-- poseen CustomerID válido.

SELECT COUNT(*) AS total_registros,
       COUNT(CustomerID) AS customerid_validos
FROM online_retail;


-- =========================================================
-- 2. Busqueda de CustomerID vacios ("")
-- =========================================================
-- Algunos valores no eran NULL, sino strings vacíos.

SELECT *
FROM online_retail
WHERE CustomerID = '';


-- =========================================================
-- 3. Transformacion de campos vacios a null
-- =========================================================
-- Convertimos strings vacíos a NULL para manejar mejor los datos faltantes

UPDATE online_retail
SET CustomerID = NULL
WHERE CustomerID = '';


-- =========================================================
-- 4. Deteccion de devoluciones y cancelaciones
-- =========================================================
-- Las facturas que comienzan con "C"
-- representan cancelaciones o devoluciones.

SELECT *
FROM online_retail
WHERE InvoiceNo LIKE 'C%';


-- =========================================================
-- 5. Deteccion de cantidades negativas
-- =========================================================
-- Las cantidades negativas afectan el análisis de ventas.

SELECT *
FROM online_retail
WHERE Quantity < 0;


-- =========================================================
-- 6. Creacion del dataset limpio inicial
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
-- 7. Deteccion de descripciones vacias
-- =========================================================
-- Productos sin descripción no pueden analizarse correctamente.

SELECT *
FROM online_retail_clean
WHERE Description IS NULL
   OR Description = '';


-- =========================================================
-- 8. Creacion del dataset final
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
-- 9. Deteccion de precios incorrectos
-- =========================================================
-- UnitPrice <= 0 no representa ventas reales.

SELECT *
FROM online_retail_final
WHERE UnitPrice <= 0;


-- =========================================================
-- 10. Eliminacios de datos no comerciales
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
-- 11. Deteccion de ajustes contables
-- =========================================================
-- "adjust bad debt" corresponde a ajustes financieros,
-- no ventas reales.

SELECT *
FROM online_retail_ready
WHERE LOWER(Description) LIKE '%debt%';


-- =========================================================
-- 12.Tabla final utilizada para las métricas y visualizaciones
-- =========================================================
-- Se eliminan ajustes contables y registros no comerciales.

CREATE TABLE online_retail_final_v2 AS
SELECT *
FROM online_retail_ready
WHERE LOWER(Description) NOT LIKE '%debt%';
