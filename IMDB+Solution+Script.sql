USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Shape of tables from the database 
SELECT
  TABLE_NAME AS `Table`,
  ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024) AS `Size (KB)`
FROM
  information_schema.TABLES
WHERE
  TABLE_SCHEMA = "imdb"
ORDER BY
  (DATA_LENGTH + INDEX_LENGTH)
DESC;

-- count of NULL values in each column of each table
SELECT count(*)
FROM director_mapping
WHERE movie_id IS NULL;			# No null values

SELECT count(*)
FROM director_mapping
WHERE name_id IS NULL;			# No null values

SELECT count(*)
FROM genre
WHERE movie_id IS NULL;			# No null values

SELECT count(*)
FROM genre
WHERE genre IS NULL;			# No null values

SELECT count(*)
FROM movie
WHERE id IS NULL;			# No null values

SELECT count(*)
FROM movie
WHERE title IS NULL;			# No null values

SELECT count(*)
FROM movie
WHERE year IS NULL;			# No null values

SELECT count(*)
FROM movie
WHERE date_published IS NULL;			# No null values

SELECT count(*)
FROM movie
WHERE duration IS NULL;			# No null values

SELECT count(*)
FROM movie
WHERE country IS NULL;			# 20 null values

SELECT count(*)
FROM movie
WHERE worlwide_gross_income IS NULL;			# 3724 null values

SELECT count(*)
FROM movie
WHERE languages IS NULL;			# 194 null values

SELECT count(*)
FROM movie
WHERE production_company IS NULL;			# 528 null values

SELECT count(*)
FROM names
WHERE id IS NULL;			# No null values

SELECT count(*)
FROM names
WHERE name IS NULL;			# No null values

SELECT count(*)
FROM names
WHERE height IS NULL;			# 17335 null values

SELECT count(*)
FROM names
WHERE date_of_birth IS NULL;			# 13431 null values

SELECT count(*)
FROM names
WHERE known_for_movies IS NULL;			# 15226 null values

SELECT count(*)
FROM ratings
WHERE movie_id IS NULL;			# No null values

SELECT count(*)
FROM ratings
WHERE avg_rating IS NULL;			# No null values

SELECT count(*)
FROM ratings
WHERE total_votes IS NULL;			# No null values

SELECT count(*)
FROM ratings
WHERE median_rating IS NULL;			# No null values

SELECT count(*)
FROM role_mapping
WHERE movie_id IS NULL;			# No null values

SELECT count(*)
FROM role_mapping
WHERE name_id IS NULL;			# No null values

SELECT count(*)
FROM role_mapping
WHERE category IS NULL;			# No null values


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT count(*)
FROM director_mapping;			# 3867 rows

SELECT count(*)
FROM genre;			# 14662 rows

SELECT count(*)
FROM movie;			# 7997 rows

SELECT count(*)
FROM names;			# 25735 rows

SELECT count(*)
FROM ratings;			# 7997 rows

SELECT count(*)
FROM role_mapping;			# 15615 rows


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT count(*)
FROM movie
WHERE id IS NULL;			# No null values

SELECT count(*)
FROM movie
WHERE title IS NULL;			# No null values

SELECT count(*)
FROM movie
WHERE year IS NULL;			# No null values

SELECT count(*)
FROM movie
WHERE date_published IS NULL;			# No null values

SELECT count(*)
FROM movie
WHERE duration IS NULL;			# No null values

SELECT count(*)
FROM movie
WHERE country IS NULL;			# 20 null values

SELECT count(*)
FROM movie
WHERE worlwide_gross_income IS NULL;			# 3724 null values

SELECT count(*)
FROM movie
WHERE languages IS NULL;			# 194 null values

SELECT count(*)
FROM movie
WHERE production_company IS NULL;			# 528 null values


-- Now as you can see four columns of the movie table has null values. Let's look at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- For year-wise count
SELECT year AS Year, count(id) AS number_of_movies
	FROM movie
		GROUP BY year
        ORDER BY year;
-- For month-wise count
SELECT EXTRACT(month from date_published) AS month_num, count(id) AS number_of_movies
	FROM movie
		GROUP BY EXTRACT(month from date_published)
        ORDER BY EXTRACT(month from date_published);


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code belo));w:

