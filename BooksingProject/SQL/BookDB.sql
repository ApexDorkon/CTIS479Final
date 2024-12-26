USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'BooksDB')
BEGIN
    ALTER DATABASE BooksDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BooksDB;
END
GO

-- Create the database
CREATE DATABASE BooksDB;
GO

-- Use the created database
USE BooksDB;
GO

-- Create Author table
CREATE TABLE Author (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    Surname NVARCHAR(255) NOT NULL
);
GO

-- Create Genre table
CREATE TABLE Genre (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL
);
GO

-- Create Role table
CREATE TABLE Role (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL
);
GO

-- Create User table
CREATE TABLE [User] (
    Id INT PRIMARY KEY IDENTITY(1,1),
    UserName NVARCHAR(255) NOT NULL,
    Password NVARCHAR(255) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    RoleId INT NOT NULL,
    CONSTRAINT FK_User_Role FOREIGN KEY (RoleId) REFERENCES Role(Id)
);
GO

-- Create Book table
CREATE TABLE Book (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    NumberOfPages SMALLINT NULL,
    PublishDate DATETIME NOT NULL,
    Price DECIMAL(18, 2) NOT NULL,
    IsTopSeller BIT NOT NULL DEFAULT 0,
    AuthorId INT NOT NULL,
    CONSTRAINT FK_Book_Author FOREIGN KEY (AuthorId) REFERENCES Author(Id)
);
GO

-- Create BookGenre table
CREATE TABLE BookGenre (
    Id INT PRIMARY KEY IDENTITY(1,1),
    BookId INT NOT NULL,
    GenreId INT NOT NULL,
    CONSTRAINT FK_BookGenre_Book FOREIGN KEY (BookId) REFERENCES Book(Id) ON DELETE CASCADE,
    CONSTRAINT FK_BookGenre_Genre FOREIGN KEY (GenreId) REFERENCES Genre(Id)
);
GO

-- Insert data into Author table
INSERT INTO Author (Name, Surname)
VALUES 
('Aldous', 'Huxley'),
('Suzanne', 'Collins'),
('George R.R.', 'Martin'),
('Margaret', 'Atwood'),
('Kurt', 'Vonnegut'),
('Ray', 'Bradbury'),
('Stephen', 'King'),
('Neil', 'Gaiman'),
('Octavia', 'Butler'),
('Ursula', 'Le Guin'),
('Jules', 'Verne'),
('H.G.', 'Wells'),
('Philip', 'Pullman'),
('Rick', 'Riordan'),
('Dan', 'Brown'),
('Chimamanda', 'Adichie'),
('Yann', 'Martel'),
('Kazuo', 'Ishiguro'),
('Colleen', 'Hoover'),
('Paulo', 'Coelho'),
('E.L.', 'James'),
('Nicholas', 'Sparks');
GO

-- Insert data into Genre table
INSERT INTO Genre (Name)
VALUES 
('Dystopian'),
('Adventure'),
('Thriller'),
('Romantic Comedy'),
('Psychological Fiction'),
('Fantasy'),
('Speculative Fiction'),
('Historical Drama'),
('Mythology'),
('Contemporary Fiction');
GO

-- Insert data into Book table
INSERT INTO Book (Name, NumberOfPages, PublishDate, Price, IsTopSeller, AuthorId)
VALUES 
('Brave New World', 268, '1932-08-01', 15.99, 1, 1),
('The Hunger Games', 374, '2008-09-14', 14.99, 1, 2),
('A Game of Thrones', 694, '1996-08-06', 22.99, 1, 3),
('The Handmaid\s Tale', 311, '1985-03-16', 13.99, 1, 4),
('SlaughterhouseFive', 275, '1969-03-31', 12.99, 1, 5),
('Fahrenheit451', 249, '1953-10-19', 10.99, 1, 6),
('The Shining', 447, '1977-01-28', 17.99, 1, 7),
('American Gods', 465, '2001-06-19', 18.99, 1, 8),
('Kindred', 264, '1979-06-01', 14.99, 1, 9),
('The Left Hand of Darkness', 336, '1969-03-01', 16.99, 1, 10),
('Twenty Thousand Leagues Under the Sea', 304, '1870-06-20', 14.99, 0, 11),
('The War of the Worlds', 192, '1898-01-01', 12.99, 0, 12),
('The Golden Compass', 399, '1995-07-09', 14.99, 1, 13),
('The Lightning Thief', 377, '2005-06-28', 12.99, 1, 14),
('The Da Vinc  Code', 489, '2003-04-01', 19.99, 1, 15),
('Half of a Yellow Sun', 433, '2006-09-12', 13.99, 1, 16),
('Life of Pi', 319, '2001-09-11', 15.99, 1, 17),
('Never Let Me Go', 288, '2005-03-05', 14.99, 1, 18),
('It Ends With Us', 384, '2016-08-02', 11.99, 1, 19),
('TheAlchemist', 208, '1988-04-01', 10.99, 1, 20),
('Fifty Shade  of Grey', 514, '2011-06-20', 16.99, 1, 21),
('The Noteboo', 214, '1996-10-01', 9.99, 1, 22);
GO
-- Insert data into BookGenre tabl
INSERT INTO BookGenre (BookId, GenreId)
VALUES 
(1, 1),  -- Brave New World, Dystopian
(2, 6),  -- The Hunger Games, Fantasy
(3, 6),  -- A Game of Thrones, Fantasy
(4, 5),  -- The Handmaid's Tale, Psychological Fiction
(5, 1),  -- Slaughterhouse-Five, Dystopian
(6, 1),  -- Fahrenheit 451, Dystopian
(7, 5),  -- The Shining, Psychological Fiction
(8, 6),  -- American Gods, Fantasy
(9, 7),  -- Kindred, Speculative Fiction
(10, 7), -- The Left Hand of Darkness, Speculative Fiction
(11, 2), -- Twenty Thousand Leagues Under the Sea, Adventure
(12, 7), -- The War of the Worlds, Speculative Fiction
(13, 6), -- The Golden Compass, Fantasy
(14, 9), -- The Lightning Thief, Mythology
(15, 3), -- The Da Vinci Code, Thriller
(16, 8), -- Half of a Yellow Sun, Historical Drama
(17, 7), -- Life of Pi, Speculative Fiction
(18, 4), -- Never Let Me Go, Romantic Comedy
(19, 10), -- It Ends With Us, Contemporary Fiction
(20, 10), -- The Alchemist, Contemporary Fiction
(21, 4), -- Fifty Shades of Grey, Romantic Comedy
(22, 4); -- The Notebook, Romantic Comedy
GO

SET IDENTITY_INSERT [dbo].[Role] ON
INSERT INTO [dbo].[Role] ([Id], [Name]) VALUES (1, N'Admin')
INSERT INTO [dbo].[Role] ([Id], [Name]) VALUES (2, N'User')
SET IDENTITY_INSERT [dbo].[Role] OFF

SET IDENTITY_INSERT [dbo].[User] ON
INSERT INTO [dbo].[User] ([Id], [UserName], [Password], [IsActive], [RoleId]) VALUES (1, N'admin', N'admin', 1, 1)
INSERT INTO [dbo].[User] ([Id], [UserName], [Password], [IsActive], [RoleId]) VALUES (2, N'test', N'password', 1, 2)
SET IDENTITY_INSERT [dbo].[User] OFF