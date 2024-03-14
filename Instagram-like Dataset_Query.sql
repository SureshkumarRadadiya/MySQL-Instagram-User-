
select * from users;        -- Contains user information such as usernames and creation timestamps.
select * from photos;       -- Stores details about posted photos, including image URLs and user IDs.
select * from comments;     -- Stores comments made on photos, along with associated user and photo IDs.
select * from likes;        -- Tracks user likes on photos.
select * from photo_tags;   -- Links photos with associated tags
select * from tags;         -- Manages unique tag names for photos.
select * from follows;      -- Records user follow relationships.


# Task_1 -- How many times does the average user post?

-- select * from users;  -- Contains user information such as usernames and creation timestamps.
-- select * from photos; -- Stores details about posted photos, including image URLs and user IDs.
-- SELECT (SELECT COUNT(*) FROM photos) / (SELECT COUNT(*) FROM users) AS AVG;
SELECT AVG(number_count) AS average_user_post
FROM (
    SELECT user_id, COUNT(*) AS number_count
    FROM photos
    GROUP BY user_id
) AS user_post_counts;


# Task_2 -- Find the top 5 most used hashtags.

-- select * from photo_tags; -- Links photos with associated tags
-- select * from tags;       -- Manages unique tag names for photos.
SELECT t.tag_name, COUNT(*) AS total_count
FROM tags t
INNER JOIN photo_tags pt ON t.id = pt.tag_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


# Task_3 -- Find users who have liked every single photo on the site.

-- select * from users;  -- Contains user information such as usernames and creation timestamps.
-- select * from photos; -- Stores details about posted photos, including image URLs and user IDs.
-- select * from likes;  -- Tracks user likes on photos.
SELECT 
	users.id, 
    users.username 
FROM users
INNER JOIN likes ON users.id = likes.user_id
INNER JOIN photos ON likes.photo_id = photos.id 
GROUP BY users.id,users.username 
HAVING COUNT(DISTINCT photos.id) = (SELECT COUNT(*) FROM photos);
				-- OR
-- SELECT DISTINCT l.user_id
-- FROM likes l
-- WHERE NOT EXISTS (
--     SELECT p.id
--     FROM photos p
--     WHERE NOT EXISTS (
--         SELECT 1
--         FROM likes l2
--         WHERE l2.user_id = l.user_id AND l2.photo_id = p.id
--     )
-- );


# Task_4--Retrieve a list of users along with their usernames and the rank of their account creation, 
		-- ordered by the creation date in ascending order. 

-- select * from users; -- Contains user information such as usernames and creation timestamps.
SELECT
    id,
    username,
    RANK() OVER (ORDER BY created_at ASC) AS account_creation_rank
FROM users;


# Task_5-- List the comments made on photos with their comment texts, photo URLs, and usernames 
        -- of users who posted the comments. Include the comment count for each photo 

-- select * from users;    -- Contains user information such as usernames and creation timestamps.
-- select * from photos;   -- Stores details about posted photos, including image URLs and user IDs.
-- select * from comments; -- Stores comments made on photos, along with associated user and photo IDs.
SELECT
    c.comment_text,
    p.image_url,
    u.username,
    COUNT(c.id) AS comment_count
FROM comments c
INNER JOIN photos p ON c.photo_id = p.id
INNER JOIN users u ON c.user_id = u.id
GROUP BY c.comment_text, p.image_url, u.username;


# Task_6 -- For each tag, show the tag name and the number of photos associated with that tag. 
		  -- Rank the tags by the number of photos in descending order. */

-- select * from photo_tags; -- Links photos with associated tags
-- select * from tags; -- Manages unique tag names for photos.
SELECT
    t.tag_name,
    COUNT(pt.photo_id) AS number_photos
FROM tags t
JOIN photo_tags pt ON t.id = pt.tag_id
GROUP BY t.tag_name
ORDER BY number_photos DESC;


# Task_7 -- List the usernames of users who have posted photos along with the count of photos 
		  -- they have posted. Rank them by the number of photos in descending order. */

-- select * from users;  -- Contains user information such as usernames and creation timestamps.
-- select * from photos; -- Stores details about posted photos, including image URLs and user IDs.
SELECT
    u.username,
    COUNT(p.id) AS count_photos
FROM users u
LEFT JOIN photos p ON u.id = p.user_id
GROUP BY u.username
ORDER BY count_photos DESC;


# Task_8 -- Display the username of each user along with the creation date of 
		  -- their first posted photo and the creation date of their next posted photo. */
-- select * from users;  -- Contains user information such as usernames and creation timestamps.
-- select * from photos; -- Stores details about posted photos, including image URLs and user IDs.
SELECT
    u.username,
    MIN(p1.created_at) AS FirstPosted,
    MIN(p2.created_at) AS NextPosted
FROM
    users u
LEFT JOIN
    photos p1 ON u.id = p1.user_id
LEFT JOIN
    photos p2 ON u.id = p2.user_id AND p2.created_at > p1.created_at
GROUP BY
    u.id, u.username;


# Task_9 -- For each comment, show the comment text, the username of the commenter, 
	      -- and the comment text of the previous comment made on the same photo.*/

-- select * from comments;  -- Stores comments made on photos, along with associated user and photo IDs.
-- select * from users;     -- Contains user information such as usernames and creation timestamps.
SELECT
    c.comment_text,
    u.username AS username_commenter,
    LAG(c.comment_text) OVER (PARTITION BY c.photo_id ORDER BY c.created_at) AS pre_comment_text
FROM comments c
INNER JOIN users u ON c.user_id = u.id;


# Task_10  -- Show the username of each user along with the number of photos they have posted and 
           -- the number of photos posted by the user before them and after them, based on the creation date.

-- select * from users;  -- Contains user information such as usernames and creation timestamps.
-- select * from photos; -- Stores details about posted photos, including image URLs and user IDs.
WITH NumberPhotosPosted AS (
    SELECT
        u.id,
        u.username,
        COUNT(p.id) AS number_photos,
        ROW_NUMBER() OVER (ORDER BY MIN(p.created_at)) AS row_no
    FROM users u
    LEFT JOIN photos p ON u.id = p.user_id
    GROUP BY u.id, u.username
)
-- SELECT * FROM NumberPhotosPosted;
SELECT
    np.username,
    np.number_photos,
    COALESCE(LAG(np.number_photos) OVER (ORDER BY np.row_no), 0) AS before_photos,
    COALESCE(LEAD(np.number_photos) OVER (ORDER BY np.row_no), 0) AS after_photos
FROM NumberPhotosPosted np;

