USE lab_mysql_select;

-- CHALLENGE 1 : Who Have Published What At Where?
SELECT * FROM authors;

SELECT 
    au.au_id AS 'AUTHOR ID',
    au.au_lname AS 'LAST NAME',
    au.au_fname AS 'FIRST NAME',
    t.title AS 'TITLE',
    pub.pub_name AS 'PUBLISHER'
FROM 
    authors au
JOIN 
    titleauthor ta ON au.au_id = ta.au_id
JOIN 
    titles t ON ta.title_id = t.title_id
JOIN 
    publishers pub ON t.pub_id = pub.pub_id;
    
SELECT COUNT(*) AS 'TOTAL RECORDS IN TITLEAUTHOR' FROM titleauthor;

-- CHALLENGE 2 : Who Have Published How Many At Where?

SELECT 
    au.au_id AS 'AUTHOR ID',
    au.au_lname AS 'LAST NAME',
    au.au_fname AS 'FIRST NAME',
    pub.pub_name AS 'PUBLISHER',
    COUNT(ta.title_id) AS 'TITLE COUNT'
FROM 
    authors au
JOIN 
    titleauthor ta ON au.au_id = ta.au_id
JOIN 
    titles t ON ta.title_id = t.title_id
JOIN 
    publishers pub ON t.pub_id = pub.pub_id
GROUP BY 
    au.au_id, pub.pub_name;
    
-- CHALLENGE 3 : Best Selling Authors
SELECT 
    au.au_id AS 'AUTHOR ID',
    au.au_lname AS 'LAST NAME',
    au.au_fname AS 'FIRST NAME',
    SUM(title_counts) AS 'TOTAL'
FROM 
    authors au
JOIN (
    SELECT 
        ta.au_id,
        COUNT(ta.title_id) AS title_counts
    FROM 
        titleauthor ta
    GROUP BY 
        ta.au_id
) AS title_counts_subquery ON au.au_id = title_counts_subquery.au_id
GROUP BY 
    au.au_id, au.au_lname, au.au_fname
ORDER BY 
    TOTAL DESC
LIMIT 3;

-- CHALLENGE 4 : Best Selling Authors Ranking
SELECT 
    au.au_id AS 'AUTHOR ID',
    au.au_lname AS 'LAST NAME',
    au.au_fname AS 'FIRST NAME',
    COALESCE(SUM(title_counts), 0) AS 'TOTAL'
FROM 
    authors au
LEFT JOIN (
    SELECT 
        ta.au_id,
        COUNT(ta.title_id) AS title_counts
    FROM 
        titleauthor ta
    GROUP BY 
        ta.au_id
) AS title_counts_subquery ON au.au_id = title_counts_subquery.au_id
GROUP BY 
    au.au_id, au.au_lname, au.au_fname
ORDER BY 
    TOTAL DESC;