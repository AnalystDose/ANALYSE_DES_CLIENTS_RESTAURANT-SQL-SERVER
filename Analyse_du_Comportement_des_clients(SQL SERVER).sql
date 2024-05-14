CREATE DATABASE resto;

USE resto;

--Table  ventes

CREATE TABLE sales(
	customer_id VARCHAR(1),
	order_date DATE,
	product_id INTEGER
);

INSERT INTO sales
	(customer_id, order_date, product_id)
VALUES
	('A', '2021-01-01', 1),
	('A', '2021-01-01', 2),
	('A', '2021-01-07', 2),
	('A', '2021-01-10', 3),
	('A', '2021-01-11', 3),
	('A', '2021-01-11', 3),
	('B', '2021-01-01', 2),
	('B', '2021-01-02', 2),
	('B', '2021-01-04', 1),
	('B', '2021-01-11', 1),
	('B', '2021-01-16', 3),
	('B', '2021-02-01', 3),
	('C', '2021-01-01', 3),
	('C', '2021-01-01', 3),
	('C', '2021-01-07', 3);




--Table  menus

CREATE TABLE menu(
	product_id INTEGER,
	product_name VARCHAR(5),
	price INTEGER
);

INSERT INTO menu
	(product_id, product_name, price)
VALUES
	(1, 'sushi', 10),
    (2, 'curry', 15),
    (3, 'ramen', 12);




--Table  membres

CREATE TABLE members(
	customer_id VARCHAR(1),
	join_date DATE
);


INSERT INTO members
	(customer_id, join_date)
VALUES
	('A', '2021-01-07'),
    ('B', '2021-01-09');





--ETUDE DES CAS 



-- 1. Quel est le montant total dépensé par chaque client au restaurant ?

SELECT customer_id, order_date, product_name, price, sum(price) OVER (PARTITION BY customer_id) AS conso
FROM sales s
inner join menu m
on s.product_id = m.product_id


SELECT customer_id,  sum(price)  AS Tot_conso 
FROM sales s
inner join menu m
on s.product_id = m.product_id
group by customer_id


--2. Combien de jours chaque client a-t-il visité le restaurant ?

SELECT customer_id, count(order_date) as Nbre_Tot_Jour --nombre de fois le client a visité le restaurant
FROM sales s
inner join menu m
on s.product_id = m.product_id
group by customer_id

SELECT customer_id, count(distinct (order_date)) as Nbre_Tot_Jour --nombre de jour le client a visité le restaurant
FROM sales s
inner join menu m
on s.product_id = m.product_id
group by customer_id


--3. Quel a été le premier élément du menu acheté par chaque client ?

SELECT customer_id, order_date, product_name
FROM sales s
inner join menu m
on s.product_id = m.product_id

 --3.1 calculer la premiere date d'achat pour chaque client

 SELECT s.customer_id, Min(order_date) as Premier_achat --Date de premier achat pour chaque clients
FROM sales s
inner join menu m
on s.product_id = m.product_id
group by s.customer_id

  --3.2 associer les produit acheter pour ces dates 

  WITH Premier_Produit_achete AS 
  ( SELECT customer_id, Min(order_date) as Premier_achat --Date de premier achat pour chaque clients
FROM sales s
inner join menu m
on s.product_id = m.product_id
group by customer_id
)

SELECT p.customer_id, p.Premier_achat, m.product_name
FROM Premier_Produit_achete p
JOIN sales s ON p.customer_id = s.customer_id
	 AND p.Premier_achat = s.order_date
JOIN menu m ON m.product_id = s.product_id


--4. Quel est l’élément du menu le plus acheté et combien de fois a-t-il été acheté par tous les clients ?
 
 SELECT TOP 1 product_name, count(product_name)	as Nbre_Produit
FROM sales s
inner join menu m
on s.product_id = m.product_id
group by product_name 
order by Nbre_Produit desc


 --5. Quel article a été le plus populaire pour chaque client ?

  --5.1 classement des article par client
  SELECT customer_id,product_name, count(product_name) as Nbre_Prod,
 ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY count(product_name) DESC) as Rank
FROM sales s
inner join menu m
on s.product_id = m.product_id
group by customer_id, product_name


  SELECT customer_id,product_name, count(product_name) as Nbre_Prod,
 DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY count(product_name) DESC) as Rank
FROM sales s
inner join menu m
on s.product_id = m.product_id
group by customer_id, product_name


 --5.2 article le plus populaire pour chaque clients
WITH Pop_PROD AS 

 (SELECT customer_id,product_name, count(product_name) as Nbre_Prod,
 ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY count(product_name) DESC) as Rank
FROM sales s
inner join menu m
on s.product_id = m.product_id
group by customer_id, product_name
)

SELECT *
FROM Pop_PROD as PP
WHERE Rank = 1


WITH Pop_PROD AS 

 (SELECT customer_id,product_name, count(product_name) as Nbre_Prod,
 DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY count(product_name) DESC) as Rank
FROM sales s
inner join menu m
on s.product_id = m.product_id
group by customer_id, product_name
)

SELECT customer_id, product_name, Nbre_Prod
FROM Pop_PROD as PP
WHERE Rank = 1


--6. Quel article a été acheté en premier par le client après être devenu membre ?

--6.1 Date d'achat du premier produit  qui lui à permis de joindre les membres

