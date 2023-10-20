--1. Tampilkan 5 negara dengan pengguna ecommerce terbanyak
SELECT
  u.country,
  COUNT(u.country) AS sum_of_country
FROM
  `bigquery-public-data.thelook_ecommerce.users` AS u
GROUP BY
  u.country
ORDER BY
  sum_of_country DESC
LIMIT 5;

--2. Tampilkan brand yang memiliki rerata harga eceran produk diatas 900 dan jumlah barang di bawah 5 buah
SELECT
  p.brand,
  COUNT(p.name) AS sum_of_product,
  AVG(p.retail_price) AS mean
FROM
  `bigquery-public-data.thelook_ecommerce.products` as p
WHERE
  p.retail_price > 900
GROUP BY
  p.brand
HAVING
  sum_of_product < 5
ORDER BY mean DESC;

--3. Tampilkan produk yang banyak dibeli oleh perempuan yang berusia 20-35 tahun
SELECT
  p.name,
  COUNT(p.name) AS sum_of_product
FROM
  `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN
  `bigquery-public-data.thelook_ecommerce.users` AS u ON oi.user_id = u.id
JOIN
  `bigquery-public-data.thelook_ecommerce.products` AS p ON oi.product_id = p.id
WHERE
  u.age > 20 AND u.age < 35 AND u.gender = 'F' AND (oi.status != 'Cancelled' OR oi.status != 'Returned')
GROUP BY
  p.name
ORDER BY
  sum_of_product DESC;

--4. Tampilkan 5 produk yang paling cepat habis
SELECT 
  i.product_name,
  COUNT(i.product_name) AS product_sold_out
FROM 
  `bigquery-public-data.thelook_ecommerce.inventory_items` AS i
WHERE i.sold_at IS NOT NULL
GROUP BY
  i.product_name
ORDER BY product_sold_out DESC;

--5. Tampilkan pemasukan per tahun
SELECT 
  EXTRACT(YEAR FROM i.sold_at) AS year,
  SUM(i.cost) AS income
FROM 
  `bigquery-public-data.thelook_ecommerce.inventory_items` AS i
WHERE i.sold_at IS NOT NULL
GROUP BY
  year
ORDER BY 1;

-- 6. Tampilkan kategori pemasukan perbulan pada tahun 2023
WITH table_income AS (
  SELECT 
    EXTRACT(MONTH FROM i.sold_at) AS month,
    SUM(i.cost) AS income
  FROM 
    `bigquery-public-data.thelook_ecommerce.inventory_items` AS i
  WHERE
    i.sold_at IS NOT NULL AND (EXTRACT(YEAR FROM i.sold_at) = 2023)
  GROUP BY
    month
  ORDER BY 1
)
SELECT
  month,
  income,
  CASE
    WHEN income < 200000 THEN 'RENDAH'
    WHEN income > 200000 AND income < 300000 THEN 'SEDANG'
    ELSE 'TINGGI'
  END AS category
FROM
  table_income;

--7. Tampilkan barang yang harus dikirim beserta jumlahnya
SELECT
  p.id,
  p.name,
  oi.status,
  COUNT(oi.status) AS sum_of_product_status
FROM
  `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN
  `bigquery-public-data.thelook_ecommerce.products` AS p ON oi.product_id = p.id
WHERE
  oi.status = 'Processing'
GROUP BY
  p.id,
  p.name,
  oi.status
ORDER BY
  p.id;

--8. harga eceran barang untuk laki-laki dan perempuan mahal mana
SELECT
  department,
  AVG(retail_price) AS mean
FROM `bigquery-public-data.thelook_ecommerce.products`
GROUP BY department
ORDER BY mean DESC;

--9. jumlah barang per kategori
SELECT
  category,
  department,
  COUNT(category) AS sum_of_products
FROM `bigquery-public-data.thelook_ecommerce.products`
GROUP BY category, department
ORDER BY category ASC;

--10. jumlah barang untuk laki-laki dan perempuan
SELECT
  department,
  COUNT(department) AS sum_of_products
FROM `bigquery-public-data.thelook_ecommerce.products`
GROUP BY department
ORDER BY sum_of_products DESC;