SELECT count(*)
	FROM movie
    where year = '2019' AND 
    (country LIKE '%India%' OR country LIKE '%USA%');		# 1059 records found which satisfies given conditions


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
	FROM genre;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT g.genre AS Genre, count(g.movie_id) AS Overall_Count
	FROM genre AS g
    INNER JOIN
    movie AS m
    ON g.movie_id = m.id
    GROUP BY genre
    ORDER BY count(g.movie_id) desc
    limit 1;									# DRAMA Genre : 4285 --> Highest Count


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH genre_count AS
(SELECT g.movie_id, count(g.genre) as Genre_Count
	FROM genre AS g
    INNER JOIN
    movie AS m
    ON g.movie_id = m.id
    GROUP BY g.movie_id HAVING count(g.genre) = 1)
    
    SELECT count(*)
		FROM genre_count;		# 3289 movies associated with only 1 genre


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre, ROUND(SUM(duration)/COUNT(duration),2) AS avg_duration
	FROM genre AS g
    INNER JOIN 
    movie AS m
    ON g.movie_id = m.id
    GROUP BY g.genre
    ORDER BY ROUND(SUM(duration)/COUNT(duration),0) DESC;		# ACTION: 112.88 --> HISHEST & HORROR: 92.72 --> LOWEST


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT g.genre AS Genre, count(g.movie_id) AS movie_count, RANK() OVER(ORDER BY count(g.movie_id) desc) AS genre_rank
	FROM genre AS g
    INNER JOIN
    movie AS m
    ON g.movie_id = m.id
    GROUP BY g.genre;			# Thriller: 1484 --> Rank - 3


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT ROUND(min(avg_rating),0) AS min_avg_rating,
		ROUND(max(avg_rating),0) AS max_avg_rating,
		min(total_votes) AS min_total_votes,
        max(total_votes) AS max_total_votes,
		min(median_rating) AS min_median_rating,
        max(median_rating) AS min_median_rating
	FROM ratings;
    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT m.title, r.avg_rating, DENSE_RANK() OVER(ORDER BY r.avg_rating desc) AS movie_rank
	FROM movie AS m
    INNER JOIN
    ratings AS r
    ON m.id = r.movie_id
    GROUP BY r.avg_rating
    limit 10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT r.median_rating, count(m.id)
	FROM ratings AS r
    INNER JOIN
    movie AS m
    ON r.movie_id = m.id
    GROUP BY r.median_rating
    ORDER BY r.median_rating DESC;


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH hit_producer AS
(SELECT production_company, count(m.id) AS movie_count, DENSE_RANK() OVER(ORDER BY count(m.id) DESC) AS prod_company_rank
	FROM ratings AS r
	INNER JOIN
    movie AS m
		ON r.movie_id = m.id
		WHERE m.production_company IS NOT NULL AND r.median_rating > 8
	GROUP BY m.production_company
	ORDER BY count(m.id) DESC)
    
    SELECT production_company, movie_count, prod_company_rank
		FROM hit_producer
			WHERE prod_company_rank = 1;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre, count(m.id) AS movie_count
	FROM genre AS g
    INNER JOIN movie AS m
    ON g.movie_id = m.id
		INNER JOIN ratings AS r
		ON m.id = r.movie_id
			WHERE country LIKE '%USA%'
				AND year = '2017' 
				AND EXTRACT(MONTH FROM date_published) = '3'
				AND total_votes > 1000
	GROUP BY g.genre;

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title, avg_rating, genre
	FROM ratings AS r
    INNER JOIN movie AS m
    ON r.movie_id = m.id
		INNER JOIN genre AS g
        ON m.id = g.movie_id
			WHERE title LIKE 'The%'
				AND avg_rating > 8
	GROUP BY g.genre;

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

WITH count_median_8 AS
(SELECT DISTINCT m.id, m.title, m.date_published
	FROM movie AS m
    INNER JOIN ratings AS r
		WHERE (m.date_published BETWEEN '2018-04-01' AND '2019-04-01')
        AND median_rating = '8'
        ORDER BY m.date_published ASC)

SELECT count(*) FROM count_median_8;		# Total 2794 movies released between 1 April 2018 and 1 April 2019 AND were given a median rating of 8

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT DISTINCT (SELECT SUM(total_votes)
		FROM ratings
		WHERE movie_id IN (SELECT id FROM movie WHERE languages LIKE '%German%')) AS German_votes,
		(SELECT SUM(total_votes)
		FROM ratings
		WHERE movie_id IN (SELECT id FROM movie WHERE languages LIKE '%Italian%')) AS Italian_votes,
        CASE WHEN 
        (SELECT SUM(total_votes)
		FROM ratings
		WHERE movie_id IN (SELECT id FROM movie WHERE languages LIKE '%German%')) >
        (SELECT SUM(total_votes)
		FROM ratings
		WHERE movie_id IN (SELECT id FROM movie WHERE languages LIKE '%Italian%'))
        THEN 'Yes, German votes are more than Italian votes'
        ELSE 'No, Italian votes are more than German Votes'
        END AS final_result
