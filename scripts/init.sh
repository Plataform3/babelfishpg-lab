#!/bin/bash

tdscli() {
  docker compose exec -T bbf tsql -H localhost -p 1433 -P password -U bbf <<EOF
$1
EOF
}

initsql=$(cat <<'EOF'
IF EXISTS (SELECT 1
            FROM  sysobjects
           WHERE  id = object_id('Users')
            AND   type = 'U')
BEGIN
    DROP TABLE ScoreBoard;
    DROP TABLE Users;
    DROP FUNCTION generate_username;
    DROP FUNCTION generate_date;
    DROP PROCEDURE generate_random_users;
    DROP PROCEDURE generate_random_score;
END;
GO

CREATE FUNCTION generate_username ()
RETURNS varchar(40)
AS
BEGIN
    DECLARE @genuser varchar(40);
    DECLARE @length int;
    SET @length = CAST(RAND() * 38 AS INT);
    SELECT @genuser = '';
    WHILE @length > 0
    BEGIN
        SELECT @genuser = @genuser + CHAR(48 + ABS(CHECKSUM(NEWID())) % 80);
        SET @length = @length - 1;
    END;
    IF EXISTS (SELECT username FROM Users WHERE username = @genuser)
        SELECT @genuser = generate_username();
    RETURN @genuser;
END;
GO

CREATE PROCEDURE generate_random_users
    @scale int
AS
BEGIN
    WHILE (@scale <> 0)
    BEGIN
        INSERT [Users] (username, balance)
        SELECT generate_username(), CAST(RAND()*100000 AS MONEY);
        SET @scale = @scale - 1;
    END;
END;
GO

CREATE FUNCTION generate_date ()
RETURNS datetime
AS
BEGIN
    DECLARE @gentime DATETIME;
    SET @gentime = GETDATE() + (365 * 2 * RAND() - 365);
    RETURN @gentime;
END;
GO

CREATE PROCEDURE generate_random_score
    @scale int
AS
BEGIN
    DECLARE @userpick nvarchar(40);
    DECLARE @randtiny tinyint;
    DECLARE @query varchar(4000);
    
    -- Use CTE for inserting rows with a TOP clause
    SET @query = 'WITH randus AS (
        SELECT TOP ' + CAST(@scale AS varchar) + ' username, CAST(ROUND(RAND()*100) AS tinyint)
        FROM Users ORDER BY NEWID()
    ) INSERT INTO [ScoreBoard] (username, points)
    SELECT * FROM randus';
    
    EXECUTE(@query);
END;
GO

CREATE TABLE Users (
    Id          int IDENTITY,
    username    nvarchar(40)    NOT NULL,
    created     datetime        NOT NULL DEFAULT generate_date(),
    balance     MONEY,
    CONSTRAINT PK_USERS PRIMARY KEY (Id),
    CONSTRAINT UQ_USERS UNIQUE (username)
);
GO

CREATE TABLE ScoreBoard (
    Id          int IDENTITY PRIMARY KEY,
    username    nvarchar(40),
    points      tinyint,
    FOREIGN KEY (username) REFERENCES Users (username)
        ON DELETE CASCADE ON UPDATE CASCADE
);
GO

EXEC generate_random_users 1000;
GO

EXEC generate_random_score 50;
GO

SELECT COUNT(*) FROM Users;
GO

SELECT COUNT(*) FROM ScoreBoard;
GO

SELECT CAST(serverproperty('babelfishversion') AS VARCHAR);
GO
EOF
)

tdscli "$initsql"
