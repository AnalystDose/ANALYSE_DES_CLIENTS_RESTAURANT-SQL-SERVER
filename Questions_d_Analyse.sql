CREATE DATABASE resto;

USE resto;

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

CREATE TABLE members(
	customer_id VARCHAR(1),
	join_date DATE
);


INSERT INTO members
	(customer_id, join_date)
VALUES
	('A', '2021-01-07'),
    ('B', '2021-01-09');

--Quel est le montant total dépensé par chaque client au restaurant ?



-- Depuis combien de jours chaque client fréquente-t-il le restaurant ?



-- Quel est le premier article du menu acheté par chaque client ?



-- Quel est l'article le plus acheté du menu et combien de fois a-t-il été acheté par tous les clients ?



-- Quel est le plat le plus apprécié par chaque client ?



-- 6. quel article a été acheté en premier par le client après qu'il soit devenu membre ?




-- 7. quel article a été acheté juste avant que le client ne devienne membre ?



-- Quel est le total des articles et des montants dépensés par chaque membre avant qu'il ne devienne membre ?



-- 9. si chaque dollar dépensé équivaut à 10 points et que les sushis ont un multiplicateur de points de 2 - combien de points chaque client aurait-il ?



/* 10. Au cours de la première semaine suivant l'adhésion d'un client au programme (y compris la date d'adhésion), il gagne 2 fois plus de points sur tous les articles, et pas seulement sur les sushis. 
combien de points les clients A et B ont-ils à la fin du mois de janvier ?



--11. Recréez la sortie du tableau en utilisant les données disponibles



--12. Classez tous les éléments :


