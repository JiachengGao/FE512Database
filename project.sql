## final project
DROP DATABASE IF EXISTS SteamGame;
CREATE DATABASE IF NOT EXISTS SteamGame;
USE SteamGame;

## Create table general
DROP TABLE IF EXISTS general;
CREATE TABLE general(
QueryID INT NOT NULL,
QueryName VARCHAR(300),
ReleaseDate DECIMAL,
ReleaseYear INT,
RequiredAge INT,
DLC INT,
Metacritic INT,
Movie INT,
Package INT,
Recommendation INT,
Screenshot INT,
SteamOwners INT,
SteamOwnersVariance INT,
PlayersEstimate INT NOT NULL,
PlayersEstimateVariance INT NOT NULL,
Achievement INT NOT NULL,
AchievementHighlighted INT NOT NULL,
PriceInitial Float NOT NULL,
PriceFinal float NOT NULL,
SupportedLanguage VARCHAR(500) NOT NULL,
PRIMARY KEY(QueryID)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/general.csv'
INTO TABLE general
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(QueryID,@QueryName,@ReleaseDate, @ReleaseYear,RequiredAge,DLC,Metacritic,Movie,Package,Recommendation,Screenshot,SteamOwners,SteamOwnersVariance,
PlayersEstimate,PlayersEstimateVariance,Achievement,AchievementHighlighted,PriceInitial,PriceFinal,SupportedLanguage)
set
QueryName = nullif(@QueryName,''),
ReleaseDate = nullif(@ReleaseDate,''),
ReleaseYear = nullif(@ReleaseYear,'');
SELECT * FROM general;


## Create table platform
DROP TABLE IF EXISTS platform;
CREATE TABLE platform(
ID INT NOT NULL,
Name VARCHAR(300) NOT NULL,
ControllerSupport VARCHAR(10) NOT NULL,
IsFree VARCHAR(10),
FreeVerAvail VARCHAR(10),
PurchaseAvail VARCHAR(10),
SubscriptionAvail VARCHAR(10),
PlatformWindows VARCHAR(10),
PlatformLinux VARCHAR(10),
PlatformMac VARCHAR(10),
PCReqsHaveMin VARCHAR(10),
PCReqsHaveRec VARCHAR(10),
LinuxReqsHaveMin VARCHAR(10),
LinuxReqsHaveRec VARCHAR(10),
MacReqsHaveMin VARCHAR(10),
MacReqsHaveRec VARCHAR(10)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/platform.csv'
INTO TABLE platform
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(ResponseID,ResponseName,ControllerSupport,IsFree,FreeVerAvail,PurchaseAvail,SubscriptionAvail,PlatformWindows,PlatformLinux,PlatformMac,PCReqsHaveMin,
PCReqsHaveRec,LinuxReqsHaveMin,LinuxReqsHaveRec,MacReqsHaveMin,MacReqsHaveRec);
SELECT * FROM platform limit 30;


## Create table category
DROP TABLE IF EXISTS category;
CREATE TABLE category(
QueryID INT NOT NULL,
QueryName VARCHAR(300),
SinglePlayer VARCHAR(50),
Multiplayer VARCHAR(50),
Coop VARCHAR(50),
MMO VARCHAR(50),
InAppPurchase VARCHAR(50),
IncludeSrcSDK VARCHAR(50),
IncludeLevelEditor VARCHAR(50),
VRSupport VARCHAR(50),
NonGame VARCHAR(50),
Indie VARCHAR(50),
Action VARCHAR(50),
Adventure VARCHAR(50),
Casual VARCHAR(50),
Strategy VARCHAR(50),
RPG VARCHAR(50),
Simulation VARCHAR(50),
EarlyAccess VARCHAR(50),
FreeToPlay VARCHAR(50),
Sports VARCHAR(50),
Racing VARCHAR(50),
MassivelyMultiplayer VARCHAR(50),
PRIMARY KEY(QueryID)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/categories.csv'
INTO TABLE category
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(QueryID,QueryName,SinglePlayer,Multiplayer,Coop,MMO,InAppPurchase,IncludeSrcSDK,IncludeLevelEditor,
VRSupport,NonGame,Indie,Action,Adventure,Casual,Strategy,RPG,Simulation,
EarlyAccess,FreeToPlay,Sports,Racing,MassivelyMultiplayer);
SELECT * FROM category limit 10;

##----------------------------------
## change ture/false to exactly category name they are
set sql_safe_updates=0;
UPDATE category
SET SinglePlayer = 'SinglePlayer'
WHERE SinglePlayer = 'TRUE';
UPDATE category
SET SinglePlayer = ''
WHERE SinglePlayer = 'FALSE';

UPDATE category
SET Multiplayer = 'Multiplayer'
WHERE Multiplayer = 'TRUE';
UPDATE category
SET Multiplayer = ''
WHERE Multiplayer = 'FALSE';

UPDATE category
SET Coop = 'Coop'
WHERE Coop = 'TRUE';
UPDATE category
SET Coop = ''
WHERE Coop = 'FALSE';

UPDATE category
SET MMO = 'MMO'
WHERE MMO = 'TRUE';
UPDATE category
SET MMO = ''
WHERE MMO = 'FALSE';

UPDATE category
SET VRSupport = 'VRSupport'
WHERE VRSupport = 'TRUE';
UPDATE category
SET VRSupport = ''
WHERE VRSupport = 'FALSE';

UPDATE category
SET Action = 'Action'
WHERE Action = 'TRUE';
UPDATE category
SET Action = ''
WHERE Action = 'FALSE';

UPDATE category
SET Adventure = 'Adventure'
WHERE Adventure = 'TRUE';
UPDATE category
SET Adventure = ''
WHERE Adventure = 'FALSE';

UPDATE category
SET Casual = 'Casual'
WHERE Casual = 'TRUE';
UPDATE category
SET Casual = ''
WHERE Casual = 'FALSE';

UPDATE category
SET Strategy = 'Strategy'
WHERE Strategy = 'TRUE';
UPDATE category
SET Strategy = ''
WHERE Strategy = 'FALSE';

UPDATE category
SET RPG = 'RPG'
WHERE RPG = 'TRUE';
UPDATE category
SET RPG = ''
WHERE RPG = 'FALSE';

UPDATE category
SET Simulation = 'Simulation'
WHERE Simulation = 'TRUE';
UPDATE category
SET Simulation = ''
WHERE Simulation = 'FALSE';

UPDATE category
SET EarlyAccess = 'EarlyAccess'
WHERE EarlyAccess = 'TRUE';
UPDATE category
SET EarlyAccess = ''
WHERE EarlyAccess = 'FALSE';

UPDATE category
SET FreeToPlay = 'FreeToPlay'
WHERE FreeToPlay = 'TRUE';
UPDATE category
SET FreeToPlay = ''
WHERE FreeToPlay = 'FALSE';

UPDATE category
SET Sports = 'Sports'
WHERE Sports = 'TRUE';
UPDATE category
SET Sports = ''
WHERE Sports = 'FALSE';

UPDATE category
SET Racing = 'Racing'
WHERE Racing = 'TRUE';
UPDATE category
SET Racing = ''
WHERE Racing = 'FALSE';

## contact all category togehter with view
DROP view IF EXISTS cate;
CREATE view cate AS
SELECT QueryID as ID, QueryName as Game,CONCAT(SinglePlayer," ",Multiplayer," ",coop," ",MMO," ",
VRSupport," ",Action," ",Adventure," ",Casual," ",Strategy," ",RPG,
Simulation," ",EarlyAccess," ",FreeToPlay," ",Sports," ",Racing) as category
FROM category;
SELECT * FROM cate;

##-----------------------------------------------------
## FIND most recommendation game with category
SELECT general.QueryName, general.Recommendation, cate.category
FROM general
Inner JOIN cate
ON general.QueryID = cate.ID 
ORDER BY general.Recommendation DESC limit 20; 

#--------------------------------------------------------------------
##Find game free and paid
SELECT COUNT(QueryName) as FreeGame
FROM general
WHERE PriceFinal = 0;

##----------------------------------------------
# compare free and paid game
SELECT QueryName FROM general WHERE PriceFinal = 0
UNION
SELECT QueryID FROM general WHERE PriceFinal!=0;

##Create table duration
DROP TABLE IF EXISTS duration;
CREATE TABLE duration(
UserID LONG,
GameName VARCHAR(100),
Duration decimal(10,2)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/duration.csv'
INTO TABLE duration
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(UserID,GameName,Duration);
SELECT * FROM duration limit 10;

##--------------------------------------------------------------------------------------------------------
## What are the most popular games
SELECT GameName, SUM(Duration)
FROM duration
GROUP BY GameName
ORDER BY SUM(duration) DESC LIMIT 20;

##--------------------------------------------------------------------------------------------------------
## What are the most recommendatation games
SELECT general.QueryName, general.ReleaseDate, general.RecommendationCount, general.Metacritic,category.CategorySinglePlayer, category.CategoryMultiplayer
From general
INNER JOIN category
ON general.QueryName = category.QueryName
ORDER BY RecommendationCount DESC limit 15;

##--------------------------------------------------------------------------------------------------------
## Using metacritic to compare the quality of games to the number of owners
## and the quality of free games to paid 
DROP VIEW IF EXISTS FreeGame;
CREATE VIEW FreeGame AS
SELECT QueryName, metacritic, Recommendation, SteamOwners, PriceFinal
FROM general
WHERE PriceFinal = '0';
SELECT QueryName,  Recommendation,PriceFinal
FROM FreeGame limit 10;

DROP VIEW IF EXISTS PaidGame;
CREATE VIEW PaidGame AS
SELECT QueryName, metacritic, Recommendation, SteamOwners, PriceFinal
FROM general
WHERE PriceFinal != '0';
SELECT QueryName,  Recommendation,PriceFinal
FROM PaidGame limit 10;

SELECT * FROM PaidGame;
SELECT * FROM FreeGame;
SELECT FreeGame.QueryName,FreeGame.metacritic,FreeGame.Recommendation,PaidGame.QueryName
FROM FreeGame
INNER JOIN PaidGame;

SELECT QueryName
FROM PaidGame 
UNION
SELECT QueryName
FROM FreeGame;
 #----------------------------------------------------------------------
 # game count by released year
 SELECT COUNT(QueryID),ReleaseYear
 FROM general
 GROUP BY ReleaseYear
 ORDER BY ReleaseYear DESC;
 
 #----------------------------------------
 # for the game The Witcher 3: Hunter
 SELECT QueryName, Recommendation, PriceFinal
 FROM general
 INNER JOIN duration
 ON general.QueryName = duration.GameName
 WHERE general.QueryName like '%Witcher%';

select * 
from duration
where GameName like 'The Witcher 3%'
GROUP by UserID;

#--------------------------------------------------
# get the screemshot and supported language to judge worldwild game
SELECT QueryName, Screenshot,Recommendation, PriceFinal,
(LENGTH(SupportedLanguage) - LENGTH(REPLACE(SupportedLanguage, ' ', '')) + 1) 
AS NumberOfSupportedLanguage, SupportedLanguage
FROM general
WHERE Recommendation > 10000 
#ORDER BY ScreenShot DESC;
ORDER BY NumberOfSupportedLanguage DESC;
#-------------------------------------------------------------------------------
# popular worldwild game with category 
SELECT general.QueryName, general.Recommendation, general.PriceFinal,
(LENGTH(general.SupportedLanguage) - LENGTH(REPLACE(general.SupportedLanguage, ' ', '')) + 1) 
AS NumberOfSupportedLanguage, cate.category
FROM general
INNER JOIN cate
ON general.QueryName = cate.Game
WHERE general.Recommendation>10000
ORDER BY general.Recommendation DESC;
