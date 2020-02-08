-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema t8huro00
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema t8huro00
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `t8huro00` DEFAULT CHARACTER SET latin1 ;
USE `t8huro00` ;

-- -----------------------------------------------------
-- Table `t8huro00`.`Elokuva`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t8huro00`.`Elokuva` (
  `idElokuva` INT(11) NOT NULL AUTO_INCREMENT,
  `Nimi` VARCHAR(45) NOT NULL,
  `Puhuttu_kieli` VARCHAR(45) NULL DEFAULT NULL,
  `Julkaistu` DATE NULL DEFAULT NULL,
  `Genre` VARCHAR(45) NULL DEFAULT NULL,
  `IMDb_arvio` DECIMAL(10,1) NULL DEFAULT NULL,
  `Katsottu` TINYINT(1) NULL DEFAULT NULL,
  PRIMARY KEY (`idElokuva`))
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `t8huro00`.`Elokuva_Roskakori`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t8huro00`.`Elokuva_Roskakori` (
  `idElokuva_Roskakori` INT(11) NOT NULL AUTO_INCREMENT,
  `Paivays` DATETIME NOT NULL,
  `Poistetut_tiedot` VARCHAR(145) NOT NULL,
  PRIMARY KEY (`idElokuva_Roskakori`))
ENGINE = InnoDB
AUTO_INCREMENT = 13
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `t8huro00`.`Nayttelija`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t8huro00`.`Nayttelija` (
  `idNayttelija` INT(11) NOT NULL AUTO_INCREMENT,
  `Netunimi` VARCHAR(45) NOT NULL,
  `Nsukunimi` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idNayttelija`))