FROM ratings;

-/*From the results of the above programs, it is evident that total votes of German movies are more than Italian votes. 
So the answer the above question is 'YES'.*/

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT count(*)
FROM names
WHERE id IS NULL;			# No null values

SELECT count(*)
FROM names
WHERE name IS NULL;			# No null values

SELECT count(*)
FROM names
WHERE height IS NULL;			# 17335 null values

SELECT count(*)
FROM names
WHERE date_of_birth IS NULL;			# 13431 null values

SELECT count(*)
FROM names
WHERE known_for_movies IS NULL;			# 15226 null values


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT DISTINCT genre, count(m.id) AS movie_count
	FROM ratings AS r
	INNER JOIN movie AS m
	ON r.movie_id = m.id
		INNER JOIN genre AS g
        ON m.id = g.movie_id
	WHERE r.median_rating > 8
	GROUP BY g.genre
	ORDER BY count(m.id) DESC
    LIMIT 3;			# Drama: 424, Comedy: 186, Action: 162 have highest number of movies with average rating > 8
    
SELECT n.name AS director_name, COUNT(d_m.movie_id) AS movie_count
	FROM director_mapping AS d_m
    INNER JOIN genre AS g
    ON d_m.movie_id = g.movie_id
		INNER JOIN ratings AS r
        ON d_m.movie_id = r.movie_id
			INNER JOIN names AS n
            ON n.id = d_m.name_id
			WHERE g.genre IN ('Drama', 'Comedy', 'Action') AND r.avg_rating > 8
	GROUP BY d_m.name_id
    ORDER BY COUNT(d_m.movie_id) DESC
    LIMIT 3;
    
    /*James Mangold: 4, Joe Russo: 3, Anthony Russo: 3 --> Directors with these names 
		are top 3 directors among previously analyzed top 3 genres
        & James Mangold has highest (4) hits in top 3 genres hence the RSVP company should approach him for the project as director*/


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT n.name AS actor_name, COUNT(r_m.movie_id) AS movie_count
	FROM role_mapping AS r_m
	INNER JOIN ratings AS r
	ON r_m.movie_id = r.movie_id
		INNER JOIN names AS n
		ON n.id = r_m.name_id
			WHERE r.median_rating > 8
	GROUP BY r_m.name_id
    ORDER BY COUNT(r_m.movie_id) DESC
    LIMIT 2;						# Mammootty: 7 & Mohanlal: 3 are top 2 actors with median_rating > 8


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company, SUM(r.total_votes) AS vote_count, DENSE_RANK() OVER(ORDER BY SUM(r.total_votes) DESC) AS prod_comp_rank
FROM movie AS m
INNER JOIN ratings AS r
ON r.movie_id = m.id
GROUP BY m.production_company
ORDER BY SUM(r.total_votes) DESC
LIMIT 3;				# Marvel Studios is on top rank with 2656967 votes


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.name AS actor_name,
		m.country,
		r.total_votes,
        count(rm.movie_id) AS movie_count,
        ROUND(SUM(r.total_votes*r.avg_rating)/SUM(r.total_votes),2) AS actor_avg_rating,
        DENSE_RANK() OVER(ORDER BY ROUND(SUM(r.total_votes*r.avg_rating)/SUM(r.total_votes),2) DESC, r.total_votes DESC) AS actor_rank
	FROM movie AS m
		INNER JOIN role_mapping AS rm
		ON m.id = rm.movie_id
			INNER JOIN ratings AS r
			ON m.id = r.movie_id
				INNER JOIN names AS n
				ON n.id = rm.name_id
	WHERE country LIKE '%India%'
			AND category = 'actor'
	GROUP BY n.name HAVING count(rm.movie_id) >= 5
    LIMIT 1;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.name AS actress_name,
		r.total_votes,
		COUNT(rm.movie_id) AS movie_count,
        ROUND(SUM(r.total_votes*r.avg_rating)/SUM(r.total_votes),2) AS actress_avg_rating,
        DENSE_RANK() OVER(ORDER BY ROUND(SUM(r.total_votes*r.avg_rating)/SUM(r.total_votes),2) DESC, r.total_votes DESC) AS actress_rank
	FROM movie AS m
		INNER JOIN role_mapping AS rm
		ON m.id = rm.movie_id
			INNER JOIN ratings AS r
			ON m.id = r.movie_id
				INNER JOIN names AS n
				ON n.id = rm.name_id
	WHERE country LIKE '%India%'
	AND category = 'actress'
	AND languages LIKE '%Hindi%'
    GROUP BY n.name HAVING count(rm.movie_id) >= 3
    LIMIT 5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT m.id, m.title, g.genre, r.avg_rating,
	CASE
		WHEN r.avg_rating > 8 THEN 'Superhit movies'
        WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        ELSE 'Flop movies'
	END AS avg_rating_category
    FROM movie AS m
		INNER JOIN ratings AS r
        ON m.id = r.movie_id
			INNER JOIN genre AS g
            ON m.id = g.movie_id
	WHERE g.genre LIKE '%Thriller%'
    ORDER BY r.avg_rating DESC;


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH genre_duration_details AS
(SELECT m.id AS id, g.genre AS genre,
		m.duration AS duration
	FROM movie AS m
		INNER JOIN genre AS g
		ON m.id = g.movie_id
	ORDER BY g.genre ASC
)
SELECT genre,
		ROUND(SUM(duration)/COUNT(duration), 0) AS avg_duration,
		SUM(AVG(duration)) OVER w1 AS running_total_duration, 
        ROUND(AVG(AVG(duration)) OVER w1, 2) AS moving_avg_duration
	FROM genre_duration_details
    GROUP BY genre
