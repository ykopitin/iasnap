# SQL Manager Lite for MySQL 5.4.3.43929
# ---------------------------------------
# Host     : localhost
# Port     : 3306
# Database : cnap_portal


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

SET FOREIGN_KEY_CHECKS=0;

USE `cnap_portal`;

#
# Удаление объектов БД
#

DROP VIEW IF EXISTS `ff_listtables`;
DROP PROCEDURE IF EXISTS `FF_SYNCDATA`;
DROP PROCEDURE IF EXISTS `FF_RSINIT`;
DROP PROCEDURE IF EXISTS `FF_RSCLEAR`;
DROP PROCEDURE IF EXISTS `FF_INITID`;
DROP PROCEDURE IF EXISTS `FF_HELPER_SYNCDATA_DELETE`;
DROP PROCEDURE IF EXISTS `FF_HELPER_SYNCDATA`;
DROP PROCEDURE IF EXISTS `FF_HELPER_SYNCDATA_UPDATE`;
DROP PROCEDURE IF EXISTS `FF_DELTBL`;
DROP PROCEDURE IF EXISTS `FF_CRTTBL`;
DROP PROCEDURE IF EXISTS `FF_AU_FIELD`;
DROP PROCEDURE IF EXISTS `FF_BD_FIELD`;
DROP PROCEDURE IF EXISTS `FF_ALTTBL`;
DROP PROCEDURE IF EXISTS `FF_HELPER_ALTTBL`;
DROP PROCEDURE IF EXISTS `FF_AI_FIELD`;
DROP FUNCTION IF EXISTS `FF_isParent`;

DROP TABLE IF EXISTS `ff_types`;
DROP TABLE IF EXISTS `ff_route_node`;
DROP TABLE IF EXISTS `ff_route_for_user`;
DROP TABLE IF EXISTS `ff_route_for_role`;
DROP TABLE IF EXISTS `ff_route_folder`;
DROP TABLE IF EXISTS `ff_route_cabinet_for_users`;
DROP TABLE IF EXISTS `ff_route_cabinet_for_role`;
DROP TABLE IF EXISTS `ff_route_cabinet`;
DROP TABLE IF EXISTS `ff_route_action_for_user`;
DROP TABLE IF EXISTS `ff_route_action_for_role`;
DROP TABLE IF EXISTS `ff_route_action`;
DROP TABLE IF EXISTS `ff_route`;
DROP TABLE IF EXISTS `ff_registry_storage`;
DROP TABLE IF EXISTS `ff_storage`;
DROP TABLE IF EXISTS `ff_registry_h`;
DROP TABLE IF EXISTS `ff_ref_multiguide`;
DROP TABLE IF EXISTS `ff_oneline`;
DROP TABLE IF EXISTS `ff_field`;
DROP TABLE IF EXISTS `ff_registry`;
DROP TABLE IF EXISTS `ff_document_rkk`;
DROP TABLE IF EXISTS `ff_document_demo`;
DROP TABLE IF EXISTS `ff_document_base`;
DROP TABLE IF EXISTS `ff_default`;
DROP TABLE IF EXISTS `ff_commentline`;
DROP TABLE IF EXISTS `ff_available_nodes_for_users`;
DROP TABLE IF EXISTS `ff_available_nodes_for_roles`;
DROP TABLE IF EXISTS `ff_available_nodes`;
DROP TABLE IF EXISTS `ff_available_actions_for_users`;
DROP TABLE IF EXISTS `ff_available_actions_for_roles`;
DROP TABLE IF EXISTS `ff_available_actions`;

#
# Структура для таблицы `ff_available_actions`: 
#

CREATE TABLE `ff_available_actions` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 21,
  `storage` INTEGER(11) DEFAULT NULL,
  `action` BIGINT(20) DEFAULT NULL,
  `node` BIGINT(20) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
AVG_ROW_LENGTH=147 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_available_actions_for_roles`: 
#

CREATE TABLE `ff_available_actions_for_roles` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 22,
  `storage` INTEGER(11) DEFAULT NULL,
  `action` BIGINT(20) DEFAULT NULL,
  `node` BIGINT(20) DEFAULT NULL,
  `roles` INTEGER(11) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_available_actions_for_users`: 
#

CREATE TABLE `ff_available_actions_for_users` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 23,
  `storage` INTEGER(11) DEFAULT NULL,
  `action` BIGINT(20) DEFAULT NULL,
  `node` BIGINT(20) DEFAULT NULL,
  `users` INTEGER(11) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_available_nodes`: 
#

CREATE TABLE `ff_available_nodes` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 16,
  `storage` INTEGER(11) DEFAULT NULL,
  `node` BIGINT(20) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
AVG_ROW_LENGTH=132 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_available_nodes_for_roles`: 
#

CREATE TABLE `ff_available_nodes_for_roles` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 18,
  `storage` INTEGER(11) DEFAULT NULL,
  `node` BIGINT(20) DEFAULT NULL,
  `roles` INTEGER(11) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_available_nodes_for_users`: 
#

CREATE TABLE `ff_available_nodes_for_users` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 17,
  `storage` INTEGER(11) DEFAULT NULL,
  `node` BIGINT(20) DEFAULT NULL,
  `users` INTEGER(11) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_commentline`: 
#

CREATE TABLE `ff_commentline` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) DEFAULT NULL,
  `storage` INTEGER(11) DEFAULT NULL,
  `name` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `comment` TEXT COLLATE utf8_general_ci,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_default`: 
#

CREATE TABLE `ff_default` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `registry` INTEGER(11) NOT NULL COMMENT 'Ссылка на регистрацию(таблица которой принадлижит запись)',
  `storage` INTEGER(11) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT '',
   INDEX `FK_REGISTRY_idx` USING BTREE (`registry`) COMMENT ''
)ENGINE=InnoDB
AUTO_INCREMENT=781 AVG_ROW_LENGTH=66 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT='Корневая родительская форма. Ее наследуют все другие таблицы сформированые при помощи свободных форм '
;

#
# Структура для таблицы `ff_document_base`: 
#

CREATE TABLE `ff_document_base` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 13,
  `storage` INTEGER(11) DEFAULT NULL,
  `createdate` DATETIME DEFAULT NULL,
  `route` INTEGER(11) DEFAULT NULL,
  `nodes` INTEGER(11) DEFAULT NULL,
  `available_nodes` INTEGER(11) DEFAULT NULL,
  `available_actions` INTEGER(11) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
AVG_ROW_LENGTH=356 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_document_demo`: 
#

CREATE TABLE `ff_document_demo` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 14,
  `storage` INTEGER(11) DEFAULT NULL,
  `createdate` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `creditor` TEXT COLLATE utf8_general_ci,
  `route` INTEGER(11) DEFAULT NULL,
  `nodes` INTEGER(11) DEFAULT NULL,
  `available_nodes` INTEGER(11) DEFAULT NULL,
  `available_actions` INTEGER(11) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
AVG_ROW_LENGTH=315 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_document_rkk`: 
#

CREATE TABLE `ff_document_rkk` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 24,
  `storage` INTEGER(11) DEFAULT NULL,
  `createdate` DATETIME DEFAULT NULL,
  `route` INTEGER(11) DEFAULT NULL,
  `available_nodes` INTEGER(11) DEFAULT NULL,
  `available_actions` INTEGER(11) DEFAULT NULL,
  `regnum` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `regdate` DATE DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
AVG_ROW_LENGTH=16384 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_registry`: 
#

CREATE TABLE `ff_registry` (
  `id` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `parent` INTEGER(11) DEFAULT NULL COMMENT 'ссылка на родителя',
  `tablename` VARCHAR(45) COLLATE utf8_general_ci NOT NULL COMMENT 'Имя таблицы в которая используется для хранения данных свободной формы',
  `description` TINYTEXT COLLATE utf8_general_ci COMMENT 'описание',
  `protected` TINYINT(4) NOT NULL DEFAULT 0 COMMENT 'Блокировка/ системная таблица',
  `attaching` TINYINT(4) NOT NULL DEFAULT 0 COMMENT 'равен 1 если таблица создана не методами свободных форм',
  `copying` TINYINT(4) NOT NULL DEFAULT 0 COMMENT 'При 1 потомки копируют свои значения в эту таблицу',
  `view` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Зарезирвированно, предполагается через этот параметр подключать разные формы отображения документов',
  PRIMARY KEY USING BTREE (`id`) COMMENT '',
  UNIQUE INDEX `table_UNIQUE` USING BTREE (`tablename`) COMMENT '',
   INDEX `parent` USING BTREE (`parent`) COMMENT ''
)ENGINE=InnoDB
AUTO_INCREMENT=29 AVG_ROW_LENGTH=585 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT='Список зарегистрированных свободных форм'
;

#
# Структура для таблицы `ff_field`: 
#

CREATE TABLE `ff_field` (
  `id` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `formid` INTEGER(11) DEFAULT 1 COMMENT 'Ссылка на свободную форму',
  `name` VARCHAR(255) COLLATE utf8_general_ci NOT NULL COMMENT 'Имя поля свободнеой формы',
  `type` INTEGER(11) DEFAULT NULL COMMENT 'Тип поля в  свободной форме',
  `description` TINYTEXT COLLATE utf8_general_ci COMMENT 'Описание / назначение поля',
  `order` INTEGER(10) NOT NULL DEFAULT 0 COMMENT 'Порядок отображения полей. При 0 поле скрытое',
  `protected` TINYINT(4) NOT NULL DEFAULT 0 COMMENT 'Блокировка для защиты от несанкционированного удаления и/или изменения поля',
  `default` TINYTEXT COLLATE utf8_general_ci COMMENT 'Значение поля по-умолчанию',
  PRIMARY KEY USING BTREE (`id`) COMMENT '',
   INDEX `id_idx` USING BTREE (`formid`) COMMENT '',
   INDEX `FK_TYPE_idx` USING BTREE (`type`) COMMENT '',
  CONSTRAINT `fk_formid` FOREIGN KEY (`formid`) REFERENCES `ff_registry` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
)ENGINE=InnoDB
AUTO_INCREMENT=186 AVG_ROW_LENGTH=124 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT='Список полей подключенных в свобных формах'
;

#
# Структура для таблицы `ff_oneline`: 
#

CREATE TABLE `ff_oneline` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) DEFAULT NULL,
  `storage` INTEGER(11) DEFAULT NULL,
  `name` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
AVG_ROW_LENGTH=481 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_ref_multiguide`: 
#

CREATE TABLE `ff_ref_multiguide` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) DEFAULT NULL,
  `storage` INTEGER(11) DEFAULT NULL,
  `order` INTEGER(11) DEFAULT NULL,
  `owner` BIGINT(20) DEFAULT NULL,
  `owner_field` INTEGER(11) DEFAULT NULL,
  `reference` BIGINT(20) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
AVG_ROW_LENGTH=87 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_registry_h`: 
#

CREATE TABLE `ff_registry_h` (
  `id` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `owner` INTEGER(11) NOT NULL COMMENT 'Основная таблица',
  `parent` INTEGER(11) NOT NULL COMMENT 'Родители основной талицы',
  PRIMARY KEY USING BTREE (`id`) COMMENT '',
   INDEX `fk_parent_idx` USING BTREE (`parent`) COMMENT ''
)ENGINE=InnoDB
AUTO_INCREMENT=108 AVG_ROW_LENGTH=199 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT='Иерархия(вспомогательная таблиц'
;

#
# Структура для таблицы `ff_storage`: 
#

CREATE TABLE `ff_storage` (
  `id` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) COLLATE utf8_general_ci NOT NULL COMMENT 'Имя хранилища',
  `description` TINYTEXT COLLATE utf8_general_ci COMMENT 'Описание хранилища',
  `subtype` INTEGER(11) NOT NULL DEFAULT 0 COMMENT 'Подтип. Используется для отображения разных справочников',
  `type` INTEGER(11) DEFAULT NULL COMMENT 'Ссылка на таблицу типов',
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
AUTO_INCREMENT=15 AVG_ROW_LENGTH=1260 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT='Хранилище свободной формы'
;

