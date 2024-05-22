CREATE DATABASE bookstore;
USE bookstore;

CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    price DECIMAL(5,2) NOT NULL
);

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

-- Table to store cart items for each user
CREATE TABLE cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (book_id) REFERENCES books(id)
);

-- Table to store order details
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Table to store order items
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (book_id) REFERENCES books(id)
);
SHOW TABLES;

DESCRIBE users;

SELECT * FROM users;

SELECT * FROM books;
ALTER TABLE books ADD COLUMN image VARCHAR(255) DEFAULT 'default.jpg';
ALTER TABLE books ADD COLUMN categories VARCHAR(255) DEFAULT 'General';
ALTER TABLE books ADD COLUMN original_price DECIMAL(5,2) DEFAULT 0.00;
ALTER TABLE books ADD COLUMN description TEXT;



INSERT INTO books (title, author, price, image, categories, original_price) VALUES
('The Sad Ghost Club Volume 1', 'Lize Meddings', 29.90, 'book_1.jpg', 'Children Book, Horror, Comics', 65.94),
('The Stranger In The Lifeboat', 'Mitch Albom', 39.90, 'book_2.jpg', 'Fiction, Hot Selling, Romance', 89.94),
('How To Win Friend And Influence People', 'Dale Carnegie', 24.90, 'book_3.jpg', 'Non-Fiction, Development, Reference', 77.94),
('Diary Of A Wimpy Kid #4: Dog Days', 'Jeff Kinney', 22.50, 'book_4.jpg', 'Children Book, Hot Selling, Comedy', 72.60),
('Life Of Pi', 'Yann Martel', 24.50, 'book_5.jpg', 'Fiction, Hot Selling, Adventure', 59.94),
('The Return', 'Nicholas Sparks', 29.30, 'book_6.jpg', 'Fiction, Hot Selling, Romance', 126.60),
('Bitcoin Billionaires', 'Ben Mezrich', 19.90, 'book_7.jpg', 'Non-Fiction, Business, Economy', 80.70),
('A Beautiful Day In The Neighborhood', 'Fred Rogers', 39.90, 'book_8.jpg', 'Non-Fiction, Self-Help, Personal Development', 77.94),
('When The Stars Come Out', 'Nicola Edwards', 40.10, 'book_9.jpg', 'Children Book, Picture Book, Magical', 98.60),
('The End Of The Ocean: A Novel', 'Maja Lunde', 35.50, 'book_10.jpg', 'Fiction, Adventure, Romance', 125.70);

-- UPDATE DESCRIPTION
-- 1
UPDATE books
SET description = 'Ever felt anxious or alone? Like you do not belong anywhere? Like you are almost... invisible? Find your kindred spirits at The Sad Ghost Club.
(You are not alone. Shhh. Pass it on.) This is the story of one of those days - a day so bad you can barely get out of bed, when it is a struggle to leave the house, 
and when you do, you wish you had not. But even the worst of days can surprise you. When one sad ghost, alone at a crowded party, spies another sad ghost across the room, 
they decide to leave together. What happens next changes everything. Because that night they start the The Sad Ghost Club - a secret society for the anxious and alone, 
a club for people who think they do not belong. Stunningly illustrated, this is Volume 1 in a new graphic novel series, for fans of Heartstopper and Jennifer Niven, and 
for anyone who has ever felt invisible.
Join the community of half a million ghosties on Instagram, @theofficialsadghostclub'
WHERE title = 'The Sad Ghost Club Volume 1';

-- 2
UPDATE books
SET description = 'The stunning new novel from the bestselling author of global phenomenon Tuesdays with Morrie. Adrift in a raft after a terrible shipwreck, ten strangers 
struggle to survive while they wait for rescue. After three days, short on water, food and hope, they spot a man floating in the waves. They pull him on board - and the 
survivor claims he can save them. But should they put their trust in him? Will any of them see home again? And why did the ship really sink? The Stranger in the Lifeboat 
is not only a deeply moving novel about the power of love and hope in the face of danger, but also a mystery that will keep you guessing to the very end.'
WHERE title = 'The Stranger In The Lifeboat';

-- 3
UPDATE books
SET description = 'Dale Carnegie timeless bestseller How to Win Friends and Influence People is a classic that has improved and transformed the professional and personal and 
lives of millions.One of the best-known motivational guides in history, Dale Carnegie’s groundbreaking book has sold tens of millions of copies, been translated into almost 
every known language, and has helped countless people succeed. Originally published during the depths of the Great Depression—and equally valuable during booming economies 
or hard times—Carnegie rock-solid, time-tested advice has carried countless people up the ladder of success in their professional and personal lives.'
WHERE title = 'How To Win Friend And Influence People';

