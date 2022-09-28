
--Query su singola tabella

-- 1- Selezionare tutte le software house americane (3)

SELECT *
FROM software_houses
WHERE country = 'United States';

-- 2- Selezionare tutti i giocatori della città di 'Rogahnland' (2)

SELECT *
FROM players
where city = 'Rogahnland';

-- 3- Selezionare tutti  igiocatori il cui nome finisce per "a" (220)

SELECT *
FROM players
WHERE name like '%a';

-- 4- Selezionare tutte le recensioni scritte dal giocatore con ID = 800 (11)

SELECT *
FROM reviews
WHERE player_id = 800;

-- 5- Contare quanti tornei ci sono stati nell'anno 2015 (9)

SELECT *
FROM tournaments
WHERE year = 2015;

-- 6- Selezionare tutti i premi che contengono nella descrizione la parola 'facere' (2)

SELECT * 
FROM awards
WHERE description like '%facere%';

-- 7- Selezionare tutti i videogame che hanno la categoria 2 (FPS) o 6 (RPG), mostrandoli una sola volta (del videogioco vogliamo solo l'ID) (287)

SELECT COUNT(id)
FROM category_videogame
WHERE category_id = 2 OR category_id = 6 
GROUP BY videogame_id;

-- 8- Selezionare tutte le recensioni con voto compreso tra 2 e 4 (2947)

SELECT *
FROM reviews
WHERE rating >= 2 AND rating <= 4;

-- 9- Selezionare tutti i dati dei videogiochi rilasciati nell'anno 2020 (46)

SELECT *
FROM videogames
WHERE YEAR(release_date) = 2020;

-- 10- Selezionare gli id dei videogame che hanno ricevuto almeno una recensione da 5 stelle, mostrandoli una sola volta (443)

SELECT DISTINCT videogame_id
FROM reviews
WHERE rating = 5;

-- *********** BONUS ***********

-- 11- Selezionare il numero e la media delle recensioni per il videogioco con ID = 412 (review number = 12, avg_rating = 3)

SELECT COUNT(videogame_id) AS review_number, AVG(rating) AS avg_rating 
FROM reviews 
WHERE videogame_id = 412;

-- 12- Selezionare il numero di videogame che la software house con ID = 1 ha rilasciato nel 2018 (13)

SELECT COUNT(id) AS videogame_number
FROM videogames
WHERE software_house_id = 1 AND YEAR(release_date) = 2018;


--Query con GROUP BY


-- 1- Contare quante software house ci sono per ogni paese (3)

SELECT country, COUNT(*) AS "software_house_number"
FROM software_houses
GROUP BY country;

-- 2- Contare quante recensioni ha ricevuto ogni videogioco (del videogioco vogliamo solo l'ID) (500)

SELECT videogame_id, COUNT(*) AS "review_number"
FROM reviews
GROUP BY videogame_id;

-- 3- Contare quanti videogiochi hanno ciascuna classificazione PEGI (della classificazione PEGI vogliamo solo l'ID) (13)

SELECT pegi_label_id, COUNT(videogame_id) AS "videogame_number"
FROM pegi_label_videogame
GROUP BY pegi_label_id;

-- 4- Mostrare il numero di videogiochi rilasciati ogni anno (11)

SELECT COUNT(*) AS "videogames_number"
FROM videogames
GROUP BY YEAR(release_date);

-- 5- Contare quanti videogiochi sono disponbiili per ciascun device (del device vogliamo solo l'ID) (7)

SELECT device_id, COUNT(videogame_id) AS "videogames_number"
FROM device_videogame
GROUP BY device_id;

-- 6- Ordinare i videogame in base alla media delle recensioni (del videogioco vogliamo solo l'ID) (500)

SELECT videogame_id, AVG(rating) AS avg_rating
FROM reviews
GROUP BY videogame_id
ORDER BY avg_rating ASC;


--Query con JOIN


-- 1- Selezionare i dati di tutti giocatori che hanno scritto almeno una recensione, mostrandoli una sola volta (996)

SELECT player_id, name, lastname, nickname, city
FROM players
RIGHT JOIN reviews
ON players.id = player_id
GROUP BY player_id, name, lastname, nickname, city;

-- 2- Sezionare tutti i videogame dei tornei tenuti nel 2016, mostrandoli una sola volta (226)
SELECT videogame_id
FROM tournament_videogame
INNER JOIN tournaments on tournaments.id = tournament_videogame.tournament_id
WHERE tournaments.year = 2016
GROUP BY videogame_id;

-- 3- Mostrare le categorie di ogni videogioco (1718)

SELECT videogames.name AS nome_videogioco, categories.name AS nome_categoria
FROM category_videogame
INNER JOIN videogames on videogame_id = videogames.id
INNER JOIN categories on category_id = categories.id

-- 4- Selezionare i dati di tutte le software house che hanno rilasciato almeno un gioco dopo il 2020, mostrandoli una sola volta (6)

SELECT software_houses.name
FROM videogames
INNER jOIN software_houses ON software_house_id = software_houses.id
WHERE YEAR(videogames.release_date) > 2020
GROUP BY software_houses.name;

-- 5- Selezionare i premi ricevuti da ogni software house per i videogiochi che ha prodotto (55)

SELECT award_id, software_houses.name, videogames.name
FROM award_videogame
INNER JOIN videogames on videogames.id = videogame_id
INNER JOIN software_houses on videogames.software_house_id = software_houses.id
ORDER BY software_houses.name;

-- 6- Selezionare categorie e classificazioni PEGI dei videogiochi che hanno ricevuto recensioni da 4 e 5 stelle, mostrandole una sola volta (3363)

SELECT videogames.name AS videogame_name, pegi_labels.name AS pegi_name, categories.name AS category_name
FROM pegi_labels
RIGHT JOIN pegi_label_videogame
ON pegi_labels.id = pegi_label_id
LEFT JOIN videogames
ON videogames.id = pegi_label_videogame.videogame_id
RIGHT JOIN category_videogame 
ON videogames.id = category_videogame.videogame_id
LEFT JOIN categories
ON category_id=categories.id
LEFT JOIN reviews
ON reviews.videogame_id = videogames.id
WHERE reviews.rating >=4 AND reviews.rating <=5
GROUP BY videogames.name, pegi_labels.name, categories.name;

-- 7- Selezionare quali giochi erano presenti nei tornei nei quali hanno partecipato i giocatori il cui nome inizia per 'S' (474)

SELECT videogames.id
FROM videogames
RIGHT JOIN tournament_videogame
ON videogames.id= tournament_videogame.videogame_id
LEFT JOIN tournaments
ON tournaments.id= tournament_videogame.tournament_id
RIGHT JOIN player_tournament
ON tournaments.id=player_tournament.tournament_id
LEFT JOIN players
ON players.id=player_tournament.player_id
WHERE players.name LIKE 'S%'
GROUP BY videogames.id;

-- 8- Selezionare le città in cui è stato giocato il gioco dell'anno del 2018 (36)

SELECT DISTINCT tournaments.city
FROM videogames
JOIN award_videogame ON videogames.id = award_videogame.videogame_id
JOIN tournament_videogame ON videogames.id = tournament_videogame.videogame_id
JOIN tournaments ON tournament_videogame.tournament_id = tournaments.id
WHERE award_videogame.year = 2018;

-- 9- Selezionare i giocatori che hanno giocato al gioco più atteso del 2018 in un torneo del 2019 (3306)

SELECT players.name, players.lastname, players.nickname
FROM players
INNER JOIN player_tournament ON players.id = player_tournament.player_id
INNER JOIN tournaments ON player_tournament.tournament_id = tournaments.id
INNER JOIN tournament_videogame ON tournaments.id = tournament_videogame.tournament_id
INNER JOIN videogames ON tournament_videogame.videogame_id = videogames.id
INNER JOIN award_videogame ON videogames.id = award_videogame.videogame_id
INNER JOIN awards ON award_videogame.award_id = awards.id
where awards.name = 'Gioco più atteso' AND year(videogames.release_date) = 2018 AND tournaments.year = 2019;

-- *********** BONUS ***********

-- 10- Selezionare i dati della prima software house che ha rilasciato un gioco, assieme ai dati del gioco stesso (software house id : 5)

-- 11- Selezionare i dati del videogame (id, name, release_date, totale recensioni) con più recensioni (videogame id : 398)

-- 12- Selezionare la software house che ha vinto più premi tra il 2015 e il 2016 (software house id : 1)

-- 13- Selezionare le categorie dei videogame i quali hanno una media recensioni inferiore a 1.5 (10)