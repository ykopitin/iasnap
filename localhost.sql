-- phpMyAdmin SQL Dump
-- version 4.0.5
-- http://www.phpmyadmin.net
--
-- Хост: localhost
-- Время создания: Ноя 09 2014 г., 17:53
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

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_AI_FIELD`(
        IN `ID` INTEGER
    )
    COMMENT 'Вызывается после добавления поля в таблицу полей. Контролирует ссылочную целостность'
BEGIN
	DECLARE TYPEREF INT DEFAULT 0;
	
	SELECT fff.`type` INTO TYPEREF FROM `ff_field` fff WHERE (fff.`id`=ID) LIMIT 1;
	if (TYPEREF=10) then
		INSERT INTO `ff_field` (`formid`,`name`,`type`,`description`,`order`,`protected`,`default`)
		SELECT src1.`formid`, concat(src1.`name`,'_filetype'), 11, concat(src1.`description`,' - MIME Тип'), 0,1,`default`
		FROM `ff_field` src1 WHERE (src1.`id`=ID);
		INSERT INTO `ff_field` 
			(`formid`,`name`,`type`,`description`,`order`,`protected`,`default`)
		SELECT src2.`owner`, src1.`name`, src1.`type`, src1.`description`, src1.`order`,1,`default`
		FROM `ff_field` src1 
			inner join `ff_registry_h` src2 on (src1.`formid`=src2.`parent`)
		WHERE (src1.id=LAST_INSERT_ID());

		INSERT INTO `ff_field` (`formid`,`name`,`type`,`description`,`order`,`protected`,`default`)
		SELECT src1.`formid`, concat(src1.`name`,'_filename'), 12, concat(src1.`description`,' - Имя файла'), 0,1,`default`
		FROM `ff_field` src1 WHERE (src1.`id`=ID);
		INSERT INTO `ff_field` 
			(`formid`,`name`,`type`,`description`,`order`,`protected`,`default`)
		SELECT src2.`owner`, src1.`name`, src1.`type`, src1.`description`, src1.`order`,1,`default`
		FROM `ff_field` src1 
			inner join `ff_registry_h` src2 on (src1.`formid`=src2.`parent`)
		WHERE (src1.id=LAST_INSERT_ID());

	end if;
	if (TYPEREF=14) then
		INSERT INTO `ff_field` (`formid`,`name`,`type`,`description`,`order`,`protected`,`default`)
		SELECT src1.`formid`, concat(src1.`name`,'_fileedsname'), 15, concat(src1.`description`,' - Имя файла'), 0,1,`default`
		FROM `ff_field` src1 WHERE (src1.`id`=ID);
		INSERT INTO `ff_field` 
			(`formid`,`name`,`type`,`description`,`order`,`protected`,`default`)
		SELECT src2.`owner`, src1.`name`, src1.`type`, src1.`description`, src1.`order`,1,`default`
		FROM `ff_field` src1 
			inner join `ff_registry_h` src2 on (src1.`formid`=src2.`parent`)
		WHERE (src1.id=LAST_INSERT_ID());
	end if;

	INSERT INTO `ff_field` 
			(`formid`,`name`,`type`,`description`,`order`,`protected`,`default`)
		SELECT src2.`owner`, src1.`name`, src1.`type`, src1.`description`, src1.`order`,1,`default`
		FROM `ff_field` src1 
			inner join `ff_registry_h` src2 on (src1.`formid`=src2.`parent`)
		WHERE (src1.id=ID);	
END$$

CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_ALTTBL`(
        IN `IDREGISTRY` INTEGER
    )
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

CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_AU_FIELD`(
        IN `ID` INTEGER
    )
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
			WHERE (fff.`formid`=VFORMID) and (fff.`name` = concat(VNAME,'_fileedsname')) limit 1;
		if (VEXIST>0) then 
			call FF_BD_FIELD(ID);
			DELETE FROM `ff_field` WHERE (`formid`=VFORMID) and (`name` like concat(VNAME,'%'));
		end if;
	else
		SELECT count(*) INTO VEXIST FROM `ff_field` fff 
			WHERE (fff.`formid`=VFORMID) and (fff.`name` = concat(VNAME,'_fileedsname')) limit 1;
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
		src1.`default`=src2.`default`,
		src1.`description`=src2.`description`;
END$$

CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_BD_FIELD`(
        IN `ID` INTEGER
    )
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
		delete from `ff_field` where (`name`=concat(VNAME,'_fileedscrypt')) and (`formid`=VFORMID) limit 1;
		delete from `ff_field` where (`name`=concat(VNAME,'_fileedssign')) and (`formid`=VFORMID) limit 1;
	end if;

	if (@VSTMT<>'') then
		SELECT CONCAT('DELETE FROM `ff_field` WHERE id in (',@VSTMT,')') INTO @VSTMT;
		PREPARE stmt1 FROM @VSTMT;
		EXECUTE stmt1;
		DEALLOCATE PREPARE stmt1;
	end if;


END$$

CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_CRTTBL`(
        IN `IDREGISTRY` INTEGER
    )
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

CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_DELTBL`(
        IN `IDREGISTRY` INTEGER
    )
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

CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_HELPER_ALTTBL`(
        IN `IDREGISTRY` INTEGER,
        OUT `STMT` VARCHAR(4000)
    )
    COMMENT 'Вспомоготельная ХП для FF_ALTTBL. Формирует необходимый запрос для изменения талиц.'
BEGIN
DECLARE done INT DEFAULT FALSE;
DECLARE VSTMTPIACE VARCHAR(2000);
DECLARE DF varchar(1000);
DECLARE cur1 CURSOR FOR	select sq, ff_df  from (
	select ff_cn, ff_tp, is_cn, is_tp,
		case 
			when (ff_tp is null) and (ff_cn is not null) and (is_cn is not null) then CONCAT(' DROP `', is_cn,'` ')
			when (ff_df is not null) and (is_tp is not null) then CONCAT(' MODIFY `', ff_cn, '` ', ff_tp, ' ')
			when (ff_cn = is_cn) and (ff_tp <> is_tp) then CONCAT(' MODIFY `', ff_cn, '` ', ff_tp, ' ')
			when (ff_cn is null) then CONCAT(' DROP `', is_cn,'` ')
			when (is_cn is null) then CONCAT(' ADD `', ff_cn, '` ', ff_tp, ' ')
			else null
		end sq,
		ff_df
	from 
	((SELECT 
		lower(fff.`name`) ff_cn, 
		lower(fft.`systemtype`) ff_tp, 
		lower(isc.`COLUMN_NAME`) is_cn, 
		lower(isc.`COLUMN_TYPE`) is_tp,
		fff.`default` ff_df
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
		lower(isc.`COLUMN_TYPE`) is_tp,
		tt.ff_df
	from (
		SELECT 
			lower(fff.`name`) ff_cn, 
			lower(fft.`systemtype`) ff_tp, 
			lower(fff.`name`) ffcn,
			fff.`default` ff_df
		FROM `ff_field` fff 
			inner join `ff_types` fft on (fff.`type`=fft.id)
		WHERE  fff.`formid`=IDREGISTRY) tt	
		right outer join information_schema.`COLUMNS` isc on (
										(lower(isc.`COLUMN_NAME`) = tt.ffcn) and 
										(isc.`TABLE_SCHEMA`=DATABASE()))	
		inner join `ff_registry` ffr2 on (CONCAT('ff_',lower(ffr2.`tablename`))=lower(isc.`TABLE_NAME`))
	where (LOWER(isc.`COLUMN_NAME`)<>'id') and ffr2.`id`=IDREGISTRY)) t1 ) t2
	where 
		((t2.sq is not null) and (t2.ff_tp is not null)) or 
		((t2.sq is not null) and (t2.ff_tp is null) and (t2.is_cn is not null)) or 
		((LOCATE('DBDEFAULT:',TRIM(t2.ff_df))=1) and (t2.is_cn is not null));

DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
open cur1;
	set STMT='';
-- if((ff_df is null) or (lower(ff_df)='null') or (ff_df=''), '', ff_df)
	fetch cur1 into VSTMTPIACE, DF;
	while (not done) do
		if (
			(DF is not null) and 
			(LOCATE('DROP',TRIM(VSTMTPIACE))<>1) and 
			(LOCATE('DBDEFAULT:',TRIM(DF))=1)
		   ) then
			SET DF=SUBSTRING(DF,11);
			SET VSTMTPIACE = concat(VSTMTPIACE, ' ', DF, ' ');
		end if;
		if (STMT='') then
			select VSTMTPIACE into STMT;
		else
			select concat(STMT,', ',VSTMTPIACE) into STMT;
		end if;
		fetch cur1 into VSTMTPIACE, DF;
	end while;
close cur1;
END$$

CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_HELPER_SYNCDATA`(
        IN `IDFROM` INTEGER,
        IN `IDREGISTRYFROM` INTEGER,
        IN `TABLENAMEFROM` VARCHAR(45)
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

CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_HELPER_SYNCDATA_DELETE`(
        IN `ID` BIGINT
    )
    COMMENT 'НЕВспомагательная ХП для синхронизации заполненых данных. Вызывается самостоятельно из-за сложности определения операции удаления'
BEGIN
	DECLARE VTABLENAME VARCHAR(45);
	DECLARE done INT DEFAULT FALSE;
	DECLARE cur1 cursor for select `tablename` from `ff_registry` where `copying`=1;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
-- очистка связок
	DELETE FROM `ff_ref_multiguide` WHERE `owner`=ID;
-- синхронизация удаленных записей
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

CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_HELPER_SYNCDATA_UPDATE`(
        IN `IDFROM` INTEGER,
        IN `IDREGISTRYTO` INTEGER,
        IN `TABLENAMEFROM` VARCHAR(45),
        IN `TABLENAMETO` VARCHAR(45),
        OUT `BUILDQUERY` VARCHAR(4000)
    )
    COMMENT 'Вспомогательная ХП для синхронизации данных при обновлении'
BEGIN
	DECLARE VFIELDNAME VARCHAR(55);
	DECLARE done INT DEFAULT FALSE;
	DECLARE firstiteration INT DEFAULT TRUE;
	DECLARE cur1 cursor for 
		SELECT fff.`name` 
		FROM `ff_field` fff 
			inner join `ff_types` fft on (fff.`type`=fft.id)  
		WHERE (fff.`formid`=IDREGISTRYTO) and (fft.`systemtype` is not null);
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

CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_INITID`(
        IN `IDREGISTRY` INTEGER,
        IN `IDSTORAGE` INTEGER,
        OUT `ID` BIGINT(20)
    )
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

CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_RSCLEAR`(
        IN `IDSTORAGE` INTEGER
    )
    COMMENT 'Предварительная очистка привязок СФ к хранилищам'
BEGIN
	DELETE FROM `ff_registry_storage` where (`storage`=IDSTORAGE);
END$$

CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_RSINIT`(
        IN `IDREGISTRY` INTEGER,
        IN `IDSTORAGE` INTEGER
    )
    COMMENT 'Для регистрации СФ в хранилищах'
BEGIN
	INSERT INTO `ff_registry_storage` (`registry`, `storage`)
	VALUE (IDREGISTRY,IDSTORAGE);
END$$

CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_SYNCDATA`(
        IN `ID` BIGINT
    )
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
CREATE DEFINER=`iasnap`@`%` FUNCTION `FF_isParent`(
        `IDREGISTRY1` INTEGER,
        `IDREGISTRY2` INTEGER
    ) RETURNS int(11)
    COMMENT 'Для определения родителя из двух вариантов'
BEGIN
	DECLARE VCNT INT default 0;
	DECLARE VCNT2 INT default 0;
	SELECT count(*) INTO VCNT FROM `ff_registry_h` WHERE (`owner`=IDREGISTRY1) and (`parent`=IDREGISTRY2);
	if (VCNT>0) then
		RETURN IDREGISTRY2;
	end if;
	SELECT count(*) INTO VCNT FROM `ff_registry_h` WHERE (`owner`=IDREGISTRY2) and (`parent`=IDREGISTRY1);
	if (VCNT>0) then
		RETURN IDREGISTRY1;
	end if;	
	select t.`parent`, cnt INTO VCNT, VCNT2 from
		(SELECT ffrh1.`parent` ,count(ffrh3.`owner`) cnt
		FROM ff_registry_h ffrh1	
			inner join ff_registry_h ffrh2 on (ffrh1.`parent`=ffrh2.`parent`)
			inner join ff_registry_h ffrh3 on (ffrh1.`parent`=ffrh3.`parent`)
		where ffrh1.`owner`=9 and ffrh2.`owner`=10
		group by 1) t
	order by 2 asc limit 1;
	if (VCNT2=0) then
		return 0;
	end if;
	RETURN VCNT;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `AuthAssignment`
--

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
('customer', '1', NULL, 'N;'),
('customer', '55', NULL, 'N;'),
('guest', '51', NULL, 'N;'),
('guest', '52', NULL, 'N;'),
('guest', '53', NULL, 'N;'),
('siteadmin', '50', NULL, 'N;');

-- --------------------------------------------------------

--
-- Структура таблицы `AuthItem`
--

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
('cnapadmin', 2, '', NULL, 'N;'),
('customer', 2, '', NULL, 'N;'),
('guest', 2, '', NULL, 'N;'),
('secadmin', 2, '', NULL, 'N;'),
('siteadmin', 2, '', NULL, 'N;'),
('snapoperator', 2, '', NULL, 'N;');

-- --------------------------------------------------------

--
-- Структура таблицы `AuthItemChild`
--

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
  `str_activcode` varchar(40) DEFAULT NULL COMMENT 'Строка з кодом активації',
  `time_activcode` int(11) DEFAULT NULL COMMENT 'Час дії строки з кодом активації',
  `pd_agreement_signed` mediumblob NOT NULL COMMENT 'Згода на обробку персональних даних',
  `time_registered` int(11) DEFAULT NULL COMMENT 'Дата реєстрації користувача',
  `time_last_login` int(11) DEFAULT NULL COMMENT 'Дата останнього входу користувача',
  PRIMARY KEY (`id`),
  KEY `role_id_idx` (`user_roles_id`),
  KEY `author_id_idx` (`authorities_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Каталог користувачів порталу»' AUTO_INCREMENT=56 ;

--
-- Дамп данных таблицы `cab_user`
--

INSERT INTO `cab_user` (`id`, `type_of_user`, `fio`, `organization`, `email`, `phone`, `cab_state`, `authorities_id`, `user_roles_id`, `str_activcode`, `time_activcode`, `pd_agreement_signed`, `time_registered`, `time_last_login`) VALUES
(1, 0, 'Тестовый пользователь с ИД 1', 'фізична особа', 'format12@meta.ua', '0631234568', 'активований', 1, 4, NULL, NULL, '', NULL, 1415536462),
(51, 0, 'Іванов (ТЕСТ) Іван Іванович (ТЕСТ)', 'фізична особа', 'cnap_ivanov_dir@meta.ua', '0930000002', 'активований', 1, 2, '76035956', NULL, '', 1415386707, 1415548407),
(52, 0, 'Сідоров (ТЕСТ) Олександр Іванович (ТЕСТ)', 'фізична особа', 'cnap_sidorov_ac@meta.ua', '093000003', 'активований', 10, 3, '95464104', NULL, '', 1415387935, 1415548220),
(53, 0, 'Молчанов Данило Сергійович', 'фізична особа', 'danil.molchanov@gmail.com', '0912', 'активований', 1, 2, '84346402', NULL, '', 1415390545, NULL);
INSERT INTO `cab_user` (`id`, `type_of_user`, `fio`, `organization`, `email`, `phone`, `cab_state`, `authorities_id`, `user_roles_id`, `str_activcode`, `time_activcode`, `pd_agreement_signed`, `time_registered`, `time_last_login`) VALUES
(55, 1, 'Печатка (ТЕСТ)', 'фізична особа', 'fortor48@gmail.com', '0932222223', 'активований', 1, 4, '', 0, 0x4d494b446267594a4b6f5a496876634e415163436f494b44587a43436731734341514578446a414d42676f716869514341514542415149424d494a327477594a4b6f5a496876634e415163426f494a32714153436471524e41456b4153514274414445415151425a41456f415377427641466f415351426f414859415977424f414545415551426a41454d416277424a41456b4162514234414651415177424441456f416377424641454d4151514252414555416541424541476f415151424e414549415a774276414845416141427041464541517742424146454152514243414545415551424a414549415451424a41456b4156774133414863415751424b414573416277426141456b416141423241474d41546742424146454159774243414738415351424a414663414e41424241464d415177424741485141654142744145454152774134414545415977426e414549414d414242414563414f41424241474d415a7742424144414151514245414763415151425241454541516742754145454152774177414545415751425241454941634142424145634164774242414577415a77424341476f415151424841446741515142694146454151514133414545415277425a414545415967423341454941655142424145674155514242414749416477424341486b415151424541464541515142504145454151674242414545415277426a4145454159674252414549416141424241456341617742424147494151514242414855415151424841453041515142694148634151674230414545415241427a4145454154514242414545414e5142424145514154514242414530415a77424241486b415151424541456b415151424e4147634151514235414545415241424a4145454154514233414545414e774242414549415977424641456b415151424241446741516742454146554152514252414763415551417241454941525141304145554153514242414545414d77424341455141515142464145304155514252414445415167424541474d41525142514148634155514178414549415251426a4145554154674252414645414f514243414551414d41424641465141647742524147634151514245414451415251424e414645415567424241454941524141304145554154514252414645414e674243414551415a77424641456b41515142424143384151674245414451415251424f414545415551423341454941524141774145554154774242414649415267424341454d4151514242414641415151425241446b41516742454144514152514255414763415551426e414545415241424a4145554153514242414545414d51424341455141637742464145344155514252414459415167424641456b4152514252414545415551417241454941524141774145554155414252414645414b77424341455141647742464146454164774252414763415151424541456b41525142504145454155514236414549415241427a4145554156414233414645414d414243414559415751424641456b415151424241444d41516742454145454152514255414863415551423541454941517742424145454155414252414645416477424341454d4151514242414641415a77425341454d41516742464145454152514250414545415551413441454941524142424145554155414252414645414f514243414555414f41424641456b41515142424148634151674245414645415251425141454541556742584145494152414177414555415667426e414649415167424341455541535142464146454151514252414863415167424641456b4152514250414545415551423541454941524141774145554154774242414649415267424341454d41515142424146414164774252414373415167424641455541525142504148634155674245414549415241424e4145554153514242414549415677424341454d4151514242414530415a774253414663415167424541464541525142514148634155514172414549415241424a414555415667426e414645414d414243414551414d414246414641415a77425241476341515142454146454152514251414763415551426e414545415167426a4145554154514242414645414e674243414551414e41424641464141555142534145514151674244414545415151424a4148634155514132414549415251424241455541545142424146494157414243414551414d4142464145384151514252414763415151424441456b4151514249414863415567424241454941524141304145554153514242414545414d7742434145514151514246414649415551425241445141516742464145554152514252414763415551426e4145454152414134414555415467425241464941515142434145554152514246414641415a77425241446b41516742454145454152514250414863415567424e41454941524141774145554154774242414649415267424341454d41515142424145344151514252414863415167424541444141525142504145454155674247414549415177424a4145454153514242414549415541424341454d415151424241453441515142524148634151674246414451415251424a414545415151417a414549415241424e414555415541426e414645414d414243414555415451424641456b415151424241446b4151674245414545415251424a414545415151417241454941524142464145554155514242414645414b7742434145514152514246414538416477425241444541516742454144414152514251414645415567425141454941517742424145454155414242414645414b774243414559415977424641464941555142524147634151514245414467415251424f41464541556742424145494152514246414555415541426e414645414f51424341455141515142464145384164774253414530415167424541444141525142504145454155674247414549415177424241454541546742424146454164774243414551414d41424641453841515142534145594151674244414545415151424f414863415551426e414545415241424a4145554154774242414645414e674243414551414e4142464146454151514252414451415167424641455541525142524147634155514233414549415241417741455541554142524146494155414243414551416477424641456b415151424241433841516742454144514152514252414545415567424441454941524142424145554154774233414649415241424341454d415151424241456f415a77425241444541516742454144414152514252414763415567424241454941524142424145554153514242414545414f5142434145514151514246414534415151425241486341516742454144414152514251414645415567425141454941517742424145454154514242414645414d4142434145514164774246414659415a77425241446b415167424741466b41525142524146454155674244414549415251424241455541545142424146494151774243414551415a774246414530415a77425241446b41516742454147634152514253414645415551426e4145454152414134414555415541426e41464941516742434145514163774246414645416477425241486f4151674244414451415151425041486341516741784145454152414242414545415667426e4145494163674242414559414d4142424146674155514243414730415151424641456b4151514257414763415167424c414545415267424e414545415967424241454541644142424145634164774242414659415a77424341456741515142474145454151514256414545415151426f4145454152414252414545415667426e414549415951424241456341565142424147454164774242414845415151424941476341515142504145454151674250414545415241426e41454541565142424145494164414242414563415751424241464941515142424148634151514249414545415151426b4146454151514235414545415341426e414545415677424241454941517742424145514163774242414651415551424341456f4151514246414773415151425441454541516742554145454152514252414545415551423341454941524142424145554153514242414751415a774243414551415151424841474d4151514252414645415167417a4145454152514272414545415551426e4145494151674242414563415977424241464d41555142434146594151514247414545415151426b4146454151514178414545415267424e4145454156674242414549414e674242414567415651424241474d41515142424144494151514246414863415151426a41486341516742474145454152514246414545415551425241454941516742424145554152514242414655416477424341464941515142494145304151514258414763415167424341454541525141774145454159774233414549416341424241455541647742424146454155514243414549415151424941474d41515142534145454151674253414545415267427241454541564142424145494154414242414563414f4142424146634155514243414849415151424641455541515142614148634151674247414545415251424a414545415551425241454941556742424145554156514242414649415151424341454941515142474145554151514253414645415167417a414545415277426a41454541576742334145494152774242414551415751424241465141555142434146674151514246414773415151426b414863415167426141454541525142464145454156774252414549415251424241455941575142424146554155514243414649415151424641484d41515142534145454151674248414545415277413041454541565142524145494162774242414567415551424241464541647742424144554151514245414545415151425841464541516742564145454152674246414545415a41426e414549414d414242414555415977424241464541555142424148634151514246414863415151426c4147634151674253414545415341424e414545415641426e414549415341424241455541597742424145304151514243414745415151424841456b4151514256414645415167417841454541527742524145454155514233414545414e514242414551415151424241465141515142424144414151514249414645415151424e414545415167424e41454541526742524145454156514252414549414d674242414567415551424241464541647742434144554151514245414545415151425841476341516742704145454152674246414545415a41424241454941547742424145554154514242414534415a7742424148634151514246414863415151424f4148634151674253414545415341424e414545415a414242414549415241424241455141555142424145304151514243414530415151424841484d41515142614148634151514233414545415251423341454541566742424145494155674242414567415551424241466f41515142434145514151514244414467415151424e414545415167424e4145454152514252414545415651426e4145494162674242414555414e41424241464941647742434145514151514245414545415151425541454541516742464145454152674246414545415a41426e4145494154774242414555415451424241453041555142424148634151514246414863415151424e4148634151674254414545415277426a414545415951425241454941525142424145594152514242414749415a774243414538415151424641474d415151425741486341515142334145454152514233414545415451423341454941556742424145674155514242414651415a774243414551415151424441484d415151424e4145454151674261414545415267426e4145454156514252414549414d67424241456741555142424146454164774242414863415151424541454541515142584147634151674270414545415267424641454541597742334145494163514242414555415751424241474d4164774243414534415151424641474d415151426941486341516742494145454152514246414545415451425241454941566742424145554156514242414645416477424341444d415151424941476341515142684147634151514233414545415251427a41454541565142424145494155674242414567415751424241453841555142434145674151514246414555415151424e414545415167424e4145454152514252414545415651425241454941656742424145674155514242414645416477424241444d4151514245414545415151425841476341516742704145454152674246414545415a41426e414549416177424241455541545142424145384155514242414863415151424741477341515142504145454151674275414545415251427a414545415641426e4145494152414242414563414d414242414530415151424341453041515142474147634151514256414645415167417941454541527742524145454155674233414549415241424241455141515142424146634155514243414549415151424941454541515142544146454151674250414545415251426a414545415551426e41454541647742424145554164774242414663415151424341464d415151424841474d41515142554147634151674249414545415251424e414545415451424241454941545142424145634162774242414655415a774243414738415151424641445141515142534148634151674259414545415241424241454541564142424145494165514242414559415251424241474d4164774243414538415151424641474d415151425341486341515142334145454152674276414545415751426e4145494155774242414563416477424241475541555142434145554151514247414555415151426b4146454151674177414545415251424e414545415467423341454541647742424145594161774242414534416477424341464d415151424841476341515142504146454151674249414545415267426a41454541545142424145494154514242414555416177424241466f41647742424148634151514246414773415151425a41476341516742534145454152774233414545415641426e4145494152414242414559415651424241464d41555142434145384151514246414530415151425a41486341515142334145454152674276414545415751426e4145494155674242414567415751424241466f41515142434145514151514245414545415151424e414545415167424e414545415241426a414545415651426e414549416277424241456341555142424146454164774242414849415151424541454541515142554145454151674256414545415267424a4145454159674242414549414d4142424145554154514242414755415551424341453441515142474147634151514252414645415167417a414545415277424a414545415767423341454941576742424145554155514242414659415a774243414649415151424741455541515142534145454151674246414545415251426a414545415767426e41454941556742424145634163774242414651415a774243414551415151424541466b415151424e414545415167426141454541525142524145454156514252414549414d41424241456341555142424146454164774242414863415151424541454541515142554145454151674278414545415267424a4145454157674233414549414d41424241455541545142424145734164774242414863415151424641486341515142554145454151674253414545415341424e414545415641426e414549415241424241455141617742424145304151514243414530415151424841473841515142564146454151674178414545415267424e41454541556742424145494155774242414563415a77424241475141515142434145514151514245414555415151424e414545415167424e414545415241424e414545415651426e414549416267424241456741555142424146494164774243414549415151424641477341515142554147634151674249414545415251424a41454541545142424145494154514242414559415a774242414655415a77424341473441515142464144514151514253414863415167424541454541524142424145454156414242414549416351424241455941535142424147454151514243414538415151424641474d415151425741486341515142334145454152514233414545415977426e41454941556742424145674154514242414651415a774243414567415151424641474d415151424e4145454151674268414545415277424a414545415651426e4145494163774242414567416177424241464941515142434146494151514249414655415151426b4145454151674245414545415241426a414545415451424241454941576742424145514159774242414655415a7742434147384151514245414773415151425341486341516742594145454152414242414545415641424241454941536742424145634159774242414530415151424341456f415151424841456b4151514256414645415167427a4145454152514130414545415551423341454941566742424145554161774242414651415a7742434145514151514248414530415151424e4145454151674268414545415277424a4145454156514252414549414d6742424145634155514242414645416477424241486341515142454145454151514255414545415151417a414545415267424a41454541595142424145494161774242414555415451424241457341647742424148634151514246414863415151425741454541516742544145454152774233414545415a41424241454941524142424145674161774242414651415551424341464d4151514247414555415151426b4148634151674247414545415277426a4145454156774252414549415251424241455941575142424146554155514243414649415151424641466b415151425341454541516742434145454153414252414545415667426e4145494155674242414559415451424241453041515142434144594151514246414467415151425341454541516742714145454153414272414545415641426e41454941565142424145634163774242414755415a77424341453441515142464146454151514253414645415167424e41454541525141774145454155514252414549416367424241455541597742424146454155514242414867415151424741465541515142534146454151674244414545415277426e41454541564142524145494152414242414559415751424241465941555142434145594151514249414763415151425341464541516742564145454152514246414545415651424241454941517742424145634159774242414651415a774243414663415151424641456b41515142524146454151674271414545415251417741454541555142334145494154774242414555415451424241466b41555142424148634151514246414863415151426841476341516742544145454152774233414545415477425241454941524142424145674161774242414651415551424341454d415151424541464541515142584145454151674246414545415267425241454541556742524145454164774242414555414d41424241465941515142434145494151514249414763415151425541476341516742464145454152514272414545415a51424241454941546742424145554155514242414645415551424341444d415151424641444141515142534147634151674232414545415267426e414545415567424241454941565142424145554156514242414530415a774243414534415151424741464541515142524146454151674130414545415251413041454541556742424145494153674242414567415a77424241465141555142434145554151514246414555415151426b414863415167424f414545415251425a4145454159674233414549414d774242414563415977424241466f41647742434145594151514249414530415151425541464541516742554145454152514272414545415a414233414549415367424241455541525142424146634155514243414555415151424741466b41515142564146454151674253414545415251427a41454541556742424145494151774242414563414e414242414655415551424341486341515142464144514151514253414863415167425941454541524142424145454156414242414549416251424241455941525142424147514155514243414538415151424641474d41515142544145454151514233414545415251423341454541545142334145494155674242414567415451424241464541647742434145554151514247414555415151426b4147634151674177414545415251426a414545415551426e414545416477424241455541647742424145344164774243414649415151424941453041515142614145454151674245414545415341426a414545415641425241454941564142424145554161774242414751416477424341456f415151424641455541515142584146454151674246414545415267425a414545415651425241454941556742424145554164774242414649415151424341454d415151424841445141515142564146454151674233414545415251413041454541556742334145494157414242414551415151424241465141515142434147304151514247414555415151426b4146454151674250414545415251426a41454541557742424145454164774242414555416477424241453041647742434146494151514249414530415151425241486341516742464145454152674246414545415a41426e414549414d4142424145554159774242414645415a7742424148634151514246414863415151424f4148634151674253414545415341424e414545415767424241454941524142424145674159774242414651415551424341464d4151514245414545415151426b4148634151674249414545415341426a414545415677425241454941525142424145594157514242414655415551424341464941515142464144414151514253414545415167424441454541526742524145454156514252414549414d674242414551416177424241464941647742434146674151514245414545415151425541454541516742564145454152674246414545415a41426e414545414e51424241455541545142424145344151514242414863415151424741477341515142544145454151674254414545415277426a4145454154774252414549415241424241456741617742424145304151514243414530415151424641464541515142564147634151674276414545415341427641454541556742524145454165414242414555414d4142424146494151514243414534415151424641474d415151425241464541515142344145454152674256414545415567425241454941516742424145674159774242414751416477424341486f4151514245414545415151425441476341516742354145454152674246414545415a41426e414549414d41424241455541545142424145774164774242414863415151424641486341515142684147634151674254414545415277426a414545415a414242414549415341424241455941597742424145304151514243414530415151424541454541515142614148634151514233414545415251427a414545415467423341454941557742424145634159774242414651415a774243414567415151424741474d415151424e414545415167424e414545415277427a414545415767423341454541647742424145554162774242414651415151424341464d4151514248414863415151426b4145454151674245414545415241425a414545415451424241454941576742424145554164774242414655415551424341444941515142494146454151514253414863415167424341454541524142424145454156414242414545414d774242414559415251424241474d41647742434144414151514246414530415151424f414545415151423341454541526742724145454157514233414549414e4142424145554157514242414755415a774243414549415151424741466b415151425241476341516742754145454152514130414545415667426e4145494151774242414555415251424241465541555142434145344151514246414645415151426b4145454151674245414545415277424641454541545142424145494154514242414551415977424241465541555142434144494151514245414773415151425241486341515141774145454152414242414545415677425241454941545142424145594153514242414749415151424341444141515142464145304151514250414645415167424f414545415267424e4145454156774252414549414d7742424145554162774242414645415551424341466f41515142464146454151514257414763415167425341454541526742464145454159774252414549415251424241455541535142424145304164774243414649415151424941456b415151426b414545415167424941454541525142464145454154514242414549415951424241456341535142424146554155514243414445415151424741453041515142534145454151674253414545415277427a414545415a414242414549415341424241455941597742424145304151514243414530415151424941456b41515142564147634151674275414545415341425241454541555142334145454163674242414551415151424241466341555142434145554151514247414555415151426b4147634151674177414545415251424e414545415a51425241454541647742424145554164774242414745415a77424341464d4151514248414763415151426c414763415167424741454541526742464145454156414252414549415167424241455141555142424146494164774243414549415151424541455541515142574146454151674247414545415251424a4145454156514252414549414d774242414555415a77424241465141555142434146554151514247414773415151424e414545415167424f41454541526742524145454155774252414545414d414242414555414f4142424146594151514243414559415151424641486341515142554146454151674243414545415277427a4145454155674233414549415167424241455141525142424146594155514243414559415151424641456b4151514268414545415167424f414545415251424e414545415667426e414549415667424241455541565142424147554151514243414559415151424941473841515142524146454151674254414545415251424a414545415767423341454941547742424145594157514242414645415a774243414549415151424841453041515142554146454151674245414545415341425241454541555142334145494162414242414551415151424241465141515142434146554151514247414555415151426b4145454151674272414545415251426a414545415551426e414545416477424241455541647742424146454155514243414451415151424641466b415151426c4147634151674243414545415267425a414545415551426e4145494162674242414555414e414242414659415a77424341454d41515142464145554151514261414863415167424f4145454152514252414545415a414242414549415241424241456341565142424145304151514243414530415151424741464541515142564146454151674177414545415277425241454541556742334145494151774242414551415151424241466341555142434144594151514247414555415151426b4146454151674177414545415251424e414545415a4142334145494154674242414555416177424241464d415151424341445541515142464144414151514254414645415167424a4145454152514276414545415551426e4145494162674242414567415451424241474d4155514243414738415151424841477341515142564146454151674245414545415251424641454541565142524145494152674242414555415351424241464541555142434146494151514246414441415151425241476341516742434145454152674252414545415551423341454941517742424145674156514242414659415151424341454d415151424541455541515142554146454151674243414545415277424e414545415551423341454941516742424145634159774242414649415551424341454d4151514246414555415151426141486341516742474145454152514177414545415551425241454941626742424145554156514242414645415551424341454d415151424641453041515142534146454151674253414545415341425a414545415a4142524145494155514242414563415351424241466b415551424341444541515142494145554151514261414645415167424a4145454152414252414545415677426e41454941575142424145634162774242414649415551424341466b415151424641456b4151514254414763415167426841454541526742524145454154414233414549416377424241455541545142424146514164774243414659415151424941454541515142504146454151674271414545415241425241454541537742334145494155774242414563415a7742424145734164774243414745415151424741456b41515142574146454151674244414545415277424e414545415977424241454941565142424145514151514242414755415a77424341473441515142464146554151514252414863415167424b4145454152674246414545415551423341454941516742424145554152514242414645415551424341454941515142464145554151514252414645415167424341454541525142464145454155514252414549415167424241455541525142424146454155514243414549415151424641455541515142524146454151674243414545415251424641454541555142524145494151674242414555415251424241464541555142434147454151514245414555415151426841486341516742764145454152514134414545415a41426e41454941534142424145554154514242414534415a77424341466f415151424841466b41515142574145454151514177414545415267426e41454541575142334145494156674242414563416377424241464d415151424241486741515142464147634151514253414545415167425341454541526742464145454159514242414549414d41424241456341597742424145774164774243414651415151424541456b415151425541476341516741324145454152774134414545415977425241454941565142424145594152514242414745415a774243414451415151424841476341515142524146454151674270414545415341427241454541597742424145494153514242414555415651424241466f4155514243414734415151424641456b415151424c4148634151674270414545415251425241454541555142524145494154514242414555416277424241474d4164774242414867415151424741466b415151425a414763415167424c414545415341424e4145454156414233414549416251424241455941545142424146494151514243414449415151424641484d415151425641486341516742324145454152514246414545415551426e4145494152674242414555415451424241474d41515142424148674151514249414655415151426b4145454151674248414545415241426e4145454156674242414549414e414242414567415977424241466f416477424341485941515142464146454151514253414645415167427a414545415277413041454541597742334145494163514242414555415a774242414530415551424241444941515142494146454151514250414645415167427a4145454152774276414545415977426e4145494164774242414555414d414242414645415551424241486f415151424641484d415151425641476341515142334145454152414252414545415451426e4145494157414242414567415751424241475141647742434145734151514248414530415151426a4145454151674251414545415251425a41454541544142334145494163514242414567415151424241466b4164774243414734415151424541453041515142534148634151674248414545415277424a4145454156514252414545414d674242414555416377424241464d415a774243414773415151424841466b41515142524148634151514130414545415251426e4145454157674252414549416467424241455141535142424146554155514242414441415151424941464541515142574148634151674256414545415341424641454541564142424145494151774242414563415651424241466f415a774242414863415151424641456b41515142544146454151514279414545415277424a414545415751426e41454941635142424145514157514242414755415151424341466b415151424841484d4151514253414645415167424341454541534142724145454156514252414549415167424241455541535142424146454164774243414559415151424841453041515142564147634151674257414545415277425a414545415451423341454541646742424145634156514242414538415151424341456b415151424741466b415151426b4147634151674130414545415251425241454541575142334145454165514242414551415251424241474541515142434147734151514246414530415151424f41476341516741314145454152514177414545415a51426e4145494153674242414563414d4142424145344151514243414445415151424641484d415151426a4146454151674256414545415341427641454541565142424145494154514242414555414e414242414659415551424241444d415151424641444141515142684148634151674272414545415277426a4145454155674233414549414d77424241455941525142424146454164774243414845415151424841474d4151514261414863415167424e41454541517741344145454156414252414549415367424241455541617742424146454164774242414849415151424941473841515142524146454151674233414545415251424a41454541576742334145494154774242414559415751424241464d415151424341464941515142454146454151514253414645415167424b414545415277426a414545415651425241454941626742424145514157514242414749415a77424341484141515142494145454151514253414645415167424a4145454152514130414545415977423341454541636742424145554159774242414749415151424241444141515142484148634151514257414545415167426841454541525141304145454154674252414549415951424241456741617742424147514151514243414651415151424641456b415151424d4148634151514130414545415267426a414545415667426e41454541654142424145554162774242414538415551424241445141515142474145454151514253414645415167424641454541517741344145454156414233414549414d674242414567415251424241474d415a774243414855415151424741474d4151514252414763415167427a414545415277424e414545415a414233414549415441424241456741597742424146634155514243414555415151424741466b415151425641476341515142334145454152774276414545415551426e41454941524142424145594152514242414751416477424341456f4151514248414467415151425241464541516742754145454152674242414545415a414252414545414d514242414559415451424241465941515142434144594151514249414655415151426a41454541515141794145454152514233414545415a4142424145494152514242414567415751424241466f415151424341444d4151514245414555415151424e414863415167426f4145454153414242414545415567423341454941636742424145674157514242414649416477424341486741515142494145304151514253414545415167424f414545415251426a41454541545142524145494164774242414563415451424241475141555142434145674151514246414441415151424e4148634151514279414545415267425a4145454156514252414549415477424241455541565142424146594164774243414577415151424841484d415151426b414863415167424e414545415341426a414545415677425241454941525142424145594157514242414655415a774242414863415151424741455541515142524147634151674245414545415277426a414545415a41423341454941537742424145674152514242414645415551424341464d415151424641474d4151514252414645415151413041454541534142724145454156414252414549415251424241455541565142424145304151514243414534415151424741464541515142524146454151674130414545415251413041454541556742424145494153674242414567415a77424241465141555142434145554151514246414555415151426b414863415167424f414545415251425a414545415977425241454941627742424145554156514242414655415a7742434147344151514247414545415151425541464541516742784145454152514246414545415a51424241454941547742424145634162774242414649415551424341444d4151514246414441415151425741454541516742534145454153414272414545415641425241454941565142424145554152514242414751416477424341453441515142464146454151514252414763415167426f41454541525141774145454155514252414545414d41424241455541597742424146454155514242414867415151424741465541515142614145454151674246414545415341426a4145454155674252414549415177424241454d414f414242414751416477424341464941515142464146554151514252414645415167417a41454541525142724145454155674233414549414d77424241455541555142424146454155514243414745415151424641456b41515142614148634151674250414545415267425a414545415577424241454941564142424145554152514242414645415a774243414549415151424841466b415151425041454541516742474145454152514252414545415a51426e4145494151674242414555414e4142424146514155514243414549415151424941453041515142534148634151674245414545415267424e414545415977425241454941534142424145554162774242414645415551424341456f415151424641456b4151514252414645415167425341454541525142564145454155514233414549415167424241456341627742424146454155514243414534415151424641456b41515142614148634151674250414545415267425a41454541557742424145494155774242414555414d414242414645415a774243414549415151424841466b415151425041454541516742474145454152514246414545415951426e41454941516742424145554152514242414651415551424341454d415151424541464541515142534148634151674245414545415251424e4145454159774233414549415341424241455541525142424146554155514243414659415151424641466b4151514252414763415167417a414545415251425641454541556742424145494151674242414559415251424241464d4151514242414859415151424641456b41515142524146454151514130414545415341426a414545415567424241454941565142424145554152514242414651415151424341454d415151424841474d41515142684148634151674234414545415277426e4145454159514252414549415567424241455541545142424146454155514243414649415151424641465541515142524147634151674243414545415277426a4145454155674252414549414d7742424145634153514242414655415551424341466f4151514246414645415151425741476341516742544145454152414242414545415651426e41454941517742424145554159774242414663415551424341444d415151424741473841515142544148634151674243414545415277425a414545415551426e4145494162674242414567415977424241474d415a77424341454d415151424841474d41515142534146454151674247414545415251424641454541567742524145494153414242414559415a774242414655415a7742434147344151514246414655415151425241476341516742444145454152514246414545415577423341454941626742424145554155514242414751416477424341444d4151514246414451415151425441486341516742464145454152514246414545415467425241454941546742424145674161774242414745416477424341473441515142464144414151514253414545415167427141454541524142564145454156414252414549415251424241456341597742424147514164774243414538415151424841455541515142524146454151674232414545415251424a4145454157674233414549414d7742424145674153514242414645415a774243414734415151424641465541515142534146454151674243414545415267427241454541556742334145494157514242414559415351424241466f4164774243414559415151424641456b41515142524147634151674243414545415251426a4145454157674233414549415341424241455541525142424147514164774243414667415151424841465541515142574148634151674177414545415341425a4145454157514233414549415341424241456341647742424145304151514243414767415151424741474d415151424f4146454151674243414545415277424a414545415451426e4145494155774242414563416477424241466b416477424241486f41515142464144514151514268414545415167424e41454541527741774145454157674242414549414d6742424145634155514242414745415551424241444541515142454145554151514258414645415167426f4145454152514246414545415677424241454941517742424145634159774242414749416477424341486b415151424641456b4151514261414863415167424741454541525142564145454155514252414549415767424241455541617742424145304164774243414563415151424641455541515142544146454151674246414545415277413441454541555142524145494163674242414555414d414242414645415a77424241445541515142464145304151514261414863415167424f41454541525142524145454155674252414549414d414242414555414e414242414745415a77424341476f415151424941474d4151514256414863415167425341454541526742724145454155674242414549415677424241455941535142424145304151514243414730415151424641456b4151514253414645415167424b414545415341426a41454541565142524145494152514242414555415251424241457341647742434148594151514246414645415151426c4146454151674275414545415251413441454541596742334145494157674242414551415551424241466b415551424341456b415151424741456b415151424e414545415167427141454541525142524145454159674233414549414d6742424145554164774242414530415a7742434145634151514248414738415151425a4148634151514235414545415341425241454541597742424145494159514242414555415977424241465541555142434144454151514247414738415151424e4147634151514131414545415241424a4145454156414242414549416451424241455941575142424147454151514243414530415151424541456b415151425641476341516741794145454152774252414545415451426e414545414d514242414567415451424241466b415a77424241486b415151424641466b4151514268414863415167424e414545415241424a414545415641426e414549414e514242414563415351424241464d4151514243414534415151424941466b415151425641464541515142334145454152514256414545415a41424241454941546742424145514151514242414659415a774243414563415151424741456b415151425741454541516742574145454153414272414545415641426e41454941526742424145594161774242414751415151424341464d415151424841445141515142574147634151674236414545415277424a4145454155514233414545414d514242414563416277424241466b4164774243414851415151424941474d415151426b4148634151674255414545415277426a414545415677425241454941525142424145594157514242414655415a7742424148634151514249414655415151425241476341516742474145454152514177414545415a414233414549415567424241455941555142424146454155514242414859415151424841446741515142534145454151514235414545415277426a4145454156414233414545414d41424241455941617742424145344155514243414767415151424641476341515142564147634151514233414545415277424e414545415567424241454941646742424145674157514242414651415151424241486b415151424641466b41515142684147634151674271414545415241424a414545415a4142424145494164774242414559416277424241464941647742434146494151514249414655415151425841476341515142354145454152414272414545415451426e4145494154514242414563414e414242414659415a7742434147384151514246414863415151424e4147634151674254414545415341425a41454541576742424145454165514242414551415651424241474d416477424341476b415151424541456b415151425341476341516742794145454152514233414545415451426e4145494154774242414567416177424241466b415a77424341456b4151514246414441415151426b414763415167425341454541524142424145454155674252414549414d414242414555414d4142424145304151514243414663415151424641466b415151425641476341516742564145454152674256414545415a514252414549415477424241455541565142424146634155514243414441415151424741456b41515142534148634151674258414545415341424e414545415767424241454941534142424145554156514242414751415551424341466f4151514245414530415151425441476341516742364145454152514177414545415577425241454941534142424145554161774242414645415a774243414734415151424841474d415151426a4147634151674244414545415277426a414545415567425241454941527742424145554153514242414655415551424341476f415151424641456b41515142524146454151674253414545415267424a41454541547742424145494154674242414555415a774242414749416477424341444d41515142464144414151514252414645415167426141454541525142724145454155774233414549414d7742424145594161774242414645415a77424341454d41515142474145554151514257414645415167424a414545415251417741454541555142524145494153414242414555415977424241464d415a7742434145674151514248414763415151424e4145454151674272414545415251426e4145454155514252414545414d674242414555416477424241475541555142424144554151514248414763415151425841464541515142364145454152514130414545415977426e41454941614142424145594159774242414655415a774243414849415151424641486341515142694146454151674272414545415341425a414545415767424241454941634142424145514156514242414530415551424341466f415151424741453041515142504146454151674132414545415267427641454541567742424145494153774242414551415351424241466b415551424341466741515142464144514151514269414545415167427141454541534142724145454154774252414549414d67424241455941617742424145304164774243414538415151424941474d41515142554145454151674132414545415251424a41454541556742334145494151774242414563415977424241466f416477424341486b415151424641456b41515142614148634151674247414545415251425a414545415551426e414549415567424241456341545142424147514164774243414549415151424841446741515142584146454151514179414545415277424641454541557742424145494155774242414551415151424241466b41647742434145554151514248414467415151426b414763415167424e414545415241424a414545415567426e41454941635142424145634154514242414530415a7742434144414151514249414545415151425841476341516742494145454152674246414545415a41425241454941595142424145514153514242414538415551424241486b415151424641486341515142694147634151674258414545415277426e414545415641424241454541655142424145594153514242414751415a774243414773415151424541456b415151424f4146454151674236414545415277424a414545415451426e41454941527742424145634163774242414651415151424241486b4151514246414451415151426941454541516742714145454152774130414545415651426e41454941647742424145594162774242414749415551424341484d41515142484147384151514258414645415167425a414545415267424a4145454159674242414549416167424241456741617742424145384155514243414738415151424841456b41515142534148634151674130414545415277426e41454541567742524145454165674242414555414e41424241474d415a774243414767415151424741474d415151425641476341516742794145454152514233414545415967426e4145494151674242414551415451424241466341555142434148454151514246414555415151424d4148634151674244414545415277426a41454541576742334145494165514242414555415351424241466f4164774243414559415151424641466b41515142524147634151674253414545415277424e414545415551426e414549415241424241456741597742424146554155514243414459415151424641444141515142534145454151674247414545415341426a4145454156414242414549414d774242414559416177424241464d4155514243414577415151424941474d41515142584146454151674244414545415251424a41454541565142524145494156674242414555415a774242414651415551424341454941515142464144674151514253414863415167424b414545415241424a41454541595142424145454164774242414563415551424241464d4151514243414549415151424541466b415151425541454541516741314145454152414272414545415951424241454941576742424145514154514242414651415a77424341486b415151424841455541515142574148634151674254414545415277427a414545415641424241454941644142424145634155514242414751415a7742434147734151514248414773415151424f414645415151423441454541526742724145454156514233414545414e5142424145674162774242414663415a77424341466b4151514246414738415151424e414763415167426f414545415267426a414545415641426e4145494163774242414563415451424241475541555142424144554151514245414545415151425a41486341515142364145454152514246414545415a41426e4145494154674242414555415651424241465941555142434145674151514246414555415151424e4146454151674257414545415277425241454541555142334145494155674242414559415251424241457341647742434145344151514246414645415151426b414863415167417a414545415251426e41454541555142524145494157674242414555414d41424241464d4164774243414859415151424741477341515142684148634151674243414545415277426a414545415567425241454941517742424145554152514242414655415551424341486f415151424641456b415151425241476341516742434145454152514272414545415551426e41454941546742424145594152514242414751416477424341465541515142464145304151514268414763415167424f4145454153414272414545415641426e41454941565142424145594156514242414534415551424341453441515142474146454151514268414863415167417a414545415251417741454541566742424145494157674242414567415977424241464d415151424341454941515142474147734151514255414645415167424d414545415277413441454541567742524145494163674242414555415251424241466f4164774243414559415151424641456b41515142524146454151674253414545415341424e414545415551426e41454941517742424145554152514242414649415551424341454d41515142464144414151514256414645415167417a414545415267425241454541555142334145494163514242414555414d4142424147554155514243414538415151424741464541515142574146454151514178414545415251417741454541566742424145494163674242414567415977424241465141555142434146554151514247414773415151426b41486341516742464145454152674246414545415677425241454941545142424145554163774242414749416477424341466f415151424841484d415151425241464541516742754145454152514256414545415551426e41454941516742424145594152514242414649415551424341455541515142464145554151514256414645415167424741454541525142524145454156514252414549414d77424241455541525142424146494155514243414649415151424641477341515142694146454151674236414545415341424e41454541547742524145494155414242414559415a77424241465941647742424144554151514246414773415151425341486341516742434145454153414276414545415651425241454941645142424145514153514242414655415a774243414559415151424841466b415151424d414863415167417a4145454153414242414545415a51426e4145454163674242414555414d414242414663415151424341464d4151514245414645415151425a414863415167425641454541526742524145454156414242414549414d774242414559415151424241474541647742434148594151514246414530415151424e4145454151674245414545415251424e414545415641423341454941537742424145674157514242414645415a774243414530415151424941456b415151426841454541516742554145454152514252414545415467423341454941535142424145554157514242414751415151424341465541515142494145304151514256414863415167424d414545415251417741454541575142334145494153774242414555415977424241466f415a774243414659415151424541474d41515142554147634151674245414545415251424e414545415651425241454941625142424145594154514242414534415151424341477741515142484146454151514256414763415167424441454541534142524145454155674252414549414d5142424145674151514242414755415a774243414567415151424841477341515142614148634151674245414545415251425a4145454155774252414545414f514242414551416377424241465541647742434147674151514249414645415151424a4145454151674251414545415277424e414545415a414242414545415a774242414551415251424241453441555142424147634151514245414545415151424e414545415151413241454541524142424145454154514242414545414e6742424145514151514242414530415151424241476341515142464146554151514253414645415167425541454541526742524145454153514242414545416551424241455141515142424145304155514242414449415151424541484d41515142574148634151674273414545415277425241454541535142424145494155414242414563415451424241475141515142424147634151514245414555415151424f414645415151426e41454541524142424145454154514242414545414e674242414551415151424241453041515142424144594151514245414545415151424e414545415151426e414545415251425641454541556742524145494156414242414559415551424241456b415151424241486b4151514245414545415151424e4146454151514177414545415377424441454d4151674177414863416477426e414763415a41424a414530415351424a414563414f41424c414545415241424241476341525142444145454161414252414373414e77427341456f41554142504144594162674276414855416477425241454541515142424145494153674244414867416177424241486b416551424a41484d415151424541454541546742434147634163774278414767416151425241454d415151425241455541516742424146454154514243414545415641424441454d4151514259414738416541425a41476f415167426e414549415a77424f414659415167424241473841545142584147514151774248414441415441417a414649416141424f41454d414b77417741466b41524142524148594154674244414863414d41425a41474941556742734148514151774131414441415441417a414645416467427041444d41555142304145344151774172414441415441424d414649416241423041454d414d4141774145774163674252414859416441424441486b414d41424d41476f415551423141464d41524142524148514154674244414445414d41424d414338415551427a4145344152774242414441415751424d414645416377424f41454d414f4141774145774157414252414859415a41424841454d415351424f41454d415977417741466f4159674252414859415a414244414441414d41424d414463415567426f41475141517741724144414154414255414649416241423041454d416551424e4146634164774233414745415a77425a414551415667425241464541544142454145634155414252414738414f514244414338414d41425a414551415551427a41453441517742354144414154414232414649416241423041454d414f514177414577414d77425341476f4165514242414738414d41424c41474941555142304147514151774135414441415751424d414649415a774244414773415a77417741466b4153414252414851415a414248414545414d41425a414577415551423141453441527742464144414157674269414645416451423041454d416477417741466b41596742534147774164414248414667415351424f41454d414e674177414577416467425341476f4164414248414567414d414261414749415551427a41476b41524142524147674164414244414655414d41424b414645415a77417741456f4165674253414777416441424441446b414d41424d414651415551423241485141527742474144414154414133414645416441424f4145634156774177414577415351423441474d4152414243414855415167426e4145344156674243414545415451424e41466f414f514244414645414d41424d414849415567426e41453441517741784144414154414255414645416451424f4145634151774177414577414e77425241484d4164414244414863414d41424d41444d4155514231414534415177413141456b4154674248414563414d41424d414667415551423241475141527742444144414157514242414763414d41425a41456741555142304147514152774242414441415751424d414645416451424f414563415251417741466f41596742524148554164414244414863414d41425a4147494155674273414851415277425941456b4154674244414459414d41424d4148594155674271414851415277424941444141576742694146454163774270414551415551426f41485141517742564144414153674252414763414d41424b41486f41556742734148514151774135414441415441425541464541646742304145634152674177414577414e7742524148514154674248414663414d41424d41456b41654142474145514151514254414549415a77424f414659415167424241465541545142444144454156674243414577415641424e414451415467423641456b414d5142504146514154514233414530415551427a414863415177425241466b41524142574146454155514248414555416477424b4146594155514255414555415567424e414545414f414248414545414d5142564145554151674233414863415351417741456f41636742524148554154674248414667414d41424d41456b4164774249414767415977424f41453041564142524148674154514245414555414d41424e41476f41525142334145304152414242414863415677426f41474d415467424e414651415751423441453041524142464144414154514271414555416477424e4145514151514233414663416167424441454d4151514254414863416541424a41476f415151426e414549415a77424f4146594151674242414738415451424841475141517742724144414157674269414645416441413541454d414e41417741466b415a674252414859415a414244414863415351424f41454d414b77417741466b41534142524148594164414244414867414d41424d414545416541424a41476f415151426e414549415a77424f414659415167424241484d415451424841475141517742724144414157674269414645416441413541454d414e41417741466b415a674252414859415a414244414863415351424f41454d414b77417741466b41534142524148594164414244414867414d41424d41454541654142494146514151514269414549415a77424f4146594151674242414863415451424741453441517741764144414157674269414645416441424f41454d414c7741774145774161674253414763415a414248414551414d41424d414577415551427a41453441527742494145304156414256414863415451423341466b415241425741464541555142454145514151774236414645416251423041454d414b774177414577414c774252414855415467424841454d414d414261414749415551423241464d41524142524148494164414248414545414d414261414749415551423141464d41524142524147734164414248414663414d41424d414849415567426e41485141517741724144414157514245414645416467423041454d4165514177414577416167425341476741656742464146674154514243414655415277424241444541565142464145494151514233414538414d41424b414849415551423241485141517741764144414154414271414649415a7742304145634156774177414577414d41423441456f4161674242414773415167426e414534415667424341454d416277424e414567415a414244414855414d41425a4145514155674273414851415177413141456b415467424441464d414d414261414749415551423141485141527742444144414154414133414649415a77424f41454d414b774177414577415441425241485541546742484145674154514253414545416477424541476341575142454146594155514252414559415241424241474d416541424f41476f4155514234414530416167426e414455415451425241484d416477424441464541575142454146594155514252414563415251423341456f41566742524146514152514255414530415167424641456341515141784146554152514243414863416477424c4144414153674133414645416441424f41454d414d51417741466b415341425241484d415241424641466741545142434146554152774242414445415651424641454d4151514233414538414d41424b414463415551423041453441517741784144414157514249414649416167424f41454d414e6741774145774151514233414763415a67424a414863415a77426a414773415277424441486b416351424841456f415151424a4145494151514252414555415167424241486341525142434145304153514248414455415451424941465541647742434148634153514244414545415551424641454d41515142524148634151774242414645415151424641456b4155674244414373414e4141354148514163514132414841414e41426d414767416241426c414530415567426a4145554162414273414641414b77425641456b414e514254414734414d51423641476f414e514248414567414e514273414559415551424741486b41624142514146514154774242414645415351426f414545415351424241454541515142424145454151514242414545415151424241454541515142424145454151514242414545415151424241454541516742754146634155774246414459414f41425a414577416341426f41446b415541426f4147514165414254414645415a67425641474d415467424341454d4152774179414551414f51424d41466b414d77425041476b416341424f41454d41554142484145554151674232414573416177426a414649414e674242414567414e51427a414530415151427a41473041656742574146594163774274414863414e51413541456b4154774134414841415377426e41454541525142524145734162674258414459414d414259414867415541424941454d415177426e4145304155774258414755416551424e414759415741427841444d414d6742584145384164514272414863415241426a414841415341425541476f4157674268414338415151427341486b4161774130414667414b774250414777416551424541474d4157514257414851415241427641473841624141784144674154414233414751414e67427141466f415241427041444541576742504147384163774247414455414c77425241455541616741314148514164514251414849415267426c414645415551424541456f415151424241455541535142534148674152674253414338415a674135414463416477426b414663414c77424641453441656742694146634152674177414577416367424a41486f415451427041474941615141304148454163414251414530414f41427a414445415641427a41486b41556741794145454159674243414545415377425041454d4151514232414467416477426e414763415441413341453041517742724145634151514178414655415a41424541476341555142704145494151774245414845415a51424c414773415551426a41444941656741304147454157414270414659415467427241444d4162414275414573414d51424a414567414c77423441466f4157414256414734414d7742334144674155514251414467414e674172414845416451426b41466b415277425741486f4151514279414549415a77424f4146594153414254414530415251424b41455141515142704147634151774242414373414e77427341456f41554142504144594162674276414855414d41425041446b414d774245414667415a414278414773415951425441446741595142784148634154514233414749415677427341486b414e41425a41486f415a674131414659415151417741464941575142784146514151514232414549415a77424f4146594153414253414545415251424c4145514151514274414738415167424641466b415241423641456b416477424e414651415551423441453041524142464144414154514271414555416477424e414551415151423341466341635142464146494152774242414467416551424e41455141525141794145304156414242414867415467424541456b416541424e41455141515142334145304152674276414863415241426e41466b4152414257414649414d414251414545415551424941433841516742424146454152414242414763415967424241453041516742724145634151514178414655415a41424a4145454152514243414338416477425241464141545142424144414164774244414863415751424b414573416277425a414773415151426e4145554151674242414645415351424441453041515142334145634151514178414655415a4142464148634152514243414338416477425241454d41545142424145454164774249414763415751424a414573416477425a414549415167425241465541534142424146454154514243414545415a6741344145554152414236414545415467424e414545416377424841454d4155774278414563415367424241456b415167424241464541525142444145454156414243414851415167426e4145344156674249414649415251424641466f41616742434147734162774243414467415277424541454d41637742484145454155514252414549415a7742614147514152774242414645415251424641454541635142424146414152414242414441416277424e41455141617742364145734155774242414863415467423641477341647742504145514151514178414738415177426e414563415241424441484d41527742424146454155514243414763415767426b41456341515142524145554152514242414745415151425a4145514151674261414455415951417941446b4164774268414667415567427741474941617742434148594157674248414659416567426a414449415251423141466f414d67413541444941544142754146594161414276414549415977424841454d416151427a4145634151514252414645415167426e41476f4159774256414545415a774250414763415177425241486341534141774145734151514233414530415577417741444941546742364145494153674243414763415467425741456741556741344145554155514271414549415151424e414551414e67426e41464141537742424144594161414271414767416277426b4145674155674233414538416151413441485941575142584145344165674268414449416241427241466f4151774131414734415967417a41466b416451426b414663415251423241466f415277413541444d4159674274414867416467425a414663415551423241466b414d77424b41484d415977423541446b415241425241464d414d4142364146494156514257414559415467425541456b414d41425341476b414d514248414751415677423441484d41544142744145344165514269414551415167424c414549415a77424f4146594153414254414451415251425241486f415167424341453041524141724147634155414268414545414e77426f41476f416241427641475141534142534148634154774270414467416467425a4146634154674236414745414d6742734147734157674244414455416267426941444d41575142314147514156774246414859415767424841446b414d774269414730416541423241466b4156774252414859415751417a41456f416377426a41486b414f514245414645415577417741486f4155674256414659415267424f414651415351417741464941615141784145554157674258414867414d41425a41464d414e51427141474d4162514233414863415a77425a414763415277424441454d416377424841454541555142564145594151674233414555415167424341456741647742334147554161674242414863415167426e41476341636742434147634152514247414549415551426a414863415151425a41466b4161774268414567415567417741474d41524142764148594154414179414559416167426a414449416441427741466f4152774252414855415767417941446b414d67424d414734415667426f414577414d77424f414777415977427541466f416341425a4144494156674236414577414d67413541476f415977417a414545416467424e414555415751424841454d415177427a4145634151514252414655415267424341486f41515142444147674161674277414738415a414249414649416477425041476b414f41423241466b415677424f41486f4159514179414777416177426141454d414e514275414749414d77425a414855415a4142584145554164674261414563414f51417a41474941625142344148594157514258414645416467425a414449415667423541475141527742734147304159514258414534416141426b4145634156674236414577414d67424741484d4159674248414559416167426a414449416441427741466f41527742524148554159774245414751416151424e414551414f41424841454d415177427a41456341515142524146554152674243414863415251424d414549415241424e41486341545142554145454164674243414763415a774279414549415a774246414559415167425241474d4164774242414451415751427141474541534142534144414159774245414738416467424d414449415267427141474d414d67423041484141576742484146454164514261414449414f5141794145774162674257414767415441417a414534416241426a414734415767427741466b414d67425741486f415441417a414649416567426a41454d414f414233414649415551425a41455141566742534144414153674243414551414e414233414641415241424241474d415167426e414863416351426f41476b41555142444145454155514246414549415177423341455541525142424147634152514234414551415167424e414573415451423641456b414d51424f41465141617742344145384156414242414867415467427141454541597742434147634164774278414767416151425241454d41515142524145554151674244414863415251424641454541555142464148674152414243414530415377424e41486f415351417841453441564142724148674154774255414545416541424f41476f415151424f414549415a77427a414845416141427041464541517742424146454152514243414545415551424e41454941515142524145344152414242414545415567424241476b415951423541486f414d41413141475141596741774147634157514245414534415177426d41466f4152514253414338414c7742444147344155414130414867415a414249414767416541424f4145304164674242414373415577426e414577415551424a41456b414e4142744144674152514231414855415267424a414641416377426a414663414d5142504148674153514276414867416477427241466f414f51425541484d414d41424a41456f41516741354145774161414131414445415251424841444141557741324147344154514268414573415151424a414655416167424841454d415177424841474d416477426e4147634161414271414545415a774246414549415451424a41456b4151674273414551415177424441454541574142764148674157514271414549415a77424341476341546742574145494151514276414530415677426b41454d4152774177414577414d7742534147674154674244414373414d41425a414551415551423241453441517742334144414157514269414649416241423041454d414e514177414577414d774252414859416151417a414645416441424f41454d414b77417741457741544142534147774164414244414441414d41424d4148494155514232414851415177423541444141544142714146454164514254414551415551423041453441517741784144414154414176414645416377424f414563415151417741466b415441425241484d4154674244414467414d41424d4146674155514232414751415277424441456b415467424441474d414d414261414749415551423241475141517741774144414154414133414649416141426b41454d414b7741774145774156414253414777416441424441486b41545142584148634164774268414763415751424541465941555142524145774152414248414641415551427641446b41517741764144414157514245414645416377424f41454d41655141774145774164674253414777416441424441446b414d41424d41444d415567427141486b41515142764144414153774269414645416441426b41454d414f51417741466b41544142534147634151774272414763414d41425a41456741555142304147514152774242414441415751424d414645416451424f414563415251417741466f41596742524148554164414244414863414d41425a4147494155674273414851415277425941456b4154674244414459414d41424d4148594155674271414851415277424941444141576742694146454163774270414551415551426f41485141517742564144414153674252414763414d41424b41486f41556742734148514151774135414441415441425541464541646742304145634152674177414577414e7742524148514154674248414663414d41424d41456b416541426a4145514151674231414549415a77424f4146594151674242414530415451426141446b41517742524144414154414279414649415a77424f41454d414d5141774145774156414252414855415467424841454d414d41424d414463415551427a4148514151774233414441415441417a414645416451424f41454d414e51424a41453441527742484144414154414259414645416467426b414563415177417741466b415151426e4144414157514249414645416441426b414563415151417741466b41544142524148554154674248414555414d4142614147494155514231414851415177423341444141575142694146494162414230414563415741424a414534415177413241444141544142324146494161674230414563415341417741466f415967425241484d4161514245414645416141423041454d415651417741456f415551426e4144414153674236414649416241423041454d414f51417741457741564142524148594164414248414559414d41424d41446341555142304145344152774258414441415441424a41486741526742454145454155774243414763415467425741454941515142564145304151774178414659415167424d4146514154514130414534416567424a4144454154774255414530416477424e414645416377423341454d415551425a4145514156674252414645415277424641486341536742574146454156414246414649415451424241446741527742424144454156514246414549416477423341456b414d41424b41484941555142314145344152774259414441415441424a41454d41526742454144634164514256414773414f414133414845415a51427041446341516742424145454151514242414555416177424d41456341555142454145774153514270414863415151424e414545416477424841454d4161514278414563415367424241456b41516742424146454152514243414545415a774248414763415a77426e41466f416241424e41456b4153514243414463415551425a414577415377427641466f415351426f414859415977424f41454541555142724146454151514270414467416541426e414763415341426a414530415351424a414549414d67424541454d41517742424147514155514233414763415a7742494146454154514242414863415277424441476b416351424841456f415151424a41454941515142524145554151674242414763415251424641456b415441417241473041534142324143384165514249414455415251426c4147494159514261414573415a77424341486741645142684147634155674247414777415a5141784147454155414254414641416541426a414549415377427841473841555142324147774162774272414451416351424e41456b4153514243414734415241424441454d415151425a414573416177426e4147634152674172414530415351424a414549415a514271414559416151424e4145634151514248414545414d514256414555415177426e414867415767417741456b4159674252414859415a414248414555414d41424d414463415567426e41453441517741344144414154414245414649416141423041456341567741774145774162674252414859415a414244414373415441426b41454d414d414177414577414e77425241484d4164414248414663414d41424d41465141555142314148514151774172414441415441424d414645416451424f41454d414e51424a41453441517741774144414154414259414645416467413541454d416477417741466b41524142534147634164414244414863414d41424d41486f41555142304147514151774135414441415751424a414763414d41424b41486f41556742734148514151774135414441415441425541464541646742304145634152674177414577414e7742524148514154674248414663414d41424d41456b41654142694145514151674278414549415a77424f414659415167424241484d415451425a41446b41517742714144414154414176414649415a77424f41454d41647741774145774154414252414855414f514248414663414d41424d41444d4155514232414751415277425141456b4151774271414645416341423041454d414d514177414577414d77425341476341644142484145454153774254414551415567426e41475141517741784144414157514245414649415a77423041454d414e41417741466b41564142534147774164414244414459414d41424d414551415567426f4148514152774258414441415767426a414763414d41424d414849415551423141446b4152774250414441415751426d414649416241423041454d416551424a41453441517742484144414153674255414645416241424441455141555142754145344152774258414441415441417a414645416441424f41454d414b77417741466b41574142524148594164414244414441414d414261414749415551427a41476f4152674233414530415277413041456341515141784146554152514242414863416541427541444141536742454146454164514230414563415151417741457741574142524148514154674244414451414d41425a414577415551423241485141517742354144414154414245414645416467426b41454d414e414177414577416177426e4144414157514269414645416441426b41454d414f51417741466b41544142534147634151774245414649415a77426b41454d414d51417741466b41524142534147634164414244414451414d41425a4146514155674273414851415177413241444141544142454146494161414230414563415677417741466f415977426e41444141544142794146454164514135414563415477417741466b415a674253414777416441424441486b415351424f41454d415277417741456f41564142524147774151774245414645416267424f4145634156774177414577414d7742524148514154674244414373414d41425a4146674155514232414851415177417741444141576742694146454163774271414555415651424e4145494153514248414545414d514256414555415167425241486341544142574146554152514230414530416567426e41444d4154514271414655414e51424e41486f415151423441454d416567424241456f415167426e4145344156674243414545415751425541454541624142574145494154514253414555416477424541486341575142454146594155514252414567415241424241476f41555142744148514151774130414441415767426d414645416377426e41456b4156514251414855414e5142544146514165674231414841414e67424d41484d4152514242414545415151424241464d415551427a41466f415151424e41484d416151424d4145454151514233414563415151425a41456f415377427641466f415351426f414859415977424f4145454155514272414551415451425241484d415277424441464d416351424841464d415351426941444d415241425241455541534142424146514151514232414549415a774272414845416141427241476b4152774135414863414d41424341454d4155514252414867415351426e414645415a774255414851414f514245414645414c774278414573414e67424a414663414e674269414573415a414236414459416441427841476b415977423041446b414b774277414745415951417241484541564142724147304165514273414773415667427941464d416341426e41486f4156774246414863415a77426e414645415341424341476341637742784147674161774270414563414f51423341444141516742444146494151514244414559415241424841454d415151417641466b416477426e4147634155414235414549415a774272414845416141427241476b4152774135414863414d414243414549416477424c414763415a77426e414641416167424e41456b415351424541444d416477424a4145494151514236414555415477424e414545416477424841454d4161514278414563415367424241456b41516742424146454152514243414545415a774246414863415951423341466b415441424c414738415767424a414767416467426a41453441515142524147734155514242414645415577426e414667415151425341474541545142474147634151774242414645415251424841454d4161514278414563415367424241456b415167424241464541525142444145454164774246414863415451424541454541545142434147634162774278414767416151425241454d4151514252414555415167424241464541535142434145494151774243414538414d77417741453441524141724147384163674276414767415967427741484d416341417a4146414163514179414845415367423541444d414d7741324147774163414279414459416341425041464d415967424c41466341556742584148514153774274414551415467425a4146454153514246414545415651426f41484d4155414234414763415541424e41476f415151423441453441524142464148674154514245414763416551424e41476f4151514130414530416567426f414745415451425a41456b415241425841486f4151774244414545414d51426a41454d4151514252414555416477426e414763415251425541453041535142494144594154514255414467416477425141464541575142454146594155514252414573415241424541474941555142754145344152774258414441415441417a4146494162414230414563415167417741466b4154414252414851415a414248414545414d41425a414567415567426e41485141517742354144414154414130414763414d41425a414463415567426e414751415277424441444141544142714146494161414230414563415677417741466f415977426e4144414153774251414645416451423041456341515141774145774152414253414777414f51424441446b414d41424d414763416541424e4146514151514232414549415a77424f414659415167424241484d415451424c41453441517742524144414154414255414645416467424f4145634156774177414577414d7742534147774164414248414549414d41425a414577415567426e4145344151774233414441415751424d4146454164674230414563415151424a4145344151774248414441415377424d4146454162774254414551415551427741485141517742594144414153674130414867415577425541454941534142434147634154674257414549415151424e414530415551424f41454d41625141774145774157414252414859415a41424841454d414d41425a414551415551427a41453441517741334144414157514236414645416467426b41454d414e414177414577416177426e414441415441426d414645416377424f414563415167417741457741544142534147774164414244414441414d41425a414759415567426e41446b4151774235414441415441424541464541645141354145634154514177414577414d7742524148554154674244414455415351424f41454d414b77417741466b415241425241484d414f514244414863414d41424d41444141654142484146514151514259414549415a77424f41465941516742424146554154514246414559415667424341457741564142424148634154514245414555414d51424f41476f4153514235414577415641424a414863415451425541456b416541424441486f415151424b414549415a77424f414659415167424241466b415641424241477741566742434145304155674246414863415241423341466b415241425741464541555142494145514151514271414645416251423041454d414e41417741466f415a67425241484d415a77424a4146554154514242414649414d514249414755414f41427a414755415377413041454d415151424241454541515142424146454151514242414545415241427a41454541515142424145454164774245414545415751424c414573416277425a414773415151426e41455541516742424146454152514244414545415951424441454d415151426b414738416477426e4147634152674279414549415a77427a414845416141427241476b4152774135414863414d41424341454d415567424241454d415441423641456341517742424146594162774233414763415a774247414663415451424a41456b415167425641476f41517742444145454156514130414863415241424241466b415377424c4147384157514272414545415a77424641454941515142524145554151774242414645415551426e41466f4151674247414659414c77423541455141557742464145514163414232414651416241426f414763416441426d4146634162414135414855415677424b41476b4152774232414751416441425941464941515142724146414159514252414451414b7742584145774153514243414863416477426e4147634152514268414530415351424a414549415151424c41464d41516741764146514151774243414373416167424641433841545142454144414152774242414445415651424641454d415a774233414449414d41424b41486f415567427341485141517741354144414157674269414649415a77426b414563415177417741457741574142534147634154674248414549414d41425a414577415551427a414851415177417241456b4154674248414538414d41425a414567415567426e414851415177413041444141575142694146494162414230414563415741424a41453441517742714144414154414279414649415a77424f41454d416477417741466f415a674252414859415a4142444144514154514255414555416477424d41486341575142454146594155514252414577415241424441476f415551427241453441517741774144414154414236414649416241423041454d414f51417741466f4159674253414763415a41424841454d414d41425a414551415551427a41453441527742444144414154414133414649415a774244414551415551426f41485141517742704144414153774246414763414d41424c414749415551427341446b415177426c4145304156514272414863415567423341466b415241425741464541555142454145514152514245414645416341423041454d414d514177414577414d7742534147634164414248414545414d41424d414551415551423141446b415277424e414441415441417a414645416451424f41454d414e51424a414534415177417a4144414154414245414649415a77426b41454d416551417741466f41596742524148514154674248414567414d41425a414641415551427a41485141517742334144414154414232414649416167424f41454d414f5141774145774161674252414855415577424541464541646742304145634151514177414577415541425241484d415467424441446b41545142534147734164774247414863415751424541465941555142524145594152414243414549415667425241464d414d4142334145304152414242414867415467425541466b416551424e41476b414d414235414530415241424641486b415451425241484d416477424441464541575142454146594155514252414563415251423341456f41566742524146514152514253414530415151413441456341515141784146554152514243414863416477424a4144414153674279414645416451424f414563415741417741457741535142444145594152414242414555415a41425341444d416467424d4145674161514231414545415a77424241454541515142424145554151514242414545415151413341454541515142424145454154514243414738415277424441464d416351424841464d415351426941444d4152414252414555415367424241486f415251424f414549415a77427a414845416141427241476b4152774135414863414d41424341454d41556742424145494151674245414545416467424341476341617742784147674161774270414563414f5142334144414151674244414645415551423441456b415a774252414763416151426a41486b41524142764146594162514249414534414d7742454144674156774134414745414b774268414663416377427541486f416541425a414649415177425541456f414d7742764145634157414278414445416151417941474d415467424441455541597742504148554163774233414567415151425a41456f415377427641466f415351426f414859415977424f41454541555142724145594154514252414467415741424541465141525141774145304156414246414863415477424541456b416551424e414551415a7742364145384152674276414863415241425241466b415441424c4147384157514272414545415a774246414549415151425241455541524142424146454152514246414645415467424c4145304156414231414338416541426a4148634151674279414659416277427441454541635141334147454153774255414459414b77426a41484d416551426d41453441566742484147514163414177414534415151425a41476b414e414132414530414c774131414767415641424f414538415a41424c414577415151425041486f414e77427a41484d4152514132414549414d414135414755414f41424741444d415577426941484d415967427741474d4164774272414449415567426b41446b415977425041465941576742514144594156774274414467414d674134414863415341424241466b415367424c414738415767424a414767416467426a4145344151514252414773415267424e414645414f4142594145514156414246414441415451425541455541647742504145514153514235414530415241426e41486f41545142734147384164774245414645415751424d414573416277425a414773415151426e4145554151674242414645415251424541454541555142464145554155514245414863414d41427a414738416567427941466f415541423641454d415541426f414441415267424a4143734155674256414777415577426a414451415751417241486f416477424741476f414e51426a41453841556741324144674165414251414445416567426d414767415251426b414777415767425441473441644142494146554159774176414655414c77426e41454d416467424541456f4165414230414655414f51426b41476f4161514246414845414d51424a41446b416567427241484141636742484145674164414247414751415451426c4148554153414243414555415051413741486f41665141324143734164514277414855416251426e41486f4165674279414538415341413041483041575142684145774163414254414767415177416b41476b4152774276414849415767424c414830415967424b414455414c5141314148304163774172414759414f77424e41456b4153514247414655416567424441454d4151674251414855415a7742424148634153514243414545415a77424a4146554155514273414445415441423441485541556742514143734165414242414555415151424241454541515142464146454151514242414545415241423341454541515142424145454164774245414645415751424d414573416277425a414773415151426e414555415167424241464541525142454145454155514246414863415a77426c41455541654142544145514151674248414549415a77424f4146594151674242414738415451425141446b41517742564144414153674134414763415351423041454d416167417741457741636742534147634154674244414863414d4142614147594155514232414751415277424341444141575142364146454164514230414563415677424a41453441527742434144414154414176414645416441426b414563415277417741466f415967425241484d4154674244414463414d41425a41486f4155514232414751415277425841456b4154674248414549414d41424d41476f415567426e41475141527742444144414154414259414645416467424f41454d414e41424a41476f4152514131414530415241426a4145634151514178414655415251424441486341647742334144414153774269414645416441426b41454d414f51417741466b41544142534147634151774245414649415a77426b41454d414d51417741466b41524142534147634164414244414451414d41425a4146514155674273414851415177413241444141544142454146494161414230414563415677417741466f415977426e41444141544142794146454164514135414563415477417741466b415a674253414777416441424441486b4154514253414467416477424941464541575142454146594155514252414551415241424341474941555142724145344151774274414441415377424941464541625142704145514155514273414534415177426d41456b415177424d414645416277413541454d416141417741457341525142704145304155674272414863415267423341466b4152414257414645415551424741455141516742434146594155514254414441416567424e41476f4154514177414538415241424a4144414154774244414441416551424e4145514152514177414530415551427a414863415177425241466b41524142574146454155514248414555416477424b4146594155514255414555415567424e414545414f414248414545414d5142564145554151674233414863415351417741456f41636742524148554154674248414667414d41424d41456b4164774249414767415977424f4145304156414252414863415467423641456b414d41424e41476f41525142334145304152414242414863415677426f41474d415467424e4146514156514233414534416567424a4144414154514271414555416477424e414551415151423341466341616742434147734154514253414555416477424541486341575142454146594155514252414573415241424241476f4155514272414534415177427441444141537742494146454162514271414555416151424e41454d4151514248414545414d5142564145554151514233414863415767417741456f414c774252414851415a414248414567414d41424d414551415567426e41485141517741324144414154414242414763415377424f41454d416151417741456f4157414252414738415a41424441476b4153774255414555415441424e4145454161774248414545414d5142564145554151674252414863415177424e414651415977423441454d416567424241456f415167426e4145344156674243414545415751425541454541624142574145494154514253414555416477424541486341575142454146594155514252414567415241424241476f41555142744148514151774130414441415767426d414645416377427141454d415167413441476f415177424341486b415551425a414577415377427641466b4161774242414763415251424341454541555142464145514151514252414555416477426e41474941617742334147514156414242414567415151426e41456b41516742424146454153514243414551415151424a41454941515142424146454161414246414577414e774271414449414d674279414845416267426f414373415277425741445141654142474148634155774258414655414c7741314146454161674273414573415a674259414538415541427241466b415a6742744146554156674242414667415377425641446b41545141304145494151514270414555415151426e4145454151514242414545415151424241454541515142424145454151514242414545415151424241454541515142424145454151514248414751415767424a41465141636742344147634164514274414567414d414172414559414d77424741456f41516741354146494164774177414555415351426941466b4155414177414851416167426a4144594153774272414441415351413441466b415551424841446741635142534148674153414276414545415a674274414863416477424441486b415967424f41465941567742354147494152414275414441415a77413341486b41617742784145454151514253414545416351426b4147494163674253414759415251413441474d415351424c414545416541424b41466f414e77424a414867414f51426c414849415a67426141466b414e674132414651415151424f41486b416177426b4145384154674273414849414f4142444146674153774255414767415a674130414459415741424a414534416541426f414663414d41425041476b41615142594146674164774232414549414d77427841453441617742504145774156674272414459416151423341466741626741354145454155774251414730414d674130414373416377425741445541516742424145304161774242414545415551426f414851415967427141446341574142694143734156514134414849414c77425141455141635142694145384164774172414859416567424241484d416377424641466f415367425841476b416551417a414559414e4142424147304161514261414845415a514251414734415667426f41454541516742764144514153514244414749416167424441454d4151514274414738416477424c41464541575142454146594155674177414538415167424441456b415251424a414573415677425141476b414c7741764148414153414230414851416441424c4147514165414234414577414e51424c41445141536742554147454163414134414730415a7741334145304153674271414849414d774250414451415551424a4145734156774269414649415741425341476f415451424441484d4152774242414445415651426b41456b41647742524147734154514244414573415151424a414555415367426b41464d414f414269414773415641417641484d41555142684145774163514236414555416241423141465941614142784147774165414271414851414f51427641464d414e41427641446b414e41417a414845415a77417a4147454163414269414773414d67427741466b41545142444144674152774242414445415651426b41455541515142524147384154514244414745415a774246414649415a77425141453041616742424148674154674245414545414d77424e41476f4155514235414530415641424241486341545142454145494159514276414649415251425a414551416567424a4148634154514255414655416477424f41486f415351417741453041616742464148634154514245414545416477425841476f4151514250414549415a77424f41465941534142524144674151674242414759414f414246414549415151424e41454d415167427a4145454164774247414863415751424541465941556741774147774151514252414567414c774243414545414d41423341454d416477425a41456f415377427641466b41617742424147634152514243414545415551424e41456f41545142434147734152774242414445415651426b41456b4151514246414549414c774233414645415541424e414545414d41423341454d416477425a41456f415377427641466b41617742424147634152514243414545415551424a41454d41545142424148634152774242414445415651426b4145554164774246414549414c774233414645415177424e4145454151514233414567415a77425a41456b415377423341466b41516742434146454156514249414545415551424e414549415151426d414467415251424541486f415151424f414530415151427a4145634151774254414845415277424b4145454153514243414545415551424641454d41515142554145494152514243414763415467425741456741556741344145554155414255414545414e77424e414551416251426e414534414e6742424144454161414271414534416277426b41456741556742334145384161514134414859415751417a414534416367424d414734415667423641474d4165514131414734415967417a41466b416451426b414663415251423241466f415277413541444d4159674274414867416467425a414663415551423241466b414d77424b41484d415977423541446b41524142564144414164414257414655414d51424e4148514155674275414659416377426941454d414e51427141474d4162514233414863415567425241466b4152414257414649414d41423141454941524141304148634155414245414545414e674276414551416151426e414534416277425a4144414159514249414649414d41426a4145514162774232414577414d67424f41486f4159514235414455414d51426a41444d415451423141466f414d6741354144494154414275414659416141424d4144494155674232414751414d67413141484d4159674179414559416177424d4144494154674235414749415341424e41485941555141784145344154414257414659415467425541457741565142534147774159674249414649416141424d41473041546742354147494152414243414451415167426e41476341636742434147634152514247414549415551426a4145494151514252414649416377424e4145634162774233414530415151425a41456b415377423341466b4151674243414645415651424941453041515142484145634153674248414767414d41426b4145674151514132414577416551413541476f415977417941484d416451426b4146674154674236414577416251426b414859415a414270414455414d51425a41464d414f51423641466f415741424b4144494159514258414534416241426a41486b414f51423241466b414d77424f4148634154414236414545414d674243414763415a774279414549415a774246414559415167425241474d4164774242414738415751427841474541534142534144414159774245414738416467424d41444941546742364147454165514131414445415977417a4145304164514261414449414f51417941457741626742574147674154414179414534416141424d414663415467427341474d41626742534148414157674274414777416167425a414667415567427341474d41655141344148554159774245414751416151424e414551414f41424841454d415177427a41456341515142524146554152674243414863415251424d414549415241424e41486341545142554145454164674243414763415a774279414549415a774246414559415167425241474d4164774242414451415751427141474541534142534144414159774245414738416467424d41444941546742364147454165514131414445415977417a4145304164514261414449414f5141794145774162674257414767415441417a414534416241426a414734415767427741466b414d67425741486f415441417a414649416567426a41454d414f41423341456f415551425a41455141566742534144414153674243414549414e4142334145674152414242414745415167426e414863416351426f41476b4155514244414545415551424641454941517742334145554152514242414763415251423441454d416141424e41456b4154774255414545416477424e4145514151514233414530416567424a414863415241425241466b415441424c4147384157514272414545415a7742464145494151514252414555415241424241464541525142454146454164774242414555415551424c4144554161774131414651414d51423441486f4152514273414449415267426c414659415951413241454d416367425741466f41624141304144594161774248414841415577426a41484d415741417a4144454152514270414641416267425341476341626741764147674165414257414530415951427a414549415641426941474941627742614146414157674178414463416441427141474d416451417a41446341575141784147674155514233414763415241426141464d414d41425541446b4153774245414577415577425141466b414d67427a414749416351423441474d415051413741464d4159514230414341415367423141477741494141794144554149414177414441414f674177414441414f67417741444141494142464145554155774255414341414d674177414445414e5141374145594163674270414341415367423141477741494141794144554149414177414441414f674177414441414f67417741444141494142464145554155774255414341414d674177414445414e414367676756584d494946557a4343425075674177494241674955516c314c787552502b784145414141414551414141447741414141774451594c4b6f596b416745424151454441514577676545785344424742674e5642416f4d50394355304a38674974436a304c7252674e4377305a66517664474230597a5175744757494e4742304c2f5174644747305a6251734e433730597a5176644757494e4742304c6a5267644743304c5851764e4334496a45354d4463474131554543777777304b62517464433930594c5267434452676443313059445267744334305954526c744336304c445268744757305a6367304c72517539474f305966526c7443794d5238774851594456515144444262516b4e436d304b48516d6944516c4e436649434c516f394368304b45694d526b774677594456515146444242565153307a4d6a4d304f4449304f4330794d4445304d517377435159445651514745774a56515445524d4138474131554542777749304a7251754e4758304c49774868634e4d5451774e7a49304d6a45774d4441775768634e4d5455774e7a49304d6a45774d444177576a426b4d524577447759445651514b44416a516b4e436d304b48516d6a45694d434147413155454177775a304a2f5174644748304c445267744336304c41674b4e4369304a58516f6443694b54454c4d416b4741315545425177434d546378437a414a42674e5642415954416c56424d524577447759445651514844416a516d744334305a6651736a4342386a43427951594c4b6f596b41674542415145444151457767626b776454414841674942415149424441494241415168454c376a323272716e682b4756347846775357552f35516a6c4b66584f506b59666d555641584b55394d34424169454167414141414141414141414141414141414141414147645a4954727867756d48302b4633464a4239527730454962595030746a63364b6b30493859514738715278486f41666d77774379624e56577962446e306737796b7141415241716462725266453863494b41784a5a374978396572665a59363654414e796b644f4e6c723843584b546866343658494e786857304f6969585877764233714e6b4f4c566b366977586e394153506d32342b73563542414d6b4141516874626a3758622b5538722f504471624f772b767a417373455a4a576979334634416d695a7165506e566841426f344943626a4343416d6f774b5159445652304f42434945494b5750692f2f70487474744b6478784c354b344a546170386d67374d4a6a72334f3451494b57625258526a4d437347413155644977516b4d434b4149454a645338626b542f7351614c717a456c755668716c786a74396f53346f3934337167336170626b3270594d433847413155644541516f4d436167455267504d6a41784e4441334d6a51794d5441774d4442616f524559447a49774d5455774e7a49304d6a45774d444177576a414f42674e56485138424166384542414d4342734177467759445652306c4151482f424130774377594a4b6f596b4167454241514d4a4d426b4741315564494145422f7751504d4130774377594a4b6f596b41674542415149434d41774741315564457745422f7751434d414177486759494b7759424251554841514d4241663845447a414e4d417347435371474a414942415145434154424542674e5648523845505441374d446d674e364131686a4e6f644852774f69387659334e724c6e567a6379356e62335975645745765a473933626d78765957517659334a73637939445530745655314d74526e56736243356a636d7777525159445652307542443477504441366f4469674e6f59306148523063446f764c324e7a6179353163334d755a3239324c6e56684c325276643235736232466b4c324e7962484d7651314e4c56564e544c55526c624852684c6d4e7962444234426767724267454642516342415152734d476f774d4159494b775942425155484d4147474a476830644841364c79396a6332737564584e7a4c6d6476646935315953397a5a584a3261574e6c6379397659334e774c7a4132426767724267454642516377416f59716148523063446f764c324e7a6179353163334d755a3239324c6e56684c324e684c574e6c636e52705a6d6c6a5958526c63793875634464694d44384743437347415155464277454c42444d774d5441764267677242674546425163774134596a6148523063446f764c324e7a6179353163334d755a3239324c6e56684c334e6c636e5a705932567a4c33527a634338774a5159445652304a4242347748444161426777716869514341514542437745454167457843684d494f5441774d4441774d7a49774451594c4b6f596b41674542415145444151454451774145514b356b355431787a456c3246655661364372565a6c34366b47705363735833314569506e52676e2f6878564d6173425462626f5a505a3137746a63753337593168517767445a533054394b444c53505932736271786378676763754d4949484b674942415443422b6a4342345446494d455947413155454367772f304a54516e794169304b505175744741304c44526c394339305948526a4e4336305a59673059485176394331305962526c744377304c76526a4e4339305a596730594851754e474230594c5174644338304c67694d546b774e7759445651514c4444445170744331304c335267744741494e4742304c5852674e4743304c6a52684e4757304c7251734e4747305a62526c794451757443373059375268394757304c4978487a416442674e5642414d4d46744351304b62516f644361494e4355304a38674974436a304b48516f5349784754415842674e564241554d454656424c544d794d7a51344d6a51344c5449774d545178437a414a42674e5642415954416c56424d524577447759445651514844416a516d744334305a665173674955516c314c787552502b784145414141414551414141447741414141774441594b4b6f596b416745424151454341614343426363776767465242677371686b694739773042435241434c7a474341554177676745384d4949424f444343415451774441594b4b6f596b416745424151454341515167454f683478315a784645346f4b713648556b664f53727835376e52677767505575335a6f3948516238624d77676745414d49486e7049486b4d4948684d556777526759445651514b44442f516c4e436649434c516f39433630594451734e4758304c33526764474d304c72526c6944526764432f304c585268744757304c44517539474d304c33526c694452676443343059485267744331304c7a51754349784f54413342674e564241734d4d4e436d304c58517664474330594167305948517464474130594c51754e4745305a625175744377305962526c744758494e4336304c76526a744748305a6251736a45664d4230474131554541777757304a445170744368304a6f67304a54516e794169304b50516f644368496a455a4d4263474131554542517751565545744d7a497a4e4467794e4467744d6a41784e44454c4d416b474131554542684d43565545784554415042674e564241634d434e4361304c6a526c394379416852435855764735452f37454151414141415241414141504141414144415942676b71686b69473977304243514d784377594a4b6f5a496876634e415163424d43384743537147534962334451454a424445694243434e614d4b304955585737677977734f636c64332b704447416e45744258764f6c653771684651736273615443434241554743797147534962334451454a454149554d59494439444343412f414743537147534962334451454841714343412b457767675064416745444d5134774441594b4b6f596b41674542415145434154427042677371686b69473977304243524142424b426142466777566749424151594b4b6f596b4167454241514944415441774d417747436971474a41494241514542416745454949316f7772516852646275444c43773579563366366b4d5943635330466538365637757145564378757870416749456b5267504d6a41784e4445784d4467794d6a45784e4456614d594944577a43434131634341514577676745544d4948364d543877505159445651514b444462516e4e4757304c33526c74474230594c51746447413059485267744379304c34673059375267644743304c6a5268744757305a6367304b505175744741304c44526c394339304c67784d54417642674e564241734d4b4e4351304c5451764e4757304c33526c74474230594c52674e437730594c5176744741494e4347304b4c516f53445170744358304a34785354424842674e5642414d4d514e436d304c58517664474330594451734e433730597a5176644334304c6b67304c6651734e4742304c4c526c7443303059665267394379304c44517539474d304c3351754e4335494e432b3059445173394377304c30784754415842674e564241554d454656424c5441774d4445314e6a49794c5449774d544978437a414a42674e5642415954416c56424d524577447759445651514844416a516d744334305a6651736749554d41523148653873654b3443414141414151414141456341414141774441594b4b6f596b41674542415145434161434341646f776767467242677371686b694739773042435241434c7a474341566f77676746574d494942556a4343415534774441594b4b6f596b4167454241514543415151676658534265694a72496a73306a592f356751432f486e4168694d636c756b67364d69443071592f5a45566777676745614d494942414b53422f5443422b6a452f4d4430474131554543677732304a7a526c744339305a625267644743304c5852674e474230594c517374432b494e474f3059485267744334305962526c744758494e436a304c7252674e4377305a6651766443344d5445774c7759445651514c44436a516b4e4330304c7a526c744339305a62526764474330594451734e4743304c37526743445168744369304b4567304b62516c3943654d556b7752775944565151444445445170744331304c335267744741304c44517539474d304c3351754e4335494e4333304c445267644379305a6251744e47483059505173744377304c76526a4e4339304c6a517553445176744741304c5051734e43394d526b77467759445651514644424256515330774d4441784e5459794d6930794d4445794d517377435159445651514745774a56515445524d4138474131554542777749304a7251754e4758304c494346444145645233764c486975416741414141454141414248414141414d426f4743537147534962334451454a417a454e42677371686b694739773042435241424244417642676b71686b69473977304243515178496751674c395074516744316d7a6e392f58574756625046415042314b7a7773474279346d5057376544324779474d774841594a4b6f5a496876634e41516b464d513858445445304d5445774f4449794d5445304e566f774451594c4b6f596b416745424151454441514545514d433464637a7a787249564d4373574a55304e764d5237477243392b354f624d45417567784e51554878433750534577346d6f716c3976464d4e456f454b67344b7a7134514a4e76354e5739723530524965534c784d774841594a4b6f5a496876634e41516b464d513858445445304d5445774f4449794d4467314d316f774451594c4b6f596b416745424151454441514545514b7178426234652b4b62305a46487444416969324e2f4e452b6f34365772623174544f74327977676473565032522f36344b6d6d65436c66776a464c4554634c61617579567a646a587445374f775162424c424f31453d, 1415484512, 1415484647);

-- --------------------------------------------------------

--
-- Структура таблицы `cab_user_activities`
--

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
  `certSignTime` int(11) DEFAULT NULL COMMENT 'Час підпису форми реєстрації',
  `certUseTSP` tinyint(1) DEFAULT NULL COMMENT 'Присутність мітки часу',
  `certIssuerCN` text COMMENT 'Загальне ім''я видавника',
  `certSubject` text COMMENT 'Власник сертифікату',
  `certSubjCN` text COMMENT 'Загальне ім''я власника',
  `certSubjOrg` text COMMENT 'Організація',
  `certSubjOrgUnit` text COMMENT 'Підрозділ',
  `certSubjTitle` text COMMENT 'Посада',
  `certSubjState` text COMMENT 'Область',
  `certSubjLocality` text COMMENT 'Місто',
  `certSubjFullName` text COMMENT 'Повне ім''я',
  `certSubjAddress` text COMMENT 'Адреса',
  `certSubjPhone` text COMMENT 'Телефон',
  `certSubjEMail` text COMMENT 'E-Mail',
  `certSubjDNS` text COMMENT 'DNS',
  `certExpireEndTime` int(11) DEFAULT NULL COMMENT 'Дата закінчення дії сертифікату',
  `certExpireBeginTime` int(11) DEFAULT NULL COMMENT 'Дата початку дії сертифікату',
  PRIMARY KEY (`id`),
  KEY `ext_user_certs_idx` (`ext_user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Сертифікати зовнішніх користувачів»' AUTO_INCREMENT=36 ;

--
-- Дамп данных таблицы `cab_user_extern_certs`
--

INSERT INTO `cab_user_extern_certs` (`id`, `type_of_user`, `certissuer`, `certserial`, `certSubjDRFOCode`, `certSubjEDRPOUCode`, `certData`, `certType`, `ext_user_id`, `certSignTime`, `certUseTSP`, `certIssuerCN`, `certSubject`, `certSubjCN`, `certSubjOrg`, `certSubjOrgUnit`, `certSubjTitle`, `certSubjState`, `certSubjLocality`, `certSubjFullName`, `certSubjAddress`, `certSubjPhone`, `certSubjEMail`, `certSubjDNS`, `certExpireEndTime`, `certExpireBeginTime`) VALUES
(1, 0, 'O=АТ "ІІТ";OU=Тестовий ЦСК;CN=Тестовий ЦСК АТ "ІІТ";Serial=UA-22723472;C=UA;L=Харків;ST=Харківська', '5B63D88375D9201804000000EB040000630A0000', '9987654321', '99876540', 0x3082068130820629a00302010202145b63d88375d9201804000000eb040000630a0000300d060b2a862402010101010301013081c331163014060355040a0c0dd090d0a22022d086d086d0a2223120301e060355040b0c17d0a2d0b5d181d182d0bed0b2d0b8d0b920d0a6d0a1d09a312e302c06035504030c25d0a2d0b5d181d182d0bed0b2d0b8d0b920d0a6d0a1d09a20d090d0a22022d086d086d0a2223114301206035504050c0b55412d3232373233343732310b30090603550406130255413115301306035504070c0cd0a5d0b0d180d0bad196d0b2311d301b06035504080c14d0a5d0b0d180d0bad196d0b2d181d18cd0bad0b0301e170d3134303830383231303030305a170d3135303830383231303030305a3082012231223020060355040a0c19d0a4d196d0b7d0b8d187d0bdd0b020d0bed181d0bed0b1d0b031223020060355040b0c19d0a4d196d0b7d0b8d187d0bdd0b020d0bed181d0bed0b1d0b031223020060355040c0c19d0a4d196d0b7d0b8d187d0bdd0b020d0bed181d0bed0b1d0b0312f302d06035504030c26d09cd0bed0bbd0bed0b4d188d0b8d0b920d094d0b8d18020d094d0b8d180d0bed0b2d0b8d1873119301706035504040c10d09cd0bed0bbd0bed0b4d188d0b8d0b9311e301c060355042a0c15d094d0b8d18020d094d0b8d180d0bed0b2d0b8d187310d300b06035504050c0431323539310b30090603550406130255413113301106035504070c0ad09ed0b4d0b5d181d0b03117301506035504080c0ed09ed0b4d0b5d181d18cd0bad0b03081f23081c9060b2a862402010101010301013081b9307530070202010102010c020100042110bee3db6aea9e1f86578c45c12594ff942394a7d738f9187e6515017294f4ce01022100800000000000000000000000000000006759213af182e987d3e17714907d470d0421b60fd2d8dce8a93423c6101bca91c47a007e6c300b26cd556c9b0e7d20ef292a000440a9d6eb45f13c708280c4967b231f5eadf658eba4c037291d38d96bf025ca4e17f8e9720dc615b43a28975f0bc1dea36438b564ea2c179fd0123e6db8fac5790403240004215869fc50fc2b8e07bc779940ba002d79e08fba55b3560679580fb2a7cab3f95f00a38202fa308202f630290603551d0e042204204d0fb29c86aa18eea3a89eef34b84ab2bf8f3f928010767dd468bddaf7441527302b0603551d230424302280205b63d88375d92018cdb4b10eb9b6a5c69a59fd4327c671e3c1f53aeab02d6ade302f0603551d1004283026a011180f32303134303830383231303030305aa111180f32303135303830383231303030305a300e0603551d0f0101ff0404030206c030190603551d200101ff040f300d300b06092a8624020101010202300c0603551d130101ff04023000301e06082b060105050701030101ff040f300d300b06092a86240201010102013081810603551d11047a3078a035060c2b0601040181974601010402a0250c23d0b2d183d0bb2e20d0a1d0b5d180d182d0b8d184d196d0bad0b0d182d0bdd0b02c2033a01f060c2b0601040181974601010401a00f0c0d2b333830303831323334353637820c6961736e61702e6c6f63616c8110666f726d61743132406d6574612e756130410603551d1f043a30383036a034a0328630687474703a2f2f63612e6969742e636f6d2e75612f646f776e6c6f61642f63726c732f434131332d46756c6c2e63726c30420603551d2e043b30393037a035a0338631687474703a2f2f63612e6969742e636f6d2e75612f646f776e6c6f61642f63726c732f434131332d44656c74612e63726c30818106082b0601050507010104753073302f06082b060105050730018623687474703a2f2f63612e6969742e636f6d2e75612f73657276696365732f6f6373702f304006082b060105050730028634687474703a2f2f63612e6969742e636f6d2e75612f646f776e6c6f61642f6365727469666963617465732f63616969742e703762303e06082b0601050507010b04323030302e06082b060105050730038622687474703a2f2f63612e6969742e636f6d2e75612f73657276696365732f7473702f30430603551d09043c303a301a060c2a8624020101010b01040201310a13083939383736353430301c060c2a8624020101010b01040101310c130a39393837363534333231300d060b2a862402010101010301010343000440c61a79035d4ef320eb20a1be8c19e7bc8ecfdef485f00180a3262cb2e9b66206bc1ac6b4bda3b092360149d34316e9aaaac7bb95e9dc39ac4373de0035c5a942, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30, 0, 'O=ДП "Українські спеціальні системи";OU=Центр сертифікації ключів;CN=АЦСК ДП "УСС";Serial=UA-32348248-2014;C=UA;L=Київ', '425D4BC6E44FFB10040000000600000038000000', '', '90000032', 0x308205ca30820572a0030201020214425d4bc6e44ffb10040000000600000038000000300d060b2a862402010101010301013081e131483046060355040a0c3fd094d09f2022d0a3d0bad180d0b0d197d0bdd181d18cd0bad19620d181d0bfd0b5d186d196d0b0d0bbd18cd0bdd19620d181d0b8d181d182d0b5d0bcd0b82231393037060355040b0c30d0a6d0b5d0bdd182d18020d181d0b5d180d182d0b8d184d196d0bad0b0d186d196d19720d0bad0bbd18ed187d196d0b2311f301d06035504030c16d090d0a6d0a1d09a20d094d09f2022d0a3d0a1d0a1223119301706035504050c1055412d33323334383234382d32303134310b30090603550406130255413111300f06035504070c08d09ad0b8d197d0b2301e170d3134303732343231303030305a170d3135303732343231303030305a3081f3311f301d060355040a0c16d09ed180d0b3d0b0d0bdd196d0b7d0b0d186d196d18f3111300f060355040b0c08d090d0a6d0a1d09a31193017060355040c0c10d094d0b8d180d0b5d0bad182d0bed1803127302506035504030c1e49d0b2d0b0d0bdd0bed0b220d0862ed0862e2028d0a2d095d0a1d0a229203120301e06035504040c1749d0b2d0b0d0bdd0bed0b22028d0a2d095d0a1d0a22920312b3029060355042a0c2249d0b2d0b0d0bd2049d0b2d0b0d0bdd0bed0b2d0b8d1872028d0a2d095d0a1d0a229310a300806035504050c0136310b30090603550406130255413111300f06035504070c08d09ad0b8d197d0b23081f23081c9060b2a862402010101010301013081b9307530070202010102010c020100042110bee3db6aea9e1f86578c45c12594ff942394a7d738f9187e6515017294f4ce01022100800000000000000000000000000000006759213af182e987d3e17714907d470d0421b60fd2d8dce8a93423c6101bca91c47a007e6c300b26cd556c9b0e7d20ef292a000440a9d6eb45f13c708280c4967b231f5eadf658eba4c037291d38d96bf025ca4e17f8e9720dc615b43a28975f0bc1dea36438b564ea2c179fd0123e6db8fac579040324000421aa24508b7d93568d7d6c1cb8221ce4590eb83de657aacc3eaaf7a5ab329c8d9500a38202553082025130290603551d0e04220420d2839677fcd9f623c017387b15f01f6e864cc41460c4168afda0543077512af4302b0603551d23042430228020425d4bc6e44ffb1068bab3125b9586a9718edf684b8a3de37aa0ddaa5b936a58302f0603551d1004283026a011180f32303134303732343231303030305aa111180f32303135303732343231303030305a300e0603551d0f0101ff0404030206c030190603551d200101ff040f300d300b06092a8624020101010202300c0603551d130101ff04023000301e06082b060105050701030101ff040f300d300b06092a862402010101020130440603551d1f043d303b3039a037a0358633687474703a2f2f63736b2e7573732e676f762e75612f646f776e6c6f61642f63726c732f43534b5553532d46756c6c2e63726c30450603551d2e043e303c303aa038a0368634687474703a2f2f63736b2e7573732e676f762e75612f646f776e6c6f61642f63726c732f43534b5553532d44656c74612e63726c307806082b06010505070101046c306a303006082b060105050730018624687474703a2f2f63736b2e7573732e676f762e75612f73657276696365732f6f6373702f303606082b06010505073002862a687474703a2f2f63736b2e7573732e676f762e75612f63612d6365727469666963617465732f2e703762303f06082b0601050507010b04333031302f06082b060105050730038623687474703a2f2f63736b2e7573732e676f762e75612f73657276696365732f7473702f30250603551d09041e301c301a060c2a8624020101010b01040201310a13083930303030303332300d060b2a8624020101010103010103430004405612d9cb6bb081adca00081228bbcc8d5f28fdbc5325c55201a0388fc29b703d76e2c0f238ef9ac825853cc1ba67c8609b6a55bc6bcb0dce6d41f32ade3afc76, 0, 51, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(31, 0, 'O=ДП "Українські спеціальні системи";OU=Центр сертифікації ключів;CN=АЦСК ДП "УСС";Serial=UA-32348248-2014;C=UA;L=Київ', '425D4BC6E44FFB1004000000100000003A000000', '', '90000032', 0x308205de30820586a0030201020214425d4bc6e44ffb1004000000100000003a000000300d060b2a862402010101010301013081e131483046060355040a0c3fd094d09f2022d0a3d0bad180d0b0d197d0bdd181d18cd0bad19620d181d0bfd0b5d186d196d0b0d0bbd18cd0bdd19620d181d0b8d181d182d0b5d0bcd0b82231393037060355040b0c30d0a6d0b5d0bdd182d18020d181d0b5d180d182d0b8d184d196d0bad0b0d186d196d19720d0bad0bbd18ed187d196d0b2311f301d06035504030c16d090d0a6d0a1d09a20d094d09f2022d0a3d0a1d0a1223119301706035504050c1055412d33323334383234382d32303134310b30090603550406130255413111300f06035504070c08d09ad0b8d197d0b2301e170d3134303732343231303030305a170d3135303732343231303030305a30820106311f301d060355040a0c16d09ed180d0b3d0b0d0bdd196d0b7d0b0d186d196d18f3111300f060355040b0c08d090d0a6d0a1d09a311b3019060355040c0c12d091d183d185d0b3d0b0d0bbd182d0b5d1803129302706035504030c20d0a1d196d0b4d0bed180d0bed0b220d09e2ed0862e2028d0a2d095d0a1d0a2293122302006035504040c19d0a1d196d0b4d0bed180d0bed0b22028d0a2d095d0a1d0a22931373035060355042a0c2ed09ed0bbd0b5d0bad181d0b0d0bdd0b4d18020d086d0b2d0b0d0bdd0bed0b2d0b8d1872028d0a2d095d0a1d0a229310b300906035504050c023136310b30090603550406130255413111300f06035504070c08d09ad0b8d197d0b23081f23081c9060b2a862402010101010301013081b9307530070202010102010c020100042110bee3db6aea9e1f86578c45c12594ff942394a7d738f9187e6515017294f4ce01022100800000000000000000000000000000006759213af182e987d3e17714907d470d0421b60fd2d8dce8a93423c6101bca91c47a007e6c300b26cd556c9b0e7d20ef292a000440a9d6eb45f13c708280c4967b231f5eadf658eba4c037291d38d96bf025ca4e17f8e9720dc615b43a28975f0bc1dea36438b564ea2c179fd0123e6db8fac579040324000421738597bffb2653717ab4503167db7c90d73846f872903692f0be36efaccfb9be01a38202553082025130290603551d0e0422042076c5221b34026afa6eb6746ac33b3c17ec7cb2819ddca15c9415bba1e0d13555302b0603551d23042430228020425d4bc6e44ffb1068bab3125b9586a9718edf684b8a3de37aa0ddaa5b936a58302f0603551d1004283026a011180f32303134303732343231303030305aa111180f32303135303732343231303030305a300e0603551d0f0101ff0404030206c030190603551d200101ff040f300d300b06092a8624020101010202300c0603551d130101ff04023000301e06082b060105050701030101ff040f300d300b06092a862402010101020130440603551d1f043d303b3039a037a0358633687474703a2f2f63736b2e7573732e676f762e75612f646f776e6c6f61642f63726c732f43534b5553532d46756c6c2e63726c30450603551d2e043e303c303aa038a0368634687474703a2f2f63736b2e7573732e676f762e75612f646f776e6c6f61642f63726c732f43534b5553532d44656c74612e63726c307806082b06010505070101046c306a303006082b060105050730018624687474703a2f2f63736b2e7573732e676f762e75612f73657276696365732f6f6373702f303606082b06010505073002862a687474703a2f2f63736b2e7573732e676f762e75612f63612d6365727469666963617465732f2e703762303f06082b0601050507010b04333031302f06082b060105050730038623687474703a2f2f63736b2e7573732e676f762e75612f73657276696365732f7473702f30250603551d09041e301c301a060c2a8624020101010b01040201310a13083930303030303332300d060b2a86240201010101030101034300044013cb65ad4a8256cb26ad2dab6fd5e22a73c67158e29a937f854434834d68b07029d25da0e86c8528c9e27225ab4b2416b1a51aeb2c35b9bc62efcfd0b8f11442, 0, 52, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32, 0, 'O=Інформаційно-довідковий департамент Міндоходів;OU=Управління (Центр) сертифікації ключів ІДД Міндоходів;CN=Акредитований центр сертифікації ключів ІДД Міндоходів;Serial=UA-38725930;C=UA;L=Київ', '3EEE524F3BA9E8BB04000000080D1900D12E2C00', '2996310756', '25053256', 0x3082078130820729a00302010202143eee524f3ba9e8bb04000000080d1900d12e2c00300d060b2a862402010101010301013082017a31623060060355040a0c59d086d0bdd184d0bed180d0bcd0b0d186d196d0b9d0bdd0be2dd0b4d0bed0b2d196d0b4d0bad0bed0b2d0b8d0b920d0b4d0b5d0bfd0b0d180d182d0b0d0bcd0b5d0bdd18220d09cd196d0bdd0b4d0bed185d0bed0b4d196d0b2316c306a060355040b0c63d0a3d0bfd180d0b0d0b2d0bbd196d0bdd0bdd18f2028d0a6d0b5d0bdd182d1802920d181d0b5d180d182d0b8d184d196d0bad0b0d186d196d19720d0bad0bbd18ed187d196d0b220d086d094d09420d09cd196d0bdd0b4d0bed185d0bed0b4d196d0b23170306e06035504030c67d090d0bad180d0b5d0b4d0b8d182d0bed0b2d0b0d0bdd0b8d0b920d186d0b5d0bdd182d18020d181d0b5d180d182d0b8d184d196d0bad0b0d186d196d19720d0bad0bbd18ed187d196d0b220d086d094d09420d09cd196d0bdd0b4d0bed185d0bed0b4d196d0b23114301206035504050c0b55412d3338373235393330310b30090603550406130255413111300f06035504070c08d09ad0b8d197d0b2301e170d3134313031343231303030305a170d3136313031343231303030305a3082013131163014060355040a0c0dd09ad09f20d09ed086d090d0a631163014060355040b0c0dd09ad09f20d09ed086d090d0a6312e302c060355040c0c25d0b7d0b0d181d182d183d0bfd0bdd0b8d0ba20d0b4d0b8d180d0b5d0bad182d0bed180d0b0313b303906035504030c32d09cd0bed0bbd187d0b0d0bdd0bed0b220d094d0b0d0bdd0b8d0bbd0be20d0a1d0b5d180d0b3d196d0b9d0bed0b2d0b8d1873119301706035504040c10d09cd0bed0bbd187d0b0d0bdd0bed0b2312a3028060355042a0c21d094d0b0d0bdd0b8d0bbd0be20d0a1d0b5d180d0b3d196d0b9d0bed0b2d0b8d1873110300e06035504050c0731363431373336310b30090603550406130255413113301106035504070c0ad09ed0b4d0b5d181d0b03117301506035504080c0ed09ed0b4d0b5d181d18cd0bad0b03081f23081c9060b2a862402010101010301013081b9307530070202010102010c020100042110bee3db6aea9e1f86578c45c12594ff942394a7d738f9187e6515017294f4ce01022100800000000000000000000000000000006759213af182e987d3e17714907d470d0421b60fd2d8dce8a93423c6101bca91c47a007e6c300b26cd556c9b0e7d20ef292a000440a9d6eb45f13c708280c4967b231f5eadf658eba4c037291d38d96bf025ca4e17f8e9720dc615b43a28975f0bc1dea36438b564ea2c179fd0123e6db8fac57904032400042165291f635c3dae2b44857b9f14e1ac087e9397c2061cccdb8a4c28ed4ea12e3001a38203333082032f30290603551d0e0422042062cd73ba7ae391b07050557ddd416f718d5153c2932947dbb4fcd10bc4cc41da302b0603551d230424302280203eee524f3ba9e8bb43bddc35ddaa4692f1aab03306d6972e18cdfe55034458a9302f0603551d1004283026a011180f32303134313031343231303030305aa111180f32303136313031343231303030305a300e0603551d0f0101ff0404030206c030190603551d200101ff040f300d300b06092a8624020101010202300c0603551d130101ff04023000301e06082b060105050701030101ff040f300d300b06092a86240201010102013081a20603551d1104819a308197a048060c2b0601040181974601010402a0380c3636353033322c20d0bc2e20d09ed0b4d0b5d181d0b02c20d0bfd180d0bed181d0bf2e20d0a8d0b5d0b2d187d0b5d0bdd0bad0b02c2034a01f060c2b0601040181974601010401a00f0c0d283034382920373138393334378111696163406f64657373612e676f762e7561a017060a2b060104018237140203a0090c07d0a030312d363730490603551d1f04423040303ea03ca03a8638687474703a2f2f6163736b6964642e676f762e75612f646f776e6c6f61642f63726c732f43412d33454545353234462d46756c6c2e63726c304a0603551d2e04433041303fa03da03b8639687474703a2f2f6163736b6964642e676f762e75612f646f776e6c6f61642f63726c732f43412d33454545353234462d44656c74612e63726c30818806082b06010505070101047c307a303006082b060105050730018624687474703a2f2f6163736b6964642e676f762e75612f73657276696365732f6f6373702f304606082b06010505073002863a687474703a2f2f6163736b6964642e676f762e75612f646f776e6c6f61642f6365727469666963617465732f616c6c6163736b6964642e703762303f06082b0601050507010b04333031302f06082b060105050730038623687474703a2f2f6163736b6964642e676f762e75612f73657276696365732f7473702f30430603551d09043c303a301a060c2a8624020101010b01040201310a13083235303533323536301c060c2a8624020101010b01040101310c130a32393936333130373536300d060b2a862402010101010301010343000440f5cadf5e75986169170d5c229f57c903862f34a05bbbfe1776ba9b0a8a7d3e5137da608315ad41f24edc93f58460e53092c8133e7ca5b1f1c7a650834eb5d03c, 0, 53, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(34, 0, 'O=Інформаційно-довідковий департамент Міндоходів;OU=Управління (Центр) сертифікації ключів ІДД Міндоходів;CN=Акредитований центр сертифікації ключів ІДД Міндоходів;Serial=UA-38725930;C=UA;L=Київ', '3EEE524F3BA9E8BB04000000490B1900CB222C00', '3255919016', '3255919016', 0x30820748308206f0a00302010202143eee524f3ba9e8bb04000000490b1900cb222c00300d060b2a862402010101010301013082017a31623060060355040a0c59d086d0bdd184d0bed180d0bcd0b0d186d196d0b9d0bdd0be2dd0b4d0bed0b2d196d0b4d0bad0bed0b2d0b8d0b920d0b4d0b5d0bfd0b0d180d182d0b0d0bcd0b5d0bdd18220d09cd196d0bdd0b4d0bed185d0bed0b4d196d0b2316c306a060355040b0c63d0a3d0bfd180d0b0d0b2d0bbd196d0bdd0bdd18f2028d0a6d0b5d0bdd182d1802920d181d0b5d180d182d0b8d184d196d0bad0b0d186d196d19720d0bad0bbd18ed187d196d0b220d086d094d09420d09cd196d0bdd0b4d0bed185d0bed0b4d196d0b23170306e06035504030c67d090d0bad180d0b5d0b4d0b8d182d0bed0b2d0b0d0bdd0b8d0b920d186d0b5d0bdd182d18020d181d0b5d180d182d0b8d184d196d0bad0b0d186d196d19720d0bad0bbd18ed187d196d0b220d086d094d09420d09cd196d0bdd0b4d0bed185d0bed0b4d196d0b23114301206035504050c0b55412d3338373235393330310b30090603550406130255413111300f06035504070c08d09ad0b8d197d0b2301e170d3134313031343231303030305a170d3136313031343231303030305a3082012c31223020060355040a0c19d0a4d196d0b7d0b8d187d0bdd0b020d0bed181d0bed0b1d0b031223020060355040b0c19d0a4d196d0b7d0b8d187d0bdd0b020d0bed181d0bed0b1d0b0311d301b060355040c0c14d0bfd196d0b4d0bfd0b8d181d183d0b2d0b0d1873135303306035504030c2cd09ad0bed0bfd0b8d182d196d0bd20d0aed180d196d0b920d092d196d0bad182d0bed180d0bed0b2d0b8d1873117301506035504040c0ed09ad0bed0bfd0b8d182d196d0bd31263024060355042a0c1dd0aed180d196d0b920d092d196d0bad182d0bed180d0bed0b2d0b8d1873110300e06035504050c0731363431323839310b30090603550406130255413113301106035504070c0ad09ed0b4d0b5d181d0b03117301506035504080c0ed09ed0b4d0b5d181d18cd0bad0b03081f23081c9060b2a862402010101010301013081b9307530070202010102010c020100042110bee3db6aea9e1f86578c45c12594ff942394a7d738f9187e6515017294f4ce01022100800000000000000000000000000000006759213af182e987d3e17714907d470d0421b60fd2d8dce8a93423c6101bca91c47a007e6c300b26cd556c9b0e7d20ef292a000440a9d6eb45f13c708280c4967b231f5eadf658eba4c037291d38d96bf025ca4e17f8e9720dc615b43a28975f0bc1dea36438b564ea2c179fd0123e6db8fac5790403240004211c4547f7fdef0756fc43736d61742eb2333226e2e2aa4f33cb354ecc91d806c100a38202ff308202fb30290603551d0e04220420ea78a910736cf8697895364de59cad481ffc595d49f7c3c40ff3afaab9d60657302b0603551d230424302280203eee524f3ba9e8bb43bddc35ddaa4692f1aab03306d6972e18cdfe55034458a9302f0603551d1004283026a011180f32303134313031343231303030305aa111180f32303136313031343231303030305a300e0603551d0f0101ff0404030206c030190603551d200101ff040f300d300b06092a8624020101010202300c0603551d130101ff04023000301e06082b060105050701030101ff040f300d300b06092a8624020101010201306d0603551d1104663064a01f060c2b0601040181974601010402a00f0c0d28303933292030373930383035a028060c2b0601040181974601010401a0180c16796b6f706974696e406f64657373612e676f762e7561a017060a2b060104018237140203a0090c07d0a030312d363730490603551d1f04423040303ea03ca03a8638687474703a2f2f6163736b6964642e676f762e75612f646f776e6c6f61642f63726c732f43412d33454545353234462d46756c6c2e63726c304a0603551d2e04433041303fa03da03b8639687474703a2f2f6163736b6964642e676f762e75612f646f776e6c6f61642f63726c732f43412d33454545353234462d44656c74612e63726c30818806082b06010505070101047c307a303006082b060105050730018624687474703a2f2f6163736b6964642e676f762e75612f73657276696365732f6f6373702f304606082b06010505073002863a687474703a2f2f6163736b6964642e676f762e75612f646f776e6c6f61642f6365727469666963617465732f616c6c6163736b6964642e703762303f06082b0601050507010b04333031302f06082b060105050730038623687474703a2f2f6163736b6964642e676f762e75612f73657276696365732f7473702f30450603551d09043e303c301c060c2a8624020101010b01040201310c130a33323535393139303136301c060c2a8624020101010b01040101310c130a33323535393139303136300d060b2a86240201010101030101034300044089acb3d3975bd206033427d9111fff0a73f8c5d1e1c4d32f03e4a02d0208e26f04bae1483ec716d4ec48a31c2467d4ecd08241f4b879d441b44ba9cc68a00852, 0, 55, NULL, 1, 'Акредитований центр сертифікації ключів ІДД Міндоходів', 'O=Фізична особа;OU=Фізична особа;Title=підписувач;CN=Копитін Юрій Вікторович;SN=Копитін;GivenName=Юрій Вікторович;Serial=1641289;C=UA;L=Одеса;ST=Одеська', 'Копитін Юрій Вікторович', 'Фізична особа', 'Фізична особа', 'підписувач', 'Одеська', 'Одеса', 'Копитін Юрій Вікторович', '(093) 0790805', 'ykopitin@odessa.gov.ua', '', '', 1476478800, 1413320400),
(35, 1, 'O=ДП "Українські спеціальні системи";OU=Центр сертифікації ключів;CN=АЦСК ДП "УСС";Serial=UA-32348248-2014;C=UA;L=Київ', '425D4BC6E44FFB1004000000110000003C000000', '', '90000032', 0x30820553308204fba0030201020214425d4bc6e44ffb1004000000110000003c000000300d060b2a862402010101010301013081e131483046060355040a0c3fd094d09f2022d0a3d0bad180d0b0d197d0bdd181d18cd0bad19620d181d0bfd0b5d186d196d0b0d0bbd18cd0bdd19620d181d0b8d181d182d0b5d0bcd0b82231393037060355040b0c30d0a6d0b5d0bdd182d18020d181d0b5d180d182d0b8d184d196d0bad0b0d186d196d19720d0bad0bbd18ed187d196d0b2311f301d06035504030c16d090d0a6d0a1d09a20d094d09f2022d0a3d0a1d0a1223119301706035504050c1055412d33323334383234382d32303134310b30090603550406130255413111300f06035504070c08d09ad0b8d197d0b2301e170d3134303732343231303030305a170d3135303732343231303030305a30643111300f060355040a0c08d090d0a6d0a1d09a3122302006035504030c19d09fd0b5d187d0b0d182d0bad0b02028d0a2d095d0a1d0a229310b300906035504050c023137310b30090603550406130255413111300f06035504070c08d09ad0b8d197d0b23081f23081c9060b2a862402010101010301013081b9307530070202010102010c020100042110bee3db6aea9e1f86578c45c12594ff942394a7d738f9187e6515017294f4ce01022100800000000000000000000000000000006759213af182e987d3e17714907d470d0421b60fd2d8dce8a93423c6101bca91c47a007e6c300b26cd556c9b0e7d20ef292a000440a9d6eb45f13c708280c4967b231f5eadf658eba4c037291d38d96bf025ca4e17f8e9720dc615b43a28975f0bc1dea36438b564ea2c179fd0123e6db8fac579040324000421b5b8fb5dbf94f2bfcf0ea6cec3ebf302cb046495a2cb7178026899a9e3e7561001a382026e3082026a30290603551d0e04220420a58f8bffe91edb6d29dc712f92b82536a9f2683b3098ebdcee1020a59b457463302b0603551d23042430228020425d4bc6e44ffb1068bab3125b9586a9718edf684b8a3de37aa0ddaa5b936a58302f0603551d1004283026a011180f32303134303732343231303030305aa111180f32303135303732343231303030305a300e0603551d0f0101ff0404030206c030170603551d250101ff040d300b06092a862402010101030930190603551d200101ff040f300d300b06092a8624020101010202300c0603551d130101ff04023000301e06082b060105050701030101ff040f300d300b06092a862402010101020130440603551d1f043d303b3039a037a0358633687474703a2f2f63736b2e7573732e676f762e75612f646f776e6c6f61642f63726c732f43534b5553532d46756c6c2e63726c30450603551d2e043e303c303aa038a0368634687474703a2f2f63736b2e7573732e676f762e75612f646f776e6c6f61642f63726c732f43534b5553532d44656c74612e63726c307806082b06010505070101046c306a303006082b060105050730018624687474703a2f2f63736b2e7573732e676f762e75612f73657276696365732f6f6373702f303606082b06010505073002862a687474703a2f2f63736b2e7573732e676f762e75612f63612d6365727469666963617465732f2e703762303f06082b0601050507010b04333031302f06082b060105050730038623687474703a2f2f63736b2e7573732e676f762e75612f73657276696365732f7473702f30250603551d09041e301c301a060c2a8624020101010b01040201310a13083930303030303332300d060b2a862402010101010301010343000440ae64e53d71cc497615e55ae82ad5665e3a906a5272c5f7d4488f9d1827fe1c5531ab014db6e864f675eed8dcbb7ed8d61430803652d13f4a0cb48f636b1bab17, 0, 55, NULL, 1, 'АЦСК ДП "УСС"', 'O=АЦСК;CN=Печатка (ТЕСТ);Serial=17;C=UA;L=Київ', 'Печатка (ТЕСТ)', 'АЦСК', '', '', '', 'Київ', ' ', '', '', '', '', 1437771600, 1406235600);

-- --------------------------------------------------------

--
-- Структура таблицы `cab_user_external`
--

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
(1, 0, 'Молодший Дир Дирович', 'фізична особа', 'format12@meta.ua', '0631234567', 'активований'),
(3, 0, 'Молодший Дир Дирович', 'фізична особа', 'email@email.em', '0639876543', 'не активований');

-- --------------------------------------------------------

--
-- Структура таблицы `cab_user_files_in`
--

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

CREATE TABLE IF NOT EXISTS `cab_user_gen_str` (
  `sauth` varchar(40) NOT NULL COMMENT 'Строка авторизації',
  `itime` int(11) NOT NULL COMMENT 'час авторизації',
  PRIMARY KEY (`sauth`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Генеровані строки авторизації';

-- --------------------------------------------------------

--
-- Структура таблицы `cab_user_intern_certs`
--

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Таблиця «Сертифікати внутрішніх користувачів»' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Структура таблицы `cab_user_internal`
--

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
-- Структура таблицы `ff_available_actions`
--

CREATE TABLE IF NOT EXISTS `ff_available_actions` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '21',
  `storage` int(11) DEFAULT NULL,
  `action` bigint(20) DEFAULT NULL,
  `node` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `ff_available_actions_for_roles`
--

CREATE TABLE IF NOT EXISTS `ff_available_actions_for_roles` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '22',
  `storage` int(11) DEFAULT NULL,
  `action` bigint(20) DEFAULT NULL,
  `node` bigint(20) DEFAULT NULL,
  `roles` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `ff_available_actions_for_users`
--

CREATE TABLE IF NOT EXISTS `ff_available_actions_for_users` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '23',
  `storage` int(11) DEFAULT NULL,
  `action` bigint(20) DEFAULT NULL,
  `node` bigint(20) DEFAULT NULL,
  `users` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `ff_available_nodes`
--

CREATE TABLE IF NOT EXISTS `ff_available_nodes` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '16',
  `storage` int(11) DEFAULT NULL,
  `node` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `ff_available_nodes_for_roles`
--

CREATE TABLE IF NOT EXISTS `ff_available_nodes_for_roles` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '18',
  `storage` int(11) DEFAULT NULL,
  `node` bigint(20) DEFAULT NULL,
  `roles` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `ff_available_nodes_for_users`
--

CREATE TABLE IF NOT EXISTS `ff_available_nodes_for_users` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '17',
  `storage` int(11) DEFAULT NULL,
  `node` bigint(20) DEFAULT NULL,
  `users` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `ff_commentline`
--

CREATE TABLE IF NOT EXISTS `ff_commentline` (
  `id` int(11) NOT NULL,
  `registry` int(11) DEFAULT NULL,
  `storage` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `ff_default`
--

CREATE TABLE IF NOT EXISTS `ff_default` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `registry` int(11) NOT NULL COMMENT 'Ссылка на регистрацию(таблица которой принадлижит запись)',
  `storage` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK_STORAGE_idx` (`storage`) USING BTREE,
  KEY `FK_REGISTRY_IDX` (`registry`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=165 COMMENT='Корневая родительская форма. Ее наследуют все другие таблицы сформированые при помощи свободных форм ' AUTO_INCREMENT=103 ;

--
-- Дамп данных таблицы `ff_default`
--

INSERT INTO `ff_default` (`id`, `registry`, `storage`) VALUES
(1, 12, 7),
(2, 2, 2),
(3, 12, 7),
(4, 2, 2),
(5, 3, 15),
(6, 3, 15),
(7, 3, 15),
(8, 12, 7),
(9, 2, 2),
(10, 8, 6),
(11, 8, 6),
(12, 8, 6),
(13, 8, 6),
(14, 2, 2),
(15, 2, 2),
(16, 2, 2),
(17, 8, 6),
(18, 8, 6),
(19, 8, 6),
(20, 8, 6),
(21, 8, 6),
(22, 8, 6),
(23, 2, 2),
(24, 2, 2),
(25, 2, 2),
(26, 2, 2),
(27, 2, 2),
(28, 2, 2),
(29, 2, 2),
(30, 2, 2),
(31, 2, 2),
(32, 2, 2),
(33, 2, 2),
(34, 2, 2),
(35, 2, 2),
(36, 2, 2),
(37, 2, 2),
(38, 2, 2),
(39, 2, 2),
(40, 2, 2),
(41, 2, 2),
(42, 2, 2),
(43, 6, 4),
(44, 6, 4),
(45, 6, 4),
(46, 6, 4),
(47, 6, 4),
(48, 6, 4),
(49, 2, 2),
(50, 2, 2),
(51, 2, 2),
(52, 2, 2),
(53, 2, 2),
(54, 2, 2),
(55, 2, 2),
(56, 2, 2),
(57, 2, 2),
(58, 2, 2),
(59, 2, 2),
(60, 2, 2),
(61, 2, 2),
(62, 2, 2),
(63, 2, 2),
(64, 2, 2),
(65, 2, 2),
(66, 2, 2),
(67, 2, 2),
(68, 6, 4),
(69, 2, 2),
(70, 2, 2),
(71, 2, 2),
(72, 2, 2),
(73, 2, 2),
(74, 2, 2),
(75, 2, 2),
(76, 2, 2),
(77, 2, 2),
(78, 2, 2),
(79, 2, 2),
(80, 2, 2),
(81, 2, 2),
(82, 37, 18),
(84, 37, 18),
(85, 38, 16),
(86, 37, 18),
(87, 38, 16),
(88, 3, 19),
(89, 3, 19),
(90, 3, 19),
(91, 3, 20),
(92, 3, 20),
(93, 3, 20),
(94, 25, 3),
(95, 2, 2),
(96, 2, 2),
(97, 2, 2),
(98, 25, 3),
(99, 2, 2),
(100, 2, 2),
(101, 37, 18),
(102, 38, 16);

-- --------------------------------------------------------

--
-- Структура таблицы `ff_document_base`
--

CREATE TABLE IF NOT EXISTS `ff_document_base` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '13',
  `storage` int(11) DEFAULT NULL,
  `createdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `route` int(11) DEFAULT NULL,
  `nodes` int(11) DEFAULT NULL,
  `available_nodes` int(11) DEFAULT NULL,
  `available_actions` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `indx_registry` (`registry`) USING BTREE,
  KEY `indx_storage` (`storage`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=8192;

--
-- Дамп данных таблицы `ff_document_base`
--

INSERT INTO `ff_document_base` (`id`, `registry`, `storage`, `createdate`, `route`, `nodes`, `available_nodes`, `available_actions`) VALUES
(85, 38, 16, '2014-11-09 01:07:53', NULL, NULL, NULL, NULL),
(87, 38, 16, '2014-11-09 01:08:56', NULL, NULL, NULL, NULL),
(102, 38, 16, '2014-11-09 13:30:56', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `ff_document_cnap`
--

CREATE TABLE IF NOT EXISTS `ff_document_cnap` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '36',
  `storage` int(11) DEFAULT NULL,
  `createdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `route` int(11) DEFAULT NULL,
  `available_nodes` int(11) DEFAULT NULL,
  `available_actions` int(11) DEFAULT NULL,
  `regnum` varchar(255) DEFAULT NULL,
  `regdate` date DEFAULT NULL,
  `legal_personality` int(11) DEFAULT NULL,
  `organization` int(11) DEFAULT NULL,
  `person_name` varchar(255) DEFAULT NULL,
  `person_drfo` varchar(255) DEFAULT NULL,
  `address` text,
  `phone1` varchar(20) DEFAULT NULL,
  `phone2` varchar(20) DEFAULT NULL,
  `delivery_reply` int(11) DEFAULT NULL,
  `email` varchar(70) DEFAULT NULL,
  `service` int(11) DEFAULT NULL,
  `context` text,
  `reason` text,
  `reply` int(11) DEFAULT NULL,
  `file_petition` longblob,
  `file_petition_fileedsname` varchar(255) DEFAULT NULL,
  `plandate` date DEFAULT NULL,
  `factdate` date DEFAULT NULL,
  `administrator` int(11) DEFAULT NULL,
  `executor` int(11) DEFAULT NULL,
  `file_result` longblob,
  `file_result_fileedsname` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=8192;

--
-- Дамп данных таблицы `ff_document_cnap`
--

INSERT INTO `ff_document_cnap` (`id`, `registry`, `storage`, `createdate`, `route`, `available_nodes`, `available_actions`, `regnum`, `regdate`, `legal_personality`, `organization`, `person_name`, `person_drfo`, `address`, `phone1`, `phone2`, `delivery_reply`, `email`, `service`, `context`, `reason`, `reply`, `file_petition`, `file_petition_fileedsname`, `plandate`, `factdate`, `administrator`, `executor`, `file_result`, `file_result_fileedsname`) VALUES
(85, 38, 16, '2014-11-09 01:07:53', NULL, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Тест ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(87, 38, 16, '2014-11-09 01:08:56', NULL, NULL, NULL, NULL, NULL, NULL, 86, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ТЕСТ №2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(102, 38, 16, '2014-11-09 13:30:56', NULL, NULL, NULL, NULL, NULL, NULL, 101, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Проверка покумента с параметрами по умолчанию', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `ff_document_cnap_metolobruht`
--

CREATE TABLE IF NOT EXISTS `ff_document_cnap_metolobruht` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '38',
  `storage` int(11) DEFAULT NULL,
  `createdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `route` int(11) DEFAULT NULL,
  `available_nodes` int(11) DEFAULT NULL,
  `available_actions` int(11) DEFAULT NULL,
  `regnum` varchar(255) DEFAULT NULL,
  `regdate` date DEFAULT NULL,
  `legal_personality` int(11) DEFAULT NULL,
  `organization` int(11) DEFAULT NULL,
  `person_name` varchar(255) DEFAULT NULL,
  `person_drfo` varchar(255) DEFAULT NULL,
  `address` text,
  `phone1` varchar(20) DEFAULT NULL,
  `phone2` varchar(20) DEFAULT NULL,
  `delivery_reply` int(11) DEFAULT '88',
  `email` varchar(70) DEFAULT NULL,
  `service` int(11) DEFAULT '61',
  `context` text,
  `reason` text,
  `reply` int(11) DEFAULT NULL,
  `file_petition` longblob,
  `file_petition_fileedsname` varchar(255) DEFAULT NULL,
  `plandate` date DEFAULT NULL,
  `factdate` date DEFAULT NULL,
  `administrator` int(11) DEFAULT NULL,
  `executor` int(11) DEFAULT NULL,
  `file_result` longblob,
  `file_result_fileedsname` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=16384;

--
-- Дамп данных таблицы `ff_document_cnap_metolobruht`
--

INSERT INTO `ff_document_cnap_metolobruht` (`id`, `registry`, `storage`, `createdate`, `route`, `available_nodes`, `available_actions`, `regnum`, `regdate`, `legal_personality`, `organization`, `person_name`, `person_drfo`, `address`, `phone1`, `phone2`, `delivery_reply`, `email`, `service`, `context`, `reason`, `reply`, `file_petition`, `file_petition_fileedsname`, `plandate`, `factdate`, `administrator`, `executor`, `file_result`, `file_result_fileedsname`) VALUES
(85, 38, 16, '2014-11-09 01:07:53', NULL, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Тест ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(87, 38, 16, '2014-11-09 01:08:56', NULL, NULL, NULL, NULL, NULL, NULL, 86, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ТЕСТ №2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(102, 38, 16, '2014-11-09 13:30:56', NULL, NULL, NULL, NULL, NULL, NULL, 101, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Проверка покумента с параметрами по умолчанию', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `ff_document_demo`
--

CREATE TABLE IF NOT EXISTS `ff_document_demo` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '14',
  `storage` int(11) DEFAULT NULL,
  `createdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `creditor` text,
  `route` int(11) DEFAULT NULL,
  `nodes` int(11) DEFAULT NULL,
  `available_nodes` int(11) DEFAULT NULL,
  `available_actions` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=224;

--
-- Дамп данных таблицы `ff_document_demo`
--

INSERT INTO `ff_document_demo` (`id`, `registry`, `storage`, `createdate`, `creditor`, `route`, `nodes`, `available_nodes`, `available_actions`) VALUES
(19, 14, 8, NULL, 'чамвмывмы', NULL, NULL, NULL, NULL),
(20, 14, 8, NULL, 'Тест <ins>маршрута</ins>', NULL, NULL, NULL, NULL),
(145, 14, 8, NULL, 'ntcn+', 21, NULL, NULL, NULL),
(146, 14, 8, NULL, 'ntcn', 21, NULL, NULL, NULL),
(147, 14, 8, NULL, 'wefwefwef', 21, NULL, NULL, NULL),
(148, 14, 8, NULL, 'fcbfbfdbdbfd', 21, NULL, NULL, NULL),
(149, 14, 8, NULL, '2131231231212312312312312312312312331231231', 21, NULL, NULL, NULL),
(150, 14, 8, NULL, 'bfbfdbdfdf+', 21, NULL, NULL, NULL),
(151, 14, 8, NULL, 'eqweqweq<strong>weqweqweqweqweqweqweqwe</strong>qweqeqwe', 21, NULL, NULL, NULL),
(152, 14, 8, NULL, '11111111111111111111111', 21, NULL, NULL, NULL),
(153, 14, 8, NULL, 'aaaaaaaaaaaaaa', 21, NULL, NULL, NULL),
(154, 14, 8, NULL, 'тест', 21, NULL, NULL, NULL),
(157, 14, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(159, 14, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(160, 14, 8, NULL, 'ТЕСТ', 21, NULL, NULL, NULL),
(162, 14, 8, NULL, 'Документ из кабинета', 21, NULL, NULL, NULL),
(164, 14, 8, NULL, 'ТЕСТ1', 21, NULL, NULL, NULL),
(166, 14, 8, NULL, 'ТЕСТ1', 21, NULL, NULL, NULL),
(169, 14, 8, NULL, '12323123', 21, NULL, NULL, NULL),
(176, 14, 8, NULL, 'кцкцукцук', 21, NULL, NULL, NULL),
(179, 14, 8, NULL, 'Тест маршрута перенеенного в модель', 21, NULL, NULL, NULL),
(180, 14, 8, NULL, 'Тест маршрута перенеенного в модель', 21, NULL, NULL, NULL),
(183, 14, 8, NULL, 'Тест маршрута перенесенного в модель + 2', 21, NULL, NULL, NULL),
(186, 14, 8, NULL, 'Для удаления', 21, NULL, NULL, NULL),
(189, 14, 8, NULL, 'Для удаления', 21, NULL, NULL, NULL),
(192, 14, 8, NULL, 'Для удаления', 21, NULL, NULL, NULL),
(195, 14, 8, NULL, '3123123123+', 21, NULL, NULL, NULL),
(198, 14, 8, NULL, '3123123123', 21, NULL, NULL, NULL),
(201, 14, 8, NULL, 'йццццццццццццццццццццц', 21, NULL, NULL, NULL),
(204, 14, 8, NULL, 'ывмвывв', 21, NULL, NULL, NULL),
(207, 14, 8, NULL, 'тест привязки действий', 21, NULL, NULL, NULL),
(213, 14, 8, NULL, 'Новый', 21, NULL, NULL, NULL),
(215, 14, 8, NULL, 'Новый+', 21, NULL, NULL, NULL),
(218, 14, 8, NULL, 'Новый 2', 21, NULL, NULL, NULL),
(222, 14, 8, NULL, 'Направить на рассмотрение', 21, NULL, NULL, NULL),
(225, 14, 8, NULL, 'Направить на рассмотрение', 21, NULL, NULL, NULL),
(232, 14, 8, NULL, 'поправлена форма', 21, NULL, NULL, NULL),
(256, 14, 8, NULL, 'Новыйй тест', 21, NULL, NULL, NULL),
(335, 14, 8, NULL, '+++++++++', 21, NULL, NULL, NULL),
(668, 14, 8, NULL, 'Заявление', 21, NULL, NULL, NULL),
(704, 14, 8, NULL, 'Заявление 2+', 21, NULL, NULL, NULL),
(738, 14, 8, NULL, '===&gt;', 21, NULL, NULL, NULL),
(766, 14, 8, NULL, 'ыфауыа', 21, NULL, NULL, NULL),
(771, 14, 8, NULL, 'qqqqqqqqqqqqqqq', 21, NULL, NULL, NULL),
(776, 14, 8, NULL, '123123123', 21, NULL, NULL, NULL),
(781, 14, 8, NULL, '12312312322222222222', 21, NULL, NULL, NULL),
(782, 14, 8, NULL, '123123123', 21, NULL, NULL, NULL),
(783, 14, 8, NULL, '123123123', 21, NULL, NULL, NULL),
(788, 14, 8, NULL, 'После ошибки', 21, NULL, NULL, NULL),
(813, 14, 8, NULL, 'Пример', 21, NULL, NULL, NULL),
(848, 14, 8, NULL, '123', 21, NULL, NULL, NULL),
(853, 14, 8, NULL, '<h1>123123+123123=246246</h1>\r\n', 21, NULL, NULL, NULL),
(858, 14, 8, NULL, '123132ы13в', 211, NULL, NULL, NULL),
(861, 14, 8, NULL, '--------------', 21, NULL, NULL, NULL),
(866, 14, 8, NULL, '--------------', 21, NULL, NULL, NULL),
(871, 14, 8, NULL, NULL, 21, NULL, NULL, NULL),
(876, 14, 8, NULL, '1231', 21, NULL, NULL, NULL),
(881, 14, 8, NULL, '123', 21, NULL, NULL, NULL),
(886, 14, 8, NULL, '+12', 21, NULL, NULL, NULL),
(891, 14, 8, NULL, '1e21e12', 21, NULL, NULL, NULL),
(896, 14, 8, NULL, '0000000000000+', 21, NULL, NULL, NULL),
(901, 14, 8, NULL, '123*', 21, NULL, NULL, NULL),
(906, 14, 8, NULL, '542', 21, NULL, NULL, NULL),
(911, 14, 8, NULL, 'tt', 21, NULL, NULL, NULL),
(916, 14, 8, NULL, 'jjjjjjjjjj', 21, NULL, NULL, NULL),
(921, 14, 8, NULL, 'тест', 21, NULL, NULL, NULL),
(926, 14, 8, NULL, 'виаави', 21, NULL, NULL, NULL),
(931, 14, 8, NULL, 'qwq', 21, NULL, NULL, NULL),
(936, 14, 8, NULL, '100', 211, NULL, NULL, NULL),
(939, 14, 8, NULL, '100', 211, NULL, NULL, NULL),
(942, 14, 8, NULL, '101', 21, NULL, NULL, NULL),
(947, 14, 8, NULL, '102', 21, NULL, NULL, NULL),
(952, 14, 8, NULL, '123', 21, NULL, NULL, NULL),
(957, 14, 8, NULL, '132+132', 21, NULL, NULL, NULL),
(962, 14, 8, NULL, 'фффффф', 21, NULL, NULL, NULL),
(967, 14, 8, NULL, 'testff', 21, NULL, NULL, NULL),
(972, 14, 8, NULL, 'testff2', 21, NULL, NULL, NULL),
(977, 14, 8, NULL, '1231231231123131', 21, NULL, NULL, NULL),
(982, 14, 8, NULL, 'testff3', 21, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `ff_document_rkk`
--

CREATE TABLE IF NOT EXISTS `ff_document_rkk` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '24',
  `storage` int(11) DEFAULT NULL,
  `createdate` datetime DEFAULT NULL,
  `route` int(11) DEFAULT NULL,
  `available_nodes` int(11) DEFAULT NULL,
  `available_actions` int(11) DEFAULT NULL,
  `regnum` varchar(255) DEFAULT NULL,
  `regdate` date DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `ff_document_rkk`
--

INSERT INTO `ff_document_rkk` (`id`, `registry`, `storage`, `createdate`, `route`, `available_nodes`, `available_actions`, `regnum`, `regdate`) VALUES
(210, 24, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(761, 24, 8, NULL, 21, NULL, NULL, '123123', NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `ff_field`
--

CREATE TABLE IF NOT EXISTS `ff_field` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `formid` int(11) DEFAULT '1' COMMENT 'Ссылка на свободную форму',
  `name` varchar(255) NOT NULL COMMENT 'Имя поля свободнеой формы',
  `type` int(11) DEFAULT NULL COMMENT 'Тип поля в  свободной форме',
  `description` tinytext COMMENT 'Описание / назначение поля',
  `order` int(10) NOT NULL DEFAULT '0' COMMENT 'Порядок отображения полей. При 0 поле скрытое',
  `protected` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Блокировка для защиты от несанкционированного удаления и/или изменения поля',
  `default` tinytext COMMENT 'Значение поля по-умолчанию',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id_idx` (`formid`) USING BTREE,
  KEY `FK_TYPE_idx` (`type`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=88 COMMENT='Список полей подключенных в свобных формах' AUTO_INCREMENT=279 ;

--
-- Дамп данных таблицы `ff_field`
--

INSERT INTO `ff_field` (`id`, `formid`, `name`, `type`, `description`, `order`, `protected`, `default`) VALUES
(1, 1, 'registry', 2, NULL, 0, 1, NULL),
(2, 1, 'storage', 2, NULL, 0, 1, NULL),
(3, 2, 'registry', 2, NULL, 0, 1, NULL),
(4, 2, 'storage', 2, NULL, 0, 1, NULL),
(6, 3, 'registry', 2, NULL, 0, 1, NULL),
(7, 3, 'storage', 2, NULL, 0, 1, NULL),
(9, 4, 'registry', 2, NULL, 0, 1, NULL),
(10, 4, 'storage', 2, NULL, 0, 1, NULL),
(12, 3, 'name', 1, 'Наименование', 100, 0, NULL),
(13, 4, 'name', 1, 'Наименование', 100, 1, NULL),
(14, 4, 'comment', 4, 'Комментарий', 200, 0, NULL),
(15, 2, 'order', 2, 'Порядок сортировки', 0, 0, NULL),
(16, 2, 'owner', 5, 'Ссылка на документ', 0, 0, NULL),
(17, 2, 'owner_field', 1, 'поле документа привязки', 0, 0, ''),
(18, 2, 'reference', 5, 'Ссылка на элемент справочника', 0, 0, NULL),
(19, 5, 'registry', 2, NULL, 0, 1, NULL),
(20, 5, 'storage', 2, NULL, 0, 1, NULL),
(21, 5, 'name', 1, 'Наименование', 100, 1, NULL),
(22, 5, 'comment', 4, 'Комментарий', 200, 1, NULL),
(26, 6, 'registry', 2, NULL, 0, 1, NULL),
(27, 6, 'storage', 2, NULL, 0, 1, NULL),
(28, 6, 'name', 1, 'Наименование', 100, 1, NULL),
(29, 6, 'comment', 4, 'Комментарий', 200, 1, NULL),
(33, 7, 'registry', 2, NULL, 0, 1, NULL),
(34, 7, 'storage', 2, NULL, 0, 1, NULL),
(35, 7, 'name', 1, 'Наименование', 100, 1, NULL),
(36, 7, 'comment', 4, 'Комментарий', 200, 1, NULL),
(40, 8, 'registry', 2, NULL, 0, 1, NULL),
(41, 8, 'storage', 2, NULL, 0, 1, NULL),
(42, 8, 'name', 1, 'Наименование', 100, 1, NULL),
(43, 8, 'comment', 4, 'Комментарий', 200, 1, NULL),
(47, 9, 'registry', 2, NULL, 0, 1, NULL),
(48, 9, 'storage', 2, NULL, 0, 1, NULL),
(49, 9, 'name', 1, 'Наименование', 100, 1, NULL),
(50, 9, 'comment', 4, 'Комментарий', 200, 1, NULL),
(54, 7, 'start_route', 1002, 'Начальный узел', 300, 0, NULL),
(55, 5, 'gotonodes', 1002, 'Перейти к узлам', 300, 0, NULL),
(56, 5, 'clearnodes', 1002, 'Очистить узлы', 400, 0, NULL),
(57, 6, 'allow_action', 1001, 'Разрешить действия', 300, 0, NULL),
(58, 6, 'deny_action', 1001, 'Запретить действия', 400, 0, NULL),
(59, 8, 'nodes', 1002, 'Ассоциированные узлы', 300, 0, NULL),
(60, 9, 'folders', 1007, 'Папки кабинета', 300, 0, NULL),
(61, 8, 'allow_new', 1012, 'Создать документ', 400, 0, NULL),
(62, 8, 'allow_edit', 1012, 'Изменить документ', 500, 0, NULL),
(63, 8, 'allow_delete', 1012, 'Удалить документ', 600, 0, NULL),
(65, 12, 'registry', 2, NULL, 0, 1, NULL),
(66, 12, 'storage', 2, NULL, 0, 1, NULL),
(67, 12, 'name', 1, 'Наименование', 100, 1, NULL),
(68, 12, 'comment', 4, 'Комментарий', 200, 1, NULL),
(69, 12, 'folders', 1007, 'Папки кабинета', 300, 1, NULL),
(72, 12, 'role', 1009, 'ИД роли пользователя', 400, 0, NULL),
(73, 13, 'registry', 2, NULL, 0, 1, NULL),
(74, 13, 'storage', 2, NULL, 0, 1, NULL),
(76, 13, 'createdate', 17, 'Время создания документа', 0, 0, 'DBDEFAULT:DEFAULT CURRENT_TIMESTAMP'),
(89, 15, 'registry', 2, NULL, 0, 1, NULL),
(90, 15, 'storage', 2, NULL, 0, 1, NULL),
(91, 15, 'name', 1, 'Наименование', 100, 1, NULL),
(92, 15, 'comment', 4, 'Комментарий', 200, 1, NULL),
(93, 15, 'folders', 1007, 'Папки кабинета', 300, 1, NULL),
(96, 15, 'users', 1008, 'Список пользователей, допущенных к кабинету', 400, 0, NULL),
(97, 13, 'route', 1003, 'Маршрут', 1, 0, NULL),
(101, 16, 'registry', 2, NULL, 0, 1, NULL),
(102, 16, 'storage', 2, NULL, 0, 1, NULL),
(104, 16, 'node', 5, 'Текущий узел', 0, 0, NULL),
(108, 17, 'registry', 2, NULL, 0, 1, NULL),
(109, 17, 'storage', 2, NULL, 0, 1, NULL),
(110, 17, 'node', 5, 'Текущий узел', 0, 1, NULL),
(111, 18, 'registry', 2, NULL, 0, 1, NULL),
(112, 18, 'storage', 2, NULL, 0, 1, NULL),
(113, 18, 'node', 5, 'Текущий узел', 0, 1, NULL),
(114, 17, 'users', 1008, 'Список пользователей', 0, 0, NULL),
(115, 18, 'roles', 1009, 'Список ролей', 0, 0, NULL),
(118, 13, 'available_nodes', 1010, 'Список узлов в которых находится документ', 0, 0, NULL),
(120, 13, 'available_actions', 1013, 'Действия с документом', 0, 0, NULL),
(122, 8, 'visual_names', 4, 'Список отображаемых полей', 700, 0, NULL),
(123, 21, 'registry', 2, NULL, 0, 1, NULL),
(124, 21, 'storage', 2, NULL, 0, 1, NULL),
(126, 21, 'action', 5, 'Ссылка на действие', 0, 0, NULL),
(127, 22, 'registry', 2, NULL, 0, 1, NULL),
(128, 22, 'storage', 2, NULL, 0, 1, NULL),
(129, 22, 'action', 5, 'Ссылка на действие', 0, 1, NULL),
(130, 21, 'node', 5, 'Ссылка на узел', 0, 0, NULL),
(131, 22, 'node', 5, 'Ссылка на узел', 0, 1, NULL),
(132, 23, 'registry', 2, NULL, 0, 1, NULL),
(133, 23, 'storage', 2, NULL, 0, 1, NULL),
(134, 23, 'action', 5, 'Ссылка на действие', 0, 1, NULL),
(135, 23, 'node', 5, 'Ссылка на узел', 0, 1, NULL),
(139, 22, 'roles', 1009, 'Список ролей', 0, 0, NULL),
(140, 23, 'users', 1008, 'Список пользователей', 0, 0, NULL),
(150, 25, 'registry', 2, NULL, 0, 1, NULL),
(151, 25, 'storage', 2, NULL, 0, 1, NULL),
(152, 25, 'name', 1, 'Наименование', 100, 1, NULL),
(153, 25, 'comment', 4, 'Комментарий', 200, 1, NULL),
(154, 25, 'gotonodes', 1002, 'Перейти к узлам', 300, 1, NULL),
(155, 25, 'clearnodes', 1002, 'Очистить узлы', 400, 1, NULL),
(157, 26, 'registry', 2, NULL, 0, 1, NULL),
(158, 26, 'storage', 2, NULL, 0, 1, NULL),
(159, 26, 'name', 1, 'Наименование', 100, 1, NULL),
(160, 26, 'comment', 4, 'Комментарий', 200, 1, NULL),
(161, 26, 'gotonodes', 1002, 'Перейти к узлам', 300, 1, NULL),
(162, 26, 'clearnodes', 1002, 'Очистить узлы', 400, 1, NULL),
(166, 27, 'registry', 2, NULL, 0, 1, NULL),
(167, 27, 'storage', 2, NULL, 0, 1, NULL),
(168, 27, 'name', 1, 'Наименование', 100, 1, NULL),
(169, 27, 'comment', 4, 'Комментарий', 200, 1, NULL),
(170, 27, 'start_route', 1002, 'Начальный узел', 300, 1, NULL),
(173, 28, 'registry', 2, NULL, 0, 1, NULL),
(174, 28, 'storage', 2, NULL, 0, 1, NULL),
(175, 28, 'name', 1, 'Наименование', 100, 1, NULL),
(176, 28, 'comment', 4, 'Комментарий', 200, 1, NULL),
(177, 28, 'start_route', 1002, 'Начальный узел', 300, 1, NULL),
(180, 27, 'roles', 1009, 'Роли', 400, 0, NULL),
(181, 28, 'users', 1008, 'Пользователи', 400, 0, NULL),
(182, 25, 'roles', 1009, 'Роли', 500, 0, NULL),
(183, 26, 'users', 1008, 'Пользователи', 500, 0, NULL),
(184, 25, 'currentrole', 6, 'Для текущего пользователя', 600, 0, NULL),
(185, 26, 'currentuser', 6, 'Для текущего пользователя', 600, 0, NULL),
(210, 36, 'registry', 2, NULL, 0, 1, NULL),
(211, 36, 'storage', 2, NULL, 0, 1, NULL),
(212, 36, 'createdate', 17, 'Время создания документа', 0, 1, 'DBDEFAULT: DEFAULT CURRENT_TIMESTAMP'),
(213, 36, 'route', 1003, 'Маршрут', 0, 1, NULL),
(214, 36, 'available_nodes', 1010, 'Список узлов в которых находится документ', 0, 1, NULL),
(215, 36, 'available_actions', 1013, 'Действия с документом', 0, 1, NULL),
(217, 36, 'regnum', 1, 'Реєстраційний номер', 100, 0, NULL),
(218, 36, 'regdate', 3, 'Дата реєстрації', 200, 0, NULL),
(219, 36, 'legal_personality', 1014, 'Правова форма', 300, 0, NULL),
(220, 37, 'registry', 2, NULL, 0, 1, NULL),
(221, 37, 'storage', 2, NULL, 0, 1, NULL),
(222, 37, 'name', 1, 'Наименование', 100, 1, NULL),
(223, 37, 'edrpou', 1, 'ЄДРПОУ', 200, 0, NULL),
(224, 36, 'organization', 1016, 'Підприємство', 400, 0, NULL),
(225, 36, 'person_name', 1, 'Им''я фізичної особи', 500, 0, NULL),
(226, 36, 'person_drfo', 1, 'Код ДРФО', 600, 0, NULL),
(227, 36, 'address', 4, 'Адреса', 700, 0, NULL),
(228, 36, 'phone1', 18, 'Телефон 1', 800, 0, ''),
(229, 36, 'phone2', 18, 'Телефон 2', 900, 0, ''),
(230, 36, 'delivery_reply', 1017, 'Форма надання відповіді', 1000, 0, NULL),
(231, 36, 'email', 19, 'E-Mail', 1100, 0, ''),
(232, 36, 'service', 1015, 'Послуга', 1200, 0, NULL),
(233, 36, 'tracknumber', 8, 'Трек-номер', 1300, 0, NULL),
(234, 36, 'context', 4, 'Короткий зміст', 1400, 0, NULL),
(235, 36, 'reason', 4, 'Висновок', 1500, 0, NULL),
(236, 36, 'reply', 1018, 'Результат', 1600, 0, NULL),
(237, 36, 'file_petition', 14, 'Заява', 1700, 0, NULL),
(238, 36, 'file_petition_fileedsname', 15, 'Заява - Имя файла', 0, 1, NULL),
(239, 36, 'initeds', 13, 'Java-аплет.', 1, 0, NULL),
(240, 36, 'plandate', 3, 'Запланована дата виконання', 1800, 0, NULL),
(241, 36, 'factdate', 3, 'Дата виконання', 1900, 0, NULL),
(242, 36, 'administrator', 2, 'Администратор', 2000, 0, NULL),
(243, 36, 'executor', 2, 'Виконавец', 2100, 0, NULL),
(244, 36, 'file_result', 14, 'Результат рассмотрения', 2200, 0, NULL),
(245, 36, 'file_result_fileedsname', 15, 'Результат рассмотрения - Имя файла', 0, 1, NULL),
(246, 38, 'registry', 2, NULL, 0, 1, NULL),
(247, 38, 'storage', 2, NULL, 0, 1, NULL),
(248, 38, 'createdate', 17, 'Время создания документа', 0, 1, 'DBDEFAULT: NOT NULL DEFAULT CURRENT_TIMESTAMP'),
(249, 38, 'route', 1003, 'Маршрут', 0, 1, NULL),
(250, 38, 'available_nodes', 1010, 'Список узлов в которых находится документ', 0, 1, NULL),
(251, 38, 'available_actions', 1013, 'Действия с документом', 0, 1, NULL),
(252, 38, 'regnum', 1, 'Реєстраційний номер', 100, 1, NULL),
(253, 38, 'regdate', 3, 'Дата реєстрації', 200, 1, NULL),
(254, 38, 'legal_personality', 1014, 'Правова форма', 300, 1, NULL),
(255, 38, 'organization', 1016, 'Підприємство', 400, 1, NULL),
(256, 38, 'person_name', 1, 'Им''я фізичної особи', 500, 1, NULL),
(257, 38, 'person_drfo', 1, 'Код ДРФО', 600, 1, NULL),
(258, 38, 'address', 4, 'Адреса', 700, 1, NULL),
(259, 38, 'phone1', 18, 'Телефон 1', 800, 1, ''),
(260, 38, 'phone2', 18, 'Телефон 2', 900, 1, ''),
(261, 38, 'delivery_reply', 1017, 'Форма надання відповіді', 1000, 1, 'DBDEFAULT: DEFAULT 88'),
(262, 38, 'email', 19, 'E-Mail', 1100, 1, ''),
(263, 38, 'service', 1015, 'Послуга', 1200, 1, 'DBDEFAULT: DEFAULT 61'),
(264, 38, 'tracknumber', 8, 'Трек-номер', 1300, 1, NULL),
(265, 38, 'context', 4, 'Короткий зміст', 1400, 1, NULL),
(266, 38, 'reason', 4, 'Висновок', 1500, 1, NULL),
(267, 38, 'reply', 1018, 'Результат', 1600, 1, NULL),
(268, 38, 'file_petition', 14, 'Заява', 1700, 1, NULL),
(269, 38, 'file_petition_fileedsname', 15, 'Заява - Имя файла', 0, 1, NULL),
(270, 38, 'initeds', 13, 'Java-аплет.', 1, 1, ''),
(271, 38, 'plandate', 3, 'Запланована дата виконання', 1800, 1, NULL),
(272, 38, 'factdate', 3, 'Дата виконання', 1900, 1, NULL),
(273, 38, 'administrator', 2, 'Администратор', 2000, 1, NULL),
(274, 38, 'executor', 2, 'Виконавец', 2100, 1, NULL),
(275, 38, 'file_result', 14, 'Результат рассмотрения', 2200, 1, NULL),
(276, 38, 'file_result_fileedsname', 15, 'Результат рассмотрения - Имя файла', 0, 1, NULL),
(277, 8, 'deny_new', 1011, 'Исключить из регистрации (Создание документа)', 450, 0, ''),
(278, 26, 'ownernodes', 1002, 'Владельцам узлов', 700, 0, '');

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `ff_listtables`
--
CREATE TABLE IF NOT EXISTS `ff_listtables` (
`TABLE_NAME` varchar(64)
);
-- --------------------------------------------------------

--
-- Структура таблицы `ff_oneline`
--

CREATE TABLE IF NOT EXISTS `ff_oneline` (
  `id` int(11) NOT NULL,
  `registry` int(11) DEFAULT NULL,
  `storage` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=481;

--
-- Дамп данных таблицы `ff_oneline`
--

INSERT INTO `ff_oneline` (`id`, `registry`, `storage`, `name`) VALUES
(1, 12, 7, 'Кабінет заявника'),
(3, 12, 7, 'Кабінет адміністратора'),
(5, 3, 15, 'Фізична особа'),
(6, 3, 15, 'Фізична особа - підприємець'),
(7, 3, 15, 'Юридична особа'),
(8, 12, 7, 'Кабінет виконавця'),
(10, 8, 6, 'Розглядаються'),
(11, 8, 6, 'Є рішення'),
(12, 8, 6, 'Надісланні'),
(13, 8, 6, 'У роботі'),
(17, 8, 6, 'У виконавця'),
(18, 8, 6, 'Прийняте рішення'),
(19, 8, 6, 'Архив'),
(20, 8, 6, 'Надісланні'),
(21, 8, 6, 'У роботі'),
(22, 8, 6, 'Виконано'),
(43, 6, 4, 'Нові (Заявник)'),
(44, 6, 4, 'На розляді у Адміністратора'),
(45, 6, 4, 'Прийняті у роботу (Адміністратор)'),
(46, 6, 4, 'У виконавця'),
(47, 6, 4, 'Виконані'),
(48, 6, 4, 'В архіві'),
(68, 6, 4, 'У виконавця в роботі'),
(82, 37, 18, NULL),
(84, 37, 18, NULL),
(86, 37, 18, NULL),
(88, 3, 19, 'Сайт'),
(89, 3, 19, 'Особисто'),
(90, 3, 19, 'Пошта'),
(91, 3, 20, 'Відмовленно'),
(92, 3, 20, 'Прийняте рішення'),
(93, 3, 20, 'Видано дозвільний документ'),
(94, 25, 3, 'Направити на розгляд'),
(98, 25, 3, 'Прийняті у роботу'),
(101, 37, 18, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `ff_organization`
--

CREATE TABLE IF NOT EXISTS `ff_organization` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '37',
  `storage` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `edrpou` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=5461;

--
-- Дамп данных таблицы `ff_organization`
--

INSERT INTO `ff_organization` (`id`, `registry`, `storage`, `name`, `edrpou`) VALUES
(82, 37, 18, NULL, NULL),
(84, 37, 18, NULL, NULL),
(86, 37, 18, NULL, NULL),
(101, 37, 18, NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `ff_ref_multiguide`
--

CREATE TABLE IF NOT EXISTS `ff_ref_multiguide` (
  `id` int(11) NOT NULL,
  `registry` int(11) DEFAULT NULL,
  `storage` int(11) DEFAULT NULL,
  `order` int(11) DEFAULT NULL,
  `owner` bigint(20) DEFAULT NULL,
  `owner_field` varchar(255) DEFAULT NULL,
  `reference` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=287;

--
-- Дамп данных таблицы `ff_ref_multiguide`
--

INSERT INTO `ff_ref_multiguide` (`id`, `registry`, `storage`, `order`, `owner`, `owner_field`, `reference`) VALUES
(4, 2, 2, NULL, 3, 'role', 2),
(9, 2, 2, NULL, 8, 'role', 3),
(16, 2, 2, NULL, 13, 'allow', 16),
(23, 2, 2, NULL, 1, 'folders', 10),
(24, 2, 2, 1, 1, 'folders', 11),
(25, 2, 2, NULL, 1, 'role', 4),
(29, 2, 2, NULL, 1, 'folders', 10),
(30, 2, 2, 1, 1, 'folders', 11),
(31, 2, 2, NULL, 1, 'role', 4),
(32, 2, 2, NULL, 3, 'folders', 12),
(33, 2, 2, 1, 3, 'folders', 13),
(34, 2, 2, 2, 3, 'folders', 17),
(35, 2, 2, 3, 3, 'folders', 18),
(36, 2, 2, 4, 3, 'folders', 19),
(37, 2, 2, NULL, 3, 'role', 2),
(38, 2, 2, 4, 8, 'folders', 19),
(39, 2, 2, 1, 8, 'folders', 20),
(40, 2, 2, 2, 8, 'folders', 21),
(41, 2, 2, 3, 8, 'folders', 22),
(42, 2, 2, NULL, 8, 'role', 3),
(49, 2, 2, NULL, 10, 'nodes', 44),
(50, 2, 2, 1, 10, 'nodes', 45),
(51, 2, 2, 2, 10, 'nodes', 46),
(52, 2, 2, NULL, 11, 'nodes', 47),
(53, 2, 2, 1, 11, 'nodes', 48),
(54, 2, 2, NULL, 12, 'nodes', 44),
(55, 2, 2, NULL, 13, 'nodes', 45),
(56, 2, 2, NULL, 13, 'nodes', 45),
(57, 2, 2, NULL, 13, 'allow_new', 16),
(58, 2, 2, NULL, 13, 'allow_edit', 16),
(59, 2, 2, NULL, 13, 'allow_delete', 16),
(60, 2, 2, NULL, 13, 'nodes', 45),
(61, 2, 2, NULL, 13, 'allow_new', 16),
(62, 2, 2, NULL, 13, 'allow_edit', 16),
(63, 2, 2, NULL, 13, 'allow_delete', 16),
(64, 2, 2, NULL, 17, 'nodes', 46),
(65, 2, 2, NULL, 18, 'nodes', 47),
(66, 2, 2, NULL, 19, 'nodes', 48),
(67, 2, 2, NULL, 20, 'nodes', 46),
(69, 2, 2, NULL, 17, 'nodes', 46),
(70, 2, 2, NULL, 17, 'nodes', 46),
(71, 2, 2, 1, 17, 'nodes', 68),
(72, 2, 2, NULL, 18, 'nodes', 47),
(73, 2, 2, NULL, 19, 'nodes', 48),
(74, 2, 2, NULL, 20, 'nodes', 46),
(75, 2, 2, NULL, 21, 'nodes', 68),
(76, 2, 2, NULL, 22, 'nodes', 47),
(77, 2, 2, NULL, 13, 'nodes', 45),
(78, 2, 2, NULL, 13, 'allow_new', 16),
(79, 2, 2, NULL, 13, 'deny_new', 36),
(80, 2, 2, NULL, 13, 'allow_edit', 16),
(81, 2, 2, NULL, 13, 'allow_delete', 16),
(95, 2, 2, NULL, 94, 'gotonodes', 44),
(96, 2, 2, NULL, 94, 'clearnodes', 43),
(97, 2, 2, NULL, 94, 'roles', 2),
(99, 2, 2, NULL, 98, 'gotonodes', 45),
(100, 2, 2, NULL, 98, 'clearnodes', 44);

-- --------------------------------------------------------

--
-- Структура таблицы `ff_registry`
--

CREATE TABLE IF NOT EXISTS `ff_registry` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent` int(11) DEFAULT NULL COMMENT 'ссылка на родителя',
  `tablename` varchar(45) NOT NULL COMMENT 'Имя таблицы в которая используется для хранения данных свободной формы',
  `description` tinytext COMMENT 'описание',
  `protected` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Блокировка/ системная таблица',
  `attaching` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'равен 1 если таблица создана не методами свободных форм',
  `copying` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'При 1 потомки копируют свои значения в эту таблицу',
  `view` varchar(255) DEFAULT NULL COMMENT 'Зарезирвированно, предполагается через этот параметр подключать разные формы отображения документов',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `table_UNIQUE` (`tablename`) USING BTREE,
  KEY `parent` (`parent`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=546 COMMENT='Список зарегистрированных свободных форм' AUTO_INCREMENT=39 ;

--
-- Дамп данных таблицы `ff_registry`
--

INSERT INTO `ff_registry` (`id`, `parent`, `tablename`, `description`, `protected`, `attaching`, `copying`, `view`) VALUES
(1, NULL, 'default', 'Корневая родительская свободная форма', 1, 0, 1, NULL),
(2, 1, 'ref_multiguide', 'Системный справочник многие-ко-многим', 1, 0, 1, NULL),
(3, 1, 'oneline', 'Однострочный справочник', 1, 0, 1, NULL),
(4, 3, 'commentline', 'Справочник с комментированием', 1, 0, 0, NULL),
(5, 4, 'route_action', 'Действия на маршруте', 0, 0, 1, NULL),
(6, 4, 'route_node', 'Узлы маршрута', 0, 0, 1, NULL),
(7, 4, 'route', 'Маршрут', 0, 0, 1, NULL),
(8, 4, 'route_folder', 'Папки маршрута', 0, 0, 1, NULL),
(9, 4, 'route_cabinet', 'Кабинеты пользователей', 0, 0, 1, NULL),
(10, NULL, 'cab_user', 'Внутрение пользователи', 0, 1, 0, NULL),
(11, NULL, 'cab_user_roles', 'Роли пользователей', 0, 1, 0, NULL),
(12, 9, 'route_cabinet_for_role', 'Кабинет пользователя с розделением по ролям', 0, 0, 1, NULL),
(13, 1, 'document_base', 'Базовый документ', 0, 0, 1, NULL),
(15, 9, 'route_cabinet_for_users', 'Кабинет пользователя с разделением по пользователям', 0, 0, 1, NULL),
(16, 1, 'available_nodes', 'Доступные узлы для определенных пользователей на маршруте', 0, 0, 1, NULL),
(17, 16, 'available_nodes_for_users', 'Список доступных узлов для круга пользователей', 0, 0, 1, NULL),
(18, 16, 'available_nodes_for_roles', 'Список доступных узлов для списка ролей', 0, 0, 1, NULL),
(19, NULL, 'ff_registry', 'Таблица регистраций', 0, 1, 0, NULL),
(20, NULL, 'ff_storage', 'Список хранилищ', 0, 1, 0, NULL),
(21, 1, 'available_actions', 'Список разрешенных действий с документом', 0, 0, 1, NULL),
(22, 21, 'available_actions_for_roles', 'Разшенные действия с документом для набора ролей', 0, 0, 0, NULL),
(23, 21, 'available_actions_for_users', 'Список разрешенных действий с документом в узле для перечня пользователей', 0, 0, 1, NULL),
(25, 5, 'route_action_for_role', 'Действие с привязкой к роли', 0, 0, 1, NULL),
(26, 5, 'route_action_for_user', 'Действие с привязкой к пользователям', 0, 0, 1, NULL),
(27, 7, 'route_for_role', 'Маршрут с применением роли', 0, 0, 1, NULL),
(28, 7, 'route_for_user', 'Маршрут с применением списка пользователей', 0, 0, 1, NULL),
(30, NULL, 'gen_services', 'Перечень услуг', 0, 1, 0, NULL),
(36, 13, 'document_cnap', 'Документ для отримання адміністративних послуг', 0, 0, 1, NULL),
(37, 3, 'organization', 'Организация', 0, 0, 1, NULL),
(38, 36, 'document_cnap_metolobruht', 'заготівлі, переробки, металургійної переробки металобрухту кольорових і чорних металів', 0, 0, 0, NULL);

--
-- Триггеры `ff_registry`
--
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
DROP TRIGGER IF EXISTS `ff_registry_ad`;
DELIMITER //
CREATE TRIGGER `ff_registry_ad` AFTER DELETE ON `ff_registry`
 FOR EACH ROW begin
	if (@disable_triggers is null) then
		delete from `ff_registry_h` where `owner`= old.id;		
	end if;
end
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `ff_registry_h`
--

CREATE TABLE IF NOT EXISTS `ff_registry_h` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` int(11) NOT NULL COMMENT 'Основная таблица',
  `parent` int(11) NOT NULL COMMENT 'Родители основной талицы',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_parent_idx` (`parent`) USING BTREE,
  KEY `idx_owner` (`owner`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=190 COMMENT='Иерархия(вспомогательная таблиц' AUTO_INCREMENT=134 ;

--
-- Дамп данных таблицы `ff_registry_h`
--

INSERT INTO `ff_registry_h` (`id`, `owner`, `parent`) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 2, 1),
(4, 3, 1),
(5, 3, 1),
(6, 4, 1),
(7, 4, 1),
(9, 4, 3),
(10, 5, 1),
(11, 5, 1),
(12, 5, 3),
(13, 5, 4),
(14, 6, 1),
(15, 6, 1),
(16, 6, 3),
(17, 6, 4),
(18, 7, 1),
(19, 7, 1),
(20, 7, 3),
(21, 7, 4),
(22, 8, 1),
(23, 8, 1),
(24, 8, 3),
(25, 8, 4),
(26, 9, 1),
(27, 9, 1),
(28, 9, 3),
(29, 9, 4),
(30, 12, 1),
(31, 12, 1),
(32, 12, 3),
(33, 12, 4),
(37, 12, 9),
(38, 13, 1),
(39, 13, 1),
(44, 15, 1),
(45, 15, 1),
(46, 15, 3),
(47, 15, 4),
(51, 15, 9),
(52, 16, 1),
(53, 16, 1),
(54, 17, 1),
(55, 17, 1),
(57, 17, 16),
(58, 18, 1),
(59, 18, 1),
(61, 18, 16),
(62, 21, 1),
(63, 21, 1),
(64, 22, 1),
(65, 22, 1),
(67, 22, 21),
(68, 23, 1),
(69, 23, 1),
(71, 23, 21),
(76, 25, 1),
(77, 25, 1),
(78, 25, 3),
(79, 25, 4),
(83, 25, 5),
(84, 26, 1),
(85, 26, 1),
(86, 26, 3),
(87, 26, 4),
(91, 26, 5),
(92, 27, 1),
(93, 27, 1),
(94, 27, 3),
(95, 27, 4),
(99, 27, 7),
(100, 28, 1),
(101, 28, 1),
(102, 28, 3),
(103, 28, 4),
(107, 28, 7),
(122, 36, 1),
(123, 36, 1),
(125, 36, 13),
(126, 37, 1),
(127, 37, 1),
(129, 37, 3),
(130, 38, 1),
(131, 38, 1),
(132, 38, 13),
(133, 38, 36);

-- --------------------------------------------------------

--
-- Структура таблицы `ff_registry_storage`
--

CREATE TABLE IF NOT EXISTS `ff_registry_storage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `registry` int(11) NOT NULL COMMENT 'Ссылка на регистрацию свободной формы',
  `storage` int(11) NOT NULL COMMENT 'Ссылка на хранилище в свободной форме',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_registry_idx` (`registry`) USING BTREE,
  KEY `fk_storage_idx` (`storage`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=546 COMMENT='Привязка форм и хранилищ' AUTO_INCREMENT=62 ;

--
-- Дамп данных таблицы `ff_registry_storage`
--

INSERT INTO `ff_registry_storage` (`id`, `registry`, `storage`) VALUES
(1, 1, 1),
(2, 2, 2),
(4, 6, 4),
(15, 8, 6),
(22, 9, 7),
(23, 12, 7),
(24, 15, 7),
(29, 10, 9),
(32, 16, 11),
(33, 17, 11),
(34, 18, 11),
(36, 20, 13),
(37, 21, 14),
(38, 22, 14),
(39, 23, 14),
(42, 5, 3),
(43, 25, 3),
(44, 26, 3),
(45, 7, 5),
(46, 27, 5),
(47, 28, 5),
(48, 3, 15),
(52, 37, 18),
(53, 3, 19),
(54, 3, 20),
(55, 11, 10),
(58, 30, 17),
(59, 36, 16),
(60, 38, 16),
(61, 19, 12);

-- --------------------------------------------------------

--
-- Структура таблицы `ff_route`
--

CREATE TABLE IF NOT EXISTS `ff_route` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '7',
  `storage` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `comment` text,
  `start_route` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `ff_route_action`
--

CREATE TABLE IF NOT EXISTS `ff_route_action` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '5',
  `storage` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `comment` text,
  `gotonodes` int(11) DEFAULT NULL,
  `clearnodes` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=8192;

--
-- Дамп данных таблицы `ff_route_action`
--

INSERT INTO `ff_route_action` (`id`, `registry`, `storage`, `name`, `comment`, `gotonodes`, `clearnodes`) VALUES
(94, 25, 3, 'Направити на розгляд', 'Заявник направляє документ на розгляд до ЦНАП', NULL, NULL),
(98, 25, 3, 'Прийняті у роботу', 'Адміністратор приймає у роботу документ', NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `ff_route_action_for_role`
--

CREATE TABLE IF NOT EXISTS `ff_route_action_for_role` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '25',
  `storage` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `comment` text,
  `gotonodes` int(11) DEFAULT NULL,
  `clearnodes` int(11) DEFAULT NULL,
  `setroles` int(11) DEFAULT NULL,
  `roles` int(11) DEFAULT NULL,
  `currentrole` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=8192;

--
-- Дамп данных таблицы `ff_route_action_for_role`
--

INSERT INTO `ff_route_action_for_role` (`id`, `registry`, `storage`, `name`, `comment`, `gotonodes`, `clearnodes`, `setroles`, `roles`, `currentrole`) VALUES
(94, 25, 3, 'Направити на розгляд', 'Заявник направляє документ на розгляд до ЦНАП', NULL, NULL, NULL, NULL, 1),
(98, 25, 3, 'Прийняті у роботу', 'Адміністратор приймає у роботу документ', NULL, NULL, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `ff_route_action_for_user`
--

CREATE TABLE IF NOT EXISTS `ff_route_action_for_user` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '26',
  `storage` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `comment` text,
  `gotonodes` int(11) DEFAULT NULL,
  `clearnodes` int(11) DEFAULT NULL,
  `users` int(11) DEFAULT NULL,
  `currentuser` tinyint(4) DEFAULT NULL,
  `ownernodes` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `ff_route_cabinet`
--

CREATE TABLE IF NOT EXISTS `ff_route_cabinet` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '9',
  `storage` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `comment` text,
  `folders` int(11) DEFAULT NULL,
  `role` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=5461;

--
-- Дамп данных таблицы `ff_route_cabinet`
--

INSERT INTO `ff_route_cabinet` (`id`, `registry`, `storage`, `name`, `comment`, `folders`, `role`) VALUES
(1, 12, 7, 'Кабінет заявника', 'Перегляд документі які на розгляді у завника', NULL, NULL),
(3, 12, 7, 'Кабінет адміністратора', 'Перегляд документів, які знаходяться на розгляді адміністратора', NULL, NULL),
(8, 12, 7, 'Кабінет виконавця', 'Кабінет в якому обробляе документи представник виконачих органів', NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `ff_route_cabinet_for_role`
--

CREATE TABLE IF NOT EXISTS `ff_route_cabinet_for_role` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '12',
  `storage` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `comment` text,
  `folders` int(11) DEFAULT NULL,
  `role` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=5461;

--
-- Дамп данных таблицы `ff_route_cabinet_for_role`
--

INSERT INTO `ff_route_cabinet_for_role` (`id`, `registry`, `storage`, `name`, `comment`, `folders`, `role`) VALUES
(1, 12, 7, 'Кабінет заявника', 'Перегляд документі які на розгляді у завника', NULL, NULL),
(3, 12, 7, 'Кабінет адміністратора', 'Перегляд документів, які знаходяться на розгляді адміністратора', NULL, NULL),
(8, 12, 7, 'Кабінет виконавця', 'Кабінет в якому обробляе документи представник виконачих органів', NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `ff_route_cabinet_for_users`
--

CREATE TABLE IF NOT EXISTS `ff_route_cabinet_for_users` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '15',
  `storage` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `comment` text,
  `folders` int(11) DEFAULT NULL,
  `users` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `ff_route_folder`
--

CREATE TABLE IF NOT EXISTS `ff_route_folder` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '8',
  `storage` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `comment` text,
  `nodes` int(11) DEFAULT NULL,
  `allow_new` int(11) DEFAULT NULL,
  `allow_edit` int(11) DEFAULT NULL,
  `allow_delete` int(11) DEFAULT NULL,
  `visual_names` text,
  `deny_new` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=1638;

--
-- Дамп данных таблицы `ff_route_folder`
--

INSERT INTO `ff_route_folder` (`id`, `registry`, `storage`, `name`, `comment`, `nodes`, `allow_new`, `allow_edit`, `allow_delete`, `visual_names`, `deny_new`) VALUES
(10, 8, 6, 'Розглядаються', 'Документи які обробляються у виконавчому органі', NULL, NULL, NULL, NULL, NULL, NULL),
(11, 8, 6, 'Є рішення', 'Дкументи по якім виконавчий орган прийняв рішення', NULL, NULL, NULL, NULL, NULL, NULL),
(12, 8, 6, 'Надісланні', 'Документи які надійшли до Адміністратора ЦНАП', NULL, NULL, NULL, NULL, NULL, NULL),
(13, 8, 6, 'У роботі', 'Документи які Адміністратор ЦНАП прийняв у роботу, або створив', NULL, NULL, NULL, NULL, NULL, NULL),
(17, 8, 6, 'У виконавця', 'Документи, які Адміністратор ЦПАП надійслав до виконавчого органу', NULL, NULL, NULL, NULL, NULL, NULL),
(18, 8, 6, 'Прийняте рішення', 'Документи, по якім виконавчий орган прийняв рішення', NULL, NULL, NULL, NULL, NULL, NULL),
(19, 8, 6, 'Архив', 'Документи, які Адміністратор ЦНАП поклав до архіву', NULL, NULL, NULL, NULL, NULL, NULL),
(20, 8, 6, 'Надісланні', 'Документи які надійшли до виконавчого органу', NULL, NULL, NULL, NULL, NULL, NULL),
(21, 8, 6, 'У роботі', 'Документи, які представник виконавчого органу прийняв у роботу', NULL, NULL, NULL, NULL, NULL, NULL),
(22, 8, 6, 'Виконано', 'Документи, по якім представник виконавчого органу виніс рішення', NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `ff_route_for_role`
--

CREATE TABLE IF NOT EXISTS `ff_route_for_role` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '27',
  `storage` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `comment` text,
  `start_route` int(11) DEFAULT NULL,
  `roles` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `ff_route_for_user`
--

CREATE TABLE IF NOT EXISTS `ff_route_for_user` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '28',
  `storage` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `comment` text,
  `start_route` int(11) DEFAULT NULL,
  `users` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `ff_route_node`
--

CREATE TABLE IF NOT EXISTS `ff_route_node` (
  `id` int(11) NOT NULL,
  `registry` int(11) NOT NULL DEFAULT '6',
  `storage` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `comment` text,
  `allow_action` int(11) DEFAULT NULL,
  `deny_action` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=2340;

--
-- Дамп данных таблицы `ff_route_node`
--

INSERT INTO `ff_route_node` (`id`, `registry`, `storage`, `name`, `comment`, `allow_action`, `deny_action`) VALUES
(43, 6, 4, 'Нові (Заявник)', 'Документи зареєстровані заявником', NULL, NULL),
(44, 6, 4, 'На розляді у Адміністратора', 'На розляді у Адміністратора', NULL, NULL),
(45, 6, 4, 'Прийняті у роботу (Адміністратор)', 'Прийняті у роботу Адміністратором', NULL, NULL),
(46, 6, 4, 'У виконавця', 'Документи надіслані до виконавчого органу', NULL, NULL),
(47, 6, 4, 'Виконані', 'Документи виконані виконачим органом', NULL, NULL),
(48, 6, 4, 'В архіві', 'Документи які направленні до архіву', NULL, NULL),
(68, 6, 4, 'У виконавця в роботі', 'Документи, які виконавець прийняв до роботи', NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `ff_storage`
--

CREATE TABLE IF NOT EXISTS `ff_storage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT 'Имя хранилища',
  `description` tinytext COMMENT 'Описание хранилища',
  `subtype` int(11) NOT NULL DEFAULT '0' COMMENT 'Подтип. Используется для отображения разных справочников',
  `type` int(11) DEFAULT NULL COMMENT 'Ссылка на таблицу типов',
  `fields` tinytext,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_type` (`type`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=819 COMMENT='Хранилище свободной формы' AUTO_INCREMENT=21 ;

--
-- Дамп данных таблицы `ff_storage`
--

INSERT INTO `ff_storage` (`id`, `name`, `description`, `subtype`, `type`, `fields`) VALUES
(1, 'default', 'Хранилище по умолчанию', 0, NULL, NULL),
(2, 'ref_multiguide_storage', 'Хранилище для хранения связок', 0, NULL, NULL),
(3, 'actions', 'Действия на узлах маршрута', 5, 1001, NULL),
(4, 'nodes', 'Перечень узлов маршрута', 5, 1002, NULL),
(5, 'routes', 'Маршруты', 1, 1003, NULL),
(6, 'folders', 'Папки кабинета', 5, 1007, NULL),
(7, 'cabinets', 'Кабинеты', 0, NULL, NULL),
(8, 'Тестовые документы', 'Хранилище для тестирования документов', 0, NULL, NULL),
(9, 'Список пользователей', 'Проба работы с внешними таблицами', 5, 1008, NULL),
(10, 'Роли', 'Проба работы с внешними таблицами', 5, 1009, 'user_role'),
(11, 'Доступные узлы', 'Доступные узлы(available nodes) документа', 5, 1010, NULL),
(12, 'Список регистраций свободных форм', 'Список зарегистрированых свободных форм', 5, 1011, 'tablename:Название;description:Описание'),
(13, 'Список хранилищ', 'Список зарегистрированных хранилищ', 5, 1012, 'name:Название;description:Описание'),
(14, 'Доступные действия', 'Перечень доступных действий в узле', 5, 1013, NULL),
(15, 'Правовая форма', 'Физик, Юрик', 4, 1014, NULL),
(16, 'Документы ЦНАП', 'Документы по получению админуслуг', 0, NULL, ''),
(17, 'Услуги', 'Список услуг', 1, 1015, 'name'),
(18, 'Организации', 'Встраиваемый справочник в документ ЦНАП', 3, 1016, NULL),
(19, 'Вид доставки', 'Вид доставки', 1, 1017, NULL),
(20, 'Результат виконання', 'Довідник з результатами виконання', 1, 1018, NULL);

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
		set vview = '';
		case new.`subtype`
			when 0 then set vview = '';
			when 1 then set vview = 'combobox';
			when 2 then set vview = 'listbox';
			when 3 then set vview = 'innerguide';
			when 4 then set vview = 'radiobox';
			when 5 then set vview = 'listbox_multi';
			-- when 6 then set vview = 'listbox_multi_external';
			else set vview = '';
		end case;
		if (vview = '') then
			DELETE FROM `ff_types` 
				where id=old.`type`;
			set new.`type`= null;
		else 
			if ((old.`subtype` is null) or (old.`subtype` = 0)) then
				insert into `ff_types` (`typename`,`systemtype`,`description`, `view`)
				VALUES (new.`name`,'INT(11)',new.`description`,vview);
				set new.`type`=LAST_INSERT_ID();
			else
				update `ff_types` set 
					`typename` = new.`name`,
					`description` = new.`description`,
					`view`=vview
				where id=new.`type`;
			end if;
		end if;
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
		set vview = '';
		case new.`subtype`
			when 0 then set vview = '';
			when 1 then set vview = 'combobox';
			when 2 then set vview = 'listbox';
			when 3 then set vview = 'innerguide';
			when 4 then set vview = 'radiobox';
			when 5 then set vview = 'listbox_multi';
			-- when 6 then set vview = 'listbox_multi_external';
			else set vview = '';
		end case;
		set new.`type`=null;
		if (vview <> '') then
			insert into `ff_types` (`typename`,`systemtype`,`description`, `view`)
			VALUES (new.`name`,'INT(11)',new.`description`,vview);
			set new.`type`=LAST_INSERT_ID();
		end if;
    end if;
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `ff_types`
--

CREATE TABLE IF NOT EXISTS `ff_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `typename` varchar(255) NOT NULL COMMENT 'Имя типа отображаемого в свободной форме',
  `systemtype` varchar(255) DEFAULT NULL COMMENT 'Имя типа используемого для генерации таблиц',
  `view` varchar(255) DEFAULT NULL COMMENT 'Путь к визуальному представлению типа',
  `description` tinytext COMMENT 'Описание',
  `visible` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Признак отображения типа в списке типов',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=481 COMMENT='Список зарегистрированных типов' AUTO_INCREMENT=1019 ;

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
(9, 'Картинка', 'MEDIUMBLOB', 'image', '', 1),
(10, 'Файл', 'LONGBLOB', 'file', 'Загружаемый файл', 1),
(11, 'filetype', 'VARCHAR(55)', NULL, 'MIME-тип файла', 0),
(12, 'filename', 'VARCHAR(255)', NULL, 'Имя файла', 0),
(13, 'Инициализация ЭЦП', NULL, 'initsign', 'Если файлы в документе будут подписывать, то в документе должен присутствовать', 1),
(14, 'Файл с подписью', 'LONGBLOB', 'filesign', 'Данные файла с подписью', 1),
(15, 'fileedsname', 'VARCHAR(255)', NULL, 'Имя файла', 0),
(16, 'CKeditor', 'TEXT', 'ckeditor', 'WYSIWYG-редактор', 1),
(17, 'Штамп времени', 'TIMESTAMP', 'datetime', 'Отображает дату и время', 1),
(18, 'Телефон', 'VARCHAR(20)', 'phone', 'Телефон', 1),
(19, 'E-mail', 'VARCHAR(70)', 'email', 'Электронный адрес', 1),
(1001, 'actions', 'INT(11)', 'listbox_multi', 'Действия на узлах маршрута', 1),
(1002, 'nodes', 'INT(11)', 'listbox_multi', 'Перечень узлов маршрута', 1),
(1003, 'routes', 'INT(11)', 'combobox', 'Маршруты', 1),
(1007, 'folders', 'INT(11)', 'listbox_multi', 'Папки кабинета', 1),
(1008, 'Список пользователей', 'INT(11)', 'listbox_multi', 'Проба работы с внешними таблицами', 1),
(1009, 'Роли', 'INT(11)', 'listbox_multi', 'Проба работы с внешними таблицами', 1),
(1010, 'Доступные узлы', 'INT(11)', 'listbox_multi', 'Доступные узлы(available nodes) документа', 1),
(1011, 'Список регистраций свободных форм', 'INT(11)', 'listbox_multi', 'Список зарегистрированых свободных форм', 1),
(1012, 'Список хранилищ', 'INT(11)', 'listbox_multi', 'Список зарегистрированных хранилищ', 1),
(1013, 'Доступные действия', 'INT(11)', 'listbox_multi', 'Перечень доступных действий в узле', 1),
(1014, 'Правовая форма', 'INT(11)', 'radiobox', 'Физик, Юрик', 1),
(1015, 'Услуги', 'INT(11)', 'combobox', 'Список услуг', 1),
(1016, 'Организации', 'INT(11)', 'innerguide', 'Встраиваемый справочник в документ ЦНАП', 1),
(1017, 'Вид доставки', 'INT(11)', 'combobox', 'Вид доставки', 1),
(1018, 'Результат виконання', 'INT(11)', 'combobox', 'Довідник з результатами виконання', 1);

-- --------------------------------------------------------

--
-- Структура таблицы `fpoll_config`
--

CREATE TABLE IF NOT EXISTS `fpoll_config` (
  `user` text NOT NULL,
  `pass` text NOT NULL,
  `bg1` text NOT NULL,
  `bg2` text NOT NULL,
  `text` text NOT NULL,
  `size` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `fpoll_config`
--

INSERT INTO `fpoll_config` (`user`, `pass`, `bg1`, `bg2`, `text`, `size`) VALUES
('admin', '', '#D7D7D7', '#4795C3', '#000000', '14'),
('admin', '202cb962ac59075b964b07152d234b70', '#D7D7D7', '#4795C3', '#000000', '14');

-- --------------------------------------------------------

--
-- Структура таблицы `fpoll_ips`
--

CREATE TABLE IF NOT EXISTS `fpoll_ips` (
  `ip` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `fpoll_ips`
--

INSERT INTO `fpoll_ips` (`ip`) VALUES
('130.0.34.199'),
('94.158.148.193'),
('213.200.49.171'),
('193.200.212.50'),
('37.73.236.235');

-- --------------------------------------------------------

--
-- Структура таблицы `fpoll_options`
--

CREATE TABLE IF NOT EXISTS `fpoll_options` (
  `id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `field` text NOT NULL,
  `votes` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Дамп данных таблицы `fpoll_options`
--

INSERT INTO `fpoll_options` (`id`, `field`, `votes`) VALUES
(1, 'Ð¢Ð°Ðº', '2'),
(2, 'ÐÑ–', '2'),
(3, 'ÐÐµ Ð·Ð½Ð°ÑŽ Ñ‰Ð¾ Ñ†Ðµ', '1');

-- --------------------------------------------------------

--
-- Структура таблицы `fpoll_poll`
--

CREATE TABLE IF NOT EXISTS `fpoll_poll` (
  `id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `question` text NOT NULL,
  `totalvotes` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Дамп данных таблицы `fpoll_poll`
--

INSERT INTO `fpoll_poll` (`id`, `question`, `totalvotes`) VALUES
(1, 'Ð§Ð¸ ÐºÐ¾Ñ€Ð¸ÑÑ‚ÑƒÑ”Ñ‚ÐµÑÑŒ Ð’Ð¸ Ð•Ð¦ÐŸ?', 5);

-- --------------------------------------------------------

--
-- Структура таблицы `gen_authorities`
--

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
  UNIQUE KEY `name_UNIQUE` (`name`),
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
-- Структура таблицы `gen_life_situation`
--

CREATE TABLE IF NOT EXISTS `gen_life_situation` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT 'Життєва ситуація',
  `visability` enum('так','ні') NOT NULL COMMENT 'Видимість',
  `icon` varchar(255) NOT NULL COMMENT 'Піктограма',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Послуги за життєвими ситуаціями' AUTO_INCREMENT=8 ;

--
-- Дамп данных таблицы `gen_life_situation`
--

INSERT INTO `gen_life_situation` (`id`, `name`, `visability`, `icon`) VALUES
(3, 'Переїзд, міграція', 'так', 'couple74.png'),
(4, 'Отримання ліцензії', 'так', 'big57.png'),
(5, 'Отримання паспорту', 'так', 'passport2.png'),
(6, 'Отримання дозволу на діяльність', 'так', 'big57.png'),
(7, 'Державна реєстрація бізнеса', 'так', 'business117.png');

-- --------------------------------------------------------

--
-- Структура таблицы `gen_locations`
--

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
(1, 'Послуги', 0, '/', 0, 1),
(2, 'Про центр', 0, '', 0, 1),
(3, 'Відслідкувати заявку', 0, '', 0, 1),
(4, 'Законодавство', 0, 'regulations', 0, 1),
(5, 'Допомога та підтримка', 0, '', 0, 1),
(6, 'е-ЦНАП', 2, 'ecnap', 0, 1),
(7, 'Контакти центрів', 2, 'contacts', 0, 1),
(8, 'Текстові інструкції', 5, 'instructions', 0, 1),
(9, 'Відео інструкції', 5, 'video', 0, 1),
(10, 'Як отримати ЕЦП?', 5, '', 0, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `gen_news`
--

CREATE TABLE IF NOT EXISTS `gen_news` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `publicationDate` date NOT NULL COMMENT 'Дата публікації',
  `title` varchar(255) NOT NULL COMMENT 'Заголовок',
  `summary` text NOT NULL COMMENT 'Стислий опис новини',
  `text` mediumtext NOT NULL COMMENT 'Зміст новини',
  `img` varchar(255) NOT NULL COMMENT 'Посилання на зображення',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Управління новинами»' AUTO_INCREMENT=4 ;

--
-- Дамп данных таблицы `gen_news`
--

INSERT INTO `gen_news` (`id`, `publicationDate`, `title`, `summary`, `text`, `img`) VALUES
(2, '2014-11-05', 'Система електронного цифрового підпису відпрацьовується на сумісність з європейськими стандартами', 'Система електронного цифрового підпису відпрацьовується на сумісність з європейськими стандартами', '<p>Відбулось засідання міжвідомчої робочої групи Міністерства юстиції України з представниками Адміністрації Державної служби спеціального зв&#39;язку та захисту інформації України, ДП &laquo;Інформаційний центр&raquo; Міністерства юстиції України та Всеукраїнської асоціації &laquo;Інформаційна безпека та інформаційні технології&raquo;.</p>\r\n\r\n<p>Обговорювались та погоджувались проекти Концепції Державної цільової програми стандартизації та розвитку інфраструктури відкритих ключів та надання послуг електронного цифрового підпису (кваліфікованих електронних довірчих послуг) на період з 2014 до 2017 року, Державної цільової програми стандартизації та розвитку інфраструктури відкритих ключів та надання послуг електронного цифрового підпису (кваліфікованих електронних довірчих послуг) на період із 2014 до 2017 року та Наказу Міністерства юстиції України, Адміністрації Державної служби спеціального зв&#39;язку та захисту інформації України &laquo;Про затвердження вимог до алгоритмів, форматів та інтерфейсів, що реалізуються у засобах шифрування та надійних засобах електронного цифрового підпису&raquo;.</p>\r\n\r\n<p>&laquo;Для нас важливо привести вітчизняну електронну систему в інтероперабельний режим &ndash; тобто в режим взаємодії з іншими системами, в даному випадку &ndash; європейською. Тобто система електронного цифрового підпису відпрацьовується на сумісність з європейськими стандартами&raquo;, - зазначив Дмитро Журавльов, начальник Управління функціонування центрального засвідчувального органу Міністерства юстиції України.</p>\r\n\r\n<p>За його словами, сумісність відповідних програмних продуктів дозволить вести різнопланові операції на світовому рівні, виходячи з євроінтеграційних намірів України.</p>\r\n', '<p><img alt="" src="/ckeditor/kcfinder/upload/images/337ead4f01330c982b24a9055fdf697d_400_auto_jpg.jpg" style="float:left; height:172px; margin:2px; width:300px" /></p>\r\n'),
(3, '2014-09-18', 'Онлайн-игра Particle Clicker - почувствуйте себя исследователем элементарных частиц!', 'В ходе прошедшего на днях в ЦЕРНе студенческого мероприятия CERN Summer Student Webfest группа студентов-энтузиастов написала с нуля простую, но симпатичную и затягивающую онлайн-игру Particle Clicker.', 'В ходе прошедшего на днях в ЦЕРНе студенческого мероприятия CERN Summer Student Webfest группа студентов-энтузиастов написала с нуля простую, но симпатичную и затягивающую онлайн-игру Particle Clicker. Игра позволяет погрузиться в мир исследователя элементарных частиц. Она в ненавязчивой форме дает вам возможность почувствовать себя пусть не ученым, но хотя бы менеджером физического эксперимента.\r\n\r\nКликните по игровому полю — и детектор начнет набирать статистику столкновений элементарных частиц. Накопив некоторый объем данных, вы можете проанализировать его. При этом вы открываете некоторое свойство частиц, а у вашего проекта повышается репутация. От репутации зависит финансирование проекта, оно позволяет вам нанимать для работы студентов, постдоков и даже нобелевских лауреатов. Ваша коллаборация растет, и каждый новый человек в команде повышает скорость набора данных — а значит, и темп новых открытий и исследований элементарных частиц. Вы также можете потратить накопленный бюджет на модернизацию детектора или на мероприятия по популяризации своих открытий — всё это тоже сказывается на эффективности работы.', 'http://particle-clicker.web.cern.ch/particle-clicker');

-- --------------------------------------------------------

--
-- Структура таблицы `gen_other_info`
--

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
(2, 'Промисловість', 'так', 'prom.png'),
(3, 'Комунікації та звязок', 'ні', 'com.png'),
(4, 'Сільське господарство', 'так', 'sg.png'),
(6, 'Реклама', 'так', 'rek.png'),
(9, 'Будівництво та архітектура', 'так', 'bud.png'),
(10, 'Культура та релігія', 'так', 'rel.png'),
(11, 'Освіта', 'так', 'osv.png'),
(12, 'Землеустрій', 'ні', 'zem.png'),
(13, 'Спорт', 'так', 'sport.png'),
(14, 'Економіка та інвестиції', 'так', 'econ.png'),
(15, 'Реєстрація бізнеса', 'так', 'biz.png'),
(16, 'Комунікації та зв''язок', 'так', 'com.png'),
(22, 'Сім''я', 'так', 'sim.png'),
(23, 'Соціальне забезпечення', 'так', 'soc.png'),
(24, 'Охорона здоров''я', 'так', 'zdr.png'),
(25, 'Екологія', 'так', 'eko.png'),
(26, 'ЖКГ', 'так', 'gkg.png'),
(27, 'Безпека', 'так', 'bez.png'),
(28, 'Підприємництво', 'ні', 'pid.png');

-- --------------------------------------------------------

--
-- Структура таблицы `gen_serv_classes`
--

CREATE TABLE IF NOT EXISTS `gen_serv_classes` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `item_name` varchar(45) NOT NULL COMMENT 'Назва класу',
  `visability` enum('так','ні') NOT NULL COMMENT 'Видимість (0/1)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `item_name_UNIQUE` (`item_name`)
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
-- Структура таблицы `gen_serv_life_situations`
--

CREATE TABLE IF NOT EXISTS `gen_serv_life_situations` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `service_id` smallint(6) unsigned NOT NULL,
  `life_situation_id` smallint(6) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `life_situat` (`service_id`,`life_situation_id`),
  KEY `life_situation_idx` (`life_situation_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=16 ;

--
-- Дамп данных таблицы `gen_serv_life_situations`
--

INSERT INTO `gen_serv_life_situations` (`id`, `service_id`, `life_situation_id`) VALUES
(11, 1, 4),
(12, 2, 4),
(13, 13, 4),
(15, 88, 7),
(14, 89, 7),
(8, 112, 5),
(9, 113, 5),
(10, 114, 5),
(4, 115, 3),
(3, 116, 3),
(6, 117, 5),
(7, 118, 5);

-- --------------------------------------------------------

--
-- Структура таблицы `gen_serv_regulations`
--

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
  `ff_link` int(11) DEFAULT NULL COMMENT 'Посилання на вільну форму',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`(255)),
  KEY `id_idx` (`subjnap_id`),
  KEY `id2_idx` (`subjwork_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Відомості про послуги»' AUTO_INCREMENT=121 ;

--
-- Дамп данных таблицы `gen_services`
--

INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`, `ff_link`) VALUES
(1, 'Ліцензування діяльності з надання освітніх послуг у сфері загальної середньої освіти (юридичні особи)', 1, 3, '<ol>\r\n	<li>Закон України від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 13.05.1999 №651-ХІV &nbsp;&laquo;Про загальну середню освіту&raquo;, ст.&nbsp;8 п.1.</li>\r\n	<li>Постанова Кабінету Міністрів України від 08.08.2007 №1019 &laquo;Про ліцензування діяльності з надання освітніх послуг&raquo; (п.&nbsp;2 підпункт 2, п.&nbsp;3, п.&nbsp;11 Порядку ліцензування діяльності з надання освітніх послуг, затвердженого постановою Кабінету Міністрів України від 08.08.2007 №1019).</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>через Центр надання адміністративних послуг</p>\r\n', '<ol>\r\n	<li>Заява про проведення ліцензування із зазначенням виду освітньої послуги і ліцензованого обсягу, реквізитів навчального закладу за затвердженою Міністерством освіти і науки, молоді та спорту України формою.</li>\r\n	<li>Копії установчих документів (статуту, положення, рішення засновника (власника) або уповноваженого ним органу про створення навчального закладу).</li>\r\n	<li>Копії рішень про утворення відокремлених підрозділів та положення про них (у разі ліцензування освітніх послуг у відокремленому підрозділі).</li>\r\n	<li>4.&nbsp;Концепція діяльності за заявленою освітньою послугою, яка ґрунтується на результатах моніторингу регіонального ринку освітніх послуг.</li>\r\n	<li>Копія робочого навчального плану, затвердженого в установленому порядку.</li>\r\n	<li>Відомості про кількісні та якісні показники кадрового забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про кількісні показники матеріально-технічного забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про навчально-методичне забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про кількісні показники інформаційного забезпечення освітньої діяльності, наявність бібліотеки та обсяг її фондів.</li>\r\n	<li>Копії документів, що засвідчують право власності (свідоцтво про право власності, договір купівлі-продажу), оперативного управління (рішення чи повідомлення власника майна про перебування майна в оперативному управлінні) чи користування (договір оренди) основними засобами для здійснення навчально-виховного процесу на строк, необхідний для завершення надання послуги.</li>\r\n	<li>Копії документів про відповідність приміщень навчального закладу та його матеріально-технічної бази санітарним нормам, вимогам правил пожежної безпеки.</li>\r\n	<li>Копії документів, що засвідчують рівень освіти, кваліфікації та громадянство керівника навчального закладу (диплома про вищу освіту, першої сторінки паспорта керівника навчального закладу).</li>\r\n</ol>\r\n', 1, '<p>- Відшкодування витрат, пов&rsquo;язаних з проведенням ліцензійної експертизи &ndash; пункт 24 постанови Кабінету Міністрів України від 08.08.2007 № 1019 &laquo;Про ліцензування діяльності з надання освітніх послуг&raquo;. - Плата за видачу, переоформлення ліцензії, видачу копії та дубліката ліцензії &ndash; пункт 2 постанови Кабінету Міністрів України від 29.08.2003 № 1380 &laquo;Про ліцензування освітніх послуг&raquo;</p>\r\n', '<p>Відшкодування витрат, пов&rsquo;язаних з проведенням ліцензійної експертизи становить &ndash; 24 неоподаткованих мінімумів громадян (408 грн) Плата за видачу ліцензії становить &ndash; 15 неоподаткованих мінімумів доходів громадян (255 грн) Плата за переоформлення ліцензії, видачу копії та дубліката ліцензії &ndash; 5 неоподаткованих мінімумів доходів громадян (85 грн)</p>\r\n', '<p>Реквізити для Відшкодування витрат, пов&rsquo;язаних з проведенням ліцензійної експертизи,- р/р 31256277221575 МФО 828011 код 23207206, одержувач Навчально-методичний центр професійно-технічної освіти в Одеській області, банк одержувача ГУДКСУ в Одеській області.</p>\r\n\r\n<p>Реквізити для внесення плати за видачу ліцензії, переоформлення ліцензії, видачу копії та дубліката ліцензії &ndash; р/р 31413511700001 код 37607526 МФО 828011одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200</p>\r\n', '<p>Три місяці</p>\r\n', '', '<p>Ліцензія або лист з обґрунтуванням причин відмови</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 1, '<p>Спроможність надавати освітні послуги підтверджується результатами ліцензійної експертизи (п.&nbsp;16&sup1; Порядку ліцензування діяльності з надання освітніх послуг, затвердженого постановою Кабінету Міністрів України від 08.08.2007 №1019 &laquo;Про ліцензування діяльності з надання освітніх послуг&raquo;).</p>\r\n', 1, '<p>Оплата послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування здійснюється суб&rsquo;єктом звернення (п.&nbsp;24&nbsp; Порядку ліцензування діяльності з надання освітніх послуг, затвердженого постановою Кабінету Міністрів України від 08.08.2007 №1019 &laquo;Про ліцензування діяльності з надання освітніх послуг&raquo;).</p>\r\n', '<p>Спроможність надавати освітні послуги підтверджується результатами ліцензійної експертизи (п.&nbsp;16&sup1; Порядку ліцензування діяльності з надання освітніх послуг, затвердженого постановою Кабінету Міністрів України від 08.08.2007 №1019 &laquo;Про ліцензування діяльності з надання освітніх послуг&raquo;).</p>\r\n', '<p>Оплата послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування діяльності юридичних осіб у сфері загальної середньої освіти здійснюється суб&rsquo;єктом звернення у розмірі 24 неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p>Оплата послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування перераховується заявником на рахунок регіональної експертної ради &ndash; навчально-методичний центр професійно-технічної освіти в Одеській області р/р&nbsp;31256277221575 МФО&nbsp;828011 код&nbsp;23207206, банк одержувача ГУДКСУ в Одеській області.</p>\r\n', NULL),
(2, 'Ліцензія  на право провадження господарської діяльності з виробництва та транспортування теплової енергії магістральними та місцевими (розподільчими) тепловими мережами', 1, 3, '<p>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ</p>\r\n', '<p>&lt;&gt;</p>\r\n', '<p>через Центр надання адміністративних послуг</p>\r\n', '<p>1.Заява, заповнена відповідно до ст..10 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n\r\n<p>2. Засвідчена в астановленому поррядку копія документа, що підтверджує право власності суб&rsquo;єкта господарювання або оренди ним виробничих об&rsquo;єктів, де провадитиметься відповідний вид господарської діяльності;</p>\r\n\r\n<p>3. Відомості за підписом заявника &ndash; суб&rsquo;єкта господарювання (за формою, встановленою ліцензійними умовами) про:</p>\r\n\r\n<p>3.1 Наявність власних або орендованих виробничих об&rsquo;єктів, де провадитиметься відповідний вид господарської діяльності;</p>\r\n\r\n<p>3.2 Наявність та стан технологічного обладнання і технічної бази для його обслуговування;</p>\r\n\r\n<p>3.3 Освітній та кваліфікаційний рівень працівників, необхідний для провадження відповідного виду господарської діяльності;</p>\r\n\r\n<p>3.4&nbsp; Наявність матеріально-технічної бази, необхідної для провадження відповідного виду господарської діяльності;</p>\r\n\r\n<p>3.5 Технічний стан трубопроводів та споруд на них (на підставі експлуатаційної документації на такі об&rsquo;єкти);</p>\r\n\r\n<p>3.6 Наявність проектної і виконавчої документації на трубопроводи та споруди на них, які використовуються для провадження відповідного виду господарської діяльності;</p>\r\n\r\n<p>3.7 Перелік трубопроводів, що перебувають у користуванні заявника &ndash; суб&rsquo;єкта господарювання, їх технічна характеристика та річні обсяги транспортування теплової енергії;</p>\r\n\r\n<p>3.8 Перелік приладів обліку із зазначенням місць їх встановлення;</p>\r\n\r\n<p>3.9&nbsp; Схема трубопроводів, нанесена на географічну карту місцевості;</p>\r\n\r\n<p>3.10&nbsp; Копія затвердженої міс цевим органом виконавчої влади схеми теплопостачання;</p>\r\n\r\n<p>3.11 Засвідчені в установленому порядку копії актів і схем розмежування&nbsp; ділянок обслуговування між суб&rsquo;єктами господарювання, трубопроводи яких з&rsquo;єднані між собою;</p>\r\n\r\n<p>3.12 Баланс підприємства на останню звітню дату за підписом керівника суб&rsquo;єкта&nbsp; господарювання, скріпленим печаткою;</p>\r\n\r\n<p>3.13 Засвідчені в установленому порядку копії документав, що підтверджують освітний і кваліфікаційний рівень працівників, необхідний для провадження відповідного виду господарської діяльності.</p>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;</p>\r\n', '<p>Одна мінімальна заробітна плата виходячи з її розміру на дату прийняття органам ліцензування рішення про видачу ліцензії.</p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії</p>\r\n', '<p>Одержувач: Г<strong>УДКСУ в Одеській області</strong></p>\r\n\r\n<p>Банк одержувача: Г<strong>УДКСУ в Одеській області</strong></p>\r\n\r\n<p>ОКПО (код):&nbsp;<strong>37607526</strong></p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;<strong>31413511700001</strong></p>\r\n\r\n<p>МФО (код банку):&nbsp;<strong>828011</strong></p>\r\n\r\n<p>Код платежу:&nbsp;<strong>22010200</strong></p>\r\n\r\n<p>Призначення платежу:&nbsp;<strong>плата за видачу ліцензій</strong></p>\r\n', '<p>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж 10 робочих днів з дати надходження заяви про видачу ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної</p>\r\n', '<p>Відмова у видачі ліцензії:</p>\r\n\r\n<p>Недостовірність даних у документах, поданих заявником, для отримання ліцензії;</p>\r\n\r\n<p>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</p>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<p>Заява подана (підписана) особою, яка не має на це повноважень;</p>\r\n\r\n<p>Документи оформлені з порушенням вимог;</p>\r\n\r\n<p>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення</p>\r\n', '<p>Ліцензія&nbsp; на право провадження господарської діяльності з виробництва та транспортування теплової енергії магістральними та місцевими (розподільчими) тепловими мережами або залишення заяви без розгляду</p>\r\n', '<p>через Центр надання адміністративних послуг</p>\r\n', 'так', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(3, 'Висновок по проекту землеустрою щодо відведення земельної ділянки або технічній документації по встановленню меж земельної ділянки', 1, 1, '<p>Земельний кодекс України, ст.ст. 123, 124, 186-1;</p>\r\n\r\n<p>Закон України &laquo;Про землеустрій&raquo;, Закон України &laquo;Про внесення змін до деяких законодавчих актів України щодо вдосконалення процедури відведення земельних ділянок та зміни їх цільового призначення&raquo;.</p>\r\n', '<p>z</p>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради</p>\r\n', '<p>1.Звернення УЗР або</p>\r\n\r\n<p>землевпорядної організації;</p>\r\n\r\n<p>2.Проект землеустрою або</p>\r\n\r\n<p>технічна документація, розроблені землевпорядною організацією відповідно до Еталону (див. п.6)</p>\r\n', 0, '', '', '', '<p>10 робочих днів з дня надання проекту землеустрою на погодження до виконавчого органу</p>\r\n', '<p>Надана документація не відповідає вимогам нормативно-правових актів, зокрема Еталону (див. п.6), у тому числі:&nbsp;</p>\r\n\r\n<p>- не надано відкорегований&nbsp; топогеодезичний план у М 1:500, прийнятий геослужбою м. Одеси;</p>\r\n\r\n<p>- відсутнє погодження суміжних землекористувачів;</p>\r\n\r\n<p>- на земельній ділянці, розташовані самовільно збудовані будівлі, на які не оформлена декларація про введення в експлуатацію;</p>\r\n\r\n<p>- відсутня фотофіксація об&rsquo;єкту;</p>\r\n\r\n<p>- об&rsquo;єкт, розташований на земельній ділянці, знаходиться в неексплуатаційному стані і потребує розробки проектно - кошторисної документації;</p>\r\n\r\n<p>- проект землеустрою розроблений з відхиленнями від погоджених УАМ меж земельної ділянки;</p>\r\n\r\n<p>-&nbsp; не встановлена площа дії сервітутів;</p>\r\n\r\n<p>-&nbsp; земельна ділянка використовується не по цільовому призначенню;</p>\r\n\r\n<p>-&nbsp; на земельній ділянці розташовані об&rsquo;єкти, цільове призначення яких не визначено;</p>\r\n\r\n<p>- &nbsp;площа земельної ділянки не обґрунтована затвердженою проектною або містобудівною документацією;</p>\r\n\r\n<p>- якщо попередній висновок УАМ втратив чинність</p>\r\n', '<p>Висновок</p>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(4, 'Державна реєстрація іноземних інвестицій', 1, 5, '<ul>\r\n	<li>Частина друга статті 13 Закону України &ldquo;Про режим іноземного інвестування&rdquo;</li>\r\n	<li>Постанова Кабінету Міністрів України від 6 березня 2013 р. № 139 Про затвердження Порядку державної реєстрації (перереєстрації) іноземних інвестицій та її анулювання</li>\r\n</ul>\r\n', '<p>Здійснення іноземної інвестиції</p>\r\n', '<p>Документи подаються іноземним інвестором або уповноваженою ним в установленому порядку особою до центру надання адміністративних послуг</p>\r\n', '<ol>\r\n	<li>Інформаційне повідомлення згідно з <a href="http://zakon3.rada.gov.ua/laws/show/139-2013-%D0%BF#n68">додатком 1</a> до Порядку державної реєстрації (перереєстрації) іноземних інвестицій та її анулювання у трьох примірниках з відміткою територіального органу Міністерства доходів і зборів за місцем здійснення інвестицій про їх фактичне здійснення.</li>\r\n	<li>Документи, що підтверджують форму здійснення іноземних інвестицій (установчі документи, договори (контракти) про виробничу кооперацію, спільне виробництво та інші види спільної інвестиційної діяльності, концесійні договори тощо).</li>\r\n	<li>Документи, які підтверджують вартість іноземних інвестицій, що визначається відповідно до статті 2 <a href="http://zakon3.rada.gov.ua/laws/show/93/96-%D0%B2%D1%80" target="_blank">Закону України &ldquo;Про режим іноземного інвестування&rdquo;</a>.</li>\r\n</ol>\r\n\r\n<p><a href="/iasnap/ckeditor/kcfinder/upload/files/nf_pov_domlennya_17_05_2013.doc">Завантажити форму інформаційного повідомлення. </a></p>\r\n', 0, '', '', '', '<p>7 днів</p>\r\n', '<p>Порушення встановленого порядку реєстрації</p>\r\n', '<p>Державна реєстрація іноземної інвестиції (інформаційне повідомлення) або відмова в наданні адміністративної послуги.</p>\r\n', '<p>Адміністративна послуга вважається надана з моменту отримання її через Управління надання адміністративних послуг Одеської міської ради</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(5, 'Перереєстрація іноземних інвестицій', 1, 5, '<p>Закон України &laquo;Про режим іноземного інвестування&raquo; Постанова Кабінету Міністрів України від 6 березня 2013 р. № 139 Про затвердження Порядку державної реєстрації (перереєстрації) іноземних інвестицій та її анулювання.</p>\r\n', '<p>---</p>\r\n', '<p>Документи подаються іноземним інвестором або уповноваженою ним в установленому порядку особою до центру надання адміністративних послуг</p>\r\n', '<p>Або:</p>\r\n\r\n<ul>\r\n	<li>письмове повідомлення про припинення іноземним інвестором своєї діяльності у зв&#39;язку з передачею (продажем) своїх інвестицій іншим суб&#39;єктам інвестиційної діяльності;</li>\r\n	<li>інформаційне повідомлення про попередню державну реєстрацію іноземних інвестицій;</li>\r\n	<li>довідку територіального органу Міністерства доходів і зборів про сплачені іноземним інвестором в Україні податки.</li>\r\n</ul>\r\n\r\n<p>Або:</p>\r\n\r\n<ul>\r\n	<li>інформаційне повідомлення згідно з додатком 1 до Порядку державної реєстрації (перереєстрації) іноземних інвестицій та її анулювання у трьох примірниках з відміткою територіального органу Міністерства доходів і зборів за місцем здійснення інвестицій про їх фактичне здійснення</li>\r\n	<li>документи, що підтверджують форму здійснення іноземних інвестицій (установчі документи, договори (контракти) про виробничу кооперацію, спільне виробництво та інші види спільної інвестиційної діяльності, концесійні договори тощо);</li>\r\n	<li>документи, які підтверджують вартість іноземних інвестицій, що визначається відповідно до статті 2 Закону України &ldquo;Про режим іноземного інвестування&rdquo;.</li>\r\n</ul>\r\n', 0, '', '', '', '<p>7 днів</p>\r\n', '<p>Порушення встановленого порядку перереєстрації</p>\r\n', '<p>Державна реєстрація іноземної інвестиції (інформаційне повідомлення) або відмова в наданні адміністративної послуги.</p>\r\n', '<p>Адміністративна послуга вважається надана з моменту отримання її через Управління надання адміністративних послуг Одеської міської ради</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(6, 'Анулювання державної реєстрації іноземних інвестицій', 1, 5, '<p>Постанова Кабінету Міністрів України від 6 березня 2013 р. № 139 Про затвердження Порядку державної реєстрації (перереєстрації) іноземних інвестицій та її анулювання</p>\r\n', '<p>---</p>\r\n', '<p>Документи подаються іноземним інвестором або уповноваженою ним в установленому порядку особою до центру надання адміністративних послуг</p>\r\n', '<ul>\r\n	<li>письмове повідомлення про припинення іноземним інвестором своєї діяльності у зв&#39;язку з передачею (продажем) своїх інвестицій іншим суб&#39;єктам інвестиційної діяльності;</li>\r\n	<li>інформаційне повідомлення про попередню державну реєстрацію іноземних інвестицій;</li>\r\n	<li>довідку територіального органу Міністерства доходів і зборів про сплачені іноземним інвестором в Україні податки.</li>\r\n</ul>\r\n', 0, '', '', '', '<p>7 днів</p>\r\n', '<p>Порушення встановленого порядку анулювання</p>\r\n', '<p>Анулювання іноземної інвестиції або відмова в наданні адміністративної послуги.</p>\r\n', '<p>Адміністративна послуга вважається надана з моменту отримання її через Управління надання адміністративних послуг Одеської міської ради</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(7, 'Видача дубліката інформаційного повідомлення про внесення іноземної інвестиції, у разі його втрати (знищення)', 1, 5, '<p>Постанова Кабінету Міністрів України від 6 березня 2013 р. № 139 Про затвердження Порядку державної реєстрації (перереєстрації) іноземних інвестицій та її анулювання.</p>\r\n', '<p>---</p>\r\n', '<p>Документи подаються іноземним інвестором або уповноваженою ним в установленому порядку особою до центру надання адміністративних послуг.</p>\r\n', '<p>Опубліковане в офіційних друкованих засобах масової інформації оголошення про визнання недійсним втраченого інформаційного повідомлення.</p>\r\n', 0, '', '', '', '<p>5 днів</p>\r\n', '<p>Порушення встановленого порядку видачі дублікату.</p>\r\n', '<p><strong>Видача дублікату інформаційного повідомлення або відмова в наданні адміністративної послуги.</strong></p>\r\n', '<p>Адміністративна послуга вважається надана з моменту отримання її через Управління надання адміністративних послуг Одеської міської ради.</p>\r\n', 'так', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(8, 'Державна реєстрація договорів (контрактів) про спільну інвестиційну діяльність за участю іноземного інвестора', 1, 5, '<p>Стаття 24 Закону України &laquo;Про режим іноземного інвестування&raquo;; Постанова Кабінету Міністрів України від 30.01.1997 №112 &quot;Про затвердження Положення про порядок державної реєстрації договорів (контрактів) про спільну інвестиційну діяльність за участю іноземного інвестора&quot;; Наказ Міністерства зовнішніх економічних зв&#39;язків і торгівлі України від 20.02.1997 р. №125 України &laquo;Про заходи МЗЕЗторгу щодо забезпечення виконання Постанови КМУ від 30.01.1997 р. № 112&raquo;.</p>\r\n', '<p>---</p>\r\n', '<p>Суб&#39;єкт зовнішньоекономічної діяльності України - учасник договору (контракту), якому доручено ведення спільних справ учасників, або уповноважена ним особа подає документи до центру надання адміністративних послуг</p>\r\n', '<ol>\r\n	<li>лист-звернення про державну реєстрацію договору (контракту);</li>\r\n	<li>інформаційна картка договору (контракту) за формою, що встановлює Мінекономрозвитку;</li>\r\n	<li>договір (контракт) (оригінал і копію), засвідчені в установленому порядку;</li>\r\n	<li>засвідчені копії установчих документів суб&rsquo;єкта (суб&rsquo;єктів) зовнішньоекономічної діяльності України та свідоцтва про його державну реєстрацію як суб&rsquo;єкта підприємницької діяльності;</li>\r\n	<li>документи, що свідчать про реєстрацію (створення) іноземної юридичної особи (нерезидента) в країні її місцезнаходження (витяг із торгівельного, банківського або судового реєстру тощо). Ці документи повинні бути засвідчені відповідно до законодавства країни їх видачі, перекладенні українською мовою та легалізовані у консульській установі України, якщо міжнародними договорами, в яких бере участь Україна, не передбачено інше. Зазначені документи можуть бути засвідчені також у посольстві відповідної держави в Україні та легалізовані в МЗС;</li>\r\n	<li>ліцензію, якщо згідно із законодавством України цього вимагає діяльність, що передбачається договором (контрактом);</li>\r\n	<li>документ про оплату послуг за державну реєстрацію договору (контракту).</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 30.01.1997 №112 &quot;Про затвердження Положення про порядок державної реєстрації договорів (контрактів) про спільну інвестиційну діяльність за участю іноземного інвестора&quot;.</p>\r\n', '<p>Шість неоподатковуваних мінімумів доходів громадян, встановлених на день реєстрації.</p>\r\n', '<p><a href="/iasnap/ckeditor/kcfinder/upload/files/nomera_rahunk_v_cajt.xls">Завантажити файл з банківськими реквізитами.</a></p>\r\n', '<p>20 днів</p>\r\n', '<p>Порушення встановленого порядку реєстрації</p>\r\n', '<p><strong>Державна реєстрація договору (контракту) про спільну інвестиційну діяльність за участю іноземного інвестора або відмова в наданні адміністративної послуги.</strong></p>\r\n', '<p>Адміністративна послуга вважається надана з моменту отримання її через Управління надання адміністративних послуг Одеської міської ради.</p>\r\n', 'так', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(9, 'Реєстрація статутів (положень) релігійних громад та змін до них', 1, 6, '<p>Закон України &laquo;Про свободу совісті та релігійні організації&raquo; від 23 квітня 1991 року&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; №&nbsp;987-ХІІ (стаття 14).&nbsp;</p>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', '<p>1.Заява засновників (членів) релігійної громади на ім&rsquo;я голови облдержадміністрації (заяву підписують не менше 10 повнолітніх громадян. Підписи завіряються нотаріально).</p>\r\n\r\n<p>2. Статут релігійної громади, прийнятий на загальних зборах віруючих громадян (прошиті, 5 примірників).</p>\r\n\r\n<p>3. Документ, що підтверджує місцезнаходження релігійної громади (підпис завіряється нотаріально).</p>\r\n\r\n<p>4. Протокол установчих (загальних) зборів віруючих громадян ( 2 примірника).</p>\r\n\r\n<p>5. Оригінали реєстраційних документів релігійної громади (у разі реєстрації статуту релігійної громади у нової редакції).</p>\r\n\r\n<p>Всі документи оформляються державною мовою.</p>\r\n\r\n<p>Статут не повинен суперечити чинному законодавству.</p>\r\n\r\n<p><a href="Завантажити зразок заяви про реєстрацію статуту релігійної громади">Завантажити зразок заяви про реєстрацію статуту релігійної громади</a>&nbsp;</p>\r\n', 0, '', '', '', '<p>Відповідно до статті 14 Закону України &laquo;Про свободу совісті та релігійні організації&raquo; обласна державна адміністрація в місячний термін розглядає заяву, статут (положення) релігійної громади, приймає відповідне рішення&nbsp; і не пізніш як у десятиденний термін письмово повідомляє про нього заявникам. У необхідних випадках облдержадміністрація може зажадати висновок місцевої державної адміністрації, виконавчого комітету сільської, селищної, міської Рад народних депутатів, а також спеціалістів. У цьому разі рішення приймається у тримісячний термін.</p>\r\n', '<p>---</p>\r\n', '<p><strong>Розпорядження голови обласної державної адміністрації; рішення про відмову в реєстраціях статуту (положення) релігійної громади із зазначенням підстав відмови.</strong></p>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`, `ff_link`) VALUES
(10, 'Дозвіл на викиди забруднюючих речовин в атмосферне повітря стаціонарними джерелами (для об’єктів другої та третьої груп)', 1, 7, '<ul>\r\n	<li>Закон України &quot;Про Перелік документів дозвільного характеру у сфері господарської діяльності&quot; (п. 30) ;</li>\r\n	<li>Закон України &quot;Про охорону атмосферного повітря&quot; (ст. 11).</li>\r\n</ul>\r\n', '<p>Здійснення діяльності пов&rsquo;язаної з викидами в атмосферне повітря</p>\r\n', '<p>Документи подаються через Центр надання адміністративних послуг Одеської міської ради суб&#39;єктом господарювання (керівником юридичної особи, фізичною особою - підприємцем) або уповноваженою особою. Уповноважена особа повинна мати документ, який підтверджує її повноваження.&nbsp;</p>\r\n', '<ol>\r\n	<li>Заява (наказ Міністерства охорони навколишнього природного середовища України 30.05.2006 № 266)</li>\r\n	<li>Документи, в яких обґрунтовуються обсяги викидів забруднюючих речовин (в письмовій та в електронній формі XML-файли);</li>\r\n	<li>Звіт з інвентаризації стаціонарних джерел викидів забруднюючих речовин в атмосферне повітря, видів та обсягів викидів забруднюючих речовин в атмосферне повітря стаціонарними&nbsp; джерелами, пилогазоочисного обладнання;</li>\r\n	<li>Оцінка впливу викидів забруднюючих речовин на стан атмосферного повітря на межі санітарно-захисної зони (тільки для суб&rsquo;єктів господарювання, об&rsquo;єкти яких належать до 2 групи).</li>\r\n	<li>Плани заходів (тільки для суб&rsquo;єктів господарювання, об&rsquo;єкти яких належать до 2 групи) щодо:</li>\r\n</ol>\r\n\r\n<ul>\r\n	<li>досягнення встановлених нормативів граничнодопустимих викидів для найбільш поширених і небезпечних забруднюючих речовин;</li>\r\n	<li>охорони атмосферного повітря на випадок виникнення надзвичайних ситуацій техногенного та природного характеру;</li>\r\n	<li>ліквідації причин і наслідків забруднення атмосферного повітря;</li>\r\n	<li>остаточного припинення діяльності, пов&#39;язаної з викидами забруднюючих речовин в атмосферне повітря, та приведення місця діяльності у задовільний стан;</li>\r\n	<li>запобігання перевищенню встановлених нормативів граничнодопустимих викидів у процесі виробництва;</li>\r\n	<li>здійснення контролю за дотриманням встановлених нормативів граничнодопустимих викидів забруднюючих речовин та умов дозволу на викиди.</li>\r\n</ul>\r\n\r\n<ol>\r\n	<li>Обґрунтування розмірів нормативних санітарно-захисних зон, оцінка витрат, пов`язаних з реалізацією заходів щодо їх створення.</li>\r\n	<li>Оцінка та аналіз витрат, пов`язаних з реалізацією запланованих заходів щодо запобігання забрудненню атмосферного повітря (тільки для суб&rsquo;єктів господарювання, об&rsquo;єкти яких належать до 2 групи).</li>\r\n	<li>Копія повідомлення про намір отримати дозвіл на викиди, розміщене в місцевих друкованих засобах масової інформації.</li>\r\n	<li>Висновок щодо видачі дозволу установи державної санітарно-епідеміологічної служби.</li>\r\n	<li>Лист &mdash; повідомлення місцевої державної адміністрації щодо наявності зауважень громадських організацій та громадян.</li>\r\n	<li>Копія публікації у ЗМІ з інформацією про отримання дозволу для ознайомлення з нею громадськості.</li>\r\n	<li>Для отримання дозволу на новостворені стаціонарні джерела - позитивний висновок комплексної державної експертизи або позитивні висновки державної санітарно-гігієнічної та державної екологічної експертиз.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Строк видачі документів дозвільного характеру становить &ndash; 30 календарних днів з дня одержання заяви та документів.</p>\r\n', '<ul>\r\n	<li>подання суб&#39;єктом господарювання неповного пакета документів, необхідних для одержання документа дозвільного характеру;</li>\r\n	<li>&nbsp;виявлення в документах, поданих суб&#39;єктом господарюванняосподарювання, даних суб&#39;єктом , недостовірних відомостей;</li>\r\n	<li>негативний висновок за результатами проведених експертиз та обстежень або інших наукових і технічних оцінок, необхідних для видачі документа дозвільного характеру;</li>\r\n	<li>виявлення ознак об&#39;єкта першої групи;</li>\r\n	<li>невідповідність представленої документації наказу Мінприроди України від 09.03.2006 № 108;</li>\r\n	<li>невиконання умов попереднього дозволу.</li>\r\n</ul>\r\n\r\n<p>Законом можуть встановлюватися інші підстави для відмови у видачі документа дозвільного характеру.</p>\r\n', '<p>Дозвіл на викиди забруднюючих речовин в атмосферне повітря стаціонарними джерелами. Дозвіл видається на термін не менш як п&#39;ять років</p>\r\n', '<p>Управління надання адміністративних послуг Одеської&nbsp; міської ради</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(11, 'Переоформлення дозволу на викиди забруднюючих речовин в атмосферне повітря стаціонарними джерелами', 1, 7, '<p>Закон України &quot;Про дозвільну систему у сфері господарської діяльності&quot; (ст. 4-1)</p>\r\n', '<ol>\r\n	<li>Зміна найменування суб&#39;єкта господарювання - юридичної особи або прізвища, імені, по батькові фізичної особи - підприємця.</li>\r\n	<li>Зміна місцезнаходження суб&#39;єкта господарювання.</li>\r\n	<li>Законом можуть бути встановлені інші підстави для переоформлення документа дозвільного характеру.</li>\r\n</ol>\r\n', '<p>Документи подаються через Центр надання адміністративних послуг Одеської міської ради особисто суб&#39;єктом господарювання (керівником юридичної особи, фізичною особою - підприємцем) або уповноваженою особою. Уповноважена особа повинна мати документ, який підтверджує її повноваження. Заява та документи, що додаються до неї, можуть бути надіслані рекомендованим листом з описом вкладення, при цьому підпис заявника (фізичної особи - підприємця) та уповноваженої ним особи засвідчується нотаріально.</p>\r\n', '<ol>\r\n	<li>Довіреність (за необхідністю)</li>\r\n	<li>Заява про переоформлення документа дозвільного характеру - затверджена постановою КМУ від 07.12.2005 № 1176;</li>\r\n	<li>Документ дозвільного характеру, що підлягає переоформленню;</li>\r\n	<li>Документ, що підтверджує зміни, які являються підставою для переоформлення документа дозвільного характеру.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Протягом двох робочих днів з дня одержання заяви про переоформлення документа дозвільного характеру та документів, що додаються до неї.</p>\r\n', '<p>Подання суб&#39;єктом господарювання неповного пакета документів</p>\r\n', '<p>Видача переоформленого документа дозвільного характеру.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(12, 'Видача дубліката дозволу на викиди забруднюючих речовин в атмосферне повітря стаціонарними джерелами', 1, 7, '<p>Закон України &quot;Про дозвільну систему у сфері господарської діяльності&quot; (ст. 4-1)</p>\r\n', '<ol>\r\n	<li>Втрата документа дозвільного характеру;</li>\r\n	<li>Пошкодження документа дозвільного характеру.</li>\r\n	<li>Законом можуть бути встановлені інші підстави для видачі дубліката документа дозвільного характеру.</li>\r\n</ol>\r\n', '<p>Документи подаються через Центр надання адміністративних послуг особисто суб&#39;єктом господарювання (керівником юридичної особи, фізичною особою - підприємцем) або уповноваженою особою. Уповноважена особа повинна мати документ, який підтверджує її повноваження.</p>\r\n', '<ol>\r\n	<li>Довіреність (за необхідністю)</li>\r\n	<li>Заява про видачу дубліката документа дозвільного характеру - затверджена постановою КМУ від 07.12.2005 № 1176;</li>\r\n	<li>Пошкоджений документ дозвільного характеру.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Протягом двох робочих днів з дня одержання заяви про видачу дубліката документа дозвільного характеру.</p>\r\n', '<p>Подання суб&#39;єктом господарювання неповного пакета документів.</p>\r\n', '<p>Видача дубліката дозволу на викиди забруднюючих речовин в атмосферне повітря стаціонарними джерелами.</p>\r\n', '<p>Через Центр надання адміністративих послуг Одеської міської ради.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(13, 'Видача ліцензії на надання освітніх послуг у сфері загальної середньої освіти', 1, 8, '<ol>\r\n	<li>Закон України від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 13.05.1999 №651-ХІV &nbsp;&laquo;Про загальну середню освіту&raquo;, ст.&nbsp;8 п.1.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері загальної середньої освіти за затвердженою Міністерством освіти і науки, молоді та спорту України формою, до якої додається пакет документів.</p>\r\n', '<ol>\r\n	<li>Заява про проведення ліцензування із зазначенням виду освітньої послуги і ліцензованого обсягу, реквізитів навчального закладу за затвердженою Міністерством освіти і науки, молоді та спорту України формою.</li>\r\n	<li>Копії установчих документів (статуту, положення, рішення засновника (власника) або уповноваженого ним органу про створення навчального закладу).</li>\r\n	<li>Копії рішень про утворення відокремлених підрозділів та положення про них (у разі ліцензування освітніх послуг у відокремленому підрозділі).</li>\r\n	<li>Концепція діяльності за заявленою освітньою послугою, яка ґрунтується на результатах моніторингу регіонального ринку освітніх послуг.</li>\r\n	<li>Копія робочого навчального плану, затвердженого в установленому порядку.</li>\r\n	<li>Відомості про кількісні та якісні показники кадрового забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про кількісні показники матеріально-технічного забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про навчально-методичне забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про кількісні показники інформаційного забезпечення освітньої діяльності, наявність бібліотеки та обсяг її фондів.</li>\r\n	<li>Копії документів, що засвідчують право власності (свідоцтво про право власності, договір купівлі-продажу), оперативного управління (рішення чи повідомлення власника майна про перебування майна в оперативному управлінні) чи користування (договір оренди) основними засобами для здійснення навчально-виховного процесу на строк, необхідний для завершення надання послуги.</li>\r\n	<li>Копії документів про відповідність приміщень навчального закладу та його матеріально-технічної бази санітарним нормам, вимогам правил пожежної безпеки.</li>\r\n	<li>Копії документів, що засвідчують рівень освіти, кваліфікації та громадянство керівника навчального закладу (диплома про вищу освіту, першої сторінки паспорта керівника навчального закладу).</li>\r\n</ol>\r\n', 1, '<p>П.&nbsp;2 постанови Кабінету Міністрів України від 29.08.2003 №1380 &laquo;Про ліцензування освітніх послуг&raquo;.</p>\r\n', '<ul>\r\n	<li>Плата за видачу ліцензії на надання освітніх послуг справляється в розмірі п&rsquo;ятнадцяти неоподаткованих мінімумів доходів громадян.</li>\r\n	<li>Плата за переоформлення ліцензії, за видачу копії та дубліката ліцензії справляється в розмірі п&rsquo;яти неоподаткованих мінімумів доходів громадян.</li>\r\n</ul>\r\n', '<p>Внесення суб&rsquo;єктом звернення плати за видачу, переоформлення ліцензії, видачу копії та дубліката ліцензії здійснюється на р/р&nbsp;31413511700001 код&nbsp;37607526 МФО&nbsp;828011, одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200.</p>\r\n', '<p>Загальний строк прийняття суб&rsquo;єктом надання адміністративної послуги рішення про видачу або відмову у видачі ліцензії не може перевищувати трьох місяців.</p>\r\n', '<ul>\r\n	<li>недостовірність даних у документах, поданих суб&rsquo;єктом звернення, для отримання ліцензії;</li>\r\n	<li>невідповідність суб&rsquo;єкта звернення згідно з поданими документами ліцензійним умовам, встановленим для виду діяльності у сфері освіти, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n', '<p>Суб&rsquo;єкт звернення отримує ліцензію на право провадження діяльності у сфері освіти на бланку ліцензії єдиного зразка. Ліцензія видається на строк від 3 до 12 років включно.</p>\r\n', '<ol>\r\n	<li>Суб&rsquo;єкт звернення надає до Центру надання адміністративних послуг платіжні документи, що засвідчують плату&nbsp; за видачу ліцензії&nbsp; (переоформлення ліцензії, видачу копії та дубліката ліцензії), та оплату послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування.</li>\r\n	<li>Суб&rsquo;єкт звернення особисто отримує ліцензію на надання освітніх послуг у сфері загальної середньої освіти в Центрі надання адміністративних послуг Одеської міської ради.</li>\r\n</ol>\r\n', 'ні', 1, 'Спроможність надавати освітні послуги підтверджується результатами ліцензійної експертизи (п.&nbsp;16&sup1; Порядку ліцензування діяльності з надання освітніх послуг, затвердженого постановою Кабінету Міністрів України від 08.08.2007 №1019 &laquo;Про ліцензування діяльності з надання освітніх послуг&raquo;).', 1, 'Оплата послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування здійснюється суб&rsquo;єктом звернення (п.&nbsp;24&nbsp; Порядку ліцензування діяльності з надання освітніх послуг, затвердженого постановою Кабінету Міністрів України від 08.08.2007 №1019 &laquo;Про ліцензування діяльності з надання освітніх послуг&raquo;).', 'П.&nbsp;24&nbsp; Порядку ліцензування діяльності з надання освітніх послуг, затвердженого постановою Кабінету Міністрів України від 08.08.2007 №1019 &laquo;Про ліцензування діяльності з надання освітніх послуг&raquo;.', 'Оплата послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування діяльності юридичних осіб у сфері загальної середньої освіти здійснюється суб&rsquo;єктом звернення у розмірі 24 неоподаткованих мінімумів доходів громадян.', 'Оплата послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування перераховується заявником на рахунок регіональної експертної ради &ndash; навчально-методичний центр професійно-технічної освіти в Одеській області р/р&nbsp;31256277221575 МФО&nbsp;828011 код&nbsp;23207206, банк одержувача ГУДКСУ в Одеській області.', NULL),
(14, 'Видача дубліката ліцензії на надання освітніх послуг у сфері загальної середньої освіти', 1, 8, '<ol>\r\n	<li>Закон України від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 13.05.1999 №651-ХІV &nbsp;&laquo;Про загальну середню освіту&raquo;, ст.&nbsp;8 п.1.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері загальної середньої освіти за затвердженою Міністерством освіти і науки, молоді та спорту України формою, до якої додається пакет документів.</p>\r\n', '<ol>\r\n	<li>Заява про видачу дубліката ліцензії.</li>\r\n	<li>У разі пошкодження ліцензії &ndash; пошкоджений оригінал.</li>\r\n</ol>\r\n', 1, '<p>П.&nbsp;2 постанови Кабінету Міністрів України від 29.08.2003 №1380 &laquo;Про ліцензування освітніх послуг&raquo;.</p>\r\n', '<p>Плата за видачу дубліката ліцензії справляється в розмірі п&rsquo;яти неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p>Внесення суб&rsquo;єктом звернення плати за видачу дубліката ліцензії здійснюється на р/р&nbsp;31413511700001 код&nbsp;37607526 МФО&nbsp;828011, одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200.</p>\r\n', '<p>10 робочих днів після надходження заяви.</p>\r\n', '<p>Підставою для прийняття рішення про відмову у видачі дубліката ліцензії є недостовірність даних у документах, поданих суб&rsquo;єктом звернення, для отримання ліцензії.</p>\r\n', '<p>Суб&rsquo;єкт звернення отримує дублікат ліцензії на право провадження діяльності у сфері освіти на бланку ліцензії єдиного зразка.</p>\r\n', '<p>Суб&rsquo;єкт звернення надає до Центру надання адміністративних послуг платіжні документи, що засвідчують плату за видачу дубліката ліцензії та особисто отримує дублікат ліцензії на надання освітніх послуг у сфері загальної середньої освіти.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(15, 'Видача копії ліцензії на надання освітніх послуг у сфері загальної середньої освіти', 1, 8, '<ol>\r\n	<li>Закон України від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 13.05.1999 №651-ХІV &nbsp;&laquo;Про загальну середню освіту&raquo;, ст.&nbsp;8 п.1.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері загальної середньої освіти за затвердженою Міністерством освіти і науки, молоді та спорту України формою до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>1Заява про проведення ліцензування із зазначенням виду освітньої послуги і ліцензованого обсягу, реквізитів навчального закладу за затвердженою Міністерством освіти і науки, молоді та спорту України формою.</li>\r\n	<li>Копії установчих документів (статуту, положення, рішення засновника (власника) або уповноваженого ним органу про створення навчального закладу).</li>\r\n	<li>Копії рішень про утворення відокремлених підрозділів та положення про них (у разі ліцензування освітніх послуг у відокремленому підрозділі).</li>\r\n	<li>Концепція діяльності за заявленою освітньою послугою, яка ґрунтується на результатах моніторингу регіонального ринку освітніх послуг.</li>\r\n	<li>Відомості про кількості та якісні показники кадрового забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про кількісні показники матеріально-технічного забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про навчально-методичне забезпечення освітньої діяльності.</li>\r\n	<li>Копії документів, що засвідчують право власності (свідоцтво про право власності, договір купівлі-продажу), оперативного управління (рішення чи повідомлення власника майна про перебування майна в оперативному управлінні) чи користування (договір оренди) основними засобами для здійснення навчально-виховного процесу на строк, необхідний для завершення надання послуги.</li>\r\n	<li>Копії документів про відповідність приміщень навчального закладу та його матеріально-технічної бази санітарним нормам, вимогам правил пожежної безпеки.</li>\r\n	<li>Копії документів, що засвідчують рівень освіти, кваліфікації та громадянство керівника навчального закладу (диплома про вищу освіту, першої сторінки паспорта керівника навчального закладу).</li>\r\n</ol>\r\n', 1, '<p>П.&nbsp;2 постанови Кабінету Міністрів України від 29.08.2003 №1380 &laquo;Про ліцензування освітніх послуг&raquo;.</p>\r\n', '<p>Плата за видачу копії ліцензії справляється в розмірі п&rsquo;яти неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p>Внесення суб&rsquo;єктом звернення плати за видачу копії ліцензії здійснюється на р/р&nbsp;31413511700001 код&nbsp;37607526 МФО&nbsp;828011, одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200.</p>\r\n', '<p>Строк прийняття суб&rsquo;єктом надання адміністративної послуги рішення про видачу або відмову у видачі ліцензії не може перевищувати трьох місяців.</p>\r\n', '<ul>\r\n	<li>недостовірність даних у документах, поданих суб&rsquo;єктом звернення, для отримання ліцензії;</li>\r\n	<li>невідповідність суб&rsquo;єкта звернення згідно з поданими документами ліцензійним умовам, встановленим для виду діяльності у сфері освіти, зазначеного в заяві про видачу копії ліцензії.</li>\r\n</ul>\r\n', '<p>Суб&rsquo;єкт звернення отримує копію ліцензії на право провадження діяльності у сфері освіти на бланку ліцензії єдиного зразка.</p>\r\n', '<ol>\r\n	<li>Суб&rsquo;єкт звернення надає до Центру надання адміністративних послуг платіжні документи, що засвідчують плату за видачу копії ліцензії&nbsp; та оплату послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування.</li>\r\n	<li>Суб&rsquo;єкт звернення особисто отримує копію ліцензії на надання освітніх послуг у сфері загальної середньої освіти в Центрі надання адміністративних послуг Одеської міської ради.</li>\r\n</ol>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(16, 'Переоформлення ліцензії на надання освітніх послуг у сфері загальної середньої освіти', 1, 8, '<ol>\r\n	<li>Закон України від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 13.05.1999 №651-ХІV &nbsp;&laquo;Про загальну середню освіту&raquo;, ст.&nbsp;8 п.1.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері загальної середньої освіти до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява про переоформлення ліцензії.</li>\r\n	<li>Копії установчих документів (статуту, положення, рішення засновника (власника) або уповноваженого ним органу про створення навчального закладу).</li>\r\n	<li>Відомості про кількісні показники кадрового забезпечення.</li>\r\n	<li>Відомості кількісні показники матеріально-технічного забезпечення освітньої діяльності.</li>\r\n	<li>Копії документів про відповідність приміщень навчального закладу та його матеріально-технічної бази санітарним нормам, вимогам правил пожежної безпеки.</li>\r\n</ol>\r\n', 1, '<p>П.&nbsp;2 постанови Кабінету Міністрів України від 29.08.2003 №1380 &laquo;Про ліцензування освітніх послуг&raquo;.</p>\r\n', '<p>Плата за переоформлення ліцензії справляється в розмірі п&rsquo;яти неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p>Внесення суб&rsquo;єктом звернення плати за переоформлення ліцензії здійснюється на р/р&nbsp;31413511700001 код&nbsp;37607526 МФО&nbsp;828011, одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200.</p>\r\n', '<p>Розгляд на черговому засіданні Регіональної експертної ради з питань ліцензування та атестації навчальних закладів (не рідше одного разу на 2 місяці).</p>\r\n', '<p>Підставою для прийняття рішення про відмову у переоформленні ліцензії є недостовірність даних у документах, поданих суб&rsquo;єктом звернення, для переоформлення ліцензії.</p>\r\n', '<p>Суб&rsquo;єкт звернення отримує ліцензію на право провадження діяльності у сфері освіти на бланку ліцензії єдиного зразка.</p>\r\n', '<p>Суб&rsquo;єкт звернення надає до Центру надання адміністративних послуг платіжні документи, що засвідчують плату&nbsp; за переоформлення ліцензії&nbsp; та оплату послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування (у разі проведення експертизи).&nbsp; Суб&rsquo;єкт звернення особисто отримує переоформлену ліцензію на надання освітніх послуг у сфері загальної середньої освіти в Центрі надання адміністративних послуг Одеської міської ради.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(17, 'Анулювання ліцензії на надання освітніх послуг у сфері загальної середньої освіти', 1, 8, '<ol>\r\n	<li>Закон України від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 13.05.1999 №651-ХІV &nbsp;&laquo;Про загальну середню освіту&raquo;, ст.&nbsp;8 п.1.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері загальної середньої освіти до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява про анулювання ліцензії.</li>\r\n	<li>Ліцензія.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Розгляд на черговому засіданні Регіональної експертної ради з питань ліцензування та атестації навчальних закладів (не рідше одного разу на 2 місяці).</p>\r\n', '<p>---</p>\r\n', '<p>Наказ органу ліцензування відповідно до рішення&nbsp; Регіональної експертної ради з питань ліцензування та атестації навчальних закладів.</p>\r\n', '<p>На офіційному веб-сайті органу ліцензування.</p>\r\n', 'так', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(18, 'Видача ліцензії на надання освітніх послуг у сфері дошкільної освіти', 1, 8, '<ol>\r\n	<li>Закон України&nbsp;&nbsp; від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 11.07.2001 №2628-ІІІ &nbsp;&laquo;Про дошкільну освіту&raquo;, ст.&nbsp;11 п.3.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері дошкільної освіти&nbsp; до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява про проведення ліцензування із зазначенням виду освітньої послуги і ліцензованого обсягу, реквізитів навчального закладу за затвердженою Міністерством освіти і науки, молоді та спорту України формою.</li>\r\n	<li>Копії установчих документів (статуту, положення, рішення засновника (власника) або уповноваженого ним органу про створення навчального закладу).</li>\r\n	<li>Копії рішень про утворення відокремлених підрозділів та положення про них (у разі ліцензування освітніх послуг у відокремленому підрозділі).</li>\r\n	<li>Концепція діяльності за заявленою освітньою послугою, яка ґрунтується на результатах моніторингу регіонального ринку освітніх послуг.</li>\r\n	<li>Відомості про кількості та якісні показники кадрового забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про кількісні показники матеріально-технічного забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про навчально-методичне забезпечення освітньої діяльності.</li>\r\n	<li>Копії документів, що засвідчують право власності (свідоцтво про право власності, договір купівлі-продажу), оперативного управління (рішення чи повідомлення власника майна про перебування майна в оперативному управлінні) чи користування (договір оренди) основними засобами для здійснення навчально-виховного процесу на строк, необхідний для завершення надання послуги.</li>\r\n	<li>Копії документів про відповідність приміщень навчального закладу та його матеріально-технічної бази санітарним нормам, вимогам правил пожежної безпеки.</li>\r\n	<li>Копії документів, що засвідчують рівень освіти, кваліфікації та громадянство керівника навчального закладу (диплома про вищу освіту, першої сторінки паспорта керівника навчального закладу).</li>\r\n</ol>\r\n', 1, '<p>П.&nbsp;2 постанови Кабінету Міністрів України від 29.08.2003 №1380 &laquo;Про ліцензування освітніх послуг&raquo;.</p>\r\n', '<p>Плата за видачу ліцензії на надання освітніх послуг справляється в розмірі п&rsquo;ятнадцяти неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p>Внесення суб&rsquo;єктом звернення плати за видачу, переоформлення ліцензії, видачу копії та дубліката ліцензії здійснюється на р/р&nbsp;31413511700001 код&nbsp;37607526 МФО&nbsp;828011, одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200.</p>\r\n', '<p>Загальний строк прийняття суб&rsquo;єктом надання адміністративної послуги рішення про видачу або відмову у видачі ліцензії не може перевищувати трьох місяців.</p>\r\n', '<ul>\r\n	<li>недостовірність даних у документах, поданих суб&rsquo;єктом звернення, для отримання ліцензії;</li>\r\n	<li>невідповідність суб&rsquo;єкта звернення згідно з поданими документами ліцензійним умовам, встановленим для виду діяльності у сфері освіти, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n', '<p>Суб&rsquo;єкт звернення отримує ліцензію на право провадження діяльності у сфері освіти на бланку ліцензії єдиного зразка. Ліцензія видається на строк від 3 до 12 років включно.</p>\r\n', '<ul>\r\n	<li>Суб&rsquo;єкт звернення надає до Центру надання адміністративних послуг платіжні документи, що засвідчують плату&nbsp; за видачу ліцензії&nbsp; (переоформлення ліцензії, видачу копії та дубліката ліцензії), та оплату послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування.</li>\r\n	<li>Суб&rsquo;єкт звернення особисто отримує ліцензію на надання освітніх послуг у сфері дошкільної освіти в Центрі надання адміністративних послуг Одеської міської ради.</li>\r\n</ul>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`, `ff_link`) VALUES
(19, 'Видача дубліката ліцензії на надання освітніх послуг у сфері дошкільної освіти', 1, 8, '<ol>\r\n	<li>Закон України&nbsp;&nbsp; від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 11.07.2001 №2628-ІІІ &nbsp;&laquo;Про дошкільну освіту&raquo;, ст.&nbsp;11 п.3.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері дошкільної освіти до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява про видачу дубліката ліцензії.</li>\r\n	<li>У разі пошкодження ліцензії &ndash; пошкоджений оригінал.</li>\r\n</ol>\r\n', 1, '<p>П.&nbsp;2 постанови Кабінету Міністрів України від 29.08.2003 №1380 &laquo;Про ліцензування освітніх послуг&raquo;.</p>\r\n', '<p>Плата за видачу дубліката ліцензії справляється в розмірі п&rsquo;яти неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p>Внесення суб&rsquo;єктом звернення плати за видачу дубліката ліцензії здійснюється на р/р&nbsp;31413511700001 код&nbsp;37607526 МФО&nbsp;828011, одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200.</p>\r\n', '<p>10 робочих днів після надходження заяви.</p>\r\n', '<p>Підставою для прийняття рішення про відмову у видачі дубліката ліцензії є недостовірність даних у документах, поданих суб&rsquo;єктом звернення, для отримання ліцензії.</p>\r\n', '<p>Суб&rsquo;єкт звернення отримує дублікат ліцензії на право провадження діяльності у сфері освіти на бланку ліцензії єдиного зразка.</p>\r\n', '<ul>\r\n	<li>Суб&rsquo;єкт звернення надає до Центру надання адміністративних послуг платіжні документи, що засвідчують плату&nbsp; за видачу дубліката ліцензії.</li>\r\n	<li>Суб&rsquo;єкт звернення особисто отримує дублікат ліцензії на надання освітніх послуг у сфері дошкільної освіти в Центрі надання адміністративних послуг Одеської міської ради.</li>\r\n</ul>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(20, 'Видача копії ліцензії на надання освітніх послуг у сфері дошкільної освіти', 1, 8, '<ol>\r\n	<li>Закон України&nbsp;&nbsp; від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 11.07.2001 №2628-ІІІ &nbsp;&laquo;Про дошкільну освіту&raquo;, ст.&nbsp;11 п.3.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері дошкільної освіти до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<p>Для відокремленого структурного підрозділу (філії тощо):</p>\r\n\r\n<ol>\r\n	<li>Заява про проведення ліцензування із зазначенням виду освітньої послуги і ліцензованого обсягу, реквізитів навчального закладу за затвердженою Міністерством освіти і науки, молоді та спорту України формою.</li>\r\n	<li>Копії установчих документів (статуту, положення, рішення засновника (власника) або уповноваженого ним органу про створення навчального закладу).</li>\r\n	<li>Копії рішень про утворення відокремлених підрозділів та положення про них (у разі ліцензування освітніх послуг у відокремленому підрозділі).</li>\r\n	<li>Концепція діяльності за заявленою освітньою послугою, яка ґрунтується на результатах моніторингу регіонального ринку освітніх послуг.</li>\r\n	<li>Відомості про кількості та якісні показники кадрового забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про кількісні показники матеріально-технічного забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про навчально-методичне забезпечення освітньої діяльності.</li>\r\n	<li>Копії документів, що засвідчують право власності (свідоцтво про право власності, договір купівлі-продажу), оперативного управління (рішення чи повідомлення власника майна про перебування майна в оперативному управлінні) чи користування (договір оренди) основними засобами для здійснення навчально-виховного процесу на строк, необхідний для завершення надання послуги.</li>\r\n	<li>Копії документів про відповідність приміщень навчального закладу та його матеріально-технічної бази санітарним нормам, вимогам правил пожежної безпеки.</li>\r\n	<li>Копії документів, що засвідчують рівень освіти, кваліфікації та громадянство керівника навчального закладу (диплома про вищу освіту, першої сторінки паспорта керівника навчального закладу).</li>\r\n</ol>\r\n', 1, '<p>П.&nbsp;2 постанови Кабінету Міністрів України від 29.08.2003 №1380 &laquo;Про ліцензування освітніх послуг&raquo;.</p>\r\n', '<p>Плата за видачу копії ліцензії справляється в розмірі п&rsquo;яти неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p>Внесення суб&rsquo;єктом звернення плати за видачу копії ліцензії здійснюється на р/р&nbsp;31413511700001 код&nbsp;37607526 МФО&nbsp;828011, одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200.</p>\r\n', '<p>Загальний строк прийняття суб&rsquo;єктом надання адміністративної послуги рішення про видачу або відмову у видачі ліцензії не може перевищувати трьох місяців.</p>\r\n', '<p>Підставами для прийняття рішення про відмову у видачі ліцензії є:</p>\r\n\r\n<ul>\r\n	<li>недостовірність даних у документах, поданих суб&rsquo;єктом звернення, для отримання ліцензії;</li>\r\n	<li>невідповідність суб&rsquo;єкта звернення згідно з поданими документами ліцензійним умовам, встановленим для виду діяльності у сфері освіти, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n', '<p>Суб&rsquo;єкт звернення отримує копію ліцензії на право провадження діяльності у сфері освіти на бланку ліцензії єдиного зразка.</p>\r\n', '<ul>\r\n	<li>Суб&rsquo;єкт звернення надає до Центру надання адміністративних послуг платіжні документи, що засвідчують плату за видачу копії ліцензії&nbsp; та оплату послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування.</li>\r\n	<li>Суб&rsquo;єкт звернення особисто отримує копію ліцензії на надання освітніх послуг у сфері дошкільної освіти в Центрі надання адміністративних послуг Одеської міської ради.</li>\r\n</ul>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(21, 'Переоформлення ліцензії на надання освітніх послуг у сфері дошкільної освіти', 1, 8, '<ol>\r\n	<li>Закон України&nbsp;&nbsp; від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 11.07.2001 №2628-ІІІ &nbsp;&laquo;Про дошкільну освіту&raquo;, ст.&nbsp;11 п.3.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері дошкільної освіти до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява про переоформлення ліцензії.</li>\r\n	<li>Копії установчих документів (статуту, положення, рішення засновника (власника) або уповноваженого ним органу про створення навчального закладу).</li>\r\n	<li>Відомості про кількісні показники кадрового забезпечення.</li>\r\n	<li>Відомості кількісні показники матеріально-технічного забезпечення освітньої діяльності.</li>\r\n	<li>Копії документів про відповідність приміщень навчального закладу та його матеріально-технічної бази санітарним нормам, вимогам правил пожежної безпеки.</li>\r\n</ol>\r\n', 1, '<p>П.&nbsp;2 постанови Кабінету Міністрів України від 29.08.2003 №1380 &laquo;Про ліцензування освітніх послуг&raquo;.</p>\r\n', '<p>Плата за переоформлення ліцензії справляється в розмірі п&rsquo;яти неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p>Внесення суб&rsquo;єктом звернення плати за переоформлення ліцензії здійснюється на р/р&nbsp;31413511700001 код&nbsp;37607526 МФО&nbsp;828011, одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200.</p>\r\n', '<p>Розгляд на черговому засіданні Регіональної експертної ради з питань ліцензування та атестації навчальних закладів (не рідше одного разу на 2 місяці).</p>\r\n', '<p>Підставою для прийняття рішення про відмову у переоформленні ліцензії є недостовірність даних у документах, поданих суб&rsquo;єктом звернення, для переоформлення ліцензії.</p>\r\n', '<p>Суб&rsquo;єкт звернення отримує ліцензію на право провадження діяльності у сфері освіти на бланку ліцензії єдиного зразка.</p>\r\n', '<ul>\r\n	<li>Суб&rsquo;єкт звернення надає до Центру надання адміністративних послуг платіжні документи, що засвідчують плату&nbsp; за переоформлення ліцензії&nbsp; та оплату послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування (у разі проведення експертизи).</li>\r\n	<li>Суб&rsquo;єкт звернення особисто отримує переоформлену ліцензію на надання освітніх послуг у сфері дошкільної освіти в Центрі надання адміністративних послуг Одеської міської ради.</li>\r\n</ul>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(22, 'Анулювання ліцензії на надання освітніх послуг у сфері дошкільної освіти', 1, 8, '<ol>\r\n	<li>5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 11.07.2001 №2628-ІІІ &nbsp;&laquo;Про дошкільну освіту&raquo;, ст.&nbsp;11 п.3.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері дошкільної освіти до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява про анулювання ліцензії.</li>\r\n	<li>Ліцензія.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Розгляд на черговому засіданні Регіональної експертної ради з питань ліцензування та атестації навчальних закладів (не рідше одного разу на 2 місяці).</p>\r\n', '<p>---</p>\r\n', '<p>Наказ органу ліцензування відповідно до рішення&nbsp; Регіональної експертної ради з питань ліцензування та атестації навчальних закладів.</p>\r\n', '<p>На офіційному веб-сайті органу ліцензування.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(23, 'Видача ліцензії на надання освітніх послуг у сфері позашкільної освіти ', 1, 8, '<ol>\r\n	<li>Закон України&nbsp;&nbsp; від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 22.06.2000 №1841-ІІІ &nbsp;&laquo;Про позашкільну освіту&raquo;, ст.&nbsp;14 п.&nbsp;3.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері позашкільної освіти до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява про проведення ліцензування із зазначенням виду освітньої послуги і ліцензованого обсягу, реквізитів навчального закладу за затвердженою Міністерством освіти і науки, молоді та спорту України формою.</li>\r\n	<li>Копії установчих документів (статуту, положення, рішення засновника (власника) або уповноваженого ним органу про створення навчального закладу).</li>\r\n	<li>Копії рішень про утворення відокремлених підрозділів та положення про них (у разі ліцензування освітніх послуг у відокремленому підрозділі).</li>\r\n	<li>Концепція діяльності за заявленою освітньою послугою, яка ґрунтується на результатах моніторингу регіонального ринку освітніх послуг, затверджена керівником та скріплена печаткою навчального закладу, а також погоджена управлінням освіти і науки Одеської облдержадміністрації.</li>\r\n	<li>Копія навчального плану (навчальних планів), затвердженого в установленому порядку.</li>\r\n	<li>Відомості про кількісні та якісні показники кадрового забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про кількісні показники матеріально-технічного забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про навчально-методичне забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про інформаційне забезпечення освітньої діяльності.</li>\r\n	<li>Копії документів, що засвідчують право власності (свідоцтво про право власності, договір купівлі-продажу), оперативного управління (рішення чи повідомлення власника майна про перебування майна в оперативному управлінні) чи користування (договір оренди) основними засобами для здійснення навчально-виховного процесу на строк, необхідний для завершення надання послуги.</li>\r\n	<li>Копії документів про відповідність приміщень навчального закладу та його матеріально-технічної бази санітарним нормам, вимогам правил пожежної безпеки.</li>\r\n	<li>Копії документів, що засвідчують рівень освіти, кваліфікації та громадянство керівника навчального закладу (диплома про вищу освіту, першої сторінки паспорта керівника навчального закладу).</li>\r\n</ol>\r\n', 1, '<p>П.&nbsp;2 постанови Кабінету Міністрів України від 29.08.2003 №1380 &laquo;Про ліцензування освітніх послуг&raquo;.</p>\r\n', '<p>Плата за видачу ліцензії на надання освітніх послуг справляється в розмірі п&rsquo;ятнадцяти неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p>Внесення заявником плати за видачу, переоформлення ліцензії, видачу копії та дубліката ліцензії здійснюється на р/р&nbsp;31413511700001 код&nbsp;37607526 МФО&nbsp;828011, одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200.</p>\r\n', '<p>Загальний строк прийняття суб&rsquo;єктом надання адміністративної послуги рішення про видачу або відмову у видачі ліцензії не може перевищувати трьох місяців.</p>\r\n', '<p>Підставами для прийняття рішення про відмову у видачі ліцензії є:</p>\r\n\r\n<ul>\r\n	<li>недостовірність даних у документах, поданих суб&rsquo;єктом звернення, для отримання ліцензії;</li>\r\n	<li>невідповідність суб&rsquo;єкта звернення згідно з поданими документами ліцензійним умовам, встановленим для виду діяльності у сфері освіти, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n', '<p>Суб&rsquo;єкт звернення отримує ліцензію на право провадження діяльності у сфері освіти на бланку ліцензії єдиного зразка.</p>\r\n', '<ul>\r\n	<li>Суб&rsquo;єкт звернення надає до Центру надання адміністративних послуг платіжні документи, що засвідчують плату&nbsp; за видачу ліцензії&nbsp; (переоформлення ліцензії, видачу копії та дубліката ліцензії), та оплату послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування.</li>\r\n	<li>Суб&rsquo;єкт звернення особисто отримує ліцензію на надання освітніх послуг у сфері позашкільної освіти в Центрі надання адміністративних послуг Одеської міської ради.</li>\r\n</ul>\r\n', 'так', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(24, 'Видача дубліката ліцензії на надання освітніх послуг у сфері позашкільної освіти ', 1, 8, '<ol>\r\n	<li>Закон України&nbsp;&nbsp; від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 22.06.2000 №1841-ІІІ &nbsp;&laquo;Про позашкільну освіту&raquo;, ст.&nbsp;14 п.&nbsp;3.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері позашкільної освіти до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява про видачу дубліката ліцензії.</li>\r\n	<li>У разі пошкодження ліцензії &ndash; пошкоджений оригінал.</li>\r\n</ol>\r\n', 1, '<p>П.&nbsp;2 постанови Кабінету Міністрів України від 29.08.2003 №1380 &laquo;Про ліцензування освітніх послуг&raquo;.</p>\r\n', '<p>Плата за видачу дубліката ліцензії справляється в розмірі п&rsquo;яти неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p>Внесення суб&rsquo;єктом звернення плати за видачу дубліката ліцензії здійснюється на р/р&nbsp;31413511700001 код&nbsp;37607526 МФО&nbsp;828011, одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200.</p>\r\n', '<p>10 робочих днів після надходження заяви.</p>\r\n', '<p>Підставою для прийняття рішення про відмову у видачі дубліката ліцензії є недостовірність даних у документах, поданих суб&rsquo;єктом звернення, для отримання ліцензії.</p>\r\n', '<p>Суб&rsquo;єкт звернення отримує дублікат ліцензії на право провадження діяльності у сфері освіти на бланку ліцензії єдиного зразка.</p>\r\n', '<ul>\r\n	<li>Суб&rsquo;єкт звернення надає до Центру надання адміністративних послуг платіжні документи, що засвідчують плату&nbsp; за видачу дубліката ліцензії.</li>\r\n	<li>Суб&rsquo;єкт звернення особисто отримує дублікат ліцензії на надання освітніх послуг у сфері позашкільної освіти в Центрі надання адміністративних послуг Одеської міської ради.</li>\r\n</ul>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(25, 'Видача копії ліцензії на надання освітніх послуг у сфері позашкільної освіти', 1, 8, '<ol>\r\n	<li>Закон України&nbsp;&nbsp; від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 22.06.2000 №1841-ІІІ &nbsp;&laquo;Про позашкільну освіту&raquo;, ст.&nbsp;14 п.&nbsp;3.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері позашкільної освіти до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<p>Для відокремленого структурного підрозділу (філії тощо):</p>\r\n\r\n<ol>\r\n	<li>Заява про проведення ліцензування із зазначенням виду освітньої послуги і ліцензованого обсягу, реквізитів навчального закладу за затвердженою Міністерством освіти і науки, молоді та спорту України формою.</li>\r\n	<li>Копії установчих документів (статуту, положення, рішення засновника (власника) або уповноваженого ним органу про створення навчального закладу).</li>\r\n	<li>Копії рішень про утворення відокремлених підрозділів та положення про них (у разі ліцензування освітніх послуг у відокремленому підрозділі).</li>\r\n	<li>Концепція діяльності за заявленою освітньою послугою, яка ґрунтується на результатах моніторингу регіонального ринку освітніх послуг.</li>\r\n	<li>Відомості про кількості та якісні показники кадрового забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про кількісні показники матеріально-технічного забезпечення освітньої діяльності.</li>\r\n	<li>Відомості про навчально-методичне забезпечення освітньої діяльності.</li>\r\n	<li>Копії документів, що засвідчують право власності (свідоцтво про право власності, договір купівлі-продажу), оперативного управління (рішення чи повідомлення власника майна про перебування майна в оперативному управлінні) чи користування (договір оренди) основними засобами для здійснення навчально-виховного процесу на строк, необхідний для завершення надання послуги.</li>\r\n	<li>Копії документів про відповідність приміщень навчального закладу та його матеріально-технічної бази санітарним нормам, вимогам правил пожежної безпеки.</li>\r\n	<li>Копії документів, що засвідчують рівень освіти, кваліфікації та громадянство керівника навчального закладу (диплома про вищу освіту, першої сторінки паспорта керівника навчального закладу).</li>\r\n</ol>\r\n', 1, '<p>П.&nbsp;2 постанови Кабінету Міністрів України від 29.08.2003 №1380 &laquo;Про ліцензування освітніх послуг&raquo;.</p>\r\n', '<p>Плата за видачу копії ліцензії справляється в розмірі п&rsquo;яти неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p>Внесення суб&rsquo;єктом звернення плати за видачу копії ліцензії здійснюється на р/р&nbsp;31413511700001 код&nbsp;37607526 МФО&nbsp;828011, одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200.</p>\r\n', '<p>Загальний строк прийняття суб&rsquo;єктом надання адміністративної послуги рішення про видачу або відмову у видачі ліцензії не може перевищувати трьох місяців.</p>\r\n', '<p>Підставами для прийняття рішення про відмову у видачі копії ліцензії є:</p>\r\n\r\n<ul>\r\n	<li>недостовірність даних у документах, поданих суб&rsquo;єктом звернення, для отримання ліцензії;</li>\r\n	<li>невідповідність суб&rsquo;єкта звернення згідно з поданими документами ліцензійним умовам, встановленим для виду діяльності у сфері освіти, зазначеного в заяві про видачу копії ліцензії.</li>\r\n</ul>\r\n', '<p>Суб&rsquo;єкт звернення отримує копію ліцензії на право провадження діяльності у сфері освіти на бланку ліцензії єдиного зразка.</p>\r\n', '<ul>\r\n	<li>Суб&rsquo;єкт звернення надає до Центру надання адміністративних послуг платіжні документи, що засвідчують плату за видачу копії ліцензії&nbsp; та оплату послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування.</li>\r\n	<li>Суб&rsquo;єкт звернення особисто отримує копію ліцензії на надання освітніх послуг у сфері позашкільної освіти в Центрі надання адміністративних послуг Одеської міської ради.</li>\r\n</ul>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(26, 'Переоформлення ліцензії на надання освітніх послуг у сфері позашкільної освіти', 1, 8, '<ol>\r\n	<li>Закон України&nbsp;&nbsp; від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 22.06.2000 №1841-ІІІ &nbsp;&laquo;Про позашкільну освіту&raquo;, ст.&nbsp;14 п.&nbsp;3.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері позашкільної освіти до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява про переоформлення ліцензії.</li>\r\n	<li>Копії установчих документів (статуту, положення, рішення засновника (власника) або уповноваженого ним органу про створення навчального закладу).</li>\r\n	<li>Відомості про кількісні показники кадрового забезпечення.</li>\r\n	<li>Відомості кількісні показники матеріально-технічного забезпечення освітньої діяльності.</li>\r\n	<li>Копії документів про відповідність приміщень навчального закладу та його матеріально-технічної бази санітарним нормам, вимогам правил пожежної безпеки.</li>\r\n</ol>\r\n', 1, '<p>П.&nbsp;2 постанови Кабінету Міністрів України від 29.08.2003 №1380 &laquo;Про ліцензування освітніх послуг&raquo;.</p>\r\n', '<p>Плата за переоформлення ліцензії справляється в розмірі п&rsquo;яти неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p>Внесення суб&rsquo;єктом звернення плати за переоформлення ліцензії здійснюється на р/р&nbsp;31413511700001 код&nbsp;37607526 МФО&nbsp;828011, одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200.</p>\r\n', '<p>Розгляд на черговому засіданні Регіональної експертної ради з питань ліцензування та атестації навчальних закладів (не рідше одного разу на 2 місяці).</p>\r\n', '<p>Підставою для прийняття рішення про відмову у переоформленні ліцензії є недостовірність даних у документах, поданих суб&rsquo;єктом звернення, для переоформлення ліцензії.</p>\r\n', '<p>Суб&rsquo;єкт звернення отримує ліцензію на право провадження діяльності у сфері освіти на бланку ліцензії єдиного зразка.</p>\r\n', '<ul>\r\n	<li>Суб&rsquo;єкт звернення надає до Центру надання адміністративних послуг платіжні документи, що засвідчують плату&nbsp; за переоформлення ліцензії&nbsp; та оплату послуг організаційного характеру, пов&rsquo;язаних з проведенням ліцензування (у разі проведення експертизи).</li>\r\n	<li>Суб&rsquo;єкт звернення особисто отримує переоформлену ліцензію на надання освітніх послуг у сфері позашкільної освіти в Центрі надання адміністративних послуг Одеської міської ради.</li>\r\n</ul>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(27, 'Анулювання ліцензії на надання освітніх послуг у сфері позашкільної освіти', 1, 8, '<ol>\r\n	<li>Закон України&nbsp;&nbsp; від 06.09.2012 №5203-VI &laquo;Про адміністративні послуги&raquo;;</li>\r\n	<li>Закон України від 01.06.2000 №1775-ІІІ &laquo;Про ліцензування певних видів господарської діяльності&raquo;, ст.&nbsp;9 п.&nbsp;7;</li>\r\n	<li>Закон України від 22.06.2000 №1841-ІІІ &nbsp;&laquo;Про позашкільну освіту&raquo;, ст.&nbsp;14 п.&nbsp;3.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт звернення подає заяву про проведення ліцензування освітньої послуги у сфері позашкільної освіти до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява про анулювання ліцензії.</li>\r\n	<li>Ліцензія.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Розгляд на черговому засіданні Регіональної експертної ради з питань ліцензування та атестації навчальних закладів (не рідше одного разу на 2 місяці).</p>\r\n', '<p>---</p>\r\n', '<p>Наказ органу ліцензування відповідно до рішення&nbsp; Регіональної експертної ради з питань ліцензування та атестації навчальних закладів.</p>\r\n', '<p>На офіційному веб-сайті органу ліцензування.</p>\r\n', 'так', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`, `ff_link`) VALUES
(28, 'Ліцензія на право провадження господарської діяльності з централізованого водопостачання', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n\r\n<p>&nbsp;</p>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<p>1. Заява, заповнена відповідно до ст.10 Закону України &ldquo;Про ліцензування певних видів господарської діяльності&rdquo;.</p>\r\n\r\n<p>2. Відомості за підписом заявника &mdash; суб&#39;єкта господарювання (за формою,встановленою ліцензійними умовами) про:</p>\r\n\r\n<ul>\r\n	<li>Наявність матеріально-технічної бази, для провадження відповідного виду господарської діяльності;</li>\r\n	<li>Відповідність чисельності персоналу та його кваліфікаційного рівня нормативним вимогам щодо провадження відповідного виду господарської діяльності.</li>\r\n	<li>Наявність акредитованої лабораторії, яка здійснює виробничий контроль, або договору на виконання таких робіт з акредитованими лабораторіями інших організацій;</li>\r\n</ul>\r\n\r\n<p>2.4.Потужність, річні обсяги видобування, виробництва та транспортування.</p>\r\n\r\n<p>3. Технологічний регламент експлуатації системи водовідведення за підписом заявника &mdash; суб&#39;єкта господарювання.</p>\r\n\r\n<p>4. Перелік приладів обліку та місць їх встановлення.</p>\r\n\r\n<p>5. Технічна характеристика мереж, споруд та інших об`єктів, їх схеми за підписом керівника суб&#39;єкта господарювання.</p>\r\n\r\n<p>6. Баланс підприємства на останню звітну дату за підписом керівника суб&#39;єкта господарювання, скріпленим печаткою.</p>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p>Одна мінімальна заробітна плата виходячи з її розміру на дату прийняття органам ліцензування рішення про видачу ліцензії.</p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж 10 робочих днів з дати надходження заяви про видачу ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n	<li>Залишення заяви без розгляду:</li>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Ліцензія на право провадження господарської діяльності з централізованого водопостачання, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(29, 'Дублікат ліцензії на право провадження господарської діяльності з централізованого водопостачання', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.18 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Непридатна для користування ліцензія та відповідні документи для видачі дубліката</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p>Плата в розмірі п`яти неоподатковуваних мінімумів доходів громадян на дату подання заяви про переоформлення ліцензії.</p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу дублікату ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж трьох робочих днів з дати надходження заяви про видачу дублікату ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу дубліката ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання дублікату ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення</li>\r\n</ul>\r\n', '<p>Дублікат ліцензії на право провадження господарської діяльності з централізованого водопостачання, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(30, 'Копія ліцензії на право провадження господарської діяльності з централізованого водопостачання', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.18 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Копії надаються під час надання заяви на отримання ліцензії та відповідно до статей 10, 11 та 14 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n</ol>\r\n', 1, '<p>Закон України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n', '<p>Плата в одному неоподатковуваному &nbsp;мінімуму доходів громадян.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про&nbsp; видачу&nbsp; ліцензії та надання копій або про відмову у її видачі у строк не пізніше ніж десять робочих днів з дати надходження заяви про видачу&nbsp; ліцензії та&nbsp; документів,&nbsp; що додаються до заяви, якщо спеціальним законом, що регулює відносини у певних сферах господарської діяльності, не&nbsp; передбачений інший строк видачі ліцензії на окремі види діяльності. Повідомлення про прийняття&nbsp; рішення&nbsp; про видачу ліцензії або про відмову у видачі ліцензії надсилається (видається) заявникові в письмовій&nbsp; формі&nbsp; протягом&nbsp; трьох робочих днів з дати прийняття відповідного рішення.&nbsp; У рішенні про відмову у видачі&nbsp; ліцензії зазначаються підстави такої відмови.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа, що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Підстави для відмови:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання дублікату ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Копія ліцензії на право провадження господарської діяльності з централізованого водопостачання, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(31, 'Переоформлення ліцензії на право провадження господарської діяльності з централізованого водопостачання', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.16 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Ліцензія, що підлягає переоформленню та відповідні документи або їх нотаріально засвідчені копії, які підтверджують зазначені зміни.</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p>Плата в розмірі п`яти неоподатковуваних мінімумів доходів громадян на дату подання заяви про переоформлення ліцензії.</p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж трьох робочих днів з дати надходження заяви про переоформлення ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Не переоформлена в установлений строк ліцензія є недійсною.</p>\r\n', '<p>Ліцензія на право провадження господарської діяльності з централізованого водопостачання, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(32, 'Анулювання ліцензії на право провадження господарської діяльності з централізованого водопостачання', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<p>Заява, ліцензіата про анулювання заповнена відповідно до ст. 21 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n', 0, '', '', '', '<p>Орган ліцензування приймає рішення про анулювання ліцензії протягом 10 робочих днів з дати встановлення підстав для анулювання ліцензії.</p>\r\n\r\n<p>Повідомлення про прийняття рішення надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n', '<p>Відмова у анулюванні ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для анулювання ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про анулювання ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Анулювання ліцензії на право провадження господарської діяльності з централізованого водопостачання, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(33, 'Ліцензія на право провадження господарської діяльності з централізованого водовідведення', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг</p>\r\n', '<p>1. Заява, заповнена відповідно до ст.10 Закону України &ldquo;Про ліцензування певних видів господарської діяльності&rdquo;.</p>\r\n\r\n<p>2. Відомості за підписом заявника &mdash; суб&#39;єкта господарювання (за формою,встановленою ліцензійними умовами) про:</p>\r\n\r\n<ul>\r\n	<li>2.1. Наявність матеріально-технічної бази, для провадження відповідного виду господарської діяльності;</li>\r\n	<li>2.2. Відповідність чисельності персоналу та його кваліфікаційного рівня нормативним вимогам щодо провадження відповідного виду господарської діяльності.</li>\r\n	<li>2.3. Наявність акредитованої лабораторії, яка здійснює виробничий контроль, або договору на виконання таких робіт з акредитованими лабораторіями інших організацій;</li>\r\n	<li>2.4.Потужність, річні обсяги видобування, виробництва та транспортування.</li>\r\n</ul>\r\n\r\n<p>3.Технологічний регламент експлуатації системи водовідведення за підписом заявника &mdash; суб&#39;єкта господарювання;</p>\r\n\r\n<p>4. Перелік приладів обліку та місць їх встановлення.</p>\r\n\r\n<p>5.Технічна характеристика мереж, споруд та інших об`єктів, їх схеми за підписом керівника суб&#39;єкта господарювання.</p>\r\n\r\n<p>6.Баланс підприємства на останню звітну дату за підписом керівника суб&#39;єкта господарювання, скріпленим печаткою.</p>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p>Одна мінімальна заробітна плата виходячи з її розміру на дату прийняття органам ліцензування рішення про видачу ліцензії.</p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж 10 робочих днів з дати надходження заяви про видачу ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Ліцензія на право провадження господарської діяльності з централізованого водовідведення, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(34, 'Дублікат ліцензії на право провадження господарської діяльності з централізованого водовідведення', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.18 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>2. Непридатна для користування ліцензія та відповідні документи для видачі дубліката.&nbsp;</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<ul>\r\n	<li>Плата в розмірі п`яти неоподатковуваних мінімумів доходів громадян на дату подання заяви про переоформлення ліцензії.</li>\r\n	<li>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</li>\r\n</ul>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу дублікату ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж трьох робочих днів з дати надходження заяви про видачу дублікату ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу дубліката ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання дублікату ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Дублікат ліцензії на право провадження господарської діяльності з централізованого водовідведення, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`, `ff_link`) VALUES
(35, 'Копія ліцензії на право провадження господарської діяльності з централізованого водовідведення', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.18 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Копії надаються під час надання заяви на отримання ліцензії та відповідно до статей 10, 11 та 14 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n</ol>\r\n', 1, '<p>Закон України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n', '<p>Плата в одному неоподатковуваному &nbsp;мінімуму доходів громадян.</p>\r\n\r\n<p>&nbsp;</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій</p>\r\n', '<pre>\r\nОрган ліцензування приймає рішення про&nbsp; видачу&nbsp; ліцензії та надання копій або про відмову у її видачі у строк не пізніше ніж десять робочих днів з дати надходження заяви про видачу&nbsp; ліцензії та&nbsp; документів,&nbsp; що додаються до заяви, якщо спеціальним законом, що регулює відносини у певних сферах господарської діяльності, не&nbsp; передбачений інший строк видачі ліцензії на окремі види діяльності. <a name="o202"></a>Повідомлення про прийняття&nbsp; рішення&nbsp; про видачу ліцензії або про відмову у видачі ліцензії надсилається (видається) заявникові в письмовій&nbsp; формі&nbsp; протягом&nbsp; трьох робочих днів з дати прийняття відповідного рішення.&nbsp; У рішенні про відмову у видачі&nbsp; ліцензії зазначаються підстави такої відмови. </pre>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа, що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії та її копій (ії):</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання дублікату ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Копія ліцензії на право провадження господарської діяльності з централізованого водопостачання, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(36, 'Переоформлення ліцензії на право провадження господарської діяльності з централізованого водовідведення', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.16 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Ліцензія, що підлягає переоформленню та відповідні документи або їх нотаріально засвідчені копії, які підтверджують зазначені зміни.</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<ul>\r\n	<li>Плата в розмірі п`яти неоподатковуваних мінімумів доходів громадян на дату подання заяви про переоформлення ліцензії.</li>\r\n	<li>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</li>\r\n</ul>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж трьох робочих днів з дати надходження заяви про переоформлення ліцензії та документів, що додаються до заяви</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Не переоформлена в установлений строк ліцензія є недійсною.</p>\r\n', '<p>Ліцензія на право провадження господарської діяльності з централізованого водовідведення, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(37, 'Анулювання ліцензії на право провадження господарської діяльності з централізованого водовідведення', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<p>Заява, ліцензіата про анулювання заповнена відповідно до ст. 21 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n', 0, '', '', '', '<p>Орган ліцензування приймає рішення про анулювання ліцензії протягом10 робочих днів з дати встановлення підстав для анулювання ліцензії.</p>\r\n\r\n<p>Повідомлення про прийняття рішення надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n', '<p>Відмова у анулюванні ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для анулювання ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про анулювання ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Анулювання ліцензії на право провадження господарської діяльності з централізованого водовідведення, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(38, 'Ліцензія на право провадження господарської діяльності з централізованого водопостачання та водовідведення', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<p>1. Заява, заповнена відповідно до ст.10 Закону України &ldquo;Про ліцензування певних видів господарської діяльності&rdquo;.</p>\r\n\r\n<p>2. Відомості за підписом заявника &mdash; суб&#39;єкта господарювання (за формою,встановленою ліцензійними умовами) про:</p>\r\n\r\n<ul>\r\n	<li>Наявність матеріально-технічної бази, для провадження відповідного виду господарської діяльності;</li>\r\n	<li>Відповідність чисельності персоналу та його кваліфікаційного рівня нормативним вимогам щодо провадження відповідного виду господарської діяльності.</li>\r\n	<li>Наявність акредитованої лабораторії, яка здійснює виробничий контроль, або договору на виконання таких робіт з акредитованими лабораторіями інших організацій;</li>\r\n	<li>Потужність, річні обсяги видобування, виробництва та транспортування.</li>\r\n</ul>\r\n\r\n<p>3.Технологічний регламент експлуатації системи водовідведення за підписом заявника &mdash; суб&#39;єкта господарювання;</p>\r\n\r\n<p>4. Перелік приладів обліку та місць їх встановлення.</p>\r\n\r\n<p>5.Технічна характеристика мереж, споруд та інших об`єктів, їх схеми за підписом керівника суб&#39;єкта господарювання.</p>\r\n\r\n<p>6.Баланс підприємства на останню звітну дату за підписом керівника суб&#39;єкта господарювання, скріпленим печаткою.</p>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;/</p>\r\n', '<p><strong>Одна мінімальна заробітна плата виходячи з її розміру на дату прийняття органам ліцензування рішення про видачу ліцензії.</strong></p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж 10 робочих днів з дати надходження заяви про видачу ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної/</p>\r\n', '<p>Відмова у видачі ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Ліцензія на право провадження господарської діяльності з централізованого водопостачання та водовідведення, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(39, 'Дублікат ліцензії на право провадження господарської діяльності з централізованого водопостачання та водовідведення', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.18 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Непридатна для користування ліцензія та відповідні документи для видачі дубліката.</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p><strong>Плата в розмірі п`яти неоподатковуваних мінімумів доходів громадян на дату подання заяви про переоформлення ліцензії.</strong></p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу дублікату ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж трьох робочих днів з дати надходження заяви про видачу дублікату ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу дубліката ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання дублікату ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення</li>\r\n</ul>\r\n', '<p>Дублікат ліцензії на право провадження господарської діяльності з централізованого водопостачання та водовідведення, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(40, 'Копія ліцензії на право провадження господарської діяльності з централізованого водопостачання та водовідведення', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.18 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Копії надаються під час надання заяви на отримання ліцензії та відповідно до статей 10, 11 та 14 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n</ol>\r\n', 1, '<p>Закон України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n', '<p>Плата в одному неоподатковуваному &nbsp;мінімуму доходів громадян.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<pre>\r\nОрган ліцензування приймає рішення про&nbsp; видачу&nbsp; ліцензії та надання копій або про відмову у її видачі у строк не пізніше ніж десять робочих днів з дати надходження заяви про видачу&nbsp; ліцензії та&nbsp; документів,&nbsp; що додаються до заяви, якщо спеціальним законом, що регулює відносини у певних сферах господарської діяльності, не&nbsp; передбачений інший строк видачі ліцензії на окремі види діяльності. <a name="o202"></a>Повідомлення про прийняття&nbsp; рішення&nbsp; про видачу ліцензії або про відмову у видачі ліцензії надсилається (видається) заявникові в письмовій&nbsp; формі&nbsp; протягом&nbsp; трьох робочих днів з дати прийняття відповідного рішення.&nbsp; У рішенні про відмову у видачі&nbsp; ліцензії зазначаються підстави такої відмови. </pre>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа, що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії та її копій (ії):</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання дублікату ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Копія ліцензії на право провадження господарської діяльності з централізованого водопостачання, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(41, 'Переоформлення ліцензії на право провадження господарської діяльності з централізованого водопостачання та водовідведення', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.16 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Ліцензія, що підлягає переоформленню та відповідні документи або їх нотаріально засвідчені копії, які підтверджують зазначені зміни.</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p><strong>Плата в розмірі п`яти неоподатковуваних мінімумів доходів громадян на дату подання заяви про переоформлення ліцензії.</strong></p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>рган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж трьох робочих днів з дати надходження заяви про переоформлення ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Не переоформлена в установлений строк ліцензія є недійсною.</p>\r\n', '<p>Ліцензія на право провадження господарської діяльності з централізованого водопостачання та водовідведення, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(42, 'Анулювання ліцензії на право провадження господарської діяльності з централізованого водопостачання та водовідведення', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<p>Заява, ліцензіата про анулювання заповнена відповідно до ст. 21 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n', 0, '', '', '', '<p><strong>Орган ліцензування приймає рішення про анулювання ліцензії протягом 10 робочих днів з дати встановлення підстав для анулювання ліцензії.</strong></p>\r\n\r\n<p>Повідомлення про прийняття рішення надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення</p>\r\n', '<p>Відмова у анулюванні ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для анулювання ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про анулювання ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Анулювання ліцензії&nbsp;на право провадження господарської діяльності з централізованого водопостачання та водовідведення, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`, `ff_link`) VALUES
(43, 'Ліцензія  на право провадження господарської діяльності з постачання теплової енергії', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.10 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Перелік приладів обліку із&nbsp;зазначенням&nbsp; місць їх&nbsp; встановлення.</li>\r\n	<li>Відомості про обсяги постачання теплової енергії за підписом&nbsp; керівника суб&rsquo;єкта господарювання.</li>\r\n	<li>Баланс підприємства на останню звітну дату за підписом керівника&nbsp;суб&rsquo;єкта господарювання, скріпленим печаткою.</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p><strong>Одна мінімальна заробітна плата виходячи з її розміру на дату прийняття органам ліцензування рішення про видачу ліцензії.</strong></p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p><strong>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж 10 робочих днів з дати надходження заяви про видачу ліцензії та документів, що додаються до заяви.</strong></p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Ліцензія на право провадження господарської діяльності з постачання теплової енергії, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(44, 'Дублікат ліцензії  на право провадження господарської діяльності з постачання теплової енергії', 1, 3, '<ol>\r\n	<li>Закон України &ldquo;Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.18 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Непридатна для користування ліцензія та відповідні документи для видачі дубліката.</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p><strong>Плата в розмірі п`яти неоподатковуваних мінімумів доходів громадян на дату подання заяви про переоформлення ліцензії.</strong></p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу дублікату ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж трьох робочих днів з дати надходження заяви про видачу дублікату ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу дубліката ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання дублікату ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Дублікат ліцензії на право провадження господарської діяльності з постачання теплової енергії, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(45, 'Копія ліцензії  на право провадження господарської діяльності з постачання теплової енергії', 1, 3, '<ol>\r\n	<li>Закон України &ldquo;Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.18 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Копії надаються під час надання заяви на отримання ліцензії та відповідно до статей 10, 11 та 14 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n</ol>\r\n', 1, '<p>Закон України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n', '<p>Плата в одному неоподатковуваному &nbsp;мінімуму доходів громадян.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу копії ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про&nbsp; видачу&nbsp; ліцензії та надання копій або про відмову у її видачі у строк не пізніше ніж десять робочих днів з дати надходження заяви про видачу&nbsp; ліцензії та&nbsp; документів,&nbsp; що додаються до заяви, якщо спеціальним законом, що регулює відносини у певних сферах господарської діяльності, не&nbsp; передбачений інший строк видачі ліцензії на окремі види діяльності. Повідомлення про прийняття&nbsp; рішення&nbsp; про видачу ліцензії або про відмову у видачі ліцензії надсилається (видається) заявникові в письмовій&nbsp; формі&nbsp; протягом&nbsp; трьох робочих днів з дати прийняття відповідного рішення.&nbsp; У рішенні про відмову у видачі&nbsp; ліцензії зазначаються підстави такої відмови.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа, що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії та її копії (ій):</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання дублікату ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Копія(ії) ліцензії на право провадження господарської діяльності з виробництва та постачання теплової енергії, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(46, 'Переоформлення ліцензії  на право провадження господарської діяльності з постачання теплової енергії', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.16 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Ліцензія, що підлягає переоформленню та відповідні документи або їх нотаріально засвідчені копії, які підтверджують зазначені зміни.</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p><strong>Плата в розмірі п`яти неоподатковуваних мінімумів доходів громадян на дату подання заяви про переоформлення ліцензії.</strong></p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж трьох робочих днів з дати надходження заяви про переоформлення ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Не переоформлена в установлений строк ліцензія є недійсною.</p>\r\n', '<p>Ліцензія на право провадження господарської діяльності з постачання теплової енергії, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(47, 'Анулювання ліцензії  на право провадження господарської діяльності з постачання теплової енергії', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<p>Заява, ліцензіата про анулювання заповнена відповідно до ст. 21 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n', 0, '', '', '', '<p><strong>Орган ліцензування приймає рішення про анулювання ліцензії протягом 10 робочих днів з дати встановлення підстав для анулювання ліцензії.</strong></p>\r\n\r\n<p>Повідомлення про прийняття рішення надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення</p>\r\n', '<p>Відмова у анулюванні ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для анулювання ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про анулювання ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Анулювання ліцензії на право провадження господарської діяльності з постачання теплової енергії, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(48, 'Ліцензія  на право провадження господарської діяльності з транспортування  теплової енергії магістральними та місцевими (розподільчими) тепловими мережам', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг</p>\r\n', '<p>1. Заява, заповнена відповідно до ст.10 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n\r\n<p>2. Відомості за підписом заявника -&nbsp; суб&rsquo;єкта господарювання (за формою, встановленою ліцензійними умовами) про:</p>\r\n\r\n<ul>\r\n	<li>Наявність матеріально-технічної бази, необхідної для провадження</li>\r\n	<li>відповідного виду господарської діяльності;</li>\r\n	<li>Технічний стан трубопроводів та споруд на них (на підставі експлуатаційної документації на такі об&rsquo;єкти);</li>\r\n	<li>2.3 Наявність проектної і виконавчої документації на трубопроводи та споруди на них, які&nbsp;&nbsp;&nbsp; використовуються для провадження відповідного виду господарської</li>\r\n	<li>діяльності;&nbsp;Перелік трубопроводів, що перебувають у користуванні заявника</li>\r\n	<li>суб&rsquo;єкта господарювання, їх технічна характеристика та річні обсяги</li>\r\n	<li>транспортування теплової енергії;</li>\r\n	<li>Перелік приладів обліку із зазначенням місць їх встановлення;&nbsp;Схема трубопроводів, нанесена на географічну карту місцевості;</li>\r\n	<li>Копія затвердженої місцевим органом виконавчої влади схеми</li>\r\n	<li>теплопостачання;</li>\r\n	<li>Баланс підприємства на останню звітну дату за підписом керівника</li>\r\n	<li>суб&rsquo;єкта господарювання, скріпленим печаткою.</li>\r\n	<li>Засвідчені в установленому порядку копії актів і схем розмежування ділянок обслуговування між суб&rsquo;єктами господарювання, трубопроводами яких з&rsquo;єднані між собою;</li>\r\n	<li>Засвідчені в установленому порядку копії документів, що підтверджують освітній і кваліфікаційний рівень працівників, необхідний для провадження відповідного виду господарської діяльності.</li>\r\n</ul>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p><strong>Одна мінімальна заробітна плата виходячи з її розміру на дату прийняття органам ліцензування рішення про видачу ліцензії.</strong></p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p><strong>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж 10 робочих днів з дати надходження заяви про видачу ліцензії та документів, що додаються до заяви.</strong></p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Ліцензія на право провадження господарської діяльності з транспортування&nbsp; теплової енергії магістральними та місцевими (розподільчими) тепловими мережами, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(49, 'Дублікат ліцензії  на право провадження господарської діяльності з транспортування  теплової енергії магістральними та місцевими (розподільчими) тепловими мережами', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.18 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Непридатна для користування ліцензія та відповідні документи для видачі дубліката.&nbsp;</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p><strong>Плата в розмірі п`яти неоподатковуваних мінімумів доходів громадян на дату подання заяви про переоформлення ліцензії.</strong></p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n\r\n<p>&nbsp;</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу дублікату ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж трьох робочих днів з дати надходження заяви про видачу дублікату ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу дубліката ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання дублікату ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Дублікат ліцензії на право провадження господарської діяльності з виробництва та постачання теплової енергії, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`, `ff_link`) VALUES
(50, 'Копія ліцензії  на право провадження господарської діяльності з транспортування  теплової енергії магістральними та місцевими (розподільчими) тепловими мережами', 1, 3, '<ol>\r\n	<li>Закон України &ldquo;Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.18 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Копії надаються під час надання заяви на отримання ліцензії та відповідно до статей 10, 11 та 14 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n</ol>\r\n', 1, '<p>Закон України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n', '<p>Плата в одному неоподатковуваному &nbsp;мінімуму доходів громадян.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу копії ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про&nbsp; видачу&nbsp; ліцензії та надання копій або про відмову у її видачі у строк не пізніше ніж десять робочих днів з дати надходження заяви про видачу&nbsp; ліцензії та&nbsp; документів,&nbsp; що додаються до заяви, якщо спеціальним законом, що регулює відносини у певних сферах господарської діяльності, не&nbsp; передбачений інший строк видачі ліцензії на окремі види діяльності. Повідомлення про прийняття&nbsp; рішення&nbsp; про видачу ліцензії або про відмову у видачі ліцензії надсилається (видається) заявникові в письмовій&nbsp; формі&nbsp; протягом&nbsp; трьох робочих днів з дати прийняття відповідного рішення.&nbsp; У рішенні про відмову у видачі&nbsp; ліцензії зазначаються підстави такої відмови.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа, що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії та її копії (ій):</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання дублікату ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Копія(ії) ліцензії на право провадження господарської діяльності з виробництва та постачання теплової енергії, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(51, 'Переоформлення ліцензії  на право провадження господарської діяльності з транспортування  теплової енергії магістральними та місцевими (розподільчими) тепловими мережами', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.16 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Ліцензія, що підлягає переоформленню та відповідні документи або їх нотаріально засвідчені копії, які підтверджують зазначені зміни.</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу.</p>\r\n', '<p><strong>Плата в розмірі п`яти неоподатковуваних мінімумів доходів громадян на дату подання заяви про переоформлення ліцензії.</strong></p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж трьох робочих днів з дати надходження заяви про переоформлення ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Не переоформлена в установлений строк ліцензія є недійсною.</p>\r\n', '<p>Ліцензія на право провадження господарської діяльності з транспортування теплової енергії магістральними та місцевими (розподільчими) тепловими мережами, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(52, 'Анулювання ліцензії  на право провадження господарської діяльності з транспортування  теплової енергії магістральними та місцевими (розподільчими) тепловими мережами', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<p>Заява, ліцензіата про анулювання заповнена відповідно до ст. 21 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n', 0, '', '', '', '<p><strong>Орган ліцензування приймає рішення про анулювання ліцензії протягом 10 робочих днів з дати встановлення підстав для анулювання ліцензії.</strong></p>\r\n\r\n<p>Повідомлення про прийняття рішення надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення</p>\r\n', '<p>Відмова у анулюванні ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для анулювання ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про анулювання ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Анулювання ліцензії на право провадження господарської діяльності з транспортування теплової енергії магістральними та місцевими (розподільчими) тепловими мережами, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(53, 'Ліцензія  на право провадження господарської діяльності з виробництва теплової енергії (крім діяльності  з виробництва теплової енергії на теплоелектроцентралях, теплоелектростанціях, атомних електростанціях і когенераційних установках та установках з вик', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<p>1. Заява, заповнена відповідно до ст.10 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n\r\n<p>2. Засвідчена в установленому&nbsp; порядку копія документа, що підтверджує право власності суб&rsquo;єкта господарювання або оренди ним виробничих об&rsquo;єктів, де провадитиметься відповідний вид господарської діяльності.</p>\r\n\r\n<p>3. Відомості за підписом заявника -&nbsp; суб&rsquo;єкта господарювання (за формою, встановленою ліцензійними умовами) про:</p>\r\n\r\n<ul>\r\n	<li>Наявність власних або орендованих виробничих об&rsquo;єктів, де провадитиметься підповідний вид господарської діяльності;</li>\r\n	<li>Наявність та стан технологічного обладнання і технічної бази для його обслуговування;</li>\r\n	<li>Освітній і кваліфікаційний рівень працівників, необхідний для провадження відповідного&nbsp;виду господарської діяльності;</li>\r\n	<li>Баланс підприємства на&nbsp;&nbsp;останню звітну дату з підписом керівника суб&rsquo;єкта господарювання,&nbsp;скріпленим печаткою.</li>\r\n</ul>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p><strong>Одна мінімальна заробітна плата виходячи з її розміру на дату прийняття органам ліцензування рішення про видачу ліцензії.</strong></p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p><strong>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж 10 робочих днів з дати надходження заяви про видачу ліцензії та документів, що додаються до заяви.</strong></p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Ліцензія на право провадження господарської діяльності з виробництва теплової енергії (крім діяльності&nbsp; з виробництва теплової енергії на теплоелектроцентралях, теплоелектростанціях, атомних електростанціях і когенераційних установках та установках з використанням нетрадиційних або поновлювальних джерел енергії, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(54, 'Дублікат ліцензії  на право провадження господарської діяльності з виробництва теплової енергії (крім діяльності  з виробництва теплової енергії на теплоелектроцентралях, теплоелектростанціях, атомних електростанціях і когенераційних установках та установ', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.18 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Непридатна для користування ліцензія та відповідні документи для видачі дубліката.</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p><strong>Плата в розмірі п`яти неоподатковуваних мінімумів доходів громадян на дату подання заяви про переоформлення ліцензії.</strong></p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу дублікату ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж трьох робочих днів з дати надходження заяви про видачу дублікату ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу дубліката ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання дублікату ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Дублікат ліцензії на право провадження господарської діяльності з виробництва теплової енергії (крім діяльності&nbsp; з виробництва теплової енергії на теплоелектроцентралях, теплоелектростанціях, атомних електростанціях і когенераційних установках та установках з використанням нетрадиційних або поновлювальних джерел енергії, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(56, 'Копія ліцензії  на право провадження господарської діяльності з виробництва теплової енергії (крім діяльності  з виробництва теплової енергії на теплоелектроцентралях, теплоелектростанціях, атомних електростанціях і когенераційних установках та установ', 1, 3, '<ol>\r\n	<li>Закон України &ldquo;Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.18 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Копії надаються під час надання заяви на отримання ліцензії та відповідно до статей 10, 11 та 14 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n</ol>\r\n', 1, '<p>Закон України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n', '<p>Плата в одному неоподатковуваному &nbsp;мінімуму доходів громадян.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу копії ліцензій.</p>\r\n', '<pre>\r\nОрган ліцензування приймає рішення про&nbsp; видачу&nbsp; ліцензії та надання копій або про відмову у її видачі у строк не пізніше ніж десять робочих днів з дати надходження заяви про видачу&nbsp; ліцензії та&nbsp; документів,&nbsp; що додаються до заяви, якщо спеціальним законом, що регулює відносини у певних сферах господарської діяльності, не&nbsp; передбачений інший строк видачі ліцензії на окремі види діяльності. <a name="o202"></a>Повідомлення про прийняття&nbsp; рішення&nbsp; про видачу ліцензії або про відмову у видачі ліцензії надсилається (видається) заявникові в письмовій&nbsp; формі&nbsp; протягом&nbsp; трьох робочих днів з дати прийняття відповідного рішення.&nbsp; У рішенні про відмову у видачі&nbsp; ліцензії зазначаються підстави такої відмови. </pre>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа, що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії та її копії (ій):</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання дублікату ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Копія(ії) ліцензії на право провадження господарської діяльності з виробництва та постачання теплової енергії, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(58, 'Переоформлення ліцензії на право провадження господарської діяльності з виробництва теплової енергії (крім діяльності  з виробництва теплової енергії на теплоелектроцентралях, теплоелектростанціях, атомних електростанціях і когенераційних установках ', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява, заповнена відповідно до ст.16 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Ліцензія, що підлягає переоформленню та відповідні документи або їх нотаріально засвідчені копії, які підтверджують зазначені зміни.</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p>Плата в розмірі п`яти неоподатковуваних мінімумів доходів громадян на дату подання заяви про переоформлення ліцензії.</p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж трьох робочих днів з дати надходження заяви про переоформлення ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Не переоформлена в установлений строк ліцензія є недійсною.</p>\r\n', '<p>Ліцензія на право провадження господарської діяльності з виробництва теплової енергії (крім діяльності з виробництва теплової енергії на теплоелектроцентралях, теплоелектростанціях, атомних електростанціях і когенераційних установках та установках з використанням нетрадиційних або поновлювальних джерел енергії, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(59, 'Анулювання ліцензії  на право провадження господарської діяльності з виробництва теплової енергії (крім діяльності  з виробництва теплової енергії на теплоелектроцентралях, теплоелектростанціях, атомних електростанціях і когенераційних установках', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<p>Заява, ліцензіата про анулювання заповнена відповідно до ст. 21 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n', 0, '', '', '', '<p><strong>Орган ліцензування приймає рішення про анулювання ліцензії протягом 10 робочих днів з дати встановлення підстав для анулювання ліцензії.</strong></p>\r\n\r\n<p>Повідомлення про прийняття рішення надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n', '<p>Відмова у анулюванні ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для анулювання ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про анулювання ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Анулювання ліцензії на право провадження господарської діяльності з виробництва теплової енергії (крім діяльності з виробництва теплової енергії на теплоелектроцентралях, теплоелектростанціях, атомних електростанціях і когенераційних установках та установках з використанням нетрадиційних або поновлювальних джерел енергії, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`, `ff_link`) VALUES
(60, 'Ліцензія  на право провадження господарської діяльності з виробництва теплової енергії, транспортування її магістральними та місцевими (розподільчими) тепловими мережами та постачання теплової енергії', 1, 3, '<ol>\r\n	<li>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження документів, які додаються до заяви про видачу ліцензії для окремого виду діяльності&rdquo;</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>аява, заповнена відповідно до ст.10 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</li>\r\n	<li>Засвідчена в установленому&nbsp; порядку копія документа, що підтверджує право власності суб&rsquo;єкта господарювання або оренди ним виробничих об&rsquo;єктів, де провадитиметься відповідний вид господарської діяльності.</li>\r\n	<li>Відомості за підписом заявника -&nbsp; суб&rsquo;єкта господарювання (за формою, встановленою ліцензійними умовами) про:</li>\r\n</ol>\r\n\r\n<ul>\r\n	<li>Наявність власних або орендованих виробничих об&rsquo;єктів, де провадитиметься відповідний вид господарської діяльності;</li>\r\n	<li>Наявність та стан технологічного обладнання і технічної бази для його обслуговування;</li>\r\n	<li>Освітній і кваліфікаційний рівень працівників, необхідний для провадження відповідного Виду господарської діяльності;</li>\r\n	<li>Наявність матеріально -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; технічної бази, необхідної для провадження відповідного виду&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; господарської діяльності;</li>\r\n	<li>Технічний стан трубопроводів та споруд на них (на підставі експлуатаційної документації на такі об&rsquo;єкти);</li>\r\n	<li>Наявність проектної і виконавчої документації на трубопроводи та споруди на них, які&nbsp;&nbsp;&nbsp;використовуються для&nbsp; провадження відповідного виду господарської&nbsp;діяльності;</li>\r\n	<li>Перелік трубопроводів, що перебувають у користуванні заявника суб&rsquo;єкта господарювання, їх технічна характеристика та річні обсяги&nbsp;транспортування теплової&nbsp; енергії;</li>\r\n	<li>Перелік приладів обліку із зазначенням місць їх&nbsp; встановлення;</li>\r\n	<li>Схема трубопроводів, нанесена на географічну карту місцевості;</li>\r\n	<li>Копія затвердженої місцевим органом виконавчої влади схеми теплопостачання;</li>\r\n	<li>Засвідчені в установленому порядку копії актів і схем розмежування ділянок обслуговування між суб&rsquo;єктами господарювання, трубопроводами яких з&rsquo;єднані між собою;</li>\r\n	<li>Засвідчені в установленому порядку копії документів, що підтверджують освітній і кваліфікаційний рівень працівників, необхідний для провадження відповідного виду господарської діяльності;</li>\r\n	<li>Відомість про обсяги &nbsp;постачання теплової&nbsp; енергії за підписом керівника суб&rsquo;єкта господарювання;</li>\r\n	<li>Баланс підприємства на останню звітну дату за підписом керівника&nbsp;суб&rsquo;єкта господарювання, скріпленим печаткою.</li>\r\n</ul>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;.</p>\r\n', '<p><strong>Одна мінімальна заробітна плата виходячи з її розміру на дату прийняття органам ліцензування рішення про видачу ліцензії.</strong></p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії.</p>\r\n', '<p>Одержувач: ГУДКСУ в Одеській області</p>\r\n\r\n<p>Банк одержувача: ГУДКСУ в Одеській області</p>\r\n\r\n<p>ОКПО (код):&nbsp;37607526</p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;31413511700001</p>\r\n\r\n<p>МФО (код банку):&nbsp;828011</p>\r\n\r\n<p>Код платежу:&nbsp;22010200</p>\r\n\r\n<p>Призначення платежу:&nbsp;плата за видачу ліцензій.</p>\r\n', '<p>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж 10 робочих днів з дати надходження заяви про видачу ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної.</p>\r\n', '<p>Відмова у видачі ліцензії:</p>\r\n\r\n<ul>\r\n	<li>Недостовірність даних у документах, поданих заявником, для отримання ліцензії;</li>\r\n	<li>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</li>\r\n</ul>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<ul>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Документи оформлені з порушенням вимог;</li>\r\n	<li>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення.</li>\r\n</ul>\r\n', '<p>Ліцензія на право провадження господарської діяльності з виробництва теплової енергії, транспортування її магістральними та місцевими (розподільчими) тепловими мережами та постачання теплової енергії, відмова або залишення заяви без розгляду.</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(61, 'Складання актів обстеження спеціалізованих або спеціалізованих металургійних переробних підприємств або їх приймальних пунктів', 1, 10, '<ol>\r\n	<li>Стаття 4 Закону України &laquo;Про металобрухт&raquo;.</li>\r\n	<li>Наказ Міністерства економічного розвитку і торгівлі України від 31.10.2011 р. № 183, зареєстрований у Міністерстві юстиції України 18.11.2011&nbsp;р. за №&nbsp;1321/20059&nbsp; &laquo;Про затвердження Ліцензійних умов провадження господарської діяльності із заготівлі, переробки, металургійної переробки металобрухту кольорових і чорних металів&raquo;,</li>\r\n	<li>Наказ Міністерства економічного розвитку і торгівлі України від 03.11.2011 р. №&nbsp;191 &laquo;Про затвердження форм актів обстеження суб&rsquo;єктів господарювання&raquo;.</li>\r\n	<li>Розпорядження голови обласної державної адміністрації від 19.04.2013 №&nbsp;356/А-2013 &laquo;Про робочу групу для проведення обстеження спеціалізованих підприємств, спеціалізованих металургійних переробних підприємств та їх приймальних пунктів на відповідність вимогам Закону України &laquo;Про металобрухт&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Письмова заява може бути подана особисто, надіслана поштою або у випадках, передбачених законом&nbsp; за допомогою засобів телекомунікаційного зв&rsquo;язку через Управління надання адміністративних послуг Одеської міської ради.</p>\r\n', '<p>Заява на отримання адміністративної послуги в письмовій формі.</p>\r\n', 0, '', '', '', '<p>Протягом 15 календарних днів з дня надходження заяви до суб&rsquo;єкта надання адміністративної послуги.</p>\r\n', '<p>Невідповідність спеціалізованих або спеціалізованих металургійних переробних підприємств та їх приймальних пунктів вимогам Закону України &laquo;Про металобрухт&raquo; та Ліцензійним умовам провадження господарської діяльності із заготівлі, переробки, металургійної переробки металобрухту кольорових і чорних металів, затвердженим наказом Міністерства економічного розвитку і торгівлі України від 31.10.2011&nbsp;№&nbsp;183, зареєстрованим у Міністерстві юстиції України 18.11.2011&nbsp;р. за №&nbsp;1321/20059.</p>\r\n', '<p>Акт обстеження спеціалізованого або спеціалізованого металургійного переробного підприємства або його приймальних пунктів або лист з обґрунтуванням причин відмови.</p>\r\n', '<p>Через Центр&nbsp;надання адміністративних послуг Одеської міської ради, суб&rsquo;єктом звернення особисто або направлення поштою (рекомендованим листом з повідомленням про вручення) листа з повідомленням про можливість отримання такої послуги на адресу суб&rsquo;єкта звернення.</p>\r\n', 'так', 0, '', 0, '', '', '', '', 38),
(62, 'Державна реєстрація змін і доповнень до договорів (контрактів) про спільну інвестиційну діяльність за участю іноземного інвестора', 1, 5, '<ol>\r\n	<li>Стаття 24 Закону України &laquo;Про режим іноземного інвестування&raquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 30.01.1997 №112 &quot;Про затвердження Положення про порядок державної реєстрації договорів (контрактів) про спільну інвестиційну діяльність за участю іноземного інвестора&quot;.</li>\r\n	<li>Наказ Міністерства зовнішніх економічних зв&#39;язків і торгівлі України від 20.02.1997 р. №125 України &laquo;Про заходи МЗЕЗторгу щодо забезпечення виконання Постанови КМУ від 30.01.1997 р. № 112&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&#39;єкт зовнішньоекономічної діяльності України - учасник договору (контракту), якому доручено ведення спільних справ учасників, або уповноважена ним особа подає документи до Центру надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Лист-звернення про державну реєстрацію змін і доповнень до договору (контракту).</li>\r\n	<li>Інформаційна картка договору (контракту) за формою, що встановлює Мінекономрозвитку.</li>\r\n	<li>Договір (контракт) (оригінал і копію), засвідчені в установленому порядку.</li>\r\n	<li>Засвідчені копії установчих документів суб&rsquo;єкта (суб&rsquo;єктів) зовнішньоекономічної діяльності України та свідоцтва про його державну реєстрацію як суб&rsquo;єкта підприємницької діяльності.</li>\r\n	<li>Документи, що свідчать про реєстрацію (створення) іноземної юридичної особи (нерезидента) в країні її місцезнаходження (витяг із торгівельного, банківського або судового реєстру тощо). Ці документи повинні бути засвідчені відповідно до законодавства країни їх видачі, перекладенні українською мовою та легалізовані у консульській установі України, якщо міжнародними договорами, в яких бере участь Україна, не передбачено інше. Зазначені документи можуть бути засвідчені також у посольстві відповідної держави в Україні та легалізовані в МЗС.</li>\r\n	<li>Ліцензія, якщо згідно із законодавством України цього вимагає діяльність, що передбачається договором (контрактом).</li>\r\n	<li>Документ про оплату послуг за державну реєстрацію договору (контракту).</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 30.01.1997 №112 &quot;Про затвердження Положення про порядок державної реєстрації договорів (контрактів) про спільну інвестиційну діяльність за участю іноземного інвестора&quot;.</p>\r\n', '<p>Шість неоподатковуваних мінімумів доходів громадян, встановлених на день реєстрації.</p>\r\n', '<p>---</p>\r\n', '<p>20 днів</p>\r\n', '<p>Порушення встановленого порядку реєстрації.</p>\r\n', '<ol>\r\n	<li>Державна реєстрація змін і доповнень до договору (контракту) про спільну інвестиційну діяльність за участю іноземного інвестора;</li>\r\n	<li>Відмова в наданні адміністративної послуги.</li>\r\n</ol>\r\n', '<p>Адміністративна послуга вважається надана з моменту отримання її через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(64, 'видача дублікату картки державної реєстрації договору (контракту) про спільну інвестиційну діяльність за участю іноземного інвестора', 1, 5, '<ol>\r\n	<li>Стаття 24 Закону України &laquo;Про режим іноземного інвестування&raquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 30.01.1997 №112 &quot;Про затвердження Положення про порядок державної реєстрації договорів (контрактів) про спільну інвестиційну діяльність за участю іноземного інвестора&quot;.</li>\r\n	<li>Наказ Міністерства зовнішніх економічних зв&#39;язків і торгівлі України від 20.02.1997 р. №125 України &laquo;Про заходи МЗЕЗторгу щодо забезпечення виконання Постанови КМУ від 30.01.1997 р. № 112&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&#39;єкт зовнішньоекономічної діяльності України - учасник договору (контракту), якому доручено ведення спільних справ учасників, або уповноважена ним особа подає документи до Центру надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Опубліковану в офіційній пресі об&#39;яву про визнання недійсною втраченої картки державної реєстрації договору (контракту).</li>\r\n	<li>Документ, що засвідчує сплату збору за видачу картки і дубліката картки державної реєстрації договору (контракту).&nbsp;</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 30.01.1997 №112 &quot;Про затвердження Положення про порядок державної реєстрації договорів (контрактів) про спільну інвестиційну діяльність за участю іноземного інвестора&quot;.</p>\r\n', '<p>2,4 неоподатковуваних мінімумів доходів громадян, встановлених на день видачі дублікату картки державної реєстрації договору (контракту).</p>\r\n', '<p>Розміщені на інтернет-сторінці</p>\r\n\r\n<p>www.ved.odessa.gov.ua</p>\r\n', '<p>5 днів</p>\r\n', '<p>Порушення встановленого порядку видачі дублікату.</p>\r\n', '<ol>\r\n	<li>Видача дублікату картки державної реєстрації договору (контракту).</li>\r\n	<li>Відмова в наданні адміністративної послуги.</li>\r\n</ol>\r\n', '<p>Адміністративна послуга вважається надана з моменту отримання її через Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(65, 'Ліцензування діяльності з торгівлі пестицидами та агрохімікатами (тільки регуляторами росту рослин)', 1, 11, '<ol>\r\n	<li>Закон України &laquo;Про ліцензування певних видів господарської діяльності&raquo;&nbsp;від 1 червня 2000 року №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 14 листопада 2000 року №1698 &laquo;Про затвердження переліку органів ліцензування&raquo;;</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження переліку документів, які додаються до заяви про видачу ліцензії для окремого виду господарської діяльності&rdquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 29 листопада 2000 року №1755 &laquo;Про строк дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&raquo;.</li>\r\n	<li>Наказ Міністерства аграрної політики та продовольства України від 17 липня 2013 року №439 &laquo;Про затвердження Ліцензійних умов провадження господарської діяльності з торгівлі пестицидами та агрохімікатами (тільки регуляторами росту рослин&raquo;.</li>\r\n	<li>Розпорядження обласної державної адміністрації від 20.12.2012 року №1398/А-2012 &laquo;Про ліцензування окремих видів господарської діяльності&raquo;</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт господарювання звертається до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява про видачу ліцензії встановленого зразка;</li>\r\n	<li>Відомості за підписом заявника - суб&#39;єкта господарювання (за формою, встановленою ліцензійними умовами) про наявність власних або орендованих складських і торгових приміщень, матеріально-технічної бази та їх відповідність встановленим вимогам;</li>\r\n	<li>Копії допусків (посвідчень) працівників на право роботи з пестицидами та агрохімікатами (тільки регуляторами росту рослин);</li>\r\n	<li>Гарантійний лист про утилізацію токсичних відходів, які виникають у процесі здійснення торгівлі.<em>&nbsp; &nbsp;</em></li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000 року №1755 &laquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&raquo; (зі змінами згідно Постанови КМУ України від 20 жовтня 2011 року №1059).</p>\r\n', '<p>Одна мінімальна заробітна плата виходячи з її розміру, що діє на дату прийняття органом ліцензування рішення про видачу ліцензії:</p>\r\n\r\n<p>з 1 січня 2014р. &ndash; 1218 грн., з 1 липня -1250 грн., 1 жовтня 2014р. &ndash; 1301 грн.<br />\r\n&nbsp;</p>\r\n', '<p>Одержувач: <strong>ГУДКСУ в Одеській області</strong></p>\r\n\r\n<p>Банк одержувача: <strong>ГУДКСУ в Одеській області</strong></p>\r\n\r\n<p>ЄДРПОУ (код): 37607526</p>\r\n\r\n<p>Розрахунковий рахунок: <strong>31413511700001</strong></p>\r\n\r\n<p>МФО (код банку): <strong>828011</strong></p>\r\n\r\n<p>Код платежу: <strong>22010200</strong></p>\r\n\r\n<p>Призначення платежу: <strong>плата за видачу ліцензії</strong></p>\r\n', '<p><strong>Рішення про видачу або про відмову у видачі ліцензії приймається у строк не пізніше ніж 10 робочих днів з дати надходження заяви про видачу ліцензії та документів, що додаються до заяви.</strong></p>\r\n\r\n<p>Оформлення ліцензії здійснюється не пізніше ніж за три робочі дні з дня надходження документа, що підтверджує внесення плати за видачу ліцензії.</p>\r\n', '<ol>\r\n	<li>Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>&nbsp;Документи оформлені з порушенням вимог статті 10 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;&nbsp;від 1 червня 2000 року №1775-ІІІ.</li>\r\n</ol>\r\n', '<p>Видається ліцензія на торгівлю пестицидами та агрохімікатами (тільки регуляторами росту рослин).</p>\r\n', '<p>Повідомлення про прийняття рішення про видачу ліцензії або про відмову видачі ліцензії надсилається (видається) заявникові в письмовій формі особисто або поштою. Ліцензія видається особисто ліцензіату.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(66, 'Видача дублікату ліцензії на торгівлю пестицидами та агрохімікатами (тільки регуляторами росту рослин)', 1, 11, '<ol>\r\n	<li>Закон України &laquo;Про ліцензування певних видів господарської діяльності&raquo;&nbsp;від 1 червня 2000 року №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 14 листопада 2000 року №1698 &laquo;Про затвердження переліку органів ліцензування&raquo;;</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження переліку документів, які додаються до заяви про видачу ліцензії для окремого виду господарської діяльності&rdquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 29 листопада 2000 року №1755 &laquo;Про строк дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&raquo;.</li>\r\n	<li>Наказ Міністерства аграрної політики та продовольства України від 17 липня 2013 року №439 &laquo;Про затвердження Ліцензійних умов провадження господарської діяльності з торгівлі пестицидами та агрохімікатами (тільки регуляторами росту рослин&raquo;.</li>\r\n	<li>Розпорядження обласної державної адміністрації від 20.12.2012 року №1398/А-2012 &laquo;Про ліцензування окремих видів господарської діяльності&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт господарювання звертається до центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<p>У разі втрати ліцензії ліцензіат зобов&rsquo;язаний звернутися до органу ліцензування із заявою про видачу дубліката ліцензії, до якої додається документ, що засвідчує внесення плати за видачу дубліката ліцензії.</p>\r\n\r\n<p>Якщо бланк ліцензії непридатний для користування внаслідок його пошкодження, ліцензіат подає слідуючи документи:</p>\r\n\r\n<ul>\r\n	<li>заява про видачу дубліката ліцензії встановленого зразка;</li>\r\n	<li>непридатна для користування ліцензія;</li>\r\n	<li>документ, що підтверджує внесення плати за видачу дубліката ліцензії.</li>\r\n</ul>\r\n\r\n<p>&nbsp;</p>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000 року №1755 &laquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&raquo; (зі змінами згідно Постанови КМУ України від 20 жовтня 2011 року №1059).</p>\r\n', '<p>За видачу дубліката ліцензії справляється плата в розмірі п&rsquo;яти неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p>Одержувач: <strong>ГУДКСУ в Одеській області</strong></p>\r\n\r\n<p>Банк одержувача: <strong>ГУДКСУ в Одеській області</strong></p>\r\n\r\n<p>ЄДРПОУ (код): 37607526</p>\r\n\r\n<p>Розрахунковий рахунок: <strong>31413511700001</strong></p>\r\n\r\n<p>МФО (код банку): <strong>828011</strong></p>\r\n\r\n<p>Код платежу: <strong>22010200</strong></p>\r\n\r\n<p>Призначення платежу: <strong>плата за видачу ліцензії</strong></p>\r\n', '<p>Орган ліцензування зобов&rsquo;язаний протягом трьох робочих днів з дати одержання заяви про видачу дубліката ліцензії видати заявникові дублікат ліцензії замість втраченої або пошкодженої.</p>\r\n', '<ol>\r\n	<li><em>Заява подана (підписана) особою, яка не має на це повноважень;</em></li>\r\n	<li><em>&nbsp;Документи оформлені з порушенням вимог статті 10 </em><em>Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;&nbsp;від 1 червня 2000 року №1775-ІІІ.</em></li>\r\n</ol>\r\n', '<p>Видача дубліката ліцензії на торгівлю пестицидами та агрохімікатами (тільки регуляторами росту рослин).</p>\r\n', '<p>Повідомлення про видачу дубліката ліцензії надсилається (видається) заявникові в письмовій формі особисто або поштою. Дублікат ліцензії видається особисто ліцензіату.&nbsp;</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(67, 'Переоформлення ліцензії на торгівлю пестицидами та агрохімікатами (тільки регуляторами росту рослин)', 1, 11, '<ol>\r\n	<li>Закон України &laquo;Про ліцензування певних видів господарської діяльності&raquo;&nbsp;від 1 червня 2000 року №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 14 листопада 2000 року №1698 &laquo;Про затвердження переліку органів ліцензування&raquo;;</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження переліку документів, які додаються до заяви про видачу ліцензії для окремого виду господарської діяльності&rdquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 29 листопада 2000 року №1755 &laquo;Про строк дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт господарювання звертається до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Ліцензіат подає до органу ліцензування заяву про переоформлення ліцензії разом з ліцензією, що підлягає переоформленню, та відповідними документами або їх нотаріально засвідченими копіями, які підтверджують зазначені зміни.</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000 року №1755 &laquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&raquo; (зі змінами згідно Постанови КМУ України від 20 жовтня 2011 року №1059).</p>\r\n', '<p>За переоформлення ліцензії справляється плата в розмірі п&rsquo;яти неоподаткованих мінімумів доходів громадян.</p>\r\n', '<p><em>Одержувач: <strong>ГУДКСУ в Одеській області</strong></em></p>\r\n\r\n<p><em>Банк одержувача: <strong>ГУДКСУ в Одеській області</strong></em></p>\r\n\r\n<p><em>ЄДРПОУ (код): 37607526</em></p>\r\n\r\n<p><em>Розрахунковий рахунок: <strong>31413511700001</strong> </em></p>\r\n\r\n<p><em>МФО (код банку): <strong>828011</strong></em></p>\r\n\r\n<p><em>Код платежу: <strong>22010200</strong></em></p>\r\n\r\n<p><em>Призначення платежу: <strong>плата за видачу ліцензії.</strong></em></p>\r\n', '<p>Орган ліцензування протягом трьох робочих днів з дати надходження заяви про переоформлення ліцензії та документів, що додаються до неї, зобов&rsquo;язаний видати переоформлену на новому бланку ліцензію з урахуванням змін, зазначених у заяві про переоформлення ліцензії.</p>\r\n\r\n<p>У разі переоформлення ліцензії у зв&rsquo;язку із змінами, пов&rsquo;язаними з провадженням ліцензіатом певного виду господарської діяльності, якщо ця зміна пов&rsquo;язана з намірами ліцензіата розширити свою діяльність, ліцензія переоформляється в порядку і в строки, передбачені для видачі ліцензії.</p>\r\n', '<ol>\r\n	<li>&nbsp;Заява подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>&nbsp;Документи оформлені з порушенням вимог статті 10 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;&nbsp;від 1 червня 2000 року №1775-ІІІ.</li>\r\n</ol>\r\n', '<p>Видається переоформлена ліцензія на торгівлю пестицидами та агрохімікатами (тільки регуляторами росту рослин).</p>\r\n', '<p>Повідомлення про прийняття рішення щодо переоформлення ліцензії або про відмову у переоформленні ліцензії надсилається (видається) заявникові в письмовій формі особисто або поштою. Переоформлена ліцензія видається особисто ліцензіату.<em>&nbsp;</em></p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(68, 'Видача копії ліцензії на торгівлю пестицидами та агрохімікатами (тільки регуляторами росту рослин)', 1, 11, '<ol>\r\n	<li>Закон України &laquo;Про ліцензування певних видів господарської діяльності&raquo;&nbsp;від 1 червня 2000 року №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 14 листопада 2000 року №1698 &laquo;Про затвердження переліку органів ліцензування&raquo;;</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження переліку документів, які додаються до заяви про видачу ліцензії для окремого виду господарської діяльності&rdquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 29 листопада 2000 року №1755 &laquo;Про строк дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт господарювання звертається до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява про видачу копії ліцензії встановленого зразка;</li>\r\n	<li>Відомості за підписом заявника - суб&#39;єкта господарювання (за формою, встановленою ліцензійними умовами) про наявність власних або орендованих складських і торгових приміщень, матеріально-технічної бази та їх відповідність встановленим вимогам.</li>\r\n	<li>Копії допусків (посвідчень) працівників на право роботи з пестицидами та агрохімікатами (тільки регуляторами росту рослин).</li>\r\n	<li>Гарантійний лист про утилізацію токсичних відходів, які виникають у процесі здійснення торгівлі.</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000 року №1755 &laquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&raquo; (зі змінами згідно Постанови КМУ України від 20 жовтня 2011 року №1059).</p>\r\n', '<p>За видачу копії ліцензії справляється плата в розмірі одного неоподаткованого мінімуму доходів громадян.</p>\r\n', '<p>Одержувач: <strong>ГУДКСУ в Одеській області</strong></p>\r\n\r\n<p>Банк одержувача: <strong>ГУДКСУ в Одеській області</strong></p>\r\n\r\n<p>ЄДРПОУ (код): 37607526</p>\r\n\r\n<p>Розрахунковий рахунок: <strong>31413511700001</strong></p>\r\n\r\n<p>МФО (код банку): <strong>828011</strong></p>\r\n\r\n<p>Код платежу: <strong>22010200</strong></p>\r\n\r\n<p>Призначення платежу: <strong>плата за видачу ліцензії</strong></p>\r\n', '<ul>\r\n	<li>Рішення про видачу або про відмову у видачі копії ліцензії приймається у строк не пізніше ніж 10 робочих днів з дати надходження заяви про видачу копії ліцензії та документів, що додаються до заяви.</li>\r\n	<li>Оформлення копії ліцензії здійснюється не пізніше ніж за три робочі дні з дня надходження документа, що підтверджує внесення плати за видачу копії &nbsp;ліцензії.</li>\r\n</ul>\r\n', '<ol>\r\n	<li><em>Заява подана (підписана) особою, яка не має на це повноважень;</em></li>\r\n	<li><em>Документи оформлені з порушенням вимог статті 10 </em><em>Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;&nbsp;від 1 червня 2000 року №1775-ІІІ.</em></li>\r\n</ol>\r\n', '<p>Видається копія ліцензії на торгівлю пестицидами та агрохімікатами (тільки регуляторами росту рослин).</p>\r\n', '<p>Повідомлення про прийняття рішення про видачу копії ліцензії або про відмову видачі копії ліцензії надсилається (видається) заявникові в письмовій формі особисто або поштою. Копія ліцензії видається особисто ліцензіату.&nbsp;</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`, `ff_link`) VALUES
(69, 'Анулювання ліцензії на діяльність з торгівлі пестицидами та агрохімікатами (тільки регуляторами росту рослин)', 1, 11, '<ol>\r\n	<li>Закон України &laquo;Про ліцензування певних видів господарської діяльності&raquo;&nbsp;від 1 червня 2000 року №1775-ІІІ.</li>\r\n	<li>Постанова Кабінету Міністрів України від 14 листопада 2000 року №1698 &laquo;Про затвердження переліку органів ліцензування&raquo;;</li>\r\n	<li>Постанова Кабінету Міністрів України від 4 липня 2001р. №756 &ldquo;Про затвердження переліку документів, які додаються до заяви про видачу ліцензії для окремого виду господарської діяльності&rdquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 29 листопада 2000 року №1755 &laquo;Про строк дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт господарювання звертається до Центру надання адміністративних послуг Одеської міської ради.</p>\r\n', '<p>Заява ліцензіата про анулювання ліцензії.</p>\r\n', 0, '', '', '', '<p>Рішення про анулювання ліцензії приймається протягом десяти робочих днів з дати встановлення підстав для анулювання ліцензії.</p>\r\n', '<p>&nbsp; &nbsp;&nbsp;Заява подана (підписана) особою, яка не має на це повноважень.</p>\r\n\r\n<p>&nbsp;&nbsp;&nbsp;</p>\r\n', '<p>Анулювання ліцензії.</p>\r\n', '<p>Повідомлення про прийняття рішення про анулювання ліцензії надсилається (видається) заявникові із зазначенням підстав анулювання не пізніше трьох робочих днів з дати його прийняття.&nbsp;</p>\r\n', 'так', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(70, 'Внесення суб''єкта видавничої справи до Державного реєстру  видавців, виготівників і розповсюджувачів видавничої продукції', 1, 12, '<ol>\r\n	<li>Розділ 2 Закону України &laquo;Про видавничу справу&raquo;</li>\r\n	<li>Постанова Кабінету Міністрів України від 28.09.1998 №1540 &laquo;Про Державний реєстр видавців, виготівників і розповсюджувачів видавничої продукції&raquo;.</li>\r\n	<li>Наказ Державного комітету телебачення та радіомовлення України від 23.03.2011 №64.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт видавничої справи (заявник) подає пакет документів до Центру надання адміністративних послуг.</p>\r\n', '<p>До заяви про внесення суб&#39;єкта видавничої справи (заявника) до Державного реєстру додаються:</p>\r\n\r\n<p>1. Витяг з Єдиного&nbsp; державного реєстру юридичних осіб та фізичних&nbsp; осіб-підприємців &ndash; суб&rsquo;єкта підприємницької діяльності;</p>\r\n\r\n<p>2. Нотаріально засвідчені копії установчих документів (статут, положення, якими передбачено провадження видавничої діяльності, виготовлення та розповсюдження видавничої продукції, установчий договір);</p>\r\n\r\n<p>3. Передбачувані дані про річний обсяг випуску, виготовлення та розповсюдження видавничої продукції, зокрема для:</p>\r\n\r\n<p>- видавців - фізичні особи - суб&#39;єкти підприємницької діяльності, обсяг випуску видавничої продукції яких становить до 5 назв на рік;</p>\r\n\r\n<p>- виготівників видавничої продукції &ndash; підприємства, установи і організації, фізичні особи &ndash; суб&#39;єкти підприємницької діяльності, які випускають видавничу продукцію на суму до 500 тис. гривень на рік (за цінами, що склалися на час внесення до Державного реєстру);</p>\r\n\r\n<p>- розповсюджувачів видавничої продукції - підприємства і організації, які не мають мережі книгорозповсюдження; фізичні особи - суб&#39;єкти підприємницької діяльності;</p>\r\n\r\n<p>4. Видавнича діяльність - навести перелік або вказати кількість і тематику неперіодичних видань, що готуються до випуску;</p>\r\n\r\n<p>5. Виготовлення видавничої продукції &ndash; вказати, яку видавничу продукцію планується тиражувати на власному обладнанні (свої видання та (або) замовлення інших видавців) і на яку суму;</p>\r\n\r\n<p>6. Розповсюдження видавничої продукції - назвати видавців, неперіодичні видання яких планується розповсюджувати.</p>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 28.09.1998 №1540 &laquo;Про Державний реєстр видавців, виготівників і розповсюджувачів видавничої продукції&raquo;.</p>\r\n', '<p>Реєстраційний збір за внесення суб&#39;єкта видавничої справи до Державного реєстру складає 25 неоподатковуваних мінімумів доходів громадян.</p>\r\n', '<p>Розрахунковий рахунок №33213852700009 в ГУ ДСКУ в м. Одеса.</p>\r\n\r\n<p>Код ЄДРПОУ: 38016923.</p>\r\n\r\n<p>МФО 828011.</p>\r\n\r\n<p>Банк одержувача: ГУ ДКСУ в Одеській області.&nbsp;</p>\r\n\r\n<p>Призначення платежу: в дохід обласного бюджету за внесення до&nbsp; Державного реєстру, код бюджетної кваліфікації 22010900, суб&#39;єкта видавничої справи.</p>\r\n', '<p>27-30 днів&nbsp;</p>\r\n', '<ol>\r\n	<li>Назва, програмні цілі, напрями діяльності суб&#39;єкта видавничої справи суперечать законодавству України;</li>\r\n	<li>Заява про внесення до Державного реєстру подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Суб&#39;єкт видавничої справи з такою назвою вже внесений до Державного реєстру;</li>\r\n	<li>Заяву про внесення до Державного реєстру подано після набрання законної сили рішенням суду про припинення діяльності цього суб&#39;єкта видавничої справи.</li>\r\n</ol>\r\n', '<p>Видача Свідоцтва про внесення суб&#39;єкта видавничої справи до Державного реєстру видавців, виготівників і розповсюджувачів видавничої продукції.</p>\r\n', '<p>Повідомлення про прийняття рішення про видачу Свідоцтва або про відмову видачі Свідоцтва надсилається (видається) суб&#39;єкту видавничої справи в письмовій формі особисто або поштою.</p>\r\n\r\n<p>Свідоцтво про внесення суб&#39;єкта видавничої справи до Державного реєстру видавців, виготівників і розповсюджувачів видавничої продукції суб&#39;єкт видавничої справи отримує особисто.&nbsp;</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(71, 'Видача дубліката Свідоцтва про внесення до Державного реєстру  видавців, виготівників і розповсюджувачів видавничої продукції ', 12, 12, '<p>Розділ 2 Закону України &laquo;Про видавничу справу&raquo;</p>\r\n\r\n<p>Постанова Кабінету Міністрів України від 28.09.1998 №1540 &laquo;Про Державний реєстр видавців, виготівників і розповсюджувачів видавничої продукції&raquo;.</p>\r\n\r\n<p>Наказ Державного комітету телебачення та радіомовлення України від 23.03.2011 №64.</p>\r\n', '<p>Заява про видачу дубліката Свідоцтва про внесення суб&#39;єкта видавничої справи до Державного реєстру, що підписана уповноваженою на те особою.</p>\r\n', '<p>Суб&rsquo;єкт видавничої справи (заявник) подає пакет документів до Центру надання адміністративних послуг&nbsp;особисто або через особу.</p>\r\n', '<p>До заяви про внесення суб&#39;єкта видавничої справи (заявника) до Державного реєстру додається витяг з Єдиного&nbsp; державного реєстру юридичних осіб та фізичних&nbsp; осіб-підприємців &ndash; суб&rsquo;єкта підприємницької діяльності та документи, що засвідчують уповноважену на те особу.</p>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 28.09.1998 №1540 &laquo;Про Державний реєстр видавців, виготівників і розповсюджувачів видавничої продукції&raquo;.</p>\r\n', '<p>Реєстраційний збір за видачу дубліката Свідоцтва складає 20 відсотків суми реєстраційного збору.</p>\r\n', '<p>Розрахунковий рахунок №33213852700009 в ГУ ДСКУ в м. Одеса.</p>\r\n\r\n<p>Код ЄДРПОУ: 38016923.</p>\r\n\r\n<p>МФО 828011.</p>\r\n\r\n<p>Банк одержувача: ГУ ДКСУ в Одеській області.&nbsp;</p>\r\n\r\n<p>Призначення платежу: в дохід обласного бюджету за внесення до&nbsp; Державного реєстру, код бюджетної кваліфікації 22010900, суб&#39;єкта видавничої справи.</p>\r\n', '<p>12-15 днів&nbsp;</p>\r\n', '<p>Одержувачеві адміністративної послуги може бути відмовлено у разі, коли:</p>\r\n\r\n<ol>\r\n	<li>Назва, програмні цілі, напрями діяльності суб&#39;єкта видавничої справи суперечать законодавству України;</li>\r\n	<li>Заява про видачу дубліката Свідоцтва подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Заяву про видачу дубліката Свідоцтва подано після набрання законної сили рішенням суду про припинення діяльності цього суб&#39;єкта видавничої справи.</li>\r\n</ol>\r\n', '<p>Видача дубліката Свідоцтва про внесення суб&#39;єкта видавничої справи до Державного реєстру видавців, виготівників і розповсюджувачів видавничої продукції.</p>\r\n', '<p>Повідомлення про прийняття рішення про видачу дубліката Свідоцтва або про відмову видачі дубліката Свідоцтва надсилається (видається) суб&#39;єкту видавничої справи в письмовій формі особисто або поштою.</p>\r\n\r\n<p>Свідоцтво про внесення суб&#39;єкта видавничої справи до Державного реєстру видавців, виготівників і розповсюджувачів видавничої продукції суб&#39;єкт видавничої справи отримує особисто.&nbsp;</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(72, 'Внесення змін до Державного реєстру  видавців, виготівників і розповсюджувачів видавничої продукції ', 1, 12, '<ol>\r\n	<li>Розділ 2 Закону України &laquo;Про видавничу справу&raquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 28.09.1998 №1540 &laquo;Про Державний реєстр видавців, виготівників і розповсюджувачів видавничої продукції&raquo;.</li>\r\n	<li>Наказ Державного комітету телебачення та радіомовлення України від 23.03.2011 №64.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Суб&rsquo;єкт видавничої справи (заявник) подає пакет документів до Центру надання адміністративних послуг особисто або через особу.</p>\r\n', '<p>До заяви про внесення змін до Державного реєстру додаються документи в яких внесено зміни:</p>\r\n\r\n<p>1. витяг з Єдиного державного реєстру юридичних осіб та фізичних осіб-підприємців &ndash; суб&rsquo;єкта підприємницької діяльності;</p>\r\n\r\n<p>2. копія попереднього свідоцтва про внесення до Державного реєстру;</p>\r\n\r\n<p>3. передбачувані дані про річний обсяг випуску, виготовлення, розповсюдження видавничої продукції:</p>\r\n\r\n<p>- видавнича діяльність (навести перелік&nbsp; або вказати кількість&nbsp; і тематику <em>неперіодичних&nbsp; видань, </em>&nbsp;що готуються до випуску);</p>\r\n\r\n<p>- виготовлення видавничої продукції (вказати, яку видавничу продукцію планується тиражувати на <em>власному</em> <em>обладнанні</em> /свої видання та/або&nbsp; замовлення інших видавців/ і на яку суму);</p>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 28.09.1998 №1540 &laquo;Про Державний реєстр видавців, виготівників і розповсюджувачів видавничої продукції&raquo;.</p>\r\n', '<p>Реєстраційний збір за видачу нового Свідоцтва (при внесенні змін до Державного реєстру) складає - 50 відсотків суми реєстраційного збору.&nbsp;</p>\r\n', '<p>Розрахунковий рахунок №33213852700009 в ГУ ДСКУ в м. Одеса.</p>\r\n\r\n<p>Код ЄДРПОУ: 38016923.</p>\r\n\r\n<p>МФО 828011.</p>\r\n\r\n<p>Банк одержувача: ГУ ДКСУ в Одеській області.&nbsp;</p>\r\n\r\n<p>Призначення платежу: в дохід обласного бюджету за внесення до&nbsp; Державного реєстру, код бюджетної кваліфікації 22010900, суб&#39;єкта видавничої справи.</p>\r\n', '<p><em>27-30 днів&nbsp;</em></p>\r\n', '<p>Одержувачеві адміністративної послуги може бути відмовлено у разі, коли:</p>\r\n\r\n<ol>\r\n	<li>Назва, програмні цілі, напрями діяльності суб&#39;єкта видавничої справи суперечать законодавству України;</li>\r\n	<li>Заява про внесення змін до Державного реєстру подана (підписана) особою, яка не має на це повноважень;</li>\r\n	<li>Суб&#39;єкт видавничої справи з такою назвою вже внесений до Державного реєстру;</li>\r\n	<li>Заяву про внесення змін до Державного реєстру подано після набрання законної сили рішенням суду про припинення діяльності цього суб&#39;єкта видавничої справи.</li>\r\n</ol>\r\n', '<p>Видача Свідоцтва про внесення суб&#39;єкта видавничої справи до Державного реєстру видавців, виготівників і розповсюджувачів видавничої продукції.</p>\r\n', '<p>Повідомлення про прийняття рішення про видачу Свідоцтва або про відмову видачі Свідоцтва надсилається (видається) суб&#39;єкту видавничої справи в письмовій формі особисто або поштою.</p>\r\n\r\n<p>Свідоцтво про внесення суб&#39;єкта видавничої справи до Державного реєстру видавців, виготівників і розповсюджувачів видавничої продукції суб&#39;єкт видавничої справи отримує особисто.&nbsp;</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(73, 'Виключення суб''єкта видавничої справи з Державного реєстру  видавців, виготівників і розповсюджувачів видавничої продукції ', 1, 12, '<ol>\r\n	<li>Розділ 2 Закону України &laquo;Про видавничу справу&raquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 28.09.1998 №1540 &laquo;Про Державний реєстр видавців, виготівників і розповсюджувачів видавничої продукції&raquo;.</li>\r\n	<li>Наказ Державного комітету телебачення та радіомовлення України від 23.03.2011 №64.</li>\r\n</ol>\r\n', '<p>Заява про виключення суб&#39;єкта видавничої справи з Державного реєстру.</p>\r\n', '<p>Суб&rsquo;єкт видавничої справи подає документи до Центру надання адміністративних послуг&nbsp;особисто або через особу.</p>\r\n', '<p>До заяви надається Свідоцтво про внесення суб&#39;єкта видавничої справи до Державного реєстру видавців, виготівників і розповсюджувачів видавничої продукції.</p>\r\n', 0, '', '', '', '<p><em>7-9 днів&nbsp;</em></p>\r\n', '<p>--</p>\r\n', '<p>Анулювання Свідоцтва та виключення з Державного реєстру видавців, виготівників і розповсюджувачів видавничої продукції.</p>\r\n', '<p>Повідомлення про прийняття рішення про виключення з Державного реєстру видавців, виготівників і розповсюджувачів видавничої продукції в письмовій формі особисто або поштою.&nbsp;</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(74, 'Дозвіл на відновлення земляних робіт', 1, 13, '<ol>\r\n	<li>п. 15 ч. 1 ст. 6 Закон України &laquo;Про охорону культурної спадщини&raquo;</li>\r\n	<li>Постанова Кабінету Міністрів України від 21.05.2009 №526 &laquo;Про заходи щодо упорядкування видачі документів дозвільного характеру у сфері господарської діяльності&raquo;.</li>\r\n	<li>Розпорядження Одеської обласної державної адміністрації від 21.05.2012 №473/А-2012 &laquo;Про надання адміністративних послуг&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява на ім&rsquo;я начальника управління охорони об&rsquo;єктів культурної спадщини Одеської обласної державної адміністрації.</li>\r\n	<li>Копія виписки або витягу з Єдиного державного реєстру&nbsp; юридичних осіб та фізичних осіб - підприємців.</li>\r\n	<li>Звіт про археологічне дослідження пам&rsquo;ятки в межах земельної ділянки.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Рішення про надання дозволу приймається протягом одного місяця з дня подання відповідних документів.</p>\r\n', '<ol>\r\n	<li>Надана недостовірна або застаріла інформація та вразі невідповідності поданих документів вичерпному переліку документів, зазначених в п.11;</li>\r\n	<li>Негативний висновок за результатами проведених експертиз та обстежень або інших наукових і технічних оцінок, необхідних для надання адміністративної послуги;</li>\r\n</ol>\r\n\r\n<p>Інші підстави для відмови у видачі документа дозвільного характеру, встановлені законом України.</p>\r\n', '<p>Письмовий дозвіл або лист з обґрунтуванням причин відмови.</p>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(75, 'Видача дубліката дозволу на відновлення земляних робіт', 1, 13, '<ol>\r\n	<li>п. 15 ч. 1 ст. 6 Закон України &laquo;Про охорону культурної спадщини&raquo;.</li>\r\n	<li>п. 9 ст. 4-1 Закону України &laquo;Про дозвільну систему у сфері господарської діяльності&raquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 21.05.2009 №526 &laquo;Про заходи щодо упорядкування видачі документів дозвільного характеру у сфері господарської діяльності&raquo;.</li>\r\n	<li>Розпорядження Одеської обласної державної адміністрації від 21.05.2012 №473/А-2012 &laquo;Про надання адміністративних послуг&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява на ім&rsquo;я начальника управління охорони об&rsquo;єктів культурної спадщини Одеської обласної державної адміністрації.</li>\r\n	<li>Копія виписки або витягу з Єдиного державного реєстру&nbsp; юридичних осіб та фізичних осіб - підприємців.</li>\r\n	<li>У разі пошкодження документа: оригінал непридатного для використання дозволу на відновлення земляних робіт.</li>\r\n	<li>У разі втрати документа: лист-обґрунтування щодо підстав та дати втрати оригіналу дозволу на відновлення земляних робіт.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Рішення про надання дубліката дозволу приймається протягом 2-х&nbsp; робочих днів з дня надходження пакета документів.</p>\r\n', '<p>Надана недостовірна або застаріла інформація та вразі невідповідності поданих документів вичерпному переліку документів.</p>\r\n', '<ol>\r\n	<li>Дублікат дозволу на відновлення земляних робіт;</li>\r\n	<li>Лист з обґрунтуванням причин відмови у видачі дублікату дозволу на відновлення земельних робіт.</li>\r\n</ol>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(76, 'Переоформлення дозволу на відновлення земляних робіт', 1, 13, '<ol>\r\n	<li>п. 15 ч. 1 ст. 6 Закон України &laquo;Про охорону культурної спадщини&raquo;;</li>\r\n	<li>п. 8 ст. 4-1 Закону України &laquo;Про дозвільну систему у сфері господарської діяльності&raquo;</li>\r\n	<li>Постанова Кабінету Міністрів України від 21.05.2009 №526 &laquo;Про заходи щодо упорядкування видачі документів дозвільного характеру у сфері господарської діяльності&raquo;</li>\r\n	<li>Розпорядження Одеської обласної державної адміністрації від 21.05.2012 №473/А-2012 &laquo;Про надання адміністративних послуг&raquo;</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява на ім&rsquo;я начальника управління охорони об&rsquo;єктів культурної спадщини Одеської обласної державної адміністрації.&nbsp;</li>\r\n	<li>Копія виписки або витягу з Єдиного державного реєстру&nbsp; юридичних осіб та фізичних осіб - підприємців.</li>\r\n	<li>Оригінал дозволу на відновлення земляних робіт, що підлягає переоформленню.</li>\r\n</ol>\r\n\r\n<p>Відповідно посвідчені копії документів, що стали підставою для переоформлення документа.</p>\r\n\r\n<p><strong>Підстави для переоформлення документа:</strong>&nbsp;зміна найменування або місцезнаходження суб&rsquo;єкта господарювання та інші підстави, передбачені чинним законодавством.&nbsp;Заяву про переоформлення дозволу на відновлення земляних робіт суб&#39;єкт господарювання зобов&#39;язаний подати&nbsp;<strong>протягом п&#39;яти робочих днів</strong>&nbsp;з дня настання відповідних підстав.</p>\r\n', 0, '', '', '', '<p>Рішення про переоформлення дозволу приймається протягом 2-х&nbsp; робочих днів з дня надходження пакета документів.</p>\r\n', '<p>Надана недостовірна або застаріла інформація та вразі невідповідності поданих документів вичерпному переліку документів.</p>\r\n', '<ol>\r\n	<li>Переоформлений дозвіл на відновлення земляних робіт.</li>\r\n	<li>Лист з обґрунтуванням причин відмови&nbsp;переоформлення дозволу на відновлення земляних робіт.</li>\r\n</ol>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(77, 'Анулювання дозволу на відновлення земляних робіт', 1, 13, '<ol>\r\n	<li>п. 15 ч. 1 ст. 6 Закон України &laquo;Про охорону культурної спадщини&raquo;;</li>\r\n	<li>п. 8 ст. 4-1 Закону України &laquo;Про дозвільну систему у сфері господарської діяльності&raquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 21.05.2009 №526 &laquo;Про заходи щодо упорядкування видачі документів дозвільного характеру у сфері господарської діяльності&raquo;.</li>\r\n	<li>Розпорядження Одеської обласної державної адміністрації від 21.05.2012 №473/А-2012 &laquo;Про надання адміністративних послуг&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява на ім&rsquo;я начальника управління охорони об&rsquo;єктів культурної спадщини Одеської обласної державної адміністрації.&nbsp;</li>\r\n	<li>Копія виписки або витягу з Єдиного державного реєстру&nbsp; юридичних осіб та фізичних осіб - підприємців.</li>\r\n	<li>Оригінал дозволу на відновлення земляних робіт, що підлягає анулюванню.</li>\r\n</ol>\r\n\r\n<p>Відповідно посвідчені копії документів, що стали підставою для анулювання документа</p>\r\n', 0, '', '', '', '<p>Рішення про анулювання дозволу приймається протягом десяти робочих днів з дня одержання заяви та відповідних документів .</p>\r\n', '<p>Надана недостовірна або застаріла інформація та вразі невідповідності поданих документів вичерпному переліку документів.</p>\r\n', '<ol>\r\n	<li>Лист із повідомленням щодо анулювання дозволу на відновлення земляних робіт;</li>\r\n	<li>Лист з обґрунтуванням причин відмови щодо анулювання дозволу на відновлення земляних робіт.</li>\r\n</ol>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(78, 'Погодження розміщення реклами  на пам’ятках місцевого значення, в межах зон охорони цих пам’яток', 1, 13, '<ol>\r\n	<li>п. 15 ч. 1 ст. 6 Закон України &laquo;Про охорону культурної спадщини&raquo;;</li>\r\n	<li>ч.1 ст. 16 Закону України &laquo;Про рекламу&raquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 21.05.2009 № 526 &laquo;Про заходи щодо упорядкування видачі документів дозвільного характеру&raquo;.</li>\r\n	<li>Розпорядження Одеської обласної державної адміністрації від 21.05.2012 №&nbsp;473/А-2012 &laquo;Про надання адміністративних послуг&raquo;.</li>\r\n	<li>п. 29 Додатку № 8 до Порядку взаємодії представників місцевих дозвільних органів, які здійснюють прийом суб&#39;єктів господарювання в&nbsp; одному приміщенні, затверджений рішенням Одеської міської ради від 10.07.2008 №2882-V (зі змінами).</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява на ім&rsquo;я начальника управління охорони об&rsquo;єктів культурної спадщини Одеської обласної державної адміністрації.</li>\r\n	<li>Документи, що посвідчують особу заявника та реєструє заяву і документи.</li>\r\n	<li>Копія виписки або витягу з Єдиного державного реєстру&nbsp; юридичних осіб та фізичних осіб - підприємців.</li>\r\n	<li>Акт обстеження щодо можливості розміщення рекламного засобу на пам&rsquo;ятці місцевого значення, складений представниками управління охорони об&#39;єктів культурної спадщини облдержадміністрації не пізніше ніж за 1 місяць до звернення щодо надання послуги.</li>\r\n	<li>Лист управління реклами Одеської міської ради щодо можливого розміщення реклами.</li>\r\n	<li>Технічна документація щодо розміщення реклами.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Рішення про надання погодження приймається протягом тридцяти календарних днів з дня одержання документації щодо розміщення реклами.</p>\r\n', '<ol>\r\n	<li>Надана недостовірна або застаріла інформація та вразі невідповідності поданих документів вичерпному переліку документів, зазначених в п.11;</li>\r\n	<li>Невідповідність технічної документації вимогам законів та прийнятих відповідно до них нормативно-правових актів;</li>\r\n	<li>Незадовільний стан фасаду, на якому розміщується об&rsquo;єкт;&nbsp;</li>\r\n	<li>Інші підстави для відмови у видачі документа дозвільного характеру, встановлені законом України.</li>\r\n</ol>\r\n', '<p>Лист-погодження, підпис начальника та печатка управління на технічній документації щодо розміщення зовнішньої реклами або лист з обґрунтуванням причин відмови.</p>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(79, 'Декларація відповідності матеріально-технічної бази суб’єкта господарювання вимогам законодавства з питань пожежної безпеки', 1, 14, '<ol>\r\n	<li>Кодекс цивільного захисту України № 5403-VI 02.10.2012 року.</li>\r\n	<li>Закон України № 5203-VI &nbsp;06.09.2012 &laquo;Про адміністративні послуги&raquo;.</li>\r\n	<li>Закон України № 2806-VI від 06.09.2005 &laquo;Про дозвільну систему у&nbsp; сфері господарської діяльності&raquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 27.01.2012 №&nbsp;77&nbsp;&laquo;Деякі питання застосування принципу мовчазної згоди&raquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 05.06.2013 №440&nbsp;&laquo;Про затвердження Порядку подання і реєстрації декларації відповідності матеріально-технічної бази суб&rsquo;єкта господарювання вимогам законодавства з питань пожежної безпеки&raquo;.</li>\r\n</ol>\r\n\r\n<p>&nbsp;</p>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг.</p>\r\n', '<p>Декларація відповідності матеріально-технічної бази суб&rsquo;єкта господарювання вимогам законодавства з питань пожежної безпеки (2 прим.)</p>\r\n', 0, '', '', '', '<p>10 днів</p>\r\n', '<p>Декларацію подано чи оформлено з порушенням вимог, визначених постановою Кабінету Міністрів України від 05.06.2013р. №&nbsp;440&nbsp;&laquo;Про затвердження порядку подання і реєстрації декларації відповідності матеріально-технічної бази суб&rsquo;єкта господарювання вимогам законодавства з питань пожежної безпеки&raquo;.</p>\r\n', '<p>Реєстрація декларації відповідності матеріально-технічної бази суб&rsquo;єкта&nbsp;господарювання вимогам законодавства з питань пожежної безпеки.</p>\r\n', '<p>Через центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL),
(80, 'Видача фізичним особам висновку державної санітарно-епідеміологічної експертизи діючих об’єктів', 1, 15, '<ol>\r\n	<li>Закон України &bdquo;Про дозвільну систему у сфері господарської діяльності&raquo;;</li>\r\n	<li>Закон України &laquo;Про перелік документів дозвільного характеру у сфері господарської діяльності&raquo;;</li>\r\n	<li>Закон України &laquo;Про забезпечення санітарного та епідемічного благополуччя населення&raquo;;</li>\r\n	<li>Закон України &laquo;Про відходи&raquo;;</li>\r\n	<li>Закон України &laquo;Про охорону атмосферного повітря&raquo;;</li>\r\n	<li>Закон України &bdquo;Про питну воду та питне водопостачання&rdquo;;</li>\r\n	<li>Закон України &bdquo;Про регулювання містобудівної діяльності&rdquo;;</li>\r\n	<li>Закон України &bdquo;Про адміністративні послуги&rdquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Через центр надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява на ім&rsquo;я головного державного санітарного лікаря відповідної адміністративної території за формою, затвердженою наказом МОЗ України від 09.10.2000 №247, зареєстрованим в Мін&rsquo;юсті України 10.01.2001 за №4/5195 &laquo;Про затвердження тимчасового порядку проведення державної санітарно-епідеміологічної експертизи&raquo; (із змінами).</li>\r\n	<li>Документ власника, що декларує відповідність об&rdquo;єкта експертизи визначеним в Україні вимогам щодо їх безпеки для здоров&#39;я людини ( Свідоцтво на право власності на об&rsquo;єкт експертизи або Акт державної приймальної комісії про прийняття в експлуатацію закінченого будівництвом об&rsquo;єкта або будівельний паспорт).</li>\r\n	<li>Акт санітарно-епідеміологічного обстеження обєкта експертизи ( за формою 315/о, (Наказ МОЗ України від 11.07.2000р. № 160 &bdquo;Про затвердження форм облікової статистичної документації, що використовується в санітарно-епідеміологічних закладах&rdquo;).</li>\r\n</ol>\r\n', 1, '<ol>\r\n	<li>Закон України &laquo;Про забезпечення санітарного та епдемічного благополуччя населення&raquo; (ст. 35);</li>\r\n	<li>Розпорядження Кабінету Міністрів України від 26.10.2011 № 1067-р &laquo;Про затвердження переліку платних адміністративних послуг, які надаються Державною санітарно-епідеміологічною службою та установами і закладами, що належать до сфери її управління&raquo;;</li>\r\n	<li>Постанова Кабінету Міністрів України від 27.08.2003 № 1351 &laquo;Про затвердження тарифів (прейскурантів) на роботи і послуги, що виконуються і надаються за плату установами та закладами державної санітарно-епідеміологічної служби&raquo;.</li>\r\n</ol>\r\n', '<p>200 грн. без ПДВ&nbsp;</p>\r\n', '<p>Постачальник: Головне управління Державної санітарно-епідеміологічної служби в Одеській області</p>\r\n\r\n<p>Адреса: м. Одеса, вул. Старопортофранківська, 8.</p>\r\n\r\n<p>Р/рах. №31114028700008</p>\r\n\r\n<p>МФО 828011 в ГУДКСУ у Одеській області</p>\r\n\r\n<p>Код 37607526</p>\r\n\r\n<p>Код платежу 22012500</p>\r\n\r\n<p>Плата за надання інших адміністративних послуг</p>\r\n', '<p>10 днів</p>\r\n', '<ol>\r\n	<li>Подання неповного пакета документів, необхідних для одержання документа дозвільного характеру, згідно із встановленим вичерпним переліком;</li>\r\n	<li>Виявлення в документах, поданих фізичною особою, недостовірних відомостей;</li>\r\n	<li>Негативний висновок за результатами проведених експертиз та обстежень.</li>\r\n	<li>Інші підстави, які передбачені чинним законодавством.</li>\r\n</ol>\r\n', '<p>Видача фізичним особам висновку державної санітарно-епідемологічної експертизи діючих об&rsquo;єктів або відмова у видачі фізичним особам висновку&nbsp;державної санітарно-епідемологічної експертизи діючих об&rsquo;єктів.</p>\r\n', '<p>Через центр надання адміністративних послуг.</p>\r\n', 'ні', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`, `ff_link`) VALUES
(81, 'Реєстрація декларації про початок виконання підготовчих робіт\r\n', 1, 16, '<p>Закон України &laquo;Про регулювання містобудівної діяльності&raquo; стаття 35.</p>\r\n', '<p>Початок виконання підготовчих робіт щодо будівництва об&rsquo;єкта&nbsp;</p>\r\n', '<p>Подається особисто замовником (його уповноваженою особою) до Центру надання адміністративних послуг.</p>\r\n', '<p>Два примірники декларації про початок виконання підготовчих робіт відповідно до вимог статті 35 Закону України &laquo;Про регулювання містобудівної діяльності&raquo; за формою встановленого зразка.</p>\r\n', 0, '', '', '', '<p>П&#39;ять робочих днів з дня надходження декларації.</p>\r\n', '<p>Подання чи оформлення декларації з порушенням установлених вимог.</p>\r\n', '<p>Реєстрація декларації про початок виконання підготовчих робіт.</p>\r\n', '<p>Зареєстрована декларація направляється замовнику засобами поштового зв`язку.</p>\r\n\r\n<p>Інформація щодо зареєстрованої декларації про початок виконання підготовчих робіт розміщується на офіційному сайті Держархбудінспекції України у розділі &laquo;Дозвільні документи&raquo; у єдиному реєстрі отриманих повідомлень про початок виконання підготовчих і будівельних робіт, зареєстрованих декларацій про початок виконання підготовчих і будівельних робіт, виданих дозволів на виконання будівельних робіт, зареєстрованих декларацій про готовність об&rsquo;єкта&nbsp; до експлуатації та виданих сертифікатів, відмов у реєстрації таких декларацій та у видачі таких дозволів і сертифікатів.</p>\r\n', 'так', 0, '', 0, '', '', '', '', NULL),
(82, 'Внесення змін до декларації про початок виконання підготовчих робіт\r\n', 1, 16, '<ol>\r\n	<li>Закон України &laquo;Про регулювання містобудівної діяльності&raquo; частина перша статті 39-1.</li>\r\n	<li>Пункт 14 Порядку виконання підготовчих робіт, затвердженого постановою Кабінету Міністрів України від 13.04.2011 № 466 &laquo;Деякі питання виконання підготовчих та будівельних робіт&raquo;, п. 49 Розпорядження Кабінету Міністрів України від 16 травня 2014 №523-р.</li>\r\n</ol>\r\n', '<p>Виявлення замовником технічної помилки в зареєстрованій декларації про початок виконання підготовчих робіт або отримання відомостей про виявлення у такій декларації недостовірних даних.</p>\r\n', '<p>Подається особисто замовником (його уповноваженою особою) до Центру надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява згідно статті 39-1 Закону України &laquo;Про регулювання містобудівної діяльності&raquo; та пункту 14 Порядку виконання підготовчих робіт, затвердженого постановою Кабінету Міністрів України від 13.04.2011 № 466 &laquo;Деякі питання виконання підготовчих та будівельних робіт&raquo; за формою встановленого зразка.</li>\r\n	<li>Один примірник зареєстрованої декларації, в якій виявлено технічну помилку або недостовірні дані.</li>\r\n	<li>Два примірники декларації, в якій враховані зміни згідно статті 39-1 Закону України &laquo;Про регулювання містобудівної діяльності&raquo; та пункту 14 Порядку виконання підготовчих робіт, затвердженого постановою Кабінету Міністрів України від 13.04.2011 № 466 &laquo;Деякі питання виконання підготовчих та будівельних робіт&raquo; за формою встановленого зразка.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>П&rsquo;ять робочих днів з дня надходження декларації.</p>\r\n', '<p>Подання чи оформлення декларації з порушенням установлених вимог.</p>\r\n', '<ol>\r\n	<li>Реєстрація декларації про початок виконання підготовчих робіт, в якій враховано зміни.</li>\r\n	<li>Внесення достовірних даних до єдиного&nbsp; реєстру&nbsp; отриманих повідомлень&nbsp; про початок&nbsp; виконання&nbsp; підготовчих&nbsp; будівельних робіт, зареєстрованих декларацій&nbsp; про початок виконання підготовчих і будівельних робіт, виданих&nbsp; дозволів&nbsp; на&nbsp; виконання будівельних робіт, зареєстрованих декларацій&nbsp; про&nbsp; готовність&nbsp; об&rsquo;єкта&nbsp; до&nbsp; експлуатації&nbsp; та виданих сертифікатів,&nbsp; повернених&nbsp; декларацій&nbsp; та&nbsp; відмов&nbsp; у&nbsp; видачі таких дозволів&nbsp; і&nbsp; сертифікатів.</li>\r\n</ol>\r\n', '<p>Зареєстрована декларація направляється замовнику засобами поштового зв`язку.</p>\r\n\r\n<p>Інформація щодо зареєстрованої декларації про початок виконання підготовчих робіт розміщується на офіційному сайті Держархбудінспекції України у розділі &laquo;Дозвільні документи&raquo; у єдиному реєстрі отриманих повідомлень про початок виконання підготовчих і будівельних робіт, зареєстрованих декларацій про початок виконання підготовчих і будівельних робіт, виданих дозволів на виконання будівельних робіт, зареєстрованих декларацій про готовність об&rsquo;єкта&nbsp; до експлуатації та виданих сертифікатів, відмов у реєстрації таких декларацій та у видачі таких дозволів і сертифікатів.</p>\r\n', 'так', 0, '', 0, '', '', '', '', NULL),
(83, 'Реєстрація декларації про початок виконання будівельних робіт\r\n', 1, 16, '<p>Закон України &laquo;Про регулювання містобудівної діяльності&raquo; частина перша &nbsp;&nbsp;статті 36.</p>\r\n', '<p>Початок виконання будівельних робіт на об&rsquo;єкті будівництва,&nbsp; що належить&nbsp; до &nbsp;I-III&nbsp; категорій&nbsp; складності.</p>\r\n', '<p>Подається особисто замовником (його уповноваженою особою) або надсилається рекомендованим листом з описом вкладення.</p>\r\n', '<p>Два примірники декларації про початок виконання будівельних робіт відповідно до вимог статті 36 Закону України &laquo;Про регулювання містобудівної діяльності&raquo; за формою встановленого зразка.</p>\r\n', 0, '', '', '', '<p>П&rsquo;ять робочих днів з дня надходження декларації.</p>\r\n', '<p>Подання чи оформлення декларації з порушенням установлених вимог.</p>\r\n', '<p>Реєстрація декларації про початок виконання будівельних робіт.</p>\r\n', '<p>Зареєстрована декларація направляється замовнику засобами поштового зв`язку.</p>\r\n\r\n<p>Інформація щодо зареєстрованої декларації про початок виконання будівельних робіт розміщується на офіційному сайті Держархбудінспекції України у розділі &laquo;Дозвільні документи&raquo; у єдиному реєстрі отриманих повідомлень про початок виконання підготовчих і будівельних робіт, зареєстрованих декларацій про початок виконання підготовчих і будівельних робіт, виданих дозволів на виконання будівельних робіт, зареєстрованих декларацій про готовність об&rsquo;єкта&nbsp; до експлуатації та виданих сертифікатів, відмов у реєстрації таких декларацій та у видачі таких дозволів і сертифікатів.</p>\r\n', 'так', 0, '', 0, '', '', '', '', NULL),
(84, 'Внесення змін до декларації про початок виконання будівельних робіт\r\n', 1, 16, '<ol>\r\n	<li>Закон України &laquo;Про регулювання містобудівної діяльності&raquo; частина перша статті 39-1.</li>\r\n	<li>Пункт 14 Порядку виконання будівельних робіт, затвердженого постановою Кабінету Міністрів України від 13.04.2011 № 466 &laquo;Деякі питання виконання підготовчих та будівельних робіт&raquo;, п. 50 Розпорядження Кабінету Міністрів України від 16 травня 2014 №523-р.</li>\r\n</ol>\r\n', '<p>Виявлення замовником технічної помилки в зареєстрованій декларації про початок виконання будівельних робіт або отримання відомостей про виявлення у такій декларації недостовірних даних.</p>\r\n', '<p>Подається особисто замовником до Центру надання адміністративних послуг або надсилається рекомендованим листом з описом вкладення.</p>\r\n', '<ol>\r\n	<li>Заява згідно статті 39-1 Закону України &laquo;Про регулювання містобудівної діяльності&raquo; та пункту 14 Порядку виконання підготовчих робіт, затвердженого постановою Кабінету Міністрів України від 13.04.2011 № 466 &laquo;Деякі питання виконання підготовчих та будівельних робіт&raquo; за формою встановленого зразка;</li>\r\n	<li>Один примірник зареєстрованої декларації, в якій виявлено технічну помилку або недостовірні дані;</li>\r\n	<li>Два примірники декларації, в якій враховані зміни згідно статті 39-1 Закону України &laquo;Про регулювання містобудівної діяльності&raquo; та пункту 14 Порядку виконання підготовчих робіт, затвердженого постановою Кабінету Міністрів України від 13.04.2011 № 466 &laquo;Деякі питання виконання підготовчих та будівельних робіт&raquo; за формою встановленого зразка.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>П&rsquo;ять робочих днів з дня надходження декларації.</p>\r\n', '<p>Подання чи оформлення декларації з порушенням установлених вимог.</p>\r\n', '<ol>\r\n	<li>Реєстрація декларації про початок виконання будівельних робіт, в якій враховано зміни;</li>\r\n	<li>Внесення достовірних даних до єдиного&nbsp; реєстру&nbsp; отриманих повідомлень&nbsp; про початок&nbsp; виконання&nbsp; підготовчих&nbsp; будівельних робіт, зареєстрованих декларацій&nbsp; про початок виконання підготовчих і будівельних робіт, виданих&nbsp; дозволів&nbsp; на&nbsp; виконання будівельних робіт, зареєстрованих декларацій&nbsp; про&nbsp; готовність&nbsp; об&rsquo;єкта&nbsp; до&nbsp; експлуатації&nbsp; та виданих сертифікатів,&nbsp; повернених&nbsp; декларацій&nbsp; та&nbsp; відмов&nbsp; у&nbsp; видачі таких дозволів&nbsp; і&nbsp; сертифікатів.</li>\r\n</ol>\r\n', '<p>Зареєстрована декларація направляється замовнику засобами поштового зв`язку;</p>\r\n\r\n<p>Інформація щодо зареєстрованої декларації про початок виконання будівельних робіт розміщується на офіційному сайті Держархбудінспекції України у розділі &laquo;Дозвільні документи&raquo; в єдиному реєстрі&nbsp; отриманих повідомлень&nbsp; про початок&nbsp; виконання&nbsp; підготовчих&nbsp; будівельних робіт, зареєстрованих декларацій&nbsp; про початок виконання підготовчих і будівельних робіт, виданих&nbsp; дозволів&nbsp; на&nbsp; виконання будівельних робіт, зареєстрованих декларацій&nbsp; про&nbsp; готовність&nbsp; об&rsquo;єкта&nbsp; до&nbsp; експлуатації&nbsp; та виданих сертифікатів,&nbsp; повернених&nbsp; декларацій&nbsp; та&nbsp; відмов&nbsp; у&nbsp; видачі таких дозволів&nbsp; і&nbsp; сертифікатів</p>\r\n', 'так', 0, '', 0, '', '', '', '', NULL),
(85, 'Реєстрація декларації про готовність об`єкта до експлуатації\r\n', 1, 16, '<ol>\r\n	<li>Закон України &laquo;Про регулювання містобудівної діяльності&raquo; частина перша &nbsp;статті 39.</li>\r\n	<li>Пункт 2&nbsp; Порядку прийняття в експлуатацію закінчених будівництвом об&rsquo;єктів, затвердженого постановою Кабінету Міністрів України від 13.04.2011 № 461 &laquo;Питання прийняття в експлуатацію закінчених будівництвом об&rsquo;єктів&raquo;.</li>\r\n</ol>\r\n', '<p>Експлуатація закінченого будівництвом об`єкта, що належить до&nbsp;І &ndash; ІІІ категорії складності.</p>\r\n', '<p>Подається особисто замовником (його уповноваженою особою) до Центру надання адміністративних послуг&nbsp;або надсилається рекомендованим листом з описом вкладення.</p>\r\n', '<p>Два примірники декларації про готовність об`єкта до експлуатації відповідно до вимог частини першої статті 39 Закону України &laquo;Про регулювання містобудівної діяльності&raquo; за формою встановленого зразка.</p>\r\n', 0, '', '', '', '<p>Десять робочих днів з дня надходження декларації.</p>\r\n', '<p>Подання чи оформлення декларації з порушенням установлених вимог.</p>\r\n', '<p>Реєстрація декларації про готовність об`єкта до експлуатації.</p>\r\n', '<p>Зареєстрована декларація направляється замовнику засобами поштового зв`язку.</p>\r\n\r\n<p>Інформація щодо зареєстрованої декларації про готовність об`єкта до експлуатації розміщується на офіційному сайті Держархбудінспекції України у розділі &laquo;Дозвільні документи&raquo; в єдиному реєстрі отриманих повідомлень про початок виконання підготовчих і будівельних робіт, зареєстрованих декларацій про початок виконання підготовчих і будівельних робіт, виданих дозволів на виконання будівельних робіт, зареєстрованих декларацій про готовність об&rsquo;єкта&nbsp; до експлуатації та виданих сертифікатів, відмов у реєстрації таких декларацій та у видачі таких дозволів і сертифікатів.</p>\r\n', 'так', 0, '', 0, '', '', '', '', NULL),
(86, 'Внесення змін до декларації про готовність об`єкта до експлуатації\r\n', 1, 16, '<ol>\r\n	<li>Закон України &laquo;Про регулювання містобудівної діяльності&raquo; частина перша &nbsp;статті 39-1.</li>\r\n	<li>Пункт 2&nbsp; Порядку прийняття в експлуатацію закінчених будівництвом об&rsquo;єктів, затвердженого постановою Кабінету Міністрів України від 13.04.2011 № 461 &laquo;Питання прийняття в експлуатацію закінчених будівництвом об&rsquo;єктів&raquo;, п. 51 Розпорядження Кабінету Міністрів України від 16 травня 2014 №523-р.</li>\r\n</ol>\r\n', '<p>Виявлення замовником технічної помилки у зареєстрованій декларації про готовність об`єкта до експлуатації або отримання відомостей про виявлення у такій декларації недостовірних даних.</p>\r\n', '<p>Подається особисто замовником до Центру надання адміністративних послуг&nbsp;або надсилається рекомендованим листом з описом вкладення.</p>\r\n', '<ol>\r\n	<li>Заява згідно статті 39-1 Закону України &laquo;Про регулювання містобудівної діяльності&raquo; та пункту 28 Порядку прийняття в експлуатацію закінчених будівництвом об&rsquo;єктів, затвердженого постановою Кабінету Міністрів України від 13.04.2011 № 461 &laquo;Питання прийняття в експлуатацію закінчених будівництвом об&rsquo;єктів&raquo; за формою встановленого зразка;</li>\r\n	<li>Один примірник зареєстрованої декларації, в якій виявлено технічну помилку або недостовірні дані;</li>\r\n	<li>Два примірники декларації, в якій враховані зміни згідно статті 39-1 Закону України &laquo;Про регулювання містобудівної діяльності&raquo; та пункту 28 Порядку прийняття в експлуатацію закінчених будівництвом об&rsquo;єктів, затвердженого постановою Кабінету Міністрів України від 13.04.2011 № 461 &laquo;Питання прийняття в експлуатацію закінчених будівництвом об&rsquo;єктів&raquo; за формою встановленого зразка.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Десять робочих днів з дня надходження декларації.</p>\r\n', '<p>Подання чи оформлення декларації з порушенням установлених вимог.</p>\r\n', '<ol>\r\n	<li>Реєстрація декларації про готовність об`єкта до експлуатації, в якій враховано зміни.</li>\r\n	<li>Внесення достовірних даних до єдиного&nbsp; реєстру&nbsp; отриманих повідомлень&nbsp; про початок&nbsp; виконання&nbsp; підготовчих&nbsp; будівельних робіт, зареєстрованих декларацій&nbsp; про початок виконання підготовчих і будівельних робіт, виданих&nbsp; дозволів&nbsp; на&nbsp; виконання будівельних робіт, зареєстрованих декларацій&nbsp; про&nbsp; готовність&nbsp; об&rsquo;єкта&nbsp; до&nbsp; експлуатації&nbsp; та виданих сертифікатів,&nbsp; повернених&nbsp; декларацій&nbsp; та&nbsp; відмов&nbsp; у&nbsp; видачі таких дозволів&nbsp; і&nbsp; сертифікатів.</li>\r\n</ol>\r\n', '<p>Зареєстрована декларація направляється замовнику засобами поштового зв`язку;</p>\r\n\r\n<p>Інформація щодо зареєстрованої декларації про готовність об`єкта до експлуатації розміщується на офіційному сайті Держархбудінспекції України у розділі &laquo;Дозвільні документи&raquo; в єдиному реєстрі&nbsp; отриманих повідомлень&nbsp; про початок&nbsp; виконання&nbsp; підготовчих&nbsp; будівельних робіт, зареєстрованих декларацій&nbsp; про початок виконання підготовчих і будівельних робіт, виданих&nbsp; дозволів&nbsp; на&nbsp; виконання будівельних робіт, зареєстрованих декларацій&nbsp; про&nbsp; готовність&nbsp; об&rsquo;єкта&nbsp; до&nbsp; експлуатації&nbsp; та виданих сертифікатів,&nbsp; повернених&nbsp; декларацій&nbsp; та&nbsp; відмов&nbsp; у&nbsp; видачі таких дозволів&nbsp; і сертифікатів.</p>\r\n', 'так', 0, '', 0, '', '', '', '', NULL),
(87, 'Видача сертифікату у разі прийняття в експлуатацію закінченого будівництвом об`єкта', 1, 16, '<ol>\r\n	<li>Закон України &laquo;Про регулювання містобудівної діяльності&raquo; частина друга статті 39.</li>\r\n	<li>Пункт 22 Порядку &nbsp;прийняття в експлуатацію закінчених будівництвом об&rsquo;єктів, затвердженого постановою Кабінету Міністрів України від 13.04.2011 № 461 &laquo;Питання прийняття в експлуатацію закінчених будівництвом об&rsquo;єктів&raquo;.</li>\r\n</ol>\r\n', '<p>Експлуатація закінченого будівництвом об&rsquo;єкта IV &ndash; V категорії складності.</p>\r\n', '<p>Подається особисто замовником (його уповноваженою особою) до Центру надання адміністративних послуг&nbsp;або надсилається рекомендованим листом з описом вкладення.</p>\r\n', '<ol>\r\n	<li>Заява за формою встановленого зразка.</li>\r\n	<li>Акт готовності об&rsquo;єкта до експлуатації відповідно до вимог частини другої статті 39 Закону України &laquo;Про регулювання містобудівної діяльності&raquo; за формою встановленого зразка.</li>\r\n</ol>\r\n', 1, '<p>Відповідно до Порядку внесення плати за видачу сертифіката, який видається у разі прийняття в експлуатацію закінченого будівництвом об&rsquo;єкта, та її розмір, затвердженого постановою Кабінету Міністрів від 13.04.2011 № 461 &laquo;Питання прийняття в експлуатацію закінчених будівництвом об&rsquo;єктів&raquo;.</p>\r\n', '<p>Для закінчених будівництвом об`єктів, що належать:</p>\r\n\r\n<p>до об&rsquo;єктів IV категорії складності &ndash; 4,6 мінімальної заробітної плати;</p>\r\n\r\n<p>до об&rsquo;єктів V категорії складності &ndash; 5,2 мінімальної заробітної плати.</p>\r\n', '<p>Отримувач: УДКСУ у Дніпровському р-ні м. Києва</p>\r\n\r\n<p>Код 38012871</p>\r\n\r\n<p>ГУДКСУ України у м. Києві</p>\r\n\r\n<p>МФО 820019; р/р 31115028700005</p>\r\n\r\n<p>За сертифікат згідно з постановою КМУ від 13.04.2011 № 461</p>\r\n', '<p>Десять робочих днів з дня реєстрації заяви.</p>\r\n', '<ol>\r\n	<li>Неподання документів, необхідних для прийняття рішення про видачу сертифіката.</li>\r\n	<li>Виявлення недостовірних відомостей у поданих документах.</li>\r\n	<li>Невідповідність об&rsquo;єкта проектній документації та вимогам державних будівельних норм, стандартів і правил.</li>\r\n</ol>\r\n', '<p>Видача сертифіката.</p>\r\n', '<p>Сертифікат направляється замовнику засобами поштового зв`язку. Інформація щодо виданого сертифіката&nbsp; розміщується на офіційному сайті Держархбудінспекції України у розділі &laquo;Дозвільні документи&raquo; у єдиному реєстрі отриманих повідомлень про початок виконання підготовчих і будівельних робіт, зареєстрованих декларацій про початок виконання підготовчих і будівельних робіт, виданих дозволів на виконання будівельних робіт, зареєстрованих декларацій про готовність об&rsquo;єкта&nbsp; до експлуатації та виданих сертифікатів, відмов у реєстрації таких декларацій та у видачі таких дозволів і сертифікатів.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(88, 'Державна реєстрація фізичної особи, яка має намір стати підприємцем\r\n', 1, 17, '<ol>\r\n	<li>Закон України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; (зі&nbsp; змінами&nbsp; та&nbsp; доповненнями)&nbsp;&nbsp;(статті 8, 10, 42, 43, 44).</li>\r\n	<li>Порядок подання та обігу електронних документів державному реєстратору, затверджений наказом Міністерства юстиції України від 19.08.2011 № 2010/5, зареєстрований в Міністерстві юстиції України 23.08.2011 за № 997/19735.</li>\r\n	<li>Наказ Міністерства юстиції України від 14.10.2011&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; № 3178/5 &quot;Про затвердження форм реєстраційних карток&quot;, зареєстрований в Міністерстві юстиції України 19.10.2011 за № 1207/19945.</li>\r\n	<li>Наказ Міністерства юстиції України від 17.04.2013&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; № 730/5 &quot;Про затвердження форм заяв та повідомлень, надання (надсилання) яких встановлено Законом України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;, зареєстрований в Міністерстві юстиції України 24.04.2013 за № 671/23203.</li>\r\n</ol>\r\n', '<p>Звернення фізичної особи, яка має намір стати підприємцем.</p>\r\n', '<ol>\r\n	<li>Особисто, поштовим відправленням з описом вкладення або через уповноважену особу &ndash; у разі подання документів для проведення державної реєстрації фізичної особи, яка має намір стати підприємцем та має реєстраційний номер облікової картки платника податків.</li>\r\n	<li>Особисто &ndash; у разі подання документів для проведення державної реєстрації фізичної особи, яка через свої релігійні або інші переконання відмовилася від прийняття реєстраційного номера облікової картки платника податків, офіційно повідомила про це відповідні державні органи, має запис в електронному безконтактному носії паспорта громадянина України та намір стати підприємцем.</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Заповнена реєстраційна картка на проведення державної реєстрації фізичної особи &ndash; підприємця (форма 10).</li>\r\n	<li>Копія документа, що засвідчує реєстрацію у Державному реєстрі фізичних осіб &ndash; платників податків.</li>\r\n	<li>Документ, що підтверджує внесення реєстраційного збору&nbsp; за проведення державної реєстрації фізичної особи &ndash; підприємця (копія квитанції, виданої банком, або копія платіжного доручення з відміткою банку).</li>\r\n	<li>Нотаріально посвідчена письмова згода батьків (усиновлювачів) або піклувальника, або органу опіки та піклування, якщо заявником є фізична особа, яка досягла шістнадцяти років і має бажання займатися підприємницькою діяльністю.</li>\r\n	<li>Якщо документи для проведення державної реєстрації подаються заявником особисто, державному реєстратору додатково пред&#39;являється паспорт громадянина України або паспортний документ іноземця.&nbsp;</li>\r\n</ol>\r\n', 1, '<p>???</p>\r\n', '<p>За проведення державної реєстрації фізичної особи &ndash; підприємця справляється реєстраційний збір у розмірі двох неоподатковуваних мінімумів доходів громадян&nbsp;(34 грн.)</p>\r\n', '<p>???</p>\r\n', '<p>Строк державної реєстрації фізичної особи &ndash; підприємця не повинен перевищувати два робочих дні з дати надходження документів для проведення державної реєстрації фізичної особи &ndash; підприємця.</p>\r\n', '<ol>\r\n	<li>Документи подані за неналежним місцем проведення державної реєстрації фізичної особи &ndash; підприємця.</li>\r\n	<li>Документи не відповідають вимогам частин першої та другої статті 8 та частини п&#39;ятої статті 10 Закону України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n	<li>Документи подані не у повному обсязі.&nbsp;</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</li>\r\n	<li>Повідомлення про залишення документів без розгляду.</li>\r\n	<li>Повідомлення про відмову у проведенні державної реєстрації.</li>\r\n</ol>\r\n', '<p>Виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців, повідомлення про залишення документів без розгляду, повідомлення про відмову у проведенні державної реєстрації та документи, що подавалися для проведення державної реєстрації фізичної особи &ndash; підприємця, відповідно до опису, видаються (надсилаються поштовим відправленням з описом вкладення) державним реєстратором заявнику.</p>\r\n\r\n<p>&nbsp;</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(89, 'Державна реєстрація юридичної особи\r\n', 1, 17, '<ol>\r\n	<li>Закон України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; (стаття 8, 10, 24, 24-1, 25, 27, 32, 35).</li>\r\n	<li>Постанова Кабінету Міністрів України від 19.12.2012&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; № 1212 &quot;Про затвердження Порядку ведення Реєстру громадських об&rsquo;єднань та обміну відомостями між зазначеним Реєстром і Єдиним державним реєстром юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n</ol>\r\n', '<p>Звернення засновника (засновників) новоствореної юридичної особи або уповноваженої ними особи.</p>\r\n', '<ul>\r\n	<li>Засновник (засновники) або уповноважена ними особа повинні (заявник) особисто подати державному реєстратору (надіслати поштовим відправленням з описом вкладення) за місцезнаходженням юридичної особи для проведення державної реєстрації юридичної особи.</li>\r\n	<li>У разі подання документів для проведення державної реєстрації юридичної особи, що створюється шляхом виділу документи подаються засновниками (учасниками) або уповноваженими ними органом чи особою.&nbsp;</li>\r\n</ul>\r\n', '<ol>\r\n	<li>Заповнена реєстраційна картка на проведення державної реєстрації юридичної особи (форма 1 або форма 2).</li>\r\n	<li>Примірник оригіналу (ксерокопія, нотаріально засвідчена копія) рішення засновників або уповноваженого ними органу про створення юридичної особи у випадках, передбачених законом.</li>\r\n	<li>Два примірники установчих документів.</li>\r\n	<li>У разі утворення юридичної особи на підставі модельного статуту в реєстраційній картці на проведення державної реєстрації юридичної особи проставляється відповідна відмітка з посиланням на типовий установчий документ.</li>\r\n	<li>Документ, що засвідчує внесення реєстраційного збору за проведення державної реєстрації юридичної особи.</li>\r\n	<li>Інформація з документами, що підтверджують структуру власності засновників &ndash; юридичних осіб, яка дає змогу встановити фізичних осіб &ndash; власників істотної участі цих юридичних осіб.&nbsp;</li>\r\n</ol>\r\n', 1, '<p>???</p>\r\n', '<p>За проведення державної реєстрації справляється реєстраційний збір у такому розмірі:</p>\r\n\r\n<ul>\r\n	<li>есять неоподатковуваних мінімумів доходів громадян &ndash; за проведення державної реєстрації юридичної особи&nbsp;&nbsp; (170 грн.);</li>\r\n	<li>&nbsp;три неоподатковуваних мінімумів доходів громадян &ndash; за проведення державної реєстрації благодійної організації (51 грн.).</li>\r\n</ul>\r\n\r\n<p>&nbsp;</p>\r\n', '<p>???</p>\r\n', '<p>Строк державної реєстрації юридичної особи не повинен перевищувати три робочих дні з дати надходження документів для проведення державної реєстрації юридичної особи.&nbsp;</p>\r\n', '<ol>\r\n	<li>Документи подані за неналежним місцем проведення державної реєстрації юридичної особи.</li>\r\n	<li>Документи не відповідають вимогам частин першої, другої, четвертої &ndash; сьомої статті 8 та частини п&#39;ятої статті 10 Закону України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n	<li>До державного реєстратора надійшло рішення суду щодо заборони у проведенні реєстраційних дій.&nbsp;</li>\r\n	<li>Документи подані не у повному обсязі.</li>\r\n	<li>Документи подано особою, яка не має на це повноважень.&nbsp;</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців та один примірник оригіналу установчих документів з відміткою державного реєстратора про проведення державної реєстрації юридичної особи.</li>\r\n	<li>Повідомлення про залишення документів без розгляду.</li>\r\n	<li>Повідомлення про відмову у проведенні державної реєстрації юридичної особи.</li>\r\n</ol>\r\n', '<p>Виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців, один примірник оригіналу установчих документів з відміткою державного реєстратора про проведення державної реєстрації юридичної особи, повідомлення про залишення документів, без розгляду, повідомлення про відмову у проведенні державної реєстрації, із зазначенням підстав для такої відмови, та документи, що подавалися для проведення державної реєстрації юридичної особи, відповідно до опису, видаються (надсилаються поштовим відправленням з описом вкладення) державним реєстратором заявнику.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL);
INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`, `ff_link`) VALUES
(90, 'Видача виписки з Єдиного державного реєстру юридичних осіб та фізичних осіб підприємців', 1, 17, '<p>Закон України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; (зі&nbsp; змінами&nbsp; та&nbsp; доповненнями) (статті 8, 20, 21).</p>\r\n', '<p>Запит юридичної особи або фізичної особи &ndash; підприємця</p>\r\n', '<p>Запит про надання виписки з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців подається юридичними або фізичними особами (їх уповноваженими представниками) особисто.</p>\r\n', '<ol>\r\n	<li>Запит про надання виписки з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</li>\r\n	<li>Документ, що підтверджує внесення плати за отримання відповідних відомостей (копія квитанції, виданої банком, або копія платіжного доручення з відміткою банку).</li>\r\n	<li>Документ, що посвідчує особу заявника, відповідно до підпункту 1 пункту 2 Положення про прикордонний режим, затвердженого постановою Кабінету Міністрів України від 27 липня 1998 року № 1147 (із змінами).</li>\r\n	<li>&nbsp;Документ, що підтверджує повноваження уповноваженої особи &ndash; у разі подання запиту уповноваженою особою.</li>\r\n</ol>\r\n', 1, '<p>???</p>\r\n', '<p>За одержання виписки з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців справляється плата в розмірі одного неоподатковуваного мінімуму доходів громадян (17 грн.).</p>\r\n', '<p>???</p>\r\n', '<p>Виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців або письмове повідомлення про відмову у наданні відомостей з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців видається (надсилається поштовим відправленням) протягом двох робочих днів з дати подання запиту про надання виписки з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</p>\r\n', '<ol>\r\n	<li>У Єдиному державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців є запис про відсутність юридичної особи за її місцезнаходженням.</li>\r\n	<li>У Єдиному державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців є запис про відсутність підтвердження відомостей про юридичну особу.</li>\r\n	<li>Запит подано особою, яка не підтвердила на це повноваження.</li>\r\n	<li>У запиті про надання виписки відсутні відомості для&nbsp; критеріїв пошуку відомостей у Єдиному державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців для формування виписки з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</li>\r\n	<li>Запитувачем не подано документ, що підтверджує внесення плати за отримання виписки, крім випадків, встановлених Законом України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;, або плата внесена не в повному обсязі.</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</li>\r\n	<li>Письмове повідомлення про відмову у наданні відомостей з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</li>\r\n</ol>\r\n', '<p>Державний реєстратор надає запитувачу (надсилає поштовим відправленням) виписку або направляє письмове повідомлення про відмову у наданні відомостей з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(91, 'Видача витягу з Єдиного державного реєстру юридичних осіб та фізичних осіб підприємців\r\n', 1, 17, '<p>Закон України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;&nbsp; (зі&nbsp; змінами&nbsp; та&nbsp; доповненнями) (статті 8, 20).</p>\r\n', '<p>Запит про надання витягу з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</p>\r\n', '<p>Особисто або поштовим відправленням з описом вкладення.</p>\r\n', '<ol>\r\n	<li>Запит про надання витягу з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</li>\r\n	<li>Запит про надання витягу з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців заповнюються українською мовою машинодруком або від руки розбірливими друкованими літерами, без виправлень.</li>\r\n	<li>Документ, що підтверджує внесення плати за отримання відповідних відомостей (копія квитанції, виданої банком, або копія платіжного доручення з відміткою банку).</li>\r\n</ol>\r\n', 1, '<p>???</p>\r\n', '<p>Три неоподатковувані мінімуми доходів громадян та за кожен аркуш інформації на бланку встановленого зразка справляється плата у розмірі 20 відсотків одного неоподаткованого мінімуму доходів громадян (51 грн. + 3,4 грн. за кожен аркуш інформації на бланку встановленого зразка).</p>\r\n', '<p>???</p>\r\n', '<p>Строк надання витягу з Єдиного державного реєстру не повинен перевищувати п&#39;яти робочих днів з дати надходження запиту про надання витягу з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</p>\r\n', '<ol>\r\n	<li>У запиті про надання витягу відсутні критерії пошуку відомостей у Єдиному державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців, які були зазначені у запиті про надання витягу на вибір запитувача для його формування.</li>\r\n	<li>Запитувачем не подано документ, що підтверджує внесення плати за отримання витягу, крім випадків, встановлених Законом України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;, або плата внесена не в повному обсязі.</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Витяг з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</li>\r\n	<li>Письмове повідомлення про відмову у наданні відомостей з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</li>\r\n</ol>\r\n', '<p>Державний реєстратор видає витяг з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців особі, яка подала запит, або, у разі проставлення відповідної відмітки у запиті, надсилає її поштовим відправленням.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(92, 'Видача довідки з Єдиного державного реєстру юридичних осіб та фізичних осіб  підприємців.\r\n', 1, 17, '<p>Закон України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; (статті 8, 20).</p>\r\n', '<p>Запит про надання довідки про наявність або відсутність в Єдиному державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців інформації, яка запитується.</p>\r\n', '<p>Особисто або поштовим відправленням з описом вкладення.&nbsp;</p>\r\n', '<ol>\r\n	<li>Запит про надання довідки про наявність або відсутність в Єдиному державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців інформації, яка запитується.</li>\r\n	<li>Запит про надання довідки про наявність або відсутність в Єдиному державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців інформації, яка запитується заповнюються українською мовою машинодруком або від руки розбірливими друкованими літерами, без виправлень.</li>\r\n	<li>Документ, що підтверджує внесення плати за отримання відповідних відомостей (копія квитанції, виданої банком, або копія платіжного доручення з відміткою банку).</li>\r\n</ol>\r\n', 1, '<p>???</p>\r\n', '<p>Один неоподатковуваний мінімум доходів громадян (17 грн.).</p>\r\n', '<p>???</p>\r\n', '<p>Строк надання довідки про наявність або відсутність в Єдиному державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців інформації, яка запитується не повинен перевищувати п&#39;яти робочих днів з дати надходження запиту про надання довідки про наявність або відсутність в Єдиному державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців інформації, яка запитується.</p>\r\n', '<ol>\r\n	<li>У запиті про надання довідки відсутні критерії пошуку відомостей у Єдиному державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців, які були зазначені у запиті про надання довідки про наявність або відсутність в Єдиному державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців інформації, яка запитується.</li>\r\n	<li>Запитувачем не подано документ, що підтверджує внесення плати за отримання довідки, крім випадків, встановлених Законом України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;, або плата внесена не в повному обсязі.</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Довідка про наявність або відсутність в Єдиному державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців інформації, яка запитується.</li>\r\n	<li>Письмове повідомлення про відмову у наданні відомостей з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</li>\r\n</ol>\r\n', '<p>Державний реєстратор видає довідку про наявність або відсутність в Єдиному державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців інформації, яка запитується особі, яка подала запит, або, у разі проставлення відповідної відмітки у запиті, надсилає її поштовим відправленням.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(93, 'Державна реєстрація змін до установчих документів юридичної особи\r\n', 1, 17, '<p>Закон України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; (зі&nbsp; змінами &nbsp;та&nbsp; доповненнями)&nbsp;(статті 8, 10, 29, 30).</p>\r\n', '<p>Звернення юридичної особи у зв&rsquo;язку із прийняттям рішення про внесення змін до установчих&nbsp; документів юридичної особи.</p>\r\n', '<p>Документи подаються (надсилаються поштовим відправленням з описом вкладення) юридичною&nbsp; особою.</p>\r\n', '<ol>\r\n	<li>Заповнена реєстраційна картка на проведення державної реєстрації змін до установчих документів юридичної особи (форма 3).</li>\r\n	<li>Примірник оригіналу (ксерокопія, нотаріально засвідчена копія) рішення про внесення змін до установчих документів. Документ, що підтверджує&nbsp; правомочність прийняття рішення&nbsp; про внесення&nbsp; змін&nbsp; до&nbsp; установчих документів.</li>\r\n	<li>Оригінали установчих документів юридичної особи з відміткою про їх державну реєстрацію з усіма змінами, чинними на дату подачі документів, або копія опублікованого в спеціалізованому друкованому засобі масової інформації повідомлення про втрату всіх або частини зазначених оригіналів установчих документів.</li>\r\n	<li>Два примірники змін до установчих документів юридичної особи у вигляді окремих додатків або два примірники установчих документів у новій редакції.</li>\r\n	<li>Документ, що підтверджує внесення реєстраційного збору за проведення державної реєстрації змін до установчих документів, якщо інше не&nbsp; встановлено Законом України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.&nbsp;</li>\r\n</ol>\r\n', 1, '<p>???</p>\r\n', '<p>Справляється реєстраційний збір у розмірі тридцяти відсотків від реєстраційного збору за проведення державної реєстрації юридичної особи (51 грн.).</p>\r\n\r\n<p>&nbsp;</p>\r\n', '<p>???</p>\r\n', '<p>Строк державної реєстрації змін до установчих документів юридичної особи не повинен перевищувати три робочих дні з дати надходження документів.</p>\r\n', '<ol>\r\n	<li>Документи подані за неналежним місцем проведення державної реєстрації.</li>\r\n	<li>Документи не відповідають вимогам, які встановлені частинами першою, другою, четвертою, п&#39;ятою та сьомою статті 8, частиною п&#39;ятою&nbsp; статті 10 Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n	<li>Документи подані не у повному обсязі.</li>\r\n	<li>Документи подано особою, яка не має на&nbsp; це повноважень.</li>\r\n	<li>До державного реєстратора надійшло рішення суду щодо заборони у&nbsp; проведенні&nbsp; реєстраційних дій.&nbsp;&nbsp;</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Повідомлення про залишення документів без розгляду.</li>\r\n	<li>Повідомлення про відмову в проведенні державної реєстрації змін до установчих документів юридичної особи.</li>\r\n	<li>Один примірник змін до установчих документів юридичної особи у вигляді окремих додатків або один примірник оригіналу установчих документів у новій редакції та один примірник оригіналу установчих документів у старій редакції з відмітками державного реєстратора про проведення державної реєстрації змін до установчих документів.</li>\r\n	<li>Виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб-підприємців<em> &ndash;</em> у разі внесенні змін до установчих документів, які пов&rsquo;язані із зміною відомостей про юридичну особу, які відповідно&nbsp; до&nbsp; Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; зазначаються у виписці з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</li>\r\n</ol>\r\n', '<p>Повідомлення про залишення документів без розгляду/ повідомлення про відмову в проведенні державної реєстрації змін до установчих документів юридичної особи разом з документами, що подавалися для проведення державної змін до установчих документів юридичної особи або один примірник оригіналу установчих документів у старій редакції з відмітками державного реєстратора про проведення державної реєстрації змін до установчих документів та виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб-підприємців (у разі видачі) видаються (надсилаються поштовим відправленням з описом вкладення) державним реєстратором заявнику.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(94, 'Включення до Єдиного державного реєстру юридичних осіб та фізичних осіб-підприємців відомостей про закриття відокремленого підрозділу юридичної особи', 1, 17, '<p>Закон України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; (із&nbsp; змінами&nbsp; та&nbsp; доповненнями) &nbsp;(статті 8, 28).</p>\r\n', '<p>Звернення юридичної особи у зв&rsquo;язку із закриттям відокремленого підрозділу.</p>\r\n', '<p>Документи подаються (надсилаються поштовим відправленням з описом вкладення) виконавчим органом юридичної особи або уповноваженою ним особою.</p>\r\n', '<ol>\r\n	<li>Повідомлення встановленого зразка про закриття відокремленого підрозділу.</li>\r\n	<li>Якщо документи подаються особою, уповноваженою&nbsp;&nbsp; виконавчим органом юридичної особи додатково пред&#39;являються паспорт громадянина України або паспортний документ іноземця та документ, що засвідчує її повноваження.</li>\r\n</ol>\r\n\r\n<p>&nbsp;</p>\r\n', 0, '', '', '', '<p>Включення до Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців відомостей про закриття відокремленого підрозділу юридичної особи здійснюється протягом двох робочих днів з дати надходження документів.</p>\r\n', '<ol>\r\n	<li>Документи подані за неналежним місцем проведення реєстраційних дій.</li>\r\n	<li>Документи не відповідають вимогам, які встановлені частиною першою статті 8 Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Повідомлення про залишення документів без розгляду.</li>\r\n	<li>Виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</li>\r\n</ol>\r\n', '<p>Повідомлення про залишення документів без розгляду разом з документами, що подавалися для включення до Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців відомостей про створення відокремленого підрозділу юридичної особи або виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців видаються (надсилаються поштовим відправленням з описом вкладення) державним реєстратором заявнику.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(95, 'Включення до Єдиного державного реєстру юридичних осіб та фізичних осіб-підприємців відомостей про створення відокремленого підрозділу юридичної особи\r\n', 1, 17, '<p>Закон України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; (зі змінами&nbsp; та&nbsp; доповненнями)&nbsp;(статті 8, 28).</p>\r\n', '<p>Звернення юридичної особи у зв&rsquo;язку із рішенням органу управління юридичної особи про створення відокремленого підрозділу.&nbsp;</p>\r\n', '<p>Документи подаються (надсилаються поштовим відправленням з описом вкладення) виконавчим органом юридичної особи або уповноваженою ним особою.</p>\r\n', '<ol>\r\n	<li>Заповнена реєстраційна картка про створення відокремленого&nbsp; підрозділу (форма 5).</li>\r\n	<li>Рішення органу управління юридичної&nbsp;особи&nbsp; про&nbsp; створення&nbsp; відокремленого&nbsp; підрозділу.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Включення до Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців відомостей про створення відокремленого підрозділу юридичної особи &ndash; протягом двох робочих днів з дати надходження документів.</p>\r\n', '<ol>\r\n	<li>Документи подані за неналежним місцем проведення реєстраційних дій.</li>\r\n	<li>Реєстраційна картка не відповідає вимогам&nbsp; частин&nbsp; першої, другої та сьомої статті 8 Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.&nbsp;</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Повідомлення про залишення документів без розгляду.</li>\r\n	<li>Виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</li>\r\n</ol>\r\n', '<p>Повідомлення про залишення документів без розгляду разом з документами, що подавалися для включення до Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців відомостей про створення відокремленого підрозділу юридичної особи або виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців видаються (надсилаються поштовим відправленням з описом вкладення) державним реєстратором заявнику.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(96, 'Державна реєстрація змін до відомостей про фізичну особу-підприємця, які містяться в Єдиному державному реєстрі юридичних осіб та&nbsp;фізичних осіб-підприємців', 1, 17, '<p>Закон України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; (зі&nbsp; змінами&nbsp; та&nbsp; доповненнями)&nbsp;&nbsp;(статті 8, 10, 43, 44, 45).</p>\r\n', '<p>Звернення фізичної особи &ndash; підприємця.</p>\r\n', '<ol>\r\n	<li>Особисто, поштовим відправленням з описом вкладення або через уповноважену особу &ndash; у разі подання документів фізичної особи &ndash; підприємця, яка має реєстраційний номер облікової картки платника податків.</li>\r\n	<li>Особисто &ndash; у разі подання документів фізичної особи &ndash; підприємця, яка через свої релігійні або інші переконання відмовилася від прийняття реєстраційного номера облікової картки платника податків, офіційно повідомила про це відповідні державні органи, має запис в електронному безконтактному носії паспорта громадянина України та намір стати підприємцем.</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Заповнена реєстраційна картка на проведення державної реєстрації змін до відомостей про фізичну особу &ndash; підприємця (форма 11).</li>\r\n	<li>Документ, що підтверджує сплату реєстраційного збору за державну реєстрацію змін до відомостей про фізичну особу &ndash; підприємця.</li>\r\n	<li>Копія довідки про зміну реєстраційного номера облікової картки платника податків.&nbsp;&nbsp;</li>\r\n</ol>\r\n', 1, '<p>???</p>\r\n', '<p>За проведення державної реєстрації зміни імені або місця проживання фізичної особи &ndash; підприємця справляється реєстраційний збір у розмірі тридцяти відсотків реєстраційного збору, встановленого за проведення державної реєстрації фізичної особи &ndash; підприємця &nbsp;(10,20 грн.).</p>\r\n', '<p>???</p>\r\n', '<p>Строк державної реєстрації змін до відомостей про фізичну особу &ndash; підприємця не повинен перевищувати два робочих дні з дати надходження документів для проведення державної реєстрації фізичної особи &ndash; підприємця.</p>\r\n', '<ol>\r\n	<li>Документи подані за неналежним місцем проведення державної реєстрації змін до відомостей про фізичну особу &ndash; підприємця.</li>\r\n	<li>Документи не відповідають вимогам частин першої та другої статті 8 та частини п&#39;ятої статті 10 Закону України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n	<li>Документи подані не у повному обсязі.</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців.</li>\r\n	<li>Повідомлення про залишення без розгляду документів.</li>\r\n	<li>Повідомлення про відмову у проведенні державної реєстрації змін до відомостей про фізичну особу &ndash; підприємця.</li>\r\n</ol>\r\n', '<p>Виписка з Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців, повідомлення про залишення документів без розгляду, повідомлення про відмову у проведенні державної реєстрації змін до відомостей про фізичну особу &ndash; підприємця та документи, що подавалися для проведення державної реєстрації змін до відомостей про фізичну особу &ndash; підприємця, відповідно до опису, видаються (надсилаються поштовим відправленням з описом вкладення) державним реєстратором заявнику.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(97, 'Видача юридичним особам дублікатів оригіналів їх установчих документів та змін до них\r\n', 1, 17, '<p>Закон України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; (зі&nbsp; змінами&nbsp; та&nbsp; доповненнями)&nbsp;(статті ч.1 ст.6, ч.3 ст.10).</p>\r\n', '<p>Звернення юридичної особи.</p>\r\n', '<p>Документи подаються засновниками (учасниками) юридичної особи або уповноваженим ними органом чи особою.</p>\r\n', '<ol>\r\n	<li>Заява&nbsp; про&nbsp; про видачу дубліката у довільній формі.</li>\r\n	<li>Документ, що підтверджує внесення плати за&nbsp; публікацію&nbsp; у спеціальному&nbsp; друкованому&nbsp; засобі&nbsp; масової інформації повідомлення про втрату оригіналів установчих документів (копія&nbsp; квитанції або копія платіжного доручення з відміткою банку).</li>\r\n	<li>Документ, що підтверджує внесення реєстраційного збору за видачу дубліката установчих документів та змін до них</li>\r\n</ol>\r\n', 1, '<p>???</p>\r\n', '<p>Справляється реєстраційний збір у розмірі одного неоподаткованого мінімуму доходів громадян (17 грн).</p>\r\n', '<p>???</p>\r\n', '<p>???</p>\r\n', '<ol>\r\n	<li>Заява оформлена з порушенням вимог,&nbsp; встановлених&nbsp; частинами&nbsp; першою та другою статті 8 Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n	<li>Документи подані не в повному обсязі.</li>\r\n	<li>До державного реєстратора надійшло рішення суду щодо заборони проведення реєстраційних дій.</li>\r\n	<li>Документи подані за неналежним місцем реєстрації.</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Повідомлення про залишення заяви про видачу дублікату &nbsp;установчих документів без розгляду.</li>\r\n	<li>Видача дублікату установчих документів юридичної особи та змін до них.</li>\r\n</ol>\r\n', '<p>Дублікат установчих документів юридичної особи та змін до них або повідомлення про залишення заяви про видачу дублікату установчих документів без розгляду видається (надсилається поштовим відправленням з описом вкладення) державним реєстратором заявнику.&nbsp;</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(98, 'Державна реєстрація припинення юридичної особи в результаті злиття,&nbsp; приєднання, поділу або перетворення\r\n', 1, 17, '<p>Закон України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; (зі&nbsp; змінами&nbsp; та&nbsp; доповненнями)&nbsp;(статті 8, 37).</p>\r\n', '<p>Звернення юридичної особи у зв&rsquo;язку із закінченням строку заявлення вимог кредиторами та процедури припинення юридичної особи.</p>\r\n', '<p>Документи подаються (надсилаються поштовим&nbsp; відправленням з описом вкладення) головою комісії з&nbsp; припинення&nbsp; або&nbsp; уповноваженою&nbsp; нею&nbsp; особою.</p>\r\n', '<ol>\r\n	<li>Заповнена реєстраційна картка на проведення державної реєстрації припинення юридичної особи в&nbsp; результаті&nbsp; злиття, приєднання, поділу або перетворення .</li>\r\n	<li>Підписаний головою і членами комісії з припинення&nbsp; юридичної особи та затверджений засновниками (учасниками) юридичної особи або органом,&nbsp; який прийняв рішення про припинення юридичної особи, примірник оригіналу передавального акта, якщо припинення здійснюється в результаті злиття,&nbsp; приєднання або перетворення, чи розподільчого&nbsp; балансу,&nbsp; якщо припинення здійснюється в результаті поділу, або їх нотаріально засвідчені копії.</li>\r\n	<li>Довідка архівної установи про прийняття документів, які відповідно до закону підлягають довгостроковому зберіганню*.</li>\r\n	<li>Документ про узгодження плану реорганізації&nbsp; з&nbsp; органом державної податкової служби (за наявності податкового боргу)*.</li>\r\n	<li>Довідка відповідного органу державної податкової&nbsp; служби про відсутність заборгованості із сплати податків, зборів*.</li>\r\n	<li>Довідка відповідного органу Пенсійного фонду України про відсутність заборгованості із сплати єдиного внеску на загальнообов&#39;язкове державне соціальне страхування та страхових коштів до Пенсійного фонду України і фондів соціального страхування*.&nbsp;</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Строк&nbsp; державної реєстрації припинення юридичної особи в результаті злиття,&nbsp; приєднання, поділу або перетворення не повинен перевищувати одного робочого дня з дати надходження документів.</p>\r\n\r\n<p>&nbsp;</p>\r\n', '<ol>\r\n	<li>Документи подані за неналежним місцем проведення державної реєстрації.</li>\r\n	<li>Документи подані не у повному обсязі.</li>\r\n	<li>Документи не відповідають вимогам, які встановлені частинами першою та другою статті 8 Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n	<li>Передавальний акт&nbsp; або&nbsp; розподільчий&nbsp; баланс&nbsp; не відповідає вимогам, які встановлені частиною четвертою&nbsp; статті 37 Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n	<li>Документи подані раніше строку, встановленого абзацом першим частини першої статті 37 Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n	<li>В Єдиному державному реєстрі юридичних осіб та фізичних осіб-підприємців щодо юридичної особи, що припиняється, містяться відомості про те, що вона є учасником (власником) інших юридичних осіб та/або&nbsp;&nbsp; має&nbsp; не&nbsp; закриті відокремлені підрозділи.</li>\r\n	<li>Не скасовано реєстрацію всіх випусків акцій, якщо&nbsp; юридична особа, що припиняється, є акціонерним&nbsp; товариством.&nbsp;</li>\r\n	<li>Від органів державної податкової служби та/або Пенсійного фонду України надійшло повідомлення про наявність заперечень проти проведення державної&nbsp; реєстрації припинення&nbsp; юридичної особи в результаті злиття, приєднання, поділу або перетворення, і воно не відкликане.&nbsp;</li>\r\n	<li>&nbsp;Не зазначені та&nbsp; не підтверджені&nbsp; особистим підписом голови комісії з припинення або уповноваженою ним особою відомості, передбачені частиною другою статті 37 Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.&nbsp;</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Повідомлення про залишення документів без розгляду.</li>\r\n	<li>Повідомлення про проведення&nbsp; державної реєстрації припинення юридичної особи в результаті злиття,&nbsp; приєднання, поділу або перетворення.&nbsp;</li>\r\n</ol>\r\n', '<p>Повідомлення про залишення документів без розгляду разом з документами, що подавалися для проведення державної реєстрації припинення юридичної особи в результаті злиття, приєднання, поділу або перетворення або повідомлення про проведення&nbsp; державної реєстрації припинення юридичної особи в результаті злиття,&nbsp; приєднання, поділу або перетворення видаються (надсилаються поштовим відправленням з описом вкладення) державним реєстратором заявнику.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL);
INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`, `ff_link`) VALUES
(99, 'Державна реєстрація припинення юридичної особи в результаті її ліквідації\r\n', 1, 17, '<p>Закон України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; (зі&nbsp; змінами&nbsp; та&nbsp; доповненнями)&nbsp;(статті 8, 36).</p>\r\n', '<p>Звернення юридичної особи у зв&rsquo;язку із закінченням строку заявлення вимог кредиторами та процедури ліквідації юридичної особи.</p>\r\n', '<p>Документи подаються (надсилаються поштовим&nbsp; відправленням з описом вкладення) головою&nbsp; ліквідаційної комісії, уповноваженою&nbsp; ним&nbsp; особою або ліквідатором.</p>\r\n', '<ol>\r\n	<li>Заповнена реєстраційна картка на проведення державної реєстрації припинення юридичної особи у зв&#39;язку з ліквідацією (форма 7).</li>\r\n	<li>Довідка відповідного органу державної податкової&nbsp; служби про відсутність заборгованості із сплати податків, зборів.</li>\r\n	<li>Довідка відповідного органу Пенсійного фонду України про відсутність заборгованості із сплати єдиного внеску на загальнообов&#39;язкове державне соціальне страхування та страхових коштів до Пенсійного фонду України і фондів соціального страхування.</li>\r\n	<li>Довідка архівної установи про прийняття документів, які відповідно до закону підлягають довгостроковому зберіганню.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Строк&nbsp; державної реєстрації припинення юридичної особи в результаті її ліквідації не повинен перевищувати одного робочого дня з дати надходження документів.&nbsp;</p>\r\n', '<ol>\r\n	<li>Документи подані&nbsp; за&nbsp; неналежним&nbsp; місцем проведення державної реєстрації.</li>\r\n	<li>Документи не відповідають вимогам,&nbsp; які встановлені частинами першою та другою статті 8 Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n	<li>Документи подані не у повному обсязі.</li>\r\n	<li>Документи подані раніше строку, встановленого абзацом першим частини першої статті 36 Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n	<li>В Єдиному&nbsp; державному реєстрі юридичних осіб та фізичних осіб &ndash; підприємців щодо&nbsp; юридичної&nbsp; особи,&nbsp; що припиняється, містяться відомості&nbsp; про&nbsp; те,&nbsp; що вона є учасником (власником) інших юридичних осіб&nbsp;&nbsp; та/або&nbsp;&nbsp; має&nbsp; не&nbsp; закриті відокремлені&nbsp; підрозділи.&nbsp;</li>\r\n	<li>Не скасовано реєстрацію всіх випусків акцій, якщо&nbsp; юридична особа, що припиняється, є акціонерним&nbsp; товариством.&nbsp;</li>\r\n	<li>Від органів державної&nbsp; податкової служби&nbsp; та/або Пенсійного фонду України надійшло повідомлення про наявність заперечень проти проведення державної&nbsp; реєстрації&nbsp; припинення&nbsp; юридичної&nbsp; особи&nbsp; в результаті&nbsp;&nbsp; її&nbsp; ліквідації,&nbsp; і&nbsp; воно&nbsp; не&nbsp; відкликане.&nbsp;</li>\r\n	<li>Не зазначено та не&nbsp; підтверджено&nbsp; особистим&nbsp; підписом&nbsp; голови ліквідаційної комісії, ліквідатора або&nbsp; уповноваженої&nbsp; особи відомості, передбачені частиною&nbsp; другою статті 36 Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.&nbsp;</li>\r\n	<li>Стосовно юридичної особи відкрито виконавче&nbsp; провадження.</li>\r\n	<li>Стосовно юридичної особи відкрито провадження у справі про банкрутство&nbsp; юридичної особи.&nbsp;</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Повідомлення про залишення документів без розгляду.</li>\r\n	<li>Повідомлення про проведення&nbsp; державної реєстрації припинення юридичної особи в результаті її ліквідації.&nbsp;</li>\r\n</ol>\r\n', '<p>Повідомлення про залишення документів без розгляду разом з документами, що подавалися для проведення державної реєстрації припинення юридичної особи в результаті її ліквідації або повідомлення про проведення&nbsp; державної реєстрації припинення юридичної особи в результаті її ліквідації видаються (надсилаються поштовим відправленням з описом вкладення) державним реєстратором заявнику.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(100, 'Державна реєстрація припинення підприємницької діяльності фізичної особи-підприємця за її рішенням\r\n', 1, 17, '<p>Закон України від 15.05.2003 № 755-ІV &laquo;Про державну реєстрацію юридичних осіб та фізичних осіб-підприємців&raquo; (статті 8, 47)</p>\r\n', '<p>Звернення фізичної особи-підприємця або уповноваженою нею особою.&nbsp;</p>\r\n', '<p>Особисто, поштовим відправленням з описом вкладення або через уповноважену особу.</p>\r\n', '<p>Заповнена реєстраційна картка на проведення&nbsp; державної&nbsp; реєстрації&nbsp; припинення підприємницької діяльності&nbsp; фізичною особою &ndash;підприємцем за її рішенням.</p>\r\n', 0, '', '', '', '<p>Внесення до Єдиного державного реєстру юридичних осіб та фізичних осіб-підприємців запису про проведення держаної реєстрації припинення підприємницької діяльності фізичною особою-підприємцем здійснюється держаним реєстратором не пізніше наступного робочого дня з дати надходження реєстраційної картки на проведення державної реєстрації припинення підприємницької діяльності фізичною особою-підприємцем за її рішенням та в той же день видається (надсилається поштовим відправленням з описом вкладення) їй повідомлення про проведення такого запису.</p>\r\n', '<ol>\r\n	<li>Документи подані за неналежним місцем проведення держаної реєстрації.</li>\r\n	<li>Документи не&nbsp; відповідають вимогам, встановленим&nbsp; частиною першою або абзацом першим частини другої статті 8 Закон України від 15.05.2003 № 755-ІV &laquo;Про державну реєстрацію юридичних осіб та фізичних осіб-підприємців&raquo;.</li>\r\n</ol>\r\n', '<p>Повідомлення про внесення до Єдиного державного реєстру юридичних осіб та фізичних осіб-підприємців запису про проведення держаної реєстрації припинення підприємницької діяльності фізичною особою-підприємцем, повідомлення із зазначенням підстав залишення реєстраційної картки на проведення державної реєстрації припинення підприємницької діяльності фізичною особою-підприємцем за її рішенням без розгляду разом із реєстраційною карткою, що подавалася для проведення держаної реєстрації припинення підприємницької діяльності фізичною особою-підприємцем за її рішенням, відповідно до опису, видаються (надсилається поштовим відправленням з описом вкладення) державним реєстратором заявнику.</p>\r\n', '<p>???</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(101, 'Видача свідоцтва про реєстрацію громадської організації\r\n', 1, 18, '<ol>\r\n	<li>Закон України &laquo;Про громадські об&rsquo;єднання&raquo; від 22.03.2012 р. №4572-VI.&nbsp;&nbsp;</li>\r\n	<li>Постанова Кабінету Міністрів України від 26 грудня 2012р.№1193 &laquo;Про затвердження зразків свідоцтв&nbsp;про реєстрацію громадського об&#39;єднання як громадської організації чи громадської спілки та про&nbsp;акредитацію відокремленого підрозділу іноземної неурядової організації&raquo;.</li>\r\n	<li>Наказ Міністерства юстиції України від 14.12.2012 №1745/5 &laquo;Про порядок підготовки та оформлення&nbsp;рішень щодо громадських об&#39;єднань&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>&nbsp;Через Центр надання адміністративних послуг.</p>\r\n', '<ol>\r\n	<li>Заява.</li>\r\n	<li>Статут (у двох примірниках).</li>\r\n	<li>Протокол установчих зборів громадської організації, оформленого з дотриманням вимог частин другої,&nbsp;&nbsp;п&rsquo;ятої, сьомої статті 9&nbsp; &nbsp;&nbsp;Закону України &laquo;Про громадські об&rsquo;єднання&raquo; від 22.03.2012 р. №4572-VI.&nbsp;&nbsp;&nbsp;</li>\r\n	<li>Реєстр осіб, які брали участь в зборах.</li>\r\n	<li>Відомості про склад керівних органів громадської організації.</li>\r\n	<li>Відомості про особу, яка має право представляти громадську організацію для здійснення реєстраційних дій.</li>\r\n	<li>Письмова особиста згода керівника на зайняття відповідної посади відповідно до частини 6 статті 9 Закону.</li>\r\n	<li>Письмова особиста згода осіб, які&nbsp; мають право представляти Організацію для здійснення реєстраційних дій відповідно до частини 6 статті 9 Закону.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>7 робочих днів з дня надходження письмової заяви та документів.<br />\r\n&nbsp;</p>\r\n', '<p>---</p>\r\n', '<p>Видача свідоцтва про реєстрацію громадської організації.</p>\r\n', '<p>Особисто або&nbsp;уповноваженою особою в &nbsp;Центрі надання адміністративних послуг.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(102, 'Прийняття повідомлення про утворення громадського об''єднання', 1, 18, '<ol>\r\n	<li>Закон України &laquo;Про громадські об&rsquo;єднання&raquo; від 22.03.2012 р. №4572-VI.&nbsp;&nbsp;</li>\r\n	<li>Постанова Кабінету Міністрів України від 26 грудня 2012р.№1193 &laquo;Про затвердження зразків свідоцтв&nbsp;про реєстрацію громадського об&#39;єднання як громадської організації чи громадської спілки та про&nbsp;акредитацію відокремленого підрозділу іноземної неурядової організації&raquo;.</li>\r\n	<li>Наказ Міністерства юстиції України від 14.12.2012 №1745/5 &laquo;Про порядок підготовки та оформлення&nbsp;рішень щодо громадських об&#39;єднань&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>???</p>\r\n', '<ol>\r\n	<li>Заява(підписується засновниками громадського об&rsquo;єднання або особою(особами), уповноваженою представляти громадське об&rsquo;єднання, а справжність їх підписів засвідчується нотаріально).</li>\r\n	<li>Примірник оригіналу або нотаріально засвідчена копія протоколу установчих зборів, оформленого з&nbsp;дотриманням вимог частини другої, четвертої та восьмої статті 9&nbsp; цього&nbsp; Закону.</li>\r\n	<li>Відомості про засновників &nbsp;громадського об&rsquo;єднання &nbsp;із зазначенням прізвища, ім&rsquo;я по батькові&nbsp;(за наявності), дати народження, адреси місця проживання,а в разі якщо засновником є юридична особа&nbsp;приватного права &ndash; її найменування, місцезнаходження, &nbsp;ідентифікаційного коду.</li>\r\n	<li>Відомості про особу (осіб), уповноважену представляти громадське об&rsquo;єднання із зазначенням&nbsp;прізвища, ім&rsquo;я по батькові (за наявності), дати народження, контактного номера телефону та інших&nbsp;засобів зв&rsquo;язку, до яких додається&nbsp; письмова згода цієї особи, передбачена частиною шостою&nbsp;статті 9 цього Закону.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>5 робочих днів з дня надходження письмової заяви та документів.<br />\r\n&nbsp;</p>\r\n', '<pre>\r\n\r\n\r\n&nbsp;</pre>\r\n\r\n<pre>\r\n???</pre>\r\n', '<p>Видача письмового повідомлення &nbsp;про утворення громадської організації.</p>\r\n', '<p>Особисто, уповноваженою особою в Центрі надання адміністративних послуг.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(103, 'Видача&nbsp;дубліката свідоцтва про реєстрацію громадської організації\r\n', 1, 18, '<ol>\r\n	<li>Закон України &laquo;Про громадські об&rsquo;єднання&raquo; від 22.03.2012 р. №4572-VI.&nbsp;&nbsp;</li>\r\n	<li>Закон України &laquo;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&raquo;&nbsp;&nbsp;від 15.05.2003р. №755-IV.&nbsp;&nbsp;&nbsp;</li>\r\n	<li>Наказ Міністерства юстиції України від 14.12.2012 №1745/5 &laquo;Про порядок підготовки та оформлення&nbsp;рішень щодо громадських об&#39;єднань&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Особисто або&nbsp;уповноваженою особою.</p>\r\n', '<ol>\r\n	<li>Заява.</li>\r\n	<li>Документ, що підтверджує внесення плати за публікацію повідомлення у спеціальному друкованому засобі масової&nbsp; інформації повідомлення про втрату оригіналу свідоцтва про реєстрацію або статуту.</li>\r\n	<li>Довідка, видана органом внутрішніх справ про реєстрацію заяви про втрату оригіналу свідоцтва про реєстрацію або статуту.&nbsp;&nbsp;&nbsp; &nbsp;</li>\r\n</ol>\r\n', 0, '', '', '', '<p>3 &nbsp;дні з дня надходження письмової заяви та документів.<br />\r\n&nbsp;</p>\r\n', '<p>---</p>\r\n', '<p>Видача дубліката свідоцтва про реєстрацію громадської організації.</p>\r\n', '<p>Особисто або&nbsp; уповноваженою особою.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(104, 'Внесення до реєстру громадських&nbsp;об&rsquo;єднань відомостей про відокремлений підрозділ громадського об&rsquo;єднання\r\n', 1, 18, '<ol>\r\n	<li>Закон України &laquo;Про громадські об&rsquo;єднання&raquo; від 22.03.2012 р. №4572-VI.&nbsp;&nbsp;</li>\r\n	<li>Наказ Міністерства юстиції України від 14.12.2012 №1745/5 &laquo;Про порядок підготовки та оформлення&nbsp;рішень щодо громадських об&#39;єднань&raquo;.</li>\r\n	<li>Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; від 15.05.2003 № 755-IV.&nbsp;</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Особисто або&nbsp; уповноваженою особою.</p>\r\n', '<ol>\r\n	<li>Заява.</li>\r\n	<li>Рішення керівного органу &nbsp;громадського об&rsquo;єднання &nbsp;про створення&nbsp; відокремленого&nbsp; підрозділу.</li>\r\n	<li>Реєстраційна картка&nbsp; форми №5 про створення відокремленого підрозділу, яка повинна містити такі дані:</li>\r\n</ol>\r\n\r\n<ul>\r\n	<li>ідентифікаційний код громадського об&rsquo;єднання як юридичної особи;</li>\r\n	<li>повне найменування відокремленого підрозділу;</li>\r\n	<li>місцезнаходження відокремленого підрозділу;</li>\r\n	<li>прізвище, ім&rsquo;я та по батькові керівника відокремленого підрозділу, його реєстраційний номер&nbsp;облікової картки платника податку;</li>\r\n	<li>місцезнаходження реєстраційної справи громадського об&rsquo;єднання.</li>\r\n</ul>\r\n', 0, '', '', '', '<p>3 робочих дня з дня надходження письмової заяви та документів.</p>\r\n', '<p>---</p>\r\n', '<p>Внесення до Реєстру &nbsp;громадських об&rsquo;єднань відомостей про відокремлений підрозділ.</p>\r\n', '<p>Особисто, &nbsp;уповноваженою особою, рекомендованим листом з повідомленням про вручення.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(105, 'Прийняття&nbsp;повідомлення про зміни до статуту громадського об&rsquo;єднання, зміни у складі керівних органів громадського об&rsquo;єднання, зміну місцезнаходження зареєстрованого громадського об&rsquo;єднання\r\n', 18, 18, '<ol>\r\n	<li>Закон України &laquo;Про громадські об&rsquo;єднання&raquo; від 22.03.2012 р. №4572-VI.&nbsp;&nbsp;</li>\r\n	<li>Закон України &laquo;Про державну реєстрацію юридичних осіб та фізичних осіб-підприємців&raquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 26 грудня 2012р.№1193 &laquo;Про затвердження зразків свідоцтв&nbsp;про реєстрацію громадського об&#39;єднання як громадської організації чи громадської спілки та про&nbsp;акредитацію відокремленого підрозділу іноземної неурядової організації&raquo;.</li>\r\n	<li>Наказ Міністерства юстиції України від 14.12.2012 №1745/5 &laquo;Про порядок підготовки та оформлення&nbsp;рішень щодо громадських об&#39;єднань&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Особисто або&nbsp; уповноваженою особою.</p>\r\n', '<ol>\r\n	<li>Заява.</li>\r\n	<li>Заповнена відповідна реєстраційна картка.</li>\r\n	<li>Оригінал статуту та свідоцтва громадського об&rsquo;єднання.</li>\r\n	<li>Статут в новій редакції (у двох прим.)</li>\r\n	<li>Протокол вищого органу управління громадського об&rsquo;єднання про відповідні зміни, оформленого з дотриманням вимог частини другої статті 9 Закону України &laquo;Про громадські об&rsquo;єднання&raquo; від 22.03.2012р№4572-VI.</li>\r\n	<li>Реєстр осіб, які брали участь в зборах.</li>\r\n	<li>Протокол керівного органу &nbsp;громадського об&rsquo;єднання, на якому відповідно до статуту було скликано засідання вищого органу управління.</li>\r\n	<li>Відомості про склад керівних органів громадської організації.</li>\r\n	<li>Відомості про особу, яка має право представляти громадську організацію для здійснення реєстраційних дій.</li>\r\n	<li>Письмова особиста згода керівника на зайняття відповідної&nbsp; посади відповідно до частини 9 статті 9 Закону.</li>\r\n	<li>Письмова особиста згода осіб, які мають право представляти Організацію для здійснення реєстраційних дій відповідно до частини 6 статті 9 Закону.&nbsp;</li>\r\n</ol>\r\n', 1, '<p>Відповідно до ч.16 ст. 14 Закону за прийняття повідомлення про зміни до статуту громадського об&rsquo;єднання.</p>\r\n', '<p>Справляється плата у розмірі 51 грн.</p>\r\n', '<p>???</p>\r\n', '<p>5 днів з дня надходження письмової заяви та документів.<br />\r\n&nbsp;</p>\r\n', '<p>---</p>\r\n', '<p>Видача свідоцтва, &nbsp;повідомлення та статуту &nbsp;з відповідними змінами &nbsp;громадської організації.</p>\r\n', '<p>Особисто або&nbsp; уповноваженою особою.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(106, 'Прийняття&nbsp;повідомлення про зміну &nbsp;найменування &nbsp;громадського об&rsquo;єднання, мети(цілей), зміну особи (осіб), уповноваженої представляти громадське об&rsquo;єднання, утворене шляхом прийняття повідомлення про утворення\r\n', 18, 18, '<ol>\r\n	<li>Закон України &laquo;Про громадські об&rsquo;єднання&raquo; від 22.03.2012 р. №4572-VI.&nbsp;&nbsp;</li>\r\n	<li>Постанова Кабінету Міністрів України від 26 грудня 2012р.№1193 &laquo;Про затвердження зразків свідоцтв&nbsp;про реєстрацію громадського об&#39;єднання як громадської організації чи громадської спілки та про&nbsp;акредитацію відокремленого підрозділу іноземної неурядової організації&raquo;.</li>\r\n	<li>Наказ Міністерства юстиції України від 14.12.2012 №1745/5 &laquo;Про порядок підготовки та оформлення&nbsp;рішень щодо громадських об&#39;єднань&raquo;.</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Особисто або&nbsp;уповноваженою особою.</p>\r\n', '<ol>\r\n	<li>Заява.</li>\r\n	<li>Повідомлення про відповідні зміни.</li>\r\n	<li>Відомості про особу, уповноважену представляти громадське об&rsquo;єднання, оформлені з дотриманням ч.7 ст.14 Закону України &laquo;Про громадські об&rsquo;єднання&rdquo; від 22.03.2012р.№4572-VI.</li>\r\n	<li>Письмова особиста згода уповноваженої особи на зайняття відповідної посади відповідно до частини 9 статті 9 Закону.</li>\r\n	<li>Письмова особиста згода осіб, які мають право представляти Організацію для здійснення реєстраційних дій відповідно до частини 6 статті 9 Закону.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>5 днів з дня надходження письмової заяви та документів.</p>\r\n', '<p>---</p>\r\n', '<p>Видача свідоцтва, &nbsp;повідомлення &nbsp;з відповідними змінами &nbsp;громадської організації.</p>\r\n', '<p>Особисто або&nbsp; уповноваженою особою.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(107, 'Внесення до реєстру &nbsp;громадських об&rsquo;єднань запису про рішення щодо саморозпуску або реорганізації громадського об&rsquo;єднання, а також про припинення діяльності громадського об&rsquo;єднання\r\n', 18, 18, '<ol>\r\n	<li>Закон України &laquo;Про громадські об&rsquo;єднання&raquo; від 22.03.2012 р. №4572-VI.&nbsp;&nbsp;</li>\r\n	<li>Наказ Міністерства юстиції України від 14.12.2012 №1745/5 &laquo;Про порядок підготовки та оформлення&nbsp;рішень щодо громадських об&#39;єднань&raquo;.</li>\r\n	<li>Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; від 15.05.2003 № 755-IV.&nbsp;</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Особисто або&nbsp; уповноваженою особою.</p>\r\n', '<ol>\r\n	<li>Заява.</li>\r\n	<li>Рішення про саморозпуск громадського об&rsquo;єднання. До рішення додаються:</li>\r\n</ol>\r\n\r\n<ul>\r\n	<li>оригінал свідоцтва про реєстрацію громадського &nbsp;об&rsquo;єднання( або його дубліката);</li>\r\n	<li>оригінал статуту громадського&nbsp; об&rsquo;єднання( або його дубліката).</li>\r\n	<li>реєстраційна картка на проведення державної реєстрації припинення юридичної особи.<br />\r\n	&nbsp;</li>\r\n</ul>\r\n', 0, '', '', '', '<p>10 робочих днів з дня надходження письмової заяви та документів.<br />\r\n&nbsp;</p>\r\n', '<p>---</p>\r\n', '<p>Рішення про визнання або відмову у визнанні рішення про саморозпуск громадського об&rsquo;єднання. Лист про внесення даних.</p>\r\n', '<p>Особисто або&nbsp; уповноваженою особою.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(108, 'Видача свідоцтва про державну реєстрацію друкованого засобу масової інформації з місцевою сферою розповсюдження\r\n', 18, 18, '<ol>\r\n	<li>Закон України &laquo;Про друковані засоби масової інформації (пресу) в Україні&raquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України &laquo;Про державну реєстрацію друкованих засобів масової інформації, інформаційних агентств та розміри реєстраційних зборів&raquo; від 17.11.1997 № 1287.</li>\r\n	<li>Наказ Міністерства юстиції України &laquo;Про затвердження Положення про державну реєстрацію друкованих засобів масової інформації в Україні та Положення про державну реєстрацію інформаційних агентств як суб&#39;єктів інформаційної діяльності&raquo; від 21.02.2006 № 12/5 ( із змінами).</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Особисто засновником (або його представником за довіреністю).</p>\r\n', '<p><strong>Для юридичної особи такими документами є:</strong></p>\r\n\r\n<ol>\r\n	<li>Засвідчені&nbsp; печаткою&nbsp; юридичної&nbsp; особи&nbsp; та&nbsp; підписом&nbsp; її керівника копії статуту (положення), чинні на момент подачі.</li>\r\n	<li>Протокол або витяг з протоколу рішення загальних зборів (конференції) у разі заснування друкованого засобу масової інформації трудовим колективом згідно з вимогами статті 8 Закону України &laquo;Про друковані засоби масової інформації (пресу) в Україні&raquo;.</li>\r\n	<li>Установчий договір між співзасновниками друкованого засобу масової інформації (засвідчений нотаріально, якщо одна із сторін - фізична особа).</li>\r\n	<li>Довіреність, доручення (якщо заяву та/чи установчий договір, угоду між засновником і правонаступником підписує особа, якій таке право не надано правовстановлювальними документами).</li>\r\n</ol>\r\n\r\n<p>&nbsp;<strong> Для фізичної особи таким документом є копія паспорта (сторінок, що містять інформацію про громадянство та реєстрацію місця проживання фізичної особи).</strong></p>\r\n\r\n<p>&nbsp; Установчі документи, складені іноземною мовою, подаються для державної реєстрації друкованих засобів масової інформації разом з їх перекладом на українську мову, засвідчені в установленому порядку.</p>\r\n\r\n<p>&nbsp;</p>\r\n', 1, '<p>Безоплатна, якщо вільняються від сплати реєстраційного збору друкований засіб масової інформації, заснований з благодійною метою і призначений для безплатного розповсюдження.<br />\r\n&nbsp;</p>\r\n', '<ul>\r\n	<li>із місцевою сферою розповсюдження в межах однієї області, обласного центру або двох і більше сільських районів - 24 неоподатковуваних мінімумів доходів громадян;</li>\r\n	<li>із місцевою сферою розповсюдження в межах одного міста, району, окремих населених пунктів, а також підприємств, установ, організацій - 14 неоподатковуваних мінімумів доходів громадян;</li>\r\n	<li>заснованих за участю громадян та/або юридичних осіб інших держав, а також юридичних осіб&nbsp; України, у статутному фонді яких є іноземний капітал, - 120&nbsp; неоподатковуваних&nbsp; мінімумів&nbsp; доходів громадян;</li>\r\n	<li>що спеціалізується на матеріалах еротичного характеру, - 100 неоподатковуваних мінімумів доходів громадян;</li>\r\n	<li>&nbsp;за державну реєстрацію дайджесту &ndash; 60 неоподатковуваних мінімумів доходів громадян.&nbsp;</li>\r\n</ul>\r\n', '<p>Засновник (співзасновники) сплачує реєстраційний збір за наступними реквізитами:</p>\r\n\r\n<p>Банк отримувача: ГУДКСУ у м. Києві;</p>\r\n\r\n<p>Код банку отримувача: 820019;</p>\r\n\r\n<p>Одержувач коштів: УК у Дніпровському районі м. Києва;</p>\r\n\r\n<p>Код отримувача (код за ЄДРПОУ): 38012871;</p>\r\n\r\n<p>Рахунок отримувача: 31115028733005;</p>\r\n\r\n<p>Призначення платежу: за державну реєстрацію друкованого засобу масової інформації.</p>\r\n', '<p>Заява розглядається у місячний строк з дня її одержання.</p>\r\n', '<p>---</p>\r\n', '<p>Видача свідоцтва про державну реєстрацію друкованого засобу масової інформації.</p>\r\n', '<p>Особисто засновником (або його представником за довіреністю) при пред&#39;явленні паспорта і платіжного документа про сплату адміністративного збору</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(109, 'Видача свідоцтва про державну реєстрацію друкованого засобу масової інформації у зв&#39;язку з перереєстрацією\r\n', 18, 18, '<ol>\r\n	<li>Закон України &laquo;Про друковані засоби масової інформації (пресу) в Україні&raquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 17.11.1997 № 1287 &laquo;Про державну реєстрацію друкованих засобів масової інформації, інформаційних агентств та розміри реєстраційних зборів&raquo;.</li>\r\n	<li>Наказ Міністерства юстиції України від 21.02.2006 № 12/5 &laquo;Про затвердження Положення про державну реєстрацію друкованих засобів масової інформації в Україні та Положення про державну реєстрацію інформаційних агентств як суб&#39;єктів інформаційної діяльності&raquo; (із змінами).</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Особисто засновником або його представником за довіреністю.</p>\r\n', '<ol>\r\n	<li>Засвідчені&nbsp; печаткою&nbsp; юридичної&nbsp; особи&nbsp; та&nbsp; підписом&nbsp; її керівника копії статуту (положення), чинні на момент подачі;</li>\r\n	<li>Протокол або витяг з протоколу рішення загальних зборів (конференції) у разі заснування друкованого засобу масової інформації трудовим колективом згідно з вимогами статті 8 Закону України &laquo;Про друковані засоби масової інформації (пресу) в Україні&raquo;;</li>\r\n	<li>Установчий договір між співзасновниками друкованого засобу масової інформації (засвідчений нотаріально, якщо одна із сторін - фізична особа);</li>\r\n	<li>Довіреність, доручення (якщо заяву та/чи установчий договір, угоду між засновником і правонаступником підписує особа, якій таке право не надано правовстановлювальними документами).</li>\r\n</ol>\r\n\r\n<p><strong>&nbsp; Для фізичної особи таким документом є копія паспорта (сторінок, що містять інформацію про громадянство та реєстрацію місця проживання фізичної особи).</strong></p>\r\n\r\n<p>&nbsp; Установчі документи, складені іноземною мовою, подаються для державної реєстрації друкованих засобів масової інформації разом з їх перекладом на українську мову, засвідчені в установленому порядку.</p>\r\n\r\n<p>&nbsp; При перереєстрації до зазначених документів додаються також:</p>\r\n\r\n<ol>\r\n	<li>Угода між засновником і правонаступником (у зв&#39;язку зі зміною засновника (співзасновників)</li>\r\n	<li>Копія попереднього свідоцтва про державну реєстрацію друкованого засобу масової інформації.</li>\r\n</ol>\r\n', 1, '<p>---</p>\r\n', '<p>Безоплатна, якщо вільняються від сплати реєстраційного збору друкований засіб масової інформації, заснований з благодійною метою і призначений для безплатного розповсюдження.<br />\r\n&nbsp;</p>\r\n\r\n<p>Платна - &nbsp;у розмірі 50 відсотків від установленого реєстраційного збору.<br />\r\n&nbsp;</p>\r\n', '<p>Банк отримувача: ГУДКСУ у м. Києві;</p>\r\n\r\n<p>Код банку отримувача: 820019;</p>\r\n\r\n<p>Одержувач коштів: УК у Дніпровському районі м. Києва;</p>\r\n\r\n<p>Код отримувача (код за ЄДРПОУ): 38012871;</p>\r\n\r\n<p>Рахунок отримувача: 31115028733005;</p>\r\n\r\n<p>Призначення платежу: за державну реєстрацію друкованого засобу масової інформації</p>\r\n', '<p>Заява розглядається у місячний строк з дня її одержання.</p>\r\n', '<p>---</p>\r\n', '<p>Видача свідоцтва про державну реєстрацію друкованого засобу масової інформації.</p>\r\n', '<p>Особисто засновником (або його представником за довіреністю)&nbsp; при пред&#39;явленні паспорта і платіжного документа&nbsp; про сплату адміністративного збору.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(110, 'Видача дубліката свідоцтва про державну реєстрацію друкованого засобу масової інформації\r\n', 18, 18, '<ol>\r\n	<li>Закон України &laquo;Про друковані засоби масової інформації (пресу) в Україні&raquo;.</li>\r\n	<li>Постанова Кабінету Міністрів України від 17.11.1997 № 1287 &laquo;Про державну реєстрацію друкованих засобів масової інформації, інформаційних агентств та розміри реєстраційних зборів&raquo;.</li>\r\n	<li>Наказ Міністерства юстиції України від 21.02.2006 № 12/5 &laquo;Про затвердження Положення про державну реєстрацію друкованих засобів масової інформації в Україні та Положення про&nbsp; державну реєстрацію інформаційних агентств як суб&#39;єктів інформаційної діяльності&raquo; (із змінами).</li>\r\n</ol>\r\n', '<p>---</p>\r\n', '<p>Особисто засновником або його представником за довіреністю.</p>\r\n', '<p><strong>У разі пошкодження свідоцтва: </strong></p>\r\n\r\n<ol>\r\n	<li>Письмова заява засновника (співзасновників) про видачу дубліката.</li>\r\n	<li>Пошкоджене свідоцтво про державну реєстрацію друкованого засобу масової інформації.</li>\r\n</ol>\r\n\r\n<p>&nbsp; <strong>У разі втрати свідоцтва:</strong></p>\r\n\r\n<ol>\r\n	<li>Письмова заява засновника (співзасновника) про видачу дубліката;</li>\r\n	<li>Примірник друкованого засобу масової інформації, у якому опубліковано оголошення про втрату свідоцтва.</li>\r\n</ol>\r\n', 1, '<p>---</p>\r\n', '<p>Платна - &nbsp;у розмірі 20 відсотків від установленого реєстраційного збору.</p>\r\n', '<p>Банк отримувача: ГУДКСУ у м. Києві;</p>\r\n\r\n<p>Код банку отримувача: 820019;</p>\r\n\r\n<p>Одержувач коштів: УК у Дніпровському районі м. Києва;</p>\r\n\r\n<p>Код отримувача (код за ЄДРПОУ): 38012871;</p>\r\n\r\n<p>Рахунок отримувача: 31115028733005;</p>\r\n\r\n<p>Призначення платежу: за державну реєстрацію друкованого засобу масової інформації</p>\r\n', '<p>Заява розглядається у місячний строк з дня її одержання.</p>\r\n', '<p>---</p>\r\n', '<p>Видача дубліката свідоцтва про державну реєстрацію друкованого засобу масової інформації.</p>\r\n', '<p>Особисто засновником (або його представником за довіреністю) при пред&#39;явленні паспорта і платіжного документа про сплату адміністративного збору.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL);
INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`, `ff_link`) VALUES
(111, 'Визнання недійсним свідоцтва про державну реєстрацію друкованого засобу масової&nbsp; інформації з місцевою сферою розповсюдження на підставі повідомлення засновника\r\n', 18, 18, '<p>Наказ Міністерства юстиції України від 21.02.2006 № 12/5 &laquo;Про затвердження Положення про державну реєстрацію друкованих засобів масової інформації в Україні та Положення про державну реєстрацію інформаційних агентств як суб&#39;єктів інформаційної діяльності&raquo; (із змінами).</p>\r\n', '<p>---</p>\r\n', '<p>Особисто засновником&nbsp; або&nbsp; поштою.</p>\r\n', '<p>Письмове повідомлення засновника (співзасновника) про припинення випуску друкованого засобу масової інформації, погоджене з редакцією (свідоцтво&nbsp; про державну реєстрацію друкованого засобу масової інформації,&nbsp; яке визнано недійсним, підлягає поверненню у десятиденний термін з дня отримання відповідного повідомлення реєструвального органу).<br />\r\n&nbsp;</p>\r\n', 0, '', '', '', '<p>Протягом 30 робочих днів з дня подання заяви.</p>\r\n', '<p>---</p>\r\n', '<p>Повідомлення про визнання&nbsp; недійсним&nbsp; свідоцтва про державну реєстрацію&nbsp; друкованого засобу масової інформації.</p>\r\n', '<p>Особисто засновником&nbsp; або&nbsp; поштою.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(112, 'Оформлення та видача паспорта громадянина України\r\n', 1, 19, '<ol>\r\n	<li>П. 2 Положення про паспорт громадянина України, затвердженого Постановою ВРУ &laquo;Про затвердження положень про паспорт громадянина України та про паспорт громадянина для виїзду за кордон&raquo; від 26.06.1992&nbsp;№ 2503-ХІІ</li>\r\n	<li>П. 7 ч. 1 ст. 24 Закону України &laquo;Про громадянство України&raquo; від 18.01.2001 № 2235-ІІІ</li>\r\n	<li>Ст. 21 Закону України &laquo;Про Єдиний державний демографічний реєстр та документи, що підтверджують громадянство України, посвідчують особу чи її спеціальний статус&raquo; від 20.11.2012 № 5492-VІ</li>\r\n	<li>НАКАЗ МВС &laquo;Про затвердження Порядку оформлення і видачі паспорта громадянина України&raquo; від 13.04.2012 № 320</li>\r\n</ol>\r\n', '<p>Паспорт громадянина України видається кожному громадянинові України після досягнення 16-річного віку.</p>\r\n', '<p>Заявник для одержання адміністративної послуги з оформлення&nbsp; та видачі паспорта громадянина України звертається до територіального підрозділу ДМС або центру надання адміністративних послуг відповідно до місця проживання.</p>\r\n', '<ol>\r\n	<li>Заява.</li>\r\n	<li>Дві фотокартки розміром 3,5 х 4,5 см.</li>\r\n	<li>Свідоцтво про народження.</li>\r\n	<li>Довідка про реєстрацію особи громадянином України.</li>\r\n	<li>Паспорт громадянина України для виїзду за кордон &ndash; для громадян, які постійно проживали за кордоном, після повернення їх на проживання в Україну.</li>\r\n	<li>Посвідчення для взяття на облік бездомних осіб, видане відповідним центром обліку бездомних осіб (для бездомних осіб).</li>\r\n	<li>Документи що підтверджують обставини, на підставі яких паспорт підлягає обміну (зміна (переміна) прізвища, імені або по батькові; установлення розбіжностей у записах).</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Не пізніше 10 робочих днів з дати подання заявником необхідних документів.</p>\r\n', '<p>Відсутність одного з документів, необхідних для отримання адміністративної послуги, відсутність громадянства України.</p>\r\n', '<p>Видача паспорта громадянина України.</p>\r\n', '<p>Звернутися до територіального підрозділу ДМС або центру надання адміністративних послуги відповідно до місця проживання.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(113, 'Оформлення та видача паспорта громадянина України у разі обміну замість втраченого чи пошкодженого\r\n', 1, 19, '<ol>\r\n	<li>П. 19 Положення про паспорт громадянина України, затвердженого Постановою Верховної Ради України &laquo;Про затвердження положень про паспорт громадянина України та про паспорт громадянина для виїзду за кордон&raquo; від 26.06.1992&nbsp;№ 2503-ХІІ</li>\r\n	<li>Ст. 16, 21 Закону України &nbsp;&laquo;Про Єдиний державний демографічний реєстр та документи, що підтверджують громадянство України, посвідчують особу чи її спеціальний статус&raquo; від 20.11.2012 № 5492-VІ</li>\r\n	<li>Декрет Кабінету міністрів України &laquo;Про державне мито&raquo; від 21.01.1993 № 7-93</li>\r\n	<li>Наказ МВС &laquo;Про затвердження Порядку оформлення і видачі паспорта громадянина України&raquo; від 13.04.2012 № 320</li>\r\n</ol>\r\n', '<p>Втрата чи пошкодження паспорта громадянина України.</p>\r\n', '<p>Заявник для одержання адміністративної послуги з оформлення&nbsp; та видачі паспорта громадянина України замість втраченого чи пошкодженого звертається до територіального підрозділу ДМС відповідно до місця проживання.</p>\r\n', '<p>1. заява про видачу паспорта громадянина України;</p>\r\n\r\n<p>2. або три фотокартки розміром 3,5 х 4,5 см;</p>\r\n\r\n<p>3. платіжний документ з відміткою банку про сплату державного мита або копію документа про звільнення від сплати державного мита;</p>\r\n\r\n<p>4. документи, на підставі яких у паспорті проставляються відповідні відмітки;</p>\r\n\r\n<p>5. паспорт громадянина України для виїзду за кордон &ndash; для громадян, які постійно проживали за кордоном, після повернення їх на проживання в Україну;</p>\r\n\r\n<p>6. витяг з Єдиного&nbsp; реєстру досудових розслідувань (у разі викрадення паспорта).</p>\r\n', 1, '<p>П.п. а) п. 6 ст. 3 Декрету Кабінету Міністрів України &laquo;Про державне мито&raquo; від&nbsp;&nbsp; 21.01.1993 № 7-93</p>\r\n', '<p>Державне мито &ndash; 34 грн. (2 неоподаткованих мінімуми доходів громадян).</p>\r\n', '<p>---</p>\r\n', '<p>Не пізніше 30 (у деяких випадках 60) робочих днів з дати подання заявником необхідних документів.</p>\r\n', '<p>Неналежність особи до громадянства України, неможливість ідентифікації особи.</p>\r\n', '<p>Видача паспорта громадянина України.</p>\r\n', '<p>Звернутися до територіального підрозділу ДМС відповідно до місця проживання.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(114, 'Вклеювання до паспорта громадянина України фотокартки при досягненні 25- та 45- річного віку\r\n', 1, 19, '<ol>\r\n	<li>П. 7, 8 Положення про паспорт громадянина України, затвердженого Постановою Верховної Ради України &laquo;Про затвердження положень про паспорт громадянина України та про паспорт громадянина для виїзду за кордон&raquo; від 26.06.1992&nbsp;№ 2503-ХІІ</li>\r\n	<li>Наказ МВС &laquo;Про затвердження Порядку оформлення і видачі паспорта громадянина України&raquo; від 13.04.2012 № 320</li>\r\n</ol>\r\n', '<p>Досягнення 25- і 45- річного віку.</p>\r\n', '<p>Заявник для одержання адміністративної послуги звертається до територіального підрозділу ДМС відповідно до місця проживання.</p>\r\n', '<ol>\r\n	<li>Заява</li>\r\n	<li>2 фотокартки розміром 3,5 х 4,5 см.</li>\r\n	<li>Паспорт громадянина України.</li>\r\n</ol>\r\n', 0, '', '', '', '<p>Не пізніше 5 днів з дати подання заявником необхідних документів.</p>\r\n', '<p>Відсутність одного з документів, необхідних для отримання адміністративної послуги.</p>\r\n', '<p>Видача паспорта громадянина України.</p>\r\n', '<p>Звернутися до територіального підрозділу ДМС відповідно за місцем проживання.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(115, 'Реєстрація місця проживання / перебування\r\n', 1, 19, '<ol>\r\n	<li>Закон України &laquo;Про свободу пересування та вільний вибір місця проживання в Україні&raquo; від 11.12.2003 № 1382-ІV.</li>\r\n	<li>Наказ МВС &laquo;Про затвердження Порядку реєстрації місця проживання та місця перебування фізичних осіб в Україні та зразків необхідних документів&raquo; від 22.11.2012 № 1077.</li>\r\n</ol>\r\n', '<p>Заява особи або її законного представника.</p>\r\n', '<p>Заявник для одержання адміністративної послуги з оформлення реєстрації місця проживання / перебування звертається до територіального підрозділу ДМС &nbsp;або Центру надання адміністративних послуг Одеської міської ради відповідно до місця проживання.</p>\r\n', '<ol>\r\n	<li>Письмова заява.</li>\r\n	<li>Документ до якого вносяться відомості про місце проживання / перебування. Якщо дитина не досягла 16 річного віку, подається свідоцтво про народження;</li>\r\n	<li>Квитанція про сплату державного мита або документ про звільнення від його сплати;</li>\r\n	<li>Талон зняття з реєстрації (у разі зміни місця проживання в межах України).</li>\r\n	<li>Талон зняття з реєстрації не подається у разі оформлення реєстрації місця проживання з одночасним зняттям з реєстрації попереднього місця проживання;</li>\r\n	<li>Документи, що підтверджують право проживання в житлі, перебування або взяття на облік у спеціалізованій соціальній установі, закладі соціального обслуговування та соціального захисту, проходження служби у військовій частині, адреса яких зазначається під час реєстрації;</li>\r\n	<li>військовий квиток або посвідчення про приписку (для громадян, які підлягають взяттю на військовий облік або перебувають на військовому обліку)</li>\r\n</ol>\r\n\r\n<p>У разі подачі заяви законним представником додатково подаються:</p>\r\n\r\n<ol>\r\n	<li>Документ, що посвідчує особу законного представника,</li>\r\n	<li>Документ, що підтверджує повноваження особи як законного представника, крім випадків, коли законними представниками є батьки (усиновлювачі)</li>\r\n</ol>\r\n', 1, '<p>П.п. м) п. 6 ст. 3 Декрету Кабінету Міністрів України &laquo;Про державне мито&raquo; від 21.01.1993 № 7-93</p>\r\n', '<p>Державне мито &ndash; 0,85 грн (0,05 % неоподаткованих мінімумів доходів громадян).</p>\r\n', '<p>---</p>\r\n', '<p>Реєстрація місця проживання / перебування здійснюється в день подання особою документів.</p>\r\n', '<p>Відсутність одного з документів, необхідних для отримання адміністративної послуги.</p>\r\n', '<p><strong>Реєстрація місця проживання / перебування особи.</strong></p>\r\n\r\n<p><em>У разі звернення особи для реєстрації місця проживання більше чим через 10 днів після прибуття до нового місця&nbsp; проживання, до неї застосовуються заходи адміністративного впливу відповідно до статті 197 КУпАП (санкція &ndash; попередження або накладання штрафу від 1 до 3&nbsp; неоподаткованих мінімумів доходів громадян).</em></p>\r\n', '<p>Звернення до територіального підрозділу ДМС або центру надання адміністративних послуг відповідно до місця проживання.</p>\r\n\r\n<p>&nbsp;</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(116, 'Зняття з реєстрації місця проживання\r\n', 1, 19, '<ol>\r\n	<li>Закон України &laquo;Про свободу пересування та вільний вибір місця проживання в Україні&raquo; від 11.12.2003 № 1382-ІV.</li>\r\n	<li>Наказ МВС &laquo;Про затвердження Порядку реєстрації місця проживання та місця перебування фізичних осіб в Україні та зразків необхідних документів&raquo; від 22.11.2012 № 1077.</li>\r\n</ol>\r\n', '<p>Заява особи або її законного представника.</p>\r\n', '<p>Особа або її законний представник &nbsp;для одержання адміністративної послуги з оформлення зняття з звертається до територіального підрозділу ДМС &nbsp;або Центру надання адміністративних послуг Одеської міської ради відповідно до місця проживання.</p>\r\n', '<ol>\r\n	<li>Письмова заява;</li>\r\n	<li>Судове рішення, яке набрало законної сили, про позбавлення права власності на житлове приміщення або права користування житловим приміщенням, про виселення, про визнання особи безвісно відсутньою або оголошення її померлою;</li>\r\n	<li>Свідоцтво про смерть</li>\r\n	<li>Паспорт або паспортний документ, що надійшов з органу державної реєстрації актів цивільного стану, або документа про смерть, виданого компетентним органом іноземної держави, легалізованого в установленому порядку;</li>\r\n	<li>Інших документів, які свідчать про припинення:</li>\r\n</ol>\r\n\r\n<ul>\r\n	<li>підстав перебування на території України іноземців та осіб без громадянства;</li>\r\n	<li>підстав для проживання або перебування особи у спеціалізованій соціальній установі, закладі, соціального обслуговування та соціального захисту;</li>\r\n	<li>підстав на право користування житловим приміщенням</li>\r\n</ul>\r\n\r\n<p>&nbsp; &nbsp; &nbsp;6.&nbsp;Разом із заявою особа подає:</p>\r\n\r\n<ul>\r\n	<li>Документ, до якого вносяться відомості про зняття з реєстрації місця проживання. Якщо дитина не досягла 16-річного віку, подається свідоцтво про народження;</li>\r\n	<li>Військовий квиток або посвідчення про приписку (для громадян, які підлягають взяттю на військовий облік або перебувають на військовому обліку)</li>\r\n</ul>\r\n\r\n<p>&nbsp; &nbsp; 7. У разі подачі заяви законним представником особи додатково подаються:</p>\r\n\r\n<ul>\r\n	<li>Документ, що посвідчує особу законного представника;</li>\r\n	<li>Документ, що підтверджує повноваження особи як законного представника, крім випадків, коли законними представниками є батьки (усиновлювачі).</li>\r\n</ul>\r\n', 0, '', '', '', '<p>Зняття з реєстрації місця проживання здійснюється в день подання особою документі.</p>\r\n', '<p>Відсутність одного з документів, необхідних для отримання адміністративної послуги.</p>\r\n', '<p>Зняття з реєстрації місця проживання особи.</p>\r\n', '<p>Звернутися &nbsp;до територіального підрозділу ДМС або центру надання адміністративних послуг відповідно до місця проживання.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(117, 'Оформлення та видача або обмін паспорта громадянина України для виїзду за кордон\r\n', 1, 19, '<ol>\r\n	<li>Закон України &laquo;Про порядок виїзду з України і в&rsquo;їзду в Україну громадян України&raquo;&nbsp; від 21.01.1994 № 3857-ХІІ.</li>\r\n	<li>Положення про паспорт громадянина України для виїзду за кордон, затверджене Постановою Верховної Ради України 23.02.2007 № 719-V.</li>\r\n	<li>Правила оформлення та видачі паспорта громадянина України для виїзду за кордон і проїзного документа дитини, їх тимчасового затримання та вилучення, затверджені постановою Кабінету Міністрів України від 31 березня 1995 року № 231.</li>\r\n	<li>Порядок провадження за заявами про оформлення паспортів громадянина України для виїзду за кордон і проїзних документів дитини, затверджений Наказом МВС від 21.12.2004&nbsp; № 1603.</li>\r\n</ol>\r\n', '<p>Заява громадянина України.</p>\r\n', '<p>Заявник &nbsp;для одержання адміністративної послуги з оформлення зняття з реєстрації звертається до територіального органу (підрозділу) ДМС &nbsp;або Центру надання адміністративних послуг Одеської міської ради.&nbsp;</p>\r\n', '<ol>\r\n	<li>Заява-анкета встановленого зразка (заповнюється посадовою особою територіального органу (підрозділу) ДМС, адміністратором центру надання адміністративних послуг,</li>\r\n	<li>Паспорт громадянина України, свідоцтво про народження (для осіб віком до 16 років) (після прийняття документів повертається)</li>\r\n	<li>Копія документа про реєстрацію у Державному реєстрі фізичних осіб &ndash; платників податків, виданого органами державної податкової служби, крім осіб, які через свої релігійні або інші переконання відмовляються від прийняття ідентифікаційного номера та офіційно повідомляють про це відповідні державні органи,</li>\r\n	<li>Квитанція про сплату державного мита або документ, що підтверджує право на звільнення від його сплати,</li>\r\n	<li>Квитанцію про оплату інших передбачених законодавством платежів.&nbsp;</li>\r\n	<li>Особи віком від 18 до 25 років, які підлягають призову на строкову військову службу разом із заявою&nbsp; про оформлення паспорта подають довідку відповідного військового комісаріату щодо можливості виїзду з України.&nbsp;&nbsp;</li>\r\n</ol>\r\n', 1, '<ol>\r\n	<li>Декрет Кабінету Міністрів України &laquo;Про державне мито&raquo; від&nbsp;&nbsp; 21.01.1993 № 7.</li>\r\n	<li>Постанова Кабінету Міністрів України&nbsp; &laquo;Деякі питання надання підрозділами Міністерства внутрішніх справ та Державної міграційної служби&nbsp; платних послуг&raquo; від 26.10.2011 № 1098.</li>\r\n	<li>Постанова Кабінету Міністрів України&nbsp; &laquo;Про затвердження переліку платних послуг, які надаються підрозділами Міністерства внутрішніх справ та Державної міграційної служби і розміру плати за їх надання&raquo; від 04.06.2007 № 795.</li>\r\n</ol>\r\n', '<p>Державне мито &ndash; 10 неоподатковуваних мінімумів доходів громадян</p>\r\n\r\n<p>Розмір плати за надання послуги &ndash; 87,15 грн.</p>\r\n\r\n<p>Вартість бланка паспорта громадянина України для виїзду за кордон (визначається з урахуванням витрат, пов&rsquo;язаних з придбанням відповідної продукції, у тому числі вартості персоналізації).</p>\r\n', '<p>---</p>\r\n', '<p>Не пізніше 20 робочих днів з дати подання заявником необхідних документів.</p>\r\n', '<p>Громадянину може бути тимчасово відмовлено у разі, коли:&nbsp;</p>\r\n\r\n<ol>\r\n	<li>він обізнаний з відомостями, що становлять державну таємницю, - до закінчення строку, встановленого законом України &laquo;Про державну таємницю&raquo; (у разі виїзду за кордон на постійне проживання).</li>\r\n	<li>діють неврегульовані аліментні, договірні чи інші&nbsp; невиконані зобов&rsquo;язання, - до виконання зобов&rsquo;язань або зобов&rsquo;язання спору за погодженням сторін у передбачених законом випадках, чи забезпечення зобов&rsquo;язань заставою, якщо інше не передбачено міжнародним договором України;</li>\r\n	<li>стосовно нього в порядку, передбаченому кримінальним процесуальним законодавством, застосовано запобіжний захід, за умовами якого йому заборонено виїжджати за кордон, - до закінчення кримінального провадження або скасування відповідних обмежень;</li>\r\n	<li>він засуджений за вчинення кримінального правопорушення, - до відбуття покарання або звільнення</li>\r\n	<li>він ухиляється від виконання зобов&rsquo;язань, покладених на нього судовим рішенням, рішенням іншого органу (посадової особи), - до виконання зобов&rsquo;язань;</li>\r\n	<li>він свідомо сповістив про себе неправдиві відомості, - до з&rsquo;ясування причин і наслідків подання неправдивих відомостей;</li>\r\n	<li>він підлягає призову на строкову військову службу, - до вирішення питання про відстрочку від призову;</li>\r\n	<li>щодо нього подано цивільний позов до суду, - до закінчення провадження у справі;</li>\r\n	<li>він перебуває під адміністративним наглядом органів внутрішніх справ, -&nbsp; до припинення нагляду.&nbsp;</li>\r\n</ol>\r\n', '<p>Видача паспорта громадянину України для виїзду за кордон.</p>\r\n', '<p>Звернутися &nbsp;до територіального органу (підрозділу) ДМС або центру надання адміністративних послуг.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(118, 'Оформлення та видача проїзного документу дитини для виїзду за кордон\r\n', 1, 19, '<ol>\r\n	<li>Закон України &laquo;Про порядок виїзду з України і в&rsquo;їзду в Україну громадян України&raquo;&nbsp; від 21.01.1994 № 3857.</li>\r\n	<li>Положення про проїзний документ дитини, затверджене&nbsp; Указом Президента України від 07.09.1994 &nbsp;№ 503.</li>\r\n	<li>Правила оформлення та видачі паспорта громадянина України для виїзду за кордон і проїзного документа дитини, їх тимчасового затримання та вилучення, затверджені постановою Кабінету Міністрів України від &nbsp; 31.03. 1995 року № 231.</li>\r\n	<li>Порядок провадження за заявами про оформлення паспортів громадянина України для виїзду за кордон і проїзних документів дитини, затверджений Наказом МВС від 21.12.2004&nbsp; № 1603.</li>\r\n</ol>\r\n', '<p>Заява громадянина України.</p>\r\n', '<p>Заявник &nbsp;для одержання адміністративної послуги звертається до територіального органу (підрозділу) ДМС &nbsp;або Центру надання адміністративних послуг Одеської міської ради.&nbsp;</p>\r\n', '<ol>\r\n	<li>Заява-анкета встановленого зразка.</li>\r\n	<li>Нотаріальне засвідчене клопотання батьків або законних представників чи дітей</li>\r\n	<li>Паспорт громадянина України, свідоцтво про народження (для осіб віком до 16 років) (після прийняття документів повертається).</li>\r\n	<li>Копія документа про реєстрацію у Державному реєстрі фізичних осіб &ndash; платників податків, виданого органами державної податкової служби, крім осіб, які через свої релігійні або інші переконання відмовляються від прийняття ідентифікаційного номера та офіційно повідомляють про це відповідні державні органи.</li>\r\n	<li>Квитанції про оплату передбачених законодавством платежів.&nbsp;&nbsp;</li>\r\n</ol>\r\n', 1, '<ol>\r\n	<li>Постанова Кабінету Міністрів України&nbsp; &laquo;Деякі питання надання підрозділами Міністерства внутрішніх справ та Державної міграційної служби&nbsp; платних послуг&raquo; від 26.10.2011 № 1098.</li>\r\n	<li>Постанова Кабінету Міністрів України&nbsp; &laquo;Про затвердження переліку платних послуг, які надаються підрозділами Міністерства внутрішніх справ та Державної міграційної служби і розміру плати за їх надання&raquo; від 04.06.2007 № 795.</li>\r\n</ol>\r\n', '<p>Розмір плати за надання послуги &ndash; 30,35 грн, у разі надання послуги в строк до 10 днів &ndash; 60,70 грн.</p>\r\n\r\n<p>Вартість бланка &ndash; визначається з урахуванням витрат, пов&rsquo;язаних з придбанням бланкової продукції.</p>\r\n', '<p>---</p>\r\n', '<p>Не пізніше 30 календарних днів, у разі термінового надання&nbsp; послуги &ndash; 10 робочих днів.</p>\r\n', '<p>Громадянину (у разі досягнення 14 річного віку)&nbsp; може бути тимчасово відмовлено у разі, коли:</p>\r\n\r\n<ol>\r\n	<li>діють неврегульовані аліментні, договірні чи інші невиконані зобов&rsquo;язання, - до виконання зобов&rsquo;язань або розв&rsquo;язання спору за погодженням сторін у передбачених законом випадках, чи забезпечення зобов&rsquo;язань заставою, якщо інше не передбачено міжнародним договором України;</li>\r\n	<li>стосовно нього в порядку, передбаченому кримінальним процесуальним законодавством, застосовано запобіжний захід, за умовами якого йому заборонено виїжджати за кордон, - до закінчення кримінального провадження або скасування відповідних обмежень;</li>\r\n	<li>він засуджений за вчинення кримінального правопорушення, - до відбуття покарання або звільнення</li>\r\n	<li>він ухиляється від виконання зобов&rsquo;язань, покладених на нього судовим рішенням, рішенням іншого органу (посадової особи), - до виконання зобов&rsquo;язань;</li>\r\n	<li>він свідомо сповістив про себе неправдиві відомості, - до з&rsquo;ясування причин і наслідків подання неправдивих відомостей;</li>\r\n	<li>щодо нього подано цивільний позов до суду, - до закінчення провадження у справі;</li>\r\n	<li>він перебуває під адміністративним наглядом органів внутрішніх справ, -&nbsp; до припинення нагляду.&nbsp;</li>\r\n</ol>\r\n', '<p>Видача проїзного документу дитини для виїзду за кордон.</p>\r\n', '<p>Звернутися &nbsp;до територіального органу (підрозділу) ДМС або центру надання адміністративних послуг.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL),
(119, 'Внесення до Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців запису про рішення засновників (учасників) юридичної особи або уповноваженим ними органом щодо припинення юридичної особи\r\n', 17, 17, '<ol>\r\n	<li>Закон України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; (зі&nbsp; змінами&nbsp; та&nbsp; доповненнями)&nbsp;(статті 8, 34, 35).</li>\r\n	<li>Наказ Міністерства юстиції України від 17.04.2013 &nbsp;№ 730/5 &quot;Про затвердження форм заяв та повідомлень, надання (надсилання) яких встановлено Законом України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;, зареєстрований в Міністерстві юстиції України 24.04.2013 за № 671/23203.</li>\r\n</ol>\r\n', '<p>Звернення юридичної особи у зв&rsquo;язку із рішенням засновників (учасників) юридичної особи або уповноваженим ними органом щодо припинення юридичної особи.</p>\r\n', '<p>Документи подаються (надсилаються&nbsp; поштовим відправленням з&nbsp; описом&nbsp; вкладення) заявником.</p>\r\n', '<ol>\r\n	<li>Оригінал або нотаріально засвідчена копія рішення засновників (учасників) або уповноваженого ними&nbsp; органу щодо припинення юридичної особи.</li>\r\n	<li>&nbsp;Додатково подається:</li>\r\n</ol>\r\n\r\n<ul>\r\n	<li>Документ, який підтверджує одержання згоди відповідних державних органів на припинення юридичної особи &ndash; у випадках, встановлених законом.</li>\r\n</ul>\r\n\r\n<p><em>&nbsp;Якщо документи подаються особою, яка згідно з відомостями, внесеними до Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців, має право вчиняти юридичні дії від імені юридичної особи без&nbsp; довіреності,&nbsp; пред&#39;являється паспорт громадянина України або паспортний документ іноземця.</em></p>\r\n\r\n<p><em>Якщо документи подаються іншим представником юридичної особи пред&#39;являється паспорт громадянина України або&nbsp; паспортний&nbsp; документ іноземця та додатково подається примірник&nbsp; оригіналу&nbsp; (ксерокопія,&nbsp; нотаріально&nbsp; засвідчена копія) документа,&nbsp; що засвідчує повноваження такого представника.</em></p>\r\n', 0, '', '', '', '<p>Внесення до Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців запису про рішення&nbsp; засновників (учасників) юридичної особи або уповноваженого ними органу щодо припинення юридичної особи здійснюється у день надходження&nbsp; документів.</p>\r\n\r\n<p>Повідомлення про залишення без розгляду поданих документів видається не пізніше наступного робочого дня з дати надходження документів.&nbsp;</p>\r\n', '<p>&nbsp;</p>\r\n\r\n<ol>\r\n	<li>Документи подані за неналежним&nbsp; місцем&nbsp; проведення державної реєстрації&nbsp; припинення&nbsp; юридичної&nbsp; особи за рішенням засновників (учасників) юридичної особи або уповноваженого ними органу.</li>\r\n	<li>Документи не відповідають вимогам,&nbsp; які встановлені&nbsp; частиною першою статті 8 Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n	<li>Рішення щодо припинення юридичної особи&nbsp;&nbsp; оформлено з порушенням вимог, які встановлені частиною третьою статті 34 Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n	<li>Документи подані не у повному обсязі.</li>\r\n	<li>Рішення щодо припинення юридичної особи не&nbsp; містить відомостей про персональний склад комісії з припинення (комісії з реорганізації, ліквідаційної комісії), її голову або ліквідатора, реєстраційні&nbsp; номери&nbsp; облікових&nbsp; карток платників податків (або відомості&nbsp; про&nbsp; серію&nbsp; та&nbsp; номер паспорта громадянина України або паспортного документа іноземця - для фізичних осіб, які через свої релігійні переконання відмовилися від прийняття реєстраційного номера облікової картки платника&nbsp; податків та повідомили про це відповідний&nbsp; орган&nbsp; державної податкової служби і мають запис в електронному безконтактному носії паспорта громадянина України), про&nbsp; порядок&nbsp; або строк заявлення кредиторами своїх вимог або якщо такий&nbsp; строк&nbsp; не&nbsp; відповідає&nbsp; закону.&nbsp;&nbsp;</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Повідомлення про залишення&nbsp; документів без розгляду.</li>\r\n	<li>Внесення до Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців запису про рішення засновників (учасників) юридичної особи або уповноваженого ними органу щодо припинення&nbsp; юридичної&nbsp; особи.</li>\r\n</ol>\r\n', '<p>Повідомлення про залишення&nbsp; документів без розгляду разом з документами, що подавалися для внесення до Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців запису про рішення&nbsp; засновників (учасників) юридичної особи або уповноваженого ними органу щодо припинення юридичної особи видаються (надсилаються поштовим відправленням з описом вкладення) державним реєстратором заявнику.</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL);
INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`, `have_expertise`, `nes_expertise`, `is_payed_expertise`, `payed_expertise`, `regul_expertise`, `rate_expertise`, `bank_info_expertise`, `ff_link`) VALUES
(120, 'Внесення до Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців запису про втрату оригіналів установчих документів юридичної особи\r\n', 17, 17, '<ol>\r\n	<li>Закон України від 15.05.2003 № 755-IV &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot; (зі&nbsp; змінами&nbsp; та&nbsp; доповненнями)&nbsp;(статті 8, 19, 22).</li>\r\n	<li>Наказ Міністерства юстиції України від 17.04.2013 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;№ 730/5 &quot;Про затвердження форм заяв та повідомлень, надання (надсилання) яких встановлено Законом України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;, зареєстрований в Міністерстві юстиції України 24.04.2013 за № 671/23203.</li>\r\n</ol>\r\n', '<p>Звернення юридичної особи у зв&rsquo;язку із втратою оригіналів установчих документів.</p>\r\n', '<p>Документи подаються засновниками (учасниками) юридичної особи або уповноваженим ними органом чи особою.</p>\r\n', '<ol>\r\n	<li>Заява&nbsp; про&nbsp; втрату оригіналів установчих документів встановленого зразка.</li>\r\n	<li>Документ, що підтверджує внесення плати за&nbsp; публікацію&nbsp; у спеціальному&nbsp; друкованому&nbsp; засобі&nbsp; масової інформації повідомлення про втрату оригіналів установчих документів (копія&nbsp; квитанції або копія платіжного доручення з відміткою банку).</li>\r\n	<li>Довідка, видана органом внутрішніх справ, про реєстрацію заяви про втрату оригіналів установчих&nbsp; документів.</li>\r\n</ol>\r\n\r\n<p><em>Якщо документи подаються особою, яка згідно з відомостями, внесеними до Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців, має право вчиняти юридичні дії від імені юридичної особи без довіреності, додатково пред&#39;являється паспорт громадянина України або паспортний документ іноземця.</em></p>\r\n\r\n<p><em>Якщо документи&nbsp; подаються&nbsp; представником&nbsp;&nbsp; юридичної&nbsp;&nbsp; особи додатково пред&#39;являється&nbsp; паспорт громадянина&nbsp; України або паспортний документ іноземця та надається документ, що засвідчує повноваження представника.</em></p>\r\n\r\n<p>&nbsp;</p>\r\n', 1, '<p>---</p>\r\n', '<p>Справляється плата за публікацію повідомлення у спеціалізованому друкованому засобі масової інформації в розмірі трьох неоподатковуваних мінімумів доходів громадян (51 грн.).</p>\r\n', '<p>---</p>\r\n', '<p>Внесення до Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців запису про втрату оригіналів установчих документів юридичної особи здійснюється не пізніше наступного робочого дня з дати надходження заяви про&nbsp; втрату оригіналів установчих документів.</p>\r\n\r\n<p>Повідомлення про залишення заяви про втрату&nbsp; оригіналів установчих документів без розгляду видається не пізніше наступного робочого дня з дати надходження заяви про&nbsp; втрату оригіналів установчих документів.</p>\r\n', '<ol>\r\n	<li>Заява оформлена з порушенням вимог,&nbsp; встановлених&nbsp; частинами&nbsp; першою та другою статті 8 Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n	<li>До заяви не додаються документи, передбачені частиною п&rsquo;ятнадцятою статті 19 Закону України &quot;Про державну реєстрацію юридичних осіб та фізичних осіб &ndash; підприємців&quot;.</li>\r\n	<li>&nbsp;До державного реєстратора надійшло рішення суду щодо заборони проведення реєстраційних дій.&nbsp;</li>\r\n</ol>\r\n', '<ol>\r\n	<li>Повідомлення про залишення заяви про втрату&nbsp; оригіналів установчих документів без розгляду.</li>\r\n	<li>Внесення до Єдиного державного реєстру юридичних осіб та фізичних осіб &ndash; підприємців запису про втрату оригіналів установчих документів юридичної особи.</li>\r\n</ol>\r\n', '<p>Повідомлення про залишення заяви про втрату&nbsp; оригіналів установчих документів без розгляду видається (надсилається поштовим відправленням з описом вкладення) державним реєстратором заявнику.&nbsp;</p>\r\n', 'ні', 0, '', 0, '', '', '', '', NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `gen_status_description`
--

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
  ADD CONSTRAINT `t_author_id` FOREIGN KEY (`authorities_id`) REFERENCES `gen_authorities` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `t_role_id` FOREIGN KEY (`user_roles_id`) REFERENCES `cab_user_roles` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

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

--
-- Ограничения внешнего ключа таблицы `cab_user_files_out`
--
ALTER TABLE `cab_user_files_out`
  ADD CONSTRAINT `bid_id_out` FOREIGN KEY (`user_bid_id`) REFERENCES `gen_bid_current_status` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Ограничения внешнего ключа таблицы `cab_user_internal`
--
ALTER TABLE `cab_user_internal`
  ADD CONSTRAINT `author_id` FOREIGN KEY (`authorities_id`) REFERENCES `gen_authorities` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `role_id` FOREIGN KEY (`user_roles_id`) REFERENCES `cab_user_roles` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `ff_field`
--
ALTER TABLE `ff_field`
  ADD CONSTRAINT `fk_formid` FOREIGN KEY (`formid`) REFERENCES `ff_registry` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Ограничения внешнего ключа таблицы `ff_registry_storage`
--
ALTER TABLE `ff_registry_storage`
  ADD CONSTRAINT `fk_registry` FOREIGN KEY (`registry`) REFERENCES `ff_registry` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_storage` FOREIGN KEY (`storage`) REFERENCES `ff_storage` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Ограничения внешнего ключа таблицы `gen_authorities`
--
ALTER TABLE `gen_authorities`
  ADD CONSTRAINT `fk_locations` FOREIGN KEY (`locations_id`) REFERENCES `gen_locations` (`id`) ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `gen_cat_classes`
--
ALTER TABLE `gen_cat_classes`
  ADD CONSTRAINT `cat_id` FOREIGN KEY (`categorie_id`) REFERENCES `gen_serv_categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `class_id` FOREIGN KEY (`class_id`) REFERENCES `gen_serv_classes` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `gen_interview_result`
--
ALTER TABLE `gen_interview_result`
  ADD CONSTRAINT `question_id` FOREIGN KEY (`question_id`) REFERENCES `gen_interview_question` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `gen_other_info`
--
ALTER TABLE `gen_other_info`
  ADD CONSTRAINT `menu_info` FOREIGN KEY (`kind_of_publication`) REFERENCES `gen_menu_items` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `gen_serv_cat_class`
--
ALTER TABLE `gen_serv_cat_class`
  ADD CONSTRAINT `cat_class_id` FOREIGN KEY (`cat_class_id`) REFERENCES `gen_cat_classes` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `serv_id` FOREIGN KEY (`service_id`) REFERENCES `gen_services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `gen_serv_docum`
--
ALTER TABLE `gen_serv_docum`
  ADD CONSTRAINT `serv_docum` FOREIGN KEY (`service_id`) REFERENCES `gen_services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `gen_serv_life_situations`
--
ALTER TABLE `gen_serv_life_situations`
  ADD CONSTRAINT `life_situat` FOREIGN KEY (`life_situation_id`) REFERENCES `gen_life_situation` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `serv_live` FOREIGN KEY (`service_id`) REFERENCES `gen_services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `gen_serv_regulations`
--
ALTER TABLE `gen_serv_regulations`
  ADD CONSTRAINT `serv_reg` FOREIGN KEY (`service_id`) REFERENCES `gen_services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `gen_services`
--
ALTER TABLE `gen_services`
  ADD CONSTRAINT `id_i` FOREIGN KEY (`subjnap_id`) REFERENCES `gen_authorities` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `id_sub` FOREIGN KEY (`subjwork_id`) REFERENCES `gen_authorities` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