-- 4
UPDATE books
SET description = 'It is summer vacation, the weather is great, and all the kids are having fun outside. So where is Greg Heffley? Inside his house, playing video games with 
the shades drawn. Greg, a self-confessed indoor person, is living out his ultimate summer fantasy: no responsibilities and no rules. But Gregs mom has a different vision for 
an ideal summer . . . one packed with outdoor activities and family togetherness. Whose vision will win out? Or will a new addition to the Heffley family change everything?'
WHERE title = 'Diary Of A Wimpy Kid #4: Dog Days';
-- 5
UPDATE books
SET description = 'One boy, one boat, one tiger . . .
After the tragic sinking of a cargo ship, a solitary lifeboat remains bobbing on the wild, blue Pacific. The only survivors from the wreck are a sixteen-year-old boy named Pi, 
a hyena, a zebra (with a broken leg), a female orang-utan - and a 450-pound Royal Bengal tiger. The scene is set for one of the most extraordinary and best-loved works of fiction 
in recent years.'
WHERE title = 'Life Of Pi';
-- 6
UPDATE books
SET description = 'Trevor Benson never intended to move back to New Bern, North Carolina. But when a mortar blast outside the hospital where he worked sent him home from Afghanistan 
with devastating injuries, the dilapidated cabin he would inherited from his grandfather seemed as good a place to regroup as any. Further complicating his stay in New Bern is the 
presence of a sullen teenage girl, Callie, who lives in the trailer park down the road. Trevor hopes Callie can shed light on the mysterious circumstances of his grandfathers death, 
but she offers few clues -- until a crisis triggers a race to uncover the true nature of Callies past, one more intertwined with the elderly mans passing than Trevor could ever have imagined.
In his quest to unravel Natalie and Callies secrets, Trevor will learn the true meaning of love and forgiveness . . . and that in life, to move forward, we must often return to the place where it all began.'
WHERE title = 'The Return';
-- 7
UPDATE books
SET description = 'Ben Mezrichs 2009 bestseller The Accidental Billionaires is the definitive account of Facebooks founding and the basis for the Academy Award-winning film The Social Network. 
Two of the storys iconic characters are Harvard students Tyler and Cameron Winklevoss: identical twins, Olympic rowers, and foils to Mark Zuckerberg. Bitcoin Billionaires is the story of the 
brothers redemption and revenge in the wake of their epic legal battle with Facebook. Planning to start careers as venture capitalists, the brothers quickly discover that no one will take their 
money after their fight with Zuckerberg. While nursing their wounds in Ibiza, they accidentally run into an eccentric character who tells them about a brand-new idea: cryptocurrency. Immersing 
themselves in what is then an obscure and sometimes sinister world, they begin to realize "crypto" is, in their own words, "either the next big thing or total bulls--t." There is nothing left to do but make a bet.
From the Silk Road to the halls of the Securities and Exchange Commission, Bitcoin Billionaires will take us on a wild and surprising ride while illuminating a tantalizing economic future. On November 26, 2017, 
the Winklevoss brothers became the first bitcoin billionaires. Here is the story of how they got there--as only Ben Mezrich could tell it.'
WHERE title = 'Bitcoin Billionaires';
-- 8
UPDATE books
SET description = 'The inspiring profile brought to life in the major motion picture starring Tom Hanks, plus a collection of warm advice and encouragement from Americas favorite neighbor. 
Tom Junods Esquire profile of Fred Rogers, “Can You Say... Hero?,” has been hailed as a classic of magazine writing. Now, his moving story of meeting and observing the beloved host of Mister 
Rogers’ Neighborhood is the inspiration for A Beautiful Day in the Neighborhood, directed by Marielle Heller and written by Micah Fitzerman-Blue & Noah Harpster. Here, Junods unforgettable 
piece appears for the first time in book form alongside an inspiring collection of advice and encouragement from Mister Rogers himself. Covering topics like relationships, childhood, communication, 
parenthood, and more, Rogers signature sayings and wise thoughts are included here. Pairing the definitive portrait of a national icon with his own instructions for living your best, kindest life, 
this book is a timeless treasure for Mister Rogers fans.'
WHERE title = 'A Beautiful Day In The Neighborhood';
-- 9
UPDATE books
SET description = 'As we delve into the magical realm that is our universe at night we discover what makes it so extraordinary...from moonbows to shooting stars and from the polar night to the 
northern lights. Experience how different habitats from the city to the ocean, come alive when the sun sets. Meet animals that make their own elaborate beds and others that sleep while swimming 
or flying. Explore the history of human sleep across the globe and dive into a world of dreams...'
WHERE title = 'When The Stars Come Out';
-- 10
UPDATE books
SET description = 'From the author of the number-one international bestseller The History of Bees, a captivating story of the power of nature and the human spirit that explores the threat of a 
devastating worldwide drought, witnessed through the lives of a father, a daughter, and a woman who will risk her life to save the future. In 2019, seventy-year-old Signe sets sail alone on a 
hazardous voyage across the ocean in a sailboat. On board, a cargo that can change lives. Signe is haunted by memories of the love of her life, whom she’ll meet again soon. In 2041, David and 
his young daughter, Lou, flee from a drought-stricken Southern Europe that has been ravaged by thirst and war. Separated from the rest of their family and desperate to find them, they discover 
an ancient sailboat in a dried-out garden, miles away from the nearest shore. Signe’s sailboat. As David and Lou discover Signe’s personal effects, her long ago journey becomes inexorably linked 
to their own. An evocative tale of the search for love and connection, The End of the Ocean is a profoundly moving father daughter story of survival and a clarion call for climate action.'
WHERE title = 'The End Of The Ocean: A Novel';

SELECT * FROM books;
SELECT * FROM cart;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM users;


/* DATA MASKING*/
SELECT 
	username,
    CONCAT(
        REGEXP_REPLACE(SUBSTRING_INDEX(email, '@', 1), '[0-9]', '*'),
        '@',
        SUBSTRING_INDEX(email, '@', -1)
    ) AS masked_email
FROM users;