SELECT s.customer_id,MIN(s.order_date) as Date_ent_Menbre
FROM sales s
inner join members me
on s.customer_id = me.customer_id
where s.order_date>= me.join_date
group by s.customer_id


--6.2 Associer le produit a la date de jointure

WITH Prod_mem  as (
SELECT s.customer_id,MIN(s.order_date) as Date_ent_Menbre
FROM sales s
inner join members me
on s.customer_id = me.customer_id
where s.order_date>= me.join_date
group by s.customer_id

)

SELECT pm.customer_id, pm.Date_ent_Menbre, m.product_name
FROM Prod_mem as pm
INNER JOIN sales as s
	ON pm.customer_id = s.customer_id
AND pm.Date_ent_Menbre = s.order_date

INNER JOIN menu as m
	ON m.product_id = s.product_id


--7. Quel article a été acheté juste avant que le client ne devienne membre ?

--7.1 Date d'achat de produit avant d'etre membre

SELECT s.customer_id, MAX(order_date) as Date_avnt_mem
FROM sales s
inner join members me
on s.customer_id = me.customer_id
where s.order_date< me.join_date
group by s.customer_id

-- 7.2 Asocier chaque produit a chaque date


WITH Prod_avant_mem  as (
SELECT s.customer_id, MAX(order_date) as Date_avnt_mem
FROM sales s
inner join members me
on s.customer_id = me.customer_id
where s.order_date< me.join_date
group by s.customer_id
)

SELECT pam.customer_id, m.product_name
FROM Prod_avant_mem as pam
INNER JOIN sales as s
     ON pam.customer_id = s.customer_id
	AND pam.Date_avnt_mem = s.order_date
INNER JOIN menu as m
	ON m.product_id = s.product_id
 

 --8. Quel est le total des articles et le montant dépensé pour chaque membre avant de devenir membre ?

 SELECT *
FROM sales s
inner join menu as m
on s.product_id = m.product_id
inner join members as me
on s.customer_id = me.customer_id


 SELECT s.customer_id, COUNT(s.customer_id) as Total_Prod_avt_Mem, SUM( m.price) as Tot_Prix
FROM sales s
inner join menu as m
on s.product_id = m.product_id
inner join members as me
on s.customer_id = me.customer_id
where s.order_date < me.join_date
group by s.customer_id


--9. Si chaque dollar dépensé équivaut à 10 points et que les sushis ont un multiplicateur de points de 2, combien de points chaque client aurait-il ?

 SELECT s.customer_id,SUM(
 
 CASE 
		WHEN m.product_name = 'sushi' THEN m.price * 20
		ELSE m.price *10

 END) AS BONUS

FROM sales s
inner join menu as m
on s.product_id = m.product_id
group by s.customer_id


--10 . Au cours de la première semaine après qu'un client a rejoint le programme 
--(y compris sa date d'adhésion), il gagne 2x points sur tous les articles, pas seulement
--sur les sushis. De combien de points les clients A et B ont-ils fin janvier ?


 SELECT *
FROM sales s
inner join menu as m
on s.product_id = m.product_id
inner join members as me
on s.customer_id = me.customer_id


SELECT s.customer_id, SUM(
    CASE 
        WHEN s.order_date BETWEEN mb.join_date AND DATEADD(day, 7, mb.join_date) THEN m.price*20
        WHEN m.product_name = 'sushi' THEN m.price*20 
        ELSE m.price*10 
    END) AS total_points
FROM dbo.sales s
JOIN dbo.menu m ON s.product_id = m.product_id
LEFT JOIN dbo.members mb ON s.customer_id = mb.customer_id
WHERE s.customer_id IN ('A', 'B') AND s.order_date <= '2021-01-31'
--WHERE s.customer_id = mb.customer_id AND s.order_date <= '2021-01-31'
GROUP BY s.customer_id;


--11. Recree la table avec toutes les informations neccessaires

 SELECT s.customer_id, s.order_date, m.product_name, m.price,
 CASE
		when s.customer_id = 'A' and s.order_date >= '2021-01-07' THEN 'Y'
		when s.customer_id = 'B' and s.order_date >= '2021-01-11' THEN 'Y'
		ELSE 'N'
 END AS Membre
FROM sales s
inner join menu as m
on s.product_id = m.product_id
ORDER BY 1,2


 SELECT s.customer_id, s.order_date, m.product_name, m.price,
 CASE
		when  s.order_date >= me.join_date THEN 'Y'
		ELSE 'N'
 END AS Membre
FROM sales s
inner join menu as m
on s.product_id = m.product_id
left join members as me
on s.customer_id =  me.customer_id
ORDER BY 1,2


--12. LES CLASSEMENTS

WITH class as 
(
 SELECT s.customer_id, s.order_date, m.product_name, m.price,
 CASE
		when  s.order_date >= me.join_date THEN 'Y'
		ELSE 'N'
 END AS Membre
FROM sales s
inner join menu as m
on s.product_id = m.product_id
left join members as me
on s.customer_id =  me.customer_id
)

SELECT 
  *, 
  CASE
    WHEN Membre = 'N' THEN NULL
    ELSE RANK () OVER(PARTITION BY customer_id, Membre ORDER BY order_date) END AS Classement
FROM class
ORDER BY customer_id, order_date;


