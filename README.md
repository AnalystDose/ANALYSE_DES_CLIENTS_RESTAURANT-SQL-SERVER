# ANALYSE_DES_CLIENTS_RESTAURANT-SQL-SERVER
![App Screenshot](https://8weeksqlchallenge.com/images/case-study-designs/1.png)


## Introduction

Ce projet et les données utilisées faisaient partie d'une étude de cas qui peut être consultée  [ici](https://8weeksqlchallenge.com/case-study-1/). Il s'agit d'examiner les modèles, les tendances et les facteurs qui influencent les dépenses des clients afin de mieux connaître leurs préférences, leurs habitudes d'achat et les domaines susceptibles d'être améliorés dans les menus proposés ou les stratégies de marketing d'un établissement de restauration.

## Problématique
Danny souhaite utiliser les données pour répondre à quelques questions simples sur ses clients, notamment sur leurs habitudes de visite, combien d'argent ils ont dépensé et quels éléments de menu sont leurs préférés. Avoir ce lien plus profond avec ses clients l’aidera à offrir une expérience meilleure et plus personnalisée à ses clients fidèles.

Il prévoit d'utiliser ces informations pour l'aider à décider s'il doit étendre le programme de fidélisation de la clientèle existant. En outre, il a besoin d'aide pour générer des ensembles de données de base afin que son équipe puisse facilement inspecter les données sans avoir besoin d'utiliser SQL.

Danny vous a fourni un échantillon de ses données client globales en raison de problèmes de confidentialité - mais il espère que ces exemples seront suffisants pour que vous puissiez écrire des requêtes SQL entièrement fonctionnelles pour l'aider à répondre à ses questions !


## Diagramme des relations entre entités

![Capture d'écran 2024-05-15 233144](https://github.com/AnalystDose/ANALYSE_DES_CLIENTS_RESTAURANT-SQL-SERVER/assets/169387833/6b0e8246-dddb-40ef-8248-47dfd15f6c19)


## Compétences mises en œuvre
 
- Window Functions
- CTEs
- Les Fonction d'aggregation
- Les jointures

## Questions étudiées
1. Quel est le montant total dépensé par chaque client au restaurant ?
2. Depuis combien de jours chaque client fréquente-t-il le restaurant ?
3. Quel est le premier article du menu acheté par chaque client ?
4. Quel est l'article le plus acheté du menu et combien de fois a-t-il été acheté par tous  les clients ?
5. Quel est le plat le plus apprécié par chaque client ?
6. Quel article a été acheté en premier par le client après qu'il soit devenu membre ?
7. Quel article a été acheté juste avant que le client ne devienne membre ?
8. Quel est le nombre total d'articles et le montant dépensé par chaque membre avant qu'il ne devienne membre ?
9. Si chaque dollar dépensé équivaut à 10 points et que les sushis ont un multiplicateur de points de 2 - combien de points chaque client aurait-il ?
Au cours de la première semaine suivant l'adhésion d'un client au programme (y compris la date d'adhésion), il gagne 2 fois plus de points sur tous les articles, et pas seulement sur les sushis - combien de points les clients A et B ont-ils à la fin du mois de janvier ?

## Scripts de creation de la base de données et insertions

```bash
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
```
