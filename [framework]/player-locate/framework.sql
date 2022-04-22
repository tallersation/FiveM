CREATE DATABASE IF NOT EXISTS `FiveM`;
USE `FiveM`;

CREATE TABLE `user_identifiers` (
	`steamid` VARCHAR(100) NOT NULL PRIMARY KEY,
   	`steamname` VARCHAR(100) NOT NULL,
   	`license` VARCHAR(100) NOT NULL,
   	`discord` VARCHAR(100) NOT NULL,
   	`fivem` VARCHAR(100) NOT NULL,
   	`ip` VARCHAR(100) NOT NULL,
	PRIMARY KEY (`steamid`)
);

CREATE TABLE `user_information` (
	`steamid` VARCHAR(100) NOT NULL,
	`steamname` VARCHAR(100) NOT NULL,
    `position` VARCHAR(100) NULL DEFAULT '{-269.4, -955.3, 31.2}',
	PRIMARY KEY (`steamid`)
    CONSTRAINT `FK_user_information_user_identifiers`
    FOREIGN KEY (`steamid`)
    REFERENCES `user_identifiers` (`steamid`)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);