WINDOW w1 AS (ORDER BY genre ROWS UNBOUNDED PRECEDING);

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
    
    WITH genre_selection AS(
WITH top_genre AS(
SELECT genre, COUNT(title) AS movie_count,
	RANK() OVER(ORDER BY COUNT(title) DESC) AS genre_rank
FROM movie AS m
	INNER JOIN ratings AS r ON r.movie_id=m.id
	INNER JOIN genre AS g ON g.movie_id=m.id
GROUP BY genre)
SELECT genre
FROM top_genre
WHERE genre_rank<4),
-- top genres have been identified. DRAMA, COMEDY, THRILLER are top 3 genres based on most number of movies criteria Now we will use these to find the top 5 movies as required.
top_five AS(
SELECT genre, year, title AS movie_name, worlwide_gross_income,
	RANK() OVER (PARTITION BY YEAR ORDER BY worlwide_gross_income DESC) AS movie_rank
FROM movie AS m 
	INNER JOIN genre AS g ON m.id= g.movie_id
WHERE genre IN (SELECT genre FROM genre_selection))
SELECT *
FROM top_five
WHERE movie_rank<=5;

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company,
	count(m.id) AS movie_count,
	DENSE_RANK() OVER (ORDER BY count(m.id) DESC) AS prod_comp_rank
    FROM movie AS m
    INNER JOIN ratings AS r
    ON m.id = r.movie_id
    WHERE median_rating >= 8 AND POSITION(',' IN m.languages)>0 AND m.production_company IS NOT NULL
    GROUP BY m.production_company
	ORDER BY count(m.id) DESC
    LIMIT 2;

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.name AS actress_name, r.total_votes,
	count(m.id) AS movie_count, r.avg_rating AS actress_avg_rating,
    ROW_NUMBER() OVER (ORDER BY count(m.id) DESC) AS actress_rank
	FROM movie AS m
    INNER JOIN ratings AS r
    ON m.id = r.movie_id
		INNER JOIN role_mapping AS rm
        ON m.id = rm.movie_id
			INNER JOIN names AS n
			ON n.id = rm.name_id
				INNER JOIN genre AS g
                ON m.id = g.movie_id
	WHERE rm.category = 'actress'
		AND r.avg_rating > 8
			AND g.genre = 'Drama'
	GROUP BY n.name
    ORDER BY count(m.id) DESC
    LIMIT 3;

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
    
WITH top_directors AS
(
SELECT name_id AS director_id, name AS director_name, dm.movie_id, duration,
	   avg_rating, total_votes, avg_rating * total_votes AS rating_count,
	   date_published,
       LEAD(date_published, 1) OVER (PARTITION BY name ORDER BY date_published, name) AS next_date_published
FROM director_mapping AS dm
INNER JOIN names AS n ON dm.name_id = n.id
INNER JOIN movie AS m ON dm.movie_id = m.id 
INNER JOIN ratings AS r ON m.id = r.movie_id
)

SELECT director_id, director_name,
        COUNT(movie_id) AS number_of_movies,
        CAST(SUM(rating_count)/SUM(total_votes)AS DECIMAL(4,2)) AS avg_rating,
        ROUND(SUM(DATEDIFF(Next_date_published, date_published))/(COUNT(movie_id)-1)) AS avg_inter_movie_days,
        SUM(total_votes) AS total_votes, MIN(avg_rating) AS min_rating, MAX(avg_Rating) AS max_rating,
        SUM(duration) AS total_duration
FROM top_directors
GROUP BY director_id
ORDER BY number_of_movies DESC
LIMIT 9;