use movies;

# 1 --Write a SQL query to count the number of characters except for the spaces for each actor. 
   --Return the first 10 actors' name lengths along with their names.

-- select first_name from actor limit 10;
SELECT first_name, LENGTH(first_name) as count_characters FROM actor LIMIT 10;  



# 2 --List all Oscar awardees(Actors who received the Oscar award) with their full names and the length of their names

-- select * from actor_award where awards = 'Oscar'; 
-- select * from actor;
SELECT   
CONCAT(actor.first_name, ' ', actor.last_name) as FullName,
CHAR_LENGTH(concat(actor.first_name, ' ', actor.last_name)) as length 
FROM (actor
INNER JOIN actor_award ON actor.actor_id = actor_award.actor_id)
WHERE awards = 'Oscar';

# 3 --Find the actors who have acted in the film ‘Frost Head.

-- select * from film where title = 'Frost Head';
-- select * from film_actor where film_id = 341;
-- select * from actor;
SELECT 
actor.first_name
FROM ((film
INNER JOIN film_actor ON film.film_id = film_actor.film_id)
INNER JOIN actor ON film_actor.actor_id = actor.actor_id)
WHERE title = 'Frost Head';


# 4 --Pull all the films acted by the actor 'Will Wilson'.

-- select * from actor where first_name = 'WILL' and last_name = 'Wilson';
-- select * from film_actor where actor_id = 168;
-- select title from film;
SELECT 
film.title 
FROM ((actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id)
INNER JOIN film ON film_actor.film_id = film.film_id)
WHERE first_name = 'WILL' AND last_name = 'Wilson';


# 5 --Pull all the films which were rented and return them in the month of May.

-- select * from rental where month(rental_date) = 5 and month(return_date) = 5; #inventory_id
-- select * from inventory; # film_id
-- select * from film; #title
SELECT 
film.title
FROM (( rental
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id)
INNER JOIN film ON inventory.film_id = film.film_id)
WHERE MONTHNAME(rental_date) = 'May' AND MONTHNAME(return_date) = 'May';


# 6 --Pull all the films with ‘Comedy’ category.

-- select * from category where name = 'Comedy';
-- select * from film_category where category_id = 5;
-- select title from film;
SELECT DISTINCT 
film.title
FROM ((category
INNER JOIN film_category ON category.category_id = film_category.category_id)
INNER JOIN film ON film_category.film_id = film.film_id)
WHERE name = 'Comedy';