#
# Структура для таблицы `ff_registry_storage`: 
#

CREATE TABLE `ff_registry_storage` (
  `id` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `registry` INTEGER(11) NOT NULL COMMENT 'Ссылка на регистрацию свободной формы',
  `storage` INTEGER(11) NOT NULL COMMENT 'Ссылка на хранилище в свободной форме',
  PRIMARY KEY USING BTREE (`id`) COMMENT '',
   INDEX `fk_registry_idx` USING BTREE (`registry`) COMMENT '',
   INDEX `fk_storage_idx` USING BTREE (`storage`) COMMENT '',
  CONSTRAINT `fk_registry` FOREIGN KEY (`registry`) REFERENCES `ff_registry` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_storage` FOREIGN KEY (`storage`) REFERENCES `ff_storage` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
)ENGINE=InnoDB
AUTO_INCREMENT=48 AVG_ROW_LENGTH=655 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT='Привязка форм и хранилищ'
;

#
# Структура для таблицы `ff_route`: 
#

CREATE TABLE `ff_route` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 7,
  `storage` INTEGER(11) DEFAULT NULL,
  `name` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `comment` TEXT COLLATE utf8_general_ci,
  `start_route` INTEGER(11) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_route_action`: 
#

CREATE TABLE `ff_route_action` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 5,
  `storage` INTEGER(11) DEFAULT NULL,
  `name` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `comment` TEXT COLLATE utf8_general_ci,
  `gotonodes` INTEGER(11) DEFAULT NULL,
  `clearnodes` INTEGER(11) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
AVG_ROW_LENGTH=2048 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_route_action_for_role`: 
#

CREATE TABLE `ff_route_action_for_role` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 25,
  `storage` INTEGER(11) DEFAULT NULL,
  `name` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `comment` TEXT COLLATE utf8_general_ci,
  `gotonodes` INTEGER(11) DEFAULT NULL,
  `clearnodes` INTEGER(11) DEFAULT NULL,
  `setroles` INTEGER(11) DEFAULT NULL,
  `roles` INTEGER(11) DEFAULT NULL,
  `currentrole` TINYINT(4) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_route_action_for_user`: 
#

CREATE TABLE `ff_route_action_for_user` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 26,
  `storage` INTEGER(11) DEFAULT NULL,
  `name` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `comment` TEXT COLLATE utf8_general_ci,
  `gotonodes` INTEGER(11) DEFAULT NULL,
  `clearnodes` INTEGER(11) DEFAULT NULL,
  `setusers` INTEGER(11) DEFAULT NULL,
  `users` INTEGER(11) DEFAULT NULL,
  `currentuser` TINYINT(4) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_route_cabinet`: 
#

CREATE TABLE `ff_route_cabinet` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 9,
  `storage` INTEGER(11) DEFAULT NULL,
  `name` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `comment` TEXT COLLATE utf8_general_ci,
  `folders` INTEGER(11) DEFAULT NULL,
  `role` INTEGER(11) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
AVG_ROW_LENGTH=8192 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_route_cabinet_for_role`: 
#

CREATE TABLE `ff_route_cabinet_for_role` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 12,
  `storage` INTEGER(11) DEFAULT NULL,
  `name` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `comment` TEXT COLLATE utf8_general_ci,
  `folders` INTEGER(11) DEFAULT NULL,
  `role` INTEGER(11) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
AVG_ROW_LENGTH=8192 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_route_cabinet_for_users`: 
#

CREATE TABLE `ff_route_cabinet_for_users` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 15,
  `storage` INTEGER(11) DEFAULT NULL,
  `name` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `comment` TEXT COLLATE utf8_general_ci,
  `folders` INTEGER(11) DEFAULT NULL,
  `users` INTEGER(11) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_route_folder`: 
#

CREATE TABLE `ff_route_folder` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 8,
  `storage` INTEGER(11) DEFAULT NULL,
  `name` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `comment` TEXT COLLATE utf8_general_ci,
  `nodes` INTEGER(11) DEFAULT NULL,
  `allow_new` INTEGER(11) DEFAULT NULL,
  `allow_edit` INTEGER(11) DEFAULT NULL,
  `allow_delete` INTEGER(11) DEFAULT NULL,
  `visual_names` TEXT COLLATE utf8_general_ci,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
AVG_ROW_LENGTH=1489 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_route_for_role`: 
#

CREATE TABLE `ff_route_for_role` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 27,
  `storage` INTEGER(11) DEFAULT NULL,
  `name` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `comment` TEXT COLLATE utf8_general_ci,
  `start_route` INTEGER(11) DEFAULT NULL,
  `roles` INTEGER(11) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_route_for_user`: 
#

CREATE TABLE `ff_route_for_user` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 28,
  `storage` INTEGER(11) DEFAULT NULL,
  `name` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `comment` TEXT COLLATE utf8_general_ci,
  `start_route` INTEGER(11) DEFAULT NULL,
  `users` INTEGER(11) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_route_node`: 
#

CREATE TABLE `ff_route_node` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 6,
  `storage` INTEGER(11) DEFAULT NULL,
  `name` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `comment` TEXT COLLATE utf8_general_ci,
  `allow_action` INTEGER(11) DEFAULT NULL,
  `deny_action` INTEGER(11) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
AVG_ROW_LENGTH=1489 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_types`: 
#

CREATE TABLE `ff_types` (
  `id` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `typename` VARCHAR(255) COLLATE utf8_general_ci NOT NULL COMMENT 'Имя типа отображаемого в свободной форме',
  `systemtype` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Имя типа используемого для генерации таблиц',
  `view` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Путь к визуальному представлению типа',
  `description` TINYTEXT COLLATE utf8_general_ci COMMENT 'Описание',
  `visible` TINYINT(4) NOT NULL DEFAULT 1 COMMENT 'Признак отображения типа в списке типов',
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
AUTO_INCREMENT=1014 AVG_ROW_LENGTH=862 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT='Список зарегистрированных типов'
;


#
# Definition for the `FF_isParent` function : 
#

DELIMITER $$

CREATE DEFINER = 'iasnap'@'%' FUNCTION `FF_isParent`(
        `IDREGISTRY1` INTEGER,
        `IDREGISTRY2` INTEGER
    )
    RETURNS INTEGER(11)
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
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

#
# Определение для процедуры `FF_AI_FIELD`: 
#

DELIMITER $$

CREATE DEFINER = 'iasnap'@'%' PROCEDURE `FF_AI_FIELD`(
        IN `ID` INTEGER
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
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

DELIMITER ;

#
# Определение для процедуры `FF_HELPER_ALTTBL`: 
#

DELIMITER $$

CREATE DEFINER = 'iasnap'@'%' PROCEDURE `FF_HELPER_ALTTBL`(
        IN `IDREGISTRY` INTEGER,
        OUT `STMT` VARCHAR(4000)
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT 'Вспомоготельная ХП для FF_ALTTBL. Формирует необходимый запрос для изменения талиц.'
BEGIN
DECLARE done INT DEFAULT FALSE;
DECLARE VSTMTPIACE VARCHAR(200);
DECLARE cur1 CURSOR FOR	select sq from (
	select ff_cn, ff_tp, is_cn, is_tp,
		case 
			when (ff_cn = is_cn) and (ff_tp <> is_tp) then CONCAT(' MODIFY `', ff_cn, '` ', ff_tp,' DEFAULT ', if((ff_df is null) or (lower(ff_df)='null') or (ff_df=''), 'NULL', ff_df))
			when (ff_cn is null) then CONCAT(' DROP `', is_cn,'`')
			when (is_cn is null) then CONCAT(' ADD `', ff_cn, '` ', ff_tp,' DEFAULT ', if((ff_df is null) or (lower(ff_df)='null') or (ff_df=''), 'NULL', ff_df))
			else null
-- CONCAT(' MODIFY `', ff_cn, '` ', ff_tp,' DEFAULT ', if((ff_df is null) or (lower(ff_df)='null') or (ff_df=''), 'NULL', ff_df))
		end sq
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

#
# Определение для процедуры `FF_ALTTBL`: 
#

DELIMITER $$

CREATE DEFINER = 'iasnap'@'%' PROCEDURE `FF_ALTTBL`(
        IN `IDREGISTRY` INTEGER
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
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

#
# Определение для процедуры `FF_BD_FIELD`: 
#

DELIMITER $$

CREATE DEFINER = 'iasnap'@'%' PROCEDURE `FF_BD_FIELD`(
        IN `ID` INTEGER
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
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

DELIMITER ;

#
# Определение для процедуры `FF_AU_FIELD`: 
#

DELIMITER $$

CREATE DEFINER = 'iasnap'@'%' PROCEDURE `FF_AU_FIELD`(
        IN `ID` INTEGER
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
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

DELIMITER ;

#
# Определение для процедуры `FF_CRTTBL`: 
#

DELIMITER $$

CREATE DEFINER = 'iasnap'@'%' PROCEDURE `FF_CRTTBL`(
        IN `IDREGISTRY` INTEGER
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
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

#
# Определение для процедуры `FF_DELTBL`: 
#

DELIMITER $$

CREATE DEFINER = 'iasnap'@'%' PROCEDURE `FF_DELTBL`(
        IN `IDREGISTRY` INTEGER
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
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

#
# Определение для процедуры `FF_HELPER_SYNCDATA_UPDATE`: 
#

DELIMITER $$

CREATE DEFINER = 'iasnap'@'%' PROCEDURE `FF_HELPER_SYNCDATA_UPDATE`(
        IN `IDFROM` INTEGER,
        IN `IDREGISTRYTO` INTEGER,
        IN `TABLENAMEFROM` VARCHAR(45),
        IN `TABLENAMETO` VARCHAR(45),
        OUT `BUILDQUERY` VARCHAR(4000)
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
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

#
# Определение для процедуры `FF_HELPER_SYNCDATA`: 
#

DELIMITER $$

CREATE DEFINER = 'iasnap'@'%' PROCEDURE `FF_HELPER_SYNCDATA`(
        IN `IDFROM` INTEGER,
        IN `IDREGISTRYFROM` INTEGER,
        IN `TABLENAMEFROM` VARCHAR(45)
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
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

#
# Определение для процедуры `FF_HELPER_SYNCDATA_DELETE`: 
#

DELIMITER $$

CREATE DEFINER = 'iasnap'@'%' PROCEDURE `FF_HELPER_SYNCDATA_DELETE`(
        IN `ID` BIGINT
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
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

DELIMITER ;

#
# Определение для процедуры `FF_INITID`: 
#

DELIMITER $$

CREATE DEFINER = 'iasnap'@'%' PROCEDURE `FF_INITID`(
        IN `IDREGISTRY` INTEGER,
        IN `IDSTORAGE` INTEGER,
        OUT `ID` BIGINT(20)
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
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

#
# Определение для процедуры `FF_RSCLEAR`: 
#

DELIMITER $$

CREATE DEFINER = 'iasnap'@'%' PROCEDURE `FF_RSCLEAR`(
        IN `IDSTORAGE` INTEGER
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT 'Предварительная очистка привязок СФ к хранилищам'
BEGIN
	DELETE FROM `ff_registry_storage` where (`storage`=IDSTORAGE);
END$$

DELIMITER ;

#
# Определение для процедуры `FF_RSINIT`: 
#

DELIMITER $$

CREATE DEFINER = 'iasnap'@'%' PROCEDURE `FF_RSINIT`(
        IN `IDREGISTRY` INTEGER,
        IN `IDSTORAGE` INTEGER
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT 'Для регистрации СФ в хранилищах'
BEGIN
	INSERT INTO `ff_registry_storage` (`registry`, `storage`)
	VALUE (IDREGISTRY,IDSTORAGE);
END$$

DELIMITER ;

#
# Определение для процедуры `FF_SYNCDATA`: 
#

DELIMITER $$

CREATE DEFINER = 'iasnap'@'%' PROCEDURE `FF_SYNCDATA`(
        IN `ID` BIGINT
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
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

#
# Определение для представления `ff_listtables`: 
#

CREATE ALGORITHM=UNDEFINED DEFINER='iasnap'@'%' SQL SECURITY DEFINER VIEW `ff_listtables`
AS
select 
    lower(`information_schema`.`tables`.`TABLE_NAME`) AS `TABLE_NAME` 
  from 
    `information_schema`.`tables` 
  where 
    (`information_schema`.`tables`.`TABLE_SCHEMA` = database()) 
  order by 
    `information_schema`.`tables`.`TABLE_NAME`;

#
# Data for the `ff_available_actions` table  (LIMIT -388,500)
#

INSERT INTO `ff_available_actions` (`id`, `registry`, `storage`, `action`, `node`) VALUES

  (227,21,14,34,22),
  (234,21,14,34,22),
  (240,21,14,34,22),
  (258,21,14,34,22),
  (264,21,14,34,22),
  (273,21,14,34,22),
  (337,21,14,34,22),
  (341,21,14,37,23),
  (343,21,14,37,25),
  (345,21,14,34,22),
  (353,21,14,37,25),
  (355,21,14,37,23),
  (357,21,14,37,25),
  (359,21,14,34,22),
  (379,21,14,42,26),
  (380,21,14,47,26),
  (382,21,14,37,25),
  (384,21,14,37,23),
  (386,21,14,37,25),
  (388,21,14,34,22),
  (401,21,14,42,26),
  (402,21,14,47,26),
  (404,21,14,37,25),
  (406,21,14,37,23),
  (408,21,14,37,25),
  (410,21,14,34,22),
  (423,21,14,42,26),
  (424,21,14,47,26),
  (426,21,14,37,25),
  (428,21,14,37,23),
  (430,21,14,37,25),
  (432,21,14,34,22),
  (446,21,14,57,30),
  (448,21,14,42,26),
  (449,21,14,47,26),
  (451,21,14,37,25),
  (453,21,14,37,23),
  (455,21,14,37,25),
  (457,21,14,34,22),
  (473,21,14,57,30),
  (476,21,14,57,30),
  (478,21,14,42,26),
  (479,21,14,47,26),
  (481,21,14,37,25),
  (483,21,14,37,23),
  (485,21,14,37,25),
  (487,21,14,34,22),
  (506,21,14,51,28),
  (508,21,14,57,30),
  (511,21,14,57,30),
  (513,21,14,42,26),
  (514,21,14,47,26),
  (516,21,14,37,25),
  (518,21,14,37,23),
  (520,21,14,37,25),
  (522,21,14,34,22),
  (543,21,14,51,28),
  (546,21,14,51,28),
  (548,21,14,57,30),
  (551,21,14,57,30),
  (553,21,14,42,26),
  (554,21,14,47,26),
  (556,21,14,37,25),
  (558,21,14,37,23),
  (560,21,14,37,25),
  (562,21,14,34,22),
  (585,21,14,51,28),
  (588,21,14,51,28),
  (590,21,14,57,30),
  (593,21,14,57,30),
  (595,21,14,42,26),
  (596,21,14,47,26),
  (598,21,14,37,25),
  (600,21,14,37,23),
  (602,21,14,37,25),
  (604,21,14,34,22),
  (627,21,14,51,28),
  (630,21,14,51,28),
  (632,21,14,57,30),
  (635,21,14,57,30),
  (637,21,14,42,26),
  (638,21,14,47,26),
  (640,21,14,37,25),
  (642,21,14,37,23),
  (644,21,14,37,25),
  (646,21,14,34,22),
  (670,21,14,34,22),
  (674,21,14,37,23),
  (676,21,14,37,25),
  (678,21,14,34,22),
  (689,21,14,37,25),
  (691,21,14,37,23),
  (693,21,14,37,25),
  (695,21,14,34,22),
  (706,21,14,34,22),
  (710,21,14,37,23),
  (712,21,14,37,25),
  (714,21,14,34,22),
  (727,21,14,37,25),
  (729,21,14,37,23),
  (731,21,14,37,25),
  (740,21,14,34,22),
  (744,21,14,37,23),
  (746,21,14,37,25),
  (752,21,14,42,26),
  (753,21,14,47,26),
  (755,21,14,37,23),
  (763,21,14,34,22),
  (768,21,14,34,22),
  (773,21,14,34,22),
  (778,21,14,34,22);
COMMIT;

#
# Data for the `ff_available_nodes` table  (LIMIT -375,500)
#

INSERT INTO `ff_available_nodes` (`id`, `registry`, `storage`, `node`) VALUES

  (165,16,11,22),
  (167,16,11,22),
  (170,16,11,22),
  (177,16,11,22),
  (181,16,11,22),
  (184,16,11,22),
  (187,16,11,22),
  (190,16,11,22),
  (193,16,11,22),
  (196,16,11,22),
  (199,16,11,22),
  (202,16,11,22),
  (205,16,11,22),
  (208,16,11,22),
  (214,16,11,22),
  (216,16,11,22),
  (219,16,11,22),
  (223,16,11,22),
  (226,16,11,22),
  (233,16,11,22),
  (237,16,11,23),
  (238,16,11,25),
  (239,16,11,22),
  (242,16,11,25),
  (243,16,11,23),
  (245,16,11,23),
  (246,16,11,25),
  (248,16,11,25),
  (249,16,11,23),
  (252,16,11,25),
  (253,16,11,23),
  (257,16,11,22),
  (261,16,11,23),
  (262,16,11,25),
  (263,16,11,22),
  (269,16,11,25),
  (270,16,11,23),
  (271,16,11,25),
  (272,16,11,22),
  (336,16,11,22),
  (340,16,11,23),
  (342,16,11,25),
  (344,16,11,22),
  (354,16,11,23),
  (358,16,11,22),
  (378,16,11,26),
  (383,16,11,23),
  (387,16,11,22),
  (400,16,11,26),
  (405,16,11,23),
  (409,16,11,22),
  (425,16,11,25),
  (427,16,11,23),
  (429,16,11,25),
  (431,16,11,22),
  (444,16,11,27),
  (445,16,11,30),
  (450,16,11,25),
  (452,16,11,23),
  (454,16,11,25),
  (456,16,11,22),
  (472,16,11,30),
  (474,16,11,27),
  (475,16,11,30),
  (480,16,11,25),
  (484,16,11,25),
  (486,16,11,22),
  (504,16,11,24),
  (505,16,11,28),
  (507,16,11,30),
  (509,16,11,27),
  (510,16,11,30),
  (515,16,11,25),
  (519,16,11,25),
  (521,16,11,22),
  (542,16,11,28),
  (544,16,11,24),
  (545,16,11,28),
  (547,16,11,30),
  (549,16,11,27),
  (550,16,11,30),
  (555,16,11,25),
  (559,16,11,25),
  (561,16,11,22),
  (584,16,11,28),
  (586,16,11,24),
  (587,16,11,28),
  (589,16,11,30),
  (591,16,11,27),
  (592,16,11,30),
  (597,16,11,25),
  (599,16,11,23),
  (601,16,11,25),
  (603,16,11,22),
  (626,16,11,28),
  (628,16,11,24),
  (629,16,11,28),
  (631,16,11,30),
  (633,16,11,27),
  (634,16,11,30),
  (636,16,11,26),
  (639,16,11,25),
  (641,16,11,23),
  (643,16,11,25),
  (645,16,11,22),
  (669,16,11,22),
  (673,16,11,23),
  (675,16,11,25),
  (688,16,11,25),
  (690,16,11,23),
  (692,16,11,25),
  (694,16,11,22),
  (709,16,11,23),
  (711,16,11,25),
  (726,16,11,25),
  (728,16,11,23),
  (730,16,11,25),
  (743,16,11,23),
  (751,16,11,26),
  (754,16,11,23),
  (762,16,11,22),
  (767,16,11,22),
  (772,16,11,22),
  (777,16,11,22);
COMMIT;

#
# Data for the `ff_default` table  (LIMIT 1,500)
#

INSERT INTO `ff_default` (`id`, `registry`, `storage`) VALUES

  (1,14,8),
  (4,14,8),
  (14,14,8),
  (15,14,8),
  (16,14,8),
  (17,14,8),
  (18,14,8),
  (19,14,8),
  (20,14,8),
  (21,7,5),
  (22,6,4),
  (23,6,4),
  (24,6,4),
  (25,6,4),
  (26,6,4),
  (27,6,4),
  (28,6,4),
  (29,6,4),
  (30,6,4),
  (31,6,4),
  (32,6,4),
  (33,6,4),
  (34,5,3),
  (35,2,2),
  (36,2,2),
  (37,5,3),
  (38,2,2),
  (39,2,2),
  (40,2,2),
  (41,2,2),
  (42,5,3),
  (43,2,2),
  (44,2,2),
  (45,2,2),
  (46,2,2),
  (47,5,3),
  (48,2,2),
  (49,2,2),
  (50,2,2),
  (51,5,3),
  (52,2,2),
  (53,2,2),
  (54,2,2),
  (55,2,2),
  (56,2,2),
  (57,5,3),
  (58,2,2),
  (59,2,2),
  (60,5,3),
  (61,2,2),
  (62,2,2),
  (63,2,2),
  (64,2,2),
  (65,2,2),
  (66,5,3),
  (67,2,2),
  (68,2,2),
  (69,5,3),
  (70,2,2),
  (71,2,2),
  (72,2,2),
  (73,2,2),
  (74,2,2),
  (75,2,2),
  (76,2,2),
  (77,5,3),
  (78,2,2),
  (79,2,2),
  (80,2,2),
  (81,2,2),
  (83,2,2),
  (85,12,7),
  (86,2,2),
  (88,2,2),
  (89,2,2),
  (90,2,2),
  (91,2,2),
  (92,12,7),
  (93,2,2),
  (94,2,2),
  (95,8,6),
  (96,2,2),
  (97,8,6),
  (98,2,2),
  (99,8,6),
  (100,2,2),
  (101,2,2),
  (102,2,2),
  (103,2,2),
  (104,2,2),
  (105,8,6),
  (106,2,2),
  (107,8,6),
  (108,2,2),
  (109,8,6),
  (110,2,2),
  (111,8,6),
  (112,2,2),
  (113,8,6),
  (114,2,2),
  (115,8,6),
  (116,2,2),
  (117,8,6),
  (118,2,2),
  (119,8,6),
  (120,2,2),
  (121,12,7),
  (122,2,2),
  (123,2,2),
  (124,2,2),
  (125,2,2),
  (126,2,2),
  (127,2,2),
  (128,2,2),
  (129,2,2),
  (130,2,2),
  (131,2,2),
  (132,2,2),
  (133,2,2),
  (134,2,2),
  (135,2,2),
  (136,2,2),
  (137,2,2),
  (138,2,2),
  (139,2,2),
  (140,2,2),
  (141,2,2),
  (142,2,2),
  (143,2,2),
  (144,2,2),
  (145,14,8),
  (146,14,8),
  (147,14,8),
  (148,14,8),
  (149,14,8),
  (150,14,8),
  (151,14,8),
  (152,14,8),
  (153,14,8),
  (154,14,8),
  (155,2,2),
  (156,2,2),
  (157,14,8),
  (158,2,2),
  (159,14,8),
  (160,14,8),
  (161,2,2),
  (162,14,8),
  (163,2,2),
  (164,14,8),
  (165,16,11),
  (166,14,8),
  (167,16,11),
  (168,2,2),
  (170,16,11),
  (171,2,2),
  (172,2,2),
  (173,2,2),
  (174,2,2),
  (175,2,2),
  (177,16,11),
  (178,2,2),
  (179,14,8),
  (181,16,11),
  (182,2,2),
  (183,14,8),
  (184,16,11),
  (185,2,2),
  (187,16,11),
  (188,2,2),
  (190,16,11),
  (191,2,2),
  (193,16,11),
  (194,2,2),
  (195,14,8),
  (196,16,11),
  (197,2,2),
  (199,16,11),
  (200,2,2),
  (202,16,11),
  (203,2,2),
  (204,14,8),
  (205,16,11),
  (206,2,2),
  (207,14,8),
  (208,16,11),
  (209,2,2),
  (210,24,8),
  (211,7,5),
  (212,2,2),
  (213,14,8),
  (214,16,11),
  (215,14,8),
  (216,16,11),
  (217,2,2),
  (218,14,8),
  (219,16,11),
  (220,2,2),
  (221,2,2),
  (222,14,8),
  (223,16,11),
  (224,21,14),
  (225,0,8),
  (226,16,11),
  (227,21,14),
  (228,2,2),
  (229,2,2),
  (230,2,2),
  (231,2,2),
  (232,14,8),
  (233,16,11),
  (234,21,14),
  (235,2,2),
  (236,2,2),
  (237,16,11),
  (238,16,11),
  (239,16,11),
  (240,21,14),
  (241,2,2),
  (242,16,11),
  (243,16,11),
  (244,2,2),
  (245,16,11),
  (246,16,11),
  (247,2,2),
  (248,16,11),
  (249,16,11),
  (250,2,2),
  (251,2,2),
  (252,16,11),
  (253,16,11),
  (254,2,2),
  (255,2,2),
  (256,14,8),
  (257,16,11),
  (258,21,14),
  (259,2,2),
  (260,2,2),
  (261,16,11),
  (262,16,11),
  (263,16,11),
  (264,21,14),
  (265,2,2),
  (266,2,2),
  (267,2,2),
  (268,2,2),
  (269,16,11),
  (270,16,11),
  (271,16,11),
  (272,16,11),
  (273,21,14),
  (274,2,2),
  (275,2,2),
  (276,2,2),
  (277,2,2),
  (278,2,2),
  (279,2,2),
  (280,2,2),
  (281,2,2),
  (282,2,2),
  (283,2,2),
  (284,2,2),
  (285,2,2),
  (286,2,2),
  (287,2,2),
  (288,2,2),
  (289,2,2),
  (290,2,2),
  (291,2,2),
  (292,2,2),
  (293,2,2),
  (294,2,2),
  (295,2,2),
  (296,2,2),
  (297,2,2),
  (298,2,2),
  (299,2,2),
  (300,2,2),
  (301,2,2),
  (302,2,2),
  (303,2,2),
  (304,2,2),
  (305,2,2),
  (306,2,2),
  (307,2,2),
  (308,2,2),
  (309,2,2),
  (310,2,2),
  (311,2,2),
  (312,2,2),
  (313,2,2),
  (314,2,2),
  (315,2,2),
  (316,2,2),
  (317,2,2),
  (318,2,2),
  (319,2,2),
  (320,2,2),
  (321,2,2),
  (322,2,2),
  (323,2,2),
  (324,2,2),
  (325,2,2),
  (326,2,2),
  (327,2,2),
  (328,2,2),
  (329,2,2),
  (330,2,2),
  (331,2,2),
  (332,2,2),
  (333,2,2),
  (334,2,2),
  (335,14,8),
  (336,16,11),
  (337,21,14),
  (338,2,2),
  (339,2,2),
  (340,16,11),
  (341,21,14),
  (342,16,11),
  (343,21,14),
  (344,16,11),
  (345,21,14),
  (346,2,2),
  (347,2,2),
  (348,2,2),
  (349,2,2),
  (350,2,2),
  (351,2,2),
  (353,21,14),
  (354,16,11),
  (355,21,14),
  (357,21,14),
  (358,16,11),
  (359,21,14),
  (360,2,2),
  (361,2,2),
  (362,2,2),
  (363,2,2),
  (364,2,2),
  (365,2,2),
  (366,2,2),
  (367,2,2),
  (368,2,2),
  (369,2,2),
  (370,2,2),
  (371,2,2),
  (372,2,2),
  (373,2,2),
  (374,2,2),
  (375,2,2),
  (376,2,2),
  (377,2,2),
  (378,16,11),
  (379,21,14),
  (380,21,14),
  (382,21,14),
  (383,16,11),
  (384,21,14),
  (386,21,14),
  (387,16,11),
  (388,21,14),
  (389,2,2),
  (390,2,2),
  (391,2,2),
  (392,2,2),
  (393,2,2),
  (394,2,2),
  (395,2,2),
  (396,2,2),
  (397,2,2),
  (398,2,2),
  (399,2,2),
  (400,16,11),
  (401,21,14),
  (402,21,14),
  (404,21,14),
  (405,16,11),
  (406,21,14),
  (408,21,14),
  (409,16,11),
  (410,21,14),
  (411,2,2),
  (412,2,2),
  (413,2,2),
  (414,2,2),
  (415,2,2),
  (416,2,2),
  (417,2,2),
  (418,2,2),
  (419,2,2),
  (420,2,2),
  (421,2,2),
  (423,21,14),
  (424,21,14),
  (425,16,11),
  (426,21,14),
  (427,16,11),
  (428,21,14),
  (429,16,11),
  (430,21,14),
  (431,16,11),
  (432,21,14),
  (433,2,2),
  (434,2,2),
  (435,2,2),
  (436,2,2),
  (437,2,2),
  (438,2,2),
  (439,2,2),
  (440,2,2),
  (441,2,2),
  (442,2,2),
  (443,2,2),
  (444,16,11),
  (445,16,11),
  (446,21,14),
  (448,21,14),
  (449,21,14),
  (450,16,11),
  (451,21,14),
  (452,16,11),
  (453,21,14),
  (454,16,11),
  (455,21,14),
  (456,16,11),
  (457,21,14),
  (458,2,2),
  (459,2,2),
  (460,2,2),
  (461,2,2),
  (462,2,2),
  (463,2,2),
  (464,2,2),
  (465,2,2),
  (466,2,2),
  (467,2,2),
  (468,2,2),
  (469,2,2),
  (470,2,2),
  (471,2,2),
  (472,16,11),
  (473,21,14),
  (474,16,11),
  (475,16,11),
  (476,21,14),
  (478,21,14),
  (479,21,14),
  (480,16,11),
  (481,21,14),
  (483,21,14),
  (484,16,11),
  (485,21,14),
  (486,16,11),
  (487,21,14),
  (488,2,2),
  (489,2,2),
  (490,2,2),
  (491,2,2),
  (492,2,2),
  (493,2,2),
  (494,2,2),
  (495,2,2),
  (496,2,2),
  (497,2,2),
  (498,2,2),
  (499,2,2),
  (500,2,2),
  (501,2,2),
  (502,2,2),
  (503,2,2),
  (504,16,11),
  (505,16,11),
  (506,21,14),
  (507,16,11),
  (508,21,14),
  (509,16,11),
  (510,16,11),
  (511,21,14),
  (513,21,14),
  (514,21,14),
  (515,16,11),
  (516,21,14),
  (518,21,14),
  (519,16,11),
  (520,21,14),
  (521,16,11),
  (522,21,14),
  (523,2,2),
  (524,2,2),
  (525,2,2),
  (526,2,2),
  (527,2,2),
  (528,2,2),
  (529,2,2),
  (530,2,2),
  (531,2,2),
  (532,2,2),
  (533,2,2),
  (534,2,2);
COMMIT;

#
# Data for the `ff_default` table  (LIMIT 239,500)
#

INSERT INTO `ff_default` (`id`, `registry`, `storage`) VALUES

  (535,2,2),
  (536,2,2),
  (537,2,2),
  (538,2,2),
  (539,2,2),
  (540,2,2),
  (541,2,2),
  (542,16,11),
  (543,21,14),
  (544,16,11),
  (545,16,11),
  (546,21,14),
  (547,16,11),
  (548,21,14),
  (549,16,11),
  (550,16,11),
  (551,21,14),
  (553,21,14),
  (554,21,14),
  (555,16,11),
  (556,21,14),
  (558,21,14),
  (559,16,11),
  (560,21,14),
  (561,16,11),
  (562,21,14),
  (563,2,2),
  (564,2,2),
  (565,2,2),
  (566,2,2),
  (567,2,2),
  (568,2,2),
  (569,2,2),
  (570,2,2),
  (571,2,2),
  (572,2,2),
  (573,2,2),
  (574,2,2),
  (575,2,2),
  (576,2,2),
  (577,2,2),
  (578,2,2),
  (579,2,2),
  (580,2,2),
  (581,2,2),
  (582,2,2),
  (583,2,2),
  (584,16,11),
  (585,21,14),
  (586,16,11),
  (587,16,11),
  (588,21,14),
  (589,16,11),
  (590,21,14),
  (591,16,11),
  (592,16,11),
  (593,21,14),
  (595,21,14),
  (596,21,14),
  (597,16,11),
  (598,21,14),
  (599,16,11),
  (600,21,14),
  (601,16,11),
  (602,21,14),
  (603,16,11),
  (604,21,14),
  (605,2,2),
  (606,2,2),
  (607,2,2),
  (608,2,2),
  (609,2,2),
  (610,2,2),
  (611,2,2),
  (612,2,2),
  (613,2,2),
  (614,2,2),
  (615,2,2),
  (616,2,2),
  (617,2,2),
  (618,2,2),
  (619,2,2),
  (620,2,2),
  (621,2,2),
  (622,2,2),
  (623,2,2),
  (624,2,2),
  (625,2,2),
  (626,16,11),
  (627,21,14),
  (628,16,11),
  (629,16,11),
  (630,21,14),
  (631,16,11),
  (632,21,14),
  (633,16,11),
  (634,16,11),
  (635,21,14),
  (636,16,11),
  (637,21,14),
  (638,21,14),
  (639,16,11),
  (640,21,14),
  (641,16,11),
  (642,21,14),
  (643,16,11),
  (644,21,14),
  (645,16,11),
  (646,21,14),
  (647,2,2),
  (648,2,2),
  (649,2,2),
  (650,2,2),
  (651,2,2),
  (652,2,2),
  (653,2,2),
  (654,2,2),
  (655,2,2),
  (656,2,2),
  (657,2,2),
  (658,2,2),
  (659,2,2),
  (660,2,2),
  (661,2,2),
  (662,2,2),
  (663,2,2),
  (664,2,2),
  (665,2,2),
  (666,2,2),
  (667,2,2),
  (668,14,8),
  (669,16,11),
  (670,21,14),
  (671,2,2),
  (672,2,2),
  (673,16,11),
  (674,21,14),
  (675,16,11),
  (676,21,14),
  (678,21,14),
  (679,2,2),
  (680,2,2),
  (681,2,2),
  (682,2,2),
  (683,2,2),
  (684,2,2),
  (685,2,2),
  (686,2,2),
  (687,2,2),
  (688,16,11),
  (689,21,14),
  (690,16,11),
  (691,21,14),
  (692,16,11),
  (693,21,14),
  (694,16,11),
  (695,21,14),
  (696,2,2),
  (697,2,2),
  (698,2,2),
  (699,2,2),
  (700,2,2),
  (701,2,2),
  (702,2,2),
  (703,2,2),
  (704,14,8),
  (706,21,14),
  (707,2,2),
  (708,2,2),
  (709,16,11),
  (710,21,14),
  (711,16,11),
  (712,21,14),
  (714,21,14),
  (715,2,2),
  (716,2,2),
  (717,2,2),
  (718,2,2),
  (719,2,2),
  (720,2,2),
  (721,2,2),
  (722,2,2),
  (723,2,2),
  (724,2,2),
  (725,2,2),
  (726,16,11),
  (727,21,14),
  (728,16,11),
  (729,21,14),
  (730,16,11),
  (731,21,14),
  (732,2,2),
  (733,2,2),
  (734,2,2),
  (735,2,2),
  (736,2,2),
  (737,2,2),
  (738,14,8),
  (740,21,14),
  (741,2,2),
  (742,2,2),
  (743,16,11),
  (744,21,14),
  (746,21,14),
  (747,2,2),
  (748,2,2),
  (749,2,2),
  (750,2,2),
  (751,16,11),
  (752,21,14),
  (753,21,14),
  (754,16,11),
  (755,21,14),
  (756,2,2),
  (757,2,2),
  (758,2,2),
  (759,2,2),
  (760,2,2),
  (761,24,8),
  (762,16,11),
  (763,21,14),
  (764,2,2),
  (765,2,2),
  (766,14,8),
  (767,16,11),
  (768,21,14),
  (769,2,2),
  (770,2,2),
  (771,14,8),
  (772,16,11),
  (773,21,14),
  (774,2,2),
  (775,2,2),
  (776,14,8),
  (777,16,11),
  (778,21,14),
  (779,2,2),
  (780,2,2);
COMMIT;

#
# Data for the `ff_document_base` table  (LIMIT -453,500)
#

INSERT INTO `ff_document_base` (`id`, `registry`, `storage`, `createdate`, `route`, `nodes`, `available_nodes`, `available_actions`) VALUES

  (1,14,8,NULL,NULL,NULL,NULL,NULL),
  (4,14,8,NULL,NULL,NULL,NULL,NULL),
  (14,14,8,NULL,NULL,NULL,NULL,NULL),
  (15,14,8,NULL,NULL,NULL,NULL,NULL),
  (16,14,8,NULL,NULL,NULL,NULL,NULL),
  (17,14,8,NULL,NULL,NULL,NULL,NULL),
  (18,14,8,NULL,NULL,NULL,NULL,NULL),
  (19,14,8,NULL,NULL,NULL,NULL,NULL),
  (20,14,8,NULL,NULL,NULL,NULL,NULL),
  (145,14,8,NULL,21,NULL,NULL,NULL),
  (146,14,8,NULL,21,NULL,NULL,NULL),
  (147,14,8,NULL,21,NULL,NULL,NULL),
  (148,14,8,NULL,21,NULL,NULL,NULL),
  (149,14,8,NULL,21,NULL,NULL,NULL),
  (150,14,8,NULL,21,NULL,NULL,NULL),
  (151,14,8,NULL,21,NULL,NULL,NULL),
  (152,14,8,NULL,21,NULL,NULL,NULL),
  (153,14,8,NULL,21,NULL,NULL,NULL),
  (154,14,8,NULL,21,NULL,NULL,NULL),
  (157,14,8,NULL,NULL,NULL,NULL,NULL),
  (159,14,8,NULL,NULL,NULL,NULL,NULL),
  (160,14,8,NULL,21,NULL,NULL,NULL),
  (162,14,8,NULL,21,NULL,NULL,NULL),
  (164,14,8,NULL,21,NULL,NULL,NULL),
  (166,14,8,NULL,21,NULL,NULL,NULL),
  (179,14,8,NULL,21,NULL,NULL,NULL),
  (183,14,8,NULL,21,NULL,NULL,NULL),
  (195,14,8,NULL,21,NULL,NULL,NULL),
  (204,14,8,NULL,21,NULL,NULL,NULL),
  (207,14,8,NULL,21,NULL,NULL,NULL),
  (210,24,8,NULL,NULL,NULL,NULL,NULL),
  (213,14,8,NULL,21,NULL,NULL,NULL),
  (215,14,8,NULL,21,NULL,NULL,NULL),
  (218,14,8,NULL,21,NULL,NULL,NULL),
  (222,14,8,NULL,21,NULL,NULL,NULL),
  (225,14,8,NULL,21,NULL,NULL,NULL),
  (232,14,8,NULL,21,NULL,NULL,NULL),
  (256,14,8,NULL,21,NULL,NULL,NULL),
  (335,14,8,NULL,21,NULL,NULL,NULL),
  (668,14,8,NULL,21,NULL,NULL,NULL),
  (704,14,8,NULL,21,NULL,NULL,NULL),
  (738,14,8,NULL,21,NULL,NULL,NULL),
  (761,24,8,NULL,21,NULL,NULL,NULL),
  (766,14,8,NULL,21,NULL,NULL,NULL),
  (771,14,8,NULL,21,NULL,NULL,NULL),
  (776,14,8,NULL,21,NULL,NULL,NULL);
COMMIT;

#
# Data for the `ff_document_demo` table  (LIMIT -447,500)
#

INSERT INTO `ff_document_demo` (`id`, `registry`, `storage`, `createdate`, `creditor`, `route`, `nodes`, `available_nodes`, `available_actions`) VALUES

  (1,14,8,NULL,'фв<strong>фывфывфы</strong><br />\r\nяся<em>чся</em>чс<s>яч</s>с',NULL,NULL,NULL,NULL),
  (4,14,8,NULL,'фывфывфывф',NULL,NULL,NULL,NULL),
  (14,14,8,NULL,'йцуйцуйцу',NULL,NULL,NULL,NULL),
  (15,14,8,NULL,'33',NULL,NULL,NULL,NULL),
  (16,14,8,NULL,'16+',NULL,NULL,NULL,NULL),
  (17,14,8,NULL,'аыаыав',NULL,NULL,NULL,NULL),
  (18,14,8,NULL,NULL,NULL,NULL,NULL,NULL),
  (19,14,8,NULL,'чамвмывмы',NULL,NULL,NULL,NULL),
  (20,14,8,NULL,'Тест <ins>маршрута</ins>',NULL,NULL,NULL,NULL),
  (145,14,8,NULL,'ntcn',21,NULL,NULL,NULL),
  (146,14,8,NULL,'ntcn',21,NULL,NULL,NULL),
  (147,14,8,NULL,'wefwefwef',21,NULL,NULL,NULL),
  (148,14,8,NULL,'fcbfbfdbdbfd',21,NULL,NULL,NULL),
  (149,14,8,NULL,'2131231231212312312312312312312312331231231',21,NULL,NULL,NULL),
  (150,14,8,NULL,'bfbfdbdfdf',21,NULL,NULL,NULL),
  (151,14,8,NULL,'eqweqweq<strong>weqweqweqweqweqweqweqwe</strong>qweqeqwe',21,NULL,NULL,NULL),
  (152,14,8,NULL,'11111111111111111111111',21,NULL,NULL,NULL),
  (153,14,8,NULL,'aaaaaaaaaaaaaa',21,NULL,NULL,NULL),
  (154,14,8,NULL,'тест',21,NULL,NULL,NULL),
  (157,14,8,NULL,NULL,NULL,NULL,NULL,NULL),
  (159,14,8,NULL,NULL,NULL,NULL,NULL,NULL),
  (160,14,8,NULL,'ТЕСТ',21,NULL,NULL,NULL),
  (162,14,8,NULL,'Документ из кабинета',21,NULL,NULL,NULL),
  (164,14,8,NULL,'ТЕСТ1',21,NULL,NULL,NULL),
  (166,14,8,NULL,'ТЕСТ1',21,NULL,NULL,NULL),
  (169,14,8,NULL,'12323123',21,NULL,NULL,NULL),
  (176,14,8,NULL,'кцкцукцук',21,NULL,NULL,NULL),
  (179,14,8,NULL,'Тест маршрута перенеенного в модель',21,NULL,NULL,NULL),
  (180,14,8,NULL,'Тест маршрута перенеенного в модель',21,NULL,NULL,NULL),
  (183,14,8,NULL,'Тест маршрута перенесенного в модель + 2',21,NULL,NULL,NULL),
  (186,14,8,NULL,'Для удаления',21,NULL,NULL,NULL),
  (189,14,8,NULL,'Для удаления',21,NULL,NULL,NULL),
  (192,14,8,NULL,'Для удаления',21,NULL,NULL,NULL),
  (195,14,8,NULL,'3123123123',21,NULL,NULL,NULL),
  (198,14,8,NULL,'3123123123',21,NULL,NULL,NULL),
  (201,14,8,NULL,'йццццццццццццццццццццц',21,NULL,NULL,NULL),
  (204,14,8,NULL,'ывмвывв',21,NULL,NULL,NULL),
  (207,14,8,NULL,'тест привязки действий',21,NULL,NULL,NULL),
  (213,14,8,NULL,'Новый',21,NULL,NULL,NULL),
  (215,14,8,NULL,'Новый',21,NULL,NULL,NULL),
  (218,14,8,NULL,'Новый 2',21,NULL,NULL,NULL),
  (222,14,8,NULL,'Направить на рассмотрение',21,NULL,NULL,NULL),
  (225,14,8,NULL,'Направить на рассмотрение',21,NULL,NULL,NULL),
  (232,14,8,NULL,'поправлена форма',21,NULL,NULL,NULL),
  (256,14,8,NULL,'Новыйй тест',21,NULL,NULL,NULL),
  (335,14,8,NULL,'+++++++++',21,NULL,NULL,NULL),
  (668,14,8,NULL,'Заявление',21,NULL,NULL,NULL),
  (704,14,8,NULL,'Заявление 2',21,NULL,NULL,NULL),
  (738,14,8,NULL,'===&gt;',21,NULL,NULL,NULL),
  (766,14,8,NULL,'ыфауыа',21,NULL,NULL,NULL),
  (771,14,8,NULL,'qqqqqqqqqqqqqqq',21,NULL,NULL,NULL),
  (776,14,8,NULL,'123123123',21,NULL,NULL,NULL);
COMMIT;

#
# Data for the `ff_document_rkk` table  (LIMIT -497,500)
#

INSERT INTO `ff_document_rkk` (`id`, `registry`, `storage`, `createdate`, `route`, `available_nodes`, `available_actions`, `regnum`, `regdate`) VALUES

  (210,24,8,NULL,NULL,NULL,NULL,NULL,NULL),
  (761,24,8,NULL,21,NULL,NULL,'123123',NULL);
COMMIT;

#
# Data for the `ff_registry` table  (LIMIT -471,500)
#

INSERT INTO `ff_registry` (`id`, `parent`, `tablename`, `description`, `protected`, `attaching`, `copying`, `view`) VALUES

  (1,NULL,'default','Корневая родительская свободная форма',1,0,1,NULL),
  (2,1,'ref_multiguide','Системный справочник многие-ко-многим',1,0,1,NULL),
  (3,1,'oneline','Однострочный справочник',1,0,1,NULL),
  (4,3,'commentline','Справочник с комментированием',1,0,0,NULL),
  (5,4,'route_action','Действия на маршруте',0,0,1,NULL),
  (6,4,'route_node','Узлы маршрута',0,0,1,NULL),
  (7,4,'route','Маршрут',0,0,1,NULL),
  (8,4,'route_folder','Папки маршрута',0,0,1,NULL),
  (9,4,'route_cabinet','Кабинеты пользователей',0,0,1,NULL),
  (10,NULL,'cab_user','Внутрение пользователи',0,1,0,NULL),
  (11,NULL,'cab_user_roles','Роли пользователей',0,1,0,NULL),
  (12,9,'route_cabinet_for_role','Кабинет пользователя с розделением по ролям',0,0,1,NULL),
  (13,1,'document_base','Базовый документ',0,0,1,NULL),
  (14,13,'document_demo','Тестовый документ',0,0,0,NULL),
  (15,9,'route_cabinet_for_users','Кабинет пользователя с разделением по пользователям',0,0,1,NULL),
  (16,1,'available_nodes','Доступные узлы для определенных пользователей на маршруте',0,0,1,NULL),
  (17,16,'available_nodes_for_users','Список доступных узлов для круга пользователей',0,0,1,NULL),
  (18,16,'available_nodes_for_roles','Список доступных узлов для списка ролей',0,0,1,NULL),
  (19,NULL,'ff_registry','Таблица регистраций',0,1,0,NULL),
  (20,NULL,'ff_storage','Список хранилищ',0,1,0,NULL),
  (21,1,'available_actions','Список разрешенных действий с документом',0,0,1,NULL),
  (22,21,'available_actions_for_roles','Разшенные действия с документом для набора ролей',0,0,0,NULL),
  (23,21,'available_actions_for_users','Список разрешенных действий с документом в узле для перечня пользователей',0,0,1,NULL),
  (24,13,'document_rkk','Заявление заявителя',0,0,0,NULL),
  (25,5,'route_action_for_role','Действие с привязкой к роли',0,0,1,NULL),
  (26,5,'route_action_for_user','Действие с привязкой к пользователям',0,0,1,NULL),
  (27,7,'route_for_role','Маршрут с применением роли',0,0,1,NULL),
  (28,7,'route_for_user','Маршрут с применением списка пользователей',0,0,1,NULL);
COMMIT;

#
# Data for the `ff_field` table  (LIMIT -367,500)
#

INSERT INTO `ff_field` (`id`, `formid`, `name`, `type`, `description`, `order`, `protected`, `default`) VALUES

  (1,1,'registry',2,NULL,0,1,NULL),
  (2,1,'storage',2,NULL,0,1,NULL),
  (3,2,'registry',2,NULL,0,1,NULL),
  (4,2,'storage',2,NULL,0,1,NULL),
  (6,3,'registry',2,NULL,0,1,NULL),
  (7,3,'storage',2,NULL,0,1,NULL),
  (9,4,'registry',2,NULL,0,1,NULL),
  (10,4,'storage',2,NULL,0,1,NULL),
  (12,3,'name',1,'Наименование',100,0,NULL),
  (13,4,'name',1,'Наименование',100,1,NULL),
  (14,4,'comment',4,'Комментарий',200,0,NULL),
  (15,2,'order',2,'Порядок сортировки',0,0,NULL),
  (16,2,'owner',5,'Ссылка на документ',0,0,NULL),
  (17,2,'owner_field',2,'поле документа привязки',0,0,NULL),
  (18,2,'reference',5,'Ссылка на элемент справочника',0,0,NULL),
  (19,5,'registry',2,NULL,0,1,NULL),
  (20,5,'storage',2,NULL,0,1,NULL),
  (21,5,'name',1,'Наименование',100,1,NULL),
  (22,5,'comment',4,'Комментарий',200,1,NULL),
  (26,6,'registry',2,NULL,0,1,NULL),
  (27,6,'storage',2,NULL,0,1,NULL),
  (28,6,'name',1,'Наименование',100,1,NULL),
  (29,6,'comment',4,'Комментарий',200,1,NULL),
  (33,7,'registry',2,NULL,0,1,NULL),
  (34,7,'storage',2,NULL,0,1,NULL),
  (35,7,'name',1,'Наименование',100,1,NULL),
  (36,7,'comment',4,'Комментарий',200,1,NULL),
  (40,8,'registry',2,NULL,0,1,NULL),
  (41,8,'storage',2,NULL,0,1,NULL),
  (42,8,'name',1,'Наименование',100,1,NULL),
  (43,8,'comment',4,'Комментарий',200,1,NULL),
  (47,9,'registry',2,NULL,0,1,NULL),
  (48,9,'storage',2,NULL,0,1,NULL),
  (49,9,'name',1,'Наименование',100,1,NULL),
  (50,9,'comment',4,'Комментарий',200,1,NULL),
  (54,7,'start_route',1002,'Начальный узел',300,0,''),
  (55,5,'gotonodes',1002,'Перейти к узлам',300,0,''),
  (56,5,'clearnodes',1002,'Очистить узлы',400,0,''),
  (57,6,'allow_action',1001,'Разрешить действия',300,0,''),
  (58,6,'deny_action',1001,'Запретить действия',400,0,''),
  (59,8,'nodes',1002,'Ассоциированные узлы',300,0,''),
  (60,9,'folders',1007,'Папки кабинета',300,0,''),
  (61,8,'allow_new',1012,'Создать документ',400,0,''),
  (62,8,'allow_edit',1012,'Изменить документ',500,0,''),
  (63,8,'allow_delete',1012,'Удалить документ',600,0,''),
  (65,12,'registry',2,NULL,0,1,NULL),
  (66,12,'storage',2,NULL,0,1,NULL),
  (67,12,'name',1,'Наименование',100,1,NULL),
  (68,12,'comment',4,'Комментарий',200,1,NULL),
  (69,12,'folders',1007,'Папки кабинета',300,1,''),
  (72,12,'role',1009,'ИД роли пользователя',400,0,''),
  (73,13,'registry',2,NULL,0,1,NULL),
  (74,13,'storage',2,NULL,0,1,NULL),
  (76,13,'createdate',7,'Время создания документа',0,0,'CURRENT_TIMESTAMP'),
  (77,14,'registry',2,NULL,0,1,NULL),
  (78,14,'storage',2,NULL,0,1,NULL),
  (79,14,'createdate',7,'Время создания документа',0,1,'CURRENT_TIMESTAMP'),
  (85,14,'creditor',16,'Расширенный редактор',100,0,''),
  (89,15,'registry',2,NULL,0,1,NULL),
  (90,15,'storage',2,NULL,0,1,NULL),
  (91,15,'name',1,'Наименование',100,1,NULL),
  (92,15,'comment',4,'Комментарий',200,1,NULL),
  (93,15,'folders',1007,'Папки кабинета',300,1,NULL),
  (96,15,'users',1008,'Список пользователей, допущенных к кабинету',400,0,''),
  (97,13,'route',1003,'Маршрут',1,0,''),
  (98,14,'route',1003,'Маршрут',1,1,''),
  (101,16,'registry',2,NULL,0,1,NULL),
  (102,16,'storage',2,NULL,0,1,NULL),
  (104,16,'node',5,'Текущий узел',0,0,''),
  (108,17,'registry',2,NULL,0,1,NULL),
  (109,17,'storage',2,NULL,0,1,NULL),
  (110,17,'node',5,'Текущий узел',0,1,NULL),
  (111,18,'registry',2,NULL,0,1,NULL),
  (112,18,'storage',2,NULL,0,1,NULL),
  (113,18,'node',5,'Текущий узел',0,1,NULL),
  (114,17,'users',1008,'Список пользователей',0,0,''),
  (115,18,'roles',1009,'Список ролей',0,0,''),
  (118,13,'available_nodes',1010,'Список узлов в которых находится документ',0,0,''),
  (119,14,'available_nodes',1010,'Список узлов в которых находится документ',0,1,''),
  (120,13,'available_actions',1013,'Действия с документом',0,0,''),
  (121,14,'available_actions',1013,'Действия с документом',0,1,''),
  (122,8,'visual_names',4,'Список отображаемых полей',700,0,''),
  (123,21,'registry',2,NULL,0,1,NULL),
  (124,21,'storage',2,NULL,0,1,NULL),
  (126,21,'action',5,'Ссылка на действие',0,0,''),
  (127,22,'registry',2,NULL,0,1,NULL),
  (128,22,'storage',2,NULL,0,1,NULL),
  (129,22,'action',5,'Ссылка на действие',0,1,NULL),
  (130,21,'node',5,'Ссылка на узел',0,0,''),
  (131,22,'node',5,'Ссылка на узел',0,1,''),
  (132,23,'registry',2,NULL,0,1,NULL),
  (133,23,'storage',2,NULL,0,1,NULL),
  (134,23,'action',5,'Ссылка на действие',0,1,NULL),
  (135,23,'node',5,'Ссылка на узел',0,1,NULL),
  (139,22,'roles',1009,'Список ролей',0,0,''),
  (140,23,'users',1008,'Список пользователей',0,0,''),
  (141,24,'registry',2,NULL,0,1,NULL),
  (142,24,'storage',2,NULL,0,1,NULL),
  (143,24,'createdate',7,'Время создания документа',0,1,NULL),
  (144,24,'route',1003,'Маршрут',1,1,NULL),
  (145,24,'available_nodes',1010,'Список узлов в которых находится документ',0,1,NULL),
  (146,24,'available_actions',1013,'Действия с документом',0,1,''),
  (148,24,'regnum',1,'Регистрационный номер',1,0,''),
  (149,24,'regdate',3,'Регистрационная дата',0,0,''),
  (150,25,'registry',2,NULL,0,1,NULL),
  (151,25,'storage',2,NULL,0,1,NULL),
  (152,25,'name',1,'Наименование',100,1,NULL),
  (153,25,'comment',4,'Комментарий',200,1,NULL),
  (154,25,'gotonodes',1002,'Перейти к узлам',300,1,NULL),
  (155,25,'clearnodes',1002,'Очистить узлы',400,1,NULL),
  (157,26,'registry',2,NULL,0,1,NULL),
  (158,26,'storage',2,NULL,0,1,NULL),
  (159,26,'name',1,'Наименование',100,1,NULL),
  (160,26,'comment',4,'Комментарий',200,1,NULL),
  (161,26,'gotonodes',1002,'Перейти к узлам',300,1,NULL),
  (162,26,'clearnodes',1002,'Очистить узлы',400,1,NULL),
  (166,27,'registry',2,NULL,0,1,NULL),
  (167,27,'storage',2,NULL,0,1,NULL),
  (168,27,'name',1,'Наименование',100,1,NULL),
  (169,27,'comment',4,'Комментарий',200,1,NULL),
  (170,27,'start_route',1002,'Начальный узел',300,1,NULL),
  (173,28,'registry',2,NULL,0,1,NULL),
  (174,28,'storage',2,NULL,0,1,NULL),
  (175,28,'name',1,'Наименование',100,1,NULL),
  (176,28,'comment',4,'Комментарий',200,1,NULL),
  (177,28,'start_route',1002,'Начальный узел',300,1,NULL),
  (180,27,'roles',1009,'Роли',400,0,''),
  (181,28,'users',1008,'Пользователи',400,0,''),
  (182,25,'roles',1009,'Роли',500,0,''),
  (183,26,'users',1008,'Пользователи',500,0,''),
  (184,25,'currentrole',6,'Для текущего пользователя',600,0,''),
  (185,26,'currentuser',6,'Для текущего пользователя',600,0,'');
COMMIT;

#
# Data for the `ff_oneline` table  (LIMIT -461,500)
#

INSERT INTO `ff_oneline` (`id`, `registry`, `storage`, `name`) VALUES

  (21,7,5,'Маршрут по-умолчанию'),
  (22,6,4,'Новые (Заявитель)'),
  (23,6,4,'Рассматриваются (Заявитель)'),
  (24,6,4,'Рассмотреные (Заявитель)'),
  (25,6,4,'Поступившие (Администратор)'),
  (26,6,4,'В работе (Администратор)'),
  (27,6,4,'На рассмотрении (Администратор)'),
  (28,6,4,'Рассмотреные (Администратор)'),
  (29,6,4,'Архив (Администратор)'),
  (30,6,4,'Поступившие (Исполнитель)'),
  (31,6,4,'В работе (Исполнитель)'),
  (32,6,4,'Ожидают оплаты(Исполнитель)'),
  (33,6,4,'Архив (Исполнитель)'),
  (34,5,3,'Направить на рассмотрение'),
  (37,5,3,'Принять к исполнению'),
  (42,5,3,'Отказать'),
  (47,5,3,'Направить на выполнение'),
  (51,5,3,'В архив'),
  (57,5,3,'В работу'),
  (60,5,3,'Отказанно'),
  (66,5,3,'Направленно на оплату'),
  (69,5,3,'Выдать разрешительный документ'),
  (77,5,3,'В архив'),
  (85,12,7,'Кабинет заявителя'),
  (92,12,7,'Кабинет администратора'),
  (95,8,6,'Новые'),
  (97,8,6,'Рассматриваются'),
  (99,8,6,'Рассмотреные заявления'),
  (105,8,6,'Поступившие'),
  (107,8,6,'В работе'),
  (109,8,6,'На рассмотрении'),
  (111,8,6,'Архив'),
  (113,8,6,'Поступившие'),
  (115,8,6,'В работе'),
  (117,8,6,'В ожидании оплаты'),
  (119,8,6,'Архив'),
  (121,12,7,'Кабинет исполнителя'),
  (211,7,5,'Другой маршрут');
COMMIT;

#
# Data for the `ff_ref_multiguide` table  (LIMIT -311,500)
#

INSERT INTO `ff_ref_multiguide` (`id`, `registry`, `storage`, `order`, `owner`, `owner_field`, `reference`) VALUES

  (38,2,2,NULL,37,55,26),
  (39,2,2,NULL,37,56,25),
  (43,2,2,NULL,42,55,24),
  (44,2,2,1,42,55,28),
  (45,2,2,NULL,42,56,23),
  (46,2,2,1,42,56,26),
  (48,2,2,NULL,47,55,27),
  (49,2,2,1,47,55,30),
  (50,2,2,NULL,47,56,26),
  (52,2,2,NULL,51,55,29),
  (53,2,2,NULL,51,56,25),
  (54,2,2,1,51,56,26),
  (55,2,2,2,51,56,27),
  (56,2,2,3,51,56,28),
  (58,2,2,NULL,57,55,31),
  (59,2,2,NULL,57,56,30),
  (61,2,2,NULL,60,55,24),
  (62,2,2,1,60,55,28),
  (63,2,2,2,60,55,33),
  (64,2,2,NULL,60,56,27),
  (65,2,2,1,60,56,31),
  (67,2,2,NULL,66,55,32),
  (68,2,2,NULL,66,56,31),
  (70,2,2,NULL,69,55,24),
  (71,2,2,1,69,55,28),
  (72,2,2,2,69,55,33),
  (73,2,2,NULL,69,56,23),
  (74,2,2,1,69,56,27),
  (75,2,2,2,69,56,31),
  (76,2,2,3,69,56,32),
  (78,2,2,NULL,77,55,33),
  (79,2,2,NULL,77,56,30),
  (80,2,2,1,77,56,31),
  (81,2,2,2,77,56,32),
  (101,2,2,NULL,85,69,95),
  (102,2,2,1,85,69,97),
  (103,2,2,2,85,69,99),
  (104,2,2,NULL,85,72,4),
  (123,2,2,NULL,92,69,105),
  (124,2,2,1,92,69,107),
  (125,2,2,2,92,69,109),
  (126,2,2,3,92,69,111),
  (127,2,2,NULL,92,72,2),
  (128,2,2,NULL,121,69,113),
  (129,2,2,1,121,69,115),
  (130,2,2,2,121,69,117),
  (131,2,2,3,121,69,119),
  (132,2,2,NULL,121,72,3),
  (155,2,2,NULL,21,54,22),
  (156,2,2,NULL,NULL,119,22),
  (158,2,2,NULL,NULL,119,22),
  (161,2,2,NULL,160,119,22),
  (163,2,2,NULL,162,119,22),
  (168,2,2,NULL,166,119,167),
  (172,2,2,NULL,95,59,22),
  (173,2,2,NULL,95,61,8),
  (174,2,2,NULL,95,62,8),
  (175,2,2,NULL,95,63,8),
  (185,2,2,NULL,183,119,184),
  (197,2,2,NULL,195,119,196),
  (206,2,2,NULL,204,119,205),
  (209,2,2,NULL,207,119,208),
  (212,2,2,NULL,211,54,29),
  (217,2,2,NULL,215,119,216),
  (220,2,2,NULL,218,119,219),
  (221,2,2,NULL,22,57,34),
  (254,2,2,NULL,232,119,252),
  (255,2,2,1,232,119,253),
  (274,2,2,NULL,256,119,269),
  (275,2,2,1,256,119,270),
  (276,2,2,2,256,119,271),
  (277,2,2,3,256,119,272),
  (278,2,2,NULL,256,121,273),
  (283,2,2,NULL,25,57,37),
  (284,2,2,NULL,25,58,34),
  (285,2,2,1,25,58,37),
  (286,2,2,2,25,58,42),
  (287,2,2,3,25,58,47),
  (288,2,2,4,25,58,51),
  (289,2,2,5,25,58,57),
  (290,2,2,6,25,58,60),
  (291,2,2,7,25,58,66),
  (292,2,2,8,25,58,69),
  (293,2,2,9,25,58,77),
  (294,2,2,NULL,26,57,42),
  (295,2,2,1,26,57,47),
  (296,2,2,NULL,26,58,34),
  (297,2,2,1,26,58,37),
  (298,2,2,2,26,58,42),
  (299,2,2,3,26,58,47),
  (300,2,2,4,26,58,51),
  (301,2,2,5,26,58,57),
  (302,2,2,6,26,58,60),
  (303,2,2,7,26,58,66),
  (304,2,2,8,26,58,69),
  (305,2,2,9,26,58,77),
  (306,2,2,NULL,28,57,51),
  (307,2,2,NULL,28,58,34),
  (308,2,2,1,28,58,37),
  (309,2,2,2,28,58,42),
  (310,2,2,3,28,58,47),
  (311,2,2,4,28,58,51),
  (312,2,2,5,28,58,57),
  (313,2,2,6,28,58,60),
  (314,2,2,7,28,58,66),
  (315,2,2,8,28,58,69),
  (316,2,2,9,28,58,77),
  (317,2,2,NULL,30,57,57),
  (318,2,2,NULL,30,58,34),
  (319,2,2,1,30,58,37),
  (320,2,2,2,30,58,42),
  (321,2,2,3,30,58,47),
  (322,2,2,4,30,58,51),
  (323,2,2,NULL,31,57,60),
  (324,2,2,1,31,57,66),
  (325,2,2,2,31,57,69),
  (326,2,2,NULL,31,58,34),
  (327,2,2,1,31,58,37),
  (328,2,2,2,31,58,42),
  (329,2,2,3,31,58,47),
  (330,2,2,4,31,58,51),
  (331,2,2,5,31,58,57),
  (332,2,2,6,31,58,77),
  (333,2,2,NULL,32,57,69),
  (334,2,2,NULL,32,58,66),
  (368,2,2,NULL,97,59,23),
  (369,2,2,NULL,99,59,24),
  (370,2,2,NULL,105,59,25),
  (371,2,2,NULL,107,59,26),
  (372,2,2,NULL,109,59,27),
  (373,2,2,NULL,111,59,29),
  (374,2,2,NULL,113,59,30),
  (375,2,2,NULL,115,59,31),
  (376,2,2,NULL,117,59,32),
  (377,2,2,NULL,119,59,29),
  (647,2,2,NULL,335,119,626),
  (648,2,2,1,335,119,628),
  (649,2,2,2,335,119,629),
  (650,2,2,3,335,119,631),
  (651,2,2,4,335,119,633),
  (652,2,2,5,335,119,634),
  (653,2,2,6,335,119,636),
  (654,2,2,7,335,119,639),
  (655,2,2,8,335,119,641),
  (656,2,2,9,335,119,643),
  (657,2,2,10,335,119,645),
  (658,2,2,NULL,335,121,627),
  (659,2,2,1,335,121,630),
  (660,2,2,2,335,121,632),
  (661,2,2,3,335,121,635),
  (662,2,2,4,335,121,637),
  (663,2,2,5,335,121,638),
  (664,2,2,6,335,121,640),
  (665,2,2,7,335,121,642),
  (666,2,2,8,335,121,644),
  (667,2,2,9,335,121,646),
  (696,2,2,NULL,668,119,688),
  (697,2,2,1,668,119,690),
  (698,2,2,2,668,119,692),
  (699,2,2,3,668,119,694),
  (700,2,2,NULL,668,121,689),
  (701,2,2,1,668,121,691),
  (702,2,2,2,668,121,693),
  (703,2,2,3,668,121,695),
  (721,2,2,NULL,34,55,23),
  (722,2,2,1,34,55,25),
  (723,2,2,NULL,34,56,22),
  (724,2,2,NULL,23,57,37),
  (725,2,2,NULL,23,58,34),
  (732,2,2,NULL,704,119,726),
  (733,2,2,1,704,119,728),
  (734,2,2,2,704,119,730),
  (735,2,2,NULL,704,121,727),
  (736,2,2,1,704,121,729),
  (737,2,2,2,704,121,731),
  (756,2,2,NULL,738,119,751),
  (757,2,2,1,738,119,754),
  (758,2,2,NULL,738,121,752),
  (759,2,2,1,738,121,753),
  (760,2,2,2,738,121,755),
  (764,2,2,NULL,761,145,762),
  (765,2,2,NULL,761,146,763),
  (769,2,2,NULL,766,119,767),
  (770,2,2,NULL,766,121,768),
  (774,2,2,NULL,771,119,772),
  (775,2,2,NULL,771,121,773),
  (779,2,2,NULL,776,119,777),
  (780,2,2,NULL,776,121,778);
COMMIT;

#
# Data for the `ff_registry_h` table  (LIMIT -417,500)
#

INSERT INTO `ff_registry_h` (`id`, `owner`, `parent`) VALUES

  (1,1,1),
  (2,2,1),
  (3,2,1),
  (4,3,1),
  (5,3,1),
  (6,4,1),
  (7,4,1),
  (9,4,3),
  (10,5,1),
  (11,5,1),
  (12,5,3),
  (13,5,4),
  (14,6,1),
  (15,6,1),
  (16,6,3),
  (17,6,4),
  (18,7,1),
  (19,7,1),
  (20,7,3),
  (21,7,4),
  (22,8,1),
  (23,8,1),
  (24,8,3),
  (25,8,4),
  (26,9,1),
  (27,9,1),
  (28,9,3),
  (29,9,4),
  (30,12,1),
  (31,12,1),
  (32,12,3),
  (33,12,4),
  (37,12,9),
  (38,13,1),
  (39,13,1),
  (40,14,1),
  (41,14,1),
  (43,14,13),
  (44,15,1),
  (45,15,1),
  (46,15,3),
  (47,15,4),
  (51,15,9),
  (52,16,1),
  (53,16,1),
  (54,17,1),
  (55,17,1),
  (57,17,16),
  (58,18,1),
  (59,18,1),
  (61,18,16),
  (62,21,1),
  (63,21,1),
  (64,22,1),
  (65,22,1),
  (67,22,21),
  (68,23,1),
  (69,23,1),
  (71,23,21),
  (72,24,1),
  (73,24,1),
  (75,24,13),
  (76,25,1),
  (77,25,1),
  (78,25,3),
  (79,25,4),
  (83,25,5),
  (84,26,1),
  (85,26,1),
  (86,26,3),
  (87,26,4),
  (91,26,5),
  (92,27,1),
  (93,27,1),
  (94,27,3),
  (95,27,4),
  (99,27,7),
  (100,28,1),
  (101,28,1),
  (102,28,3),
  (103,28,4),
  (107,28,7);
COMMIT;

#
# Data for the `ff_storage` table  (LIMIT -485,500)
#

INSERT INTO `ff_storage` (`id`, `name`, `description`, `subtype`, `type`) VALUES

  (1,'default','Хранилище по умолчанию',0,NULL),
  (2,'ref_multiguide_storage','Хранилище для хранения связок',0,NULL),
  (3,'actions','Действия на узлах маршрута',5,1001),
  (4,'nodes','Перечень узлов маршрута',5,1002),
  (5,'routes','Маршруты',1,1003),
  (6,'folders','Папки кабинета',5,1007),
  (7,'cabinets','Кабинеты',0,NULL),
  (8,'Тестовые документы','Хранилище для тестирования документов',0,NULL),
  (9,'Список пользователей','Проба работы с внешними таблицами',5,1008),
  (10,'Роли','Проба работы с внешними таблицами',5,1009),
  (11,'Доступные узлы','Доступные узлы(available nodes) документа',5,1010),
  (12,'Список регистраций свободных форм','Список зарегистрированых свободных форм',5,1011),
  (13,'Список хранилищ','Список зарегистрированных хранилищ',5,1012),
  (14,'Доступные действия','Перечень доступных действий в узле',5,1013);
COMMIT;

#
# Data for the `ff_registry_storage` table  (LIMIT -474,500)
#

INSERT INTO `ff_registry_storage` (`id`, `registry`, `storage`) VALUES

  (1,1,1),
  (2,2,2),
  (4,6,4),
  (15,8,6),
  (22,9,7),
  (23,12,7),
  (24,15,7),
  (29,10,9),
  (30,11,10),
  (32,16,11),
  (33,17,11),
  (34,18,11),
  (35,19,12),
  (36,20,13),
  (37,21,14),
  (38,22,14),
  (39,23,14),
  (40,14,8),
  (41,24,8),
  (42,5,3),
  (43,25,3),
  (44,26,3),
  (45,7,5),
  (46,27,5),
  (47,28,5);
COMMIT;

#
# Data for the `ff_route` table  (LIMIT -497,500)
#

INSERT INTO `ff_route` (`id`, `registry`, `storage`, `name`, `comment`, `start_route`) VALUES

  (21,7,5,'Маршрут по-умолчанию','ТЕСТ',NULL),
  (211,7,5,'Другой маршрут',NULL,NULL);
COMMIT;

#
# Data for the `ff_route_action` table  (LIMIT -489,500)
#

INSERT INTO `ff_route_action` (`id`, `registry`, `storage`, `name`, `comment`, `gotonodes`, `clearnodes`) VALUES

  (34,5,3,'Направить на рассмотрение','Заявитель отправляет документ на рассмотрение администратору',NULL,NULL),
  (37,5,3,'Принять к исполнению','Администратор принимает к исполнению поступивший документ',NULL,NULL),
  (42,5,3,'Отказать','Администратор отказывает в рассмотрении документа',NULL,NULL),
  (47,5,3,'Направить на выполнение','Администратор направляет документ исполнителю',NULL,NULL),
  (51,5,3,'В архив','Администратор направляет рассмотреные документы в архив',NULL,NULL),
  (57,5,3,'В работу','Исполнитель принимает документ в работу',NULL,NULL),
  (60,5,3,'Отказанно','Исполнитель отказывает в исполнении',NULL,NULL),
  (66,5,3,'Направленно на оплату','Исполнитель вынес положительное решение и направил документ на оплату',NULL,NULL),
  (69,5,3,'Выдать разрешительный документ','Исполнитель вынес положительное решение ',NULL,NULL),
  (77,5,3,'В архив','Исполнитель отпавляет документ в архив',NULL,NULL);
COMMIT;

#
# Data for the `ff_route_cabinet` table  (LIMIT -496,500)
#

INSERT INTO `ff_route_cabinet` (`id`, `registry`, `storage`, `name`, `comment`, `folders`, `role`) VALUES

  (85,12,7,'Кабинет заявителя','Документы заявителя',NULL,NULL),
  (92,12,7,'Кабинет администратора',NULL,NULL,NULL),
  (121,12,7,'Кабинет исполнителя','Кабинет для работы с документами направлених в исполнительную службу',NULL,NULL);
COMMIT;

#
# Data for the `ff_route_cabinet_for_role` table  (LIMIT -496,500)
#

INSERT INTO `ff_route_cabinet_for_role` (`id`, `registry`, `storage`, `name`, `comment`, `folders`, `role`) VALUES

  (85,12,7,'Кабинет заявителя','Документы заявителя',NULL,NULL),
  (92,12,7,'Кабинет администратора',NULL,NULL,NULL),
  (121,12,7,'Кабинет исполнителя','Кабинет для работы с документами направлених в исполнительную службу',NULL,NULL);
COMMIT;

#
# Data for the `ff_route_folder` table  (LIMIT -488,500)
#

INSERT INTO `ff_route_folder` (`id`, `registry`, `storage`, `name`, `comment`, `nodes`, `allow_new`, `allow_edit`, `allow_delete`, `visual_names`) VALUES

  (95,8,6,'Новые','Вновь созданые заявления',NULL,NULL,NULL,NULL,'creditor:Полный текст;'),
  (97,8,6,'Рассматриваются','Документы находящиеся на рассмотрении в ЦНАП',NULL,0,0,0,'creditor:Полный текст;'),
  (99,8,6,'Рассмотреные заявления','Документы, решение по которым было вынесено',NULL,0,0,0,'creditor:Полный текст;'),
  (105,8,6,'Поступившие','Документы, поступившие на рассмотрение администраторов',NULL,0,0,0,'creditor:Полный текст;'),
  (107,8,6,'В работе','Документы, принятые на рассмотрение администратором',NULL,0,0,0,'creditor:Полный текст;'),
  (109,8,6,'На рассмотрении','Документы, на рассмотрении у исполнительной службы',NULL,0,0,0,'creditor:Полный текст;'),
  (111,8,6,'Архив','Документы положенные администратором в архив',NULL,0,0,0,'creditor:Полный текст;'),
  (113,8,6,'Поступившие','Документы, поступившие в исполнительную службу',NULL,0,0,0,'creditor:Полный текст;'),
  (115,8,6,'В работе','Документы принятые в работу представителем исполнительной службы',NULL,0,0,0,'creditor:Полный текст;'),
  (117,8,6,'В ожидании оплаты','Документы, по которым вынесено положительное решение, но для выдачи разрешительного документа требуется оплата',NULL,0,0,0,'creditor:Полный текст;'),
  (119,8,6,'Архив','Документы, помещеные администратором в архив',NULL,0,0,0,'creditor:Полный текст;');
COMMIT;

#
# Data for the `ff_route_node` table  (LIMIT -487,500)
#

INSERT INTO `ff_route_node` (`id`, `registry`, `storage`, `name`, `comment`, `allow_action`, `deny_action`) VALUES

  (22,6,4,'Новые (Заявитель)','Новые документы заявителя',NULL,NULL),
  (23,6,4,'Рассматриваются (Заявитель)','Документы, которые заявитель отправил на рассмотрение',NULL,NULL),
  (24,6,4,'Рассмотреные (Заявитель)','Документы, по которым вынесенно решение',NULL,NULL),
  (25,6,4,'Поступившие (Администратор)','Документы которые поступили администратору от заявителя',NULL,NULL),
  (26,6,4,'В работе (Администратор)','Документы, которые администратор принял к рассмотрению',NULL,NULL),
  (27,6,4,'На рассмотрении (Администратор)','Документы, которые администратор направил в разрешительный орган',NULL,NULL),
  (28,6,4,'Рассмотреные (Администратор)','Документы по которым вынесено решение исполнительного органа',NULL,NULL),
  (29,6,4,'Архив (Администратор)','Документы, которые администратор отправил в архив',NULL,NULL),
  (30,6,4,'Поступившие (Исполнитель)','Документы которые поступили исполнителю от администратора',NULL,NULL),
  (31,6,4,'В работе (Исполнитель)','Документы, которые исполнитель принял к рассмотрению',NULL,NULL),
  (32,6,4,'Ожидают оплаты(Исполнитель)','Документы, по которым вынесено решение, но для выдачи необходимо, что бы заявитель выполнил оплату услуг',NULL,NULL),
  (33,6,4,'Архив (Исполнитель)','Полностью отработанные заявления',NULL,NULL);
COMMIT;

#
# Data for the `ff_types` table  (LIMIT -472,500)
#

INSERT INTO `ff_types` (`id`, `typename`, `systemtype`, `view`, `description`, `visible`) VALUES

  (1,'Строка','VARCHAR(255)',NULL,'Строка длиной 255 символов',1),
  (2,'Число','INT(11)',NULL,'Целое число',1),
  (3,'Дата','DATE','date','Дата',1),
  (4,'Текст','TEXT','textarea','Текст',1),
  (5,'Большое число','BIGINT(20)',NULL,'Большое целое число',1),
  (6,'Логический','TINYINT(4)','checkbox','Галочка',1),
  (7,'Дата и Время','DATETIME','datetime','Отображает дату и время',1),
  (8,'Штрихкод EAN-13',NULL,'barcode','Генерирует штрихкод по формату EAN-13',1),
  (9,'Картинка','MEDIUMBLOB','image','',1),
  (10,'Файл','LONGBLOB','file','Загружаемый файл',1),
  (11,'filetype','VARCHAR(55)',NULL,'MIME-тип файла',0),
  (12,'filename','VARCHAR(255)',NULL,'Имя файла',0),
  (13,'Инициализация ЭЦП',NULL,'initsign','Если файлы в документе будут подписывать, то в документе должен присутствовать',1),
  (14,'Файл с подписью','LONGBLOB','filesign','Данные файла с подписью',1),
  (15,'fileedsname','VARCHAR(255)',NULL,'Имя файла',0),
  (16,'CKeditor','TEXT','ckeditor','WYSIWYG-редактор',1),
  (17,'Штамп времени','TIMESTAMP','datetime','Отображает дату и время',1),
  (1001,'actions','INT(11)','listbox_multi','Действия на узлах маршрута',1),
  (1002,'nodes','INT(11)','listbox_multi','Перечень узлов маршрута',1),
  (1003,'routes','INT(11)','combobox','Маршруты',1),
  (1007,'folders','INT(11)','listbox_multi','Папки кабинета',1),
  (1008,'Список пользователей','INT(11)','listbox_multi','Проба работы с внешними таблицами',1),
  (1009,'Роли','INT(11)','listbox_multi','Проба работы с внешними таблицами',1),
  (1010,'Доступные узлы','INT(11)','listbox_multi','Доступные узлы(available nodes) документа',1),
  (1011,'Список регистраций свободных форм','INT(11)','listbox_multi','Список зарегистрированых свободных форм',1),
  (1012,'Список хранилищ','INT(11)','listbox_multi','Список зарегистрированных хранилищ',1),
  (1013,'Доступные действия','INT(11)','listbox_multi','Перечень доступных действий в узле',1);
COMMIT;


DELIMITER $$

CREATE DEFINER = 'iasnap'@'%' TRIGGER `ff_registry_BI` BEFORE INSERT ON `ff_registry`
  FOR EACH ROW
begin
	if (@disable_triggers is null) then
		-- Установка идентификатора
		if (new.parent is null) and (new.attaching=0) then 
			set new.parent = 1;
		end if;		
	end if;
end$$

CREATE DEFINER = 'iasnap'@'%' TRIGGER `ff_registry_AI` AFTER INSERT ON `ff_registry`
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

CREATE DEFINER = 'iasnap'@'%' TRIGGER `ff_registry_ad` AFTER DELETE ON `ff_registry`
  FOR EACH ROW
begin
	if (@disable_triggers is null) then
		delete from `ff_registry_h` where `owner`= old.id;		
	end if;
end$$

DELIMITER ;

DELIMITER $$

CREATE DEFINER = 'iasnap'@'%' TRIGGER `ff_storage_bins` BEFORE INSERT ON `ff_storage`
  FOR EACH ROW
BEGIN
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
END$$

CREATE DEFINER = 'iasnap'@'%' TRIGGER `ff_storage_BUPD` BEFORE UPDATE ON `ff_storage`
  FOR EACH ROW
begin
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
end$$

CREATE DEFINER = 'iasnap'@'%' TRIGGER `ff_storage_BDEL` BEFORE DELETE ON `ff_storage`
  FOR EACH ROW
begin
	if (@disable_triggers is null) then
    	DELETE FROM `ff_types` 
		where id=old.`type`;
    end if;
end$$

DELIMITER ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;