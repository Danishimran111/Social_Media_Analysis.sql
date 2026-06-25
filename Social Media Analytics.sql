CREATE DATABASE Social_Media_Analytics;
USE Social_Media_Analytics;

CREATE TABLE users(
 user_id INT PRIMARY KEY,
 username VARCHAR(50),
 join_date DATE,
 bio TEXT
 );
 
CREATE TABLE posts (
 post_id INT PRIMARY KEY,
 user_id INT,
 content VARCHAR(100),
 post_date DATE,
 FOREIGN KEY (user_id) REFERENCES users(user_id)
 );
 
 CREATE TABLE comments (
  comment_id INT PRIMARY KEY,
  post_id INT,
  user_id INT,
  comment_text VARCHAR(100),
  comment_date DATE,
  FOREIGN KEY (post_id) REFERENCES posts(post_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
  );
  
  CREATE TABLE likes (
   like_id INT PRIMARY KEY,
   post_id INT,
   user_id INT,
   like_date DATE,
   FOREIGN KEY (post_id) REFERENCES posts(post_id),
   FOREIGN KEY (user_id) REFERENCES users(user_id)
   );
   
   CREATE TABLE follows (
    follower_id INT,
    followee_id INT,
    follow_date DATE,
    PRIMARY KEY (follower_id, followee_id),
    FOREIGN KEY (follower_id) REFERENCES users(user_id),
    FOREIGN KEY (followee_id) REFERENCES users(user_id)
    );
    
    
    
-- INSERT INTO users
INSERT INTO users (user_id, username, join_date, bio) VALUES
(1, 'danish', '2024-01-10', 'Love coding'),
(2, 'ayesha', '2024-01-15', 'Travel lover'),
(3, 'rahul', '2024-02-01', 'Fitness enthusiast'),
(4, 'sara', '2024-02-05', 'Photographer'),
(5, 'ali', '2024-02-10', 'Tech geek'),
(6, 'john', '2024-02-15', 'Music lover'),
(7, 'emma', '2024-02-20', 'Food blogger'),
(8, 'mike', '2024-02-25', 'Gamer'),
(9, 'zoya', '2024-03-01', 'Book reader'),
(10, 'arjun', '2024-03-05', 'Nature lover');


-- INSERT INTO posts
INSERT INTO posts (post_id, user_id, content, post_date) VALUES
(101, 1, 'Learning SQL', '2024-04-01'),
(102, 1, 'Database practice', '2024-04-02'),
(103, 2, 'Travel diaries', '2024-04-03'),
(104, 3, 'Morning workout', '2024-04-04'),
(105, 3, 'Gym motivation', '2024-04-05'),
(106, 4, 'Nature photography', '2024-04-06'),
(107, 5, 'Latest tech news', '2024-04-07'),
(108, 7, 'Best pizza ever', '2024-04-08'),
(109, 8, 'Gaming stream tonight', '2024-04-09'),
(110, 10, 'Hiking adventure', '2024-04-10');




-- INSERT INTO comments
INSERT INTO comments (comment_id, post_id, user_id, comment_text, comment_date) VALUES
(201, 101, 2, 'Great job!', '2024-04-20'),
(202, 102, 3, 'Amazing place', '2024-04-20'),
(203, 103, 4, 'Keep it up!', '2024-04-21'),
(204, 104, 5, 'Nice photo', '2024-04-21'),
(205, 105, 6, 'Interesting info', '2024-04-22'),
(206, 106, 7, 'Love this song', '2024-04-22'),
(207, 107, 8, 'Looks tasty', '2024-04-23'),
(208, 108, 9, 'Which game?', '2024-04-23'),
(209, 109, 10, 'Nice recommendation', '2024-04-24'),
(210, 110, 1, 'Beautiful view', '2024-04-24');



-- INSERT INTO likes
INSERT INTO likes (like_id, post_id, user_id, like_date) VALUES
(301, 101, 3, '2024-04-25'),
(302, 102, 4, '2024-04-25'),
(303, 103, 5, '2024-04-26'),
(304, 104, 6, '2024-04-26'),
(305, 105, 7, '2024-04-27'),
(306, 106, 8, '2024-04-27'),
(307, 107, 9, '2024-04-28'),
(308, 108, 10, '2024-04-28'),
(309, 109, 1, '2024-04-29'),
(310, 110, 2, '2024-04-29');


-- INSERT INTO follows
INSERT INTO follows (follower_id, followee_id, follow_date) VALUES
(1, 2, '2024-05-01'),
(2, 3, '2024-05-01'),
(3, 4, '2024-05-02'),
(4, 5, '2024-05-02'),
(5, 6, '2024-05-03'),
(6, 7, '2024-05-03'),
(7, 8, '2024-05-04'),
(8, 9, '2024-05-04'),
(9, 10, '2024-05-05'),
(10, 1, '2024-05-05');



-- 1.Find the total number of posts made by each user.
SELECT u.user_id, u.username, COUNT(p.post_id) AS total_posts
FROM users AS u
LEFT JOIN posts AS p
ON u.user_id = p.user_id
GROUP BY user_id, u.username;



-- 2.Calculate the average number of likes per post.
SELECT AVG(like_count) AS avg_likes_per_posts
FROM  
	(
	SELECT post_id, count(*) AS like_count
	FROM likes
	GROUP BY post_id
    ) AS post_likes;
    

-- 3. Identify the most active user (posts + comments + likes combined)
SELECT 	u.user_id, u.username,
		COUNT(DISTINCT p.post_id) +
        COUNT(DISTINCT c.comment_id) + 
        COUNT(DISTINCT l.like_id) AS active_score
FROM users AS u
LEFT JOIN posts AS p
ON u.user_id = p.post_id
LEFT JOIN comments AS c
ON u.user_id = c.user_id
LEFT JOIN likes AS l
ON u.user_id = l.user_id
GROUP BY u.user_id, u.username
ORDER BY active_score DESC
LIMIT 1;


-- 4. List all comments on a specific user's posts
-- Example: user_id = 1
SELECT c.comment_id, c.comment_text, c.comment_date,
		u.username AS commenter, p.post_id
FROM posts AS p
JOIN comments AS c
ON p.post_id = c.post_id
JOIN users AS u
ON c.user_id = u.user_id
WHERE p.user_id = 1;


-- 5. Find users who have not made any posts
SELECT u.user_id, u.username
FROM users AS u
LEFT JOIN posts AS p
ON u.user_id = p.user_id
WHERE p.post_id IS NULL;



-- 6. Find the post with the highest number of comments
SELECT p.post_id, p.content, COUNT(c.comment_id) AS total_comments
FROM posts p
LEFT JOIN comments c ON p.post_id = c.post_id
GROUP BY p.post_id, p.content
ORDER BY total_comments DESC
LIMIT 1;



-- 7. Calculate the number of new followers gained per user per month
SELECT followee_id AS user_id,
       DATE_FORMAT(follow_date, '%Y-%m') AS month,
       COUNT(follower_id) AS new_followers
FROM follows
GROUP BY followee_id, DATE_FORMAT(follow_date, '%Y-%m')
ORDER BY month;



-- 8. Identify users who are followed by more than 100 people
SELECT u.user_id, u.username, COUNT(f.follower_id) AS followers_count
FROM users u
JOIN follows f ON u.user_id = f.followee_id
GROUP BY u.user_id, u.username
HAVING COUNT(f.follower_id) > 100;



-- 9. List the top 3 posts with the highest engagement (likes + comments)
SELECT p.post_id,
       p.content,
       COUNT(DISTINCT l.like_id) + COUNT(DISTINCT c.comment_id) AS engagement
FROM posts p
LEFT JOIN likes l ON p.post_id = l.post_id
LEFT JOIN comments c ON p.post_id = c.post_id
GROUP BY p.post_id, p.content
ORDER BY engagement DESC
LIMIT 3;


-- 10. Find mutual follows (users who follow each other)
SELECT f1.follower_id AS user1,
       f1.followee_id AS user2
FROM follows f1
JOIN follows f2
ON f1.follower_id = f2.followee_id
AND f1.followee_id = f2.follower_id;