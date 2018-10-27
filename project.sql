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
DLCCount INT,
Metacritic INT,
MovieCount INT,
PackageCount INT,
RecommendationCount INT,
ScreenshotCount INT,
SteamSpyOwners INT,
SteamSpyOwnersVariance INT,
SteamSpyPlayersEstimate INT NOT NULL,
SteamSpyPlayersEstimateVariance INT NOT NULL,
AchievementCount INT NOT NULL,
AchievementHighlightedCount INT NOT NULL,
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
(QueryID,@QueryName,@ReleaseDate, @ReleaseYear,RequiredAge,DLCCount,Metacritic,MovieCount,PackageCount,RecommendationCount,ScreenshotCount,SteamspyOwners,SteamSpyOwnersVariance,
SteamSpyPlayersEstimate,SteamSpyPlayersEstimateVariance,AchievementCount,AchievementHighlightedCount,PriceInitial,PriceFinal,SupportedLanguage)
set
QueryName = nullif(@QueryName,''),
ReleaseDate = nullif(@ReleaseDate,''),
ReleaseYear = nullif(@ReleaseYear,'');
SELECT * FROM general;


## Create table platform
DROP TABLE IF EXISTS platform;
CREATE TABLE platform(
ResponseID INT NOT NULL,
ResponseName VARCHAR(300) NOT NULL,
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
CategorySinglePlayer VARCHAR(50),
CategoryMultiplayer VARCHAR(50),
CategoryCoop VARCHAR(50),
CategoryMMO VARCHAR(50),
CategoryInAppPurchase VARCHAR(50),
CategoryIncludeSrcSDK VARCHAR(50),
CategoryIncludeLevelEditor VARCHAR(50),
CategoryVRSupport VARCHAR(50),
GenreIsNonGame VARCHAR(50),
GenreIsIndie VARCHAR(50),
GenreIsAction VARCHAR(50),
GenreIsAdventure VARCHAR(50),
GenreIsCasual VARCHAR(50),
GenreIsStrategy VARCHAR(50),
GenreIsRPG VARCHAR(50),
GenreIsSimulation VARCHAR(50),
GenreIsEarlyAccess VARCHAR(50),
GenreIsFreeToPlay VARCHAR(50),
GenreIsSports VARCHAR(50),
GenreIsRacing VARCHAR(50),
GenreIsMassivelyMultiplayer VARCHAR(50),
PRIMARY KEY(QueryID)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/categories.csv'
INTO TABLE category
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(QueryID,QueryName,CategorySinglePlayer,CategoryMultiplayer,CategoryCoop,CategoryMMO,CategoryInAppPurchase,CategoryIncludeSrcSDK,CategoryIncludeLevelEditor,
CategoryVRSupport,GenreIsNonGame,GenreIsIndie,GenreIsAction,GenreIsAdventure,GenreIsCasual,GenreIsStrategy,GenreIsRPG,GenreIsSimulation,
GenreIsEarlyAccess,GenreIsFreeToPlay,GenreIsSports,GenreIsRacing,GenreIsMassivelyMultiplayer);
SELECT * FROM category limit 10;

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