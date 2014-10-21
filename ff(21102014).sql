SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema cnap_portal
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `cnap_portal` DEFAULT CHARACTER SET utf8 ;
USE `cnap_portal` ;

-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_default`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_default` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_default` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `registry` INT(11) NOT NULL COMMENT 'Ссылка на регистрацию(таблица которой принадлижит запись)',
  `storage` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_REGISTRY_idx` (`registry` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Корневая родительская форма. Ее наследуют все другие таблицы сформированые при помощи свободных форм ';


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_registry`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_registry` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_registry` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `parent` INT(11) NULL DEFAULT NULL COMMENT 'ссылка на родителя',
  `tablename` VARCHAR(45) NOT NULL COMMENT 'Имя таблицы в которая используется для хранения данных свободной формы',
  `description` TINYTEXT NULL DEFAULT NULL COMMENT 'описание',
  `protected` TINYINT(4) NOT NULL DEFAULT '0' COMMENT 'Блокировка/ системная таблица',
  `attaching` TINYINT(4) NOT NULL DEFAULT '0' COMMENT 'равен 1 если таблица создана не методами свободных форм',
  `copying` TINYINT(4) NOT NULL DEFAULT '0' COMMENT 'При 1 потомки копируют свои значения в эту таблицу',
  `view` VARCHAR(255) NULL DEFAULT NULL COMMENT 'Зарезирвированно, предполагается через этот параметр подключать разные формы отображения документов',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `table_UNIQUE` (`tablename` ASC),
  INDEX `parent` (`parent` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Список зарегистрированных свободных форм';


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_field`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_field` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_field` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `formid` INT(11) NULL DEFAULT '1' COMMENT 'Ссылка на свободную форму',
  `name` VARCHAR(255) NOT NULL COMMENT 'Имя поля свободнеой формы',
  `type` INT(11) NULL DEFAULT NULL COMMENT 'Тип поля в  свободной форме',
  `description` TINYTEXT NULL DEFAULT NULL COMMENT 'Описание / назначение поля',
  `order` INT(10) NOT NULL DEFAULT '0' COMMENT 'Порядок отображения полей. При 0 поле скрытое',
  `protected` TINYINT(4) NOT NULL DEFAULT '0' COMMENT 'Блокировка для защиты от несанкционированного удаления и/или изменения поля',
  PRIMARY KEY (`id`),
  INDEX `id_idx` (`formid` ASC),
  INDEX `FK_TYPE_idx` (`type` ASC),
  CONSTRAINT `fk_formid`
    FOREIGN KEY (`formid`)
    REFERENCES `cnap_portal`.`ff_registry` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8
COMMENT = 'Список полей подключенных в свобных формах';


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_registry_h`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_registry_h` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_registry_h` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `owner` INT(11) NOT NULL COMMENT 'Основная таблица',
  `parent` INT(11) NOT NULL COMMENT 'Родители основной талицы',
  PRIMARY KEY (`id`),
  INDEX `fk_parent_idx` (`parent` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Иерархия(вспомогательная таблиц';


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_storage`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_storage` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_storage` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL COMMENT 'Имя хранилища',
  `description` TINYTEXT NULL DEFAULT NULL COMMENT 'Описание хранилища',
  `subtype` INT(11) NOT NULL DEFAULT '0' COMMENT 'Подтип. Используется для отображения разных справочников',
  `type` INT(11) NULL DEFAULT NULL COMMENT 'Ссылка на таблицу типов',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Хранилище свободной формы';


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_registry_storage`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_registry_storage` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_registry_storage` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `registry` INT(11) NOT NULL COMMENT 'Ссылка на регистрацию свободной формы',
  `storage` INT(11) NOT NULL COMMENT 'Ссылка на хранилище в свободной форме',
  PRIMARY KEY (`id`),
  INDEX `fk_registry_idx` (`registry` ASC),
  INDEX `fk_storage_idx` (`storage` ASC),
  CONSTRAINT `fk_registry`
    FOREIGN KEY (`registry`)
    REFERENCES `cnap_portal`.`ff_registry` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_storage`
    FOREIGN KEY (`storage`)
    REFERENCES `cnap_portal`.`ff_storage` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Привязка форм и хранилищ';


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_types`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_types` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_types` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `typename` VARCHAR(255) NOT NULL COMMENT 'Имя типа отображаемого в свободной форме',
  `systemtype` VARCHAR(255) NULL DEFAULT NULL COMMENT 'Имя типа используемого для генерации таблиц',
  `view` VARCHAR(255) NULL DEFAULT NULL COMMENT 'Путь к визуальному представлению типа',
  `description` TINYTEXT NULL DEFAULT NULL COMMENT 'Описание',
  `visible` TINYINT(4) NOT NULL DEFAULT '1' COMMENT 'Признак отображения типа в списке типов',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 1000
DEFAULT CHARACTER SET = utf8
COMMENT = 'Список зарегистрированных типов';

USE `cnap_portal` ;

--
INSERT INTO `ff_types` (`id`, `typename`, `systemtype`, `view`, `description`,`visible`) VALUES
(1, 'Строка', 'VARCHAR(255)', NULL, 'Строка длиной 255 символов',1),
(2, 'Число', 'INT(11)', NULL, 'Целое число',1),
(3, 'Дата', 'DATE', 'date', 'Дата',1),
(4, 'Текст', 'TEXT', 'textarea', 'Текст',1),
(5, 'Большое число', 'BIGINT(20)', NULL, 'Большое целое число',1),
(6, 'Логический', 'TINYINT(4)', 'checkbox', 'Галочка',1),
(7, 'Дата и Время', 'DATETIME', 'datetime', 'Отображает дату и время',1),
(8, 'Штрихкод EAN-13', NULL, 'barcode', 'Генерирует штрихкод по формату EAN-13',1),
(9, 'Картинка', 'MEDIUMBLOB', 'image','', 1),
(10, 'Файл', 'LONGBLOB', 'file','Загружаемый файл', 1),
(11, 'filetype', 'VARCHAR(55)', NULL, 'MIME-тип файла',0),
(12, 'filename', 'VARCHAR(255)', NULL, 'Имя файла',0),
(13, 'Инициализация ЭЦП', NULL, 'initsign', 'Если файлы в документе будут подписывать, то в документе должен присутствовать',1),
(14, 'Файл с подписью', 'LONGBLOB', 'filesign', 'Данные файла с подписью',1),
(15, 'fileedstype', 'VARCHAR(55)', NULL, 'MIME-тип файла',0),
(16, 'fileedsname', 'VARCHAR(255)', NULL, 'Имя файла',0),
(17, 'fileedssign', 'BLOB', NULL, 'Подпись файла',0);

INSERT INTO `ff_registry` (`id`, `parent`, `tablename`, `description`, `protected`, `attaching`, `copying`, `view`) VALUES
(1, NULL, 'default', NULL, 1, 0, 1, NULL);


INSERT INTO `ff_field` (`id`, `formid`, `name`, `type`, `description`, `order`, `protected`) VALUES
(1, 1, 'registry', 2, NULL, 0, 1),
(2, 1, 'storage', 2, NULL, 0, 1);

COMMIT;

--

-- -----------------------------------------------------
-- Placeholder table for view `cnap_portal`.`ff_listtables`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_listtables` (`TABLE_NAME` INT);

-- -----------------------------------------------------
-- procedure FF_AI_FIELD
-- -----------------------------------------------------

USE `cnap_portal`;
DROP procedure IF EXISTS `cnap_portal`.`FF_AI_FIELD`;

DELIMITER $$
USE `cnap_portal`$$
CREATE PROCEDURE `FF_AI_FIELD`(in ID INT)
COMMENT 'Вызывается после добавления поля в таблицу полей. Контролирует ссылочную целостность'
BEGIN
	DECLARE TYPEREF INT DEFAULT 0;
	
	SELECT fff.`type` INTO TYPEREF FROM `ff_field` fff WHERE (fff.`id`=ID) LIMIT 1;
	if (TYPEREF=10) then
		INSERT INTO `ff_field` (`formid`,`name`,`type`,`description`,`order`,`protected`)
		SELECT src1.`formid`, concat(src1.`name`,'_filetype'), 11, concat(src1.`description`,' - MIME Тип'), 0,1
		FROM `ff_field` src1 WHERE (src1.`id`=ID);
		INSERT INTO `ff_field` 
			(`formid`,`name`,`type`,`description`,`order`,`protected`)
		SELECT src2.`owner`, src1.`name`, src1.`type`, src1.`description`, src1.`order`,1
		FROM `ff_field` src1 
			inner join `ff_registry_h` src2 on (src1.`formid`=src2.`parent`)
		WHERE (src1.id=LAST_INSERT_ID());

		INSERT INTO `ff_field` (`formid`,`name`,`type`,`description`,`order`,`protected`)
		SELECT src1.`formid`, concat(src1.`name`,'_filename'), 12, concat(src1.`description`,' - Имя файла'), 0,1
		FROM `ff_field` src1 WHERE (src1.`id`=ID);
		INSERT INTO `ff_field` 
			(`formid`,`name`,`type`,`description`,`order`,`protected`)
		SELECT src2.`owner`, src1.`name`, src1.`type`, src1.`description`, src1.`order`,1
		FROM `ff_field` src1 
			inner join `ff_registry_h` src2 on (src1.`formid`=src2.`parent`)
		WHERE (src1.id=LAST_INSERT_ID());

	end if;
	if (TYPEREF=14) then
		INSERT INTO `ff_field` (`formid`,`name`,`type`,`description`,`order`,`protected`)
		SELECT src1.`formid`, concat(src1.`name`,'_filetype'), 15, concat(src1.`description`,' - MIME Тип'), 0,1
		FROM `ff_field` src1 WHERE (src1.`id`=ID);
		INSERT INTO `ff_field` 
			(`formid`,`name`,`type`,`description`,`order`,`protected`)
		SELECT src2.`owner`, src1.`name`, src1.`type`, src1.`description`, src1.`order`,1
		FROM `ff_field` src1 
			inner join `ff_registry_h` src2 on (src1.`formid`=src2.`parent`)
		WHERE (src1.id=LAST_INSERT_ID());

		INSERT INTO `ff_field` (`formid`,`name`,`type`,`description`,`order`,`protected`)
		SELECT src1.`formid`, concat(src1.`name`,'_filename'), 16, concat(src1.`description`,' - Имя файла'), 0,1
		FROM `ff_field` src1 WHERE (src1.`id`=ID);
		INSERT INTO `ff_field` 
			(`formid`,`name`,`type`,`description`,`order`,`protected`)
		SELECT src2.`owner`, src1.`name`, src1.`type`, src1.`description`, src1.`order`,1
		FROM `ff_field` src1 
			inner join `ff_registry_h` src2 on (src1.`formid`=src2.`parent`)
		WHERE (src1.id=LAST_INSERT_ID());

		INSERT INTO `ff_field` (`formid`,`name`,`type`,`description`,`order`,`protected`)
		SELECT src1.`formid`, concat(src1.`name`,'_filename'), 17, concat(src1.`description`,' - Подпись файла'), 0,1
		FROM `ff_field` src1 WHERE (src1.`id`=ID);
		INSERT INTO `ff_field` 
			(`formid`,`name`,`type`,`description`,`order`,`protected`)
		SELECT src2.`owner`, src1.`name`, src1.`type`, src1.`description`, src1.`order`,1
		FROM `ff_field` src1 
			inner join `ff_registry_h` src2 on (src1.`formid`=src2.`parent`)
		WHERE (src1.id=LAST_INSERT_ID());

	end if;

	INSERT INTO `ff_field` 
			(`formid`,`name`,`type`,`description`,`order`,`protected`)
		SELECT src2.`owner`, src1.`name`, src1.`type`, src1.`description`, src1.`order`,1
		FROM `ff_field` src1 
			inner join `ff_registry_h` src2 on (src1.`formid`=src2.`parent`)
		WHERE (src1.id=ID);	
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure FF_ALTTBL
-- -----------------------------------------------------

USE `cnap_portal`;
DROP procedure IF EXISTS `cnap_portal`.`FF_ALTTBL`;

DELIMITER $$
USE `cnap_portal`$$
CREATE PROCEDURE `FF_ALTTBL`(in IDREGISTRY INT)
COMMENT 'Вызывается после измения списка полей в таблицу полей. Контролирует набор полей в сгенерированых таблицах'
BEGIN
	DECLARE CHILDCNT INT;
	DECLARE VOWNER INT;
	DECLARE VSTMT VARCHAR(4000);
	DECLARE VTSTMT VARCHAR(4000);
	DECLARE VTABLENAME VARCHAR(45);
	DECLARE done INT DEFAULT FALSE;
	DECLARE cur1 CURSOR FOR SELECT DISTINCT `owner` FROM `ff_registry_h` where `parent`= IDREGISTRY;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	call `FF_HELPER_ALTTBL`(IDREGISTRY,VTSTMT);
	select `tablename` into VTABLENAME from `ff_registry` where id = IDREGISTRY;
	select concat('ALTER TABLE `ff_',VTABLENAME,'` ', VTSTMT,';') into @VSTMT;
	PREPARE stmt1 FROM @VSTMT;
	EXECUTE stmt1;
	DEALLOCATE PREPARE stmt1;
 
	open cur1;
	FETCH cur1 INTO VOWNER;
	while (not done) do
		select `tablename` into VTABLENAME from `ff_registry` where id = VOWNER;
		select concat('ALTER TABLE `ff_',VTABLENAME,'` ', VTSTMT,';') into @VSTMT;
		PREPARE stmt2 FROM @VSTMT;
		EXECUTE stmt2;
		DEALLOCATE PREPARE stmt2;
		
		FETCH cur1 INTO VOWNER;
	END WHILE;
	close cur1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure FF_AU_FIELD
-- -----------------------------------------------------

USE `cnap_portal`;
DROP procedure IF EXISTS `cnap_portal`.`FF_AU_FIELD`;

DELIMITER $$
USE `cnap_portal`$$
CREATE PROCEDURE `FF_AU_FIELD`(in ID INT)
COMMENT 'Вызывается после изменения поля в таблице полей. Контролирует ссылочную целостность'
BEGIN
DECLARE VNAME VARCHAR(255);
DECLARE VTYPE INT;
DECLARE VFORMID INT;
DECLARE VEXIST INT DEFAULT 0;
	SELECT fff.`name`, fff.`type`, fff.`formid` INTO VNAME, VTYPE, VFORMID 
		FROM `ff_field` fff WHERE fff.id=ID LIMIT 1;

-- Будет потеря данных при модификации
-- пункт нужен для работы сохранения файла
	if (VTYPE<>10) then
		SELECT count(*) INTO VEXIST FROM `ff_field` fff 
			WHERE (fff.`formid`=VFORMID) and (fff.`name` = concat(VNAME,'_filetype')) limit 1;
		if (VEXIST>0) then 
			call FF_BD_FIELD(ID);
			DELETE FROM `ff_field` WHERE (`formid`=VFORMID) and (`name` like concat(VNAME,'%'));
		end if;
	else
		SELECT count(*) INTO VEXIST FROM `ff_field` fff 
			WHERE (fff.`formid`=VFORMID) and (fff.`name` = concat(VNAME,'_filetype')) limit 1;
		if (VEXIST=0) then 
			call FF_AI_FIELD(ID);
		end if;
	end if;
	if (VTYPE<>14) then
		SELECT count(*) INTO VEXIST FROM `ff_field` fff 
			WHERE (fff.`formid`=VFORMID) and (fff.`name` = concat(VNAME,'_fileedstype')) limit 1;
		if (VEXIST>0) then 
			call FF_BD_FIELD(ID);
			DELETE FROM `ff_field` WHERE (`formid`=VFORMID) and (`name` like concat(VNAME,'%'));
		end if;
	else
		SELECT count(*) INTO VEXIST FROM `ff_field` fff 
			WHERE (fff.`formid`=VFORMID) and (fff.`name` = concat(VNAME,'_fileedstype')) limit 1;
		if (VEXIST=0) then 
			call FF_AI_FIELD(ID);
		end if;
	end if;

	UPDATE `ff_field` src1 inner join 
		`ff_field` src2 on ((src1.`name`=src2.`name`) and (src2.id=ID))
			inner join `ff_registry_h` src3 on 
				((src2.`formid`=src3.`parent`) and (src1.`formid`=src3.`owner`))
	SET 
		src1.`type`=src2.`type`,
		src1.`description`=src2.`description`;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure FF_BD_FIELD
-- -----------------------------------------------------

USE `cnap_portal`;
DROP procedure IF EXISTS `cnap_portal`.`FF_BD_FIELD`;

DELIMITER $$
USE `cnap_portal`$$
CREATE PROCEDURE `FF_BD_FIELD`(in ID INT)
COMMENT 'Вызывается после удаления поля из таблицы полей. Контролирует ссылочную целостность'
BEGIN
	DECLARE VTYPE INT DEFAULT 0;
	DECLARE VNAME VARCHAR(255) DEFAULT NULL;	
	DECLARE VSTMT VARCHAR(4000);
	DECLARE VID INT;
	DECLARE VFORMID INT;
	DECLARE done INT DEFAULT FALSE;
	DECLARE cur1 CURSOR FOR 
				SELECT src3.id, src3.`type`, src3.`name`, src3.`formid`  
				FROM `ff_field` src3 
					inner join `ff_registry_h` src2 on (src3.`formid`=src2.`owner`)
						inner join `ff_field` src1 on ((src1.`formid`=src2.`parent`) AND (src3.`name`=src1.`name`))
				WHERE (src1.id=ID);
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	SELECT '' INTO @VSTMT;
	OPEN cur1;
	FETCH cur1 INTO VID, VTYPE, VNAME, VFORMID;
	WHILE (not done) DO 
		if (@VSTMT='') then
			SELECT VID INTO @VSTMT;
		else
			SELECT CONCAT(@VSTMT,' ,',VID) INTO @VSTMT;
		end if;
-- Поле файла
		if (VTYPE=10) then
			select fff.id into VID from `ff_field` fff where (fff.`name`=concat(VNAME,'_filetype')) and (fff.`formid`=VFORMID) limit 1;
			SELECT CONCAT(@VSTMT,' ,',VID) INTO @VSTMT;
			select fff.id into VID from `ff_field` fff where (fff.`name`=concat(VNAME,'_filename')) and (fff.`formid`=VFORMID) limit 1;
			SELECT CONCAT(@VSTMT,' ,',VID) INTO @VSTMT;
		end if;
		if (VTYPE=14) then
			select fff.id into VID from `ff_field` fff where (fff.`name`=concat(VNAME,'_fileedstype')) and (fff.`formid`=VFORMID) limit 1;
			SELECT CONCAT(@VSTMT,' ,',VID) INTO @VSTMT;
			select fff.id into VID from `ff_field` fff where (fff.`name`=concat(VNAME,'_fileedsname')) and (fff.`formid`=VFORMID) limit 1;
			SELECT CONCAT(@VSTMT,' ,',VID) INTO @VSTMT;
			select fff.id into VID from `ff_field` fff where (fff.`name`=concat(VNAME,'_fileedsname')) and (fff.`formid`=VFORMID) limit 1;
			SELECT CONCAT(@VSTMT,' ,',VID) INTO @VSTMT;
		end if;
		FETCH cur1 INTO VID, VTYPE, VNAME, VFORMID;
	END WHILE;
	CLOSE cur1;
	
	SET VTYPE=0;
	SELECT fff.`name`, fff.`type`, fff.`formid` into VNAME, VTYPE, VFORMID 
		from `ff_field` fff WHERE fff.id=ID;
	if (VTYPE=10) then 
		delete from `ff_field` where (`name`=concat(VNAME,'_filename')) and (`formid`=VFORMID) limit 1;
		delete from `ff_field` where (`name`=concat(VNAME,'_filetype')) and (`formid`=VFORMID) limit 1;
	end if;
	if (VTYPE=14) then 
		delete from `ff_field` where (`name`=concat(VNAME,'_fileedsname')) and (`formid`=VFORMID) limit 1;
		delete from `ff_field` where (`name`=concat(VNAME,'_fileedstype')) and (`formid`=VFORMID) limit 1;
		delete from `ff_field` where (`name`=concat(VNAME,'_fileedstype')) and (`formid`=VFORMID) limit 1;
	end if;

	if (@VSTMT<>'') then
		SELECT CONCAT('DELETE FROM `ff_field` WHERE id in (',@VSTMT,')') INTO @VSTMT;
		PREPARE stmt1 FROM @VSTMT;
		EXECUTE stmt1;
		DEALLOCATE PREPARE stmt1;
	end if;


END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure FF_CRTTBL
-- -----------------------------------------------------

USE `cnap_portal`;
DROP procedure IF EXISTS `cnap_portal`.`FF_CRTTBL`;

DELIMITER $$
USE `cnap_portal`$$
CREATE PROCEDURE `FF_CRTTBL`(in IDREGISTRY INT)
COMMENT 'Для создания начальной таблицы после ее регистрации. Зател должна быть вызвана ХП FF_ALTTBL'
BEGIN
	DECLARE VTABLENAME VARCHAR(45);
	DECLARE Q_CRTBL VARCHAR(1000);
	DECLARE VPARENT INT;
	
    -- SET VTABLENAME=null;
	select `tablename`,`parent` into VTABLENAME,VPARENT from `ff_registry` where id = IDREGISTRY;
	-- создаем начальную таблицу
	select CONCAT('CREATE TABLE `ff_',VTABLENAME,
      	'` ( `id` INT NOT NULL, `registry` INT NOT NULL DEFAULT ',
    	IDREGISTRY,', `storage` INT NULL DEFAULT NULL, PRIMARY KEY (`id`))')
	into @Q_CRTBL;   
    
	PREPARE stmt1 FROM @Q_CRTBL;
	EXECUTE stmt1;
	DEALLOCATE PREPARE stmt1;		
 
	INSERT INTO `ff_field` (`formid`,`name`,`type`,`description`,`order`,`protected`)
	SELECT IDREGISTRY,src.`name`,src.`type`,src.`description`,src.`order`,1
	FROM `ff_field` src
	WHERE src.`formid`=VPARENT;

	call FF_ALTTBL(IDREGISTRY);

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure FF_DELTBL
-- -----------------------------------------------------

USE `cnap_portal`;
DROP procedure IF EXISTS `cnap_portal`.`FF_DELTBL`;

DELIMITER $$
USE `cnap_portal`$$
CREATE PROCEDURE `FF_DELTBL`(in IDREGISTRY INT)
COMMENT 'Для удаления таблицы после ее дерегистрации'
BEGIN
	DECLARE VTABLENAME VARCHAR(45);
	DECLARE VATTACHING BIT;
	DECLARE Q_DLTBL VARCHAR(1000);
	DECLARE CHILDCNT INT;
	
	select count(`owner`) into CHILDCNT from `ff_registry_h` where `parent`= IDREGISTRY;
	if CHILDCNT=0 then
	  	select `tablename`, `attaching` into VTABLENAME,VATTACHING from `ff_registry` where id = IDREGISTRY;
		if VATTACHING=0 then
			select CONCAT('DROP TABLE `ff_',VTABLENAME,'`') into @Q_DLTBL;   		
			PREPARE stmt1 FROM @Q_DLTBL;
			EXECUTE stmt1;
			DEALLOCATE PREPARE stmt1;
		end if;
	else
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Нельзя удалить таблицу у которой есть наследники';
	end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure FF_HELPER_ALTTBL
-- -----------------------------------------------------

USE `cnap_portal`;
DROP procedure IF EXISTS `cnap_portal`.`FF_HELPER_ALTTBL`;

DELIMITER $$
USE `cnap_portal`$$
CREATE PROCEDURE `FF_HELPER_ALTTBL`(
	in IDREGISTRY INT,
	out STMT varchar(4000)
)
COMMENT 'Вспомоготельная ХП для FF_ALTTBL. Формирует необходимый запрос для изменения талиц.'
BEGIN
DECLARE done INT DEFAULT FALSE;
DECLARE VSTMTPIACE VARCHAR(200);
DECLARE cur1 CURSOR FOR	select sq from (
	select ff_cn, ff_tp, is_cn, is_tp,
		case 
			when (ff_cn = is_cn) and (ff_tp <> is_tp) then CONCAT(' MODIFY `', ff_cn, '` ', ff_tp)
			when (ff_cn is null) then CONCAT(' DROP `', is_cn,'`')
			when (is_cn is null) then CONCAT(' ADD `', ff_cn, '` ', ff_tp)
			else null
		end sq
	from 
	((SELECT 
		lower(fff.`name`) ff_cn, 
		lower(fft.`systemtype`) ff_tp, 
		lower(isc.`COLUMN_NAME`) is_cn, 
		lower(isc.`COLUMN_TYPE`) is_tp
	FROM `ff_field` fff 
		inner join `ff_types` fft on (fff.`type`=fft.id)
		inner join `ff_registry` ffr on (ffr.`id`=fff.`formid`)
		left outer join information_schema.`COLUMNS` isc on (
										(lower(isc.`COLUMN_NAME`) = lower(fff.`name`)) and 
										(isc.`TABLE_SCHEMA`=DATABASE()) and 
										(LOWER(isc.`COLUMN_NAME`)<>'id') and 
										(lower(isc.`TABLE_NAME`)=CONCAT('ff_',lower(ffr.`tablename`))))	
	WHERE  ffr.id=IDREGISTRY) 
	union
	(SELECT 
		tt.ff_cn, 
		tt.ff_tp,
		lower(isc.`COLUMN_NAME`) is_cn, 
		lower(isc.`COLUMN_TYPE`) is_tp
	from (
		SELECT 
			lower(fff.`name`) ff_cn, 
			lower(fft.`systemtype`) ff_tp, 
			lower(fff.`name`) ffcn
		FROM `ff_field` fff 
			inner join `ff_types` fft on (fff.`type`=fft.id)
		WHERE  fff.`formid`=IDREGISTRY) tt	
		right outer join information_schema.`COLUMNS` isc on (
										(lower(isc.`COLUMN_NAME`) = tt.ffcn) and 
										(isc.`TABLE_SCHEMA`=DATABASE()))	
		inner join `ff_registry` ffr2 on (CONCAT('ff_',lower(ffr2.`tablename`))=lower(isc.`TABLE_NAME`))
	where (LOWER(isc.`COLUMN_NAME`)<>'id') and ffr2.`id`=IDREGISTRY)) t1 ) t2
	where (t2.sq is not null) and (t2.ff_tp is not null);

DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
open cur1;
	set STMT='';

	fetch cur1 into VSTMTPIACE;
	while (not done) do
		if (STMT='') then
			select VSTMTPIACE into STMT;
		else
			select concat(STMT,', ',VSTMTPIACE) into STMT;
		end if;
		fetch cur1 into VSTMTPIACE;
	end while;
close cur1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure FF_HELPER_SYNCDATA
-- -----------------------------------------------------

USE `cnap_portal`;
DROP procedure IF EXISTS `cnap_portal`.`FF_HELPER_SYNCDATA`;

DELIMITER $$
USE `cnap_portal`$$
CREATE PROCEDURE `FF_HELPER_SYNCDATA`(
	in IDFROM INT,
	in IDREGISTRYFROM INT,
	in TABLENAMEFROM VARCHAR(45)
)
COMMENT 'Вспомагательная ХП для синхронизации заполненых данных.'
BEGIN
	DECLARE IDREGISTRYTO INT;
	DECLARE TABLENAMETO VARCHAR(45);
	DECLARE BUILDQUERY VARCHAR(4000);
	DECLARE done INT DEFAULT FALSE;
	DECLARE cur1 cursor for select ffrh.`parent`, ffr.`tablename`
		from `ff_registry_h` ffrh inner join `ff_registry` ffr on (ffrh.`parent`=ffr.id)
		where (ffrh.`owner`=IDREGISTRYFROM) and (ffr.`copying`=1);
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	OPEN cur1;
	FETCH cur1 INTO IDREGISTRYTO,TABLENAMETO;
	WHILE (not done) DO
		CALL `FF_HELPER_SYNCDATA_UPDATE`(IDFROM,IDREGISTRYTO,TABLENAMEFROM,TABLENAMETO,@BUILDQUERY);
		if (@BUILDQUERY is not null) then 
			PREPARE stmt1 FROM @BUILDQUERY;
			EXECUTE stmt1;
			DEALLOCATE PREPARE stmt1;
		end if;
		FETCH cur1 INTO IDREGISTRYTO,TABLENAMETO;
	END WHILE;
	CLOSE cur1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure FF_HELPER_SYNCDATA_DELETE
-- -----------------------------------------------------

USE `cnap_portal`;
DROP procedure IF EXISTS `cnap_portal`.`FF_HELPER_SYNCDATA_DELETE`;

DELIMITER $$
USE `cnap_portal`$$
CREATE PROCEDURE `FF_HELPER_SYNCDATA_DELETE`(
        in ID BIGINT
    )
COMMENT 'НЕВспомагательная ХП для синхронизации заполненых данных. Вызывается самостоятельно из-за сложности определения операции удаления'
BEGIN
	DECLARE VTABLENAME VARCHAR(45);
	DECLARE done INT DEFAULT FALSE;
	DECLARE cur1 cursor for select `tablename` from `ff_registry` where `copying`=1;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	OPEN cur1;
    SET @BUILDQUERY='';
	FETCH cur1 INTO VTABLENAME;
	WHILE (not done) DO
		SET @BUILDQUERY=concat('DELETE FROM `ff_', VTABLENAME,'` WHERE id=',ID);
		PREPARE stmt1 FROM @BUILDQUERY;
		EXECUTE stmt1;
		DEALLOCATE PREPARE stmt1;
		FETCH cur1 INTO VTABLENAME;
	END WHILE;	
	CLOSE cur1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure FF_HELPER_SYNCDATA_UPDATE
-- -----------------------------------------------------

USE `cnap_portal`;
DROP procedure IF EXISTS `cnap_portal`.`FF_HELPER_SYNCDATA_UPDATE`;

DELIMITER $$
USE `cnap_portal`$$
CREATE PROCEDURE `FF_HELPER_SYNCDATA_UPDATE`(
	in IDFROM INT,
	in IDREGISTRYTO INT,
	in TABLENAMEFROM VARCHAR(45),
	in TABLENAMETO VARCHAR(45),
	out BUILDQUERY VARCHAR(4000)
)
COMMENT 'Вспомогательная ХП для синхронизации данных при обновлении'
BEGIN
	DECLARE VFIELDNAME VARCHAR(55);
	DECLARE done INT DEFAULT FALSE;
	DECLARE firstiteration INT DEFAULT TRUE;
	DECLARE cur1 cursor for SELECT `name` FROM `ff_field` WHERE `formid`=IDREGISTRYTO;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	SET BUILDQUERY = CONCAT('UPDATE `ff_',TABLENAMETO,'` t1 INNER JOIN `ff_', 
							TABLENAMEFROM,'` t2 on (t1.id=t2.id) SET ');
	OPEN cur1;
	FETCH cur1 INTO VFIELDNAME;
	WHILE (not done) DO
		if not firstiteration then
			SET BUILDQUERY = CONCAT(BUILDQUERY, ', ');
		else
			SET firstiteration = FALSE;
		end if;
		SET BUILDQUERY = CONCAT(BUILDQUERY, 't1.`' ,VFIELDNAME,
				'` = t2.`', VFIELDNAME,'` ');
		FETCH cur1 INTO VFIELDNAME;
	END WHILE;
	if firstiteration then
		SET BUILDQUERY = NULL;
	else
		SET BUILDQUERY = CONCAT(BUILDQUERY,' WHERE t2.id=', IDFROM);
	end if;
	CLOSE cur1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure FF_INITID
-- -----------------------------------------------------

USE `cnap_portal`;
DROP procedure IF EXISTS `cnap_portal`.`FF_INITID`;

DELIMITER $$
USE `cnap_portal`$$
CREATE PROCEDURE `FF_INITID`(
	in IDREGISTRY INT, 
	in IDSTORAGE INT,
	out ID bigint(20))
COMMENT 'Нужна для получения ИД в наследниках'
BEGIN
	declare vtablename varchar(45);
	declare vquery varchar(1000);
	DECLARE done INT DEFAULT FALSE;
	DECLARE cur1 cursor for 
		(SELECT ffr.`tablename` 
			FROM `ff_registry_h` ffrh 
				inner join `ff_registry` ffr 
					on ((ffrh.`parent`=ffr.`id`) and (ffr.`copying`=1) and (ffr.`id`<>1)) 
			where ffrh.`owner`=IDREGISTRY) 
		UNION 
		(SELECT ffr2.`tablename` 
			FROM `ff_registry` ffr2
			WHERE (ffr2.id=IDREGISTRY) and (ffr2.id<>1));
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	
	-- Вычисляем идентификатор
	insert into `ff_default` (`registry`,`storage`) values (IDREGISTRY, IDSTORAGE);
	SELECT LAST_INSERT_ID() INTO ID;

	-- Инициируем всех потомков у которых стоит флаг копирования 
	open cur1;
	fetch cur1 into vtablename;
	while (not done) do
		select concat('insert into `ff_',vtablename,'` (`id`,`registry`,`storage`) values (',ID,',',IDREGISTRY,', ',IDSTORAGE,')') into @vquery;
		PREPARE stmt1 FROM @vquery;
		EXECUTE stmt1;
		DEALLOCATE PREPARE stmt1;

		fetch cur1 into vtablename;
	end while;
	close cur1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure FF_RSINIT
-- -----------------------------------------------------

USE `cnap_portal`;
DROP procedure IF EXISTS `cnap_portal`.`FF_RSINIT`;

DELIMITER $$
USE `cnap_portal`$$
CREATE PROCEDURE `FF_RSINIT`(in IDREGISTRY INT, in IDSTORAGE INT)
COMMENT 'Для регистрации СФ в хранилищах'
BEGIN
	INSERT INTO `ff_registry_storage` (`registry`, `storage`)
	VALUE (IDREGISTRY,IDSTORAGE);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure FF_SYNCDATA
-- -----------------------------------------------------

USE `cnap_portal`;
DROP procedure IF EXISTS `cnap_portal`.`FF_SYNCDATA`;

DELIMITER $$
USE `cnap_portal`$$
CREATE PROCEDURE `FF_SYNCDATA`(in ID BIGINT)
COMMENT 'Для синхронизации данных по дереву родителей/наследников'
BEGIN
	DECLARE VTABLENAMEFROM VARCHAR(45);
	DECLARE IDREGISTRYFROM INT DEFAULT NULL;
	DECLARE VTABLENAMETO VARCHAR(45);
	DECLARE IDREGISTRYTO INT;
	
	SELECT ffd.`registry`,  ffr.`tablename`
		INTO IDREGISTRYFROM, VTABLENAMEFROM
		FROM `ff_default` ffd
			INNER JOIN `ff_registry` ffr ON (ffd.`registry`=ffr.`id`)
		WHERE ffd.`id`=ID;
	call `FF_HELPER_SYNCDATA`(ID, IDREGISTRYFROM, VTABLENAMEFROM);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function FF_isParent
-- -----------------------------------------------------

USE `cnap_portal`;
DROP function IF EXISTS `cnap_portal`.`FF_isParent`;

DELIMITER $$
USE `cnap_portal`$$
CREATE FUNCTION `FF_isParent`(IDREGISTRY1 INT, IDREGISTRY2 INT) RETURNS int(11)
COMMENT 'Для определения родителя из двух вариантов'
BEGIN
	DECLARE VCNT INT default 0;
	SELECT count(*) INTO VCNT FROM `ff_registry_h` WHERE (`owner`=IDREGISTRY1) and (`parent`=IDREGISTRY2);
	if (VCNT>0) then
		RETURN 1;
	end if;
	SELECT count(*) INTO VCNT FROM `ff_registry_h` WHERE (`owner`=IDREGISTRY2) and (`parent`=IDREGISTRY1);
	if (VCNT>0) then
		RETURN -1;
	end if;
	RETURN 0;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `cnap_portal`.`ff_listtables`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `cnap_portal`.`ff_listtables` ;
DROP TABLE IF EXISTS `cnap_portal`.`ff_listtables`;
USE `cnap_portal`;
CREATE OR REPLACE VIEW `cnap_portal`.`ff_listtables` AS select lower(`information_schema`.`tables`.`TABLE_NAME`) AS `TABLE_NAME` from `information_schema`.`tables` where (`information_schema`.`tables`.`TABLE_SCHEMA` = database()) order by `information_schema`.`tables`.`TABLE_NAME`;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
USE `cnap_portal`;

DELIMITER $$

USE `cnap_portal`$$
DROP TRIGGER IF EXISTS `cnap_portal`.`ff_registry_AD` $$
USE `cnap_portal`$$
CREATE
TRIGGER `cnap_portal`.`ff_registry_AD`
AFTER DELETE ON `cnap_portal`.`ff_registry`
FOR EACH ROW
begin
	if (@disable_triggers is null) then
		delete from `ff_registry_h` where `owner`= old.id;		
	end if;
end$$


USE `cnap_portal`$$
DROP TRIGGER IF EXISTS `cnap_portal`.`ff_registry_AI` $$
USE `cnap_portal`$$
CREATE
TRIGGER `cnap_portal`.`ff_registry_AI`
AFTER INSERT ON `cnap_portal`.`ff_registry`
FOR EACH ROW
begin
	if (@disable_triggers is null) and (new.attaching=0) then
		-- Генерация иерархической истории
		insert into `ff_registry_h` (`owner`,`parent`)
			select new.id, `parent` from `ff_registry_h`
			where `owner`=new.parent;
		insert into `ff_registry_h` (`owner`,`parent`)
			values (new.id, new.parent);		
	end if;
end$$


USE `cnap_portal`$$
DROP TRIGGER IF EXISTS `cnap_portal`.`ff_registry_BI` $$
USE `cnap_portal`$$
CREATE
TRIGGER `cnap_portal`.`ff_registry_BI`
BEFORE INSERT ON `cnap_portal`.`ff_registry`
FOR EACH ROW
begin
	if (@disable_triggers is null) then
		-- Установка идентификатора
		if (new.parent is null) and (new.attaching=0) then 
			set new.parent = 1;
		end if;		
	end if;
end$$


USE `cnap_portal`$$
DROP TRIGGER IF EXISTS `cnap_portal`.`ff_storage_BDEL` $$
USE `cnap_portal`$$
CREATE
TRIGGER `cnap_portal`.`ff_storage_BDEL`
BEFORE DELETE ON `cnap_portal`.`ff_storage`
FOR EACH ROW
begin
	if (@disable_triggers is null) then
    	DELETE FROM `ff_types` 
		where id=old.`type`;
    end if;
end$$


USE `cnap_portal`$$
DROP TRIGGER IF EXISTS `cnap_portal`.`ff_storage_BUPD` $$
USE `cnap_portal`$$
CREATE
TRIGGER `cnap_portal`.`ff_storage_BUPD`
BEFORE UPDATE ON `cnap_portal`.`ff_storage`
FOR EACH ROW
begin
declare vview varchar(45);
	if (@disable_triggers is null) then
		case new.`subtype`
			when 0 then set vview = 'combobox';
			when 1 then set vview = 'listbox';
			when 2 then set vview = 'innerguide';
			when 3 then set vview = 'radiobox';
			else set vview = '';
		end case;
    	update `ff_types` set 
			`typename` = new.`name`,
			`description` = new.`description`,
			`view`=vview
		where id=new.`type`;
    end if;
end$$


USE `cnap_portal`$$
DROP TRIGGER IF EXISTS `cnap_portal`.`ff_storage_bins` $$
USE `cnap_portal`$$
CREATE
TRIGGER `cnap_portal`.`ff_storage_bins`
BEFORE INSERT ON `cnap_portal`.`ff_storage`
FOR EACH ROW
BEGIN
declare vview varchar(45);
	if (@disable_triggers is null) then
		case new.`subtype`
			when 0 then set vview = 'combobox';
			when 1 then set vview = 'listbox';
			when 2 then set vview = 'innerguide';
			when 3 then set vview = 'radiobox';
			else set vview = '';
		end case;
    	insert into `ff_types` (`typename`,`systemtype`,`description`, `view`)
        VALUES (new.`name`,'INT(11)',new.`description`,vview);
        set new.`type`=LAST_INSERT_ID();
    end if;
END$$


DELIMITER ;
