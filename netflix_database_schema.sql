-- Create a table named 'netflix' with appropriate columns to store information about Netflix content.
CREATE TABLE netflix
	(
		show_id VARCHAR(6),        -- Unique identifier for each show or movie.
		type VARCHAR(10),          -- Type of content: either 'Movie' or 'TV Show'.
		title VARCHAR(150),        -- Title of the movie or TV show.
		director VARCHAR(208),     -- Name of the director of the content (can be NULL if not applicable).
		castS VARCHAR(1000),       -- List of cast members in the content (can include multiple names separated by commas).
		country VARCHAR(150),      -- Country where the content was produced.
		date_added VARCHAR(50),    -- Date when the content was added to Netflix's library.
		release_year INT,          -- Year when the content was originally released.
		rating VARCHAR(10),        -- Age rating or maturity level of the content (e.g., PG, R, TV-MA).
		duration VARCHAR(15),      -- Duration of the movie or number of seasons for TV shows.
		listed_in VARCHAR(100),    -- Categories or genres the content belongs to (e.g., Comedy, Drama).
		description VARCHAR(250)   -- A brief description or synopsis of the content.
	);