ENGINE = InnoDB
AUTO_INCREMENT = 14
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `t8huro00`.`Ohjaaja`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t8huro00`.`Ohjaaja` (
  `idOhjaaja` INT(11) NOT NULL AUTO_INCREMENT,
  `Oetunimi` VARCHAR(45) NOT NULL,
  `Osukunimi` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idOhjaaja`))
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `t8huro00`.`Ohjaaja_Elokuva`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t8huro00`.`Ohjaaja_Elokuva` (
  `idOhjaaja` INT(11) NOT NULL,
  `idElokuva` INT(11) NOT NULL,
  PRIMARY KEY (`idOhjaaja`, `idElokuva`),
  INDEX `idElokuva2_idx` (`idElokuva` ASC),
  INDEX `idOhjaaja1_idx` (`idOhjaaja` ASC),
  CONSTRAINT `idElokuva2`
    FOREIGN KEY (`idElokuva`)
    REFERENCES `t8huro00`.`Elokuva` (`idElokuva`)
    ON UPDATE CASCADE,
  CONSTRAINT `idOhjaaja1`
    FOREIGN KEY (`idOhjaaja`)
    REFERENCES `t8huro00`.`Ohjaaja` (`idOhjaaja`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `t8huro00`.`Rooleissa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t8huro00`.`Rooleissa` (
  `Roolinimi` VARCHAR(45) NULL DEFAULT NULL,
  `idNayttelija` INT(11) NOT NULL,
  `idElokuva` INT(11) NOT NULL,
  INDEX `idNayttelija1_idx` (`idNayttelija` ASC),
  INDEX `idElokuva1_idx` (`idElokuva` ASC),
  CONSTRAINT `idElokuva1`
    FOREIGN KEY (`idElokuva`)
    REFERENCES `t8huro00`.`Elokuva` (`idElokuva`)
    ON UPDATE CASCADE,
  CONSTRAINT `idNayttelija1`
    FOREIGN KEY (`idNayttelija`)
    REFERENCES `t8huro00`.`Nayttelija` (`idNayttelija`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

USE `t8huro00` ;

-- -----------------------------------------------------
-- procedure ElokuvaKatsottu
-- -----------------------------------------------------

DELIMITER $$
USE `t8huro00`$$
CREATE DEFINER=`t8huro00`@`localhost` PROCEDURE `ElokuvaKatsottu`(
IN PNimi VARCHAR(45),
IN PKatsottu TINYINT(1))
Aliohjelma:BEGIN

DECLARE elokuvaID INT DEFAULT 0;
SELECT idElokuva INTO elokuvaID FROM Elokuva WHERE Nimi = PNimi;

IF elokuvaID = 0 THEN
     SELECT 'Elokuvaa ei ole olemassa';
ELSE 
UPDATE Elokuva SET Katsottu = PKatsottu WHERE idElokuva = elokuvaID;
END IF; 
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure HaeElokuvia
-- -----------------------------------------------------

DELIMITER $$
USE `t8huro00`$$
CREATE DEFINER=`t8huro00`@`localhost` PROCEDURE `HaeElokuvia`(
IN PKatsottu TINYINT(1),
IN PIMDb_arvio DECIMAL(10,1))
BEGIN

SELECT DISTINCT Nimi, Puhuttu_kieli, Julkaistu, Genre, IMDb_arvio FROM Elokuva 
WHERE IMDb_arvio >= PIMDb_arvio AND Katsottu =  PKatsottu;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure LisaaElokuva
-- -----------------------------------------------------

DELIMITER $$
USE `t8huro00`$$
CREATE DEFINER=`t8huro00`@`localhost` PROCEDURE `LisaaElokuva`(
IN POetunimi VARCHAR(45),
IN POsukunimi VARCHAR(45),
IN PNimi VARCHAR(45),
IN PPuhuttu_kieli VARCHAR(45),
IN PJulkaistu DATE,
IN PGenre  VARCHAR(45),
IN PIMDb_arvio DECIMAL(10,1),
IN PKatsottu TINYINT(1))
BEGIN
DECLARE elokuvaID INT DEFAULT 0;
DECLARE ohjaajaID INT DEFAULT 0;
DECLARE eoID INT DEFAULT 0;
SELECT idElokuva INTO elokuvaID FROM Elokuva WHERE Nimi = PNimi;

IF elokuvaID = 0 THEN
     INSERT INTO Elokuva VALUES (NULL, PNimi, PPuhuttu_kieli, PJulkaistu, PGenre, PIMDb_arvio, PKatsottu);
     SELECT LAST_INSERT_ID() INTO elokuvaID; 
END IF;

IF POetunimi IS NOT NULL AND POsukunimi IS NOT NULL THEN
       SELECT idOhjaaja INTO ohjaajaID FROM Ohjaaja WHERE Oetunimi = POetunimi AND Osukunimi = POsukunimi;
      IF ohjaajaID = 0 then
           INSERT INTO Ohjaaja VALUES (NULL, POetunimi, POsukunimi);
          SELECT LAST_INSERT_ID() INTO ohjaajaID;
     END IF;
END IF;

SELECT COUNT(*) INTO eoID FROM Ohjaaja_Elokuva WHERE idOhjaaja = ohjaajaID AND idElokuva = elokuvaID;
IF eoID = 0 then
         INSERT INTO Ohjaaja_Elokuva VALUES(ohjaajaID, elokuvaID);
END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure LisaaNayttelija
-- -----------------------------------------------------

DELIMITER $$
USE `t8huro00`$$
CREATE DEFINER=`t8huro00`@`localhost` PROCEDURE `LisaaNayttelija`(
IN PNimi VARCHAR(45),
IN PNetunimi VARCHAR(45),
IN PNsukunimi VARCHAR(45),
IN PRoolinimi VARCHAR(45))
Aliohjelma:BEGIN

DECLARE elokuvaID INT DEFAULT 0;
DECLARE nayttelijaID INT DEFAULT 0;
DECLARE rooleissaID INT DEFAULT 0;
SELECT idElokuva INTO elokuvaID FROM Elokuva WHERE Nimi = PNimi;

IF elokuvaID = 0 THEN
     SELECT 'Elokuvaa ei ole olemassa';
END IF;

SELECT idNayttelija INTO nayttelijaID FROM Nayttelija WHERE Netunimi = PNetunimi AND Nsukunimi = PNsukunimi;
	IF nayttelijaID = 0 then
		INSERT INTO Nayttelija VALUES (NULL, PNetunimi, PNsukunimi);
		SELECT LAST_INSERT_ID() INTO nayttelijaID;
	END IF;

SELECT COUNT(*) INTO rooleissaID FROM Rooleissa WHERE idNayttelija = nayttelijaID AND idElokuva = elokuvaID;
IF rooleissaID = 0 then
         INSERT INTO Rooleissa VALUES(PRoolinimi, nayttelijaID, elokuvaID);
END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure TulostaNayttelijanXElokuvat
-- -----------------------------------------------------

DELIMITER $$
USE `t8huro00`$$
CREATE DEFINER=`t8huro00`@`localhost` PROCEDURE `TulostaNayttelijanXElokuvat`(
IN PNetunimi VARCHAR(45),
IN PNsukunimi VARCHAR(45))
Aliohjelma:BEGIN

DECLARE nayttelijaID INT DEFAULT 0;
SELECT idNayttelija INTO nayttelijaID FROM Nayttelija WHERE Netunimi = PNetunimi AND Nsukunimi = PNsukunimi;

IF nayttelijaID = 0 THEN
     SELECT 'Näyttelijää ei ole olemassa';
ELSE 
SELECT DISTINCT Netunimi AS etunimi, Nsukunimi AS sukunimi, Roolinimi, Nimi AS 'Elokuvan nimi' FROM Elokuva 
JOIN Rooleissa ON Elokuva.idElokuva = Rooleissa.idElokuva 
JOIN Nayttelija ON Rooleissa.idNayttelija = Nayttelija.idNayttelija 
WHERE Netunimi = PNetunimi AND Nsukunimi = PNsukunimi;

END IF; 
END$$

DELIMITER ;
USE `t8huro00`;

DELIMITER $$
USE `t8huro00`$$
CREATE
DEFINER=`t8huro00`@`localhost`
TRIGGER `t8huro00`.`Elokuva_BEFORE_DELETE`
BEFORE DELETE ON `t8huro00`.`Elokuva`
FOR EACH ROW
BEGIN
	DECLARE str VARCHAR(145);
    SET str = CONCAT(OLD.idElokuva,' ',OLD.Nimi,' ',OLD.Puhuttu_kieli,' ',OLD.Julkaistu,' ',OLD.Genre,' ',OLD.IMDb_arvio,' ',OLD.Katsottu);
	INSERT INTO Elokuva_Roskakori VALUES(NULL,NOW(),str);
END$$

USE `t8huro00`$$
CREATE
DEFINER=`t8huro00`@`localhost`
TRIGGER `t8huro00`.`Nayttelija_BEFORE_DELETE`
BEFORE DELETE ON `t8huro00`.`Nayttelija`
FOR EACH ROW
BEGIN
	DECLARE str VARCHAR(145);
    SET str = CONCAT(OLD.idNayttelija,' ',OLD.Netunimi,' ',OLD.Nsukunimi);
	INSERT INTO Elokuva_Roskakori VALUES(NULL,NOW(),str);
END$$

USE `t8huro00`$$
CREATE
DEFINER=`t8huro00`@`localhost`
TRIGGER `t8huro00`.`Ohjaaja_BEFORE_DELETE`
BEFORE DELETE ON `t8huro00`.`Ohjaaja`
FOR EACH ROW
BEGIN
	DECLARE str VARCHAR(145);
	SET str = CONCAT(OLD.idOhjaaja,' ',OLD.Oetunimi,' ',OLD.Osukunimi);
	INSERT INTO Elokuva_Roskakori VALUES(NULL,NOW(),str);
END$$

USE `t8huro00`$$
CREATE
DEFINER=`t8huro00`@`localhost`
TRIGGER `t8huro00`.`Rooleissa_BEFORE_DELETE`
BEFORE DELETE ON `t8huro00`.`Rooleissa`
FOR EACH ROW
BEGIN
	INSERT INTO Elokuva_Roskakori VALUES(NULL,NOW(),OLD.Roolinimi);
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
