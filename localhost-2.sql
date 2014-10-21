-- phpMyAdmin SQL Dump
-- version 4.0.5
-- http://www.phpmyadmin.net
--
-- Хост: localhost
-- Время создания: Окт 22 2014 г., 00:39
-- Версия сервера: 5.5.37-0+wheezy1
-- Версия PHP: 5.4.4-14+deb7u14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- База данных: `cnap_portal`
--
CREATE DATABASE IF NOT EXISTS `cnap_portal` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `cnap_portal`;

DELIMITER $$
--
-- Процедуры
--
DROP PROCEDURE IF EXISTS `FF_AI_FIELD`$$
CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_AI_FIELD`(in ID INT)
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

DROP PROCEDURE IF EXISTS `FF_ALTTBL`$$
CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_ALTTBL`(in IDREGISTRY INT)
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

DROP PROCEDURE IF EXISTS `FF_AU_FIELD`$$
CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_AU_FIELD`(in ID INT)
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

DROP PROCEDURE IF EXISTS `FF_BD_FIELD`$$
CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_BD_FIELD`(in ID INT)
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

DROP PROCEDURE IF EXISTS `FF_CRTTBL`$$
CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_CRTTBL`(in IDREGISTRY INT)
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

DROP PROCEDURE IF EXISTS `FF_DELTBL`$$
CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_DELTBL`(in IDREGISTRY INT)
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

DROP PROCEDURE IF EXISTS `FF_HELPER_ALTTBL`$$
CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_HELPER_ALTTBL`(
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

DROP PROCEDURE IF EXISTS `FF_HELPER_SYNCDATA`$$
CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_HELPER_SYNCDATA`(
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

DROP PROCEDURE IF EXISTS `FF_HELPER_SYNCDATA_DELETE`$$
CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_HELPER_SYNCDATA_DELETE`(
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

DROP PROCEDURE IF EXISTS `FF_HELPER_SYNCDATA_UPDATE`$$
CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_HELPER_SYNCDATA_UPDATE`(
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

DROP PROCEDURE IF EXISTS `FF_INITID`$$
CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_INITID`(
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

DROP PROCEDURE IF EXISTS `FF_RSINIT`$$
CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_RSINIT`(in IDREGISTRY INT, in IDSTORAGE INT)
    COMMENT 'Для регистрации СФ в хранилищах'
BEGIN
	INSERT INTO `ff_registry_storage` (`registry`, `storage`)
	VALUE (IDREGISTRY,IDSTORAGE);
END$$

DROP PROCEDURE IF EXISTS `FF_SYNCDATA`$$
CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_SYNCDATA`(in ID BIGINT)
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

--
-- Функции
--
DROP FUNCTION IF EXISTS `FF_isParent`$$
CREATE DEFINER=`iasnap`@`%` FUNCTION `FF_isParent`(IDREGISTRY1 INT, IDREGISTRY2 INT) RETURNS int(11)
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

-- --------------------------------------------------------

--
-- Структура таблицы `AuthAssignment`
--

DROP TABLE IF EXISTS `AuthAssignment`;
CREATE TABLE IF NOT EXISTS `AuthAssignment` (
  `itemname` varchar(64) NOT NULL,
  `userid` varchar(64) NOT NULL,
  `bizrule` text,
  `data` text,
  PRIMARY KEY (`itemname`,`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `AuthAssignment`
--

INSERT INTO `AuthAssignment` (`itemname`, `userid`, `bizrule`, `data`) VALUES
('siteadmin', '16', NULL, 'N;');

-- --------------------------------------------------------

--
-- Структура таблицы `AuthItem`
--

DROP TABLE IF EXISTS `AuthItem`;
CREATE TABLE IF NOT EXISTS `AuthItem` (
  `name` varchar(64) NOT NULL,
  `type` int(11) NOT NULL,
  `description` text,
  `bizrule` text,
  `data` text,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `AuthItem`
--

INSERT INTO `AuthItem` (`name`, `type`, `description`, `bizrule`, `data`) VALUES
('siteadmin', 2, '', NULL, 'N;');

-- --------------------------------------------------------

--
-- Структура таблицы `AuthItemChild`
--

DROP TABLE IF EXISTS `AuthItemChild`;
CREATE TABLE IF NOT EXISTS `AuthItemChild` (
  `parent` varchar(64) NOT NULL,
  `child` varchar(64) NOT NULL,
  PRIMARY KEY (`parent`,`child`),
  KEY `child` (`child`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `cab_adm_menu`
--

DROP TABLE IF EXISTS `cab_adm_menu`;
CREATE TABLE IF NOT EXISTS `cab_adm_menu` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `par_id` tinyint(4) NOT NULL DEFAULT '0',
  `url` varchar(45) NOT NULL DEFAULT 'admin/default',
  `ref` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Меню адміністративної панелі' AUTO_INCREMENT=29 ;

--
-- Дамп данных таблицы `cab_adm_menu`
--

INSERT INTO `cab_adm_menu` (`id`, `name`, `par_id`, `url`, `ref`) VALUES
(1, 'Управління загальним інтерфейсом порталу', 0, 'admin/default/id1', 0),
(2, 'Управління послугами', 0, 'admin/default/id2', 1),
(3, 'Управління користувачами', 0, 'admin/default/id3', 2),
(4, 'Управління довідниками', 0, 'admin/default/id4', 3),
(5, 'Таблиця «Пункти меню»', 1, 'admin/genMenuItems/index', 0),
(6, 'Таблиця «Посилання на статті до категорій сайту»', 1, 'admin/genOtherInfo/index', 1),
(7, 'Таблиця «Відомості про нормативно-правові акти»', 1, 'admin/genRegulations/index', 3),
(8, 'Таблиця «Відомості про центри та суб’єкти»', 2, 'admin/genAuthorities/index', 0),
(9, 'Таблиця «Відомості про послуги»', 2, 'admin/genServices/index', 1),
(14, 'Модуль «Вільні форми до послуг»', 2, 'mff/default', 3),
(15, 'Модуль «Маршрути до послуг»', 2, 'admin/default', 4),
(16, 'Таблиця «Каталог ролі користувачів»', 3, 'admin/cabUserRoles/index', 0),
(17, 'Таблиця «Каталог внутрішніх користувачів порталу»', 3, 'admin/cabUserInternal/index', 1),
(18, 'Таблиця «Сертифікати внутрішніх користувачів»', 3, 'admin/cabUserInternCerts/index', 2),
(19, 'Таблиця «Каталог зовнішніх користувачів порталу»', 3, 'admin/cabUserExternal/index', 3),
(20, 'Таблиця «Сертифікати зовнішніх користувачів»', 3, 'admin/cabUserExternCerts/index', 4),
(21, 'Таблиця «Відомості про активність користувачів»', 3, 'admin/cabUserActivities/index', 5),
(22, 'Таблиця «Каталог класів послуг»', 4, 'admin/genServClasses/index', 0),
(23, 'Таблиця «Каталог категорій послуг»', 4, 'admin/genServCategories/index', 1),
(24, 'Таблиця «Відомості про населені пункти»', 4, 'admin/genLocations/index', 3),
(25, 'Таблиця «Управління новинами»', 1, 'admin/genNews/index', 2),
(27, 'Таблиця «Зв''язок категорій з класами»', 4, 'admin/genCatClasses/index', 2),
(28, 'Таблиця «Зв''язок послуг з категоріями та класами»', 2, 'admin/genServCatClass/index', 2);

-- --------------------------------------------------------

--
-- Структура таблицы `cab_authorities_certs`
--

DROP TABLE IF EXISTS `cab_authorities_certs`;
CREATE TABLE IF NOT EXISTS `cab_authorities_certs` (
  `id` int(10) unsigned NOT NULL,
  `certissuer` text NOT NULL COMMENT 'Власник сертифікату',
  `certserial` varchar(40) NOT NULL COMMENT 'Серійний номер сертифікату',
  `certSubjDRFOCode` varchar(10) DEFAULT NULL COMMENT 'Код ДРФО',
  `certSubjEDRPOUCode` varchar(10) NOT NULL COMMENT 'Код ЄДРПОУ',
  `certData` mediumblob NOT NULL COMMENT 'Вміст сертифікату',
  `type` tinyint(3) unsigned NOT NULL COMMENT 'Тип 0-ЕЦП 1-шифрування',
  `authorities_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `authorities_certs_idx` (`authorities_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Сертифікати користувачів (ЦНАП, СНАП, тех.підтримка)';

-- --------------------------------------------------------

--
-- Структура таблицы `cab_bids_rkk`
--

DROP TABLE IF EXISTS `cab_bids_rkk`;
CREATE TABLE IF NOT EXISTS `cab_bids_rkk` (
  `id` int(11) unsigned NOT NULL COMMENT '№ з/п',
  `date` date DEFAULT NULL COMMENT 'дата надходження',
  `bid_id` varchar(11) NOT NULL COMMENT 'Трек номер',
  `subj_category` enum('фізична особа','фізична особа - підприємець','юридична особа') NOT NULL COMMENT 'Категорія суб''єкта звернення',
  `organization` varchar(255) NOT NULL COMMENT 'Організація',
  `edrpouCode` varchar(10) DEFAULT NULL COMMENT 'Код ЄДРПОУ',
  `surname` varchar(20) NOT NULL COMMENT 'Прізвище',
  `name` varchar(20) NOT NULL COMMENT 'ім''я',
  `patronymic` varchar(20) NOT NULL COMMENT 'По-батькові',
  `drfoCode` varchar(10) DEFAULT NULL COMMENT 'Код ДРФО',
  `address` varchar(255) NOT NULL COMMENT 'Адреса надсилання відповіді',
  `phone1` varchar(15) NOT NULL COMMENT 'Контактний телефон 1',
  `phone2` varchar(15) DEFAULT NULL COMMENT 'Контактний телефон 2',
  `e-mail` varchar(45) DEFAULT NULL COMMENT 'Електронна пошта',
  `answer_method` tinyint(3) unsigned NOT NULL COMMENT 'Варіант отримання відповіді 0-поштою, 1-особисто, 2- через портал',
  `out_number` varchar(20) DEFAULT NULL COMMENT 'Вих. №',
  `out_date` date DEFAULT NULL COMMENT 'Дата листа',
  `method_of_delivery` enum('особисто','портал','курєр','електронна пошта','пошта','факс') NOT NULL COMMENT 'метод доставки',
  `secrecy` enum('Відкрита','Конфіденційна') NOT NULL COMMENT 'Гриф обмеження доступу',
  `sheets` tinyint(4) DEFAULT NULL COMMENT 'Кількість аркушів',
  `services_id` smallint(6) NOT NULL COMMENT 'ID послуги',
  `intern_status_id` tinyint(3) unsigned DEFAULT NULL COMMENT 'Статус обробки заявки',
  `organization_id` smallint(5) unsigned DEFAULT NULL COMMENT 'ID організації',
  `step` smallint(5) unsigned DEFAULT NULL COMMENT 'Крок',
  `date_of_delivery` datetime DEFAULT NULL COMMENT 'Дата вручення',
  `return_date` datetime DEFAULT NULL COMMENT 'Дата повернення',
  `considers` varchar(45) DEFAULT NULL COMMENT 'Розглядає',
  `contents` varchar(255) DEFAULT NULL COMMENT 'Короткий зміст',
  `control_type` enum('звичайний','додатковий') NOT NULL,
  `term` datetime DEFAULT NULL COMMENT 'Термін',
  `add_to_term` datetime DEFAULT NULL COMMENT 'Продовжено днів',
  `end_of_control_date` datetime DEFAULT NULL COMMENT 'Дата зняття контролю',
  `end_of_control_person_id` smallint(5) unsigned DEFAULT NULL COMMENT 'Особа, яка зняла з контролю',
  `result` varchar(255) DEFAULT NULL COMMENT 'Результат',
  `readiness` tinyint(4) NOT NULL COMMENT 'готовність 0-не завершений, 1-завершений',
  PRIMARY KEY (`id`),
  UNIQUE KEY `bid_id_UNIQUE` (`bid_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='РКК заяв користувачів';

-- --------------------------------------------------------

--
-- Структура таблицы `cab_org_external_certs`
--

DROP TABLE IF EXISTS `cab_org_external_certs`;
CREATE TABLE IF NOT EXISTS `cab_org_external_certs` (
  `id` int(10) unsigned NOT NULL,
  `certissuer` text NOT NULL COMMENT 'Власник сертифікату',
  `certserial` varchar(40) NOT NULL COMMENT 'Серійний номер сертифікату',
  `certSubjDRFOCode` varchar(10) DEFAULT NULL COMMENT 'Код ДРФО',
  `certSubjEDRPOUCode` varchar(10) NOT NULL COMMENT 'Код ЄДРПОУ',
  `certData` mediumblob NOT NULL COMMENT 'Вміст сертифікату',
  `type` tinyint(3) unsigned NOT NULL COMMENT 'Тип 0-ЕЦП 1-шифрування',
  `ext_user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `authorities_certs_idx` (`ext_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Сертифікати організацій';

-- --------------------------------------------------------

--
-- Структура таблицы `cab_promoting_bids`
--

DROP TABLE IF EXISTS `cab_promoting_bids`;
CREATE TABLE IF NOT EXISTS `cab_promoting_bids` (
  `id` smallint(5) unsigned NOT NULL,
  `services_id` smallint(5) unsigned NOT NULL COMMENT 'ID послуги',
  `step` tinyint(3) unsigned NOT NULL COMMENT 'Крок',
  `authorities_id` smallint(5) unsigned NOT NULL COMMENT 'ID організації',
  `scab_user_id` smallint(5) unsigned DEFAULT NULL COMMENT 'ID виконавця (за потреби)',
  PRIMARY KEY (`id`),
  KEY `fk_services` (`services_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Просування заявки';

-- --------------------------------------------------------

--
-- Структура таблицы `cab_user`
--

DROP TABLE IF EXISTS `cab_user`;
CREATE TABLE IF NOT EXISTS `cab_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `type_of_user` tinyint(3) unsigned NOT NULL COMMENT 'Тип користувача (0-фіз.особа, 1- ФОП, 2-юр.особа)',
  `fio` varchar(100) NOT NULL COMMENT 'ПІБ',
  `organization` varchar(100) NOT NULL DEFAULT 'фізична особа' COMMENT 'Організація',
  `email` varchar(45) NOT NULL COMMENT 'Електронна поштова скринька',
  `phone` varchar(12) NOT NULL COMMENT 'Мобільний телефон',
  `cab_state` enum('не активований','активований','блокований') NOT NULL COMMENT 'Стан кабінету',
  `authorities_id` smallint(3) unsigned NOT NULL,
  `user_roles_id` tinyint(3) unsigned NOT NULL COMMENT 'ID ролі користувача',
  `str_tdata` varchar(40) DEFAULT NULL COMMENT 'Дані для тимчасового використання',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `phone_UNIQUE` (`phone`),
  KEY `role_id_idx` (`user_roles_id`),
  KEY `author_id_idx` (`authorities_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Каталог користувачів порталу»' AUTO_INCREMENT=17 ;

--
-- Дамп данных таблицы `cab_user`
--

INSERT INTO `cab_user` (`id`, `type_of_user`, `fio`, `organization`, `email`, `phone`, `cab_state`, `authorities_id`, `user_roles_id`, `str_tdata`) VALUES
(1, 0, '', 'фізична особа', 'format13@meta.ua', '0671234567', 'активований', 1, 4, NULL),
(3, 0, '', 'фізична особа', 'y.v.kopytin@gmail.com', '0930798055', 'активований', 1, 4, NULL),
(9, 0, '', 'фізична особа', 'fortor48@gmail.com', '09376544567', 'активований', 1, 4, NULL),
(16, 0, '', 'фізична особа', 'admin@admin.adm', '0931233214', 'активований', 1, 1, '12754482');

-- --------------------------------------------------------

--
-- Структура таблицы `cab_user_activities`
--

DROP TABLE IF EXISTS `cab_user_activities`;
CREATE TABLE IF NOT EXISTS `cab_user_activities` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `portal_user_id` smallint(5) unsigned NOT NULL COMMENT 'ID користувача',
  `visiting` datetime NOT NULL COMMENT 'Час події',
  `IPAdress` varchar(15) NOT NULL COMMENT 'IP адреса',
  `type` enum('вхід','вихід','роздрукування','редагування') NOT NULL COMMENT 'Подія',
  `success` tinyint(4) NOT NULL COMMENT 'Успішність 0/1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Таблиця «Відомості про активність користувачів»' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Структура таблицы `cab_user_bids_connect`
--

DROP TABLE IF EXISTS `cab_user_bids_connect`;
CREATE TABLE IF NOT EXISTS `cab_user_bids_connect` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL COMMENT 'ID користувача',
  `bid_created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата подачі',
  `services_id` smallint(5) unsigned NOT NULL COMMENT 'ID послуги',
  `payment_status` enum('UNPAID','PAID') NOT NULL COMMENT 'Статус оплати',
  `answer_variant` tinyint(3) unsigned NOT NULL COMMENT 'Варіант отримання відповіді 0-пошта 1-особисто 2-портал',
  `address` varchar(255) DEFAULT NULL COMMENT 'Адреса куди надсилати відповідь поштою',
  PRIMARY KEY (`id`),
  KEY `fk_serv` (`services_id`),
  KEY `fk_user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця з заявками' AUTO_INCREMENT=3 ;

--
-- Дамп данных таблицы `cab_user_bids_connect`
--

INSERT INTO `cab_user_bids_connect` (`id`, `user_id`, `bid_created_date`, `services_id`, `payment_status`, `answer_variant`, `address`) VALUES
(2, 1, '2014-09-22 20:33:37', 1, 'UNPAID', 2, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `cab_user_extern_certs`
--

DROP TABLE IF EXISTS `cab_user_extern_certs`;
CREATE TABLE IF NOT EXISTS `cab_user_extern_certs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `type_of_user` tinyint(4) NOT NULL COMMENT 'Тип користувача (0-фіз.особа 1-організація)',
  `certissuer` text NOT NULL COMMENT 'Власник сертифікату',
  `certserial` varchar(40) NOT NULL COMMENT 'Серійний номер сертифікату',
  `certSubjDRFOCode` varchar(10) DEFAULT NULL COMMENT 'Код ДРФО',
  `certSubjEDRPOUCode` varchar(10) DEFAULT NULL COMMENT 'Код ЄДРПОУ',
  `certData` mediumblob NOT NULL COMMENT 'Вміст сертифікату',
  `certType` tinyint(3) unsigned NOT NULL COMMENT 'Тип ЕЦП/шифрування',
  `ext_user_id` int(10) unsigned NOT NULL COMMENT 'ID зовнішнього користувача',
  PRIMARY KEY (`id`),
  KEY `ext_user_certs_idx` (`ext_user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Сертифікати зовнішніх користувачів»' AUTO_INCREMENT=7 ;

--
-- Дамп данных таблицы `cab_user_extern_certs`
--

INSERT INTO `cab_user_extern_certs` (`id`, `type_of_user`, `certissuer`, `certserial`, `certSubjDRFOCode`, `certSubjEDRPOUCode`, `certData`, `certType`, `ext_user_id`) VALUES
(1, 0, 'O=АТ "ІІТ";OU=Тестовий ЦСК;CN=Тестовий ЦСК АТ "ІІТ";Serial=UA-22723472;C=UA;L=Харків;ST=Харківська', '5B63D88375D9201804000000EB040000630A0000', '9987654321', '99876540', 0x3082068130820629a00302010202145b63d88375d9201804000000eb040000630a0000300d060b2a862402010101010301013081c331163014060355040a0c0dd090d0a22022d086d086d0a2223120301e060355040b0c17d0a2d0b5d181d182d0bed0b2d0b8d0b920d0a6d0a1d09a312e302c06035504030c25d0a2d0b5d181d182d0bed0b2d0b8d0b920d0a6d0a1d09a20d090d0a22022d086d086d0a2223114301206035504050c0b55412d3232373233343732310b30090603550406130255413115301306035504070c0cd0a5d0b0d180d0bad196d0b2311d301b06035504080c14d0a5d0b0d180d0bad196d0b2d181d18cd0bad0b0301e170d3134303830383231303030305a170d3135303830383231303030305a3082012231223020060355040a0c19d0a4d196d0b7d0b8d187d0bdd0b020d0bed181d0bed0b1d0b031223020060355040b0c19d0a4d196d0b7d0b8d187d0bdd0b020d0bed181d0bed0b1d0b031223020060355040c0c19d0a4d196d0b7d0b8d187d0bdd0b020d0bed181d0bed0b1d0b0312f302d06035504030c26d09cd0bed0bbd0bed0b4d188d0b8d0b920d094d0b8d18020d094d0b8d180d0bed0b2d0b8d1873119301706035504040c10d09cd0bed0bbd0bed0b4d188d0b8d0b9311e301c060355042a0c15d094d0b8d18020d094d0b8d180d0bed0b2d0b8d187310d300b06035504050c0431323539310b30090603550406130255413113301106035504070c0ad09ed0b4d0b5d181d0b03117301506035504080c0ed09ed0b4d0b5d181d18cd0bad0b03081f23081c9060b2a862402010101010301013081b9307530070202010102010c020100042110bee3db6aea9e1f86578c45c12594ff942394a7d738f9187e6515017294f4ce01022100800000000000000000000000000000006759213af182e987d3e17714907d470d0421b60fd2d8dce8a93423c6101bca91c47a007e6c300b26cd556c9b0e7d20ef292a000440a9d6eb45f13c708280c4967b231f5eadf658eba4c037291d38d96bf025ca4e17f8e9720dc615b43a28975f0bc1dea36438b564ea2c179fd0123e6db8fac5790403240004215869fc50fc2b8e07bc779940ba002d79e08fba55b3560679580fb2a7cab3f95f00a38202fa308202f630290603551d0e042204204d0fb29c86aa18eea3a89eef34b84ab2bf8f3f928010767dd468bddaf7441527302b0603551d230424302280205b63d88375d92018cdb4b10eb9b6a5c69a59fd4327c671e3c1f53aeab02d6ade302f0603551d1004283026a011180f32303134303830383231303030305aa111180f32303135303830383231303030305a300e0603551d0f0101ff0404030206c030190603551d200101ff040f300d300b06092a8624020101010202300c0603551d130101ff04023000301e06082b060105050701030101ff040f300d300b06092a86240201010102013081810603551d11047a3078a035060c2b0601040181974601010402a0250c23d0b2d183d0bb2e20d0a1d0b5d180d182d0b8d184d196d0bad0b0d182d0bdd0b02c2033a01f060c2b0601040181974601010401a00f0c0d2b333830303831323334353637820c6961736e61702e6c6f63616c8110666f726d61743132406d6574612e756130410603551d1f043a30383036a034a0328630687474703a2f2f63612e6969742e636f6d2e75612f646f776e6c6f61642f63726c732f434131332d46756c6c2e63726c30420603551d2e043b30393037a035a0338631687474703a2f2f63612e6969742e636f6d2e75612f646f776e6c6f61642f63726c732f434131332d44656c74612e63726c30818106082b0601050507010104753073302f06082b060105050730018623687474703a2f2f63612e6969742e636f6d2e75612f73657276696365732f6f6373702f304006082b060105050730028634687474703a2f2f63612e6969742e636f6d2e75612f646f776e6c6f61642f6365727469666963617465732f63616969742e703762303e06082b0601050507010b04323030302e06082b060105050730038622687474703a2f2f63612e6969742e636f6d2e75612f73657276696365732f7473702f30430603551d09043c303a301a060c2a8624020101010b01040201310a13083939383736353430301c060c2a8624020101010b01040101310c130a39393837363534333231300d060b2a862402010101010301010343000440c61a79035d4ef320eb20a1be8c19e7bc8ecfdef485f00180a3262cb2e9b66206bc1ac6b4bda3b092360149d34316e9aaaac7bb95e9dc39ac4373de0035c5a942, 0, 1),
(2, 0, 'O=АТ "ІІТ";OU=Тестовий ЦСК;CN=Тестовий ЦСК АТ "ІІТ";Serial=UA-22723472;C=UA;L=Харків;ST=Харківська', '5B63D88375D9201804000000EB040000630A0000', '9987654321', '99876540', 0x3082068130820629a00302010202145b63d88375d9201804000000eb040000630a0000300d060b2a862402010101010301013081c331163014060355040a0c0dd090d0a22022d086d086d0a2223120301e060355040b0c17d0a2d0b5d181d182d0bed0b2d0b8d0b920d0a6d0a1d09a312e302c06035504030c25d0a2d0b5d181d182d0bed0b2d0b8d0b920d0a6d0a1d09a20d090d0a22022d086d086d0a2223114301206035504050c0b55412d3232373233343732310b30090603550406130255413115301306035504070c0cd0a5d0b0d180d0bad196d0b2311d301b06035504080c14d0a5d0b0d180d0bad196d0b2d181d18cd0bad0b0301e170d3134303830383231303030305a170d3135303830383231303030305a3082012231223020060355040a0c19d0a4d196d0b7d0b8d187d0bdd0b020d0bed181d0bed0b1d0b031223020060355040b0c19d0a4d196d0b7d0b8d187d0bdd0b020d0bed181d0bed0b1d0b031223020060355040c0c19d0a4d196d0b7d0b8d187d0bdd0b020d0bed181d0bed0b1d0b0312f302d06035504030c26d09cd0bed0bbd0bed0b4d188d0b8d0b920d094d0b8d18020d094d0b8d180d0bed0b2d0b8d1873119301706035504040c10d09cd0bed0bbd0bed0b4d188d0b8d0b9311e301c060355042a0c15d094d0b8d18020d094d0b8d180d0bed0b2d0b8d187310d300b06035504050c0431323539310b30090603550406130255413113301106035504070c0ad09ed0b4d0b5d181d0b03117301506035504080c0ed09ed0b4d0b5d181d18cd0bad0b03081f23081c9060b2a862402010101010301013081b9307530070202010102010c020100042110bee3db6aea9e1f86578c45c12594ff942394a7d738f9187e6515017294f4ce01022100800000000000000000000000000000006759213af182e987d3e17714907d470d0421b60fd2d8dce8a93423c6101bca91c47a007e6c300b26cd556c9b0e7d20ef292a000440a9d6eb45f13c708280c4967b231f5eadf658eba4c037291d38d96bf025ca4e17f8e9720dc615b43a28975f0bc1dea36438b564ea2c179fd0123e6db8fac5790403240004215869fc50fc2b8e07bc779940ba002d79e08fba55b3560679580fb2a7cab3f95f00a38202fa308202f630290603551d0e042204204d0fb29c86aa18eea3a89eef34b84ab2bf8f3f928010767dd468bddaf7441527302b0603551d230424302280205b63d88375d92018cdb4b10eb9b6a5c69a59fd4327c671e3c1f53aeab02d6ade302f0603551d1004283026a011180f32303134303830383231303030305aa111180f32303135303830383231303030305a300e0603551d0f0101ff0404030206c030190603551d200101ff040f300d300b06092a8624020101010202300c0603551d130101ff04023000301e06082b060105050701030101ff040f300d300b06092a86240201010102013081810603551d11047a3078a035060c2b0601040181974601010402a0250c23d0b2d183d0bb2e20d0a1d0b5d180d182d0b8d184d196d0bad0b0d182d0bdd0b02c2033a01f060c2b0601040181974601010401a00f0c0d2b333830303831323334353637820c6961736e61702e6c6f63616c8110666f726d61743132406d6574612e756130410603551d1f043a30383036a034a0328630687474703a2f2f63612e6969742e636f6d2e75612f646f776e6c6f61642f63726c732f434131332d46756c6c2e63726c30420603551d2e043b30393037a035a0338631687474703a2f2f63612e6969742e636f6d2e75612f646f776e6c6f61642f63726c732f434131332d44656c74612e63726c30818106082b0601050507010104753073302f06082b060105050730018623687474703a2f2f63612e6969742e636f6d2e75612f73657276696365732f6f6373702f304006082b060105050730028634687474703a2f2f63612e6969742e636f6d2e75612f646f776e6c6f61642f6365727469666963617465732f63616969742e703762303e06082b0601050507010b04323030302e06082b060105050730038622687474703a2f2f63612e6969742e636f6d2e75612f73657276696365732f7473702f30430603551d09043c303a301a060c2a8624020101010b01040201310a13083939383736353430301c060c2a8624020101010b01040101310c130a39393837363534333231300d060b2a862402010101010301010343000440c61a79035d4ef320eb20a1be8c19e7bc8ecfdef485f00180a3262cb2e9b66206bc1ac6b4bda3b092360149d34316e9aaaac7bb95e9dc39ac4373de0035c5a942, 0, 3),
(6, 0, 'O=Інформаційно-довідковий департамент Міндоходів;OU=Управління (Центр) сертифікації ключів ІДД Міндоходів;CN=Акредитований центр сертифікації ключів ІДД Міндоходів;Serial=UA-38725930;C=UA;L=Київ', '3EEE524F3BA9E8BB04000000490B1900CB222C00', '3255919016', '3255919016', 0x30820748308206f0a00302010202143eee524f3ba9e8bb04000000490b1900cb222c00300d060b2a862402010101010301013082017a31623060060355040a0c59d086d0bdd184d0bed180d0bcd0b0d186d196d0b9d0bdd0be2dd0b4d0bed0b2d196d0b4d0bad0bed0b2d0b8d0b920d0b4d0b5d0bfd0b0d180d182d0b0d0bcd0b5d0bdd18220d09cd196d0bdd0b4d0bed185d0bed0b4d196d0b2316c306a060355040b0c63d0a3d0bfd180d0b0d0b2d0bbd196d0bdd0bdd18f2028d0a6d0b5d0bdd182d1802920d181d0b5d180d182d0b8d184d196d0bad0b0d186d196d19720d0bad0bbd18ed187d196d0b220d086d094d09420d09cd196d0bdd0b4d0bed185d0bed0b4d196d0b23170306e06035504030c67d090d0bad180d0b5d0b4d0b8d182d0bed0b2d0b0d0bdd0b8d0b920d186d0b5d0bdd182d18020d181d0b5d180d182d0b8d184d196d0bad0b0d186d196d19720d0bad0bbd18ed187d196d0b220d086d094d09420d09cd196d0bdd0b4d0bed185d0bed0b4d196d0b23114301206035504050c0b55412d3338373235393330310b30090603550406130255413111300f06035504070c08d09ad0b8d197d0b2301e170d3134313031343231303030305a170d3136313031343231303030305a3082012c31223020060355040a0c19d0a4d196d0b7d0b8d187d0bdd0b020d0bed181d0bed0b1d0b031223020060355040b0c19d0a4d196d0b7d0b8d187d0bdd0b020d0bed181d0bed0b1d0b0311d301b060355040c0c14d0bfd196d0b4d0bfd0b8d181d183d0b2d0b0d1873135303306035504030c2cd09ad0bed0bfd0b8d182d196d0bd20d0aed180d196d0b920d092d196d0bad182d0bed180d0bed0b2d0b8d1873117301506035504040c0ed09ad0bed0bfd0b8d182d196d0bd31263024060355042a0c1dd0aed180d196d0b920d092d196d0bad182d0bed180d0bed0b2d0b8d1873110300e06035504050c0731363431323839310b30090603550406130255413113301106035504070c0ad09ed0b4d0b5d181d0b03117301506035504080c0ed09ed0b4d0b5d181d18cd0bad0b03081f23081c9060b2a862402010101010301013081b9307530070202010102010c020100042110bee3db6aea9e1f86578c45c12594ff942394a7d738f9187e6515017294f4ce01022100800000000000000000000000000000006759213af182e987d3e17714907d470d0421b60fd2d8dce8a93423c6101bca91c47a007e6c300b26cd556c9b0e7d20ef292a000440a9d6eb45f13c708280c4967b231f5eadf658eba4c037291d38d96bf025ca4e17f8e9720dc615b43a28975f0bc1dea36438b564ea2c179fd0123e6db8fac5790403240004211c4547f7fdef0756fc43736d61742eb2333226e2e2aa4f33cb354ecc91d806c100a38202ff308202fb30290603551d0e04220420ea78a910736cf8697895364de59cad481ffc595d49f7c3c40ff3afaab9d60657302b0603551d230424302280203eee524f3ba9e8bb43bddc35ddaa4692f1aab03306d6972e18cdfe55034458a9302f0603551d1004283026a011180f32303134313031343231303030305aa111180f32303136313031343231303030305a300e0603551d0f0101ff0404030206c030190603551d200101ff040f300d300b06092a8624020101010202300c0603551d130101ff04023000301e06082b060105050701030101ff040f300d300b06092a8624020101010201306d0603551d1104663064a01f060c2b0601040181974601010402a00f0c0d28303933292030373930383035a028060c2b0601040181974601010401a0180c16796b6f706974696e406f64657373612e676f762e7561a017060a2b060104018237140203a0090c07d0a030312d363730490603551d1f04423040303ea03ca03a8638687474703a2f2f6163736b6964642e676f762e75612f646f776e6c6f61642f63726c732f43412d33454545353234462d46756c6c2e63726c304a0603551d2e04433041303fa03da03b8639687474703a2f2f6163736b6964642e676f762e75612f646f776e6c6f61642f63726c732f43412d33454545353234462d44656c74612e63726c30818806082b06010505070101047c307a303006082b060105050730018624687474703a2f2f6163736b6964642e676f762e75612f73657276696365732f6f6373702f304606082b06010505073002863a687474703a2f2f6163736b6964642e676f762e75612f646f776e6c6f61642f6365727469666963617465732f616c6c6163736b6964642e703762303f06082b0601050507010b04333031302f06082b060105050730038623687474703a2f2f6163736b6964642e676f762e75612f73657276696365732f7473702f30450603551d09043e303c301c060c2a8624020101010b01040201310c130a33323535393139303136301c060c2a8624020101010b01040101310c130a33323535393139303136300d060b2a86240201010101030101034300044089acb3d3975bd206033427d9111fff0a73f8c5d1e1c4d32f03e4a02d0208e26f04bae1483ec716d4ec48a31c2467d4ecd08241f4b879d441b44ba9cc68a00852, 0, 16);

-- --------------------------------------------------------

--
-- Структура таблицы `cab_user_external`
--

DROP TABLE IF EXISTS `cab_user_external`;
CREATE TABLE IF NOT EXISTS `cab_user_external` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `type_of_user` tinyint(3) unsigned NOT NULL COMMENT 'Тип користувача (0-фіз.особа, 1- ФОП, 2-юр.особа)',
  `fio` varchar(100) NOT NULL COMMENT 'ПІБ',
  `organization` varchar(100) NOT NULL DEFAULT 'фізична особа' COMMENT 'Організація',
  `email` varchar(45) NOT NULL COMMENT 'Електронна поштова скринька',
  `phone` varchar(12) NOT NULL COMMENT 'Мобільний телефон',
  `cab_state` enum('не активований','активований','блокований') NOT NULL COMMENT 'Стан кабінету',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `phone_UNIQUE` (`phone`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Каталог зовнішніх користувачів порталу»' AUTO_INCREMENT=4 ;

--
-- Дамп данных таблицы `cab_user_external`
--

INSERT INTO `cab_user_external` (`id`, `type_of_user`, `fio`, `organization`, `email`, `phone`, `cab_state`) VALUES
(1, 0, 'Молодший Дир Дирович', 'фізична особа', 'format12@meta.ua', '380681234567', 'активований'),
(3, 0, 'Молодший Дир Дирович', 'фізична особа', 'email@email.em', '0639876543', 'не активований');

-- --------------------------------------------------------

--
-- Структура таблицы `cab_user_files_in`
--

DROP TABLE IF EXISTS `cab_user_files_in`;
CREATE TABLE IF NOT EXISTS `cab_user_files_in` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_bid_id` int(11) unsigned NOT NULL COMMENT 'ID заявки користувача',
  `content` mediumblob NOT NULL COMMENT 'Вміст файлу',
  `extension` varchar(5) NOT NULL COMMENT 'Розширення файлу',
  `state` tinyint(4) NOT NULL COMMENT '0-оброблені, 1-не оброблені',
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата та час додавання',
  PRIMARY KEY (`id`),
  KEY `fk_bid_out` (`user_bid_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Вхідні файли заявок' AUTO_INCREMENT=2 ;

--
-- Дамп данных таблицы `cab_user_files_in`
--

INSERT INTO `cab_user_files_in` (`id`, `user_bid_id`, `content`, `extension`, `state`, `date`) VALUES
(1, 2, '', 'docx', 1, '2014-09-22 20:35:44');

-- --------------------------------------------------------

--
-- Структура таблицы `cab_user_files_out`
--

DROP TABLE IF EXISTS `cab_user_files_out`;
CREATE TABLE IF NOT EXISTS `cab_user_files_out` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_bid_id` int(11) unsigned NOT NULL COMMENT 'ID заявки',
  `content` mediumblob NOT NULL COMMENT 'Вміст файлу',
  `extension` varchar(5) NOT NULL COMMENT 'Розширення файлу',
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата та час додавання',
  PRIMARY KEY (`id`),
  KEY `fk_bid_out` (`user_bid_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Вихідні файли заявок' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Структура таблицы `cab_user_gen_str`
--

DROP TABLE IF EXISTS `cab_user_gen_str`;
CREATE TABLE IF NOT EXISTS `cab_user_gen_str` (
  `sauth` varchar(40) NOT NULL COMMENT 'Строка авторизації',
  `itime` int(11) NOT NULL COMMENT 'час авторизації',
  PRIMARY KEY (`sauth`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Генеровані строки авторизації';

--
-- Дамп данных таблицы `cab_user_gen_str`
--

INSERT INTO `cab_user_gen_str` (`sauth`, `itime`) VALUES
('xf[ARoaMKLbe+IEH]6CSK+TxEXx1MNY.UOnp5n4t', 1413915909);

-- --------------------------------------------------------

--
-- Структура таблицы `cab_user_intern_certs`
--

DROP TABLE IF EXISTS `cab_user_intern_certs`;
CREATE TABLE IF NOT EXISTS `cab_user_intern_certs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `certissuer` text NOT NULL COMMENT 'Власник сертифікату',
  `certserial` varchar(40) NOT NULL COMMENT 'Серійний номер сертифікату',
  `certSubjDRFOCode` varchar(10) NOT NULL COMMENT 'Код ДРФО',
  `certSubjEDRPOUCode` varchar(10) DEFAULT NULL COMMENT 'Код ЄДРПОУ',
  `certData` mediumblob NOT NULL COMMENT 'Вміст сертифікату',
  `certType` tinyint(3) unsigned NOT NULL COMMENT 'Тип ЕЦП/шифрування',
  `signedData` varchar(40) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Сертифікати внутрішніх користувачів»' AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Структура таблицы `cab_user_internal`
--

DROP TABLE IF EXISTS `cab_user_internal`;
CREATE TABLE IF NOT EXISTS `cab_user_internal` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `authorities_id` smallint(5) unsigned NOT NULL COMMENT 'ID органу',
  `user_roles_id` tinyint(3) unsigned NOT NULL COMMENT 'ID ролі користувача',
  `cab_state` enum('активований','блокований') NOT NULL COMMENT 'стан кабінету',
  PRIMARY KEY (`id`),
  KEY `role_id_idx` (`user_roles_id`),
  KEY `author_id_idx` (`authorities_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Таблиця «Каталог внутрішніх користувачів порталу»' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Структура таблицы `cab_user_roles`
--

DROP TABLE IF EXISTS `cab_user_roles`;
CREATE TABLE IF NOT EXISTS `cab_user_roles` (
  `id` tinyint(3) unsigned NOT NULL COMMENT '№ з/п',
  `user_role` varchar(30) NOT NULL COMMENT 'Назва ролі',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Таблиця «Каталог ролі користувачів»';

--
-- Дамп данных таблицы `cab_user_roles`
--

INSERT INTO `cab_user_roles` (`id`, `user_role`) VALUES
(0, 'Адміністратор безпеки'),
(1, 'Адміністратор системи'),
(2, 'Адміністратор ЦНАП'),
(3, 'Відповідальна особа СНАП'),
(4, 'Суб''єкт звернення'),
(5, 'Зовнішній відвідувач');

-- --------------------------------------------------------

--
-- Структура таблицы `ff_backcommentguide`
--

DROP TABLE IF EXISTS `ff_backcommentguide`;
CREATE TABLE IF NOT EXISTS `ff_backcommentguide` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '6',
  `storage` int(11) DEFAULT NULL,
  `ref_id` bigint(20) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `ff_backonelineguide`
--

DROP TABLE IF EXISTS `ff_backonelineguide`;
CREATE TABLE IF NOT EXISTS `ff_backonelineguide` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '5',
  `storage` int(11) DEFAULT NULL,
  `ref_id` bigint(20) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `ff_backrecords`
--

DROP TABLE IF EXISTS `ff_backrecords`;
CREATE TABLE IF NOT EXISTS `ff_backrecords` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '4',
  `storage` int(11) DEFAULT NULL,
  `ref_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `ff_basedocument`
--

DROP TABLE IF EXISTS `ff_basedocument`;
CREATE TABLE IF NOT EXISTS `ff_basedocument` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '8',
  `storage` int(11) DEFAULT NULL,
  `createdate` datetime DEFAULT NULL,
  `updatedate` datetime DEFAULT NULL,
  `createuser` int(11) DEFAULT NULL,
  `updateuser` int(11) DEFAULT NULL,
  `regnum` varchar(255) DEFAULT NULL,
  `regdate` date DEFAULT NULL,
  `context` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `ff_basedocument`
--

INSERT INTO `ff_basedocument` (`id`, `registry`, `storage`, `createdate`, `updatedate`, `createuser`, `updateuser`, `regnum`, `regdate`, `context`) VALUES
(14, 11, 1, NULL, NULL, NULL, NULL, '1', '2014-10-21', 'Первый документ');

-- --------------------------------------------------------

--
-- Структура таблицы `ff_baserecord`
--

DROP TABLE IF EXISTS `ff_baserecord`;
CREATE TABLE IF NOT EXISTS `ff_baserecord` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '7',
  `storage` int(11) DEFAULT NULL,
  `createdate` datetime DEFAULT NULL,
  `updatedate` datetime DEFAULT NULL,
  `createuser` int(11) DEFAULT NULL,
  `updateuser` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `ff_baserecord`
--

INSERT INTO `ff_baserecord` (`id`, `registry`, `storage`, `createdate`, `updatedate`, `createuser`, `updateuser`) VALUES
(12, 9, 4, NULL, NULL, NULL, NULL),
(13, 9, 5, NULL, NULL, NULL, NULL),
(14, 11, 1, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `ff_commentline`
--

DROP TABLE IF EXISTS `ff_commentline`;
CREATE TABLE IF NOT EXISTS `ff_commentline` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '3',
  `storage` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `ff_default`
--

DROP TABLE IF EXISTS `ff_default`;
CREATE TABLE IF NOT EXISTS `ff_default` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `registry` int(11) NOT NULL COMMENT 'Ссылка на регистрацию(таблица которой принадлижит запись)',
  `storage` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_REGISTRY_idx` (`registry`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Корневая родительская форма. Ее наследуют все другие таблицы сформированые при помощи свободных форм ' AUTO_INCREMENT=15 ;

--
-- Дамп данных таблицы `ff_default`
--

INSERT INTO `ff_default` (`id`, `registry`, `storage`) VALUES
(1, 2, 3),
(2, 2, 3),
(3, 2, 3),
(4, 2, 2),
(5, 2, 2),
(6, 2, 6),
(7, 2, 6),
(8, 2, 6),
(9, 2, 6),
(10, 2, 6),
(11, 2, 6),
(12, 9, 4),
(13, 9, 5),
(14, 11, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `ff_document_demo`
--

DROP TABLE IF EXISTS `ff_document_demo`;
CREATE TABLE IF NOT EXISTS `ff_document_demo` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '11',
  `storage` int(11) DEFAULT NULL,
  `createdate` datetime DEFAULT NULL,
  `updatedate` datetime DEFAULT NULL,
  `createuser` int(11) DEFAULT NULL,
  `updateuser` int(11) DEFAULT NULL,
  `regnum` varchar(255) DEFAULT NULL,
  `regdate` date DEFAULT NULL,
  `context` text,
  `delivery` int(11) DEFAULT NULL,
  `legal_personality` int(11) DEFAULT NULL,
  `organization_id` int(11) DEFAULT NULL,
  `persona_of_organization` int(11) DEFAULT NULL,
  `file` longblob,
  `file_filetype` varchar(55) DEFAULT NULL,
  `file_filename` varchar(255) DEFAULT NULL,
  `image` mediumblob,
  `method_of_reply` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `ff_document_demo`
--

INSERT INTO `ff_document_demo` (`id`, `registry`, `storage`, `createdate`, `updatedate`, `createuser`, `updateuser`, `regnum`, `regdate`, `context`, `delivery`, `legal_personality`, `organization_id`, `persona_of_organization`, `file`, `file_filetype`, `file_filename`, `image`, `method_of_reply`) VALUES

-- --------------------------------------------------------

--
-- Структура таблицы `ff_field`
--

DROP TABLE IF EXISTS `ff_field`;
CREATE TABLE IF NOT EXISTS `ff_field` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `formid` int(11) DEFAULT '1' COMMENT 'Ссылка на свободную форму',
  `name` varchar(255) NOT NULL COMMENT 'Имя поля свободнеой формы',
  `type` int(11) DEFAULT NULL COMMENT 'Тип поля в  свободной форме',
  `description` tinytext COMMENT 'Описание / назначение поля',
  `order` int(10) NOT NULL DEFAULT '0' COMMENT 'Порядок отображения полей. При 0 поле скрытое',
  `protected` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Блокировка для защиты от несанкционированного удаления и/или изменения поля',
  PRIMARY KEY (`id`),
  KEY `id_idx` (`formid`),
  KEY `FK_TYPE_idx` (`type`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Список полей подключенных в свобных формах' AUTO_INCREMENT=93 ;

--
-- Дамп данных таблицы `ff_field`
--

INSERT INTO `ff_field` (`id`, `formid`, `name`, `type`, `description`, `order`, `protected`) VALUES
(1, 1, 'registry', 2, NULL, 0, 1),
(2, 1, 'storage', 2, NULL, 0, 1),
(3, 2, 'registry', 2, NULL, 0, 1),
(4, 2, 'storage', 2, NULL, 0, 1),
(6, 3, 'registry', 2, NULL, 0, 1),
(7, 3, 'storage', 2, NULL, 0, 1),
(9, 4, 'registry', 2, NULL, 0, 1),
(10, 4, 'storage', 2, NULL, 0, 1),
(12, 2, 'name', 1, 'Название', 1, 0),
(13, 3, 'name', 1, 'Название', 1, 1),
(14, 3, 'comment', 4, 'Комментарий', 2, 0),
(15, 5, 'registry', 2, NULL, 0, 1),
(16, 5, 'storage', 2, NULL, 0, 1),
(18, 6, 'registry', 2, NULL, 0, 1),
(19, 6, 'storage', 2, NULL, 0, 1),
(21, 4, 'ref_id', 5, 'Обратная ссылка', 0, 0),
(22, 5, 'ref_id', 5, 'Обратная ссылка', 0, 1),
(23, 6, 'ref_id', 5, 'Обратная ссылка', 0, 1),
(25, 5, 'name', 1, 'Название', 1, 0),
(26, 6, 'name', 1, 'Название', 1, 1),
(27, 6, 'comment', 4, 'Комментарий', 2, 0),
(28, 7, 'registry', 2, NULL, 0, 1),
(29, 7, 'storage', 2, NULL, 0, 1),
(31, 7, 'createdate', 7, 'Дата и время создания записи', 0, 0),
(32, 7, 'updatedate', 7, 'Дата и время последнего обновления', 0, 0),
(33, 7, 'createuser', 2, 'Пользователь создавший запись', 0, 0),
(34, 7, 'updateuser', 2, 'Пользователь выполнивший последнее обновление', 0, 0),
(35, 8, 'registry', 2, NULL, 0, 1),
(36, 8, 'storage', 2, NULL, 0, 1),
(37, 8, 'createdate', 7, 'Дата и время создания записи', 0, 1),
(38, 8, 'updatedate', 7, 'Дата и время последнего обновления', 0, 1),
(39, 8, 'createuser', 2, 'Пользователь создавший запись', 0, 1),
(40, 8, 'updateuser', 2, 'Пользователь выполнивший последнее обновление', 0, 1),
(42, 8, 'regnum', 1, 'Регистрационный номер', 100, 0),
(43, 8, 'regdate', 3, 'Дата регистрации документа', 200, 0),
(44, 8, 'context', 4, 'Содержание документа', 300, 0),
(45, 9, 'registry', 2, NULL, 0, 1),
(46, 9, 'storage', 2, NULL, 0, 1),
(47, 9, 'createdate', 7, 'Дата и время создания записи', 0, 1),
(48, 9, 'updatedate', 7, 'Дата и время последнего обновления', 0, 1),
(49, 9, 'createuser', 2, 'Пользователь создавший запись', 0, 1),
(50, 9, 'updateuser', 2, 'Пользователь выполнивший последнее обновление', 0, 1),
(52, 9, 'name', 1, 'Название организации', 1, 0),
(53, 9, 'edrpou', 5, 'Код ЄДРПОУ', 2, 0),
(54, 10, 'registry', 2, NULL, 0, 1),
(55, 10, 'storage', 2, NULL, 0, 1),
(56, 10, 'createdate', 7, 'Дата и время создания записи', 0, 1),
(57, 10, 'updatedate', 7, 'Дата и время последнего обновления', 0, 1),
(58, 10, 'createuser', 2, 'Пользователь создавший запись', 0, 1),
(59, 10, 'updateuser', 2, 'Пользователь выполнивший последнее обновление', 0, 1),
(61, 10, 'surname', 1, 'Прізвище', 1, 0),
(62, 10, 'name', 1, 'Им''я', 2, 0),
(63, 10, 'middlename', 1, 'по-Батькові', 3, 0),
(64, 10, 'address', 1, 'Адреса', 4, 0),
(65, 11, 'registry', 2, NULL, 0, 1),
(66, 11, 'storage', 2, NULL, 0, 1),
(67, 11, 'createdate', 7, 'Дата и время создания записи', 0, 1),
(68, 11, 'updatedate', 7, 'Дата и время последнего обновления', 0, 1),
(69, 11, 'createuser', 2, 'Пользователь создавший запись', 0, 1),
(70, 11, 'updateuser', 2, 'Пользователь выполнивший последнее обновление', 0, 1),
(71, 11, 'regnum', 1, 'Регистрационный номер', 1, 1),
(72, 11, 'regdate', 3, 'Дата регистрации документа', 2, 1),
(73, 11, 'context', 4, 'Содержание документа', 3, 1),
(80, 11, 'delivery', 1001, 'Метод доставки', 4, 0),
(81, 11, 'legal_personality', 1002, 'Форма права', 5, 0),
(82, 11, 'organization_id', 1003, 'Организация', 6, 0),
(85, 11, 'file', 10, 'Прикрепленный файл', 9, 0),
(86, 11, 'file_filetype', 11, 'Прикрепленный файл - MIME Тип', 0, 1),
(87, 11, 'file_filename', 12, 'Прикрепленный файл - Имя файла', 0, 1),
(89, 11, 'barcode', 8, 'Штрихкод', 1, 0),
(90, 11, 'image', 9, 'Фотография', 8, 0),
(91, 11, 'method_of_reply', 1005, 'Получение ответа', 10, 0),
(92, 11, 'initeds', 13, '.Инициализация ЭЦП', 1, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `ff_langaliace`
--

DROP TABLE IF EXISTS `ff_langaliace`;
CREATE TABLE IF NOT EXISTS `ff_langaliace` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lang` varchar(15) NOT NULL DEFAULT 'russian' COMMENT 'Язык на котором публикуется надпись',
  `idreference` int(11) NOT NULL COMMENT 'Ссылка на ресурс требующий перевода',
  `category` int(11) NOT NULL COMMENT 'Категория ресурса, поле, хранилище,...',
  `caption` varchar(255) NOT NULL COMMENT 'Перевод названия ресурса',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Переводы содержи' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `ff_listtables`
--
DROP VIEW IF EXISTS `ff_listtables`;
CREATE TABLE IF NOT EXISTS `ff_listtables` (
`TABLE_NAME` varchar(64)
);
-- --------------------------------------------------------

--
-- Структура таблицы `ff_oneline`
--

DROP TABLE IF EXISTS `ff_oneline`;
CREATE TABLE IF NOT EXISTS `ff_oneline` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '2',
  `storage` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `ff_oneline`
--

INSERT INTO `ff_oneline` (`id`, `registry`, `storage`, `name`) VALUES
(1, 2, 3, 'Фізична особа'),
(2, 2, 3, 'Фізична особа - підприємець'),
(3, 2, 3, 'Юридична особа'),
(4, 2, 2, 'Пошта'),
(5, 2, 2, 'Особисто'),
(6, 2, 6, 'Лично'),
(7, 2, 6, 'Пошта'),
(8, 2, 6, 'EMail'),
(9, 2, 6, 'Факс'),
(10, 2, 6, 'Телефон'),
(11, 2, 6, 'Куръер');

-- --------------------------------------------------------

--
-- Структура таблицы `ff_organization`
--

DROP TABLE IF EXISTS `ff_organization`;
CREATE TABLE IF NOT EXISTS `ff_organization` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '9',
  `storage` int(11) DEFAULT NULL,
  `createdate` datetime DEFAULT NULL,
  `updatedate` datetime DEFAULT NULL,
  `createuser` int(11) DEFAULT NULL,
  `updateuser` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `edrpou` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `ff_organization`
--

INSERT INTO `ff_organization` (`id`, `registry`, `storage`, `createdate`, `updatedate`, `createuser`, `updateuser`, `name`, `edrpou`) VALUES
(12, 9, 4, NULL, NULL, NULL, NULL, 'ООО Ромашка', 123),
(13, 9, 5, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `ff_person`
--

DROP TABLE IF EXISTS `ff_person`;
CREATE TABLE IF NOT EXISTS `ff_person` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '10',
  `storage` int(11) DEFAULT NULL,
  `createdate` datetime DEFAULT NULL,
  `updatedate` datetime DEFAULT NULL,
  `createuser` int(11) DEFAULT NULL,
  `updateuser` int(11) DEFAULT NULL,
  `surname` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `middlename` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `ff_registry`
--

DROP TABLE IF EXISTS `ff_registry`;
CREATE TABLE IF NOT EXISTS `ff_registry` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent` int(11) DEFAULT NULL COMMENT 'ссылка на родителя',
  `tablename` varchar(45) NOT NULL COMMENT 'Имя таблицы в которая используется для хранения данных свободной формы',
  `description` tinytext COMMENT 'описание',
  `protected` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Блокировка/ системная таблица',
  `attaching` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'равен 1 если таблица создана не методами свободных форм',
  `copying` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'При 1 потомки копируют свои значения в эту таблицу',
  `view` varchar(255) DEFAULT NULL COMMENT 'Зарезирвированно, предполагается через этот параметр подключать разные формы отображения документов',
  PRIMARY KEY (`id`),
  UNIQUE KEY `table_UNIQUE` (`tablename`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Список зарегистрированных свободных форм' AUTO_INCREMENT=12 ;

--
-- Дамп данных таблицы `ff_registry`
--

INSERT INTO `ff_registry` (`id`, `parent`, `tablename`, `description`, `protected`, `attaching`, `copying`, `view`) VALUES
(1, NULL, 'default', NULL, 1, 0, 1, NULL),
(2, 1, 'oneline', 'Однострочный справочник', 0, 0, 1, NULL),
(3, 2, 'commentline', 'Однострочный справочник с комментированием', 0, 0, 1, NULL),
(4, 1, 'backrecords', 'Элемент с обратной связью', 0, 0, 1, NULL),
(5, 4, 'backonelineguide', 'Однострочный справочник с обратной связью', 0, 0, 1, NULL),
(6, 5, 'backcommentguide', 'Справочник название с комментирование, с обратной связью', 0, 0, 1, NULL),
(7, 1, 'baserecord', 'Базовая запись с контролем дат создания и последнего изменения', 0, 0, 1, NULL),
(8, 7, 'basedocument', 'Начальный документ', 0, 0, 1, NULL),
(9, 7, 'organization', 'Организация', 0, 0, 0, NULL),
(10, 7, 'person', 'Громадянин', 0, 0, 0, NULL),
(11, 8, 'document_demo', 'Документ для тестирования возможностей подсистемы свободных форм', 0, 0, 0, NULL);

--
-- Триггеры `ff_registry`
--
DROP TRIGGER IF EXISTS `ff_registry_AD`;
DELIMITER //
CREATE TRIGGER `ff_registry_AD` AFTER DELETE ON `ff_registry`
 FOR EACH ROW begin
	if (@disable_triggers is null) then
		delete from `ff_registry_h` where `owner`= old.id;		
	end if;
end
//
DELIMITER ;
DROP TRIGGER IF EXISTS `ff_registry_AI`;
DELIMITER //
CREATE TRIGGER `ff_registry_AI` AFTER INSERT ON `ff_registry`
 FOR EACH ROW begin
	if (@disable_triggers is null) and (new.attaching=0) then
		-- Генерация иерархической истории
		insert into `ff_registry_h` (`owner`,`parent`)
			select new.id, `parent` from `ff_registry_h`
			where `owner`=new.parent;
		insert into `ff_registry_h` (`owner`,`parent`)
			values (new.id, new.parent);		
	end if;
end
//
DELIMITER ;
DROP TRIGGER IF EXISTS `ff_registry_BI`;
DELIMITER //
CREATE TRIGGER `ff_registry_BI` BEFORE INSERT ON `ff_registry`
 FOR EACH ROW begin
	if (@disable_triggers is null) then
		-- Установка идентификатора
		if (new.parent is null) and (new.attaching=0) then 
			set new.parent = 1;
		end if;		
	end if;
end
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `ff_registry_h`
--

DROP TABLE IF EXISTS `ff_registry_h`;
CREATE TABLE IF NOT EXISTS `ff_registry_h` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` int(11) NOT NULL COMMENT 'Основная таблица',
  `parent` int(11) NOT NULL COMMENT 'Родители основной талицы',
  PRIMARY KEY (`id`),
  KEY `fk_parent_idx` (`parent`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Иерархия(вспомогательная таблиц' AUTO_INCREMENT=22 ;

--
-- Дамп данных таблицы `ff_registry_h`
--

INSERT INTO `ff_registry_h` (`id`, `owner`, `parent`) VALUES
(1, 2, 1),
(2, 3, 1),
(3, 3, 2),
(4, 4, 1),
(5, 5, 1),
(6, 5, 4),
(7, 6, 1),
(8, 6, 4),
(10, 6, 5),
(11, 7, 1),
(12, 8, 1),
(13, 8, 7),
(14, 9, 1),
(15, 9, 7),
(16, 10, 1),
(17, 10, 7),
(18, 11, 1),
(19, 11, 7),
(21, 11, 8);

-- --------------------------------------------------------

--
-- Структура таблицы `ff_registry_storage`
--

DROP TABLE IF EXISTS `ff_registry_storage`;
CREATE TABLE IF NOT EXISTS `ff_registry_storage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `registry` int(11) NOT NULL COMMENT 'Ссылка на регистрацию свободной формы',
  `storage` int(11) NOT NULL COMMENT 'Ссылка на хранилище в свободной форме',
  PRIMARY KEY (`id`),
  KEY `fk_registry_idx` (`registry`),
  KEY `fk_storage_idx` (`storage`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Привязка форм и хранилищ' AUTO_INCREMENT=7 ;

--
-- Дамп данных таблицы `ff_registry_storage`
--

INSERT INTO `ff_registry_storage` (`id`, `registry`, `storage`) VALUES
(1, 11, 1),
(2, 2, 3),
(3, 9, 4),
(4, 9, 5),
(5, 2, 2),
(6, 2, 6);

-- --------------------------------------------------------

--
-- Структура таблицы `ff_storage`
--

DROP TABLE IF EXISTS `ff_storage`;
CREATE TABLE IF NOT EXISTS `ff_storage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT 'Имя хранилища',
  `description` tinytext COMMENT 'Описание хранилища',
  `subtype` int(11) NOT NULL DEFAULT '0' COMMENT 'Подтип. Используется для отображения разных справочников',
  `type` int(11) DEFAULT NULL COMMENT 'Ссылка на таблицу типов',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Хранилище свободной формы' AUTO_INCREMENT=7 ;

--
-- Дамп данных таблицы `ff_storage`
--

INSERT INTO `ff_storage` (`id`, `name`, `description`, `subtype`, `type`) VALUES
(1, 'Сховище тестових документів', 'Сховище тестових документів', 0, 1000),
(2, 'метод доставки', '', 0, 1001),
(3, 'Форма права', 'Юр и физ лица', 3, 1002),
(4, 'Организации', 'Список организаций', 2, 1003),
(5, 'Представители', 'Физические лица - представители организации', 2, 1004),
(6, 'метод доставки ответа', '', 1, 1005);

--
-- Триггеры `ff_storage`
--
DROP TRIGGER IF EXISTS `ff_storage_BDEL`;
DELIMITER //
CREATE TRIGGER `ff_storage_BDEL` BEFORE DELETE ON `ff_storage`
 FOR EACH ROW begin
	if (@disable_triggers is null) then
    	DELETE FROM `ff_types` 
		where id=old.`type`;
    end if;
end
//
DELIMITER ;
DROP TRIGGER IF EXISTS `ff_storage_BUPD`;
DELIMITER //
CREATE TRIGGER `ff_storage_BUPD` BEFORE UPDATE ON `ff_storage`
 FOR EACH ROW begin
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
end
//
DELIMITER ;
DROP TRIGGER IF EXISTS `ff_storage_bins`;
DELIMITER //
CREATE TRIGGER `ff_storage_bins` BEFORE INSERT ON `ff_storage`
 FOR EACH ROW BEGIN
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
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `ff_types`
--

DROP TABLE IF EXISTS `ff_types`;
CREATE TABLE IF NOT EXISTS `ff_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `typename` varchar(255) NOT NULL COMMENT 'Имя типа отображаемого в свободной форме',
  `systemtype` varchar(255) DEFAULT NULL COMMENT 'Имя типа используемого для генерации таблиц',
  `view` varchar(255) DEFAULT NULL COMMENT 'Путь к визуальному представлению типа',
  `description` tinytext COMMENT 'Описание',
  `visible` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Признак отображения типа в списке типов',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Список зарегистрированных типов' AUTO_INCREMENT=1006 ;

--
-- Дамп данных таблицы `ff_types`
--

INSERT INTO `ff_types` (`id`, `typename`, `systemtype`, `view`, `description`, `visible`) VALUES
(1, 'Строка', 'VARCHAR(255)', NULL, 'Строка длиной 255 символов', 1),
(2, 'Число', 'INT(11)', NULL, 'Целое число', 1),
(3, 'Дата', 'DATE', 'date', 'Дата', 1),
(4, 'Текст', 'TEXT', 'textarea', 'Текст', 1),
(5, 'Большое число', 'BIGINT(20)', NULL, 'Большое целое число', 1),
(6, 'Логический', 'TINYINT(4)', 'checkbox', 'Галочка', 1),
(7, 'Дата и Время', 'DATETIME', 'datetime', 'Отображает дату и время', 1),
(8, 'Штрихкод EAN-13', NULL, 'barcode', 'Генерирует штрихкод по формату EAN-13', 1),
(9, 'Картинка', 'MEDIUMBLOB', 'image', 'Загружаемая картинка', 1),
(10, 'Файл', 'LONGBLOB', 'file', 'Загружаемый файл', 1),
(11, 'filetype', 'VARCHAR(55)', NULL, 'MIME-тип файла', 0),
(12, 'filename', 'VARCHAR(255)', NULL, 'Имя файла', 0),
(13, 'Инициализация ЭЦП', NULL, 'initsign', 'Если файлы в документе будут подписывать, то в документе должен присутствовать', 1),
(14, 'Файл с подписью', 'LONGBLOB', 'filesign', 'Данные файла с подписью', 1),
(15, 'fileedstype', 'VARCHAR(55)', NULL, 'MIME-тип файла', 0),
(16, 'fileedsname', 'VARCHAR(255)', NULL, 'Имя файла', 0),
(17, 'fileedssign', 'BLOB', NULL, 'Подпись файла', 0),
(1000, 'Сховище тестових документів', 'INT(11)', 'combobox', 'Сховище тестових документів', 1),
(1001, 'метод доставки', 'INT(11)', 'combobox', '', 1),
(1002, 'Форма права', 'INT(11)', 'radiobox', 'Юр и физ лица', 1),
(1003, 'Организации', 'INT(11)', 'innerguide', 'Список организаций', 1),
(1004, 'Представители', 'INT(11)', 'innerguide', 'Физические лица - представители организации', 1),
(1005, 'метод доставки ответа', 'INT(11)', 'listbox', '', 1);

-- --------------------------------------------------------

--
-- Структура таблицы `gen_authorities`
--

DROP TABLE IF EXISTS `gen_authorities`;
CREATE TABLE IF NOT EXISTS `gen_authorities` (
  `id` smallint(3) unsigned NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `is_cnap` enum('ЦНАП','СНАП') NOT NULL COMMENT 'Тип обєкта',
  `type` enum('обласний','районний','міський') NOT NULL COMMENT 'Приналежність',
  `name` varchar(255) NOT NULL COMMENT 'Назва органу',
  `locations_id` smallint(3) NOT NULL COMMENT 'ID населеного пункту',
  `index` varchar(5) NOT NULL COMMENT 'Індекс',
  `street` varchar(50) NOT NULL COMMENT 'Вулиця',
  `building` varchar(10) NOT NULL COMMENT 'Будинок №',
  `office` varchar(5) DEFAULT NULL COMMENT 'Кабінет',
  `working_time` varchar(1500) NOT NULL COMMENT 'Режим роботи',
  `phone` varchar(44) NOT NULL COMMENT 'Телефони',
  `fax` varchar(29) DEFAULT NULL COMMENT 'Факс',
  `email` varchar(45) DEFAULT NULL COMMENT 'Електронна скринька',
  `web` varchar(45) DEFAULT NULL COMMENT 'Веб-сайт',
  `transport` varchar(255) DEFAULT NULL COMMENT 'Міський транспорт',
  `gpscoordinates` varchar(20) DEFAULT NULL COMMENT 'GPS координати (наприклад, 46.483723, 30.729476)',
  `photo` varchar(255) DEFAULT NULL COMMENT 'Фотографія (посилання)',
  PRIMARY KEY (`id`),
  KEY `fk_locations` (`locations_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Відомості про центри та субєкти»' AUTO_INCREMENT=20 ;

--
-- Дамп данных таблицы `gen_authorities`
--

INSERT INTO `gen_authorities` (`id`, `is_cnap`, `type`, `name`, `locations_id`, `index`, `street`, `building`, `office`, `working_time`, `phone`, `fax`, `email`, `web`, `transport`, `gpscoordinates`, `photo`) VALUES
(1, 'ЦНАП', 'обласний', 'Центр надання адміністративних послуг Одеської міської ради ', 1, '65026', 'вул. Преображенська', '21', '', '<p>Понеділок, середа - з 09:00 до 18:00</p>\r\n\r\n<p>Вівторок, четвер - з 09:00 до 20:00</p>\r\n\r\n<p>П&#39;ятниця - з 09:00 до 16:45</p>\r\n\r\n<p>Субота - з 09:00 до 16:00 (без перерви)</p>\r\n', '720-70-21', '720-70-21', 'admin.center3@omr.odessa.ua', 'http://www.odessa.ua/ru/essential/5577/', '121 маршрутне таксі', '46.485169, 30.732369', ''),
(2, 'СНАП', 'обласний', 'Департамент  освіти і науки Одеської обласної державної адміністрації', 1, '65107', 'вул. Канатна', '83', NULL, '9.00-18.00', '776-20-56, 722-52-54', NULL, 'osvita@osvita.od.ua', 'http://osvita.odessa.gov.ua/', NULL, '46.465661, 30.746671', NULL),
(3, 'СНАП', 'обласний', 'Департамент розвитку інфраструктури та житлово-комунального господарства Одеської обласної державної адміністрації', 1, '65107', 'вул. Канатна', '83', '', '<p>Понеділок &mdash; четвер: 9.00-18.00</p>\r\n\r\n<p>П`ятниця: 9.00-16.45</p>\r\n', '32-87-01', '', 'oblgkh@odessa.gov.ua', 'http://oda.odessa.gov.ua/', '', '', ''),
(4, 'СНАП', 'міський', 'Управління  архітектури та містобудування  Одеської міської  ради', 1, '65026', 'вул. Гоголя', '10', '', '<p>Понеділок &ndash; четвер:</p>\r\n\r\n<p>з 9.00 до 18.00</p>\r\n\r\n<p>п&rsquo;ятниця:</p>\r\n\r\n<p>з&nbsp; 9.00 до 16.45</p>\r\n', '723-07-35', '729-74-29 ', 'mailto:uag_odessa@mail.ru', 'http://www.odessa.ua/departments/259', '', '', ''),
(5, 'СНАП', 'обласний', 'Департамент зовнішньоекономічної діяльності та європейської інтеграції Одеської обласної державної адміністрації', 1, '65032', 'просп. Шевченка ', '4', '', '<p>Понеділок четвер: 9.00-18.00; П`ятниця: 9.00-16.45</p>\r\n', 'тел/факс: 720-70-21 ', '', '', '', '', '', ''),
(6, 'СНАП', 'обласний', 'Управління культури і туризму, національностей та релігії Одеської обласної державної адміністрації', 1, '65017', 'Канатна', '83', '', '<p>Понеділок четвер: 9.00-18.00; П`ятниця: 9.00-16.45</p>\r\n', '(048) 722-04-15', '', '', 'http://culture.odessa.gov.ua/', '', '', ''),
(7, 'СНАП', 'обласний', 'Департамент екології та природних ресурсів Одеської обласної державної адміністрації', 1, '65032', 'Канатна, 83', '83', '', '<p>Понеділок четвер: 9.00-18.00; П`ятниця: 9.00-16.45</p>\r\n', '+38(048) 722-12-20', '+38(048) 776-01-81', 'colog@odessa.gov.ua', 'http://ecology.odessa.gov.ua', '', '', ''),
(8, 'СНАП', 'обласний', 'Департамент освіти і науки Одеської обласної державної адміністрації', 1, '65107', 'Канатна', '83', '', '<table align="right" cellpadding="0" cellspacing="0">\r\n	<tbody>\r\n		<tr>\r\n			<td>&nbsp;</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n\r\n<p>понеділок &ndash; четвер: з 9:00 до 18:00;&nbsp; п&rsquo;ятниця: з 9:00 до 16:45</p>\r\n', '(048) 722-87-80', '', 'osvita@osvita.od.ua', 'http://osvita.odessa.gov.ua/', '', '', ''),
(10, 'СНАП', 'обласний', 'Департамент економічного розвитку і торгівлі Одеської обласної державної адміністрації', 1, '65032', 'Шевченка', '4', '', '<p>Понеділок-четвер: 9.00-18.00</p>\r\n\r\n<p>П&rsquo;ятниця : 9.00-16:45</p>\r\n\r\n<p>Обідня перерва: 13.00-13.45</p>\r\n', '(048) 7186-467', '', '', '', '', '', ''),
(11, 'СНАП', 'обласний', 'Департамент агропромислового розвитку Одеської обласної державної адміністрації', 1, '65107', 'Канатна', '83', '', '<p>понеділок-п&#39;ятниця: 9.00-18.00</p>\r\n\r\n<p>обідня перерва: 13.00-14.00</p>\r\n', '(048) 37-79-35', '', '', '', '', '', ''),
(12, 'СНАП', 'обласний', 'Управління інформаційної діяльності Одеської обласної державної адміністрації', 1, '65032', 'Шевченка', '4', '', '<p>понеділок-п&#39;ятниця: 9.00-18.00</p>\r\n\r\n<p>обідня перерва: 13.00-14.00</p>\r\n', '(048) 718-95-26', '', 'press@odessa.gov.ua', 'http://uspi.odessa.gov.ua/', '', '', ''),
(13, 'СНАП', 'обласний', 'Управління охорони об’єктів культурної спадщини Одеської обласної державної адміністрації', 1, '0000', 'Троїцька', '43', '', '<p>Понеділок - четвер з 9:00 до 18:00</p>\r\n\r\n<p>П&#39;ятниця з 9:00 до 16:45</p>\r\n\r\n<p>Перерва з 13:00 до 13:45</p>\r\n', '(048) 722-22-78', '', 'nasledie@odessa.gov.ua  ', 'www.nasledie.odessa.gov.ua', '', '', ''),
(14, 'СНАП', 'обласний', 'Головне управління Державної Служби надзвичайних ситуацій України в Одеської області', 1, '65091', 'Прохорівська', '6', '', '<p>Понеділок - четвер:</p>\r\n\r\n<p>з 09:00 по 18:00</p>\r\n\r\n<p>п&rsquo;ятниця: з 09:00 по 16:45</p>\r\n\r\n<p>перерва: з 13:00 по 13:45</p>\r\n', '(048) 779-31-23', '(048) 779-31-23', 'odesa@mns.gov.ua', 'www.odesa.mns.gov.ua', '', '', ''),
(15, 'СНАП', 'обласний', 'Головне управління Держсанепідслужби в Одеській області', 1, '65029', 'Старопортофранківська', '8', '', '<p>Понеділок &ndash; П&rsquo;ятниця</p>\r\n\r\n<p>з 9.00 до 17.00 год.</p>\r\n', '(048) 723-48-42', '(048) 723-04-32', 'odesoblses@rambler.ru', 'http://www.oblses.odessa.ua', '', '', ''),
(16, 'СНАП', 'обласний', 'Інспекція державного архітектурно-будівельного контролю в Одеській області', 1, '65059', 'Адміральський пр-т', '33а', '', '<p>Понеділок &ndash; четвер з 9-00 до 18-00,</p>\r\n\r\n<p>п&rsquo;ятниця з 9-00 до 16-45,</p>\r\n\r\n<p>перерва з 13-00 до 13-45</p>\r\n', '(0482)34-79-58', '(0482)34-79-58', 'dabkodessa@ukr.net', 'http://dabkodessa.gov.ua', '', '', ''),
(17, 'СНАП', 'обласний', 'Головне управління юстиції в Одеській області', 1, '65012', 'Велика Арнаутська', '15', '', '<p>Понеділок &ndash; П&rsquo;ятниця&nbsp; з 9.00 год.&nbsp; по&nbsp; 20.00 год.&nbsp; &nbsp;</p>\r\n\r\n<p>Обідня&nbsp; перерва&nbsp; з 13.00 год. по 14.00 год.</p>\r\n', '(048)797–20–40', '', '', '', '', '', ''),
(18, 'СНАП', 'міський', 'Реєстраційна служба  Одеського міського управління юстиції', 1, '65036', 'вул. Старицького', '10А', '', '<p>З понеділка по четвер з 09.00 до 18.00,</p>\r\n\r\n<p>п&rsquo;ятниця з 09.00 до 16.45</p>\r\n\r\n<p>обідня перерва з 13.00 до 13.45</p>\r\n', '(048) 705-58-31', '(048) 705-58-33', '', 'www. rs-odessa.org.ua', '', '', ''),
(19, 'СНАП', 'обласний', 'Головне управління ДМС в Одеській області', 1, '65045', 'Преображенська', '44', '', '<p>Понеділок 09:00-18:00 Четвер 09:00-18:00<br />\r\nВівторок 09:00-18:00 П&#39;ятниця 09:00-16:45<br />\r\nСереда 09:00-18:00 Субота, Неділя вихідний</p>\r\n\r\n<p><em>Обідня перерва з 13:00 до 13:45</em></p>\r\n', '(048) 705-31-68', '', 'od@dmsu.gov.ua', 'od.dmsu.gov.ua', '', '', '');

-- --------------------------------------------------------

--
-- Структура таблицы `gen_bid_current_status`
--

DROP TABLE IF EXISTS `gen_bid_current_status`;
CREATE TABLE IF NOT EXISTS `gen_bid_current_status` (
  `id` int(10) unsigned NOT NULL,
  `bid_id` varchar(11) NOT NULL,
  `status_id` tinyint(4) unsigned NOT NULL COMMENT 'ID статуса обробки',
  `date_of_change` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Час зміни стутусу',
  PRIMARY KEY (`id`),
  UNIQUE KEY `bid_id_UNIQUE` (`bid_id`),
  KEY `curr_stat` (`status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Поточний статус обробки заявки (звонішній) еталон для bid_id';

--
-- Дамп данных таблицы `gen_bid_current_status`
--

INSERT INTO `gen_bid_current_status` (`id`, `bid_id`, `status_id`, `date_of_change`) VALUES
(2, 'qwe-asd-89w', 0, '2014-09-22 20:32:42');

-- --------------------------------------------------------

--
-- Структура таблицы `gen_cat_classes`
--

DROP TABLE IF EXISTS `gen_cat_classes`;
CREATE TABLE IF NOT EXISTS `gen_cat_classes` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `categorie_id` smallint(5) unsigned NOT NULL COMMENT 'ID послуги',
  `class_id` tinyint(3) unsigned NOT NULL COMMENT 'ID класу послуги',
  PRIMARY KEY (`id`),
  UNIQUE KEY `categorie_id` (`categorie_id`,`class_id`),
  KEY `serv_class_idx` (`categorie_id`),
  KEY `class_id_idx` (`class_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Звязок категорій з класами»' AUTO_INCREMENT=34 ;

--
-- Дамп данных таблицы `gen_cat_classes`
--

INSERT INTO `gen_cat_classes` (`id`, `categorie_id`, `class_id`) VALUES
(10, 2, 1),
(6, 2, 2),
(17, 3, 2),
(12, 4, 2),
(16, 6, 1),
(15, 6, 2),
(7, 9, 1),
(8, 9, 2),
(11, 10, 1),
(28, 10, 2),
(4, 11, 2),
(19, 12, 2),
(14, 14, 2),
(18, 15, 2),
(21, 22, 1),
(22, 23, 1),
(23, 24, 1),
(24, 25, 2),
(25, 26, 2),
(26, 27, 1),
(27, 27, 2),
(32, 28, 1),
(33, 28, 2);

-- --------------------------------------------------------

--
-- Структура таблицы `gen_interview_question`
--

DROP TABLE IF EXISTS `gen_interview_question`;
CREATE TABLE IF NOT EXISTS `gen_interview_question` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `question` varchar(255) NOT NULL COMMENT 'Поставлене питання',
  `is_active` tinyint(3) unsigned NOT NULL COMMENT '0-не відбуваеться 1-відбувається 2 - архівне',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Теми для опитування' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Структура таблицы `gen_interview_result`
--

DROP TABLE IF EXISTS `gen_interview_result`;
CREATE TABLE IF NOT EXISTS `gen_interview_result` (
  `id` smallint(5) unsigned NOT NULL,
  `question_id` smallint(6) unsigned NOT NULL COMMENT 'ID питання',
  `answer_name` varchar(100) NOT NULL COMMENT 'Варіант відповіді',
  `answer_count` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'кількість відповідей',
  PRIMARY KEY (`id`),
  KEY `question_id_idx` (`question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Результати опитування';

-- --------------------------------------------------------

--
-- Структура таблицы `gen_locations`
--

DROP TABLE IF EXISTS `gen_locations`;
CREATE TABLE IF NOT EXISTS `gen_locations` (
  `id` smallint(3) NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `type` enum('місто','смт.','село','селище') NOT NULL COMMENT 'Тип населеного пункту',
  `name` varchar(50) NOT NULL COMMENT 'Назва населеного пункту',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Відомості про населені пункти»' AUTO_INCREMENT=2 ;

--
-- Дамп данных таблицы `gen_locations`
--

INSERT INTO `gen_locations` (`id`, `type`, `name`) VALUES
(1, 'місто', 'Одеса');

-- --------------------------------------------------------

--
-- Структура таблицы `gen_menu_items`
--

DROP TABLE IF EXISTS `gen_menu_items`;
CREATE TABLE IF NOT EXISTS `gen_menu_items` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `content` varchar(45) NOT NULL COMMENT 'Назва пункту',
  `paderntid` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Породжений',
  `url` varchar(45) NOT NULL COMMENT 'URL',
  `ref` tinyint(3) unsigned NOT NULL COMMENT 'Послідовність',
  `visability` tinyint(3) unsigned NOT NULL COMMENT 'Видимість (0/1)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Пункти меню»' AUTO_INCREMENT=11 ;

--
-- Дамп данных таблицы `gen_menu_items`
--

INSERT INTO `gen_menu_items` (`id`, `content`, `paderntid`, `url`, `ref`, `visability`) VALUES
(1, 'Послуги', 0, 'http://allium2.soborka.net/iasnap/', 0, 1),
(2, 'Про центр', 0, '', 0, 1),
(3, 'Відслідкувати заявку', 0, '', 0, 1),
(4, 'Законодавство', 0, '', 0, 1),
(5, 'Допомога та підтримка', 0, '', 0, 1),
(6, 'е-ЦНАП', 2, '', 0, 1),
(7, 'Контакти центрів', 2, '', 0, 1),
(8, 'Текстові інструкції', 5, '', 0, 1),
(9, 'Відео інструкції', 5, '', 0, 1),
(10, 'Як отримати ЕЦП?', 5, '', 0, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `gen_news`
--

DROP TABLE IF EXISTS `gen_news`;
CREATE TABLE IF NOT EXISTS `gen_news` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `publicationDate` date NOT NULL COMMENT 'Дата публікації',
  `title` varchar(255) NOT NULL COMMENT 'Заголовок',
  `summary` text NOT NULL COMMENT 'Стислий опис новини',
  `text` mediumtext NOT NULL COMMENT 'Зміст новини',
  `img` varchar(255) NOT NULL COMMENT 'Посилання на зображення',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Управління новинами»' AUTO_INCREMENT=5 ;

--
-- Дамп данных таблицы `gen_news`
--

INSERT INTO `gen_news` (`id`, `publicationDate`, `title`, `summary`, `text`, `img`) VALUES
(2, '2014-08-26', 'Електронний цифровий підпис тепер можна замовити через пошту\r\n', 'Починаючи з листопада &laquo;Укрпошта&raquo; запровадила пілотний проект &laquo;Замовлення електронного цифрового підпису&raquo;.\r\n', 'Починаючи з листопада &laquo;Укрпошта&raquo; запровадила пілотний проект &laquo;Замовлення електронного цифрового підпису&raquo;. &laquo;Проект спрямований на спрощення доступу населення до безкоштовних послуг електронного цифрового підпису від Акредитованого центру сертифікації ключів Інформаційно-довідкового департаменту Міністерства доходів&raquo;, - наголошується в повідомленні Держпідприємства. Наразі пілотний проект впроваджений тільки в 70 відділеннях Донецької, Львівської та Київської областей. У цих відділеннях пошти підприємець-фізособа має можливість подати проект документів для отримання послуги електронного цифрового підпису, а співробітники &laquo;Укрпошти&raquo; передадуть їх безпосередньо до підрозділу Міндоходов, повідомив &laquo;Інтерфакс&raquo;. Раніше повідомлялося, що з 1 листопада &laquo;Укрпошта&raquo; приступила до надання 10 послуг з державної реєстрації бізнесу, нерухомості і актів цивільного стану. Такі послуги надаватимуть в 13,263 тис. відділеннях поштового зв&#39;язку по всій країні.\r\n', '<p>/iasnap/ckeditor/kcfinder/upload/images/sign%281%29.jpg</p>\r\n'),
(3, '2014-09-18', 'Онлайн-игра Particle Clicker - почувствуйте себя исследователем элементарных частиц!', 'В ходе прошедшего на днях в ЦЕРНе студенческого мероприятия CERN Summer Student Webfest группа студентов-энтузиастов написала с нуля простую, но симпатичную и затягивающую онлайн-игру Particle Clicker.', 'В ходе прошедшего на днях в ЦЕРНе студенческого мероприятия CERN Summer Student Webfest группа студентов-энтузиастов написала с нуля простую, но симпатичную и затягивающую онлайн-игру Particle Clicker. Игра позволяет погрузиться в мир исследователя элементарных частиц. Она в ненавязчивой форме дает вам возможность почувствовать себя пусть не ученым, но хотя бы менеджером физического эксперимента.\r\n\r\nКликните по игровому полю — и детектор начнет набирать статистику столкновений элементарных частиц. Накопив некоторый объем данных, вы можете проанализировать его. При этом вы открываете некоторое свойство частиц, а у вашего проекта повышается репутация. От репутации зависит финансирование проекта, оно позволяет вам нанимать для работы студентов, постдоков и даже нобелевских лауреатов. Ваша коллаборация растет, и каждый новый человек в команде повышает скорость набора данных — а значит, и темп новых открытий и исследований элементарных частиц. Вы также можете потратить накопленный бюджет на модернизацию детектора или на мероприятия по популяризации своих открытий — всё это тоже сказывается на эффективности работы.', 'http://particle-clicker.web.cern.ch/particle-clicker'),
(4, '2014-09-19', 'Близкие пульсары B0950+08 и В1919+21\r\n', '<p>Дальний рассеивающий слой находится, скорее всего, на внешней границе Местного пузыря (область разреженного газа внутри галактического рукава) на расстоянии 26&ndash;170 парсек, а ближний слой (4.4&ndash;16.4 парсек) находится на ионизированной поверхности молекулярного облака.</p>\r\n', '<p>Наземно-космический интерферометр РадиоАстрон в одном из первых экспериментов, 25 января 2012 года, зафиксировал интерференционный отклик от индивидуальных радиоимпульсов пульсара B0950+08 в диапазоне 92 см с максимального удаления космического радиотелескопа на 300,000 км. При этом проекция базы интерферометра в направлении на исследуемый объект составила 220,000 км, что обеспечило рекордное для метрового диапазона радиоволн угловое разрешение в одну тысячную секунды дуги. Наземное плечо интерферометра образовывали крупнейшие радиотелескопы в Аресибо (США), Вестерборке (Нидерланды) и Эффельсберге (Германия). В результате обработки данных и анализа результатов этой обработки оригинальным методом построения структурных функций получена информация о распределении межзвездной плазмы на луче зрения, которая рассеивает сигнал и вызывает его мерцания. Флуктуации сигнала имеют вид модуляции на уровне около 40%. Было показано, что к такой модуляции могла привести конфигурация плазмы на луче зрения в виде двух рассеивающих слоев и &ldquo;космической призмы&rdquo; &mdash; достаточно резкого градиента в распределении плазмы, отклоняющего радиоизлучение на углы 1.1-4.4 угловых миллисекунд. Дальний рассеивающий слой находится, скорее всего, на внешней границе Местного пузыря (область разреженного газа внутри галактического рукава) на расстоянии 26&ndash;170 парсек, а ближний слой (4.4&ndash;16.4 парсек) находится на ионизированной поверхности молекулярного облака. Спектр турбулентных флуктуаций плотности в обоих слоях следует степенному закону с показателями &gamma;1 = &gamma;2 = 3.00 &plusmn; 0.08, что отличается от колмогоровского спектра с &gamma; = 11/3. Эти результаты нельзя было бы получить при наблюдениях с поверхности Земли, так как зона Френеля при рефракции излучения пульсара превышает диаметр Земли. Результаты этого исследования опубликованы в международном научном журнале Astrophysical Journal (T.V. Smirnova, V.I. Shishov, M.V. Popov, C.R. Gwinn et al., 2014, ApJ, 786, 115): http://dx.doi.org/10.1088/0004-637X/786/2/115. Аналогичные результаты были недавно получены и для другого близкого пульсара В1919+21. Наблюдаемые параметры рассеяния радиоизлучения от этого пульсара также требуют введения двух эффективных экранов, расположенных на расстояниях 300 и 0.7 парсек от наблюдателя. Вновь получены указания на наличие &ldquo;космической призмы&rdquo;, расположенной на расстоянии 1.7 парсек и дающей рефракционное отклонение на угол 110 угловых миллисекунд. Для этого пульсара был измерен размер диска рассеяния около 1.5 угловых миллисекунд. Субструктура диска мерцаний от пульсара B0329+54 Высокое угловое разрешение наземно-космического интерферометра РадиоАстрон обеспечило возможность измерить размер диска рассеяния и оценить положение в пространстве эффективного рассеивающего экрана для пульсара B0329+54 на частоте 324 МГц. Наблюдения проводились в два этапа: в ноябре 2012 года и январе 2014 года. Наблюдения были поддержаны 100-м радиотелескопом обсерватории Грин Бэнк (США), системой апертурного синтеза в Вестерборке (WSRT, Нидерланды) и российским 64-м радиотелескопом в Калязине. Наземно-космические проекции базы интерферометра покрыли интервал от 60,000 до 235,000 километров во время сессии в ноябре 2012 года и от 15,000 до 120,000 километров в январе 2014 года. Измеренный сигнал имеет значительную амплитуду даже на самых длинных проекциях с величиной около 0.05 % (20&sigma;). Отклик интерферометра на самых длинных наземно-космических базах не содержит центрального максимума и состоит из множества изолированных неразрешенных пиков. Общее распределение этих пиков по задержке сигнала следует распределению Лоренца и соответствует размытию по времени около 7.5 мс. Тонкая структура по задержке согласуется с моделью амплитудно-модулированного шума, указывая на случайный характер интерференции лучей, рассеянных на неоднородностях межзвездной плазмы. На малых наземно-космических базах амплитуда центрального пика сигнала, измеренного интерферометром, постепенно уменьшается с увеличением проекции базы, обеспечивая возможность прямого измерения углового размера диска рассеяния, который оказался равным 4.6 миллисекунды дуги. Путем сравнения временного и углового уширения мы оценили расстояние до эффективного рассеивающего экрана. Он оказался расположен почти посередине между Землей и пульсаром. Рисунок 1 демонстрирует эволюцию структуры измеренного сигнала по мере увеличения базы наземно-космического интерферометра: на малых базах присутствует центральный максимум и протяженная по задержке составляющая, центральный пик уменьшается по амплитуде с увеличением базы и на самых длинных наземно-космических базах остается только протяженная составляющая. Эти результаты были представлены недавно на ассамблее COSPAR-2014 в Москве.</p>\r\n', '<p>/iasnap/ckeditor/kcfinder/upload/images/sign.jpg</p>\r\n');

-- --------------------------------------------------------

--
-- Структура таблицы `gen_other_info`
--

DROP TABLE IF EXISTS `gen_other_info`;
CREATE TABLE IF NOT EXISTS `gen_other_info` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `publicationDate` date NOT NULL COMMENT 'Дата публікації',
  `title` varchar(255) NOT NULL COMMENT 'Заголовок',
  `summary` text NOT NULL COMMENT 'Стислий опис публікації',
  `text` mediumtext NOT NULL COMMENT 'Зміст публлікації',
  `img` varchar(255) NOT NULL COMMENT 'Посилання',
  `kind_of_publication` tinyint(3) unsigned NOT NULL COMMENT 'ID виду публікації',
  PRIMARY KEY (`id`),
  KEY `menu_info_idx` (`kind_of_publication`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Посилання на статті до категорій сайту»' AUTO_INCREMENT=4 ;

--
-- Дамп данных таблицы `gen_other_info`
--

INSERT INTO `gen_other_info` (`id`, `publicationDate`, `title`, `summary`, `text`, `img`, `kind_of_publication`) VALUES
(1, '2014-08-18', 'Підтвердження достовірності порталу', 'Перш ніж розпочинати реєстрацію або авторизацію на порталі рекомендуємо здійснити перевірку автентичності порталу.', '<p>Перш ніж розпочинати реєстрацію або авторизацію на порталі рекомендуємо здійснити перевірку автентичності порталу.</p>\r\n\r\n<p>Для перевірки автентичності порталу необхідно:</p>\r\n\r\n<p>1 Завантажити архів, який містить підписаний електронною печаткою КП ОІАЦ сертифікат порталу та комплект посилених сертифікатів, необхідних для здійснення перевірки. &nbsp;(<a href="https://cnap.odessa.gov.ua/auth/cnap_certs.zip">завантажити</a>)</p>\r\n\r\n<p>2 Розпакувати архів будь-яким з архіваторів (наприклад, <a href="http://www.rarlab.com/download.htm">WinRar</a>, <a href="http://www.7-zip.org/">7zip</a>, <a href="http://peazip.sourceforge.net/">PeaZip</a>) у зручну для Вас папку на комп&rsquo;ютері.</p>\r\n\r\n<p>3 Впевнитись, за допомогою наявного у Вас засобу роботи з електронним цифровим підписом, у чинності накладеного на сертифікат електронного цифрового підпису та у факті, що підпис накладено електронною печаткою КП ОІАЦ. Якщо дані вимоги виконано - цілісність файлу не порушена.</p>\r\n\r\n<p>Наприклад, за допомогою програмного комплексу &laquo;<a href="http://acskidd.gov.ua/korustyvach_csk">ІІТ Користувач ЦСК-1</a>&raquo; це можна зробити наступним чином:</p>\r\n\r\n<p>А) Додати в каталог із сертифікатами сертифікати, які знаходяться в папці Certs архіву.</p>\r\n\r\n<p>Розташування каталогу із сертифікатами можна дізнатися наступним чином: &laquo;Параметри&raquo; - &laquo;Встановити&hellip;&raquo; - &laquo;Каталог з сертифікатами та СВС&raquo; (рис.1).</p>\r\n\r\n<p><img alt="" src="https://cnap.odessa.gov.ua/auth/integr7.png" style="height:312px; margin-left:auto; margin-right:auto; width:662px" />Рисунок 1 - Перевірка місця розташування каталогу із сертифікатами</p>\r\n\r\n<p>Б) Для перевірки ЕЦП необхідно натиснути &laquo;Файли&raquo; - &laquo;Перевірити&raquo; - &laquo;Відміна&raquo; - &laquo;Додати&hellip;&raquo;, обрати файл cnap.odessa.gov.ua.crt із папки files архіву &nbsp;та натиснути &quot;Перевірити&quot;.</p>\r\n\r\n<p>4 Порівняти вміст сертифікатів порталу.</p>\r\n\r\n<p>Отримати вміст сертифікату у:</p>\r\n\r\n<p>браузері Firefox &ndash; натиснути на значок &quot;Кулі&quot; та &quot;Розкажіть мені про цей сайт ...&quot; (рис.2).</p>\r\n\r\n<p><img alt="" src="https://cnap.odessa.gov.ua/auth/integr1.png" style="height:205px; margin-left:auto; margin-right:auto; width:413px" /></p>\r\n\r\n<p>Рисунок 2 - Firefox відомості про сайт</p>\r\n\r\n<p>Натиснути &quot;Переглянути сертифікат&quot; (рис. 3).</p>\r\n\r\n<p><img alt="" src="https://cnap.odessa.gov.ua/auth/integr2.png" style="height:428px; margin-left:auto; margin-right:auto; width:658px" /></p>\r\n\r\n<p>Рисунок 3 - Firefox відомості про сайт</p>\r\n\r\n<p>браузері Internet Explorer &ndash; натиснути значок &quot;Замочок&quot; та &quot;Просмотр сертификатов&quot; (рис. 4).</p>\r\n\r\n<p><img alt="" src="https://cnap.odessa.gov.ua/auth/integr4.png" style="height:269px; margin-left:auto; margin-right:auto; width:290px" /></p>\r\n\r\n<p>Рисунок 4 - Internet Explorer відомості про сайт</p>\r\n\r\n<p>браузері Google Chrome &ndash; натиснути значок &quot;Замочок&quot; та &quot;Информация сертификата&quot; (рис.5).</p>\r\n\r\n<p><img alt="" src="https://cnap.odessa.gov.ua/auth/integr3.png" style="height:503px; margin-left:auto; margin-right:auto; width:373px" /></p>\r\n\r\n<p>Рисунок 5 - Google Chrome відомості про сайт</p>\r\n\r\n<p>Отримати вміст завантаженого підписаного сертифікату у операційній системі Windows можна натиснув на файл сертифікату cnap.odessa.gov.ua.crt правою кнопкою миші та обрати варіант &quot;Открыть&quot; (рис. 6).</p>\r\n\r\n<p><img alt="" src="https://cnap.odessa.gov.ua/auth/integr6.png" style="height:376px; margin-left:auto; margin-right:auto; width:490px" /></p>\r\n\r\n<p>Рисунок 6 - Відомості про сертифікат порталу у Windows</p>\r\n\r\n<p>Перевірити за рядками вміст підписаного сертифікату з архіву та вміст сертифікату сайту, який відображається у веб-браузері. Якщо поля у сертифікатах ідентичні, можна розпочинати процес реєстрації або авторизації.</p>\r\n', 'http://', 8),
(2, '2014-08-26', 'Опис процесу реєстрації на порталі ', 'Перш, ніж розпочати реєстрацію на порталі, користувач повинен отримати у акредитованому центрі сертифікації ключів відкритий та особистий ключ для реалізації криптографічних перетворень (пыдписання та шифрування заяви). <a href="https://cnap.odessa.gov.ua/info/ecp/">Деталі</a>.', '<p>Перш, ніж розпочати реєстрацію на порталі, користувач повинен отримати у акредитованому центрі сертифікації ключів відкритий та особистий ключ для реалізації криптографічних перетворень (пыдписання та шифрування заяви). <a href="https://cnap.odessa.gov.ua/info/ecp/">Деталі</a>.</p>\r\n\r\n<p>Безпосередньо процес реєстрації на порталі складається з п&rsquo;яти кроків:</p>\r\n\r\n<p><strong>Крок 1. Ініціалізація програмного забезпечення</strong></p>\r\n\r\n<p>Для проходження процесу реєстрації на порталі необхідно перейти за посиланням <a href="https://cnap.odessa.gov.ua/users/registrate/">https://cnap.odessa.gov.ua/users/registrate/</a>.</p>\r\n\r\n<p>На даному кроці відбувається перевірка всіх необхідних умов для коректного функціонування модулів порталу, а саме: чи включений у браузері JavaScript та чи інстальовано пакет з обчислювальним середовищем Java.</p>\r\n\r\n<p>При його наявності на екрані з&rsquo;явиться спливаюче вікно темно-сірого кольору (рис.1). У цьому вікні слід обрати варіант &laquo;Run&raquo; та після зникнення спливаючого вікна натиснути &laquo;Далі&raquo;. Натискаючи кнопку &laquo;Run&raquo;, Ви підтверджуєте довіру до завантаженого з порталу Центру надання адміністративних послуг Java-аплету та дозволяєте доступ до файлів, розміщених на комп&rsquo;ютері.</p>\r\n\r\n<p><img alt="" src="https://cnap.odessa.gov.ua/auth/reg1.png" style="height:404px; margin-left:auto; margin-right:auto; width:544px" /></p>\r\n\r\n<p>Рисунок 1 &ndash; Вікно підтвердження довіри до java-аплету</p>\r\n\r\n<p>Примітки до кроку 1:</p>\r\n\r\n<p>1. Детальні інструкції з встановлення Java знаходяться на сайті <a href="http://java.com/ru/download/installed.jsp" target="_blank">http://java.com/ru/download/installed.jsp</a>.</p>\r\n\r\n<p>2. Безпосередньо Java для Windows можна завантажити з <a href="http://www.java.com/ru/download/windows_xpi.jsp" target="_blank">http://www.java.com/ru/download/windows_xpi.jsp</a>.</p>\r\n\r\n<p>3. У випадку використання браузеру Google Chrome для появи спливаючого вікна необхідно натиснути кнопку &laquo;Запустить один раз&raquo;, що може бути розташоване у верхній частині основного вікна.</p>\r\n\r\n<p><strong>Крок 2. Перевірка та встановлення налаштувань</strong></p>\r\n\r\n<p>На даному кроці, за необхідності, Ви можете вказати шлях до власних сертифікатів та параметри проксі-серверу. За замовчанням, для збереження власних сертифікатів буде використано каталог &laquo;C:\\CertificatesJava&raquo;. Цей каталог можна залишити без змін (див. рис. 2).</p>\r\n\r\n<p>Для продовження реєстрації слід натиснути &laquo;Далі&raquo;.</p>\r\n\r\n<p><img alt="" src="https://cnap.odessa.gov.ua/auth/reg2.jpg" style="height:229px; margin-left:auto; margin-right:auto; width:483px" /></p>\r\n\r\n<p>Рисунок 2 &ndash; Вікно встановлення налаштувань</p>\r\n\r\n<p><strong>Крок 3. Контактна інформація</strong></p>\r\n\r\n<p>Для встановлення з Вами зворотного зв&rsquo;язку у формі зображеній на рис. 3 необхідно ввести двічі свій e-mail, контактний номер телефону, встановити галочку щодо погодження обробки персональних даних у інформаційно-телекомунікаційній системі надання адміністративних послуг та натиснути &laquo;Далі&raquo;.</p>\r\n\r\n<p><img alt="" src="https://cnap.odessa.gov.ua/auth/reg3.jpg" style="height:253px; margin-left:auto; margin-right:auto; width:475px" /></p>\r\n\r\n<p>Рисунок 3 &ndash; Форма з відомостями про суб&rsquo;єкта звернення</p>\r\n\r\n<p>Примітки до кроку 3:</p>\r\n\r\n<p>1. На зазначену адресу електронної пошти буде вислане повідомлення з інструкцією щодо завершення реєстрації. У випадку введення недійсної адреси Ви не зможете успішно завершити реєстрацію.</p>\r\n\r\n<p>2. Формат телефонного номеру повинен відповідати наступним умовам: 0xxYYYYYYY, де x - код оператора зв&#39;язку, Y - 7-значний номер телефону.</p>\r\n\r\n<p><strong>Крок 4. Створення підпису</strong></p>\r\n\r\n<p>На даному кроці Вам необхідно імпортувати свій відкритий сертифікат та накласти електронний цифровий підпис на реєстраційну інформацію.</p>\r\n\r\n<p>Перелік усіх імпортованих сертифікатів (у випадку наявності), які знаходяться у файловому сховищі вказаному на другому кроці, буде виведено в таблиці (див. табл. 1).</p>\r\n\r\n<p>Таблиця 1 &ndash; Зразок інформації про наявні сертифікати</p>\r\n\r\n<p><strong>Перелік сертифікатів користувачів</strong></p>\r\n\r\n<table border="1" cellpadding="0" style="width:100%">\r\n	<tbody>\r\n		<tr>\r\n			<td>\r\n			<p><strong>Прізвище, ім&#39;я, по батькові</strong></p>\r\n			</td>\r\n			<td>\r\n			<p><strong>Найменування центра сертифікації ключів</strong></p>\r\n			</td>\r\n			<td>\r\n			<p><strong>Серійний номер</strong></p>\r\n			</td>\r\n			<td>\r\n			<p><strong>Чинність</strong></p>\r\n			</td>\r\n		</tr>\r\n		<tr>\r\n			<td>\r\n			<p>Іванов Іван Іванович</p>\r\n			</td>\r\n			<td>\r\n			<p>ЦСК ПрАТ &quot;ІВК&quot;</p>\r\n			</td>\r\n			<td>\r\n			<p>1D12AA546E10CFAE0400000111E2010098CF0300</p>\r\n			</td>\r\n			<td>\r\n			<p>29 трав 2014 0:00:00</p>\r\n			</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n\r\n<p>Якщо в таблиці відсутні відомості про Ваш сертифікат, натисніть кнопку &laquo;Імпортувати сертифікат&raquo; (рис. 4) та у спливаючому вікні оберіть файл з Вашим відкритим сертифікатом (файл з розширенням .cer).</p>\r\n\r\n<p><img alt="" src="https://cnap.odessa.gov.ua/auth/reg4.jpg" style="height:277px; margin-left:auto; margin-right:auto; width:448px" /></p>\r\n\r\n<p>Рисунок 4 &ndash; Вікно імпорту сертифікатів</p>\r\n\r\n<p>Для переходу на наступний крок Вам необхідно підключити до комп&rsquo;ютера свій ключовий носій з особистим ключом ЕЦП (найчастіше це - оптичний диск або USB-ключ), натиснути кнопку &quot;Далі&quot;, у спливаючому вікні слід обрати з меню свій носій, ввести пароль до особистого ключа на носії та натиснути кнопку &quot;Далі&quot; (рис. 5). У випадку успіху Вас буде переадресовано на крок п&rsquo;ять.</p>\r\n\r\n<p><img alt="" src="https://cnap.odessa.gov.ua/auth/reg5.png" style="height:350px; margin-left:auto; margin-right:auto; width:333px" /></p>\r\n\r\n<p>Рисунок 5 &ndash; Вікно введення паролю до ключового носію</p>\r\n\r\n<p>Примітки до кроку 4:</p>\r\n\r\n<p>1. У випадку, якщо при імпорті Вашого відкритого сертифікату в таблиці навпроти нього відображається повідомлення &quot;Не визначено&quot; замість дати закінчення строку його дії, то необхідно імпортувати (або скопіювати до відповідної директорії, вказаної на кроці 2) всі файли сертифікатів акредитованого центра сертифікації ключів (АЦСК), який видав Вам сертифікат, у тому числі основний сертифікат АЦСК та сертифікат TSP-сервера міток часу АЦСК, які повинні бути підписані Центральним Засвідчувальним Органом (ЦЗО). Переглянути інформацію щодо отримання цих сертифікатів можна на <a href="http://czo.gov.ua/ca-registry?type=4" target="_blank">офіційному веб-сайті ЦЗО</a>.</p>\r\n\r\n<p>2. Якщо ви копіюєте файли сертифікатів до відповідної директорії (наприклад, C:\\CertificatesJava), то необхідно після цього натиснути кнопку &quot;Оновити список сертифікатів&quot;. Якщо всі необхідні сертифікати наявні та чинні, навпроти Вашого сертифікату в таблиці з&#39;явиться відмітка про строк дії сертифікату зеленого кольору.</p>\r\n\r\n<p><strong>Крок 5. Реєстраційна інформація</strong></p>\r\n\r\n<p>Інформація, виведена у формі (рис. 6), буде передана до Центра надання адміністративних послуг. Дана інформація (крім e-mail та телефону) взята з відкритого сертифікату, що відповідає Вашому особистому ключу.</p>\r\n\r\n<p>ВАЖЛИВО! Якщо Ви помітили помилку в Вашому імені, коді платника податків або у коді ЄДРПОУ, зверніться до Центру сертифікації ключів, який надав Вам сертифікат, для виправлення та отримання нового сертифікату.&nbsp;</p>\r\n\r\n<p>Для надсилання реєстраційної інформації до бази даних веб-порталу Центру надання адміністративних послуг необхідно натиснути &laquo;Завершити реєстрацію&raquo;</p>\r\n\r\n<p><img alt="" src="https://cnap.odessa.gov.ua/auth/reg6.jpg" style="height:260px; width:492px" /></p>\r\n\r\n<p>Рисунок 6 - Форма завершення реєстрації</p>\r\n\r\n<p>Після занесення відомостей до бази даних Вам у відповідь посилається повідомлення на електронну скриньку з посиланням на активацію. Для завершення реєстрації слід активувати свій обліковий запис на веб-порталі шляхом переходу за посиланням, яке було надіслано електронною поштою.</p>\r\n', 'http://', 8),
(3, '2014-08-26', 'Безпечне поводження з ключовими носіями ', 'Особистий ключ ЕЦП та пароль до нього слід зберігати у секретному та/або недоступному іншим особам місці. У разі, якщо закритий ключ ЕЦП разом з паролем до нього попадуть до рук шахраїв, то вони можуть робити відповідні дії від Вашого імені та отримувати доступ до Ваших персональних даних, а взяті ними зобов&rsquo;язання прийдеться виконувати Вам.', '<p>Особистий ключ ЕЦП та пароль до нього слід зберігати у секретному та/або недоступному іншим особам місці. У разі, якщо закритий ключ ЕЦП разом з паролем до нього попадуть до рук шахраїв, то вони можуть робити відповідні дії від Вашого імені та отримувати доступ до Ваших персональних даних, а взяті ними зобов&rsquo;язання прийдеться виконувати Вам. Для підвищення безпеки при використання ЕЦП необхідно дотримуватися певних правил та обмежень, у тому числі:</p>\r\n\r\n<ol>\r\n	<li>Не зберігайте закритий ключ ЕЦП на комп&rsquo;ютері. Зберігайте особистий ключ ЕЦП тільки на зовнішньому носії (CD/DVD, USB-флешка, USB-токен) у недоступному для інших осіб місці.</li>\r\n	<li>Особистий ключ ЕЦП рекомендується зберігати на спеціально призначених для цього пристроях - USB-токенах, які унеможливлюють несанкціоноване копіювання закритого ключа сторонніми особами.</li>\r\n	<li>Пароль до особистого ключа ЕЦП не слід зберігати поряд з ключовим носієм (у якому зберігається закритий ключ ЕЦП), у тому числі, не записуйте пароль на самому носії або його упаковці.</li>\r\n	<li>Ключовий носій слід підключати до комп&rsquo;ютера тільки перед безпосереднім його використанням (перед накладанням ЕЦП).</li>\r\n	<li>Після накладання ЕЦП ключовий носій необхідно відключати від комп&rsquo;ютера та покласти його у надійне місце. Не залишайте ключовий носій постійно під&rsquo;єднаним до комп&rsquo;ютера.</li>\r\n	<li>Не слід зберігати будь-які інші дані та файли на ключовому носії, крім закритого ключа ЕЦП.</li>\r\n	<li>Не слід копіювати та дублювати вміст ключового носія (закритий ключ ЕЦП), а також не слід передавати ключовий носій іншим особам, навіть на короткий час.</li>\r\n	<li>У випадку втрати ключового носію або підозри, що особистий ключ ЕЦП може бути у скопійований іншою особою, необхідно повідомити про це Центр сертифікації ключів, який видав Вам сертифікат ЕЦП.</li>\r\n</ol>\r\n', 'http://', 8);

-- --------------------------------------------------------

--
-- Структура таблицы `gen_regulations`
--

DROP TABLE IF EXISTS `gen_regulations`;
CREATE TABLE IF NOT EXISTS `gen_regulations` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `type` enum('Закони України','Акти Кабінету Міністрів України','Акти центральних органів виконавчої влади','Акти місцевих ОВВ та МС') NOT NULL COMMENT 'Тип нормативно-правового акту',
  `name` varchar(255) NOT NULL COMMENT 'Назва нормативно-правового акту',
  `hyperlink` varchar(255) NOT NULL COMMENT 'Посилання на документ',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Відомості про нормативно-правові акти»' AUTO_INCREMENT=4 ;

--
-- Дамп данных таблицы `gen_regulations`
--

INSERT INTO `gen_regulations` (`id`, `type`, `name`, `hyperlink`) VALUES
(1, 'Закони України', 'Закон України від 06.09.2012 № 5203-VI "Про адміністративні послуги"', 'http://zakon.rada.gov.ua/laws/show/5203-17'),
(2, 'Акти Кабінету Міністрів України', 'Постанова КМУ від 1 серпня 2013 р. № 588 "Про затвердження Примірного регламенту центру надання адміністративних послуг"', 'http://zakon.rada.gov.ua/laws/show/588-2013-%D0%BF'),
(3, 'Акти Кабінету Міністрів України', 'Розпорядження КМУ від 15.02.2006 № 90-р Про схвалення Концепції розвитку системи надання адміністративних послуг органами виконавчої влади', 'http://zakon.rada.gov.ua/laws/show/90-2006-%D1%80');

-- --------------------------------------------------------

--
-- Структура таблицы `gen_serv_cat_class`
--

DROP TABLE IF EXISTS `gen_serv_cat_class`;
CREATE TABLE IF NOT EXISTS `gen_serv_cat_class` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `service_id` smallint(5) unsigned NOT NULL,
  `cat_class_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `service_id` (`service_id`,`cat_class_id`),
  KEY `serv_cat_idx` (`cat_class_id`),
  KEY `serv_id_idx` (`service_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Звязок послуг з категоріями та класами»' AUTO_INCREMENT=108 ;

--
-- Дамп данных таблицы `gen_serv_cat_class`
--

INSERT INTO `gen_serv_cat_class` (`id`, `service_id`, `cat_class_id`) VALUES
(1, 4, 14),
(2, 5, 14),
(3, 6, 14),
(4, 7, 14),
(5, 8, 14),
(6, 9, 11),
(7, 10, 24),
(8, 11, 24),
(9, 13, 4),
(10, 14, 4),
(11, 15, 4),
(13, 16, 4),
(14, 17, 4),
(15, 18, 4),
(16, 19, 4),
(17, 20, 4),
(18, 21, 4),
(19, 22, 4),
(24, 23, 4),
(20, 24, 4),
(21, 25, 4),
(22, 26, 4),
(23, 27, 4),
(31, 28, 25),
(32, 29, 25),
(33, 30, 25),
(34, 31, 25),
(35, 32, 25),
(36, 33, 25),
(58, 34, 25),
(56, 35, 25),
(54, 36, 25),
(53, 37, 25),
(52, 38, 25),
(51, 39, 25),
(50, 40, 25),
(64, 41, 25),
(49, 42, 25),
(48, 43, 25),
(47, 44, 25),
(46, 45, 25),
(45, 46, 25),
(43, 47, 25),
(44, 48, 25),
(41, 49, 25),
(40, 50, 25),
(39, 51, 25),
(38, 52, 25),
(37, 53, 25),
(87, 54, 25),
(86, 58, 25),
(85, 59, 25),
(84, 60, 25),
(83, 61, 6),
(82, 62, 14),
(81, 64, 14),
(80, 65, 12),
(79, 66, 12),
(78, 67, 12),
(77, 68, 12),
(76, 69, 12),
(75, 70, 28),
(74, 71, 28),
(73, 72, 28),
(72, 73, 28),
(71, 74, 8),
(70, 75, 8),
(69, 76, 8),
(68, 77, 8),
(67, 78, 15),
(66, 79, 27),
(65, 80, 26),
(107, 103, 11),
(106, 104, 11),
(105, 105, 11),
(104, 106, 11),
(103, 107, 11),
(102, 108, 28),
(101, 109, 28),
(100, 110, 28),
(99, 111, 28),
(98, 113, 21),
(97, 114, 21),
(96, 115, 21),
(95, 116, 21),
(94, 117, 21),
(93, 118, 21),
(92, 119, 33),
(91, 120, 33);

-- --------------------------------------------------------

--
-- Структура таблицы `gen_serv_categories`
--

DROP TABLE IF EXISTS `gen_serv_categories`;
CREATE TABLE IF NOT EXISTS `gen_serv_categories` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `name` varchar(60) NOT NULL COMMENT 'Назва категорії',
  `visability` enum('так','ні') NOT NULL COMMENT 'Видимість (0/1)',
  `icon` varchar(255) NOT NULL DEFAULT '/' COMMENT 'Піктограма',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Каталог категорій послуг»' AUTO_INCREMENT=29 ;

--
-- Дамп данных таблицы `gen_serv_categories`
--

INSERT INTO `gen_serv_categories` (`id`, `name`, `visability`, `icon`) VALUES
(2, 'Промисловість', 'так', ''),
(3, 'Комунікації та звязок', 'ні', ''),
(4, 'Сільське господарство', 'так', '/'),
(6, 'Реклама', 'так', ''),
(9, 'Будівництво та архітектура', 'так', ''),
(10, 'Культура та релігія', 'так', ''),
(11, 'Освіта', 'так', ''),
(12, 'Землеустрій', 'ні', ''),
(13, 'Спорт', 'так', ''),
(14, 'Економіка та інвестиції', 'так', ''),
(15, 'Реєстрація бізнеса', 'так', ''),
(16, 'Комунікації та зв''язок', 'так', ''),
(22, 'Сім''я', 'так', ''),
(23, 'Соціальне забезпечення', 'так', ''),
(24, 'Охорона здоров''я', 'так', ''),
(25, 'Екологія', 'так', ''),
(26, 'ЖКГ', 'так', ''),
(27, 'Безпека', 'так', ''),
(28, 'Підприємництво', 'ні', '');

-- --------------------------------------------------------

--
-- Структура таблицы `gen_serv_classes`
--

DROP TABLE IF EXISTS `gen_serv_classes`;
CREATE TABLE IF NOT EXISTS `gen_serv_classes` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `item_name` varchar(45) NOT NULL COMMENT 'Назва класу',
  `visability` enum('так','ні') NOT NULL COMMENT 'Видимість (0/1)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Каталог класів послуг»' AUTO_INCREMENT=3 ;

--
-- Дамп данных таблицы `gen_serv_classes`
--

INSERT INTO `gen_serv_classes` (`id`, `item_name`, `visability`) VALUES
(1, 'Громадянам', 'так'),
(2, 'Організаціям', 'так');

-- --------------------------------------------------------

--
-- Структура таблицы `gen_serv_docum`
--

DROP TABLE IF EXISTS `gen_serv_docum`;
CREATE TABLE IF NOT EXISTS `gen_serv_docum` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `name` text NOT NULL COMMENT 'Назва документа',
  `hyperlink` varchar(255) DEFAULT NULL COMMENT 'Посилання',
  `service_id` smallint(5) unsigned NOT NULL COMMENT 'ID послуги',
  PRIMARY KEY (`id`),
  KEY `serv_docum_idx` (`service_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Перелік документів до послуги»' AUTO_INCREMENT=3 ;

--
-- Дамп данных таблицы `gen_serv_docum`
--

INSERT INTO `gen_serv_docum` (`id`, `name`, `hyperlink`, `service_id`) VALUES
(1, '1.	Заява про проведення ліцензування із зазначенням виду освітньої послуги і ліцензованого обсягу, реквізитів навчального закладу за затвердженою Міністерством освіти і науки, молоді та спорту України формою.', NULL, 1),
(2, '2.	Копії установчих документів (статуту, положення, рішення засновника (власника) або уповноваженого ним органу про створення навчального закладу.', NULL, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `gen_serv_regulations`
--

DROP TABLE IF EXISTS `gen_serv_regulations`;
CREATE TABLE IF NOT EXISTS `gen_serv_regulations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `type` enum('Закони України','Акти Кабінету Міністрів України','Акти центральних органів виконавчої влади','Акти місцевих ОВВ та МС') NOT NULL COMMENT 'Тип',
  `name` text NOT NULL COMMENT 'Назва',
  `hyperlink` varchar(255) NOT NULL COMMENT 'Посилання',
  `service_id` smallint(5) unsigned NOT NULL COMMENT 'ID послуги',
  PRIMARY KEY (`id`),
  KEY `serv_reg_idx` (`service_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Законодавчі акти до послуги»' AUTO_INCREMENT=2 ;

--
-- Дамп данных таблицы `gen_serv_regulations`
--

INSERT INTO `gen_serv_regulations` (`id`, `type`, `name`, `hyperlink`, `service_id`) VALUES
(1, 'Закони України', 'Закон України «Про ліцензування певних видів господарської діяльності», «Про освіту», «Про дошкільну освіту».', 'http://zakon', 1);

-- --------------------------------------------------------

--
-- Структура таблицы `gen_services`
--

DROP TABLE IF EXISTS `gen_services`;
CREATE TABLE IF NOT EXISTS `gen_services` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `name` varchar(500) NOT NULL COMMENT 'Назва послуги',
  `subjnap_id` smallint(5) unsigned NOT NULL COMMENT 'ID суб’єкта НАП',
  `subjwork_id` smallint(5) unsigned NOT NULL,
  `regulations` text NOT NULL COMMENT 'Нормативно-правові акти',
  `reason` text NOT NULL COMMENT 'Підстава для отримання',
  `submission_proc` text NOT NULL COMMENT 'Порядок подання',
  `docums` text NOT NULL COMMENT 'Перелік документів',
  `is_payed` tinyint(4) NOT NULL COMMENT 'Платність послуги',
  `payed_regulations` text COMMENT 'Нормативно-правові акти',
  `payed_rate` text COMMENT 'Розмір плати',
  `bank_info` text COMMENT 'Банківські реквізити',
  `deadline` text NOT NULL COMMENT 'Строк надання',
  `denail_grounds` text COMMENT 'Підстави для відмови',
  `result` text NOT NULL COMMENT 'Результат надання',
  `answer` text NOT NULL COMMENT 'Способи отримання відповіді',
  `is_online` enum('так','ні') NOT NULL COMMENT 'Можливість надання в електронному вигляді',
  `have_expertise` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Наявність експертизи (0-ні,1-так)',
  `nes_expertise` text,
  `is_payed_expertise` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Чи платна експертиза',
  `payed_expertise` text COMMENT 'Платність експертизи',
  `regul_expertise` text COMMENT 'НПА експертизи',
  `rate_expertise` text COMMENT 'Розмір плати за експертизу',
  `bank_info_expertise` text COMMENT 'Банківські реквізити (експертиза)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`(255)),
  KEY `id_idx` (`subjnap_id`),
  KEY `id2_idx` (`subjwork_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Відомості про послуги»' AUTO_INCREMENT=121 ;

--
-- Дамп данных таблицы `gen_services`
--

INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`) VALUES
(1, 'Ліцензування діяльності з надання освітніх послуг у сфері загальної середньої освіти (юридичні особи)', 1, 3, '<ol>\r\n	<li>Закон України від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 13.05.1999 №651-ХІV &nbsp;&laquo;Про загальну середню освіту&raquo;, ст.&nbsp;8 п.1.</li>\r\n	<li>Постанова Кабінету Міністрів України від 08.08.2007 №1019 &laquo;Про ліцензування діяльності з надання освітніх послуг&raquo; (п.&nbsp;2 підпункт 2, п.&nbsp;3, п.&nbsp;11 Порядку ліцензування діяльності з надання освітніх послуг, затвердженого постановою Кабінету Міністрів України від 08.08.2007 №1019).</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>через Центр надання адміністративних послуг</p>\r\n', '<ol>\r\n	<li>Заява про проведення ліцензування із зазначенням виду освітньої послуги і ліцензованого обсягу, реквізитів навчального закладу за затвердженою Міністерством освіти і науки, молоді та спорту України формою.</li>\r\n	<li>Копії установчих документів (статуту, положення, рішення засновника (власника) або уповноваженого ним органу про створення навчального закладу).</li>\r\n	<li>Копії рішень про утворення відокремлених підрозділів та положення про них (у разі ліцензування освітніх послуг у відокремленому підрозділі).</li>\r\n	<li>4.&nbsp;Концепція діяльності за заявленою освітньою послугою, яка ґрунтується на результатах моніторингу регіонального ринку освітніх послуг.</li>\r\n	<li>Копія робочого навчального плану, затвердженого в установленому порядку.</li>\r\n	<li>Відомості про кількісні та якісні показники кадрового забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про кількісні показники матеріально-технічного забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про навчально-методичне забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про кількісні показники інформаційного забезпечення освітньої діяльності, наявність бібліотеки та обсяг її фондів.</li>\r\n	<li>Копії документів, що засвідчують право власності (свідоцтво про право власності, договір купівлі-продажу), оперативного управління (рішення чи повідомлення власника майна про перебування майна в оперативному управлінні) чи користування (договір оренди) основними засобами для здійснення навчально-виховного процесу на строк, необхідний для завершення надання послуги.</li>\r\n	<li>Копії документів про відповідність приміщень навчального закладу та його матеріально-технічної бази санітарним нормам, вимогам правил пожежної безпеки.</li>\r\n	<li>Копії документів, що засвідчують рівень освіти, кваліфікації та громадянство керівника навчального закладу (диплома про вищу освіту, першої сторінки паспорта керівника навчального закладу).</li>\r\n</ol>\r\n', 1, '<p>- Відшкодування витрат, пов&rsquo;язаних з проведенням ліцензійної експертизи &ndash; пункт 24 постанови Кабінету Міністрів України від 08.08.2007 № 1019 &laquo;Про ліцензування діяльності з надання освітніх послуг&raquo;. - Плата за видачу, переоформлення ліцензії, видачу копії та дубліката ліцензії &ndash; пункт 2 постанови Кабінету Міністрів України від 29.08.2003 № 1380 &laquo;Про ліцензування освітніх послуг&raquo;</p>\r\n', '<p>Відшкодування витрат, пов&rsquo;язаних з проведенням ліцензійної експертизи становить &ndash; 24 неоподаткованих мінімумів громадян (408 грн) Плата за видачу ліцензії становить &ndash; 15 неоподаткованих мінімумів доходів громадян (255 грн) Плата за переоформлення ліцензії, видачу копії та дубліката ліцензії &ndash; 5 неоподаткованих мінімумів доходів громадян (85 грн)</p>\r\n', '<p>Реквізити для Відшкодування витрат, пов&rsquo;язаних з проведенням ліцензійної експертизи,- р/р 31256277221575 МФО 828011 код 23207206, одержувач Навчально-методичний центр професійно-технічної освіти в Одеській області, банк одержувача ГУДКСУ в Одеській області.</p>\r\n\r\n<p>Реквізити для внесення плати за видачу ліцензії, переоформлення ліцензії, видачу копії та дубліката ліцензії &ndash; р/р 31413511700001 код 37607526 МФО 828011одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200</p>\r\n', '<p>Три місяці</p>\r\n', '', '<p>Ліцензія або лист з обґрунтуванням причин відмови</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 1, '<p>Спроможність надавати освітні послуги підтверджується результатами ліцензійної експертизи (п.&nbsp;16&sup1; Порядку ліцензування діяльності з надання освітніх послуг, затвердженого постановою Кабінету Міністрів України від 08.08.2007 №1019 &laquo;Про ліцензування діяльності з надання освітніх послуг&raquo;).</p>\r\n', 1, '<p>Оплата послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування здійснюється суб&rsquo;єктом звернення (п.&nbsp;24&nbsp; Порядку ліцензування діяльності з надання освітніх послуг, затвердженого постановою Кабінету Міністрів України від 08.08.2007 №1019 &laquo;Про ліцензування діяльності з надання освітніх послуг&raquo;).</p>\r\n', '<p>Спроможність надавати освітні послуги підтверджується результатами ліцензійної експертизи (п.&nbsp;16&sup1; Порядку ліцензування діяльності з надання освітніх послуг, затвердженого постановою Кабінету Міністрів України від 08.08.2007 №1019 &laquo;Про ліцензування діяльності з надання освітніх послуг&raquo;).</p>\r\n', '<p>Оплата послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування діяльності юридичних осіб у сфері загальної середньої освіти здійснюється суб&rsquo;єктом звернення у розмірі 24 неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p>Оплата послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування перераховується заявником на рахунок регіональної експертної ради &ndash; навчально-методичний центр професійно-технічної освіти в Одеській області р/р&nbsp;31256277221575 МФО&nbsp;828011 код&nbsp;23207206, банк одержувача ГУДКСУ в Одеській області.</p>\r\n'),
(2, 'Ліцензія  на право провадження господарської діяльності з виробництва та транспортування теплової енергії магістральними та місцевими (розподільчими) тепловими мережами', 1, 3, '<p>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ</p>\r\n', '<p>&lt;&gt;</p>\r\n', '<p>через Центр надання адміністративних послуг</p>\r\n', '<p>1.Заява, заповнена відповідно до ст..10 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n\r\n<p>2. Засвідчена в астановленому поррядку копія документа, що підтверджує право власності суб&rsquo;єкта господарювання або оренди ним виробничих об&rsquo;єктів, де провадитиметься відповідний вид господарської діяльності;</p>\r\n\r\n<p>3. Відомості за підписом заявника &ndash; суб&rsquo;єкта господарювання (за формою, встановленою ліцензійними умовами) про:</p>\r\n\r\n<p>3.1 Наявність власних або орендованих виробничих об&rsquo;єктів, де провадитиметься відповідний вид господарської діяльності;</p>\r\n\r\n<p>3.2 Наявність та стан технологічного обладнання і технічної бази для його обслуговування;</p>\r\n\r\n<p>3.3 Освітній та кваліфікаційний рівень працівників, необхідний для провадження відповідного виду господарської діяльності;</p>\r\n\r\n<p>3.4&nbsp; Наявність матеріально-технічної бази, необхідної для провадження відповідного виду господарської діяльності;</p>\r\n\r\n<p>3.5 Технічний стан трубопроводів та споруд на них (на підставі експлуатаційної документації на такі об&rsquo;єкти);</p>\r\n\r\n<p>3.6 Наявність проектної і виконавчої документації на трубопроводи та споруди на них, які використовуються для провадження відповідного виду господарської діяльності;</p>\r\n\r\n<p>3.7 Перелік трубопроводів, що перебувають у користуванні заявника &ndash; суб&rsquo;єкта господарювання, їх технічна характеристика та річні обсяги транспортування теплової енергії;</p>\r\n\r\n<p>3.8 Перелік приладів обліку із зазначенням місць їх встановлення;</p>\r\n\r\n<p>3.9&nbsp; Схема трубопроводів, нанесена на географічну карту місцевості;</p>\r\n\r\n<p>3.10&nbsp; Копія затвердженої міс цевим органом виконавчої влади схеми теплопостачання;</p>\r\n\r\n<p>3.11 Засвідчені в установленому порядку копії актів і схем розмежування&nbsp; ділянок обслуговування між суб&rsquo;єктами господарювання, трубопроводи яких з&rsquo;єднані між собою;</p>\r\n\r\n<p>3.12 Баланс підприємства на останню звітню дату за підписом керівника суб&rsquo;єкта&nbsp; господарювання, скріпленим печаткою;</p>\r\n\r\n<p>3.13 Засвідчені в установленому порядку копії документав, що підтверджують освітний і кваліфікаційний рівень працівників, необхідний для провадження відповідного виду господарської діяльності.</p>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;</p>\r\n', '<p>Одна мінімальна заробітна плата виходячи з її розміру на дату прийняття органам ліцензування рішення про видачу ліцензії.</p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії</p>\r\n', '<p>Одержувач: Г<strong>УДКСУ в Одеській області</strong></p>\r\n\r\n<p>Банк одержувача: Г<strong>УДКСУ в Одеській області</strong></p>\r\n\r\n<p>ОКПО (код):&nbsp;<strong>37607526</strong></p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;<strong>31413511700001</strong></p>\r\n\r\n<p>МФО (код банку):&nbsp;<strong>828011</strong></p>\r\n\r\n<p>Код платежу:&nbsp;<strong>22010200</strong></p>\r\n\r\n<p>Призначення платежу:&nbsp;<strong>плата за видачу ліцензій</strong></p>\r\n', '<p>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж 10 робочих днів з дати надходження заяви про видачу ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної</p>\r\n', '<p>Відмова у видачі ліцензії:</p>\r\n\r\n<p>Недостовірність даних у документах, поданих заявником, для отримання ліцензії;</p>\r\n\r\n<p>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</p>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<p>Заява подана (підписана) особою, яка не має на це повноважень;</p>\r\n\r\n<p>Документи оформлені з порушенням вимог;</p>\r\n\r\n<p>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення</p>\r\n', '<p>Ліцензія&nbsp; на право провадження господарської діяльності з виробництва та транспортування теплової енергії магістральними та місцевими (розподільчими) тепловими мережами або залишення заяви без розгляду</p>\r\n', '<p>через Центр надання адміністративних послуг</p>\r\n', 'так', 0, NULL, 0, NULL, NULL, NULL, NULL),
(3, 'Висновок по проекту землеустрою щодо відведення земельної ділянки або технічній документації по встановленню меж земельної ділянки', 1, 1, '<p>Земельний кодекс України, ст.ст. 123, 124, 186-1;</p>\r\n\r\n<p>Закон України &laquo;Про землеустрій&raquo;, Закон України &laquo;Про внесення змін до деяких законодавчих актів України щодо вдосконалення процедури відведення земельних ділянок та зміни їх цільового призначення&raquo;.</p>\r\n', '<p>z</p>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради</p>\r\n', '<p>1.Звернення УЗР або</p>\r\n\r\n<p>землевпорядної організації;</p>\r\n\r\n<p>2.Проект землеустрою або</p>\r\n\r\n<p>технічна документація, розроблені землевпорядною організацією відповідно до Еталону (див. п.6)</p>\r\n', 0, '', '', '', '<p>10 робочих днів з дня надання проекту землеустрою на погодження до виконавчого органу</p>\r\n', '<p>Надана документація не відповідає вимогам нормативно-правових актів, зокрема Еталону (див. п.6), у тому числі:&nbsp;</p>\r\n\r\n<p>- не надано відкорегований&nbsp; топогеодезичний план у М 1:500, прийнятий геослужбою м. Одеси;</p>\r\n\r\n<p>- відсутнє погодження суміжних землекористувачів;</p>\r\n\r\n<p>- на земельній ділянці, розташовані самовільно збудовані будівлі, на які не оформлена декларація про введення в експлуатацію;</p>\r\n\r\n<p>- відсутня фотофіксація об&rsquo;єкту;</p>\r\n\r\n<p>- об&rsquo;єкт, розташований на земельній ділянці, знаходиться в неексплуатаційному стані і потребує розробки проектно - кошторисної документації;</p>\r\n\r\n<p>- проект землеустрою розроблений з відхиленнями від погоджених УАМ меж земельної ділянки;</p>\r\n\r\n<p>-&nbsp; не встановлена площа дії сервітутів;</p>\r\n\r\n<p>-&nbsp; земельна ділянка використовується не по цільовому призначенню;</p>\r\n\r\n<p>-&nbsp; на земельній ділянці розташовані об&rsquo;єкти, цільове призначення яких не визначено;</p>\r\n\r\n<p>- &nbsp;площа земельної ділянки не обґрунтована затвердженою проектною або містобудівною документацією;</p>\r\n\r\n<p>- якщо попередній висновок УАМ втратив чинність</p>\r\n', '<p>Висновок</p>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(4, 'Державна реєстрація іноземних інвестицій', 1, 5, '<ul>\r\n	<li>Частина друга статті 13 Закону України &ldquo;Про режим іноземного інвестування&rdquo;</li>\r\n	<li>Постанова Кабінету Міністрів України від 6 березня 2013 р. № 139 Про затвердження Порядку державної реєстрації (перереєстрації) іноземних інвестицій та її анулювання</li>\r\n</ul>\r\n', '<p>Здійснення іноземної інвестиції</p>\r\n', '<p>Документи подаються іноземним інвестором або уповноваженою ним в установленому порядку особою до центру надання адміністративних послуг</p>\r\n', '<ol>\r\n	<li>Інформаційне повідомлення згідно з <a href="http://zakon3.rada.gov.ua/laws/show/139-2013-%D0%BF#n68">додатком 1</a> до Порядку державної реєстрації (перереєстрації) іноземних інвестицій та її анулювання у трьох примірниках з відміткою територіального органу Міністерства доходів і зборів за місцем здійснення інвестицій про їх фактичне здійснення.</li>\r\n	<li>Документи, що підтверджують форму здійснення іноземних інвестицій (установчі документи, договори (контракти) про виробничу кооперацію, спільне виробництво та інші види спільної інвестиційної діяльності, концесійні договори тощо).</li>\r\n	<li>Документи, які підтверджують вартість іноземних інвестицій, що визначається відповідно до статті 2 <a href="http://zakon3.rada.gov.ua/laws/show/93/96-%D0%B2%D1%80" target="_blank">Закону України &ldquo;Про режим іноземного інвестування&rdquo;</a>.</li>\r\n</ol>\r\n\r\n<p><a href="/iasnap/ckeditor/kcfinder/upload/files/nf_pov_domlennya_17_05_2013.doc">Завантажити форму інформаційного повідомлення. </a></p>\r\n', 0, '', '', '', '<p>7 днів</p>\r\n', '<p>Порушення встановленого порядку реєстрації</p>\r\n', '<p>Державна реєстрація іноземної інвестиції (інформаційне повідомлення) або відмова в наданні адміністративної послуги.</p>\r\n', '<p>Адміністративна послуга вважається надана з моменту отримання її через Управління надання адміністративних послуг Одеської міської ради</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(5, 'Перереєстрація іноземних інвестицій', 1, 5, '<p>Закон України &laquo;Про режим іноземного інвестування&raquo; Постанова Кабінету Міністрів України від 6 березня 2013 р. № 139 Про затвердження Порядку державної реєстрації (перереєстрації) іноземних інвестицій та її анулювання.</p>\r\n', '<p>---</p>\r\n', '<p>Документи подаються іноземним інвестором або уповноваженою ним в установленому порядку особою до центру надання адміністративних послуг</p>\r\n', '<p>Або:</p>\r\n\r\n<ul>\r\n	<li>письмове повідомлення про припинення іноземним інвестором своєї діяльності у зв&#39;язку з передачею (продажем) своїх інвестицій іншим суб&#39;єктам інвестиційної діяльності;</li>\r\n	<li>інформаційне повідомлення про попередню державну реєстрацію іноземних інвестицій;</li>\r\n	<li>довідку територіального органу Міністерства доходів і зборів про сплачені іноземним інвестором в Україні податки.</li>\r\n</ul>\r\n\r\n<p>Або:</p>\r\n\r\n<ul>\r\n	<li>інформаційне повідомлення згідно з додатком 1 до Порядку державної реєстрації (перереєстрації) іноземних інвестицій та її анулювання у трьох примірниках з відміткою територіального органу Міністерства доходів і зборів за місцем здійснення інвестицій про їх фактичне здійснення</li>\r\n	<li>документи, що підтверджують форму здійснення іноземних інвестицій (установчі документи, договори (контракти) про виробничу кооперацію, спільне виробництво та інші види спільної інвестиційної діяльності, концесійні договори тощо);</li>\r\n	<li>документи, які підтверджують вартість іноземних інвестицій, що визначається відповідно до статті 2 Закону України &ldquo;Про режим іноземного інвестування&rdquo;.</li>\r\n</ul>\r\n', 0, '', '', '', '<p>7 днів</p>\r\n', '<p>Порушення встановленого порядку перереєстрації</p>\r\n', '<p>Державна реєстрація іноземної інвестиції (інформаційне повідомлення) або відмова в наданні адміністративної послуги.</p>\r\n', '<p>Адміністративна послуга вважається надана з моменту отримання її через Управління надання адміністративних послуг Одеської міської ради</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(6, 'Анулювання державної реєстрації іноземних інвестицій', 1, 5, '<p>Постанова Кабінету Міністрів України від 6 березня 2013 р. № 139 Про затвердження Порядку державної реєстрації (перереєстрації) іноземних інвестицій та її анулювання</p>\r\n', '<p>---</p>\r\n', '<p>Документи подаються іноземним інвестором або уповноваженою ним в установленому порядку особою до центру надання адміністративних послуг</p>\r\n', '<ul>\r\n	<li>письмове повідомлення про припинення іноземним інвестором своєї діяльності у зв&#39;язку з передачею (продажем) своїх інвестицій іншим суб&#39;єктам інвестиційної діяльності;</li>\r\n	<li>інформаційне повідомлення про попередню державну реєстрацію іноземних інвестицій;</li>\r\n	<li>довідку територіального органу Міністерства доходів і зборів про сплачені іноземним інвестором в Україні податки.</li>\r\n</ul>\r\n', 0, '', '', '', '<p>7 днів</p>\r\n', '<p>Порушення встановленого порядку анулювання</p>\r\n', '<p>Анулювання іноземної інвестиції або відмова в наданні адміністративної послуги.</p>\r\n', '<p>Адміністративна послуга вважається надана з моменту отримання її через Управління надання адміністративних послуг Одеської міської ради</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(7, 'Видача дубліката інформаційного повідомлення про внесення іноземної інвестиції, у разі його втрати (знищення)', 1, 5, '<p>Постанова Кабінету Міністрів України від 6 березня 2013 р. № 139 Про затвердження Порядку державної реєстрації (перереєстрації) іноземних інвестицій та її анулювання.</p>\r\n', '<p>---</p>\r\n', '<p>Документи подаються іноземним інвестором або уповноваженою ним в установленому порядку особою до центру надання адміністративних послуг.</p>\r\n', '<p>Опубліковане в офіційних друкованих засобах масової інформації оголошення про визнання недійсним втраченого інформаційного повідомлення.</p>\r\n', 0, '', '', '', '<p>5 днів</p>\r\n', '<p>Порушення встановленого порядку видачі дублікату.</p>\r\n', '<p><strong>Видача дублікату інформаційного повідомлення або відмова в наданні адміністративної послуги.</strong></p>\r\n', '<p>Адміністративна послуга вважається надана з моменту отримання її через Управління надання адміністративних послуг Одеської міської ради.</p>\r\n', 'так', 0, NULL, 0, NULL, NULL, NULL, NULL),
(8, 'Державна реєстрація договорів (контрактів) про спільну інвестиційну діяльність за участю іноземного інвестора', 1, 5, '<p>Стаття 24 Закону України &laquo;Про режим іноземного інвестування&raquo;; Постанова Кабінету Міністрів України від 30.01.1997 №112 &quot;Про затвердження Положення про порядок державної реєстрації договорів (контрактів) про спільну інвестиційну діяльність за участю іноземного інвестора&quot;; Наказ Міністерства зовнішніх економічних зв&#39;язків і торгівлі України від 20.02.1997 р. №125 України &laquo;Про заходи МЗЕЗторгу щодо забезпечення виконання Постанови КМУ від 30.01.1997 р. № 112&raquo;.</p>\r\n', '<p>---</p>\r\n', '<p>Суб&#39;єкт зовнішньоекономічної діяльності України - учасник договору (контракту), якому доручено ведення спільних справ учасників, або уповноважена ним особа подає документи до центру надання адміністративних послуг</p>\r\n', '<ol>\r\n	<li>лист-звернення про державну реєстрацію договору (контракту);</li>\r\n	<li>інформаційна картка договору (контракту) за формою, що встановлює Мінекономрозвитку;</li>\r\n	<li>договір (контракт) (оригінал і копію), засвідчені в установленому порядку;</li>\r\n	<li>засвідчені копії установчих документів суб&rsquo;єкта (суб&rsquo;єктів) зовнішньоекономічної діяльності України та свідоцтва про його державну реєстрацію як суб&rsquo;єкта підприємницької діяльності;</li>\r\n	<li>документи, що свідчать про реєстрацію (створення) іноземної юридичної особи (нерезидента) в країні її місцезнаходження (витяг із торгівельного, банківського або судового реєстру тощо). Ці документи повинні бути засвідчені відповідно до законодавства країни їх видачі, перекладенні українською мовою та легалізовані у консульській установі України, якщо міжнародними договорами, в яких бере участь Україна, не передбачено інше. Зазначені документи можуть бути засвідчені також у посольстві відповідної держави в Україні та легалізовані в МЗС;</li>\r\n	<li>ліцензію, якщо згідно із законодавством України цього вимагає діяльність, що передбачається договором (контрактом);</li>\r\n	<li>документ про оплату послуг за державну реєстрацію договору (контракту).</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 30.01.1997 №112 &quot;Про затвердження Положення про порядок державної реєстрації договорів (контрактів) про спільну інвестиційну діяльність за участю іноземного інвестора&quot;.</p>\r\n', '<p>Шість неоподатковуваних мінімумів доходів громадян, встановлених на день реєстрації.</p>\r\n', '<p><a href="/iasnap/ckeditor/kcfinder/upload/files/nomera_rahunk_v_cajt.xls">Завантажити файл з банківськими реквізитами.</a></p>\r\n', '<p>20 днів</p>\r\n', '<p>Порушення встановленого порядку реєстрації</p>\r\n', '<p><strong>Державна реєстрація договору (контракту) про спільну інвестиційну діяльність за участю іноземного інвестора або відмова в наданні адміністративної послуги.</strong></p>\r\n', '<p>Адміністративна послуга вважається надана з моменту отримання її через Управління надання адміністративних послуг Одеської міської ради.</p>\r\n', 'так', 0, NULL, 0, NULL, NULL, NULL, NULL),
(9, 'Реєстрація статутів (положень) релігійних громад та змін до них', 1, 6, '<p>Закон України &laquo;Про свободу совісті та релігійні організації&raquo; від 23 квітня 1991 року&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; №&nbsp;987-ХІІ (стаття 14).&nbsp;</p>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', '<p>1.Заява засновників (членів) релігійної громади на ім&rsquo;я голови облдержадміністрації (заяву підписують не менше 10 повнолітніх громадян. Підписи завіряються нотаріально).</p>\r\n\r\n<p>2. Статут релігійної громади, прийнятий на загальних зборах віруючих громадян (прошиті, 5 примірників).</p>\r\n\r\n<p>3. Документ, що підтверджує місцезнаходження релігійної громади (підпис завіряється нотаріально).</p>\r\n\r\n<p>4. Протокол установчих (загальних) зборів віруючих громадян ( 2 примірника).</p>\r\n\r\n<p>5. Оригінали реєстраційних документів релігійної громади (у разі реєстрації статуту релігійної громади у нової редакції).</p>\r\n\r\n<p>Всі документи оформляються державною мовою.</p>\r\n\r\n<p>Статут не повинен суперечити чинному законодавству.</p>\r\n\r\n<p><a href="Завантажити зразок заяви про реєстрацію статуту релігійної громади">Завантажити зразок заяви про реєстрацію статуту релігійної громади</a>&nbsp;</p>\r\n', 0, '', '', '', '<p>Відповідно до статті 14 Закону України &laquo;Про свободу совісті та релігійні організації&raquo; обласна державна адміністрація в місячний термін розглядає заяву, статут (положення) релігійної громади, приймає відповідне рішення&nbsp; і не пізніш як у десятиденний термін письмово повідомляє про нього заявникам. У необхідних випадках облдержадміністрація може зажадати висновок місцевої державної адміністрації, виконавчого комітету сільської, селищної, міської Рад народних депутатів, а також спеціалістів. У цьому разі рішення приймається у тримісячний термін.</p>\r\n', '<p>---</p>\r\n', '<p><strong>Розпорядження голови обласної державної адміністрації; рішення про відмову в реєстраціях статуту (положення) релігійної громади із зазначенням підстав відмови.</strong></p>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`) VALUES
(10, 'Дозвіл на викиди забруднюючих речовин в атмосферне повітря стаціонарними джерелами (для об’єктів другої та третьої груп)', 1, 7, '<ul>\r\n	<li>Закон України &quot;Про Перелік документів дозвільного характеру у сфері господарської діяльності&quot; (п. 30) ;</li>\r\n	<li>Закон України &quot;Про охорону атмосферного повітря&quot; (ст. 11).</li>\r\n</ul>\r\n', '<p>Здійснення діяльності пов&rsquo;язаної з викидами в атмосферне повітря</p>\r\n', '<p>Документи подаються через Центр надання адміністративних послуг Одеської міської ради суб&#39;єктом господарювання (керівником юридичної особи, фізичною особою - підприємцем) або уповноваженою особою. Уповноважена особа повинна мати документ, який підтверджує її повноваження.&nbsp;</p>\r\n', '<ol>\r\n	<li>Заява (наказ Міністерства охорони навколишнього природного середовища України 30.05.2006 № 266)</li>\r\n	<li>Документи, в яких обґрунтовуються обсяги викидів забруднюючих речовин (в письмовій та в електронній формі XML-файли);</li>\r\n	<li>Звіт з інвентаризації стаціонарних джерел викидів забруднюючих речовин в атмосферне повітря, видів та обсягів викидів забруднюючих речовин в атмосферне повітря стаціонарними&nbsp; джерелами, пилогазоочисного обладнання;</li>\r\n	<li>Оцінка впливу викидів забруднюючих речовин на стан атмосферного повітря на межі санітарно-захисної зони (тільки для суб&rsquo;єктів господарювання, об&rsquo;єкти яких належать до 2 групи).</li>\r\n	<li>Плани заходів (тільки для суб&rsquo;єктів господарювання, об&rsquo;єкти яких належать до 2 групи) щодо:</li>\r\n</ol>\r\n\r\n<ul>\r\n	<li>досягнення встановлених нормативів граничнодопустимих викидів для найбільш поширених і небезпечних забруднюючих речовин;</li>\r\n	<li>охорони атмосферного повітря на випадок виникнення надзвичайних ситуацій техногенного та природного характеру;</li>\r\n	<li>ліквідації причин і наслідків забруднення атмосферного повітря;</li>\r\n	<li>остаточного припинення діяльності, пов&#39;язаної з викидами забруднюючих речовин в атмосферне повітря, та приведення місця діяльності у задовільний стан;</li>\r\n	<li>запобігання перевищенню встановлених нормативів граничнодопустимих викидів у процесі виробництва;</li>\r\n	<li>здійснення контролю за дотриманням встановлених нормативів граничнодопустимих викидів забруднюючих речовин та умов дозволу на викиди.</li>\r\n</ul>\r\n\r\n<ol>\r\n	<li>Обґрунтування розмірів нормативних санітарно-захисних зон, оцінка витрат, пов`язаних з реалізацією заходів щодо їх створення.</li>\r\n	<li>Оцінка та аналіз витрат, пов`язаних з реалізацією запланованих заходів щодо запобігання забрудненню атмосферного повітря (тільки для суб&rsquo;єктів господарювання, об&rsquo;єкти яких належать до 2 групи).</li>\r\n	<li>Копія повідомлення про намір отримати дозвіл на викиди, розміщене в місцевих друкованих засобах масової інформації.</li>\r\n	<li>Висновок щодо видачі дозволу установи державної санітарно-епідеміологічної служби.</li>\r\n	<li>Лист &mdash; повідомлення місцевої державної адміністрації щодо наявності зауважень громадських організацій та громадян.</li>\r\n	<li>Копія публікації у ЗМІ з інформацією про отримання дозволу для ознайомлення з нею громадськості.</li>\r\n	<li>Для отримання дозволу на новостворені стаціонарні джерела - позитивний висновок комплексної державної експертизи або позитивні висновки державної санітарно-гігієнічної та державної екологічної експертиз.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Строк видачі документів дозвільного характеру становить &ndash; 30 календарних днів з дня одержання заяви та документів.</p>\r\n', '<ul>\r\n	<li>подання суб&#39;єктом господарювання неповного пакета документів, необхідних для одержання документа дозвільного характеру;</li>\r\n	<li>&nbsp;виявлення в документах, поданих суб&#39;єктом господарюванняосподарювання, даних суб&#39;єктом , недостовірних відомостей;</li>\r\n	<li>негативний висновок за результатами проведених експертиз та обстежень або інших наукових і технічних оцінок, необхідних для видачі документа дозвільного характеру;</li>\r\n	<li>виявлення ознак об&#39;єкта першої групи;</li>\r\n	<li>невідповідність представленої документації наказу Мінприроди України від 09.03.2006 № 108;</li>\r\n	<li>невиконання умов попереднього дозволу.</li>\r\n</ul>\r\n\r\n<p>Законом можуть встановлюватися інші підстави для відмови у видачі документа дозвільного характеру.</p>\r\n', '<p>Дозвіл на викиди забруднюючих речовин в атмосферне повітря стаціонарними джерелами. Дозвіл видається на термін не менш як п&#39;ять років</p>\r\n', '<p>Управління надання адміністративних послуг Одеської&nbsp; міської ради</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(11, 'Переоформлення дозволу на викиди забруднюючих речовин в атмосферне повітря стаціонарними джерелами', 1, 7, '<p>Закон України &quot;Про дозвільну систему у сфері господарської діяльності&quot; (ст. 4-1)</p>\r\n', '<ol>\r\n	<li>Зміна найменування суб&#39;єкта господарювання - юридичної особи або прізвища, імені, по батькові фізичної особи - підприємця.</li>\r\n	<li>Зміна місцезнаходження суб&#39;єкта господарювання.</li>\r\n	<li>Законом можуть бути встановлені інші підстави для переоформлення документа дозвільного характеру.</li>\r\n</ol>\r\n', '<p>Документи подаються через Центр надання адміністративних послуг Одеської міської ради особисто суб&#39;єктом господарювання (керівником юридичної особи, фізичною особою - підприємцем) або уповноваженою особою. Уповноважена особа повинна мати документ, який підтверджує її повноваження. Заява та документи, що додаються до неї, можуть бути надіслані рекомендованим листом з описом вкладення, при цьому підпис заявника (фізичної особи - підприємця) та уповноваженої ним особи засвідчується нотаріально.</p>\r\n', '<ol>\r\n	<li>Довіреність (за необхідністю)</li>\r\n	<li>Заява про переоформлення документа дозвільного характеру - затверджена постановою КМУ від 07.12.2005 № 1176;</li>\r\n	<li>Документ дозвільного характеру, що підлягає переоформленню;</li>\r\n	<li>Документ, що підтверджує зміни, які являються підставою для переоформлення документа дозвільного характеру.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Протягом двох робочих днів з дня одержання заяви про переоформлення документа дозвільного характеру та документів, що додаються до неї.</p>\r\n', '<p>Подання суб&#39;єктом господарювання неповного пакета документів</p>\r\n', '<p>Видача переоформленого документа дозвільного характеру.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(12, 'Видача дубліката дозволу на викиди забруднюючих речовин в атмосферне повітря стаціонарними джерелами', 1, 7, '<p>Закон України &quot;Про дозвільну систему у сфері господарської діяльності&quot; (ст. 4-1)</p>\r\n', '<ol>\r\n	<li>Втрата документа дозвільного характеру;</li>\r\n	<li>Пошкодження документа дозвільного характеру.</li>\r\n	<li>Законом можуть бути встановлені інші підстави для видачі дубліката документа дозвільного характеру.</li>\r\n</ol>\r\n', '<p>Документи подаються через Центр надання адміністративних послуг особисто суб&#39;єктом господарювання (керівником юридичної особи, фізичною особою - підприємцем) або уповноваженою особою. Уповноважена особа повинна мати документ, який підтверджує її повноваження.</p>\r\n', '<ol>\r\n	<li>Довіреність (за необхідністю)</li>\r\n	<li>Заява про видачу дубліката документа дозвільного характеру - затверджена постановою КМУ від 07.12.2005 № 1176;</li>\r\n	<li>Пошкоджений документ дозвільного характеру.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Протягом двох робочих днів з дня одержання заяви про видачу дубліката документа дозвільного характеру.</p>\r\n', '<p>Подання суб&#39;єктом господарювання неповного пакета документів.</p>\r\n', '<p>Видача дубліката дозволу на викиди забруднюючих речовин в атмосферне повітря стаціонарними джерелами.</p>\r\n', '<p>Через Центр надання адміністративих послуг Одеської міської ради.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(13, 'Видача ліцензії на надання освітніх послуг у сфері загальної середньої освіти', 1, 8, '<ol>\r\n	<li>Закон України від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 13.05.1999 №651-ХІV &nbsp;&laquo;Про загальну середню освіту&raquo;, ст.&nbsp;8 п.1.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері загальної середньої освіти за затвердженою Міністерством освіти і науки, молоді та спорту України формою, до якої додається пакет документів.</p>\r\n', '<ol>\r\n	<li>Заява про проведення ліцензування із зазначенням виду освітньої послуги і ліцензованого обсягу, реквізитів навчального закладу за затвердженою Міністерством освіти і науки, молоді та спорту України формою.</li>\r\n	<li>Копії установчих документів (статуту, положення, рішення засновника (власника) або уповноваженого ним органу про створення навчального закладу).</li>\r\n	<li>Копії рішень про утворення відокремлених підрозділів та положення про них (у разі ліцензування освітніх послуг у відокремленому підрозділі).</li>\r\n	<li>Концепція діяльності за заявленою освітньою послугою, яка ґрунтується на результатах моніторингу регіонального ринку освітніх послуг.</li>\r\n	<li>Копія робочого навчального плану, затвердженого в установленому порядку.</li>\r\n	<li>Відомості про кількісні та якісні показники кадрового забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про кількісні показники матеріально-технічного забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про навчально-методичне забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про кількісні показники інформаційного забезпечення освітньої діяльності, наявність бібліотеки та обсяг її фондів.</li>\r\n	<li>Копії документів, що засвідчують право власності (свідоцтво про право власності, договір купівлі-продажу), оперативного управління (рішення чи повідомлення власника майна про перебування майна в оперативному управлінні) чи користування (договір оренди) основними засобами для здійснення навчально-виховного процесу на строк, необхідний для завершення надання послуги.</li>\r\n	<li>Копії документів про відповідність приміщень навчального закладу та його матеріально-технічної бази санітарним нормам, вимогам правил пожежної безпеки.</li>\r\n	<li>Копії документів, що засвідчують рівень освіти, кваліфікації та громадянство керівника навчального закладу (диплома про вищу освіту, першої сторінки паспорта керівника навчального закладу).</li>\r\n</ol>\r\n', 1, '<p>П.&nbsp;2 постанови Кабінету Міністрів України від 29.08.2003 №1380 &laquo;Про ліцензування освітніх послуг&raquo;.</p>\r\n', '<ul>\r\n	<li>Плата за видачу ліцензії на надання освітніх послуг справляється в розмірі п&rsquo;ятнадцяти неоподаткованих мінімумів доходів громадян.</li>\r\n	<li>Плата за переоформлення ліцензії, за видачу копії та дубліката ліцензії справляється в розмірі п&rsquo;яти неоподаткованих мінімумів доходів громадян.</li>\r\n</ul>\r\n', '<p>Внесення суб&rsquo;єктом звернення плати за видачу, переоформлення ліцензії, видачу копії та дубліката ліцензії здійснюється на р/р&nbsp;31413511700001 код&nbsp;37607526 МФО&nbsp;828011, одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200.</p>\r\n', '<p>Загальний строк прийняття суб&rsquo;єктом надання адміністративної послуги рішення про видачу або відмову у видачі ліцензії не може перевищувати трьох місяців.</p>\r\n', '<ul>\r\n	<li>недостовірність даних у документах, поданих суб&rsquo;єктом звернення, для отримання ліцензії;</li>\r\n	<li>невідповідність суб&rsquo;єкта звернення згідно з поданими документами ліцензійним умовам, встановленим для виду діяльності у сфері освіти, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n', '<p>Суб&rsquo;єкт звернення отримує ліцензію на право провадження діяльності у сфері освіти на бланку ліцензії єдиного зразка. Ліцензія видається на строк від 3 до 12 років включно.</p>\r\n', '<ol>\r\n	<li>Суб&rsquo;єкт звернення надає до Центру надання адміністративних послуг платіжні документи, що засвідчують плату&nbsp; за видачу ліцензії&nbsp; (переоформлення ліцензії, видачу копії та дубліката ліцензії), та оплату послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування.</li>\r\n	<li>Суб&rsquo;єкт звернення особисто отримує ліцензію на надання освітніх послуг у сфері загальної середньої освіти в Центрі надання адміністративних послуг Одеської міської ради.</li>\r\n</ol>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(14, 'Видача дубліката ліцензії на надання освітніх послуг у сфері загальної середньої освіти', 1, 8, '<ol>\r\n	<li>Закон України від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 13.05.1999 №651-ХІV &nbsp;&laquo;Про загальну середню освіту&raquo;, ст.&nbsp;8 п.1.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері загальної середньої освіти за затвердженою Міністерством освіти і науки, молоді та спорту України формою, до якої додається пакет документів.</p>\r\n', '<ol>\r\n	<li>Заява про видачу дубліката ліцензії.</li>\r\n	<li>У разі пошкодження ліцензії &ndash; пошкоджений оригінал.</li>\r\n</ol>\r\n', 1, '<p>П.&nbsp;2 постанови Кабінету Міністрів України від 29.08.2003 №1380 &laquo;Про ліцензування освітніх послуг&raquo;.</p>\r\n', '<p>Плата за видачу дубліката ліцензії справляється в розмірі п&rsquo;яти неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p>Внесення суб&rsquo;єктом звернення плати за видачу дубліката ліцензії здійснюється на р/р&nbsp;31413511700001 код&nbsp;37607526 МФО&nbsp;828011, одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200.</p>\r\n', '<p>10 робочих днів після надходження заяви.</p>\r\n', '<p>Підставою для прийняття рішення про відмову у видачі дубліката ліцензії є недостовірність даних у документах, поданих суб&rsquo;єктом звернення, для отримання ліцензії.</p>\r\n', '<p>Суб&rsquo;єкт звернення отримує дублікат ліцензії на право провадження діяльності у сфері освіти на бланку ліцензії єдиного зразка.</p>\r\n', '<p>Суб&rsquo;єкт звернення надає до Центру надання адміністративних послуг платіжні документи, що засвідчують плату за видачу дубліката ліцензії та особисто отримує дублікат ліцензії на надання освітніх послуг у сфері загальної середньої освіти.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(15, 'Видача копії ліцензії на надання освітніх послуг у сфері загальної середньої освіти', 1, 8, '<ol>\r\n	<li>Закон України від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 13.05.1999 №651-ХІV &nbsp;&laquo;Про загальну середню освіту&raquo;, ст.&nbsp;8 п.1.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері загальної середньої освіти за затвердженою Міністерством освіти і науки, молоді та спорту України формою до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>1Заява про проведення ліцензування із зазначенням виду освітньої послуги і ліцензованого обсягу, реквізитів навчального закладу за затвердженою Міністерством освіти і науки, молоді та спорту України формою.</li>\r\n	<li>Копії установчих документів (статуту, положення, рішення засновника (власника) або уповноваженого ним органу про створення навчального закладу).</li>\r\n	<li>Копії рішень про утворення відокремлених підрозділів та положення про них (у разі ліцензування освітніх послуг у відокремленому підрозділі).</li>\r\n	<li>Концепція діяльності за заявленою освітньою послугою, яка ґрунтується на результатах моніторингу регіонального ринку освітніх послуг.</li>\r\n	<li>Відомості про кількості та якісні показники кадрового забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про кількісні показники матеріально-технічного забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про навчально-методичне забезпечення освітньої діяльності.</li>\r\n	<li>Копії документів, що засвідчують право власності (свідоцтво про право власності, договір купівлі-продажу), оперативного управління (рішення чи повідомлення власника майна про перебування майна в оперативному управлінні) чи користування (договір оренди) основними засобами для здійснення навчально-виховного процесу на строк, необхідний для завершення надання послуги.</li>\r\n	<li>Копії документів про відповідність приміщень навчального закладу та його матеріально-технічної бази санітарним нормам, вимогам правил пожежної безпеки.</li>\r\n	<li>Копії документів, що засвідчують рівень освіти, кваліфікації та громадянство керівника навчального закладу (диплома про вищу освіту, першої сторінки паспорта керівника навчального закладу).</li>\r\n</ol>\r\n', 1, '<p>П.&nbsp;2 постанови Кабінету Міністрів України від 29.08.2003 №1380 &laquo;Про ліцензування освітніх послуг&raquo;.</p>\r\n', '<p>Плата за видачу копії ліцензії справляється в розмірі п&rsquo;яти неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p>Внесення суб&rsquo;єктом звернення плати за видачу копії ліцензії здійснюється на р/р&nbsp;31413511700001 код&nbsp;37607526 МФО&nbsp;828011, одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200.</p>\r\n', '<p>Строк прийняття суб&rsquo;єктом надання адміністративної послуги рішення про видачу або відмову у видачі ліцензії не може перевищувати трьох місяців.</p>\r\n', '<ul>\r\n	<li>недостовірність даних у документах, поданих суб&rsquo;єктом звернення, для отримання ліцензії;</li>\r\n	<li>невідповідність суб&rsquo;єкта звернення згідно з поданими документами ліцензійним умовам, встановленим для виду діяльності у сфері освіти, зазначеного в заяві про видачу копії ліцензії.</li>\r\n</ul>\r\n', '<p>Суб&rsquo;єкт звернення отримує копію ліцензії на право провадження діяльності у сфері освіти на бланку ліцензії єдиного зразка.</p>\r\n', '<ol>\r\n	<li>Суб&rsquo;єкт звернення надає до Центру надання адміністративних послуг платіжні документи, що засвідчують плату за видачу копії ліцензії&nbsp; та оплату послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування.</li>\r\n	<li>Суб&rsquo;єкт звернення особисто отримує копію ліцензії на надання освітніх послуг у сфері загальної середньої освіти в Центрі надання адміністративних послуг Одеської міської ради.</li>\r\n</ol>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(16, 'Переоформлення ліцензії на надання освітніх послуг у сфері загальної середньої освіти', 1, 8, '<ol>\r\n	<li>Закон України від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 13.05.1999 №651-ХІV &nbsp;&laquo;Про загальну середню освіту&raquo;, ст.&nbsp;8 п.1.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері загальної середньої освіти до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява про переоформлення ліцензії.</li>\r\n	<li>Копії установчих документів (статуту, положення, рішення засновника (власника) або уповноваженого ним органу про створення навчального закладу).</li>\r\n	<li>Відомості про кількісні показники кадрового забезпечення.</li>\r\n	<li>Відомості кількісні показники матеріально-технічного забезпечення освітньої діяльності.</li>\r\n	<li>Копії документів про відповідність приміщень навчального закладу та його матеріально-технічної бази санітарним нормам, вимогам правил пожежної безпеки.</li>\r\n</ol>\r\n', 1, '<p>П.&nbsp;2 постанови Кабінету Міністрів України від 29.08.2003 №1380 &laquo;Про ліцензування освітніх послуг&raquo;.</p>\r\n', '<p>Плата за переоформлення ліцензії справляється в розмірі п&rsquo;яти неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p>Внесення суб&rsquo;єктом звернення плати за переоформлення ліцензії здійснюється на р/р&nbsp;31413511700001 код&nbsp;37607526 МФО&nbsp;828011, одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200.</p>\r\n', '<p>Розгляд на черговому засіданні Регіональної експертної ради з питань ліцензування та атестації навчальних закладів (не рідше одного разу на 2 місяці).</p>\r\n', '<p>Підставою для прийняття рішення про відмову у переоформленні ліцензії є недостовірність даних у документах, поданих суб&rsquo;єктом звернення, для переоформлення ліцензії.</p>\r\n', '<p>Суб&rsquo;єкт звернення отримує ліцензію на право провадження діяльності у сфері освіти на бланку ліцензії єдиного зразка.</p>\r\n', '<p>Суб&rsquo;єкт звернення надає до Центру надання адміністративних послуг платіжні документи, що засвідчують плату&nbsp; за переоформлення ліцензії&nbsp; та оплату послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування (у разі проведення експертизи).&nbsp; Суб&rsquo;єкт звернення особисто отримує переоформлену ліцензію на надання освітніх послуг у сфері загальної середньої освіти в Центрі надання адміністративних послуг Одеської міської ради.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(17, 'Анулювання ліцензії на надання освітніх послуг у сфері загальної середньої освіти', 1, 8, '<ol>\r\n	<li>Закон України від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 13.05.1999 №651-ХІV &nbsp;&laquo;Про загальну середню освіту&raquo;, ст.&nbsp;8 п.1.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері загальної середньої освіти до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява про анулювання ліцензії.</li>\r\n	<li>Ліцензія.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Розгляд на черговому засіданні Регіональної експертної ради з питань ліцензування та атестації навчальних закладів (не рідше одного разу на 2 місяці).</p>\r\n', '<p>---</p>\r\n', '<p>Наказ органу ліцензування відповідно до рішення&nbsp; Регіональної експертної ради з питань ліцензування та атестації навчальних закладів.</p>\r\n', '<p>На офіційному веб-сайті органу ліцензування.</p>\r\n', 'так', 0, NULL, 0, NULL, NULL, NULL, NULL),
(18, 'Видача ліцензії на надання освітніх послуг у сфері дошкільної освіти', 1, 8, '<ol>\r\n	<li>Закон України&nbsp;&nbsp; від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 11.07.2001 №2628-ІІІ &nbsp;&laquo;Про дошкільну освіту&raquo;, ст.&nbsp;11 п.3.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері дошкільної освіти&nbsp; до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява про проведення ліцензування із зазначенням виду освітньої послуги і ліцензованого обсягу, реквізитів навчального закладу за затвердженою Міністерством освіти і науки, молоді та спорту України формою.</li>\r\n	<li>Копії установчих документів (статуту, положення, рішення засновника (власника) або уповноваженого ним органу про створення навчального закладу).</li>\r\n	<li>Копії рішень про утворення відокремлених підрозділів та положення про них (у разі ліцензування освітніх послуг у відокремленому підрозділі).</li>\r\n	<li>Концепція діяльності за заявленою освітньою послугою, яка ґрунтується на результатах моніторингу регіонального ринку освітніх послуг.</li>\r\n	<li>Відомості про кількості та якісні показники кадрового забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про кількісні показники матеріально-технічного забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про навчально-методичне забезпечення освітньої діяльності.</li>\r\n	<li>Копії документів, що засвідчують право власності (свідоцтво про право власності, договір купівлі-продажу), оперативного управління (рішення чи повідомлення власника майна про перебування майна в оперативному управлінні) чи користування (договір оренди) основними засобами для здійснення навчально-виховного процесу на строк, необхідний для завершення надання послуги.</li>\r\n	<li>Копії документів про відповідність приміщень навчального закладу та його матеріально-технічної бази санітарним нормам, вимогам правил пожежної безпеки.</li>\r\n	<li>Копії документів, що засвідчують рівень освіти, кваліфікації та громадянство керівника навчального закладу (диплома про вищу освіту, першої сторінки паспорта керівника навчального закладу).</li>\r\n</ol>\r\n', 1, '<p>П.&nbsp;2 постанови Кабінету Міністрів України від 29.08.2003 №1380 &laquo;Про ліцензування освітніх послуг&raquo;.</p>\r\n', '<p>Плата за видачу ліцензії на надання освітніх послуг справляється в розмірі п&rsquo;ятнадцяти неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p>Внесення суб&rsquo;єктом звернення плати за видачу, переоформлення ліцензії, видачу копії та дубліката ліцензії здійснюється на р/р&nbsp;31413511700001 код&nbsp;37607526 МФО&nbsp;828011, одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200.</p>\r\n', '<p>Загальний строк прийняття суб&rsquo;єктом надання адміністративної послуги рішення про видачу або відмову у видачі ліцензії не може перевищувати трьох місяців.</p>\r\n', '<ul>\r\n	<li>недостовірність даних у документах, поданих суб&rsquo;єктом звернення, для отримання ліцензії;</li>\r\n	<li>невідповідність суб&rsquo;єкта звернення згідно з поданими документами ліцензійним умовам, встановленим для виду діяльності у сфері освіти, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n', '<p>Суб&rsquo;єкт звернення отримує ліцензію на право провадження діяльності у сфері освіти на бланку ліцензії єдиного зразка. Ліцензія видається на строк від 3 до 12 років включно.</p>\r\n', '<ul>\r\n	<li>Суб&rsquo;єкт звернення надає до Центру надання адміністративних послуг платіжні документи, що засвідчують плату&nbsp; за видачу ліцензії&nbsp; (переоформлення ліцензії, видачу копії та дубліката ліцензії), та оплату послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування.</li>\r\n	<li>Суб&rsquo;єкт звернення особисто отримує ліцензію на надання освітніх послуг у сфері дошкільної освіти в Центрі надання адміністративних послуг Одеської міської ради.</li>\r\n</ul>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(19, 'Видача дубліката ліцензії на надання освітніх послуг у сфері дошкільної освіти', 1, 8, '<ol>\r\n	<li>Закон України&nbsp;&nbsp; від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 11.07.2001 №2628-ІІІ &nbsp;&laquo;Про дошкільну освіту&raquo;, ст.&nbsp;11 п.3.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері дошкільної освіти до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява про видачу дубліката ліцензії.</li>\r\n	<li>У разі пошкодження ліцензії &ndash; пошкоджений оригінал.</li>\r\n</ol>\r\n', 1, '<p>П.&nbsp;2 постанови Кабінету Міністрів України від 29.08.2003 №1380 &laquo;Про ліцензування освітніх послуг&raquo;.</p>\r\n', '<p>Плата за видачу дубліката ліцензії справляється в розмірі п&rsquo;яти неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p>Внесення суб&rsquo;єктом звернення плати за видачу дубліката ліцензії здійснюється на р/р&nbsp;31413511700001 код&nbsp;37607526 МФО&nbsp;828011, одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200.</p>\r\n', '<p>10 робочих днів після надходження заяви.</p>\r\n', '<p>Підставою для прийняття рішення про відмову у видачі дубліката ліцензії є недостовірність даних у документах, поданих суб&rsquo;єктом звернення, для отримання ліцензії.</p>\r\n', '<p>Суб&rsquo;єкт звернення отримує дублікат ліцензії на право провадження діяльності у сфері освіти на бланку ліцензії єдиного зразка.</p>\r\n', '<ul>\r\n	<li>Суб&rsquo;єкт звернення надає до Центру надання адміністративних послуг платіжні документи, що засвідчують плату&nbsp; за видачу дубліката ліцензії.</li>\r\n	<li>Суб&rsquo;єкт звернення особисто отримує дублікат ліцензії на надання освітніх послуг у сфері дошкільної освіти в Центрі надання адміністративних послуг Одеської міської ради.</li>\r\n</ul>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`) VALUES
(20, 'Видача копії ліцензії на надання освітніх послуг у сфері дошкільної освіти', 1, 8, '<ol>\r\n	<li>Закон України&nbsp;&nbsp; від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 11.07.2001 №2628-ІІІ &nbsp;&laquo;Про дошкільну освіту&raquo;, ст.&nbsp;11 п.3.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері дошкільної освіти до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<p>Для відокремленого структурного підрозділу (філії тощо):</p>\r\n\r\n<ol>\r\n	<li>Заява про проведення ліцензування із зазначенням виду освітньої послуги і ліцензованого обсягу, реквізитів навчального закладу за затвердженою Міністерством освіти і науки, молоді та спорту України формою.</li>\r\n	<li>Копії установчих документів (статуту, положення, рішення засновника (власника) або уповноваженого ним органу про створення навчального закладу).</li>\r\n	<li>Копії рішень про утворення відокремлених підрозділів та положення про них (у разі ліцензування освітніх послуг у відокремленому підрозділі).</li>\r\n	<li>Концепція діяльності за заявленою освітньою послугою, яка ґрунтується на результатах моніторингу регіонального ринку освітніх послуг.</li>\r\n	<li>Відомості про кількості та якісні показники кадрового забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про кількісні показники матеріально-технічного забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про навчально-методичне забезпечення освітньої діяльності.</li>\r\n	<li>Копії документів, що засвідчують право власності (свідоцтво про право власності, договір купівлі-продажу), оперативного управління (рішення чи повідомлення власника майна про перебування майна в оперативному управлінні) чи користування (договір оренди) основними засобами для здійснення навчально-виховного процесу на строк, необхідний для завершення надання послуги.</li>\r\n	<li>Копії документів про відповідність приміщень навчального закладу та його матеріально-технічної бази санітарним нормам, вимогам правил пожежної безпеки.</li>\r\n	<li>Копії документів, що засвідчують рівень освіти, кваліфікації та громадянство керівника навчального закладу (диплома про вищу освіту, першої сторінки паспорта керівника навчального закладу).</li>\r\n</ol>\r\n', 1, '<p>П.&nbsp;2 постанови Кабінету Міністрів України від 29.08.2003 №1380 &laquo;Про ліцензування освітніх послуг&raquo;.</p>\r\n', '<p>Плата за видачу копії ліцензії справляється в розмірі п&rsquo;яти неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p>Внесення суб&rsquo;єктом звернення плати за видачу копії ліцензії здійснюється на р/р&nbsp;31413511700001 код&nbsp;37607526 МФО&nbsp;828011, одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200.</p>\r\n', '<p>Загальний строк прийняття суб&rsquo;єктом надання адміністративної послуги рішення про видачу або відмову у видачі ліцензії не може перевищувати трьох місяців.</p>\r\n', '<p>Підставами для прийняття рішення про відмову у видачі ліцензії є:</p>\r\n\r\n<ul>\r\n	<li>недостовірність даних у документах, поданих суб&rsquo;єктом звернення, для отримання ліцензії;</li>\r\n	<li>невідповідність суб&rsquo;єкта звернення згідно з поданими документами ліцензійним умовам, встановленим для виду діяльності у сфері освіти, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n', '<p>Суб&rsquo;єкт звернення отримує копію ліцензії на право провадження діяльності у сфері освіти на бланку ліцензії єдиного зразка.</p>\r\n', '<ul>\r\n	<li>Суб&rsquo;єкт звернення надає до Центру надання адміністративних послуг платіжні документи, що засвідчують плату за видачу копії ліцензії&nbsp; та оплату послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування.</li>\r\n	<li>Суб&rsquo;єкт звернення особисто отримує копію ліцензії на надання освітніх послуг у сфері дошкільної освіти в Центрі надання адміністративних послуг Одеської міської ради.</li>\r\n</ul>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(21, 'Переоформлення ліцензії на надання освітніх послуг у сфері дошкільної освіти', 1, 8, '<ol>\r\n	<li>Закон України&nbsp;&nbsp; від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 11.07.2001 №2628-ІІІ &nbsp;&laquo;Про дошкільну освіту&raquo;, ст.&nbsp;11 п.3.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері дошкільної освіти до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява про переоформлення ліцензії.</li>\r\n	<li>Копії установчих документів (статуту, положення, рішення засновника (власника) або уповноваженого ним органу про створення навчального закладу).</li>\r\n	<li>Відомості про кількісні показники кадрового забезпечення.</li>\r\n	<li>Відомості кількісні показники матеріально-технічного забезпечення освітньої діяльності.</li>\r\n	<li>Копії документів про відповідність приміщень навчального закладу та його матеріально-технічної бази санітарним нормам, вимогам правил пожежної безпеки.</li>\r\n</ol>\r\n', 1, '<p>П.&nbsp;2 постанови Кабінету Міністрів України від 29.08.2003 №1380 &laquo;Про ліцензування освітніх послуг&raquo;.</p>\r\n', '<p>Плата за переоформлення ліцензії справляється в розмірі п&rsquo;яти неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p>Внесення суб&rsquo;єктом звернення плати за переоформлення ліцензії здійснюється на р/р&nbsp;31413511700001 код&nbsp;37607526 МФО&nbsp;828011, одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200.</p>\r\n', '<p>Розгляд на черговому засіданні Регіональної експертної ради з питань ліцензування та атестації навчальних закладів (не рідше одного разу на 2 місяці).</p>\r\n', '<p>Підставою для прийняття рішення про відмову у переоформленні ліцензії є недостовірність даних у документах, поданих суб&rsquo;єктом звернення, для переоформлення ліцензії.</p>\r\n', '<p>Суб&rsquo;єкт звернення отримує ліцензію на право провадження діяльності у сфері освіти на бланку ліцензії єдиного зразка.</p>\r\n', '<ul>\r\n	<li>Суб&rsquo;єкт звернення надає до Центру надання адміністративних послуг платіжні документи, що засвідчують плату&nbsp; за переоформлення ліцензії&nbsp; та оплату послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування (у разі проведення експертизи).</li>\r\n	<li>Суб&rsquo;єкт звернення особисто отримує переоформлену ліцензію на надання освітніх послуг у сфері дошкільної освіти в Центрі надання адміністративних послуг Одеської міської ради.</li>\r\n</ul>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(22, 'Анулювання ліцензії на надання освітніх послуг у сфері дошкільної освіти', 1, 8, '<ol>\r\n	<li>5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 11.07.2001 №2628-ІІІ &nbsp;&laquo;Про дошкільну освіту&raquo;, ст.&nbsp;11 п.3.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері дошкільної освіти до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява про анулювання ліцензії.</li>\r\n	<li>Ліцензія.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Розгляд на черговому засіданні Регіональної експертної ради з питань ліцензування та атестації навчальних закладів (не рідше одного разу на 2 місяці).</p>\r\n', '<p>---</p>\r\n', '<p>Наказ органу ліцензування відповідно до рішення&nbsp; Регіональної експертної ради з питань ліцензування та атестації навчальних закладів.</p>\r\n', '<p>На офіційному веб-сайті органу ліцензування.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(23, 'Видача ліцензії на надання освітніх послуг у сфері позашкільної освіти ', 1, 8, '<ol>\r\n	<li>Закон України&nbsp;&nbsp; від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 22.06.2000 №1841-ІІІ &nbsp;&laquo;Про позашкільну освіту&raquo;, ст.&nbsp;14 п.&nbsp;3.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері позашкільної освіти до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява про проведення ліцензування із зазначенням виду освітньої послуги і ліцензованого обсягу, реквізитів навчального закладу за затвердженою Міністерством освіти і науки, молоді та спорту України формою.</li>\r\n	<li>Копії установчих документів (статуту, положення, рішення засновника (власника) або уповноваженого ним органу про створення навчального закладу).</li>\r\n	<li>Копії рішень про утворення відокремлених підрозділів та положення про них (у разі ліцензування освітніх послуг у відокремленому підрозділі).</li>\r\n	<li>Концепція діяльності за заявленою освітньою послугою, яка ґрунтується на результатах моніторингу регіонального ринку освітніх послуг, затверджена керівником та скріплена печаткою навчального закладу, а також погоджена управлінням освіти і науки Одеської облдержадміністрації.</li>\r\n	<li>Копія навчального плану (навчальних планів), затвердженого в установленому порядку.</li>\r\n	<li>Відомості про кількісні та якісні показники кадрового забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про кількісні показники матеріально-технічного забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про навчально-методичне забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про інформаційне забезпечення освітньої діяльності.</li>\r\n	<li>Копії документів, що засвідчують право власності (свідоцтво про право власності, договір купівлі-продажу), оперативного управління (рішення чи повідомлення власника майна про перебування майна в оперативному управлінні) чи користування (договір оренди) основними засобами для здійснення навчально-виховного процесу на строк, необхідний для завершення надання послуги.</li>\r\n	<li>Копії документів про відповідність приміщень навчального закладу та його матеріально-технічної бази санітарним нормам, вимогам правил пожежної безпеки.</li>\r\n	<li>Копії документів, що засвідчують рівень освіти, кваліфікації та громадянство керівника навчального закладу (диплома про вищу освіту, першої сторінки паспорта керівника навчального закладу).</li>\r\n</ol>\r\n', 1, '<p>П.&nbsp;2 постанови Кабінету Міністрів України від 29.08.2003 №1380 &laquo;Про ліцензування освітніх послуг&raquo;.</p>\r\n', '<p>Плата за видачу ліцензії на надання освітніх послуг справляється в розмірі п&rsquo;ятнадцяти неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p>Внесення заявником плати за видачу, переоформлення ліцензії, видачу копії та дубліката ліцензії здійснюється на р/р&nbsp;31413511700001 код&nbsp;37607526 МФО&nbsp;828011, одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200.</p>\r\n', '<p>Загальний строк прийняття суб&rsquo;єктом надання адміністративної послуги рішення про видачу або відмову у видачі ліцензії не може перевищувати трьох місяців.</p>\r\n', '<p>Підставами для прийняття рішення про відмову у видачі ліцензії є:</p>\r\n\r\n<ul>\r\n	<li>недостовірність даних у документах, поданих суб&rsquo;єктом звернення, для отримання ліцензії;</li>\r\n	<li>невідповідність суб&rsquo;єкта звернення згідно з поданими документами ліцензійним умовам, встановленим для виду діяльності у сфері освіти, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n', '<p>Суб&rsquo;єкт звернення отримує ліцензію на право провадження діяльності у сфері освіти на бланку ліцензії єдиного зразка.</p>\r\n', '<ul>\r\n	<li>Суб&rsquo;єкт звернення надає до Центру надання адміністративних послуг платіжні документи, що засвідчують плату&nbsp; за видачу ліцензії&nbsp; (переоформлення ліцензії, видачу копії та дубліката ліцензії), та оплату послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування.</li>\r\n	<li>Суб&rsquo;єкт звернення особисто отримує ліцензію на надання освітніх послуг у сфері позашкільної освіти в Центрі надання адміністративних послуг Одеської міської ради.</li>\r\n</ul>\r\n', 'так', 0, NULL, 0, NULL, NULL, NULL, NULL),
(24, 'Видача дубліката ліцензії на надання освітніх послуг у сфері позашкільної освіти ', 1, 8, '<ol>\r\n	<li>Закон України&nbsp;&nbsp; від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 22.06.2000 №1841-ІІІ &nbsp;&laquo;Про позашкільну освіту&raquo;, ст.&nbsp;14 п.&nbsp;3.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері позашкільної освіти до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява про видачу дубліката ліцензії.</li>\r\n	<li>У разі пошкодження ліцензії &ndash; пошкоджений оригінал.</li>\r\n</ol>\r\n', 1, '<p>П.&nbsp;2 постанови Кабінету Міністрів України від 29.08.2003 №1380 &laquo;Про ліцензування освітніх послуг&raquo;.</p>\r\n', '<p>Плата за видачу дубліката ліцензії справляється в розмірі п&rsquo;яти неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p>Внесення суб&rsquo;єктом звернення плати за видачу дубліката ліцензії здійснюється на р/р&nbsp;31413511700001 код&nbsp;37607526 МФО&nbsp;828011, одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200.</p>\r\n', '<p>10 робочих днів після надходження заяви.</p>\r\n', '<p>Підставою для прийняття рішення про відмову у видачі дубліката ліцензії є недостовірність даних у документах, поданих суб&rsquo;єктом звернення, для отримання ліцензії.</p>\r\n', '<p>Суб&rsquo;єкт звернення отримує дублікат ліцензії на право провадження діяльності у сфері освіти на бланку ліцензії єдиного зразка.</p>\r\n', '<ul>\r\n	<li>Суб&rsquo;єкт звернення надає до Центру надання адміністративних послуг платіжні документи, що засвідчують плату&nbsp; за видачу дубліката ліцензії.</li>\r\n	<li>Суб&rsquo;єкт звернення особисто отримує дублікат ліцензії на надання освітніх послуг у сфері позашкільної освіти в Центрі надання адміністративних послуг Одеської міської ради.</li>\r\n</ul>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(25, 'Видача копії ліцензії на надання освітніх послуг у сфері позашкільної освіти', 1, 8, '<ol>\r\n	<li>Закон України&nbsp;&nbsp; від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 22.06.2000 №1841-ІІІ &nbsp;&laquo;Про позашкільну освіту&raquo;, ст.&nbsp;14 п.&nbsp;3.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері позашкільної освіти до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<p>Для відокремленого структурного підрозділу (філії тощо):</p>\r\n\r\n<ol>\r\n	<li>Заява про проведення ліцензування із зазначенням виду освітньої послуги і ліцензованого обсягу, реквізитів навчального закладу за затвердженою Міністерством освіти і науки, молоді та спорту України формою.</li>\r\n	<li>Копії установчих документів (статуту, положення, рішення засновника (власника) або уповноваженого ним органу про створення навчального закладу).</li>\r\n	<li>Копії рішень про утворення відокремлених підрозділів та положення про них (у разі ліцензування освітніх послуг у відокремленому підрозділі).</li>\r\n	<li>Концепція діяльності за заявленою освітньою послугою, яка ґрунтується на результатах моніторингу регіонального ринку освітніх послуг.</li>\r\n	<li>Відомості про кількості та якісні показники кадрового забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про кількісні показники матеріально-технічного забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про навчально-методичне забезпечення освітньої діяльності.</li>\r\n	<li>Копії документів, що засвідчують право власності (свідоцтво про право власності, договір купівлі-продажу), оперативного управління (рішення чи повідомлення власника майна про перебування майна в оперативному управлінні) чи користування (договір оренди) основними засобами для здійснення навчально-виховного процесу на строк, необхідний для завершення надання послуги.</li>\r\n	<li>Копії документів про відповідність приміщень навчального закладу та його матеріально-технічної бази санітарним нормам, вимогам правил пожежної безпеки.</li>\r\n	<li>Копії документів, що засвідчують рівень освіти, кваліфікації та громадянство керівника навчального закладу (диплома про вищу освіту, першої сторінки паспорта керівника навчального закладу).</li>\r\n</ol>\r\n', 1, '<p>П.&nbsp;2 постанови Кабінету Міністрів України від 29.08.2003 №1380 &laquo;Про ліцензування освітніх послуг&raquo;.</p>\r\n', '<p>Плата за видачу копії ліцензії справляється в розмірі п&rsquo;яти неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p>Внесення суб&rsquo;єктом звернення плати за видачу копії ліцензії здійснюється на р/р&nbsp;31413511700001 код&nbsp;37607526 МФО&nbsp;828011, одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200.</p>\r\n', '<p>Загальний строк прийняття суб&rsquo;єктом надання адміністративної послуги рішення про видачу або відмову у видачі ліцензії не може перевищувати трьох місяців.</p>\r\n', '<p>Підставами для прийняття рішення про відмову у видачі копії ліцензії є:</p>\r\n\r\n<ul>\r\n	<li>недостовірність даних у документах, поданих суб&rsquo;єктом звернення, для отримання ліцензії;</li>\r\n	<li>невідповідність суб&rsquo;єкта звернення згідно з поданими документами ліцензійним умовам, встановленим для виду діяльності у сфері освіти, зазначеного в заяві про видачу копії ліцензії.</li>\r\n</ul>\r\n', '<p>Суб&rsquo;єкт звернення отримує копію ліцензії на право провадження діяльності у сфері освіти на бланку ліцензії єдиного зразка.</p>\r\n', '<ul>\r\n	<li>Суб&rsquo;єкт звернення надає до Центру надання адміністративних послуг платіжні документи, що засвідчують плату за видачу копії ліцензії&nbsp; та оплату послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування.</li>\r\n	<li>Суб&rsquo;єкт звернення особисто отримує копію ліцензії на надання освітніх послуг у сфері позашкільної освіти в Центрі надання адміністративних послуг Одеської міської ради.</li>\r\n</ul>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(26, 'Переоформлення ліцензії на надання освітніх послуг у сфері позашкільної освіти', 1, 8, '<ol>\r\n	<li>Закон України&nbsp;&nbsp; від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 22.06.2000 №1841-ІІІ &nbsp;&laquo;Про позашкільну освіту&raquo;, ст.&nbsp;14 п.&nbsp;3.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері позашкільної освіти до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява про переоформлення ліцензії.</li>\r\n	<li>Копії установчих документів (статуту, положення, рішення засновника (власника) або уповноваженого ним органу про створення навчального закладу).</li>\r\n	<li>Відомості про кількісні показники кадрового забезпечення.</li>\r\n	<li>Відомості кількісні показники матеріально-технічного забезпечення освітньої діяльності.</li>\r\n	<li>Копії документів про відповідність приміщень навчального закладу та його матеріально-технічної бази санітарним нормам, вимогам правил пожежної безпеки.</li>\r\n</ol>\r\n', 1, '<p>П.&nbsp;2 постанови Кабінету Міністрів України від 29.08.2003 №1380 &laquo;Про ліцензування освітніх послуг&raquo;.</p>\r\n', '<p>Плата за переоформлення ліцензії справляється в розмірі п&rsquo;яти неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p>Внесення суб&rsquo;єктом звернення плати за переоформлення ліцензії здійснюється на р/р&nbsp;31413511700001 код&nbsp;37607526 МФО&nbsp;828011, одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200.</p>\r\n', '<p>Розгляд на черговому засіданні Регіональної експертної ради з питань ліцензування та атестації навчальних закладів (не рідше одного разу на 2 місяці).</p>\r\n', '<p>Підставою для прийняття рішення про відмову у переоформленні ліцензії є недостовірність даних у документах, поданих суб&rsquo;єктом звернення, для переоформлення ліцензії.</p>\r\n', '<p>Суб&rsquo;єкт звернення отримує ліцензію на право провадження діяльності у сфері освіти на бланку ліцензії єдиного зразка.</p>\r\n', '<ul>\r\n	<li>Суб&rsquo;єкт звернення надає до Центру надання адміністративних послуг платіжні документи, що засвідчують плату&nbsp; за переоформлення ліцензії&nbsp; та оплату послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування (у разі проведення експертизи).</li>\r\n	<li>Суб&rsquo;єкт звернення особисто отримує переоформлену ліцензію на надання освітніх послуг у сфері позашкільної освіти в Центрі надання адміністративних послуг Одеської міської ради.</li>\r\n</ul>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(27, 'Анулювання ліцензії на надання освітніх послуг у сфері позашкільної освіти', 1, 8, '<ol>\r\n	<li>Закон України&nbsp;&nbsp; від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 22.06.2000 №1841-ІІІ &nbsp;&laquo;Про позашкільну освіту&raquo;, ст.&nbsp;14 п.&nbsp;3.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері позашкільної освіти до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява про анулювання ліцензії.</li>\r\n	<li>Ліцензія.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Розгляд на черговому засіданні Регіональної експертної ради з питань ліцензування та атестації навчальних закладів (не рідше одного разу на 2 місяці).</p>\r\n', '<p>---</p>\r\n', '<p>Наказ органу ліцензування відповідно до рішення&nbsp; Регіональної експертної ради з питань ліцензування та атестації навчальних закладів.</p>\r\n', '<p>На офіційному веб-сайті органу ліцензування.</p>\r\n', 'так', 0, NULL, 0, NULL, NULL, NULL, NULL),
(28, 'Ліцензія на право провадження господарської діяльності з централізованого водопостачання', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n\r\n<p>&nbsp;</p>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<p>1. Заява, заповнена відповідно до ст.10 Закону України &ldquo;Про ліцензування певних видів господарської діяльності&rdquo;.</p>\r\n\r\n<p>2. Відомості за підписом заявника &mdash; суб&#39;єкта господарювання (за формою,встановленою ліцензійними умовами) про:</p>\r\n\r\n<ul>\r\n	<li>Наявність матеріально-технічної бази, для провадження відповідного виду господарської діяльності;</li>\r\n	<li>Відповідність чисельності персоналу та його кваліфікаційного рівня нормативним вимогам щодо провадження відповідного виду господарської діяльності.</li>\r\n	<li>Наявність акредитованої лабораторії, яка здійснює виробничий контроль, або договору на виконання таких робіт з акредитованими лабораторіями інших організацій;</li>\r\n</ul>\r\n\r\n<p>2.4.Потужність, річні обсяги видобування, виробництва та транспортування.</p>\r\n\r\n<p>3. Технологічний регламент експлуатації системи водовідведення за підписом заявника &mdash; суб&#39;єкта господарювання.</p>\r\n\r\n<p>4. Перелік приладів обліку та місць їх встановлення.</p>\r\n\r\n<p>5. Технічна характеристика мереж, споруд та інших об`єктів, їх схеми за підписом керівника суб&#39;єкта господарювання.</p>\r\n\r\n<p>6. Баланс підприємства на останню звітну дату за підписом керівника суб&#39;єкта господарювання, скріпленим печаткою.</p>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p>Одна мінімальна заробітна плата виходячи з її розміру на дату прийняття органам ліцензування рішення про видачу ліцензії.</p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж 10 робочих днів з дати надходження заяви про видачу ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n	<li>Залишення заяви без розгляду:</li>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Ліцензія на право провадження господарської діяльності з централізованого водопостачання, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`) VALUES
(29, 'Дублікат ліцензії на право провадження господарської діяльності з централізованого водопостачання', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.18 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Непридатна для користування ліцензія та відповідні документи для видачі дубліката</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p>Плата в розмірі п`яти неоподатковуваних мінімумів доходів громадян на дату подання заяви про переоформлення ліцензії.</p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу дублікату ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж трьох робочих днів з дати надходження заяви про видачу дублікату ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу дубліката ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання дублікату ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення</li>\r\n</ul>\r\n', '<p>Дублікат ліцензії на право провадження господарської діяльності з централізованого водопостачання, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(30, 'Копія ліцензії на право провадження господарської діяльності з централізованого водопостачання', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.18 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Копії надаються під час надання заяви на отримання ліцензії та відповідно до статей 10, 11 та 14 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n</ol>\r\n', 1, '<p>Закон України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n', '<p>Плата в одному неоподатковуваному &nbsp;мінімуму доходів громадян.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про&nbsp; видачу&nbsp; ліцензії та надання копій або про відмову у її видачі у строк не пізніше ніж десять робочих днів з дати надходження заяви про видачу&nbsp; ліцензії та&nbsp; документів,&nbsp; що додаються до заяви, якщо спеціальним законом, що регулює відносини у певних сферах господарської діяльності, не&nbsp; передбачений інший строк видачі ліцензії на окремі види діяльності. Повідомлення про прийняття&nbsp; рішення&nbsp; про видачу ліцензії або про відмову у видачі ліцензії надсилається (видається) заявникові в письмовій&nbsp; формі&nbsp; протягом&nbsp; трьох робочих днів з дати прийняття відповідного рішення.&nbsp; У рішенні про відмову у видачі&nbsp; ліцензії зазначаються підстави такої відмови.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа, що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Підстави для відмови:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання дублікату ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Копія ліцензії на право провадження господарської діяльності з централізованого водопостачання, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(31, 'Переоформлення ліцензії на право провадження господарської діяльності з централізованого водопостачання', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.16 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Ліцензія, що підлягає переоформленню та відповідні документи або їх нотаріально засвідчені копії, які підтверджують зазначені зміни.</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p>Плата в розмірі п`яти неоподатковуваних мінімумів доходів громадян на дату подання заяви про переоформлення ліцензії.</p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж трьох робочих днів з дати надходження заяви про переоформлення ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Не переоформлена в установлений строк ліцензія є недійсною.</p>\r\n', '<p>Ліцензія на право провадження господарської діяльності з централізованого водопостачання, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(32, 'Анулювання ліцензії на право провадження господарської діяльності з централізованого водопостачання', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<p>Заява, ліцензіата про анулювання заповнена відповідно до ст. 21 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n', 0, '', '', '', '<p>Орган ліцензування приймає рішення про анулювання ліцензії протягом 10 робочих днів з дати встановлення підстав для анулювання ліцензії.</p>\r\n\r\n<p>Повідомлення про прийняття рішення надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n', '<p>Відмова у анулюванні ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для анулювання ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про анулювання ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Анулювання ліцензії на право провадження господарської діяльності з централізованого водопостачання, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(33, 'Ліцензія на право провадження господарської діяльності з централізованого водовідведення', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг</p>\r\n', '<p>1. Заява, заповнена відповідно до ст.10 Закону України &ldquo;Про ліцензування певних видів господарської діяльності&rdquo;.</p>\r\n\r\n<p>2. Відомості за підписом заявника &mdash; суб&#39;єкта господарювання (за формою,встановленою ліцензійними умовами) про:</p>\r\n\r\n<ul>\r\n	<li>2.1. Наявність матеріально-технічної бази, для провадження відповідного виду господарської діяльності;</li>\r\n	<li>2.2. Відповідність чисельності персоналу та його кваліфікаційного рівня нормативним вимогам щодо провадження відповідного виду господарської діяльності.</li>\r\n	<li>2.3. Наявність акредитованої лабораторії, яка здійснює виробничий контроль, або договору на виконання таких робіт з акредитованими лабораторіями інших організацій;</li>\r\n	<li>2.4.Потужність, річні обсяги видобування, виробництва та транспортування.</li>\r\n</ul>\r\n\r\n<p>3.Технологічний регламент експлуатації системи водовідведення за підписом заявника &mdash; суб&#39;єкта господарювання;</p>\r\n\r\n<p>4. Перелік приладів обліку та місць їх встановлення.</p>\r\n\r\n<p>5.Технічна характеристика мереж, споруд та інших об`єктів, їх схеми за підписом керівника суб&#39;єкта господарювання.</p>\r\n\r\n<p>6.Баланс підприємства на останню звітну дату за підписом керівника суб&#39;єкта господарювання, скріпленим печаткою.</p>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p>Одна мінімальна заробітна плата виходячи з її розміру на дату прийняття органам ліцензування рішення про видачу ліцензії.</p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж 10 робочих днів з дати надходження заяви про видачу ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Ліцензія на право провадження господарської діяльності з централізованого водовідведення, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(34, 'Дублікат ліцензії на право провадження господарської діяльності з централізованого водовідведення', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.18 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>2. Непридатна для користування ліцензія та відповідні документи для видачі дубліката.&nbsp;</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<ul>\r\n	<li>Плата в розмірі п`яти неоподатковуваних мінімумів доходів громадян на дату подання заяви про переоформлення ліцензії.</li>\r\n	<li>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</li>\r\n</ul>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу дублікату ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж трьох робочих днів з дати надходження заяви про видачу дублікату ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу дубліката ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання дублікату ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Дублікат ліцензії на право провадження господарської діяльності з централізованого водовідведення, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(35, 'Копія ліцензії на право провадження господарської діяльності з централізованого водовідведення', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.18 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Копії надаються під час надання заяви на отримання ліцензії та відповідно до статей 10, 11 та 14 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n</ol>\r\n', 1, '<p>Закон України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n', '<p>Плата в одному неоподатковуваному &nbsp;мінімуму доходів громадян.</p>\r\n\r\n<p>&nbsp;</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій</p>\r\n', '<pre>\r\nОрган ліцензування приймає рішення про&nbsp; видачу&nbsp; ліцензії та надання копій або про відмову у її видачі у строк не пізніше ніж десять робочих днів з дати надходження заяви про видачу&nbsp; ліцензії та&nbsp; документів,&nbsp; що додаються до заяви, якщо спеціальним законом, що регулює відносини у певних сферах господарської діяльності, не&nbsp; передбачений інший строк видачі ліцензії на окремі види діяльності. <a name="o202"></a>Повідомлення про прийняття&nbsp; рішення&nbsp; про видачу ліцензії або про відмову у видачі ліцензії надсилається (видається) заявникові в письмовій&nbsp; формі&nbsp; протягом&nbsp; трьох робочих днів з дати прийняття відповідного рішення.&nbsp; У рішенні про відмову у видачі&nbsp; ліцензії зазначаються підстави такої відмови. </pre>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа, що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії та її копій (ії):</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання дублікату ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Копія ліцензії на право провадження господарської діяльності з централізованого водопостачання, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(36, 'Переоформлення ліцензії на право провадження господарської діяльності з централізованого водовідведення', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.16 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Ліцензія, що підлягає переоформленню та відповідні документи або їх нотаріально засвідчені копії, які підтверджують зазначені зміни.</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<ul>\r\n	<li>Плата в розмірі п`яти неоподатковуваних мінімумів доходів громадян на дату подання заяви про переоформлення ліцензії.</li>\r\n	<li>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</li>\r\n</ul>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж трьох робочих днів з дати надходження заяви про переоформлення ліцензії та документів, що додаються до заяви</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Не переоформлена в установлений строк ліцензія є недійсною.</p>\r\n', '<p>Ліцензія на право провадження господарської діяльності з централізованого водовідведення, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`) VALUES
(37, 'Анулювання ліцензії на право провадження господарської діяльності з централізованого водовідведення', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<p>Заява, ліцензіата про анулювання заповнена відповідно до ст. 21 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n', 0, '', '', '', '<p>Орган ліцензування приймає рішення про анулювання ліцензії протягом10 робочих днів з дати встановлення підстав для анулювання ліцензії.</p>\r\n\r\n<p>Повідомлення про прийняття рішення надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n', '<p>Відмова у анулюванні ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для анулювання ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про анулювання ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Анулювання ліцензії на право провадження господарської діяльності з централізованого водовідведення, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(38, 'Ліцензія на право провадження господарської діяльності з централізованого водопостачання та водовідведення', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<p>1. Заява, заповнена відповідно до ст.10 Закону України &ldquo;Про ліцензування певних видів господарської діяльності&rdquo;.</p>\r\n\r\n<p>2. Відомості за підписом заявника &mdash; суб&#39;єкта господарювання (за формою,встановленою ліцензійними умовами) про:</p>\r\n\r\n<ul>\r\n	<li>Наявність матеріально-технічної бази, для провадження відповідного виду господарської діяльності;</li>\r\n	<li>Відповідність чисельності персоналу та його кваліфікаційного рівня нормативним вимогам щодо провадження відповідного виду господарської діяльності.</li>\r\n	<li>Наявність акредитованої лабораторії, яка здійснює виробничий контроль, або договору на виконання таких робіт з акредитованими лабораторіями інших організацій;</li>\r\n	<li>Потужність, річні обсяги видобування, виробництва та транспортування.</li>\r\n</ul>\r\n\r\n<p>3.Технологічний регламент експлуатації системи водовідведення за підписом заявника &mdash; суб&#39;єкта господарювання;</p>\r\n\r\n<p>4. Перелік приладів обліку та місць їх встановлення.</p>\r\n\r\n<p>5.Технічна характеристика мереж, споруд та інших об`єктів, їх схеми за підписом керівника суб&#39;єкта господарювання.</p>\r\n\r\n<p>6.Баланс підприємства на останню звітну дату за підписом керівника суб&#39;єкта господарювання, скріпленим печаткою.</p>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;/</p>\r\n', '<p><strong>Одна мінімальна заробітна плата виходячи з її розміру на дату прийняття органам ліцензування рішення про видачу ліцензії.</strong></p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж 10 робочих днів з дати надходження заяви про видачу ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної/</p>\r\n', '<p>Відмова у видачі ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Ліцензія на право провадження господарської діяльності з централізованого водопостачання та водовідведення, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(39, 'Дублікат ліцензії на право провадження господарської діяльності з централізованого водопостачання та водовідведення', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.18 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Непридатна для користування ліцензія та відповідні документи для видачі дубліката.</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p><strong>Плата в розмірі п`яти неоподатковуваних мінімумів доходів громадян на дату подання заяви про переоформлення ліцензії.</strong></p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу дублікату ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж трьох робочих днів з дати надходження заяви про видачу дублікату ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу дубліката ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання дублікату ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення</li>\r\n</ul>\r\n', '<p>Дублікат ліцензії на право провадження господарської діяльності з централізованого водопостачання та водовідведення, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(40, 'Копія ліцензії на право провадження господарської діяльності з централізованого водопостачання та водовідведення', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.18 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Копії надаються під час надання заяви на отримання ліцензії та відповідно до статей 10, 11 та 14 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n</ol>\r\n', 1, '<p>Закон України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n', '<p>Плата в одному неоподатковуваному &nbsp;мінімуму доходів громадян.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<pre>\r\nОрган ліцензування приймає рішення про&nbsp; видачу&nbsp; ліцензії та надання копій або про відмову у її видачі у строк не пізніше ніж десять робочих днів з дати надходження заяви про видачу&nbsp; ліцензії та&nbsp; документів,&nbsp; що додаються до заяви, якщо спеціальним законом, що регулює відносини у певних сферах господарської діяльності, не&nbsp; передбачений інший строк видачі ліцензії на окремі види діяльності. <a name="o202"></a>Повідомлення про прийняття&nbsp; рішення&nbsp; про видачу ліцензії або про відмову у видачі ліцензії надсилається (видається) заявникові в письмовій&nbsp; формі&nbsp; протягом&nbsp; трьох робочих днів з дати прийняття відповідного рішення.&nbsp; У рішенні про відмову у видачі&nbsp; ліцензії зазначаються підстави такої відмови. </pre>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа, що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії та її копій (ії):</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання дублікату ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Копія ліцензії на право провадження господарської діяльності з централізованого водопостачання, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(41, 'Переоформлення ліцензії на право провадження господарської діяльності з централізованого водопостачання та водовідведення', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.16 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Ліцензія, що підлягає переоформленню та відповідні документи або їх нотаріально засвідчені копії, які підтверджують зазначені зміни.</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p><strong>Плата в розмірі п`яти неоподатковуваних мінімумів доходів громадян на дату подання заяви про переоформлення ліцензії.</strong></p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>рган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж трьох робочих днів з дати надходження заяви про переоформлення ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Не переоформлена в установлений строк ліцензія є недійсною.</p>\r\n', '<p>Ліцензія на право провадження господарської діяльності з централізованого водопостачання та водовідведення, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(42, 'Анулювання ліцензії на право провадження господарської діяльності з централізованого водопостачання та водовідведення', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<p>Заява, ліцензіата про анулювання заповнена відповідно до ст. 21 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n', 0, '', '', '', '<p><strong>Орган ліцензування приймає рішення про анулювання ліцензії протягом 10 робочих днів з дати встановлення підстав для анулювання ліцензії.</strong></p>\r\n\r\n<p>Повідомлення про прийняття рішення надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення</p>\r\n', '<p>Відмова у анулюванні ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для анулювання ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про анулювання ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Анулювання ліцензії&nbsp;на право провадження господарської діяльності з централізованого водопостачання та водовідведення, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(43, 'Ліцензія  на право провадження господарської діяльності з постачання теплової енергії', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.10 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Перелік приладів обліку із&nbsp;зазначенням&nbsp; місць їх&nbsp; встановлення.</li>\r\n	<li>Відомості про обсяги постачання теплової енергії за підписом&nbsp; керівника суб&rsquo;єкта господарювання.</li>\r\n	<li>Баланс підприємства на останню звітну дату за підписом керівника&nbsp;суб&rsquo;єкта господарювання, скріпленим печаткою.</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p><strong>Одна мінімальна заробітна плата виходячи з її розміру на дату прийняття органам ліцензування рішення про видачу ліцензії.</strong></p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p><strong>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж 10 робочих днів з дати надходження заяви про видачу ліцензії та документів, що додаються до заяви.</strong></p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Ліцензія на право провадження господарської діяльності з постачання теплової енергії, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(44, 'Дублікат ліцензії  на право провадження господарської діяльності з постачання теплової енергії', 1, 3, '<ol>\r\n	<li>Закон України &ldquo;Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.18 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Непридатна для користування ліцензія та відповідні документи для видачі дубліката.</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p><strong>Плата в розмірі п`яти неоподатковуваних мінімумів доходів громадян на дату подання заяви про переоформлення ліцензії.</strong></p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу дублікату ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж трьох робочих днів з дати надходження заяви про видачу дублікату ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу дубліката ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання дублікату ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Дублікат ліцензії на право провадження господарської діяльності з постачання теплової енергії, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`) VALUES
(45, 'Копія ліцензії  на право провадження господарської діяльності з постачання теплової енергії', 1, 3, '<ol>\r\n	<li>Закон України &ldquo;Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.18 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Копії надаються під час надання заяви на отримання ліцензії та відповідно до статей 10, 11 та 14 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n</ol>\r\n', 1, '<p>Закон України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n', '<p>Плата в одному неоподатковуваному &nbsp;мінімуму доходів громадян.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу копії ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про&nbsp; видачу&nbsp; ліцензії та надання копій або про відмову у її видачі у строк не пізніше ніж десять робочих днів з дати надходження заяви про видачу&nbsp; ліцензії та&nbsp; документів,&nbsp; що додаються до заяви, якщо спеціальним законом, що регулює відносини у певних сферах господарської діяльності, не&nbsp; передбачений інший строк видачі ліцензії на окремі види діяльності. Повідомлення про прийняття&nbsp; рішення&nbsp; про видачу ліцензії або про відмову у видачі ліцензії надсилається (видається) заявникові в письмовій&nbsp; формі&nbsp; протягом&nbsp; трьох робочих днів з дати прийняття відповідного рішення.&nbsp; У рішенні про відмову у видачі&nbsp; ліцензії зазначаються підстави такої відмови.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа, що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії та її копії (ій):</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання дублікату ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Копія(ії) ліцензії на право провадження господарської діяльності з виробництва та постачання теплової енергії, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(46, 'Переоформлення ліцензії  на право провадження господарської діяльності з постачання теплової енергії', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.16 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Ліцензія, що підлягає переоформленню та відповідні документи або їх нотаріально засвідчені копії, які підтверджують зазначені зміни.</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p><strong>Плата в розмірі п`яти неоподатковуваних мінімумів доходів громадян на дату подання заяви про переоформлення ліцензії.</strong></p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж трьох робочих днів з дати надходження заяви про переоформлення ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Не переоформлена в установлений строк ліцензія є недійсною.</p>\r\n', '<p>Ліцензія на право провадження господарської діяльності з постачання теплової енергії, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(47, 'Анулювання ліцензії  на право провадження господарської діяльності з постачання теплової енергії', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<p>Заява, ліцензіата про анулювання заповнена відповідно до ст. 21 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n', 0, '', '', '', '<p><strong>Орган ліцензування приймає рішення про анулювання ліцензії протягом 10 робочих днів з дати встановлення підстав для анулювання ліцензії.</strong></p>\r\n\r\n<p>Повідомлення про прийняття рішення надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення</p>\r\n', '<p>Відмова у анулюванні ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для анулювання ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про анулювання ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Анулювання ліцензії на право провадження господарської діяльності з постачання теплової енергії, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(48, 'Ліцензія  на право провадження господарської діяльності з транспортування  теплової енергії магістральними та місцевими (розподільчими) тепловими мережам', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг</p>\r\n', '<p>1. Заява, заповнена відповідно до ст.10 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n\r\n<p>2. Відомості за підписом заявника -&nbsp; суб&rsquo;єкта господарювання (за формою, встановленою ліцензійними умовами) про:</p>\r\n\r\n<ul>\r\n	<li>Наявність матеріально-технічної бази, необхідної для провадження</li>\r\n	<li>відповідного виду господарської діяльності;</li>\r\n	<li>Технічний стан трубопроводів та споруд на них (на підставі експлуатаційної документації на такі об&rsquo;єкти);</li>\r\n	<li>2.3 Наявність проектної і виконавчої документації на трубопроводи та споруди на них, які&nbsp;&nbsp;&nbsp; використовуються для провадження відповідного виду господарської</li>\r\n	<li>діяльності;&nbsp;Перелік трубопроводів, що перебувають у користуванні заявника</li>\r\n	<li>суб&rsquo;єкта господарювання, їх технічна характеристика та річні обсяги</li>\r\n	<li>транспортування теплової енергії;</li>\r\n	<li>Перелік приладів обліку із зазначенням місць їх встановлення;&nbsp;Схема трубопроводів, нанесена на географічну карту місцевості;</li>\r\n	<li>Копія затвердженої місцевим органом виконавчої влади схеми</li>\r\n	<li>теплопостачання;</li>\r\n	<li>Баланс підприємства на останню звітну дату за підписом керівника</li>\r\n	<li>суб&rsquo;єкта господарювання, скріпленим печаткою.</li>\r\n	<li>Засвідчені в установленому порядку копії актів і схем розмежування ділянок обслуговування між суб&rsquo;єктами господарювання, трубопроводами яких з&rsquo;єднані між собою;</li>\r\n	<li>Засвідчені в установленому порядку копії документів, що підтверджують освітній і кваліфікаційний рівень працівників, необхідний для провадження відповідного виду господарської діяльності.</li>\r\n</ul>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p><strong>Одна мінімальна заробітна плата виходячи з її розміру на дату прийняття органам ліцензування рішення про видачу ліцензії.</strong></p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p><strong>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж 10 робочих днів з дати надходження заяви про видачу ліцензії та документів, що додаються до заяви.</strong></p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Ліцензія на право провадження господарської діяльності з транспортування&nbsp; теплової енергії магістральними та місцевими (розподільчими) тепловими мережами, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(49, 'Дублікат ліцензії  на право провадження господарської діяльності з транспортування  теплової енергії магістральними та місцевими (розподільчими) тепловими мережами', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.18 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Непридатна для користування ліцензія та відповідні документи для видачі дубліката.&nbsp;</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p><strong>Плата в розмірі п`яти неоподатковуваних мінімумів доходів громадян на дату подання заяви про переоформлення ліцензії.</strong></p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n\r\n<p>&nbsp;</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу дублікату ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж трьох робочих днів з дати надходження заяви про видачу дублікату ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу дубліката ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання дублікату ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Дублікат ліцензії на право провадження господарської діяльності з виробництва та постачання теплової енергії, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(50, 'Копія ліцензії  на право провадження господарської діяльності з транспортування  теплової енергії магістральними та місцевими (розподільчими) тепловими мережами', 1, 3, '<ol>\r\n	<li>Закон України &ldquo;Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.18 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Копії надаються під час надання заяви на отримання ліцензії та відповідно до статей 10, 11 та 14 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n</ol>\r\n', 1, '<p>Закон України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n', '<p>Плата в одному неоподатковуваному &nbsp;мінімуму доходів громадян.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу копії ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про&nbsp; видачу&nbsp; ліцензії та надання копій або про відмову у її видачі у строк не пізніше ніж десять робочих днів з дати надходження заяви про видачу&nbsp; ліцензії та&nbsp; документів,&nbsp; що додаються до заяви, якщо спеціальним законом, що регулює відносини у певних сферах господарської діяльності, не&nbsp; передбачений інший строк видачі ліцензії на окремі види діяльності. Повідомлення про прийняття&nbsp; рішення&nbsp; про видачу ліцензії або про відмову у видачі ліцензії надсилається (видається) заявникові в письмовій&nbsp; формі&nbsp; протягом&nbsp; трьох робочих днів з дати прийняття відповідного рішення.&nbsp; У рішенні про відмову у видачі&nbsp; ліцензії зазначаються підстави такої відмови.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа, що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії та її копії (ій):</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання дублікату ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Копія(ії) ліцензії на право провадження господарської діяльності з виробництва та постачання теплової енергії, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(51, 'Переоформлення ліцензії  на право провадження господарської діяльності з транспортування  теплової енергії магістральними та місцевими (розподільчими) тепловими мережами', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.16 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Ліцензія, що підлягає переоформленню та відповідні документи або їх нотаріально засвідчені копії, які підтверджують зазначені зміни.</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу.</p>\r\n', '<p><strong>Плата в розмірі п`яти неоподатковуваних мінімумів доходів громадян на дату подання заяви про переоформлення ліцензії.</strong></p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж трьох робочих днів з дати надходження заяви про переоформлення ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Не переоформлена в установлений строк ліцензія є недійсною.</p>\r\n', '<p>Ліцензія на право провадження господарської діяльності з транспортування теплової енергії магістральними та місцевими (розподільчими) тепловими мережами, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(52, 'Анулювання ліцензії  на право провадження господарської діяльності з транспортування  теплової енергії магістральними та місцевими (розподільчими) тепловими мережами', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<p>Заява, ліцензіата про анулювання заповнена відповідно до ст. 21 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n', 0, '', '', '', '<p><strong>Орган ліцензування приймає рішення про анулювання ліцензії протягом 10 робочих днів з дати встановлення підстав для анулювання ліцензії.</strong></p>\r\n\r\n<p>Повідомлення про прийняття рішення надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення</p>\r\n', '<p>Відмова у анулюванні ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для анулювання ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про анулювання ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Анулювання ліцензії на право провадження господарської діяльності з транспортування теплової енергії магістральними та місцевими (розподільчими) тепловими мережами, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`) VALUES
(53, 'Ліцензія  на право провадження господарської діяльності з виробництва теплової енергії (крім діяльності  з виробництва теплової енергії на теплоелектроцентралях, теплоелектростанціях, атомних електростанціях і когенераційних установках та установках з вик', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<p>1. Заява, заповнена відповідно до ст.10 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n\r\n<p>2. Засвідчена в установленому&nbsp; порядку копія документа, що підтверджує право власності суб&rsquo;єкта господарювання або оренди ним виробничих об&rsquo;єктів, де провадитиметься відповідний вид господарської діяльності.</p>\r\n\r\n<p>3. Відомості за підписом заявника -&nbsp; суб&rsquo;єкта господарювання (за формою, встановленою ліцензійними умовами) про:</p>\r\n\r\n<ul>\r\n	<li>Наявність власних або орендованих виробничих об&rsquo;єктів, де провадитиметься підповідний вид господарської діяльності;</li>\r\n	<li>Наявність та стан технологічного обладнання і технічної бази для його обслуговування;</li>\r\n	<li>Освітній і кваліфікаційний рівень працівників, необхідний для провадження відповідного&nbsp;виду господарської діяльності;</li>\r\n	<li>Баланс підприємства на&nbsp;&nbsp;останню звітну дату з підписом керівника суб&rsquo;єкта господарювання,&nbsp;скріпленим печаткою.</li>\r\n</ul>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p><strong>Одна мінімальна заробітна плата виходячи з її розміру на дату прийняття органам ліцензування рішення про видачу ліцензії.</strong></p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p><strong>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж 10 робочих днів з дати надходження заяви про видачу ліцензії та документів, що додаються до заяви.</strong></p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Ліцензія на право провадження господарської діяльності з виробництва теплової енергії (крім діяльності&nbsp; з виробництва теплової енергії на теплоелектроцентралях, теплоелектростанціях, атомних електростанціях і когенераційних установках та установках з використанням нетрадиційних або поновлювальних джерел енергії, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(54, 'Дублікат ліцензії  на право провадження господарської діяльності з виробництва теплової енергії (крім діяльності  з виробництва теплової енергії на теплоелектроцентралях, теплоелектростанціях, атомних електростанціях і когенераційних установках та установ', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.18 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Непридатна для користування ліцензія та відповідні документи для видачі дубліката.</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p><strong>Плата в розмірі п`яти неоподатковуваних мінімумів доходів громадян на дату подання заяви про переоформлення ліцензії.</strong></p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу дублікату ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж трьох робочих днів з дати надходження заяви про видачу дублікату ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу дубліката ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання дублікату ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Дублікат ліцензії на право провадження господарської діяльності з виробництва теплової енергії (крім діяльності&nbsp; з виробництва теплової енергії на теплоелектроцентралях, теплоелектростанціях, атомних електростанціях і когенераційних установках та установках з використанням нетрадиційних або поновлювальних джерел енергії, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(56, 'Копія ліцензії  на право провадження господарської діяльності з виробництва теплової енергії (крім діяльності  з виробництва теплової енергії на теплоелектроцентралях, теплоелектростанціях, атомних електростанціях і когенераційних установках та установ', 1, 3, '<ol>\r\n	<li>Закон України &ldquo;Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.18 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Копії надаються під час надання заяви на отримання ліцензії та відповідно до статей 10, 11 та 14 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n</ol>\r\n', 1, '<p>Закон України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n', '<p>Плата в одному неоподатковуваному &nbsp;мінімуму доходів громадян.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу копії ліцензій.</p>\r\n', '<pre>\r\nОрган ліцензування приймає рішення про&nbsp; видачу&nbsp; ліцензії та надання копій або про відмову у її видачі у строк не пізніше ніж десять робочих днів з дати надходження заяви про видачу&nbsp; ліцензії та&nbsp; документів,&nbsp; що додаються до заяви, якщо спеціальним законом, що регулює відносини у певних сферах господарської діяльності, не&nbsp; передбачений інший строк видачі ліцензії на окремі види діяльності. <a name="o202"></a>Повідомлення про прийняття&nbsp; рішення&nbsp; про видачу ліцензії або про відмову у видачі ліцензії надсилається (видається) заявникові в письмовій&nbsp; формі&nbsp; протягом&nbsp; трьох робочих днів з дати прийняття відповідного рішення.&nbsp; У рішенні про відмову у видачі&nbsp; ліцензії зазначаються підстави такої відмови. </pre>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа, що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії та її копії (ій):</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання дублікату ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Копія(ії) ліцензії на право провадження господарської діяльності з виробництва та постачання теплової енергії, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(58, 'Переоформлення ліцензії на право провадження господарської діяльності з виробництва теплової енергії (крім діяльності  з виробництва теплової енергії на теплоелектроцентралях, теплоелектростанціях, атомних електростанціях і когенераційних установках ', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.16 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Ліцензія, що підлягає переоформленню та відповідні документи або їх нотаріально засвідчені копії, які підтверджують зазначені зміни.</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p>Плата в розмірі п`яти неоподатковуваних мінімумів доходів громадян на дату подання заяви про переоформлення ліцензії.</p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж трьох робочих днів з дати надходження заяви про переоформлення ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Не переоформлена в установлений строк ліцензія є недійсною.</p>\r\n', '<p>Ліцензія на право провадження господарської діяльності з виробництва теплової енергії (крім діяльності з виробництва теплової енергії на теплоелектроцентралях, теплоелектростанціях, атомних електростанціях і когенераційних установках та установках з використанням нетрадиційних або поновлювальних джерел енергії, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(59, 'Анулювання ліцензії  на право провадження господарської діяльності з виробництва теплової енергії (крім діяльності  з виробництва теплової енергії на теплоелектроцентралях, теплоелектростанціях, атомних електростанціях і когенераційних установках', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<p>Заява, ліцензіата про анулювання заповнена відповідно до ст. 21 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n', 0, '', '', '', '<p><strong>Орган ліцензування приймає рішення про анулювання ліцензії протягом 10 робочих днів з дати встановлення підстав для анулювання ліцензії.</strong></p>\r\n\r\n<p>Повідомлення про прийняття рішення надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n', '<p>Відмова у анулюванні ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для анулювання ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про анулювання ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Анулювання ліцензії на право провадження господарської діяльності з виробництва теплової енергії (крім діяльності з виробництва теплової енергії на теплоелектроцентралях, теплоелектростанціях, атомних електростанціях і когенераційних установках та установках з використанням нетрадиційних або поновлювальних джерел енергії, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(60, 'Ліцензія  на право провадження господарської діяльності з виробництва теплової енергії, транспортування її магістральними та місцевими (розподільчими) тепловими мережами та постачання теплової енергії', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>аява, заповнена відповідно до ст.10 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Засвідчена в установленому&nbsp; порядку копія документа, що підтверджує право власності суб&rsquo;єкта господарювання або оренди ним виробничих об&rsquo;єктів, де провадитиметься відповідний вид господарської діяльності.</li>\r\n	<li>Відомості за підписом заявника -&nbsp; суб&rsquo;єкта господарювання (за формою, встановленою ліцензійними умовами) про:</li>\r\n</ol>\r\n\r\n<ul>\r\n	<li>Наявність власних або орендованих виробничих об&rsquo;єктів, де провадитиметься відповідний вид господарської діяльності;</li>\r\n	<li>Наявність та стан технологічного обладнання і технічної бази для його обслуговування;</li>\r\n	<li>Освітній і кваліфікаційний рівень працівників, необхідний для провадження відповідного Виду господарської діяльності;</li>\r\n	<li>Наявність матеріально -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; технічної бази, необхідної для провадження відповідного виду&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; господарської діяльності;</li>\r\n	<li>Технічний стан трубопроводів та споруд на них (на підставі експлуатаційної документації на такі об&rsquo;єкти);</li>\r\n	<li>Наявність проектної і виконавчої документації на трубопроводи та споруди на них, які&nbsp;&nbsp;&nbsp;використовуються для&nbsp; провадження відповідного виду господарської&nbsp;діяльності;</li>\r\n	<li>Перелік трубопроводів, що перебувають у користуванні заявника суб&rsquo;єкта господарювання, їх технічна характеристика та річні обсяги&nbsp;транспортування теплової&nbsp; енергії;</li>\r\n	<li>Перелік приладів обліку із зазначенням місць їх&nbsp; встановлення;</li>\r\n	<li>Схема трубопроводів, нанесена на географічну карту місцевості;</li>\r\n	<li>Копія затвердженої місцевим органом виконавчої влади схеми теплопостачання;</li>\r\n	<li>Засвідчені в установленому порядку копії актів і схем розмежування ділянок обслуговування між суб&rsquo;єктами господарювання, трубопроводами яких з&rsquo;єднані між собою;</li>\r\n	<li>Засвідчені в установленому порядку копії документів, що підтверджують освітній і кваліфікаційний рівень працівників, необхідний для провадження відповідного виду господарської діяльності;</li>\r\n	<li>Відомість про обсяги &nbsp;постачання теплової&nbsp; енергії за підписом керівника суб&rsquo;єкта господарювання;</li>\r\n	<li>Баланс підприємства на останню звітну дату за підписом керівника&nbsp;суб&rsquo;єкта господарювання, скріпленим печаткою.</li>\r\n</ul>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p><strong>Одна мінімальна заробітна плата виходячи з її розміру на дату прийняття органам ліцензування рішення про видачу ліцензії.</strong></p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж 10 робочих днів з дати надходження заяви про видачу ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Ліцензія на право провадження господарської діяльності з виробництва теплової енергії, транспортування її магістральними та місцевими (розподільчими) тепловими мережами та постачання теплової енергії, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(61, 'Складання актів обстеження спеціалізованих або спеціалізованих металургійних переробних підприємств або їх приймальних пунктів', 1, 10, '<ol>\r\n	<li>Стаття 4 Закону України &laquo;Про металобрухт&raquo;.</li>\r\n	<li>Наказ Міністерства економічного розвитку і торгівлі України від 31.10.2011 р. № 183, зареєстрований у Міністерстві юстиції України 18.11.2011&nbsp;р. за №&nbsp;1321/20059&nbsp; &laquo;Про затвердження Ліцензійних умов провадження господарської діяльності із заготівлі, переробки, металургійної переробки металобрухту кольорових і чорних металів&raquo;,</li>\r\n	<li>Наказ Міністерства економічного розвитку і торгівлі України від 03.11.2011 р. №&nbsp;191 &laquo;Про затвердження форм актів обстеження суб&rsquo;єктів господарювання&raquo;.</li>\r\n	<li>Розпорядження голови обласної державної адміністрації від 19.04.2013 №&nbsp;356/А-2013 &laquo;Про робочу групу для проведення обстеження спеціалізованих підприємств, спеціалізованих металургійних переробних підприємств та їх приймальних пунктів на відповідність вимогам Закону України &laquo;Про металобрухт&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Письмова заява може бути подана особисто, надіслана поштою або у випадках, передбачених законом&nbsp; за допомогою засобів телекомунікаційного зв&rsquo;язку через Управління надання адміністративних послуг Одеської міської ради.</p>\r\n', '<p>Заява на отримання адміністративної послуги в письмовій формі.</p>\r\n', 0, '', '', '', '<p>Протягом 15 календарних днів з дня надходження заяви до суб&rsquo;єкта надання адміністративної послуги.</p>\r\n', '<p>Невідповідність спеціалізованих або спеціалізованих металургійних переробних підприємств та їх приймальних пунктів вимогам Закону України &laquo;Про металобрухт&raquo; та Ліцензійним умовам провадження господарської діяльності із заготівлі, переробки, металургійної переробки металобрухту кольорових і чорних металів, затвердженим наказом Міністерства економічного розвитку і торгівлі України від 31.10.2011&nbsp;№&nbsp;183, зареєстрованим у Міністерстві юстиції України 18.11.2011&nbsp;р. за №&nbsp;1321/20059.</p>\r\n', '<p>Акт обстеження спеціалізованого або спеціалізованого металургійного переробного підприємства або його приймальних пунктів або лист з обґрунтуванням причин відмови.</p>\r\n', '<p>Через Центр&nbsp;надання адміністративних послуг Одеської міської ради, суб&rsquo;єктом звернення особисто або направлення поштою (рекомендованим листом з повідомленням про вручення) листа з повідомленням про можливість отримання такої послуги на адресу суб&rsquo;єкта звернення.</p>\r\n', 'так', 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`) VALUES
(62, 'Державна реєстрація змін і доповнень до договорів (контрактів) про спільну інвестиційну діяльність за участю іноземного інвестора', 1, 5, '<ol>\r\n	<li>Стаття 24 Закону України &laquo;Про режим іноземного інвестування&raquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 30.01.1997 №112 &quot;Про затвердження Положення про порядок державної реєстрації договорів (контрактів) про спільну інвестиційну діяльність за участю іноземного інвестора&quot;.</li>\r\n	<li>Наказ Міністерства зовнішніх економічних зв&#39;язків і торгівлі України від 20.02.1997 р. №125 України &laquo;Про заходи МЗЕЗторгу щодо забезпечення виконання Постанови КМУ від 30.01.1997 р. № 112&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&#39;єкт зовнішньоекономічної діяльності України - учасник договору (контракту), якому доручено ведення спільних справ учасників, або уповноважена ним особа подає документи до Центру надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Лист-звернення про державну реєстрацію змін і доповнень до договору (контракту).</li>\r\n	<li>Інформаційна картка договору (контракту) за формою, що встановлює Мінекономрозвитку.</li>\r\n	<li>Договір (контракт) (оригінал і копію), засвідчені в установленому порядку.</li>\r\n	<li>Засвідчені копії установчих документів суб&rsquo;єкта (суб&rsquo;єктів) зовнішньоекономічної діяльності України та свідоцтва про його державну реєстрацію як суб&rsquo;єкта підприємницької діяльності.</li>\r\n	<li>Документи, що свідчать про реєстрацію (створення) іноземної юридичної особи (нерезидента) в країні її місцезнаходження (витяг із торгівельного, банківського або судового реєстру тощо). Ці документи повинні бути засвідчені відповідно до законодавства країни їх видачі, перекладенні українською мовою та легалізовані у консульській установі України, якщо міжнародними договорами, в яких бере участь Україна, не передбачено інше. Зазначені документи можуть бути засвідчені також у посольстві відповідної держави в Україні та легалізовані в МЗС.</li>\r\n	<li>Ліцензія, якщо згідно із законодавством України цього вимагає діяльність, що передбачається договором (контрактом).</li>\r\n	<li>Документ про оплату послуг за державну реєстрацію договору (контракту).</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 30.01.1997 №112 &quot;Про затвердження Положення про порядок державної реєстрації договорів (контрактів) про спільну інвестиційну діяльність за участю іноземного інвестора&quot;.</p>\r\n', '<p>Шість неоподатковуваних мінімумів доходів громадян, встановлених на день реєстрації.</p>\r\n', '<p>---</p>\r\n', '<p>20 днів</p>\r\n', '<p>Порушення встановленого порядку реєстрації.</p>\r\n', '<ol>\r\n	<li>Державна реєстрація змін і доповнень до договору (контракту) про спільну інвестиційну діяльність за участю іноземного інвестора;</li>\r\n	<li>Відмова в наданні адміністративної послуги.</li>\r\n</ol>\r\n', '<p>Адміністративна послуга вважається надана з моменту отримання її через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(64, 'видача дублікату картки державної реєстрації договору (контракту) про спільну інвестиційну діяльність за участю іноземного інвестора', 1, 5, '<ol>\r\n	<li>Стаття 24 Закону України &laquo;Про режим іноземного інвестування&raquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 30.01.1997 №112 &quot;Про затвердження Положення про порядок державної реєстрації договорів (контрактів) про спільну інвестиційну діяльність за участю іноземного інвестора&quot;.</li>\r\n	<li>Наказ Міністерства зовнішніх економічних зв&#39;язків і торгівлі України від 20.02.1997 р. №125 України &laquo;Про заходи МЗЕЗторгу щодо забезпечення виконання Постанови КМУ від 30.01.1997 р. № 112&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&#39;єкт зовнішньоекономічної діяльності України - учасник договору (контракту), якому доручено ведення спільних справ учасників, або уповноважена ним особа подає документи до Центру надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Опубліковану в офіційній пресі об&#39;яву про визнання недійсною втраченої картки державної реєстрації договору (контракту).</li>\r\n	<li>Документ, що засвідчує сплату збору за видачу картки і дубліката картки державної реєстрації договору (контракту).&nbsp;</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 30.01.1997 №112 &quot;Про затвердження Положення про порядок державної реєстрації договорів (контрактів) про спільну інвестиційну діяльність за участю іноземного інвестора&quot;.</p>\r\n', '<p>2,4 неоподатковуваних мінімумів доходів громадян, встановлених на день видачі дублікату картки державної реєстрації договору (контракту).</p>\r\n', '<p>Розміщені на інтернет-сторінці</p>\r\n\r\n<p>www.ved.odessa.gov.ua</p>\r\n', '<p>5 днів</p>\r\n', '<p>Порушення встановленого порядку видачі дублікату.</p>\r\n', '<ol>\r\n	<li>Видача дублікату картки державної реєстрації договору (контракту).</li>\r\n	<li>Відмова в наданні адміністративної послуги.</li>\r\n</ol>\r\n', '<p>Адміністративна послуга вважається надана з моменту отримання її через Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(65, 'Ліцензування діяльності з торгівлі пестицидами та агрохімікатами (тільки регуляторами росту рослин)', 1, 11, '<ol>\r\n	<li>Закон України &laquo;Про ліцензування певних видів господарської діяльності&raquo;&nbsp;від 1 червня 2000 року №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 14 листопада 2000 року №1698 &laquo;Про затвердження переліку органів ліцензування&raquo;;</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження переліку документів, які додаються до заяви про видачу ліцензії для окремого виду господарської діяльності&rdquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 29 листопада 2000 року №1755 &laquo;Про строк дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&raquo;.</li>\r\n	<li>Наказ Міністерства аграрної політики та продовольства України від 17 липня 2013 року №439 &laquo;Про затвердження Ліцензійних умов провадження господарської діяльності з торгівлі пестицидами та агрохімікатами (тільки регуляторами росту рослин&raquo;.</li>\r\n	<li>Розпорядження обласної державної адміністрації від 20.12.2012 року №1398/А-2012 &laquo;Про ліцензування окремих видів господарської діяльності&raquo;</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт господарювання звертається до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява про видачу ліцензії встановленого зразка;</li>\r\n	<li>Відомості за підписом заявника - суб&#39;єкта господарювання (за формою, встановленою ліцензійними умовами) про наявність власних або орендованих складських і торгових приміщень, матеріально-технічної бази та їх відповідність встановленим вимогам;</li>\r\n	<li>Копії допусків (посвідчень) працівників на право роботи з пестицидами та агрохімікатами (тільки регуляторами росту рослин);</li>\r\n	<li>Гарантійний лист про утилізацію токсичних відходів, які виникають у процесі здійснення торгівлі.<em>&nbsp; &nbsp;</em></li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000 року №1755 &laquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&raquo; (зі змінами згідно Постанови КМУ України від 20 жовтня 2011 року №1059).</p>\r\n', '<p>Одна мінімальна заробітна плата виходячи з її розміру, що діє на дату прийняття органом ліцензування рішення про видачу ліцензії:</p>\r\n\r\n<p>з 1 січня 2014р. &ndash; 1218 грн., з 1 липня -1250 грн., 1 жовтня 2014р. &ndash; 1301 грн.<br />\r\n&nbsp;</p>\r\n', '<p>Одержувач: <strong>ГУДКСУ в Одеській області</strong></p>\r\n\r\n<p>Банк одержувача: <strong>ГУДКСУ в Одеській області</strong></p>\r\n\r\n<p>ЄДРПОУ (код): 37607526</p>\r\n\r\n<p>Розрахунковий рахунок: <strong>31413511700001</strong></p>\r\n\r\n<p>МФО (код банку): <strong>828011</strong></p>\r\n\r\n<p>Код платежу: <strong>22010200</strong></p>\r\n\r\n<p>Призначення платежу: <strong>плата за видачу ліцензії</strong></p>\r\n', '<p><strong>Рішення про видачу або про відмову у видачі ліцензії приймається у строк не пізніше ніж 10 робочих днів з дати надходження заяви про видачу ліцензії та документів, що додаються до заяви.</strong></p>\r\n\r\n<p>Оформлення ліцензії здійснюється не пізніше ніж за три робочі дні з дня надходження документа, що підтверджує внесення плати за видачу ліцензії.</p>\r\n', '<ol>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>&nbsp;Документи оформлені з порушенням вимог статті 10 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;&nbsp;від 1 червня 2000 року №1775-ІІІ.</li>\r\n</ol>\r\n', '<p>Видається ліцензія на торгівлю пестицидами та агрохімікатами (тільки регуляторами росту рослин).</p>\r\n', '<p>Повідомлення про прийняття рішення про видачу ліцензії або про відмову видачі ліцензії надсилається (видається) заявникові в письмовій формі особисто або поштою. Ліцензія видається особисто ліцензіату.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(66, 'Видача дублікату ліцензії на торгівлю пестицидами та агрохімікатами (тільки регуляторами росту рослин)', 1, 11, '<ol>\r\n	<li>Закон України &laquo;Про ліцензування певних видів господарської діяльності&raquo;&nbsp;від 1 червня 2000 року №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 14 листопада 2000 року №1698 &laquo;Про затвердження переліку органів ліцензування&raquo;;</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження переліку документів, які додаються до заяви про видачу ліцензії для окремого виду господарської діяльності&rdquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 29 листопада 2000 року №1755 &laquo;Про строк дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&raquo;.</li>\r\n	<li>Наказ Міністерства аграрної політики та продовольства України від 17 липня 2013 року №439 &laquo;Про затвердження Ліцензійних умов провадження господарської діяльності з торгівлі пестицидами та агрохімікатами (тільки регуляторами росту рослин&raquo;.</li>\r\n	<li>Розпорядження обласної державної адміністрації від 20.12.2012 року №1398/А-2012 &laquo;Про ліцензування окремих видів господарської діяльності&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт господарювання звертається до центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<p>У разі втрати ліцензії ліцензіат зобов&rsquo;язаний звернутися до органу ліцензування із заявою про видачу дубліката ліцензії, до якої додається документ, що засвідчує внесення плати за видачу дубліката ліцензії.</p>\r\n\r\n<p>Якщо бланк ліцензії непридатний для користування внаслідок його пошкодження, ліцензіат подає слідуючи документи:</p>\r\n\r\n<ul>\r\n	<li>заява про видачу дубліката ліцензії встановленого зразка;</li>\r\n	<li>непридатна для користування ліцензія;</li>\r\n	<li>документ, що підтверджує внесення плати за видачу дубліката ліцензії.</li>\r\n</ul>\r\n\r\n<p>&nbsp;</p>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000 року №1755 &laquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&raquo; (зі змінами згідно Постанови КМУ України від 20 жовтня 2011 року №1059).</p>\r\n', '<p>За видачу дубліката ліцензії справляється плата в розмірі п&rsquo;яти неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p>Одержувач: <strong>ГУДКСУ в Одеській області</strong></p>\r\n\r\n<p>Банк одержувача: <strong>ГУДКСУ в Одеській області</strong></p>\r\n\r\n<p>ЄДРПОУ (код): 37607526</p>\r\n\r\n<p>Розрахунковий рахунок: <strong>31413511700001</strong></p>\r\n\r\n<p>МФО (код банку): <strong>828011</strong></p>\r\n\r\n<p>Код платежу: <strong>22010200</strong></p>\r\n\r\n<p>Призначення платежу: <strong>плата за видачу ліцензії</strong></p>\r\n', '<p>Орган ліцензування зобов&rsquo;язаний протягом трьох робочих днів з дати одержання заяви про видачу дубліката ліцензії видати заявникові дублікат ліцензії замість втраченої або пошкодженої.</p>\r\n', '<ol>\r\n	<li><em>Заява подана (підписана) особою, яка не має на це повноважень;</em></li>\r\n	<li><em>&nbsp;Документи оформлені з порушенням вимог статті 10 </em><em>Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;&nbsp;від 1 червня 2000 року №1775-ІІІ.</em></li>\r\n</ol>\r\n', '<p>Видача дубліката ліцензії на торгівлю пестицидами та агрохімікатами (тільки регуляторами росту рослин).</p>\r\n', '<p>Повідомлення про видачу дубліката ліцензії надсилається (видається) заявникові в письмовій формі особисто або поштою. Дублікат ліцензії видається особисто ліцензіату.&nbsp;</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(67, 'Переоформлення ліцензії на торгівлю пестицидами та агрохімікатами (тільки регуляторами росту рослин)', 1, 11, '<ol>\r\n	<li>Закон України &laquo;Про ліцензування певних видів господарської діяльності&raquo;&nbsp;від 1 червня 2000 року №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 14 листопада 2000 року №1698 &laquo;Про затвердження переліку органів ліцензування&raquo;;</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження переліку документів, які додаються до заяви про видачу ліцензії для окремого виду господарської діяльності&rdquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 29 листопада 2000 року №1755 &laquo;Про строк дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт господарювання звертається до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Ліцензіат подає до органу ліцензування заяву про переоформлення ліцензії разом з ліцензією, що підлягає переоформленню, та відповідними документами або їх нотаріально засвідченими копіями, які підтверджують зазначені зміни.</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000 року №1755 &laquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&raquo; (зі змінами згідно Постанови КМУ України від 20 жовтня 2011 року №1059).</p>\r\n', '<p>За переоформлення ліцензії справляється плата в розмірі п&rsquo;яти неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p><em>Одержувач: <strong>ГУДКСУ в Одеській області</strong></em></p>\r\n\r\n<p><em>Банк одержувача: <strong>ГУДКСУ в Одеській області</strong></em></p>\r\n\r\n<p><em>ЄДРПОУ (код): 37607526</em></p>\r\n\r\n<p><em>Розрахунковий рахунок: <strong>31413511700001</strong> </em></p>\r\n\r\n<p><em>МФО (код банку): <strong>828011</strong></em></p>\r\n\r\n<p><em>Код платежу: <strong>22010200</strong></em></p>\r\n\r\n<p><em>Призначення платежу: <strong>плата за видачу ліцензії.</strong></em></p>\r\n', '<p>Орган ліцензування протягом трьох робочих днів з дати надходження заяви про переоформлення ліцензії та документів, що додаються до неї, зобов&rsquo;язаний видати переоформлену на новому бланку ліцензію з урахуванням змін, зазначених у заяві про переоформлення ліцензії.</p>\r\n\r\n<p>У разі переоформлення ліцензії у зв&rsquo;язку із змінами, пов&rsquo;язаними з провадженням ліцензіатом певного виду господарської діяльності, якщо ця зміна пов&rsquo;язана з намірами ліцензіата розширити свою діяльність, ліцензія переоформляється в порядку і в строки, передбачені для видачі ліцензії.</p>\r\n', '<ol>\r\n	<li>&nbsp;Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>&nbsp;Документи оформлені з порушенням вимог статті 10 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;&nbsp;від 1 червня 2000 року №1775-ІІІ.</li>\r\n</ol>\r\n', '<p>Видається переоформлена ліцензія на торгівлю пестицидами та агрохімікатами (тільки регуляторами росту рослин).</p>\r\n', '<p>Повідомлення про прийняття рішення щодо переоформлення ліцензії або про відмову у переоформленні ліцензії надсилається (видається) заявникові в письмовій формі особисто або поштою. Переоформлена ліцензія видається особисто ліцензіату.<em>&nbsp;</em></p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(68, 'Видача копії ліцензії на торгівлю пестицидами та агрохімікатами (тільки регуляторами росту рослин)', 1, 11, '<ol>\r\n	<li>Закон України &laquo;Про ліцензування певних видів господарської діяльності&raquo;&nbsp;від 1 червня 2000 року №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 14 листопада 2000 року №1698 &laquo;Про затвердження переліку органів ліцензування&raquo;;</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження переліку документів, які додаються до заяви про видачу ліцензії для окремого виду господарської діяльності&rdquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 29 листопада 2000 року №1755 &laquo;Про строк дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт господарювання звертається до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява про видачу копії ліцензії встановленого зразка;</li>\r\n	<li>Відомості за підписом заявника - суб&#39;єкта господарювання (за формою, встановленою ліцензійними умовами) про наявність власних або орендованих складських і торгових приміщень, матеріально-технічної бази та їх відповідність встановленим вимогам.</li>\r\n	<li>Копії допусків (посвідчень) працівників на право роботи з пестицидами та агрохімікатами (тільки регуляторами росту рослин).</li>\r\n	<li>Гарантійний лист про утилізацію токсичних відходів, які виникають у процесі здійснення торгівлі.</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000 року №1755 &laquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&raquo; (зі змінами згідно Постанови КМУ України від 20 жовтня 2011 року №1059).</p>\r\n', '<p>За видачу копії ліцензії справляється плата в розмірі одного неоподаткованого мінімуму доходів громадян.</p>\r\n', '<p>Одержувач: <strong>ГУДКСУ в Одеській області</strong></p>\r\n\r\n<p>Банк одержувача: <strong>ГУДКСУ в Одеській області</strong></p>\r\n\r\n<p>ЄДРПОУ (код): 37607526</p>\r\n\r\n<p>Розрахунковий рахунок: <strong>31413511700001</strong></p>\r\n\r\n<p>МФО (код банку): <strong>828011</strong></p>\r\n\r\n<p>Код платежу: <strong>22010200</strong></p>\r\n\r\n<p>Призначення платежу: <strong>плата за видачу ліцензії</strong></p>\r\n', '<ul>\r\n	<li>Рішення про видачу або про відмову у видачі копії ліцензії приймається у строк не пізніше ніж 10 робочих днів з дати надходження заяви про видачу копії ліцензії та документів, що додаються до заяви.</li>\r\n	<li>Оформлення копії ліцензії здійснюється не пізніше ніж за три робочі дні з дня надходження документа, що підтверджує внесення плати за видачу копії &nbsp;ліцензії.</li>\r\n</ul>\r\n', '<ol>\r\n	<li><em>Заява подана (підписана) особою, яка не має на це повноважень;</em></li>\r\n	<li><em>Документи оформлені з порушенням вимог статті 10 </em><em>Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;&nbsp;від 1 червня 2000 року №1775-ІІІ.</em></li>\r\n</ol>\r\n', '<p>Видається копія ліцензії на торгівлю пестицидами та агрохімікатами (тільки регуляторами росту рослин).</p>\r\n', '<p>Повідомлення про прийняття рішення про видачу копії ліцензії або про відмову видачі копії ліцензії надсилається (видається) заявникові в письмовій формі особисто або поштою. Копія ліцензії видається особисто ліцензіату.&nbsp;</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(69, 'Анулювання ліцензії на діяльність з торгівлі пестицидами та агрохімікатами (тільки регуляторами росту рослин)', 1, 11, '<ol>\r\n	<li>Закон України &laquo;Про ліцензування певних видів господарської діяльності&raquo;&nbsp;від 1 червня 2000 року №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 14 листопада 2000 року №1698 &laquo;Про затвердження переліку органів ліцензування&raquo;;</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження переліку документів, які додаються до заяви про видачу ліцензії для окремого виду господарської діяльності&rdquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 29 листопада 2000 року №1755 &laquo;Про строк дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт господарювання звертається до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<p>Заява ліцензіата про анулювання ліцензії.</p>\r\n', 0, '', '', '', '<p>Рішення про анулювання ліцензії приймається протягом десяти робочих днів з дати встановлення підстав для анулювання ліцензії.</p>\r\n', '<p>&nbsp; &nbsp;&nbsp;Заява подана (підписана) особою, яка не має на це повноважень.</p>\r\n\r\n<p>&nbsp;&nbsp;&nbsp;</p>\r\n', '<p>Анулювання ліцензії.</p>\r\n', '<p>Повідомлення про прийняття рішення про анулювання ліцензії надсилається (видається) заявникові із зазначенням підстав анулювання не пізніше трьох робочих днів з дати його прийняття.&nbsp;</p>\r\n', 'так', 0, NULL, 0, NULL, NULL, NULL, NULL),
(70, 'Внесення суб''єкта видавничої справи до Державного реєстру  видавців, виготівників і розповсюджувачів видавничої продукції', 1, 12, '<ol>\r\n	<li>Розділ 2 Закону України &laquo;Про видавничу справу&raquo;</li>\r\n	<li>Постанова Кабінету Міністрів України від 28.09.1998 №1540 &laquo;Про Державний реєстр видавців, виготівників і розповсюджувачів видавничої продукції&raquo;.</li>\r\n	<li>Наказ Державного комітету телебачення та радіомовлення України від 23.03.2011 №64.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт видавничої справи (заявник) подає пакет документів до Центру надання адміністративних послуг.</p>\r\n', '<p>До заяви про внесення суб&#39;єкта видавничої справи (заявника) до Державного реєстру додаються:</p>\r\n\r\n<p>1. Витяг з Єдиного&nbsp; державного реєстру юридичних осіб та фізичних&nbsp; осіб-підприємців &ndash; суб&rsquo;єкта підприємницької діяльності;</p>\r\n\r\n<p>2. Нотаріально засвідчені копії установчих документів (статут, положення, якими передбачено провадження видавничої діяльності, виготовлення та розповсюдження видавничої продукції, установчий договір);</p>\r\n\r\n<p>3. Передбачувані дані про річний обсяг випуску, виготовлення та розповсюдження видавничої продукції, зокрема для:</p>\r\n\r\n<p>- видавців - фізичні особи - суб&#39;єкти підприємницької діяльності, обсяг випуску видавничої продукції яких становить до 5 назв на рік;</p>\r\n\r\n<p>- виготівників видавничої продукції &ndash; підприємства, установи і організації, фізичні особи &ndash; суб&#39;єкти підприємницької діяльності, які випускають видавничу продукцію на суму до 500 тис. гривень на рік (за цінами, що склалися на час внесення до Державного реєстру);</p>\r\n\r\n<p>- розповсюджувачів видавничої продукції - підприємства і організації, які не мають мережі книгорозповсюдження; фізичні особи - суб&#39;єкти підприємницької діяльності;</p>\r\n\r\n<p>4. Видавнича діяльність - навести перелік або вказати кількість і тематику неперіодичних видань, що готуються до випуску;</p>\r\n\r\n<p>5. Виготовлення видавничої продукції &ndash; вказати, яку видавничу продукцію планується тиражувати на власному обладнанні (свої видання та (або) замовлення інших видавців) і на яку суму;</p>\r\n\r\n<p>6. Розповсюдження видавничої продукції - назвати видавців, неперіодичні видання яких планується розповсюджувати.</p>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 28.09.1998 №1540 &laquo;Про Державний реєстр видавців, виготівників і розповсюджувачів видавничої продукції&raquo;.</p>\r\n', '<p>Реєстраційний збір за внесення суб&#39;єкта видавничої справи до Державного реєстру складає 25 неоподатковуваних мінімумів доходів громадян.</p>\r\n', '<p>Розрахунковий рахунок №33213852700009 в ГУ ДСКУ в м. Одеса.</p>\r\n\r\n<p>Код ЄДРПОУ: 38016923.</p>\r\n\r\n<p>МФО 828011.</p>\r\n\r\n<p>Банк одержувача: ГУ ДКСУ в Одеській області.&nbsp;</p>\r\n\r\n<p>Призначення платежу: в дохід обласного бюджету за внесення до&nbsp; Державного реєстру, код бюджетної кваліфікації 22010900, суб&#39;єкта видавничої справи.</p>\r\n', '<p>27-30 днів&nbsp;</p>\r\n', '<ol>\r\n	<li>Назва, програмні цілі, напрями діяльності суб&#39;єкта видавничої справи суперечать законодавству України;</li>\r\n	<li>Заява про внесення до Державного реєстру подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Суб&#39;єкт видавничої справи з такою назвою вже внесений до Державного реєстру;</li>\r\n	<li>Заяву про внесення до Державного реєстру подано після набрання законної сили рішенням суду про припинення діяльності цього суб&#39;єкта видавничої справи.</li>\r\n</ol>\r\n', '<p>Видача Свідоцтва про внесення суб&#39;єкта видавничої справи до Державного реєстру видавців, виготівників і розповсюджувачів видавничої продукції.</p>\r\n', '<p>Повідомлення про прийняття рішення про видачу Свідоцтва або про відмову видачі Свідоцтва надсилається (видається) суб&#39;єкту видавничої справи в письмовій формі особисто або поштою.</p>\r\n\r\n<p>Свідоцтво про внесення суб&#39;єкта видавничої справи до Державного реєстру видавців, виготівників і розповсюджувачів видавничої продукції суб&#39;єкт видавничої справи отримує особисто.&nbsp;</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(71, 'Видача дубліката Свідоцтва про внесення до Державного реєстру  видавців, виготівників і розповсюджувачів видавничої продукції ', 12, 12, '<p>Розділ 2 Закону України &laquo;Про видавничу справу&raquo;</p>\r\n\r\n<p>Постанова Кабінету Міністрів України від 28.09.1998 №1540 &laquo;Про Державний реєстр видавців, виготівників і розповсюджувачів видавничої продукції&raquo;.</p>\r\n\r\n<p>Наказ Державного комітету телебачення та радіомовлення України від 23.03.2011 №64.</p>\r\n', '<p>Заява про видачу дубліката Свідоцтва про внесення суб&#39;єкта видавничої справи до Державного реєстру, що підписана уповноваженою на те особою.</p>\r\n', '<p>Суб&rsquo;єкт видавничої справи (заявник) подає пакет документів до Центру надання адміністративних послуг&nbsp;особисто або через особу.</p>\r\n', '<p>До заяви про внесення суб&#39;єкта видавничої справи (заявника) до Державного реєстру додається витяг з Єдиного&nbsp; державного реєстру юридичних осіб та фізичних&nbsp; осіб-підприємців &ndash; суб&rsquo;єкта підприємницької діяльності та документи, що засвідчують уповноважену на те особу.</p>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 28.09.1998 №1540 &laquo;Про Державний реєстр видавців, виготівників і розповсюджувачів видавничої продукції&raquo;.</p>\r\n', '<p>Реєстраційний збір за видачу дубліката Свідоцтва складає 20 відсотків суми реєстраційного збору.</p>\r\n', '<p>Розрахунковий рахунок №33213852700009 в ГУ ДСКУ в м. Одеса.</p>\r\n\r\n<p>Код ЄДРПОУ: 38016923.</p>\r\n\r\n<p>МФО 828011.</p>\r\n\r\n<p>Банк одержувача: ГУ ДКСУ в Одеській області.&nbsp;</p>\r\n\r\n<p>Призначення платежу: в дохід обласного бюджету за внесення до&nbsp; Державного реєстру, код бюджетної кваліфікації 22010900, суб&#39;єкта видавничої справи.</p>\r\n', '<p>12-15 днів&nbsp;</p>\r\n', '<p>Одержувачеві адміністративної послуги може бути відмовлено у разі, коли:</p>\r\n\r\n<ol>\r\n	<li>Назва, програмні цілі, напрями діяльності суб&#39;єкта видавничої справи суперечать законодавству України;</li>\r\n	<li>Заява про видачу дубліката Свідоцтва подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Заяву про видачу дубліката Свідоцтва подано після набрання законної сили рішенням суду про припинення діяльності цього суб&#39;єкта видавничої справи.</li>\r\n</ol>\r\n', '<p>Видача дубліката Свідоцтва про внесення суб&#39;єкта видавничої справи до Державного реєстру видавців, виготівників і розповсюджувачів видавничої продукції.</p>\r\n', '<p>Повідомлення про прийняття рішення про видачу дубліката Свідоцтва або про відмову видачі дубліката Свідоцтва надсилається (видається) суб&#39;єкту видавничої справи в письмовій формі особисто або поштою.</p>\r\n\r\n<p>Свідоцтво про внесення суб&#39;єкта видавничої справи до Державного реєстру видавців, виготівників і розповсюджувачів видавничої продукції суб&#39;єкт видавничої справи отримує особисто.&nbsp;</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`) VALUES
(72, 'Внесення змін до Державного реєстру  видавців, виготівників і розповсюджувачів видавничої продукції ', 1, 12, '<ol>\r\n	<li>Розділ 2 Закону України &laquo;Про видавничу справу&raquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 28.09.1998 №1540 &laquo;Про Державний реєстр видавців, виготівників і розповсюджувачів видавничої продукції&raquo;.</li>\r\n	<li>Наказ Державного комітету телебачення та радіомовлення України від 23.03.2011 №64.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт видавничої справи (заявник) подає пакет документів до Центру надання адміністративних послуг особисто або через особу.</p>\r\n', '<p>До заяви про внесення змін до Державного реєстру додаються документи в яких внесено зміни:</p>\r\n\r\n<p>1. витяг з Єдиного державного реєстру юридичних осіб та фізичних осіб-підприємців &ndash; суб&rsquo;єкта підприємницької діяльності;</p>\r\n\r\n<p>2. копія попереднього свідоцтва про внесення до Державного реєстру;</p>\r\n\r\n<p>3. передбачувані дані про річний обсяг випуску, виготовлення, розповсюдження видавничої продукції:</p>\r\n\r\n<p>- видавнича діяльність (навести перелік&nbsp; або вказати кількість&nbsp; і тематику <em>неперіодичних&nbsp; видань, </em>&nbsp;що готуються до випуску);</p>\r\n\r\n<p>- виготовлення видавничої продукції (вказати, яку видавничу продукцію планується тиражувати на <em>власному</em> <em>обладнанні</em> /свої видання та/або&nbsp; замовлення інших видавців/ і на яку суму);</p>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 28.09.1998 №1540 &laquo;Про Державний реєстр видавців, виготівників і розповсюджувачів видавничої продукції&raquo;.</p>\r\n', '<p>Реєстраційний збір за видачу нового Свідоцтва (при внесенні змін до Державного реєстру) складає - 50 відсотків суми реєстраційного збору.&nbsp;</p>\r\n', '<p>Розрахунковий рахунок №33213852700009 в ГУ ДСКУ в м. Одеса.</p>\r\n\r\n<p>Код ЄДРПОУ: 38016923.</p>\r\n\r\n<p>МФО 828011.</p>\r\n\r\n<p>Банк одержувача: ГУ ДКСУ в Одеській області.&nbsp;</p>\r\n\r\n<p>Призначення платежу: в дохід обласного бюджету за внесення до&nbsp; Державного реєстру, код бюджетної кваліфікації 22010900, суб&#39;єкта видавничої справи.</p>\r\n', '<p><em>27-30 днів&nbsp;</em></p>\r\n', '<p>Одержувачеві адміністративної послуги може бути відмовлено у разі, коли:</p>\r\n\r\n<ol>\r\n	<li>Назва, програмні цілі, напрями діяльності суб&#39;єкта видавничої справи суперечать законодавству України;</li>\r\n	<li>Заява про внесення змін до Державного реєстру подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Суб&#39;єкт видавничої справи з такою назвою вже внесений до Державного реєстру;</li>\r\n	<li>Заяву про внесення змін до Державного реєстру подано після набрання законної сили рішенням суду про припинення діяльності цього суб&#39;єкта видавничої справи.</li>\r\n</ol>\r\n', '<p>Видача Свідоцтва про внесення суб&#39;єкта видавничої справи до Державного реєстру видавців, виготівників і розповсюджувачів видавничої продукції.</p>\r\n', '<p>Повідомлення про прийняття рішення про видачу Свідоцтва або про відмову видачі Свідоцтва надсилається (видається) суб&#39;єкту видавничої справи в письмовій формі особисто або поштою.</p>\r\n\r\n<p>Свідоцтво про внесення суб&#39;єкта видавничої справи до Державного реєстру видавців, виготівників і розповсюджувачів видавничої продукції суб&#39;єкт видавничої справи отримує особисто.&nbsp;</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(73, 'Виключення суб''єкта видавничої справи з Державного реєстру  видавців, виготівників і розповсюджувачів видавничої продукції ', 1, 12, '<ol>\r\n	<li>Розділ 2 Закону України &laquo;Про видавничу справу&raquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 28.09.1998 №1540 &laquo;Про Державний реєстр видавців, виготівників і розповсюджувачів видавничої продукції&raquo;.</li>\r\n	<li>Наказ Державного комітету телебачення та радіомовлення України від 23.03.2011 №64.</li>\r\n</ol>\r\n', '<p>Заява про виключення суб&#39;єкта видавничої справи з Державного реєстру.</p>\r\n', '<p>Суб&rsquo;єкт видавничої справи подає документи до Центру надання адміністративних послуг&nbsp;особисто або через особу.</p>\r\n', '<p>До заяви надається Свідоцтво про внесення суб&#39;єкта видавничої справи до Державного реєстру видавців, виготівників і розповсюджувачів видавничої продукції.</p>\r\n', 0, '', '', '', '<p><em>7-9 днів&nbsp;</em></p>\r\n', '<p>--</p>\r\n', '<p>Анулювання Свідоцтва та виключення з Державного реєстру видавців, виготівників і розповсюджувачів видавничої продукції.</p>\r\n', '<p>Повідомлення про прийняття рішення про виключення з Державного реєстру видавців, виготівників і розповсюджувачів видавничої продукції в письмовій формі особисто або поштою.&nbsp;</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(74, 'Дозвіл на відновлення земляних робіт', 1, 13, '<ol>\r\n	<li>п. 15 ч. 1 ст. 6 Закон України &laquo;Про охорону культурної спадщини&raquo;</li>\r\n	<li>Постанова Кабінету Міністрів України від 21.05.2009 №526 &laquo;Про заходи щодо упорядкування видачі документів дозвільного характеру у сфері господарської діяльності&raquo;.</li>\r\n	<li>Розпорядження Одеської обласної державної адміністрації від 21.05.2012 №473/А-2012 &laquo;Про надання адміністративних послуг&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява на ім&rsquo;я начальника управління охорони об&rsquo;єктів культурної спадщини Одеської обласної державної адміністрації.</li>\r\n	<li>Копія виписки або витягу з Єдиного державного реєстру&nbsp; юридичних осіб та фізичних осіб - підприємців.</li>\r\n	<li>Звіт про археологічне дослідження пам&rsquo;ятки в межах земельної ділянки.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Рішення про надання дозволу приймається протягом одного місяця з дня подання відповідних документів.</p>\r\n', '<ol>\r\n	<li>Надана недостовірна або застаріла інформація та вразі невідповідності поданих документів вичерпному переліку документів, зазначених в п.11;</li>\r\n	<li>Негативний висновок за результатами проведених експертиз та обстежень або інших наукових і технічних оцінок, необхідних для надання адміністративної послуги;</li>\r\n</ol>\r\n\r\n<p>Інші підстави для відмови у видачі документа дозвільного характеру, встановлені законом України.</p>\r\n', '<p>Письмовий дозвіл або лист з обґрунтуванням причин відмови.</p>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(75, 'Видача дубліката дозволу на відновлення земляних робіт', 1, 13, '<ol>\r\n	<li>п. 15 ч. 1 ст. 6 Закон України &laquo;Про охорону культурної спадщини&raquo;.</li>\r\n	<li>п. 9 ст. 4-1 Закону України &laquo;Про дозвільну систему у сфері господарської діяльності&raquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 21.05.2009 №526 &laquo;Про заходи щодо упорядкування видачі документів дозвільного характеру у сфері господарської діяльності&raquo;.</li>\r\n	<li>Розпорядження Одеської обласної державної адміністрації від 21.05.2012 №473/А-2012 &laquo;Про надання адміністративних послуг&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява на ім&rsquo;я начальника управління охорони об&rsquo;єктів культурної спадщини Одеської обласної державної адміністрації.</li>\r\n	<li>Копія виписки або витягу з Єдиного державного реєстру&nbsp; юридичних осіб та фізичних осіб - підприємців.</li>\r\n	<li>У разі пошкодження документа: оригінал непридатного для використання дозволу на відновлення земляних робіт.</li>\r\n	<li>У разі втрати документа: лист-обґрунтування щодо підстав та дати втрати оригіналу дозволу на відновлення земляних робіт.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Рішення про надання дубліката дозволу приймається протягом 2-х&nbsp; робочих днів з дня надходження пакета документів.</p>\r\n', '<p>Надана недостовірна або застаріла інформація та вразі невідповідності поданих документів вичерпному переліку документів.</p>\r\n', '<ol>\r\n	<li>Дублікат дозволу на відновлення земляних робіт;</li>\r\n	<li>Лист з обґрунтуванням причин відмови у видачі дублікату дозволу на відновлення земельних робіт.</li>\r\n</ol>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(76, 'Переоформлення дозволу на відновлення земляних робіт', 1, 13, '<ol>\r\n	<li>п. 15 ч. 1 ст. 6 Закон України &laquo;Про охорону культурної спадщини&raquo;;</li>\r\n	<li>п. 8 ст. 4-1 Закону України &laquo;Про дозвільну систему у сфері господарської діяльності&raquo;</li>\r\n	<li>Постанова Кабінету Міністрів України від 21.05.2009 №526 &laquo;Про заходи щодо упорядкування видачі документів дозвільного характеру у сфері господарської діяльності&raquo;</li>\r\n	<li>Розпорядження Одеської обласної державної адміністрації від 21.05.2012 №473/А-2012 &laquo;Про надання адміністративних послуг&raquo;</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява на ім&rsquo;я начальника управління охорони об&rsquo;єктів культурної спадщини Одеської обласної державної адміністрації.&nbsp;</li>\r\n	<li>Копія виписки або витягу з Єдиного державного реєстру&nbsp; юридичних осіб та фізичних осіб - підприємців.</li>\r\n	<li>Оригінал дозволу на відновлення земляних робіт, що підлягає переоформленню.</li>\r\n</ol>\r\n\r\n<p>Відповідно посвідчені копії документів, що стали підставою для переоформлення документа.</p>\r\n\r\n<p><strong>Підстави для переоформлення документа:</strong>&nbsp;зміна найменування або місцезнаходження суб&rsquo;єкта господарювання та інші підстави, передбачені чинним законодавством.&nbsp;Заяву про переоформлення дозволу на відновлення земляних робіт суб&#39;єкт господарювання зобов&#39;язаний подати&nbsp;<strong>протягом п&#39;яти робочих днів</strong>&nbsp;з дня настання відповідних підстав.</p>\r\n', 0, '', '', '', '<p>Рішення про переоформлення дозволу приймається протягом 2-х&nbsp; робочих днів з дня надходження пакета документів.</p>\r\n', '<p>Надана недостовірна або застаріла інформація та вразі невідповідності поданих документів вичерпному переліку документів.</p>\r\n', '<ol>\r\n	<li>Переоформлений дозвіл на відновлення земляних робіт.</li>\r\n	<li>Лист з обґрунтуванням причин відмови&nbsp;переоформлення дозволу на відновлення земляних робіт.</li>\r\n</ol>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(77, 'Анулювання дозволу на відновлення земляних робіт', 1, 13, '<ol>\r\n	<li>п. 15 ч. 1 ст. 6 Закон України &laquo;Про охорону культурної спадщини&raquo;;</li>\r\n	<li>п. 8 ст. 4-1 Закону України &laquo;Про дозвільну систему у сфері господарської діяльності&raquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 21.05.2009 №526 &laquo;Про заходи щодо упорядкування видачі документів дозвільного характеру у сфері господарської діяльності&raquo;.</li>\r\n	<li>Розпорядження Одеської обласної державної адміністрації від 21.05.2012 №473/А-2012 &laquo;Про надання адміністративних послуг&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява на ім&rsquo;я начальника управління охорони об&rsquo;єктів культурної спадщини Одеської обласної державної адміністрації.&nbsp;</li>\r\n	<li>Копія виписки або витягу з Єдиного державного реєстру&nbsp; юридичних осіб та фізичних осіб - підприємців.</li>\r\n	<li>Оригінал дозволу на відновлення земляних робіт, що підлягає анулюванню.</li>\r\n</ol>\r\n\r\n<p>Відповідно посвідчені копії документів, що стали підставою для анулювання документа</p>\r\n', 0, '', '', '', '<p>Рішення про анулювання дозволу приймається протягом десяти робочих днів з дня одержання заяви та відповідних документів .</p>\r\n', '<p>Надана недостовірна або застаріла інформація та вразі невідповідності поданих документів вичерпному переліку документів.</p>\r\n', '<ol>\r\n	<li>Лист із повідомленням щодо анулювання дозволу на відновлення земляних робіт;</li>\r\n	<li>Лист з обґрунтуванням причин відмови щодо анулювання дозволу на відновлення земляних робіт.</li>\r\n</ol>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(78, 'Погодження розміщення реклами  на пам’ятках місцевого значення, в межах зон охорони цих пам’яток', 1, 13, '<ol>\r\n	<li>п. 15 ч. 1 ст. 6 Закон України &laquo;Про охорону культурної спадщини&raquo;;</li>\r\n	<li>ч.1 ст. 16 Закону України &laquo;Про рекламу&raquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 21.05.2009 № 526 &laquo;Про заходи щодо упорядкування видачі документів дозвільного характеру&raquo;.</li>\r\n	<li>Розпорядження Одеської обласної державної адміністрації від 21.05.2012 №&nbsp;473/А-2012 &laquo;Про надання адміністративних послуг&raquo;.</li>\r\n	<li>п. 29 Додатку № 8 до Порядку взаємодії представників місцевих дозвільних органів, які здійснюють прийом суб&#39;єктів господарювання в&nbsp; одному приміщенні, затверджений рішенням Одеської міської ради від 10.07.2008 №2882-V (зі змінами).</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява на ім&rsquo;я начальника управління охорони об&rsquo;єктів культурної спадщини Одеської обласної державної адміністрації.</li>\r\n	<li>Документи, що посвідчують особу заявника та реєструє заяву і документи.</li>\r\n	<li>Копія виписки або витягу з Єдиного державного реєстру&nbsp; юридичних осіб та фізичних осіб - підприємців.</li>\r\n	<li>Акт обстеження щодо можливості розміщення рекламного засобу на пам&rsquo;ятці місцевого значення, складений представниками управління охорони об&#39;єктів культурної спадщини облдержадміністрації не пізніше ніж за 1 місяць до звернення щодо надання послуги.</li>\r\n	<li>Лист управління реклами Одеської міської ради щодо можливого розміщення реклами.</li>\r\n	<li>Технічна документація щодо розміщення реклами.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Рішення про надання погодження приймається протягом тридцяти календарних днів з дня одержання документації щодо розміщення реклами.</p>\r\n', '<ol>\r\n	<li>Надана недостовірна або застаріла інформація та вразі невідповідності поданих документів вичерпному переліку документів, зазначених в п.11;</li>\r\n	<li>Невідповідність технічної документації вимогам законів та прийнятих відповідно до них нормативно-правових актів;</li>\r\n	<li>Незадовільний стан фасаду, на якому розміщується об&rsquo;єкт;&nbsp;</li>\r\n	<li>Інші підстави для відмови у видачі документа дозвільного характеру, встановлені законом України.</li>\r\n</ol>\r\n', '<p>Лист-погодження, підпис начальника та печатка управління на технічній документації щодо розміщення зовнішньої реклами або лист з обґрунтуванням причин відмови.</p>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(79, 'Декларація відповідності матеріально-технічної бази суб’єкта господарювання вимогам законодавства з питань пожежної безпеки', 1, 14, '<ol>\r\n	<li>Кодекс цивільного захисту України № 5403-VI 02.10.2012 року.</li>\r\n	<li>Закон України № 5203-VI &nbsp;06.09.2012 &laquo;Про адміністративні послуги&raquo;.</li>\r\n	<li>Закон України № 2806-VI від 06.09.2005 &laquo;Про дозвільну систему у&nbsp; сфері господарської діяльності&raquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 27.01.2012 №&nbsp;77&nbsp;&laquo;Деякі питання застосування принципу мовчазної згоди&raquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 05.06.2013 №440&nbsp;&laquo;Про затвердження Порядку подання і реєстрації декларації відповідності матеріально-технічної бази суб&rsquo;єкта господарювання вимогам законодавства з питань пожежної безпеки&raquo;.</li>\r\n</ol>\r\n\r\n<p>&nbsp;</p>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<p>Декларація відповідності матеріально-технічної бази суб&rsquo;єкта господарювання вимогам законодавства з питань пожежної безпеки (2 прим.)</p>\r\n', 0, '', '', '', '<p>10 днів</p>\r\n', '<p>Декларацію подано чи оформлено з порушенням вимог, визначених постановою Кабінету Міністрів України від 05.06.2013р. №&nbsp;440&nbsp;&laquo;Про затвердження порядку подання і реєстрації декларації відповідності матеріально-технічної бази суб&rsquo;єкта господарювання вимогам законодавства з питань пожежної безпеки&raquo;.</p>\r\n', '<p>Реєстрація декларації відповідності матеріально-технічної бази суб&rsquo;єкта&nbsp;господарювання вимогам законодавства з питань пожежної безпеки.</p>\r\n', '<p>Через центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(80, 'Видача фізичним особам висновку державної санітарно-епідеміологічної експертизи діючих об’єктів', 1, 15, '<ol>\r\n	<li>Закон України &bdquo;Про дозвільну систему у сфері господарської діяльності&raquo;;</li>\r\n	<li>Закон України &laquo;Про перелік документів дозвільного характеру у сфері господарської діяльності&raquo;;</li>\r\n	<li>Закон України &laquo;Про забезпечення санітарного та епідемічного благополуччя населення&raquo;;</li>\r\n	<li>Закон України &laquo;Про відходи&raquo;;</li>\r\n	<li>Закон України &laquo;Про охорону атмосферного повітря&raquo;;</li>\r\n	<li>Закон України &bdquo;Про питну воду та питне водопостачання&rdquo;;</li>\r\n	<li>Закон України &bdquo;Про регулювання містобудівної діяльності&rdquo;;</li>\r\n	<li>Закон України &bdquo;Про адміністративні послуги&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через центр надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява на ім&rsquo;я головного державного санітарного лікаря відповідної адміністративної території за формою, затвердженою наказом МОЗ України від 09.10.2000 №247, зареєстрованим в Мін&rsquo;юсті України 10.01.2001 за №4/5195 &laquo;Про затвердження тимчасового порядку проведення державної санітарно-епідеміологічної експертизи&raquo; (із змінами).</li>\r\n	<li>Документ власника, що декларує відповідність об&rdquo;єкта експертизи визначеним в Україні вимогам щодо їх безпеки для здоров&#39;я людини ( Свідоцтво на право власності на об&rsquo;єкт експертизи або Акт державної приймальної комісії про прийняття в експлуатацію закінченого будівництвом об&rsquo;єкта або будівельний паспорт).</li>\r\n	<li>Акт санітарно-епідеміологічного обстеження обєкта експертизи ( за формою 315/о, (Наказ МОЗ України від 11.07.2000р. № 160 &bdquo;Про затвердження форм облікової статистичної документації, що використовується в санітарно-епідеміологічних закладах&rdquo;).</li>\r\n</ol>\r\n', 1, '<ol>\r\n	<li>Закон України &laquo;Про забезпечення санітарного та епдемічного благополуччя населення&raquo; (ст. 35);</li>\r\n	<li>Розпорядження Кабінету Міністрів України від 26.10.2011 № 1067-р &laquo;Про затвердження переліку платних адміністративних послуг, які надаються Державною санітарно-епідеміологічною службою та установами і закладами, що належать до сфери її управління&raquo;;</li>\r\n	<li>Постанова Кабінету Міністрів України від 27.08.2003 № 1351 &laquo;Про затвердження тарифів (прейскурантів) на роботи і послуги, що виконуються і надаються за плату установами та закладами державної санітарно-епідеміологічної служби&raquo;.</li>\r\n</ol>\r\n', '<p>200 грн. без ПДВ&nbsp;</p>\r\n', '<p>Постачальник: Головне управління Державної санітарно-епідеміологічної служби в Одеській області</p>\r\n\r\n<p>Адреса: м. Одеса, вул. Старопортофранківська, 8.</p>\r\n\r\n<p>Р/рах. №31114028700008</p>\r\n\r\n<p>МФО 828011 в ГУДКСУ у Одеській області</p>\r\n\r\n<p>Код 37607526</p>\r\n\r\n<p>Код платежу 22012500</p>\r\n\r\n<p>Плата за надання інших адміністративних послуг</p>\r\n', '<p>10 днів</p>\r\n', '<ol>\r\n	<li>Подання неповного пакета документів, необхідних для одержання документа дозвільного характеру, згідно із встановленим вичерпним переліком;</li>\r\n	<li>Виявлення в документах, поданих фізичною особою, недостовірних відомостей;</li>\r\n	<li>Негативний висновок за результатами проведених експертиз та обстежень.</li>\r\n	<li>Інші підстави, які передбачені чинним законодавством.</li>\r\n</ol>\r\n', '<p>Видача фізичним особам висновку державної санітарно-епідемологічної експертизи діючих об&rsquo;єктів або відмова у видачі фізичним особам висновку&nbsp;державної санітарно-епідемологічної експертизи діючих об&rsquo;єктів.</p>\r\n', '<p>Через центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL),
(81, 'Реєстрація декларації про початок виконання підготовчих робіт\r\n', 1, 16, '<p>Закон України &laquo;Про регулювання містобудівної діяльності&raquo; стаття 35.</p>\r\n', '<p>Початок виконання підготовчих робіт щодо будівництва об&rsquo;єкта&nbsp;</p>\r\n', '<p>Подається особисто замовником (його уповноваженою особою) до Центру надання адміністративних послуг.</p>\r\n', '<p>Два примірники декларації про початок виконання підготовчих робіт відповідно до вимог статті 35 Закону України &laquo;Про регулювання містобудівної діяльності&raquo; за формою встановленого зразка.</p>\r\n', 0, '', '', '', '<p>П&#39;ять робочих днів з дня надходження декларації.</p>\r\n', '<p>Подання чи оформлення декларації з порушенням установлених вимог.</p>\r\n', '<p>Реєстрація декларації про початок виконання підготовчих робіт.</p>\r\n', '<p>Зареєстрована декларація направляється замовнику засобами поштового зв`язку.</p>\r\n\r\n<p>Інформація щодо зареєстрованої декларації про початок виконання підготовчих робіт розміщується на офіційному сайті Держархбудінспекції України у розділі &laquo;Дозвільні документи&raquo; у єдиному реєстрі отриманих повідомлень про початок виконання підготовчих і будівельних робіт, зареєстрованих декларацій про початок виконання підготовчих і будівельних робіт, виданих дозволів на виконання будівельних робіт, зареєстрованих декларацій про готовність об&rsquo;єкта&nbsp; до експлуатації та виданих сертифікатів, відмов у реєстрації таких декларацій та у видачі таких дозволів і сертифікатів.</p>\r\n', 'так', 0, '', 0, '', '', '', ''),
(82, 'Внесення змін до декларації про початок виконання підготовчих робіт\r\n', 1, 16, '<ol>\r\n	<li>Закон України &laquo;Про регулювання містобудівної діяльності&raquo; частина перша статті 39-1.</li>\r\n	<li>Пункт 14 Порядку виконання підготовчих робіт, затвердженого постановою Кабінету Міністрів України від 13.04.2011 № 466 &laquo;Деякі питання виконання підготовчих та будівельних робіт&raquo;, п. 49 Розпорядження Кабінету Міністрів України від 16 травня 2014 №523-р.</li>\r\n</ol>\r\n', '<p>Виявлення замовником технічної помилки в зареєстрованій декларації про початок виконання підготовчих робіт або отримання відомостей про виявлення у такій декларації недостовірних даних.</p>\r\n', '<p>Подається особисто замовником (його уповноваженою особою) до Центру надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява згідно статті 39-1 Закону України &laquo;Про регулювання містобудівної діяльності&raquo; та пункту 14 Порядку виконання підготовчих робіт, затвердженого постановою Кабінету Міністрів України від 13.04.2011 № 466 &laquo;Деякі питання виконання підготовчих та будівельних робіт&raquo; за формою встановленого зразка.</li>\r\n	<li>Один примірник зареєстрованої декларації, в якій виявлено технічну помилку або недостовірні дані.</li>\r\n	<li>Два примірники декларації, в якій враховані зміни згідно статті 39-1 Закону України &laquo;Про регулювання містобудівної діяльності&raquo; та пункту 14 Порядку виконання підготовчих робіт, затвердженого постановою Кабінету Міністрів України від 13.04.2011 № 466 &laquo;Деякі питання виконання підготовчих та будівельних робіт&raquo; за формою встановленого зразка.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>П&rsquo;ять робочих днів з дня надходження декларації.</p>\r\n', '<p>Подання чи оформлення декларації з порушенням установлених вимог.</p>\r\n', '<ol>\r\n	<li>Реєстрація декларації про початок виконання підготовчих робіт, в якій враховано зміни.</li>\r\n	<li>Внесення достовірних даних до єдиного&nbsp; реєстру&nbsp; отриманих повідомлень&nbsp; про початок&nbsp; виконання&nbsp; підготовчих&nbsp; будівельних робіт, зареєстрованих декларацій&nbsp; про початок виконання підготовчих і будівельних робіт, виданих&nbsp; дозволів&nbsp; на&nbsp; виконання будівельних робіт, зареєстрованих декларацій&nbsp; про&nbsp; готовність&nbsp; об&rsquo;єкта&nbsp; до&nbsp; експлуатації&nbsp; та виданих сертифікатів,&nbsp; повернених&nbsp; декларацій&nbsp; та&nbsp; відмов&nbsp; у&nbsp; видачі таких дозволів&nbsp; і&nbsp; сертифікатів.</li>\r\n</ol>\r\n', '<p>Зареєстрована декларація направляється замовнику засобами поштового зв`язку.</p>\r\n\r\n<p>Інформація щодо зареєстрованої декларації про початок виконання підготовчих робіт розміщується на офіційному сайті Держархбудінспекції України у розділі &laquo;Дозвільні документи&raquo; у єдиному реєстрі отриманих повідомлень про початок виконання підготовчих і будівельних робіт, зареєстрованих декларацій про початок виконання підготовчих і будівельних робіт, виданих дозволів на виконання будівельних робіт, зареєстрованих декларацій про готовність об&rsquo;єкта&nbsp; до експлуатації та виданих сертифікатів, відмов у реєстрації таких декларацій та у видачі таких дозволів і сертифікатів.</p>\r\n', 'так', 0, '', 0, '', '', '', ''),
(83, 'Реєстрація декларації про початок виконання будівельних робіт\r\n', 1, 16, '<p>Закон України &laquo;Про регулювання містобудівної діяльності&raquo; частина перша &nbsp;&nbsp;статті 36.</p>\r\n', '<p>Початок виконання будівельних робіт на об&rsquo;єкті будівництва,&nbsp; що належить&nbsp; до &nbsp;I-III&nbsp; категорій&nbsp; складності.</p>\r\n', '<p>Подається особисто замовником (його уповноваженою особою) або надсилається рекомендованим листом з описом вкладення.</p>\r\n', '<p>Два примірники декларації про початок виконання будівельних робіт відповідно до вимог статті 36 Закону України &laquo;Про регулювання містобудівної діяльності&raquo; за формою встановленого зразка.</p>\r\n', 0, '', '', '', '<p>П&rsquo;ять робочих днів з дня надходження декларації.</p>\r\n', '<p>Подання чи оформлення декларації з порушенням установлених вимог.</p>\r\n', '<p>Реєстрація декларації про початок виконання будівельних робіт.</p>\r\n', '<p>Зареєстрована декларація направляється замовнику засобами поштового зв`язку.</p>\r\n\r\n<p>Інформація щодо зареєстрованої декларації про початок виконання будівельних робіт розміщується на офіційному сайті Держархбудінспекції України у розділі &laquo;Дозвільні документи&raquo; у єдиному реєстрі отриманих повідомлень про початок виконання підготовчих і будівельних робіт, зареєстрованих декларацій про початок виконання підготовчих і будівельних робіт, виданих дозволів на виконання будівельних робіт, зареєстрованих декларацій про готовність об&rsquo;єкта&nbsp; до експлуатації та виданих сертифікатів, відмов у реєстрації таких декларацій та у видачі таких дозволів і сертифікатів.</p>\r\n', 'так', 0, '', 0, '', '', '', '');
INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`) VALUES
(84, 'Внесення змін до декларації про початок виконання будівельних робіт\r\n', 1, 16, '<ol>\r\n	<li>Закон України &laquo;Про регулювання містобудівної діяльності&raquo; частина перша статті 39-1.</li>\r\n	<li>Пункт 14 Порядку виконання будівельних робіт, затвердженого постановою Кабінету Міністрів України від 13.04.2011 № 466 &laquo;Деякі питання виконання підготовчих та будівельних робіт&raquo;, п. 50 Розпорядження Кабінету Міністрів України від 16 травня 2014 №523-р.</li>\r\n</ol>\r\n', '<p>Виявлення замовником технічної помилки в зареєстрованій декларації про початок виконання будівельних робіт або отримання відомостей про виявлення у такій декларації недостовірних даних.</p>\r\n', '<p>Подається особисто замовником до Центру надання адміністративних послуг або надсилається рекомендованим листом з описом вкладення.</p>\r\n', '<ol>\r\n	<li>Заява згідно статті 39-1 Закону України &laquo;Про регулювання містобудівної діяльності&raquo; та пункту 14 Порядку виконання підготовчих робіт, затвердженого постановою Кабінету Міністрів України від 13.04.2011 № 466 &laquo;Деякі питання виконання підготовчих та будівельних робіт&raquo; за формою встановленого зразка;</li>\r\n	<li>Один примірник зареєстрованої декларації, в якій виявлено технічну помилку або недостовірні дані;</li>\r\n	<li>Два примірники декларації, в якій враховані зміни згідно статті 39-1 Закону України &laquo;Про регулювання містобудівної діяльності&raquo; та пункту 14 Порядку виконання підготовчих робіт, затвердженого постановою Кабінету Міністрів України від 13.04.2011 № 466 &laquo;Деякі питання виконання підготовчих та будівельних робіт&raquo; за формою встановленого зразка.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>П&rsquo;ять робочих днів з дня надходження декларації.</p>\r\n', '<p>Подання чи оформлення декларації з порушенням установлених вимог.</p>\r\n', '<ol>\r\n	<li>Реєстрація декларації про початок виконання будівельних робіт, в якій враховано зміни;</li>\r\n	<li>Внесення достовірних даних до єдиного&nbsp; реєстру&nbsp; отриманих повідомлень&nbsp; про початок&nbsp; виконання&nbsp; підготовчих&nbsp; будівельних робіт, зареєстрованих декларацій&nbsp; про початок виконання підготовчих і будівельних робіт, виданих&nbsp; дозволів&nbsp; на&nbsp; виконання будівельних робіт, зареєстрованих декларацій&nbsp; про&nbsp; готовність&nbsp; об&rsquo;єкта&nbsp; до&nbsp; експлуатації&nbsp; та виданих сертифікатів,&nbsp; повернених&nbsp; декларацій&nbsp; та&nbsp; відмов&nbsp; у&nbsp; видачі таких дозволів&nbsp; і&nbsp; сертифікатів.</li>\r\n</ol>\r\n', '<p>Зареєстрована декларація направляється замовнику засобами поштового зв`язку;</p>\r\n\r\n<p>Інформація щодо зареєстрованої декларації про початок виконання будівельних робіт розміщується на офіційному сайті Держархбудінспекції України у розділі &laquo;Дозвільні документи&raquo; в єдиному реєстрі&nbsp; отриманих повідомлень&nbsp; про початок&nbsp; виконання&nbsp; підготовчих&nbsp; будівельних робіт, зареєстрованих декларацій&nbsp; про початок виконання підготовчих і будівельних робіт, виданих&nbsp; дозволів&nbsp; на&nbsp; виконання будівельних робіт, зареєстрованих декларацій&nbsp; про&nbsp; готовність&nbsp; об&rsquo;єкта&nbsp; до&nbsp; експлуатації&nbsp; та виданих сертифікатів,&nbsp; повернених&nbsp; декларацій&nbsp; та&nbsp; відмов&nbsp; у&nbsp; видачі таких дозволів&nbsp; і&nbsp; сертифікатів</p>\r\n', 'так', 0, '', 0, '', '', '', ''),
(85, 'Реєстрація декларації про готовність об`єкта до експлуатації\r\n', 1, 16, '<ol>\r\n	<li>Закон України &laquo;Про регулювання містобудівної діяльності&raquo; частина перша &nbsp;статті 39.</li>\r\n	<li>Пункт 2&nbsp; Порядку прийняття в експлуатацію закінчених будівництвом об&rsquo;єктів, затвердженого постановою Кабінету Міністрів України від 13.04.2011 № 461 &laquo;Питання прийняття в експлуатацію закінчених будівництвом об&rsquo;єктів&raquo;.</li>\r\n</ol>\r\n', '<p>Експлуатація закінченого будівництвом об`єкта, що належить до&nbsp;І &ndash; ІІІ категорії складності.</p>\r\n', '<p>Подається особисто замовником (його уповноваженою особою) до Центру надання адміністративних послуг&nbsp;або надсилається рекомендованим листом з описом вкладення.</p>\r\n', '<p>Два примірники декларації про готовність об`єкта до експлуатації відповідно до вимог частини першої статті 39 Закону України &laquo;Про регулювання містобудівної діяльності&raquo; за формою встановленого зразка.</p>\r\n', 0, '', '', '', '<p>Десять робочих днів з дня надходження декларації.</p>\r\n', '<p>Подання чи оформлення декларації з порушенням установлених вимог.</p>\r\n', '<p>Реєстрація декларації про готовність об`єкта до експлуатації.</p>\r\n', '<p>Зареєстрована декларація направляється замовнику засобами поштового зв`язку.</p>\r\n\r\n<p>Інформація щодо зареєстрованої декларації про готовність об`єкта до експлуатації розміщується на офіційному сайті Держархбудінспекції України у розділі &laquo;Дозвільні документи&raquo; в єдиному реєстрі отриманих повідомлень про початок виконання підготовчих і будівельних робіт, зареєстрованих декларацій про початок виконання підготовчих і будівельних робіт, виданих дозволів на виконання будівельних робіт, зареєстрованих декларацій про готовність об&rsquo;єкта&nbsp; до експлуатації та виданих сертифікатів, відмов у реєстрації таких декларацій та у видачі таких дозволів і сертифікатів.</p>\r\n', 'так', 0, '', 0, '', '', '', ''),
(86, 'Внесення змін до декларації про готовність об`єкта до експлуатації\r\n', 1, 16, '<ol>\r\n	<li>Закон України &laquo;Про регулювання містобудівної діяльності&raquo; частина перша &nbsp;статті 39-1.</li>\r\n	<li>Пункт 2&nbsp; Порядку прийняття в експлуатацію закінчених будівництвом об&rsquo;єктів, затвердженого постановою Кабінету Міністрів України від 13.04.2011 № 461 &laquo;Питання прийняття в експлуатацію закінчених будівництвом об&rsquo;єктів&raquo;, п. 51 Розпорядження Кабінету Міністрів України від 16 травня 2014 №523-р.</li>\r\n</ol>\r\n', '<p>Виявлення замовником технічної помилки у зареєстрованій декларації про готовність об`єкта до експлуатації або отримання відомостей про виявлення у такій декларації недостовірних даних.</p>\r\n', '<p>Подається особисто замовником до Центру надання адміністративних послуг&nbsp;або надсилається рекомендованим листом з описом вкладення.</p>\r\n', '<ol>\r\n	<li>Заява згідно статті 39-1 Закону України &laquo;Про регулювання містобудівної діяльності&raquo; та пункту 28 Порядку прийняття в експлуатацію закінчених будівництвом об&rsquo;єктів, затвердженого постановою Кабінету Міністрів України від 13.04.2011 № 461 &laquo;Питання прийняття в експлуатацію закінчених будівництвом об&rsquo;єктів&raquo; за формою встановленого зразка;</li>\r\n	<li>Один примірник зареєстрованої декларації, в якій виявлено технічну помилку або недостовірні дані;</li>\r\n	<li>Два примірники декларації, в якій враховані зміни згідно статті 39-1 Закону України &laquo;Про регулювання містобудівної діяльності&raquo; та пункту 28 Порядку прийняття в експлуатацію закінчених будівництвом об&rsquo;єктів, затвердженого постановою Кабінету Міністрів України від 13.04.2011 № 461 &laquo;Питання прийняття в експлуатацію закінчених будівництвом об&rsquo;єктів&raquo; за формою встановленого зразка.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Десять робочих днів з дня надходження декларації.</p>\r\n', '<p>Подання чи оформлення декларації з порушенням установлених вимог.</p>\r\n', '<ol>\r\n	<li>Реєстрація декларації про готовність об`єкта до експлуатації, в якій враховано зміни.</li>\r\n	<li>Внесення достовірних даних до єдиного&nbsp; реєстру&nbsp; отриманих повідомлень&nbsp; про початок&nbsp; виконання&nbsp; підготовчих&nbsp; будівельних робіт, зареєстрованих декларацій&nbsp; про початок виконання підготовчих і будівельних робіт, виданих&nbsp; дозволів&nbsp; на&nbsp; виконання будівельних робіт, зареєстрованих декларацій&nbsp; про&nbsp; готовність&nbsp; об&rsquo;єкта&nbsp; до&nbsp; експлуатації&nbsp; та виданих сертифікатів,&nbsp; повернених&nbsp; декларацій&nbsp; та&nbsp; відмов&nbsp; у&nbsp; видачі таких дозволів&nbsp; і&nbsp; сертифікатів.</li>\r\n</ol>\r\n', '<p>Зареєстрована декларація направляється замовнику засобами поштового зв`язку;</p>\r\n\r\n<p>Інформація щодо зареєстрованої декларації про готовність об`єкта до експлуатації розміщується на офіційному сайті Держархбудінспекції України у розділі &laquo;Дозвільні документи&raquo; в єдиному реєстрі&nbsp; отриманих повідомлень&nbsp; про початок&nbsp; виконання&nbsp; підготовчих&nbsp; будівельних робіт, зареєстрованих декларацій&nbsp; про початок виконання підготовчих і будівельних робіт, виданих&nbsp; дозволів&nbsp; на&nbsp; виконання будівельних робіт, зареєстрованих декларацій&nbsp; про&nbsp; готовність&nbsp; об&rsquo;єкта&nbsp; до&nbsp; експлуатації&nbsp; та виданих сертифікатів,&nbsp; повернених&nbsp; декларацій&nbsp; та&nbsp; відмов&nbsp; у&nbsp; видачі таких дозволів&nbsp; і сертифікатів.</p>\r\n', 'так', 0, '', 0, '', '', '', ''),
(87, 'Видача сертифікату у разі прийняття в експлуатацію закінченого будівництвом об`єкта', 1, 16, '<ol>\r\n	<li>Закон України &laquo;Про регулювання містобудівної діяльності&raquo; частина друга статті 39.</li>\r\n	<li>Пункт 22 Порядку &nbsp;прийняття в експлуатацію закінчених будівництвом об&rsquo;єктів, затвердженого постановою Кабінету Міністрів України від 13.04.2011 № 461 &laquo;Питання прийняття в експлуатацію закінчених будівництвом об&rsquo;єктів&raquo;.</li>\r\n</ol>\r\n', '<p>Експлуатація закінченого будівництвом об&rsquo;єкта IV &ndash; V категорії складності.</p>\r\n', '<p>Подається особисто замовником (його уповноваженою особою) до Центру надання адміністративних послуг&nbsp;або надсилається рекомендованим листом з описом вкладення.</p>\r\n', '<ol>\r\n	<li>Заява за формою встановленого зразка.</li>\r\n	<li>Акт готовності об&rsquo;єкта до експлуатації відповідно до вимог частини другої статті 39 Закону України &laquo;Про регулювання містобудівної діяльності&raquo; за формою встановленого зразка.</li>\r\n</ol>\r\n', 1, '<p>Відповідно до Порядку внесення плати за видачу сертифіката, який видається у разі прийняття в експлуатацію закінченого будівництвом об&rsquo;єкта, та її розмір, затвердженого постановою Кабінету Міністрів від 13.04.2011 № 461 &laquo;Питання прийняття в експлуатацію закінчених будівництвом об&rsquo;єктів&raquo;.</p>\r\n', '<p>Для закінчених будівництвом об`єктів, що належать:</p>\r\n\r\n<p>до об&rsquo;єктів IV категорії складності &ndash; 4,6 мінімальної заробітної плати;</p>\r\n\r\n<p>до об&rsquo;єктів V категорії складності &ndash; 5,2 мінімальної заробітної плати.</p>\r\n', '<p>Отримувач: УДКСУ у Дніпровському р-ні м. Києва</p>\r\n\r\n<p>Код 38012871</p>\r\n\r\n<p>ГУДКСУ України у м. Києві</p>\r\n\r\n<p>МФО 820019; р/р 31115028700005</p>\r\n\r\n<p>За сертифікат згідно з постановою КМУ від 13.04.2011 № 461</p>\r\n', '<p>Десять робочих днів з дня реєстрації заяви.</p>\r\n', '<ol>\r\n	<li>Неподання документів, необхідних для прийняття рішення про видачу сертифіката.</li>\r\n	<li>Виявлення недостовірних відомостей у поданих документах.</li>\r\n	<li>Невідповідність об&rsquo;єкта проектній документації та вимогам державних будівельних норм, стандартів і правил.</li>\r\n</ol>\r\n', '<p>Видача сертифіката.</p>\r\n', '<p>Сертифікат направляється замовнику засобами поштового зв`язку. Інформація щодо виданого сертифіката&nbsp; розміщується на офіційному сайті Держархбудінспекції України у розділі &laquo;Дозвільні документи&raquo; у єдиному реєстрі отриманих повідомлень про початок виконання підготовчих і будівельних робіт, зареєстрованих декларацій про початок виконання підготовчих і будівельних робіт, виданих дозволів на виконання будівельних робіт, зареєстрованих декларацій про готовність об&rsquo;єкта&nbsp; до експлуатації та виданих сертифікатів, відмов у реєстрації таких декларацій та у видачі таких дозволів і сертифікатів.</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(88, 'Державна реєстрація фізичної особи, яка має намір стати підприємцем\r\n', 1, 17, '<ol>\r\n	<li>Закон України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; (зі&nbsp; змінами&nbsp; та&nbsp; доповненнями)&nbsp;&nbsp;(статті 8, 10, 42, 43, 44).</li>\r\n	<li>Порядок подання та обігу електронних документів державному реєстратору, затверджений наказом Міністерства юстиції України від 19.08.2011 № 2010/5, зареєстрований в Міністерстві юстиції України 23.08.2011 за № 997/19735.</li>\r\n	<li>Наказ Міністерства юстиції України від 14.10.2011&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; № 3178/5 &quot;Про затвердження форм реєстраційних карток&quot;, зареєстрований в Міністерстві юстиції України 19.10.2011 за № 1207/19945.</li>\r\n	<li>Наказ Міністерства юстиції України від 17.04.2013&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; № 730/5 &quot;Про затвердження форм заяв та повідомлень, надання (надсилання) яких встановлено Законом України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;, зареєстрований в Міністерстві юстиції України 24.04.2013 за № 671/23203.</li>\r\n</ol>\r\n', '<p>Звернення фізичної особи, яка має намір стати підприємцем.</p>\r\n', '<ol>\r\n	<li>Особисто, поштовим відправленням з описом вкладення або через уповноважену особу &ndash; у разі подання документів для проведення державної реєстрації фізичної особи, яка має намір стати підприємцем та має реєстраційний номер облікової картки платника податків.</li>\r\n	<li>Особисто &ndash; у разі подання документів для проведення державної реєстрації фізичної особи, яка через свої релігійні або інші переконання відмовилася від прийняття реєстраційного номера облікової картки платника податків, офіційно повідомила про це відповідні державні органи, має запис в електронному безконтактному носії паспорта громадянина України та намір стати підприємцем.</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Заповнена реєстраційна картка на проведення державної реєстрації фізичної особи &ndash; підприємця (форма 10).</li>\r\n	<li>Копія документа, що засвідчує реєстрацію у Державному реєстрі фізичних осіб &ndash; платників податків.</li>\r\n	<li>Документ, що підтверджує внесення реєстраційного збору&nbsp; за проведення державної реєстрації фізичної особи &ndash; підприємця (копія квитанції, виданої банком, або копія платіжного доручення з відміткою банку).</li>\r\n	<li>Нотаріально посвідчена письмова згода батьків (усиновлювачів) або піклувальника, або органу опіки та піклування, якщо заявником є фізична особа, яка досягла шістнадцяти років і має бажання займатися підприємницькою діяльністю.</li>\r\n	<li>Якщо документи для проведення державної реєстрації подаються заявником особисто, державному реєстратору додатково пред&#39;являється паспорт громадянина України або паспортний документ іноземця.&nbsp;</li>\r\n</ol>\r\n', 1, '<p>???</p>\r\n', '<p>За проведення державної реєстрації фізичної особи &ndash; підприємця справляється реєстраційний збір у розмірі двох неоподатковуваних мінімумів доходів громадян&nbsp;(34 грн.)</p>\r\n', '<p>???</p>\r\n', '<p>Строк державної реєстрації фізичної особи &ndash; підприємця не повинен перевищувати два робочих дні з дати надходження документів для проведення державної реєстрації фізичної особи &ndash; підприємця.</p>\r\n', '<ol>\r\n	<li>Документи подані за неналежним місцем проведення державної реєстрації фізичної особи &ndash; підприємця.</li>\r\n	<li>Документи не відповідають вимогам частин першої та другої статті 8 та частини п&#39;ятої статті 10 Закону України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n	<li>Документи подані не у повному обсязі.&nbsp;</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</li>\r\n	<li>Повідомлення про залишення документів без розгляду.</li>\r\n	<li>Повідомлення про відмову у проведенні державної реєстрації.</li>\r\n</ol>\r\n', '<p>Виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців, повідомлення про залишення документів без розгляду, повідомлення про відмову у проведенні державної реєстрації та документи, що подавалися для проведення державної реєстрації фізичної особи &ndash; підприємця, відповідно до опису, видаються (надсилаються поштовим відправленням з описом вкладення) державним реєстратором заявнику.</p>\r\n\r\n<p>&nbsp;</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(89, 'Державна реєстрація юридичної особи\r\n', 1, 17, '<ol>\r\n	<li>Закон України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; (стаття 8, 10, 24, 24-1, 25, 27, 32, 35).</li>\r\n	<li>Постанова Кабінету Міністрів України від 19.12.2012&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; № 1212 &quot;Про затвердження Порядку ведення Реєстру громадських об&rsquo;єднань та обміну відомостями між зазначеним Реєстром і Єдиним державним реєстром юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n</ol>\r\n', '<p>Звернення засновника (засновників) новоствореної юридичної особи або уповноваженої ними особи.</p>\r\n', '<ul>\r\n	<li>Засновник (засновники) або уповноважена ними особа повинні (заявник) особисто подати державному реєстратору (надіслати поштовим відправленням з описом вкладення) за місцезнаходженням юридичної особи для проведення державної реєстрації юридичної особи.</li>\r\n	<li>У разі подання документів для проведення державної реєстрації юридичної особи, що створюється шляхом виділу документи подаються засновниками (учасниками) або уповноваженими ними органом чи особою.&nbsp;</li>\r\n</ul>\r\n', '<ol>\r\n	<li>Заповнена реєстраційна картка на проведення державної реєстрації юридичної особи (форма 1 або форма 2).</li>\r\n	<li>Примірник оригіналу (ксерокопія, нотаріально засвідчена копія) рішення засновників або уповноваженого ними органу про створення юридичної особи у випадках, передбачених законом.</li>\r\n	<li>Два примірники установчих документів.</li>\r\n	<li>У разі утворення юридичної особи на підставі модельного статуту в реєстраційній картці на проведення державної реєстрації юридичної особи проставляється відповідна відмітка з посиланням на типовий установчий документ.</li>\r\n	<li>Документ, що засвідчує внесення реєстраційного збору за проведення державної реєстрації юридичної особи.</li>\r\n	<li>Інформація з документами, що підтверджують структуру власності засновників &ndash; юридичних осіб, яка дає змогу встановити фізичних осіб &ndash; власників істотної участі цих юридичних осіб.&nbsp;</li>\r\n</ol>\r\n', 1, '<p>???</p>\r\n', '<p>За проведення державної реєстрації справляється реєстраційний збір у такому розмірі:</p>\r\n\r\n<ul>\r\n	<li>есять неоподатковуваних мінімумів доходів громадян &ndash; за проведення державної реєстрації юридичної особи&nbsp;&nbsp; (170 грн.);</li>\r\n	<li>&nbsp;три неоподатковуваних мінімумів доходів громадян &ndash; за проведення державної реєстрації благодійної організації (51 грн.).</li>\r\n</ul>\r\n\r\n<p>&nbsp;</p>\r\n', '<p>???</p>\r\n', '<p>Строк державної реєстрації юридичної особи не повинен перевищувати три робочих дні з дати надходження документів для проведення державної реєстрації юридичної особи.&nbsp;</p>\r\n', '<ol>\r\n	<li>Документи подані за неналежним місцем проведення державної реєстрації юридичної особи.</li>\r\n	<li>Документи не відповідають вимогам частин першої, другої, четвертої &ndash; сьомої статті 8 та частини п&#39;ятої статті 10 Закону України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n	<li>До державного реєстратора надійшло рішення суду щодо заборони у проведенні реєстраційних дій.&nbsp;</li>\r\n	<li>Документи подані не у повному обсязі.</li>\r\n	<li>Документи подано особою, яка не має на це повноважень.&nbsp;</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців та один примірник оригіналу установчих документів з відміткою державного реєстратора про проведення державної реєстрації юридичної особи.</li>\r\n	<li>Повідомлення про залишення документів без розгляду.</li>\r\n	<li>Повідомлення про відмову у проведенні державної реєстрації юридичної особи.</li>\r\n</ol>\r\n', '<p>Виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців, один примірник оригіналу установчих документів з відміткою державного реєстратора про проведення державної реєстрації юридичної особи, повідомлення про залишення документів, без розгляду, повідомлення про відмову у проведенні державної реєстрації, із зазначенням підстав для такої відмови, та документи, що подавалися для проведення державної реєстрації юридичної особи, відповідно до опису, видаються (надсилаються поштовим відправленням з описом вкладення) державним реєстратором заявнику.</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(90, 'Видача виписки з Єдиного державного реєстру юридичних осіб та фізичних осіб підприємців', 1, 17, '<p>Закон України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; (зі&nbsp; змінами&nbsp; та&nbsp; доповненнями) (статті 8, 20, 21).</p>\r\n', '<p>Запит юридичної особи або фізичної особи &ndash; підприємця</p>\r\n', '<p>Запит про надання виписки з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців подається юридичними або фізичними особами (їх уповноваженими представниками) особисто.</p>\r\n', '<ol>\r\n	<li>Запит про надання виписки з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</li>\r\n	<li>Документ, що підтверджує внесення плати за отримання відповідних відомостей (копія квитанції, виданої банком, або копія платіжного доручення з відміткою банку).</li>\r\n	<li>Документ, що посвідчує особу заявника, відповідно до підпункту 1 пункту 2 Положення про прикордонний режим, затвердженого постановою Кабінету Міністрів України від 27 липня 1998 року № 1147 (із змінами).</li>\r\n	<li>&nbsp;Документ, що підтверджує повноваження уповноваженої особи &ndash; у разі подання запиту уповноваженою особою.</li>\r\n</ol>\r\n', 1, '<p>???</p>\r\n', '<p>За одержання виписки з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців справляється плата в розмірі одного неоподатковуваного мінімуму доходів громадян (17 грн.).</p>\r\n', '<p>???</p>\r\n', '<p>Виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців або письмове повідомлення про відмову у наданні відомостей з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців видається (надсилається поштовим відправленням) протягом двох робочих днів з дати подання запиту про надання виписки з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</p>\r\n', '<ol>\r\n	<li>У Єдиному державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців є запис про відсутність юридичної особи за її місцезнаходженням.</li>\r\n	<li>У Єдиному державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців є запис про відсутність підтвердження відомостей про юридичну особу.</li>\r\n	<li>Запит подано особою, яка не підтвердила на це повноваження.</li>\r\n	<li>У запиті про надання виписки відсутні відомості для&nbsp; критеріїв пошуку відомостей у Єдиному державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців для формування виписки з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</li>\r\n	<li>Запитувачем не подано документ, що підтверджує внесення плати за отримання виписки, крім випадків, встановлених Законом України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;, або плата внесена не в повному обсязі.</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</li>\r\n	<li>Письмове повідомлення про відмову у наданні відомостей з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</li>\r\n</ol>\r\n', '<p>Державний реєстратор надає запитувачу (надсилає поштовим відправленням) виписку або направляє письмове повідомлення про відмову у наданні відомостей з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(91, 'Видача витягу з Єдиного державного реєстру юридичних осіб та фізичних осіб підприємців\r\n', 1, 17, '<p>Закон України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;&nbsp; (зі&nbsp; змінами&nbsp; та&nbsp; доповненнями) (статті 8, 20).</p>\r\n', '<p>Запит про надання витягу з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</p>\r\n', '<p>Особисто або поштовим відправленням з описом вкладення.</p>\r\n', '<ol>\r\n	<li>Запит про надання витягу з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</li>\r\n	<li>Запит про надання витягу з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців заповнюються українською мовою машинодруком або від руки розбірливими друкованими літерами, без виправлень.</li>\r\n	<li>Документ, що підтверджує внесення плати за отримання відповідних відомостей (копія квитанції, виданої банком, або копія платіжного доручення з відміткою банку).</li>\r\n</ol>\r\n', 1, '<p>???</p>\r\n', '<p>Три неоподатковувані мінімуми доходів громадян та за кожен аркуш інформації на бланку встановленого зразка справляється плата у розмірі 20 відсотків одного неоподаткованого мінімуму доходів громадян (51 грн. + 3,4 грн. за кожен аркуш інформації на бланку встановленого зразка).</p>\r\n', '<p>???</p>\r\n', '<p>Строк надання витягу з Єдиного державного реєстру не повинен перевищувати п&#39;яти робочих днів з дати надходження запиту про надання витягу з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</p>\r\n', '<ol>\r\n	<li>У запиті про надання витягу відсутні критерії пошуку відомостей у Єдиному державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців, які були зазначені у запиті про надання витягу на вибір запитувача для його формування.</li>\r\n	<li>Запитувачем не подано документ, що підтверджує внесення плати за отримання витягу, крім випадків, встановлених Законом України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;, або плата внесена не в повному обсязі.</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Витяг з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</li>\r\n	<li>Письмове повідомлення про відмову у наданні відомостей з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</li>\r\n</ol>\r\n', '<p>Державний реєстратор видає витяг з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців особі, яка подала запит, або, у разі проставлення відповідної відмітки у запиті, надсилає її поштовим відправленням.</p>\r\n', 'ні', 0, '', 0, '', '', '', '');
INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`) VALUES
(92, 'Видача довідки з Єдиного державного реєстру юридичних осіб та фізичних осіб  підприємців.\r\n', 1, 17, '<p>Закон України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; (статті 8, 20).</p>\r\n', '<p>Запит про надання довідки про наявність або відсутність в Єдиному державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців інформації, яка запитується.</p>\r\n', '<p>Особисто або поштовим відправленням з описом вкладення.&nbsp;</p>\r\n', '<ol>\r\n	<li>Запит про надання довідки про наявність або відсутність в Єдиному державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців інформації, яка запитується.</li>\r\n	<li>Запит про надання довідки про наявність або відсутність в Єдиному державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців інформації, яка запитується заповнюються українською мовою машинодруком або від руки розбірливими друкованими літерами, без виправлень.</li>\r\n	<li>Документ, що підтверджує внесення плати за отримання відповідних відомостей (копія квитанції, виданої банком, або копія платіжного доручення з відміткою банку).</li>\r\n</ol>\r\n', 1, '<p>???</p>\r\n', '<p>Один неоподатковуваний мінімум доходів громадян (17 грн.).</p>\r\n', '<p>???</p>\r\n', '<p>Строк надання довідки про наявність або відсутність в Єдиному державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців інформації, яка запитується не повинен перевищувати п&#39;яти робочих днів з дати надходження запиту про надання довідки про наявність або відсутність в Єдиному державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців інформації, яка запитується.</p>\r\n', '<ol>\r\n	<li>У запиті про надання довідки відсутні критерії пошуку відомостей у Єдиному державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців, які були зазначені у запиті про надання довідки про наявність або відсутність в Єдиному державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців інформації, яка запитується.</li>\r\n	<li>Запитувачем не подано документ, що підтверджує внесення плати за отримання довідки, крім випадків, встановлених Законом України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;, або плата внесена не в повному обсязі.</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Довідка про наявність або відсутність в Єдиному державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців інформації, яка запитується.</li>\r\n	<li>Письмове повідомлення про відмову у наданні відомостей з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</li>\r\n</ol>\r\n', '<p>Державний реєстратор видає довідку про наявність або відсутність в Єдиному державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців інформації, яка запитується особі, яка подала запит, або, у разі проставлення відповідної відмітки у запиті, надсилає її поштовим відправленням.</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(93, 'Державна реєстрація змін до установчих документів юридичної особи\r\n', 1, 17, '<p>Закон України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; (зі&nbsp; змінами &nbsp;та&nbsp; доповненнями)&nbsp;(статті 8, 10, 29, 30).</p>\r\n', '<p>Звернення юридичної особи у зв&rsquo;язку із прийняттям рішення про внесення змін до установчих&nbsp; документів юридичної особи.</p>\r\n', '<p>Документи подаються (надсилаються поштовим відправленням з описом вкладення) юридичною&nbsp; особою.</p>\r\n', '<ol>\r\n	<li>Заповнена реєстраційна картка на проведення державної реєстрації змін до установчих документів юридичної особи (форма 3).</li>\r\n	<li>Примірник оригіналу (ксерокопія, нотаріально засвідчена копія) рішення про внесення змін до установчих документів. Документ, що підтверджує&nbsp; правомочність прийняття рішення&nbsp; про внесення&nbsp; змін&nbsp; до&nbsp; установчих документів.</li>\r\n	<li>Оригінали установчих документів юридичної особи з відміткою про їх державну реєстрацію з усіма змінами, чинними на дату подачі документів, або копія опублікованого в спеціалізованому друкованому засобі масової інформації повідомлення про втрату всіх або частини зазначених оригіналів установчих документів.</li>\r\n	<li>Два примірники змін до установчих документів юридичної особи у вигляді окремих додатків або два примірники установчих документів у новій редакції.</li>\r\n	<li>Документ, що підтверджує внесення реєстраційного збору за проведення державної реєстрації змін до установчих документів, якщо інше не&nbsp; встановлено Законом України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.&nbsp;</li>\r\n</ol>\r\n', 1, '<p>???</p>\r\n', '<p>Справляється реєстраційний збір у розмірі тридцяти відсотків від реєстраційного збору за проведення державної реєстрації юридичної особи (51 грн.).</p>\r\n\r\n<p>&nbsp;</p>\r\n', '<p>???</p>\r\n', '<p>Строк державної реєстрації змін до установчих документів юридичної особи не повинен перевищувати три робочих дні з дати надходження документів.</p>\r\n', '<ol>\r\n	<li>Документи подані за неналежним місцем проведення державної реєстрації.</li>\r\n	<li>Документи не відповідають вимогам, які встановлені частинами першою, другою, четвертою, п&#39;ятою та сьомою статті 8, частиною п&#39;ятою&nbsp; статті 10 Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n	<li>Документи подані не у повному обсязі.</li>\r\n	<li>Документи подано особою, яка не має на&nbsp; це повноважень.</li>\r\n	<li>До державного реєстратора надійшло рішення суду щодо заборони у&nbsp; проведенні&nbsp; реєстраційних дій.&nbsp;&nbsp;</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Повідомлення про залишення документів без розгляду.</li>\r\n	<li>Повідомлення про відмову в проведенні державної реєстрації змін до установчих документів юридичної особи.</li>\r\n	<li>Один примірник змін до установчих документів юридичної особи у вигляді окремих додатків або один примірник оригіналу установчих документів у новій редакції та один примірник оригіналу установчих документів у старій редакції з відмітками державного реєстратора про проведення державної реєстрації змін до установчих документів.</li>\r\n	<li>Виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб-підприємців<em> &ndash;</em> у разі внесенні змін до установчих документів, які пов&rsquo;язані із зміною відомостей про юридичну особу, які відповідно&nbsp; до&nbsp; Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; зазначаються у виписці з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</li>\r\n</ol>\r\n', '<p>Повідомлення про залишення документів без розгляду/ повідомлення про відмову в проведенні державної реєстрації змін до установчих документів юридичної особи разом з документами, що подавалися для проведення державної змін до установчих документів юридичної особи або один примірник оригіналу установчих документів у старій редакції з відмітками державного реєстратора про проведення державної реєстрації змін до установчих документів та виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб-підприємців (у разі видачі) видаються (надсилаються поштовим відправленням з описом вкладення) державним реєстратором заявнику.</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(94, 'Включення до Єдиного державного реєстру юридичних осіб та фізичних осіб-підприємців відомостей про закриття відокремленого підрозділу юридичної особи', 1, 17, '<p>Закон України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; (із&nbsp; змінами&nbsp; та&nbsp; доповненнями) &nbsp;(статті 8, 28).</p>\r\n', '<p>Звернення юридичної особи у зв&rsquo;язку із закриттям відокремленого підрозділу.</p>\r\n', '<p>Документи подаються (надсилаються поштовим відправленням з описом вкладення) виконавчим органом юридичної особи або уповноваженою ним особою.</p>\r\n', '<ol>\r\n	<li>Повідомлення встановленого зразка про закриття відокремленого підрозділу.</li>\r\n	<li>Якщо документи подаються особою, уповноваженою&nbsp;&nbsp; виконавчим органом юридичної особи додатково пред&#39;являються паспорт громадянина України або паспортний документ іноземця та документ, що засвідчує її повноваження.</li>\r\n</ol>\r\n\r\n<p>&nbsp;</p>\r\n', 0, '', '', '', '<p>Включення до Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців відомостей про закриття відокремленого підрозділу юридичної особи здійснюється протягом двох робочих днів з дати надходження документів.</p>\r\n', '<ol>\r\n	<li>Документи подані за неналежним місцем проведення реєстраційних дій.</li>\r\n	<li>Документи не відповідають вимогам, які встановлені частиною першою статті 8 Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Повідомлення про залишення документів без розгляду.</li>\r\n	<li>Виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</li>\r\n</ol>\r\n', '<p>Повідомлення про залишення документів без розгляду разом з документами, що подавалися для включення до Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців відомостей про створення відокремленого підрозділу юридичної особи або виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців видаються (надсилаються поштовим відправленням з описом вкладення) державним реєстратором заявнику.</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(95, 'Включення до Єдиного державного реєстру юридичних осіб та фізичних осіб-підприємців відомостей про створення відокремленого підрозділу юридичної особи\r\n', 1, 17, '<p>Закон України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; (зі змінами&nbsp; та&nbsp; доповненнями)&nbsp;(статті 8, 28).</p>\r\n', '<p>Звернення юридичної особи у зв&rsquo;язку із рішенням органу управління юридичної особи про створення відокремленого підрозділу.&nbsp;</p>\r\n', '<p>Документи подаються (надсилаються поштовим відправленням з описом вкладення) виконавчим органом юридичної особи або уповноваженою ним особою.</p>\r\n', '<ol>\r\n	<li>Заповнена реєстраційна картка про створення відокремленого&nbsp; підрозділу (форма 5).</li>\r\n	<li>Рішення органу управління юридичної&nbsp;особи&nbsp; про&nbsp; створення&nbsp; відокремленого&nbsp; підрозділу.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Включення до Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців відомостей про створення відокремленого підрозділу юридичної особи &ndash; протягом двох робочих днів з дати надходження документів.</p>\r\n', '<ol>\r\n	<li>Документи подані за неналежним місцем проведення реєстраційних дій.</li>\r\n	<li>Реєстраційна картка не відповідає вимогам&nbsp; частин&nbsp; першої, другої та сьомої статті 8 Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.&nbsp;</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Повідомлення про залишення документів без розгляду.</li>\r\n	<li>Виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</li>\r\n</ol>\r\n', '<p>Повідомлення про залишення документів без розгляду разом з документами, що подавалися для включення до Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців відомостей про створення відокремленого підрозділу юридичної особи або виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців видаються (надсилаються поштовим відправленням з описом вкладення) державним реєстратором заявнику.</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(96, 'Державна реєстрація змін до відомостей про фізичну особу-підприємця, які містяться в Єдиному державному реєстрі юридичних осіб та&nbsp;фізичних осіб-підприємців', 1, 17, '<p>Закон України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; (зі&nbsp; змінами&nbsp; та&nbsp; доповненнями)&nbsp;&nbsp;(статті 8, 10, 43, 44, 45).</p>\r\n', '<p>Звернення фізичної особи &ndash; підприємця.</p>\r\n', '<ol>\r\n	<li>Особисто, поштовим відправленням з описом вкладення або через уповноважену особу &ndash; у разі подання документів фізичної особи &ndash; підприємця, яка має реєстраційний номер облікової картки платника податків.</li>\r\n	<li>Особисто &ndash; у разі подання документів фізичної особи &ndash; підприємця, яка через свої релігійні або інші переконання відмовилася від прийняття реєстраційного номера облікової картки платника податків, офіційно повідомила про це відповідні державні органи, має запис в електронному безконтактному носії паспорта громадянина України та намір стати підприємцем.</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Заповнена реєстраційна картка на проведення державної реєстрації змін до відомостей про фізичну особу &ndash; підприємця (форма 11).</li>\r\n	<li>Документ, що підтверджує сплату реєстраційного збору за державну реєстрацію змін до відомостей про фізичну особу &ndash; підприємця.</li>\r\n	<li>Копія довідки про зміну реєстраційного номера облікової картки платника податків.&nbsp;&nbsp;</li>\r\n</ol>\r\n', 1, '<p>???</p>\r\n', '<p>За проведення державної реєстрації зміни імені або місця проживання фізичної особи &ndash; підприємця справляється реєстраційний збір у розмірі тридцяти відсотків реєстраційного збору, встановленого за проведення державної реєстрації фізичної особи &ndash; підприємця &nbsp;(10,20 грн.).</p>\r\n', '<p>???</p>\r\n', '<p>Строк державної реєстрації змін до відомостей про фізичну особу &ndash; підприємця не повинен перевищувати два робочих дні з дати надходження документів для проведення державної реєстрації фізичної особи &ndash; підприємця.</p>\r\n', '<ol>\r\n	<li>Документи подані за неналежним місцем проведення державної реєстрації змін до відомостей про фізичну особу &ndash; підприємця.</li>\r\n	<li>Документи не відповідають вимогам частин першої та другої статті 8 та частини п&#39;ятої статті 10 Закону України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n	<li>Документи подані не у повному обсязі.</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</li>\r\n	<li>Повідомлення про залишення без розгляду документів.</li>\r\n	<li>Повідомлення про відмову у проведенні державної реєстрації змін до відомостей про фізичну особу &ndash; підприємця.</li>\r\n</ol>\r\n', '<p>Виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців, повідомлення про залишення документів без розгляду, повідомлення про відмову у проведенні державної реєстрації змін до відомостей про фізичну особу &ndash; підприємця та документи, що подавалися для проведення державної реєстрації змін до відомостей про фізичну особу &ndash; підприємця, відповідно до опису, видаються (надсилаються поштовим відправленням з описом вкладення) державним реєстратором заявнику.</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(97, 'Видача юридичним особам дублікатів оригіналів їх установчих документів та змін до них\r\n', 1, 17, '<p>Закон України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; (зі&nbsp; змінами&nbsp; та&nbsp; доповненнями)&nbsp;(статті ч.1 ст.6, ч.3 ст.10).</p>\r\n', '<p>Звернення юридичної особи.</p>\r\n', '<p>Документи подаються засновниками (учасниками) юридичної особи або уповноваженим ними органом чи особою.</p>\r\n', '<ol>\r\n	<li>Заява&nbsp; про&nbsp; про видачу дубліката у довільній формі.</li>\r\n	<li>Документ, що підтверджує внесення плати за&nbsp; публікацію&nbsp; у спеціальному&nbsp; друкованому&nbsp; засобі&nbsp; масової інформації повідомлення про втрату оригіналів установчих документів (копія&nbsp; квитанції або копія платіжного доручення з відміткою банку).</li>\r\n	<li>Документ, що підтверджує внесення реєстраційного збору за видачу дубліката установчих документів та змін до них</li>\r\n</ol>\r\n', 1, '<p>???</p>\r\n', '<p>Справляється реєстраційний збір у розмірі одного неоподаткованого мінімуму доходів громадян (17 грн).</p>\r\n', '<p>???</p>\r\n', '<p>???</p>\r\n', '<ol>\r\n	<li>Заява оформлена з порушенням вимог,&nbsp; встановлених&nbsp; частинами&nbsp; першою та другою статті 8 Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n	<li>Документи подані не в повному обсязі.</li>\r\n	<li>До державного реєстратора надійшло рішення суду щодо заборони проведення реєстраційних дій.</li>\r\n	<li>Документи подані за неналежним місцем реєстрації.</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Повідомлення про залишення заяви про видачу дублікату &nbsp;установчих документів без розгляду.</li>\r\n	<li>Видача дублікату установчих документів юридичної особи та змін до них.</li>\r\n</ol>\r\n', '<p>Дублікат установчих документів юридичної особи та змін до них або повідомлення про залишення заяви про видачу дублікату установчих документів без розгляду видається (надсилається поштовим відправленням з описом вкладення) державним реєстратором заявнику.&nbsp;</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(98, 'Державна реєстрація припинення юридичної особи в результаті злиття,&nbsp; приєднання, поділу або перетворення\r\n', 1, 17, '<p>Закон України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; (зі&nbsp; змінами&nbsp; та&nbsp; доповненнями)&nbsp;(статті 8, 37).</p>\r\n', '<p>Звернення юридичної особи у зв&rsquo;язку із закінченням строку заявлення вимог кредиторами та процедури припинення юридичної особи.</p>\r\n', '<p>Документи подаються (надсилаються поштовим&nbsp; відправленням з описом вкладення) головою комісії з&nbsp; припинення&nbsp; або&nbsp; уповноваженою&nbsp; нею&nbsp; особою.</p>\r\n', '<ol>\r\n	<li>Заповнена реєстраційна картка на проведення державної реєстрації припинення юридичної особи в&nbsp; результаті&nbsp; злиття, приєднання, поділу або перетворення .</li>\r\n	<li>Підписаний головою і членами комісії з припинення&nbsp; юридичної особи та затверджений засновниками (учасниками) юридичної особи або органом,&nbsp; який прийняв рішення про припинення юридичної особи, примірник оригіналу передавального акта, якщо припинення здійснюється в результаті злиття,&nbsp; приєднання або перетворення, чи розподільчого&nbsp; балансу,&nbsp; якщо припинення здійснюється в результаті поділу, або їх нотаріально засвідчені копії.</li>\r\n	<li>Довідка архівної установи про прийняття документів, які відповідно до закону підлягають довгостроковому зберіганню*.</li>\r\n	<li>Документ про узгодження плану реорганізації&nbsp; з&nbsp; органом державної податкової служби (за наявності податкового боргу)*.</li>\r\n	<li>Довідка відповідного органу державної податкової&nbsp; служби про відсутність заборгованості із сплати податків, зборів*.</li>\r\n	<li>Довідка відповідного органу Пенсійного фонду України про відсутність заборгованості із сплати єдиного внеску на загальнообов&#39;язкове державне соціальне страхування та страхових коштів до Пенсійного фонду України і фондів соціального страхування*.&nbsp;</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Строк&nbsp; державної реєстрації припинення юридичної особи в результаті злиття,&nbsp; приєднання, поділу або перетворення не повинен перевищувати одного робочого дня з дати надходження документів.</p>\r\n\r\n<p>&nbsp;</p>\r\n', '<ol>\r\n	<li>Документи подані за неналежним місцем проведення державної реєстрації.</li>\r\n	<li>Документи подані не у повному обсязі.</li>\r\n	<li>Документи не відповідають вимогам, які встановлені частинами першою та другою статті 8 Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n	<li>Передавальний акт&nbsp; або&nbsp; розподільчий&nbsp; баланс&nbsp; не відповідає вимогам, які встановлені частиною четвертою&nbsp; статті 37 Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n	<li>Документи подані раніше строку, встановленого абзацом першим частини першої статті 37 Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n	<li>В Єдиному державному реєстрі юридичних осіб та фізичних осіб-підприємців щодо юридичної особи, що припиняється, містяться відомості про те, що вона є учасником (власником) інших юридичних осіб та/або&nbsp;&nbsp; має&nbsp; не&nbsp; закриті відокремлені підрозділи.</li>\r\n	<li>Не скасовано реєстрацію всіх випусків акцій, якщо&nbsp; юридична особа, що припиняється, є акціонерним&nbsp; товариством.&nbsp;</li>\r\n	<li>Від органів державної податкової служби та/або Пенсійного фонду України надійшло повідомлення про наявність заперечень проти проведення державної&nbsp; реєстрації припинення&nbsp; юридичної особи в результаті злиття, приєднання, поділу або перетворення, і воно не відкликане.&nbsp;</li>\r\n	<li>&nbsp;Не зазначені та&nbsp; не підтверджені&nbsp; особистим підписом голови комісії з припинення або уповноваженою ним особою відомості, передбачені частиною другою статті 37 Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.&nbsp;</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Повідомлення про залишення документів без розгляду.</li>\r\n	<li>Повідомлення про проведення&nbsp; державної реєстрації припинення юридичної особи в результаті злиття,&nbsp; приєднання, поділу або перетворення.&nbsp;</li>\r\n</ol>\r\n', '<p>Повідомлення про залишення документів без розгляду разом з документами, що подавалися для проведення державної реєстрації припинення юридичної особи в результаті злиття, приєднання, поділу або перетворення або повідомлення про проведення&nbsp; державної реєстрації припинення юридичної особи в результаті злиття,&nbsp; приєднання, поділу або перетворення видаються (надсилаються поштовим відправленням з описом вкладення) державним реєстратором заявнику.</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(99, 'Державна реєстрація припинення юридичної особи в результаті її ліквідації\r\n', 1, 17, '<p>Закон України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; (зі&nbsp; змінами&nbsp; та&nbsp; доповненнями)&nbsp;(статті 8, 36).</p>\r\n', '<p>Звернення юридичної особи у зв&rsquo;язку із закінченням строку заявлення вимог кредиторами та процедури ліквідації юридичної особи.</p>\r\n', '<p>Документи подаються (надсилаються поштовим&nbsp; відправленням з описом вкладення) головою&nbsp; ліквідаційної комісії, уповноваженою&nbsp; ним&nbsp; особою або ліквідатором.</p>\r\n', '<ol>\r\n	<li>Заповнена реєстраційна картка на проведення державної реєстрації припинення юридичної особи у зв&#39;язку з ліквідацією (форма 7).</li>\r\n	<li>Довідка відповідного органу державної податкової&nbsp; служби про відсутність заборгованості із сплати податків, зборів.</li>\r\n	<li>Довідка відповідного органу Пенсійного фонду України про відсутність заборгованості із сплати єдиного внеску на загальнообов&#39;язкове державне соціальне страхування та страхових коштів до Пенсійного фонду України і фондів соціального страхування.</li>\r\n	<li>Довідка архівної установи про прийняття документів, які відповідно до закону підлягають довгостроковому зберіганню.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Строк&nbsp; державної реєстрації припинення юридичної особи в результаті її ліквідації не повинен перевищувати одного робочого дня з дати надходження документів.&nbsp;</p>\r\n', '<ol>\r\n	<li>Документи подані&nbsp; за&nbsp; неналежним&nbsp; місцем проведення державної реєстрації.</li>\r\n	<li>Документи не відповідають вимогам,&nbsp; які встановлені частинами першою та другою статті 8 Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n	<li>Документи подані не у повному обсязі.</li>\r\n	<li>Документи подані раніше строку, встановленого абзацом першим частини першої статті 36 Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n	<li>В Єдиному&nbsp; державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців щодо&nbsp; юридичної&nbsp; особи,&nbsp; що припиняється, містяться відомості&nbsp; про&nbsp; те,&nbsp; що вона є учасником (власником) інших юридичних осіб&nbsp;&nbsp; та/або&nbsp;&nbsp; має&nbsp; не&nbsp; закриті відокремлені&nbsp; підрозділи.&nbsp;</li>\r\n	<li>Не скасовано реєстрацію всіх випусків акцій, якщо&nbsp; юридична особа, що припиняється, є акціонерним&nbsp; товариством.&nbsp;</li>\r\n	<li>Від органів державної&nbsp; податкової служби&nbsp; та/або Пенсійного фонду України надійшло повідомлення про наявність заперечень проти проведення державної&nbsp; реєстрації&nbsp; припинення&nbsp; юридичної&nbsp; особи&nbsp; в результаті&nbsp;&nbsp; її&nbsp; ліквідації,&nbsp; і&nbsp; воно&nbsp; не&nbsp; відкликане.&nbsp;</li>\r\n	<li>Не зазначено та не&nbsp; підтверджено&nbsp; особистим&nbsp; підписом&nbsp; голови ліквідаційної комісії, ліквідатора або&nbsp; уповноваженої&nbsp; особи відомості, передбачені частиною&nbsp; другою статті 36 Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.&nbsp;</li>\r\n	<li>Стосовно юридичної особи відкрито виконавче&nbsp; провадження.</li>\r\n	<li>Стосовно юридичної особи відкрито провадження у справі про банкрутство&nbsp; юридичної особи.&nbsp;</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Повідомлення про залишення документів без розгляду.</li>\r\n	<li>Повідомлення про проведення&nbsp; державної реєстрації припинення юридичної особи в результаті її ліквідації.&nbsp;</li>\r\n</ol>\r\n', '<p>Повідомлення про залишення документів без розгляду разом з документами, що подавалися для проведення державної реєстрації припинення юридичної особи в результаті її ліквідації або повідомлення про проведення&nbsp; державної реєстрації припинення юридичної особи в результаті її ліквідації видаються (надсилаються поштовим відправленням з описом вкладення) державним реєстратором заявнику.</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(100, 'Державна реєстрація припинення підприємницької діяльності фізичної особи-підприємця за її рішенням\r\n', 1, 17, '<p>Закон України від 15.05.2003 № 755-ІV &laquo;Про державну реєстрацію юридичних осіб та фізичних осіб-підприємців&raquo; (статті 8, 47)</p>\r\n', '<p>Звернення фізичної особи-підприємця або уповноваженою нею особою.&nbsp;</p>\r\n', '<p>Особисто, поштовим відправленням з описом вкладення або через уповноважену особу.</p>\r\n', '<p>Заповнена реєстраційна картка на проведення&nbsp; державної&nbsp; реєстрації&nbsp; припинення підприємницької діяльності&nbsp; фізичною особою &ndash;підприємцем за її рішенням.</p>\r\n', 0, '', '', '', '<p>Внесення до Єдиного державного реєстру юридичних осіб та фізичних осіб-підприємців запису про проведення держаної реєстрації припинення підприємницької діяльності фізичною особою-підприємцем здійснюється держаним реєстратором не пізніше наступного робочого дня з дати надходження реєстраційної картки на проведення державної реєстрації припинення підприємницької діяльності фізичною особою-підприємцем за її рішенням та в той же день видається (надсилається поштовим відправленням з описом вкладення) їй повідомлення про проведення такого запису.</p>\r\n', '<ol>\r\n	<li>Документи подані за неналежним місцем проведення держаної реєстрації.</li>\r\n	<li>Документи не&nbsp; відповідають вимогам, встановленим&nbsp; частиною першою або абзацом першим частини другої статті 8 Закон України від 15.05.2003 № 755-ІV &laquo;Про державну реєстрацію юридичних осіб та фізичних осіб-підприємців&raquo;.</li>\r\n</ol>\r\n', '<p>Повідомлення про внесення до Єдиного державного реєстру юридичних осіб та фізичних осіб-підприємців запису про проведення держаної реєстрації припинення підприємницької діяльності фізичною особою-підприємцем, повідомлення із зазначенням підстав залишення реєстраційної картки на проведення державної реєстрації припинення підприємницької діяльності фізичною особою-підприємцем за її рішенням без розгляду разом із реєстраційною карткою, що подавалася для проведення держаної реєстрації припинення підприємницької діяльності фізичною особою-підприємцем за її рішенням, відповідно до опису, видаються (надсилається поштовим відправленням з описом вкладення) державним реєстратором заявнику.</p>\r\n', '<p>???</p>\r\n', 'ні', 0, '', 0, '', '', '', '');
INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`) VALUES
(101, 'Видача свідоцтва про реєстрацію громадської організації\r\n', 1, 18, '<ol>\r\n	<li>Закон України &laquo;Про громадські об&rsquo;єднання&raquo; від 22.03.2012 р. №4572-VI.&nbsp;&nbsp;</li>\r\n	<li>Постанова Кабінету Міністрів України від 26 грудня 2012р.№1193 &laquo;Про затвердження зразків свідоцтв&nbsp;про реєстрацію громадського об&#39;єднання як громадської організації чи громадської спілки та про&nbsp;акредитацію відокремленого підрозділу іноземної неурядової організації&raquo;.</li>\r\n	<li>Наказ Міністерства юстиції України від 14.12.2012 №1745/5 &laquo;Про порядок підготовки та оформлення&nbsp;рішень щодо громадських об&#39;єднань&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>&nbsp;Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява.</li>\r\n	<li>Статут (у двох примірниках).</li>\r\n	<li>Протокол установчих зборів громадської організації, оформленого з дотриманням вимог частин другої,&nbsp;&nbsp;п&rsquo;ятої, сьомої статті 9&nbsp; &nbsp;&nbsp;Закону України &laquo;Про громадські об&rsquo;єднання&raquo; від 22.03.2012 р. №4572-VI.&nbsp;&nbsp;&nbsp;</li>\r\n	<li>Реєстр осіб, які брали участь в зборах.</li>\r\n	<li>Відомості про склад керівних органів громадської організації.</li>\r\n	<li>Відомості про особу, яка має право представляти громадську організацію для здійснення реєстраційних дій.</li>\r\n	<li>Письмова особиста згода керівника на зайняття відповідної посади відповідно до частини 6 статті 9 Закону.</li>\r\n	<li>Письмова особиста згода осіб, які&nbsp; мають право представляти Організацію для здійснення реєстраційних дій відповідно до частини 6 статті 9 Закону.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>7 робочих днів з дня надходження письмової заяви та документів.<br />\r\n&nbsp;</p>\r\n', '<p>---</p>\r\n', '<p>Видача свідоцтва про реєстрацію громадської організації.</p>\r\n', '<p>Особисто або&nbsp;уповноваженою особою в &nbsp;Центрі надання адміністративних послуг.</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(102, 'Прийняття повідомлення про утворення громадського об''єднання', 1, 18, '<ol>\r\n	<li>Закон України &laquo;Про громадські об&rsquo;єднання&raquo; від 22.03.2012 р. №4572-VI.&nbsp;&nbsp;</li>\r\n	<li>Постанова Кабінету Міністрів України від 26 грудня 2012р.№1193 &laquo;Про затвердження зразків свідоцтв&nbsp;про реєстрацію громадського об&#39;єднання як громадської організації чи громадської спілки та про&nbsp;акредитацію відокремленого підрозділу іноземної неурядової організації&raquo;.</li>\r\n	<li>Наказ Міністерства юстиції України від 14.12.2012 №1745/5 &laquo;Про порядок підготовки та оформлення&nbsp;рішень щодо громадських об&#39;єднань&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>???</p>\r\n', '<ol>\r\n	<li>Заява(підписується засновниками громадського об&rsquo;єднання або особою(особами), уповноваженою представляти громадське об&rsquo;єднання, а справжність їх підписів засвідчується нотаріально).</li>\r\n	<li>Примірник оригіналу або нотаріально засвідчена копія протоколу установчих зборів, оформленого з&nbsp;дотриманням вимог частини другої, четвертої та восьмої статті 9&nbsp; цього&nbsp; Закону.</li>\r\n	<li>Відомості про засновників &nbsp;громадського об&rsquo;єднання &nbsp;із зазначенням прізвища, ім&rsquo;я по батькові&nbsp;(за наявності), дати народження, адреси місця проживання,а в разі якщо засновником є юридична особа&nbsp;приватного права &ndash; її найменування, місцезнаходження, &nbsp;ідентифікаційного коду.</li>\r\n	<li>Відомості про особу (осіб), уповноважену представляти громадське об&rsquo;єднання із зазначенням&nbsp;прізвища, ім&rsquo;я по батькові (за наявності), дати народження, контактного номера телефону та інших&nbsp;засобів зв&rsquo;язку, до яких додається&nbsp; письмова згода цієї особи, передбачена частиною шостою&nbsp;статті 9 цього Закону.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>5 робочих днів з дня надходження письмової заяви та документів.<br />\r\n&nbsp;</p>\r\n', '<pre>\r\n\r\n\r\n&nbsp;</pre>\r\n\r\n<pre>\r\n???</pre>\r\n', '<p>Видача письмового повідомлення &nbsp;про утворення громадської організації.</p>\r\n', '<p>Особисто, уповноваженою особою в Центрі надання адміністративних послуг.</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(103, 'Видача&nbsp;дубліката свідоцтва про реєстрацію громадської організації\r\n', 1, 18, '<ol>\r\n	<li>Закон України &laquo;Про громадські об&rsquo;єднання&raquo; від 22.03.2012 р. №4572-VI.&nbsp;&nbsp;</li>\r\n	<li>Закон України &laquo;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&raquo;&nbsp;&nbsp;від 15.05.2003р. №755-IV.&nbsp;&nbsp;&nbsp;</li>\r\n	<li>Наказ Міністерства юстиції України від 14.12.2012 №1745/5 &laquo;Про порядок підготовки та оформлення&nbsp;рішень щодо громадських об&#39;єднань&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Особисто або&nbsp;уповноваженою особою.</p>\r\n', '<ol>\r\n	<li>Заява.</li>\r\n	<li>Документ, що підтверджує внесення плати за публікацію повідомлення у спеціальному друкованому засобі масової&nbsp; інформації повідомлення про втрату оригіналу свідоцтва про реєстрацію або статуту.</li>\r\n	<li>Довідка, видана органом внутрішніх справ про реєстрацію заяви про втрату оригіналу свідоцтва про реєстрацію або статуту.&nbsp;&nbsp;&nbsp; &nbsp;</li>\r\n</ol>\r\n', 0, '', '', '', '<p>3 &nbsp;дні з дня надходження письмової заяви та документів.<br />\r\n&nbsp;</p>\r\n', '<p>---</p>\r\n', '<p>Видача дубліката свідоцтва про реєстрацію громадської організації.</p>\r\n', '<p>Особисто або&nbsp; уповноваженою особою.</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(104, 'Внесення до реєстру громадських&nbsp;об&rsquo;єднань відомостей про відокремлений підрозділ громадського об&rsquo;єднання\r\n', 1, 18, '<ol>\r\n	<li>Закон України &laquo;Про громадські об&rsquo;єднання&raquo; від 22.03.2012 р. №4572-VI.&nbsp;&nbsp;</li>\r\n	<li>Наказ Міністерства юстиції України від 14.12.2012 №1745/5 &laquo;Про порядок підготовки та оформлення&nbsp;рішень щодо громадських об&#39;єднань&raquo;.</li>\r\n	<li>Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; від 15.05.2003 № 755-IV.&nbsp;</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Особисто або&nbsp; уповноваженою особою.</p>\r\n', '<ol>\r\n	<li>Заява.</li>\r\n	<li>Рішення керівного органу &nbsp;громадського об&rsquo;єднання &nbsp;про створення&nbsp; відокремленого&nbsp; підрозділу.</li>\r\n	<li>Реєстраційна картка&nbsp; форми №5 про створення відокремленого підрозділу, яка повинна містити такі дані:</li>\r\n</ol>\r\n\r\n<ul>\r\n	<li>ідентифікаційний код громадського об&rsquo;єднання як юридичної особи;</li>\r\n	<li>повне найменування відокремленого підрозділу;</li>\r\n	<li>місцезнаходження відокремленого підрозділу;</li>\r\n	<li>прізвище, ім&rsquo;я та по батькові керівника відокремленого підрозділу, його реєстраційний номер&nbsp;облікової картки платника податку;</li>\r\n	<li>місцезнаходження реєстраційної справи громадського об&rsquo;єднання.</li>\r\n</ul>\r\n', 0, '', '', '', '<p>3 робочих дня з дня надходження письмової заяви та документів.</p>\r\n', '<p>---</p>\r\n', '<p>Внесення до Реєстру &nbsp;громадських об&rsquo;єднань відомостей про відокремлений підрозділ.</p>\r\n', '<p>Особисто, &nbsp;уповноваженою особою, рекомендованим листом з повідомленням про вручення.</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(105, 'Прийняття&nbsp;повідомлення про зміни до статуту громадського об&rsquo;єднання, зміни у складі керівних органів громадського об&rsquo;єднання, зміну місцезнаходження зареєстрованого громадського об&rsquo;єднання\r\n', 18, 18, '<ol>\r\n	<li>Закон України &laquo;Про громадські об&rsquo;єднання&raquo; від 22.03.2012 р. №4572-VI.&nbsp;&nbsp;</li>\r\n	<li>Закон України &laquo;Про державну реєстрацію юридичних осіб та фізичних осіб-підприємців&raquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 26 грудня 2012р.№1193 &laquo;Про затвердження зразків свідоцтв&nbsp;про реєстрацію громадського об&#39;єднання як громадської організації чи громадської спілки та про&nbsp;акредитацію відокремленого підрозділу іноземної неурядової організації&raquo;.</li>\r\n	<li>Наказ Міністерства юстиції України від 14.12.2012 №1745/5 &laquo;Про порядок підготовки та оформлення&nbsp;рішень щодо громадських об&#39;єднань&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Особисто або&nbsp; уповноваженою особою.</p>\r\n', '<ol>\r\n	<li>Заява.</li>\r\n	<li>Заповнена відповідна реєстраційна картка.</li>\r\n	<li>Оригінал статуту та свідоцтва громадського об&rsquo;єднання.</li>\r\n	<li>Статут в новій редакції (у двох прим.)</li>\r\n	<li>Протокол вищого органу управління громадського об&rsquo;єднання про відповідні зміни, оформленого з дотриманням вимог частини другої статті 9 Закону України &laquo;Про громадські об&rsquo;єднання&raquo; від 22.03.2012р№4572-VI.</li>\r\n	<li>Реєстр осіб, які брали участь в зборах.</li>\r\n	<li>Протокол керівного органу &nbsp;громадського об&rsquo;єднання, на якому відповідно до статуту було скликано засідання вищого органу управління.</li>\r\n	<li>Відомості про склад керівних органів громадської організації.</li>\r\n	<li>Відомості про особу, яка має право представляти громадську організацію для здійснення реєстраційних дій.</li>\r\n	<li>Письмова особиста згода керівника на зайняття відповідної&nbsp; посади відповідно до частини 9 статті 9 Закону.</li>\r\n	<li>Письмова особиста згода осіб, які мають право представляти Організацію для здійснення реєстраційних дій відповідно до частини 6 статті 9 Закону.&nbsp;</li>\r\n</ol>\r\n', 1, '<p>Відповідно до ч.16 ст. 14 Закону за прийняття повідомлення про зміни до статуту громадського об&rsquo;єднання.</p>\r\n', '<p>Справляється плата у розмірі 51 грн.</p>\r\n', '<p>???</p>\r\n', '<p>5 днів з дня надходження письмової заяви та документів.<br />\r\n&nbsp;</p>\r\n', '<p>---</p>\r\n', '<p>Видача свідоцтва, &nbsp;повідомлення та статуту &nbsp;з відповідними змінами &nbsp;громадської організації.</p>\r\n', '<p>Особисто або&nbsp; уповноваженою особою.</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(106, 'Прийняття&nbsp;повідомлення про зміну &nbsp;найменування &nbsp;громадського об&rsquo;єднання, мети(цілей), зміну особи (осіб), уповноваженої представляти громадське об&rsquo;єднання, утворене шляхом прийняття повідомлення про утворення\r\n', 18, 18, '<ol>\r\n	<li>Закон України &laquo;Про громадські об&rsquo;єднання&raquo; від 22.03.2012 р. №4572-VI.&nbsp;&nbsp;</li>\r\n	<li>Постанова Кабінету Міністрів України від 26 грудня 2012р.№1193 &laquo;Про затвердження зразків свідоцтв&nbsp;про реєстрацію громадського об&#39;єднання як громадської організації чи громадської спілки та про&nbsp;акредитацію відокремленого підрозділу іноземної неурядової організації&raquo;.</li>\r\n	<li>Наказ Міністерства юстиції України від 14.12.2012 №1745/5 &laquo;Про порядок підготовки та оформлення&nbsp;рішень щодо громадських об&#39;єднань&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Особисто або&nbsp;уповноваженою особою.</p>\r\n', '<ol>\r\n	<li>Заява.</li>\r\n	<li>Повідомлення про відповідні зміни.</li>\r\n	<li>Відомості про особу, уповноважену представляти громадське об&rsquo;єднання, оформлені з дотриманням ч.7 ст.14 Закону України &laquo;Про громадські об&rsquo;єднання&rdquo; від 22.03.2012р.№4572-VI.</li>\r\n	<li>Письмова особиста згода уповноваженої особи на зайняття відповідної посади відповідно до частини 9 статті 9 Закону.</li>\r\n	<li>Письмова особиста згода осіб, які мають право представляти Організацію для здійснення реєстраційних дій відповідно до частини 6 статті 9 Закону.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>5 днів з дня надходження письмової заяви та документів.</p>\r\n', '<p>---</p>\r\n', '<p>Видача свідоцтва, &nbsp;повідомлення &nbsp;з відповідними змінами &nbsp;громадської організації.</p>\r\n', '<p>Особисто або&nbsp; уповноваженою особою.</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(107, 'Внесення до реєстру &nbsp;громадських об&rsquo;єднань запису про рішення щодо саморозпуску або реорганізації громадського об&rsquo;єднання, а також про припинення діяльності громадського об&rsquo;єднання\r\n', 18, 18, '<ol>\r\n	<li>Закон України &laquo;Про громадські об&rsquo;єднання&raquo; від 22.03.2012 р. №4572-VI.&nbsp;&nbsp;</li>\r\n	<li>Наказ Міністерства юстиції України від 14.12.2012 №1745/5 &laquo;Про порядок підготовки та оформлення&nbsp;рішень щодо громадських об&#39;єднань&raquo;.</li>\r\n	<li>Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; від 15.05.2003 № 755-IV.&nbsp;</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Особисто або&nbsp; уповноваженою особою.</p>\r\n', '<ol>\r\n	<li>Заява.</li>\r\n	<li>Рішення про саморозпуск громадського об&rsquo;єднання. До рішення додаються:</li>\r\n</ol>\r\n\r\n<ul>\r\n	<li>оригінал свідоцтва про реєстрацію громадського &nbsp;об&rsquo;єднання( або його дубліката);</li>\r\n	<li>оригінал статуту громадського&nbsp; об&rsquo;єднання( або його дубліката).</li>\r\n	<li>реєстраційна картка на проведення державної реєстрації припинення юридичної особи.<br />\r\n	&nbsp;</li>\r\n</ul>\r\n', 0, '', '', '', '<p>10 робочих днів з дня надходження письмової заяви та документів.<br />\r\n&nbsp;</p>\r\n', '<p>---</p>\r\n', '<p>Рішення про визнання або відмову у визнанні рішення про саморозпуск громадського об&rsquo;єднання. Лист про внесення даних.</p>\r\n', '<p>Особисто або&nbsp; уповноваженою особою.</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(108, 'Видача свідоцтва про державну реєстрацію друкованого засобу масової інформації з місцевою сферою розповсюдження\r\n', 18, 18, '<ol>\r\n	<li>Закон України &laquo;Про друковані засоби масової інформації (пресу) в Україні&raquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України &laquo;Про державну реєстрацію друкованих засобів масової інформації, інформаційних агентств та розміри реєстраційних зборів&raquo; від 17.11.1997 № 1287.</li>\r\n	<li>Наказ Міністерства юстиції України &laquo;Про затвердження Положення про державну реєстрацію друкованих засобів масової інформації в Україні та Положення про державну реєстрацію інформаційних агентств як суб&#39;єктів інформаційної діяльності&raquo; від 21.02.2006 № 12/5 ( із змінами).</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Особисто засновником (або його представником за довіреністю).</p>\r\n', '<p><strong>Для юридичної особи такими документами є:</strong></p>\r\n\r\n<ol>\r\n	<li>Засвідчені&nbsp; печаткою&nbsp; юридичної&nbsp; особи&nbsp; та&nbsp; підписом&nbsp; її керівника копії статуту (положення), чинні на момент подачі.</li>\r\n	<li>Протокол або витяг з протоколу рішення загальних зборів (конференції) у разі заснування друкованого засобу масової інформації трудовим колективом згідно з вимогами статті 8 Закону України &laquo;Про друковані засоби масової інформації (пресу) в Україні&raquo;.</li>\r\n	<li>Установчий договір між співзасновниками друкованого засобу масової інформації (засвідчений нотаріально, якщо одна із сторін - фізична особа).</li>\r\n	<li>Довіреність, доручення (якщо заяву та/чи установчий договір, угоду між засновником і правонаступником підписує особа, якій таке право не надано правовстановлювальними документами).</li>\r\n</ol>\r\n\r\n<p>&nbsp;<strong> Для фізичної особи таким документом є копія паспорта (сторінок, що містять інформацію про громадянство та реєстрацію місця проживання фізичної особи).</strong></p>\r\n\r\n<p>&nbsp; Установчі документи, складені іноземною мовою, подаються для державної реєстрації друкованих засобів масової інформації разом з їх перекладом на українську мову, засвідчені в установленому порядку.</p>\r\n\r\n<p>&nbsp;</p>\r\n', 1, '<p>Безоплатна, якщо вільняються від сплати реєстраційного збору друкований засіб масової інформації, заснований з благодійною метою і призначений для безплатного розповсюдження.<br />\r\n&nbsp;</p>\r\n', '<ul>\r\n	<li>із місцевою сферою розповсюдження в межах однієї області, обласного центру або двох і більше сільських районів - 24 неоподатковуваних мінімумів доходів громадян;</li>\r\n	<li>із місцевою сферою розповсюдження в межах одного міста, району, окремих населених пунктів, а також підприємств, установ, організацій - 14 неоподатковуваних мінімумів доходів громадян;</li>\r\n	<li>заснованих за участю громадян та/або юридичних осіб інших держав, а також юридичних осіб&nbsp; України, у статутному фонді яких є іноземний капітал, - 120&nbsp; неоподатковуваних&nbsp; мінімумів&nbsp; доходів громадян;</li>\r\n	<li>що спеціалізується на матеріалах еротичного характеру, - 100 неоподатковуваних мінімумів доходів громадян;</li>\r\n	<li>&nbsp;за державну реєстрацію дайджесту &ndash; 60 неоподатковуваних мінімумів доходів громадян.&nbsp;</li>\r\n</ul>\r\n', '<p>Засновник (співзасновники) сплачує реєстраційний збір за наступними реквізитами:</p>\r\n\r\n<p>Банк отримувача: ГУДКСУ у м. Києві;</p>\r\n\r\n<p>Код банку отримувача: 820019;</p>\r\n\r\n<p>Одержувач коштів: УК у Дніпровському районі м. Києва;</p>\r\n\r\n<p>Код отримувача (код за ЄДРПОУ): 38012871;</p>\r\n\r\n<p>Рахунок отримувача: 31115028733005;</p>\r\n\r\n<p>Призначення платежу: за державну реєстрацію друкованого засобу масової інформації.</p>\r\n', '<p>Заява розглядається у місячний строк з дня її одержання.</p>\r\n', '<p>---</p>\r\n', '<p>Видача свідоцтва про державну реєстрацію друкованого засобу масової інформації.</p>\r\n', '<p>Особисто засновником (або його представником за довіреністю) при пред&#39;явленні паспорта і платіжного документа про сплату адміністративного збору</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(109, 'Видача свідоцтва про державну реєстрацію друкованого засобу масової інформації у зв&#39;язку з перереєстрацією\r\n', 18, 18, '<ol>\r\n	<li>Закон України &laquo;Про друковані засоби масової інформації (пресу) в Україні&raquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 17.11.1997 № 1287 &laquo;Про державну реєстрацію друкованих засобів масової інформації, інформаційних агентств та розміри реєстраційних зборів&raquo;.</li>\r\n	<li>Наказ Міністерства юстиції України від 21.02.2006 № 12/5 &laquo;Про затвердження Положення про державну реєстрацію друкованих засобів масової інформації в Україні та Положення про державну реєстрацію інформаційних агентств як суб&#39;єктів інформаційної діяльності&raquo; (із змінами).</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Особисто засновником або його представником за довіреністю.</p>\r\n', '<ol>\r\n	<li>Засвідчені&nbsp; печаткою&nbsp; юридичної&nbsp; особи&nbsp; та&nbsp; підписом&nbsp; її керівника копії статуту (положення), чинні на момент подачі;</li>\r\n	<li>Протокол або витяг з протоколу рішення загальних зборів (конференції) у разі заснування друкованого засобу масової інформації трудовим колективом згідно з вимогами статті 8 Закону України &laquo;Про друковані засоби масової інформації (пресу) в Україні&raquo;;</li>\r\n	<li>Установчий договір між співзасновниками друкованого засобу масової інформації (засвідчений нотаріально, якщо одна із сторін - фізична особа);</li>\r\n	<li>Довіреність, доручення (якщо заяву та/чи установчий договір, угоду між засновником і правонаступником підписує особа, якій таке право не надано правовстановлювальними документами).</li>\r\n</ol>\r\n\r\n<p><strong>&nbsp; Для фізичної особи таким документом є копія паспорта (сторінок, що містять інформацію про громадянство та реєстрацію місця проживання фізичної особи).</strong></p>\r\n\r\n<p>&nbsp; Установчі документи, складені іноземною мовою, подаються для державної реєстрації друкованих засобів масової інформації разом з їх перекладом на українську мову, засвідчені в установленому порядку.</p>\r\n\r\n<p>&nbsp; При перереєстрації до зазначених документів додаються також:</p>\r\n\r\n<ol>\r\n	<li>Угода між засновником і правонаступником (у зв&#39;язку зі зміною засновника (співзасновників)</li>\r\n	<li>Копія попереднього свідоцтва про державну реєстрацію друкованого засобу масової інформації.</li>\r\n</ol>\r\n', 1, '<p>---</p>\r\n', '<p>Безоплатна, якщо вільняються від сплати реєстраційного збору друкований засіб масової інформації, заснований з благодійною метою і призначений для безплатного розповсюдження.<br />\r\n&nbsp;</p>\r\n\r\n<p>Платна - &nbsp;у розмірі 50 відсотків від установленого реєстраційного збору.<br />\r\n&nbsp;</p>\r\n', '<p>Банк отримувача: ГУДКСУ у м. Києві;</p>\r\n\r\n<p>Код банку отримувача: 820019;</p>\r\n\r\n<p>Одержувач коштів: УК у Дніпровському районі м. Києва;</p>\r\n\r\n<p>Код отримувача (код за ЄДРПОУ): 38012871;</p>\r\n\r\n<p>Рахунок отримувача: 31115028733005;</p>\r\n\r\n<p>Призначення платежу: за державну реєстрацію друкованого засобу масової інформації</p>\r\n', '<p>Заява розглядається у місячний строк з дня її одержання.</p>\r\n', '<p>---</p>\r\n', '<p>Видача свідоцтва про державну реєстрацію друкованого засобу масової інформації.</p>\r\n', '<p>Особисто засновником (або його представником за довіреністю)&nbsp; при пред&#39;явленні паспорта і платіжного документа&nbsp; про сплату адміністративного збору.</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(110, 'Видача дубліката свідоцтва про державну реєстрацію друкованого засобу масової інформації\r\n', 18, 18, '<ol>\r\n	<li>Закон України &laquo;Про друковані засоби масової інформації (пресу) в Україні&raquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 17.11.1997 № 1287 &laquo;Про державну реєстрацію друкованих засобів масової інформації, інформаційних агентств та розміри реєстраційних зборів&raquo;.</li>\r\n	<li>Наказ Міністерства юстиції України від 21.02.2006 № 12/5 &laquo;Про затвердження Положення про державну реєстрацію друкованих засобів масової інформації в Україні та Положення про&nbsp; державну реєстрацію інформаційних агентств як суб&#39;єктів інформаційної діяльності&raquo; (із змінами).</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Особисто засновником або його представником за довіреністю.</p>\r\n', '<p><strong>У разі пошкодження свідоцтва: </strong></p>\r\n\r\n<ol>\r\n	<li>Письмова заява засновника (співзасновників) про видачу дубліката.</li>\r\n	<li>Пошкоджене свідоцтво про державну реєстрацію друкованого засобу масової інформації.</li>\r\n</ol>\r\n\r\n<p>&nbsp; <strong>У разі втрати свідоцтва:</strong></p>\r\n\r\n<ol>\r\n	<li>Письмова заява засновника (співзасновника) про видачу дубліката;</li>\r\n	<li>Примірник друкованого засобу масової інформації, у якому опубліковано оголошення про втрату свідоцтва.</li>\r\n</ol>\r\n', 1, '<p>---</p>\r\n', '<p>Платна - &nbsp;у розмірі 20 відсотків від установленого реєстраційного збору.</p>\r\n', '<p>Банк отримувача: ГУДКСУ у м. Києві;</p>\r\n\r\n<p>Код банку отримувача: 820019;</p>\r\n\r\n<p>Одержувач коштів: УК у Дніпровському районі м. Києва;</p>\r\n\r\n<p>Код отримувача (код за ЄДРПОУ): 38012871;</p>\r\n\r\n<p>Рахунок отримувача: 31115028733005;</p>\r\n\r\n<p>Призначення платежу: за державну реєстрацію друкованого засобу масової інформації</p>\r\n', '<p>Заява розглядається у місячний строк з дня її одержання.</p>\r\n', '<p>---</p>\r\n', '<p>Видача дубліката свідоцтва про державну реєстрацію друкованого засобу масової інформації.</p>\r\n', '<p>Особисто засновником (або його представником за довіреністю) при пред&#39;явленні паспорта і платіжного документа про сплату адміністративного збору.</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(111, 'Визнання недійсним свідоцтва про державну реєстрацію друкованого засобу масової&nbsp; інформації з місцевою сферою розповсюдження на підставі повідомлення засновника\r\n', 18, 18, '<p>Наказ Міністерства юстиції України від 21.02.2006 № 12/5 &laquo;Про затвердження Положення про державну реєстрацію друкованих засобів масової інформації в Україні та Положення про державну реєстрацію інформаційних агентств як суб&#39;єктів інформаційної діяльності&raquo; (із змінами).</p>\r\n', '<p>---</p>\r\n', '<p>Особисто засновником&nbsp; або&nbsp; поштою.</p>\r\n', '<p>Письмове повідомлення засновника (співзасновника) про припинення випуску друкованого засобу масової інформації, погоджене з редакцією (свідоцтво&nbsp; про державну реєстрацію друкованого засобу масової інформації,&nbsp; яке визнано недійсним, підлягає поверненню у десятиденний термін з дня отримання відповідного повідомлення реєструвального органу).<br />\r\n&nbsp;</p>\r\n', 0, '', '', '', '<p>Протягом 30 робочих днів з дня подання заяви.</p>\r\n', '<p>---</p>\r\n', '<p>Повідомлення про визнання&nbsp; недійсним&nbsp; свідоцтва про державну реєстрацію&nbsp; друкованого засобу масової інформації.</p>\r\n', '<p>Особисто засновником&nbsp; або&nbsp; поштою.</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(112, 'Оформлення та видача паспорта громадянина України\r\n', 1, 19, '<ol>\r\n	<li>П. 2 Положення про паспорт громадянина України, затвердженого Постановою ВРУ &laquo;Про затвердження положень про паспорт громадянина України та про паспорт громадянина для виїзду за кордон&raquo; від 26.06.1992&nbsp;№ 2503-ХІІ</li>\r\n	<li>П. 7 ч. 1 ст. 24 Закону України &laquo;Про громадянство України&raquo; від 18.01.2001 № 2235-ІІІ</li>\r\n	<li>Ст. 21 Закону України &laquo;Про Єдиний державний демографічний реєстр та документи, що підтверджують громадянство України, посвідчують особу чи її спеціальний статус&raquo; від 20.11.2012 № 5492-VІ</li>\r\n	<li>НАКАЗ МВС &laquo;Про затвердження Порядку оформлення і видачі паспорта громадянина України&raquo; від 13.04.2012 № 320</li>\r\n</ol>\r\n', '<p>Паспорт громадянина України видається кожному громадянинові України після досягнення 16-річного віку.</p>\r\n', '<p>Заявник для одержання адміністративної послуги з оформлення&nbsp; та видачі паспорта громадянина України звертається до територіального підрозділу ДМС або центру надання адміністративних послуг відповідно до місця проживання.</p>\r\n', '<ol>\r\n	<li>Заява.</li>\r\n	<li>Дві фотокартки розміром 3,5 х 4,5 см.</li>\r\n	<li>Свідоцтво про народження.</li>\r\n	<li>Довідка про реєстрацію особи громадянином України.</li>\r\n	<li>Паспорт громадянина України для виїзду за кордон &ndash; для громадян, які постійно проживали за кордоном, після повернення їх на проживання в Україну.</li>\r\n	<li>Посвідчення для взяття на облік бездомних осіб, видане відповідним центром обліку бездомних осіб (для бездомних осіб).</li>\r\n	<li>Документи що підтверджують обставини, на підставі яких паспорт підлягає обміну (зміна (переміна) прізвища, імені або по батькові; установлення розбіжностей у записах).</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Не пізніше 10 робочих днів з дати подання заявником необхідних документів.</p>\r\n', '<p>Відсутність одного з документів, необхідних для отримання адміністративної послуги, відсутність громадянства України.</p>\r\n', '<p>Видача паспорта громадянина України.</p>\r\n', '<p>Звернутися до територіального підрозділу ДМС або центру надання адміністративних послуги відповідно до місця проживання.</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(113, 'Оформлення та видача паспорта громадянина України у разі обміну замість втраченого чи пошкодженого\r\n', 1, 19, '<ol>\r\n	<li>П. 19 Положення про паспорт громадянина України, затвердженого Постановою Верховної Ради України &laquo;Про затвердження положень про паспорт громадянина України та про паспорт громадянина для виїзду за кордон&raquo; від 26.06.1992&nbsp;№ 2503-ХІІ</li>\r\n	<li>Ст. 16, 21 Закону України &nbsp;&laquo;Про Єдиний державний демографічний реєстр та документи, що підтверджують громадянство України, посвідчують особу чи її спеціальний статус&raquo; від 20.11.2012 № 5492-VІ</li>\r\n	<li>Декрет Кабінету міністрів України &laquo;Про державне мито&raquo; від 21.01.1993 № 7-93</li>\r\n	<li>Наказ МВС &laquo;Про затвердження Порядку оформлення і видачі паспорта громадянина України&raquo; від 13.04.2012 № 320</li>\r\n</ol>\r\n', '<p>Втрата чи пошкодження паспорта громадянина України.</p>\r\n', '<p>Заявник для одержання адміністративної послуги з оформлення&nbsp; та видачі паспорта громадянина України замість втраченого чи пошкодженого звертається до територіального підрозділу ДМС відповідно до місця проживання.</p>\r\n', '<p>1. заява про видачу паспорта громадянина України;</p>\r\n\r\n<p>2. або три фотокартки розміром 3,5 х 4,5 см;</p>\r\n\r\n<p>3. платіжний документ з відміткою банку про сплату державного мита або копію документа про звільнення від сплати державного мита;</p>\r\n\r\n<p>4. документи, на підставі яких у паспорті проставляються відповідні відмітки;</p>\r\n\r\n<p>5. паспорт громадянина України для виїзду за кордон &ndash; для громадян, які постійно проживали за кордоном, після повернення їх на проживання в Україну;</p>\r\n\r\n<p>6. витяг з Єдиного&nbsp; реєстру досудових розслідувань (у разі викрадення паспорта).</p>\r\n', 1, '<p>П.п. а) п. 6 ст. 3 Декрету Кабінету Міністрів України &laquo;Про державне мито&raquo; від&nbsp;&nbsp; 21.01.1993 № 7-93</p>\r\n', '<p>Державне мито &ndash; 34 грн. (2 неоподаткованих мінімуми доходів громадян).</p>\r\n', '<p>---</p>\r\n', '<p>Не пізніше 30 (у деяких випадках 60) робочих днів з дати подання заявником необхідних документів.</p>\r\n', '<p>Неналежність особи до громадянства України, неможливість ідентифікації особи.</p>\r\n', '<p>Видача паспорта громадянина України.</p>\r\n', '<p>Звернутися до територіального підрозділу ДМС відповідно до місця проживання.</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(114, 'Вклеювання до паспорта громадянина України фотокартки при досягненні 25- та 45- річного віку\r\n', 1, 19, '<ol>\r\n	<li>П. 7, 8 Положення про паспорт громадянина України, затвердженого Постановою Верховної Ради України &laquo;Про затвердження положень про паспорт громадянина України та про паспорт громадянина для виїзду за кордон&raquo; від 26.06.1992&nbsp;№ 2503-ХІІ</li>\r\n	<li>Наказ МВС &laquo;Про затвердження Порядку оформлення і видачі паспорта громадянина України&raquo; від 13.04.2012 № 320</li>\r\n</ol>\r\n', '<p>Досягнення 25- і 45- річного віку.</p>\r\n', '<p>Заявник для одержання адміністративної послуги звертається до територіального підрозділу ДМС відповідно до місця проживання.</p>\r\n', '<ol>\r\n	<li>Заява</li>\r\n	<li>2 фотокартки розміром 3,5 х 4,5 см.</li>\r\n	<li>Паспорт громадянина України.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Не пізніше 5 днів з дати подання заявником необхідних документів.</p>\r\n', '<p>Відсутність одного з документів, необхідних для отримання адміністративної послуги.</p>\r\n', '<p>Видача паспорта громадянина України.</p>\r\n', '<p>Звернутися до територіального підрозділу ДМС відповідно за місцем проживання.</p>\r\n', 'ні', 0, '', 0, '', '', '', '');
INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`) VALUES
(115, 'Реєстрація місця проживання / перебування\r\n', 1, 19, '<ol>\r\n	<li>Закон України &laquo;Про свободу пересування та вільний вибір місця проживання в Україні&raquo; від 11.12.2003 № 1382-ІV.</li>\r\n	<li>Наказ МВС &laquo;Про затвердження Порядку реєстрації місця проживання та місця перебування фізичних осіб в Україні та зразків необхідних документів&raquo; від 22.11.2012 № 1077.</li>\r\n</ol>\r\n', '<p>Заява особи або її законного представника.</p>\r\n', '<p>Заявник для одержання адміністративної послуги з оформлення реєстрації місця проживання / перебування звертається до територіального підрозділу ДМС &nbsp;або Центру надання адміністративних послуг Одеської міської ради відповідно до місця проживання.</p>\r\n', '<ol>\r\n	<li>Письмова заява.</li>\r\n	<li>Документ до якого вносяться відомості про місце проживання / перебування. Якщо дитина не досягла 16 річного віку, подається свідоцтво про народження;</li>\r\n	<li>Квитанція про сплату державного мита або документ про звільнення від його сплати;</li>\r\n	<li>Талон зняття з реєстрації (у разі зміни місця проживання в межах України).</li>\r\n	<li>Талон зняття з реєстрації не подається у разі оформлення реєстрації місця проживання з одночасним зняттям з реєстрації попереднього місця проживання;</li>\r\n	<li>Документи, що підтверджують право проживання в житлі, перебування або взяття на облік у спеціалізованій соціальній установі, закладі соціального обслуговування та соціального захисту, проходження служби у військовій частині, адреса яких зазначається під час реєстрації;</li>\r\n	<li>військовий квиток або посвідчення про приписку (для громадян, які підлягають взяттю на військовий облік або перебувають на військовому обліку)</li>\r\n</ol>\r\n\r\n<p>У разі подачі заяви законним представником додатково подаються:</p>\r\n\r\n<ol>\r\n	<li>Документ, що посвідчує особу законного представника,</li>\r\n	<li>Документ, що підтверджує повноваження особи як законного представника, крім випадків, коли законними представниками є батьки (усиновлювачі)</li>\r\n</ol>\r\n', 1, '<p>П.п. м) п. 6 ст. 3 Декрету Кабінету Міністрів України &laquo;Про державне мито&raquo; від 21.01.1993 № 7-93</p>\r\n', '<p>Державне мито &ndash; 0,85 грн (0,05 % неоподаткованих мінімумів доходів громадян).</p>\r\n', '<p>---</p>\r\n', '<p>Реєстрація місця проживання / перебування здійснюється в день подання особою документів.</p>\r\n', '<p>Відсутність одного з документів, необхідних для отримання адміністративної послуги.</p>\r\n', '<p><strong>Реєстрація місця проживання / перебування особи.</strong></p>\r\n\r\n<p><em>У разі звернення особи для реєстрації місця проживання більше чим через 10 днів після прибуття до нового місця&nbsp; проживання, до неї застосовуються заходи адміністративного впливу відповідно до статті 197 КУпАП (санкція &ndash; попередження або накладання штрафу від 1 до 3&nbsp; неоподаткованих мінімумів доходів громадян).</em></p>\r\n', '<p>Звернення до територіального підрозділу ДМС або центру надання адміністративних послуг відповідно до місця проживання.</p>\r\n\r\n<p>&nbsp;</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(116, 'Зняття з реєстрації місця проживання\r\n', 1, 19, '<ol>\r\n	<li>Закон України &laquo;Про свободу пересування та вільний вибір місця проживання в Україні&raquo; від 11.12.2003 № 1382-ІV.</li>\r\n	<li>Наказ МВС &laquo;Про затвердження Порядку реєстрації місця проживання та місця перебування фізичних осіб в Україні та зразків необхідних документів&raquo; від 22.11.2012 № 1077.</li>\r\n</ol>\r\n', '<p>Заява особи або її законного представника.</p>\r\n', '<p>Особа або її законний представник &nbsp;для одержання адміністративної послуги з оформлення зняття з звертається до територіального підрозділу ДМС &nbsp;або Центру надання адміністративних послуг Одеської міської ради відповідно до місця проживання.</p>\r\n', '<ol>\r\n	<li>Письмова заява;</li>\r\n	<li>Судове рішення, яке набрало законної сили, про позбавлення права власності на житлове приміщення або права користування житловим приміщенням, про виселення, про визнання особи безвісно відсутньою або оголошення її померлою;</li>\r\n	<li>Свідоцтво про смерть</li>\r\n	<li>Паспорт або паспортний документ, що надійшов з органу державної реєстрації актів цивільного стану, або документа про смерть, виданого компетентним органом іноземної держави, легалізованого в установленому порядку;</li>\r\n	<li>Інших документів, які свідчать про припинення:</li>\r\n</ol>\r\n\r\n<ul>\r\n	<li>підстав перебування на території України іноземців та осіб без громадянства;</li>\r\n	<li>підстав для проживання або перебування особи у спеціалізованій соціальній установі, закладі, соціального обслуговування та соціального захисту;</li>\r\n	<li>підстав на право користування житловим приміщенням</li>\r\n</ul>\r\n\r\n<p>&nbsp; &nbsp; &nbsp;6.&nbsp;Разом із заявою особа подає:</p>\r\n\r\n<ul>\r\n	<li>Документ, до якого вносяться відомості про зняття з реєстрації місця проживання. Якщо дитина не досягла 16-річного віку, подається свідоцтво про народження;</li>\r\n	<li>Військовий квиток або посвідчення про приписку (для громадян, які підлягають взяттю на військовий облік або перебувають на військовому обліку)</li>\r\n</ul>\r\n\r\n<p>&nbsp; &nbsp; 7. У разі подачі заяви законним представником особи додатково подаються:</p>\r\n\r\n<ul>\r\n	<li>Документ, що посвідчує особу законного представника;</li>\r\n	<li>Документ, що підтверджує повноваження особи як законного представника, крім випадків, коли законними представниками є батьки (усиновлювачі).</li>\r\n</ul>\r\n', 0, '', '', '', '<p>Зняття з реєстрації місця проживання здійснюється в день подання особою документі.</p>\r\n', '<p>Відсутність одного з документів, необхідних для отримання адміністративної послуги.</p>\r\n', '<p>Зняття з реєстрації місця проживання особи.</p>\r\n', '<p>Звернутися &nbsp;до територіального підрозділу ДМС або центру надання адміністративних послуг відповідно до місця проживання.</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),
(117, 'Оформлення та видача або обмін паспорта громадянина України для виїзду за кордон\r\n', 1, 19, '<ol>\r\n	<li>Закон України &laquo;Про порядок виїзду з України і в&rsquo;їзду в Україну громадян України&raquo;&nbsp; від 21.01.1994 № 3857-ХІІ.</li>\r\n	<li>Положення про паспорт громадянина України для виїзду за кордон, затверджене Постановою Верховної Ради України 23.02.2007 № 719-V.</li>\r\n	<li>Правила оформлення та видачі паспорта громадянина України для виїзду за кордон і проїзного документа дитини, їх тимчасового затримання та вилучення, затверджені постановою Кабінету Міністрів України від 31 березня 1995 року № 231.</li>\r\n	<li>Порядок провадження за заявами про оформлення паспортів громадянина України для виїзду за кордон і проїзних документів дитини, затверджений Наказом МВС від 21.12.2004&nbsp; № 1603.</li>\r\n</ol>\r\n', '<p>Заява громадянина України.</p>\r\n', '<p>Заявник &nbsp;для одержання адміністративної послуги з оформлення зняття з реєстрації звертається до територіального органу (підрозділу) ДМС &nbsp;або Центру надання адміністративних послуг Одеської міської ради.&nbsp;</p>\r\n', '<ol>\r\n	<li>Заява-анкета встановленого зразка (заповнюється посадовою особою територіального органу (підрозділу) ДМС, адміністратором центру надання адміністративних послуг,</li>\r\n	<li>Паспорт громадянина України, свідоцтво про народження (для осіб віком до 16 років) (після прийняття документів повертається)</li>\r\n	<li>Копія документа про реєстрацію у Державному реєстрі фізичних осіб &ndash; платників податків, виданого органами державної податкової служби, крім осіб, які через свої релігійні або інші переконання відмовляються від прийняття ідентифікаційного номера та офіційно повідомляють про це відповідні державні органи,</li>\r\n	<li>Квитанція про сплату державного мита або документ, що підтверджує право на звільнення від його сплати,</li>\r\n	<li>Квитанцію про оплату інших передбачених законодавством платежів.&nbsp;</li>\r\n	<li>Особи віком від 18 до 25 років, які підлягають призову на строкову військову службу разом із заявою&nbsp; про оформлення паспорта подають довідку відповідного військового комісаріату щодо можливості виїзду з України.&nbsp;&nbsp;</li>\r\n</ol>\r\n', 1, '<ol>\r\n	<li>Декрет Кабінету Міністрів України &laquo;Про державне мито&raquo; від&nbsp;&nbsp; 21.01.1993 № 7.</li>\r\n	<li>Постанова Кабінету Міністрів України&nbsp; &laquo;Деякі питання надання підрозділами Міністерства внутрішніх справ та Державної міграційної служби&nbsp; платних послуг&raquo; від 26.10.2011 № 1098.</li>\r\n	<li>Постанова Кабінету Міністрів України&nbsp; &laquo;Про затвердження переліку платних послуг, які надаються підрозділами Міністерства внутрішніх справ та Державної міграційної служби і розміру плати за їх надання&raquo; від 04.06.2007 № 795.</li>\r\n</ol>\r\n', '<p>Державне мито &ndash; 10 неоподатковуваних мінімумів доходів громадян</p>\r\n\r\n<p>Розмір плати за надання послуги &ndash; 87,15 грн.</p>\r\n\r\n<p>Вартість бланка паспорта громадянина України для виїзду за кордон (визначається з урахуванням витрат, пов&rsquo;язаних з придбанням відповідної продукції, у тому числі вартості персоналізації).</p>\r\n', '<p>---</p>\r\n', '<p>Не пізніше 20 робочих днів з дати подання заявником необхідних документів.</p>\r\n', '<p>Громадянину може бути тимчасово відмовлено у разі, коли:&nbsp;</p>\r\n\r\n<ol>\r\n	<li>він обізнаний з відомостями, що становлять державну таємницю, - до закінчення строку, встановленого законом України &laquo;Про державну таємницю&raquo; (у разі виїзду за кордон на постійне проживання).</li>\r\n	<li>діють неврегульовані аліментні, договірні чи інші&nbsp; невиконані зобов&rsquo;язання, - до виконання зобов&rsquo;язань або зобов&rsquo;язання спору за погодженням сторін у передбачених законом випадках, чи забезпечення зобов&rsquo;язань заставою, якщо інше не передбачено міжнародним договором України;</li>\r\n	<li>стосовно нього в порядку, передбаченому кримінальним процесуальним законодавством, застосовано запобіжний захід, за умовами якого йому заборонено виїжджати за кордон, - до закінчення кримінального провадження або скасування відповідних обмежень;</li>\r\n	<li>він засуджений за вчинення кримінального правопорушення, - до відбуття покарання або звільнення</li>\r\n	<li>він ухиляється від виконання зобов&rsquo;язань, покладених на нього судовим рішенням, рішенням іншого органу (посадової особи), - до виконання зобов&rsquo;язань;</li>\r\n	<li>він свідомо сповістив про себе неправдиві відомості, - до з&rsquo;ясування причин і наслідків подання неправдивих відомостей;</li>\r\n	<li>він підлягає призову на строкову військову службу, - до вирішення питання про відстрочку від призову;</li>\r\n	<li>щодо нього подано цивільний позов до суду, - до закінчення провадження у справі;</li>\r\n	<li>він перебуває під адміністративним наглядом органів внутрішніх справ, -&nbsp; до припинення нагляду.&nbsp;</li>\r\n</ol>\r\n', '<p>Видача паспорта громадянину України для виїзду за кордон.</p>\r\n', '<p>Звернутися &nbsp;до територіального органу (підрозділу) ДМС або центру надання адміністративних послуг.</p>\r\n', 'ні', 0, '', 0, '', '', '', ''),

-- --------------------------------------------------------

--
-- Структура таблицы `gen_status_description`
--

DROP TABLE IF EXISTS `gen_status_description`;
CREATE TABLE IF NOT EXISTS `gen_status_description` (
  `id` tinyint(3) unsigned NOT NULL,
  `description` varchar(150) NOT NULL COMMENT 'Текст повідомлення',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Опис статусів';

-- --------------------------------------------------------

--
-- Структура для представления `ff_listtables`
--
DROP TABLE IF EXISTS `ff_listtables`;

CREATE ALGORITHM=UNDEFINED DEFINER=`iasnap`@`%` SQL SECURITY DEFINER VIEW `ff_listtables` AS select lcase(`information_schema`.`tables`.`TABLE_NAME`) AS `TABLE_NAME` from `information_schema`.`tables` where (`information_schema`.`tables`.`TABLE_SCHEMA` = database()) order by `information_schema`.`tables`.`TABLE_NAME`;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `AuthAssignment`
--
ALTER TABLE `AuthAssignment`
  ADD CONSTRAINT `AuthAssignment_ibfk_1` FOREIGN KEY (`itemname`) REFERENCES `AuthItem` (`name`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `AuthItemChild`
--
ALTER TABLE `AuthItemChild`
  ADD CONSTRAINT `AuthItemChild_ibfk_1` FOREIGN KEY (`parent`) REFERENCES `AuthItem` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `AuthItemChild_ibfk_2` FOREIGN KEY (`child`) REFERENCES `AuthItem` (`name`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `cab_authorities_certs`
--
ALTER TABLE `cab_authorities_certs`
  ADD CONSTRAINT `authorities_certs` FOREIGN KEY (`authorities_id`) REFERENCES `gen_authorities` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `cab_bids_rkk`
--
ALTER TABLE `cab_bids_rkk`
  ADD CONSTRAINT `bid_id_rkk` FOREIGN KEY (`id`) REFERENCES `gen_bid_current_status` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Ограничения внешнего ключа таблицы `cab_org_external_certs`
--
ALTER TABLE `cab_org_external_certs`
  ADD CONSTRAINT `ext_org_certs` FOREIGN KEY (`ext_user_id`) REFERENCES `cab_user_external` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Ограничения внешнего ключа таблицы `cab_promoting_bids`
--
ALTER TABLE `cab_promoting_bids`
  ADD CONSTRAINT `promoting_services` FOREIGN KEY (`services_id`) REFERENCES `gen_services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `cab_user`
--
ALTER TABLE `cab_user`
  ADD CONSTRAINT `t_role_id` FOREIGN KEY (`user_roles_id`) REFERENCES `cab_user_roles` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `t_author_id` FOREIGN KEY (`authorities_id`) REFERENCES `gen_authorities` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `cab_user_bids_connect`
--
ALTER TABLE `cab_user_bids_connect`
  ADD CONSTRAINT `bid_id` FOREIGN KEY (`id`) REFERENCES `gen_bid_current_status` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `cab_ser_id` FOREIGN KEY (`services_id`) REFERENCES `gen_services` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `int_user_bid_id` FOREIGN KEY (`user_id`) REFERENCES `cab_user_external` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `cab_user_extern_certs`
--
ALTER TABLE `cab_user_extern_certs`
  ADD CONSTRAINT `ext_user_certs` FOREIGN KEY (`ext_user_id`) REFERENCES `cab_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `cab_user_files_in`
--
ALTER TABLE `cab_user_files_in`
  ADD CONSTRAINT `bid_id_in` FOREIGN KEY (`user_bid_id`) REFERENCES `gen_bid_current_status` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;
