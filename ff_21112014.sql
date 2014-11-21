# SQL Manager for MySQL 5.4.3.43929
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
DROP TABLE IF EXISTS `ff_route_action_for_cnap`;
DROP TABLE IF EXISTS `ff_route_action`;
DROP TABLE IF EXISTS `ff_route`;
DROP TABLE IF EXISTS `ff_registry_storage`;
DROP TABLE IF EXISTS `ff_storage`;
DROP TABLE IF EXISTS `ff_registry_h`;
DROP TABLE IF EXISTS `ff_ref_multiguide`;
DROP TABLE IF EXISTS `ff_oneline`;
DROP TABLE IF EXISTS `ff_field`;
DROP TABLE IF EXISTS `ff_registry`;
DROP TABLE IF EXISTS `ff_document_cnap_metolobruht`;
DROP TABLE IF EXISTS `ff_document_cnap`;
DROP TABLE IF EXISTS `ff_document_base`;
DROP TABLE IF EXISTS `ff_default`;
DROP TABLE IF EXISTS `ff_commentline`;
DROP TABLE IF EXISTS `ff_available_nodes_for_users`;
DROP TABLE IF EXISTS `ff_available_nodes_for_roles`;
DROP TABLE IF EXISTS `ff_available_nodes_for_cnap`;
DROP TABLE IF EXISTS `ff_available_nodes`;
DROP TABLE IF EXISTS `ff_available_actions_for_users`;
DROP TABLE IF EXISTS `ff_available_actions_for_roles`;
DROP TABLE IF EXISTS `ff_available_actions_for_cnap`;
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
AVG_ROW_LENGTH=442 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_available_actions_for_cnap`: 
#

CREATE TABLE `ff_available_actions_for_cnap` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 42,
  `storage` INTEGER(11) DEFAULT NULL,
  `action` BIGINT(20) DEFAULT NULL,
  `node` BIGINT(20) DEFAULT NULL,
  `users` INTEGER(11) DEFAULT NULL,
  `roles` INTEGER(11) DEFAULT NULL,
  `authorities` INTEGER(11) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
AVG_ROW_LENGTH=585 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
AVG_ROW_LENGTH=481 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_available_nodes_for_cnap`: 
#

CREATE TABLE `ff_available_nodes_for_cnap` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 41,
  `storage` INTEGER(11) DEFAULT NULL,
  `node` BIGINT(20) DEFAULT NULL,
  `users` INTEGER(11) DEFAULT NULL,
  `roles` INTEGER(11) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
AVG_ROW_LENGTH=564 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
   INDEX `FK_STORAGE_idx` USING BTREE (`storage`) COMMENT '',
   INDEX `FK_REGISTRY_IDX` USING BTREE (`registry`) COMMENT ''
)ENGINE=InnoDB
AUTO_INCREMENT=2019 AVG_ROW_LENGTH=112 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT='Корневая родительская форма. Ее наследуют все другие таблицы сформированые при помощи свободных форм '
;

#
# Структура для таблицы `ff_document_base`: 
#

CREATE TABLE `ff_document_base` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 13,
  `storage` INTEGER(11) DEFAULT NULL,
  `createdate` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `route` INTEGER(11) DEFAULT NULL,
  `available_nodes` INTEGER(11) DEFAULT NULL,
  `available_actions` INTEGER(11) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT '',
   INDEX `indx_registry` USING BTREE (`registry`) COMMENT '',
   INDEX `indx_storage` USING BTREE (`storage`) COMMENT ''
)ENGINE=InnoDB
AVG_ROW_LENGTH=8192 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_document_cnap`: 
#

CREATE TABLE `ff_document_cnap` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 36,
  `storage` INTEGER(11) DEFAULT NULL,
  `createdate` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `route` INTEGER(11) DEFAULT NULL,
  `available_nodes` INTEGER(11) DEFAULT NULL,
  `available_actions` INTEGER(11) DEFAULT NULL,
  `regnum` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `regdate` DATE DEFAULT NULL,
  `legal_personality` INTEGER(11) DEFAULT NULL,
  `person_name` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `person_drfo` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `address` TEXT COLLATE utf8_general_ci,
  `phone1` VARCHAR(20) COLLATE utf8_general_ci DEFAULT NULL,
  `phone2` VARCHAR(20) COLLATE utf8_general_ci DEFAULT NULL,
  `delivery_reply` INTEGER(11) DEFAULT NULL,
  `email` VARCHAR(70) COLLATE utf8_general_ci DEFAULT NULL,
  `service` INTEGER(11) DEFAULT NULL,
  `context` TEXT COLLATE utf8_general_ci,
  `reason` TEXT COLLATE utf8_general_ci,
  `reply` INTEGER(11) DEFAULT NULL,
  `file_petition` LONGBLOB,
  `file_petition_fileedsname` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `plandate` DATE DEFAULT NULL,
  `factdate` DATE DEFAULT NULL,
  `administrator` INTEGER(11) DEFAULT NULL,
  `executor` INTEGER(11) DEFAULT NULL,
  `file_result` LONGBLOB,
  `file_result_fileedsname` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `authorities` INTEGER(11) DEFAULT NULL,
  `organization_name` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `organization_edrpou` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `outnum` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `outdate` DATE DEFAULT NULL,
  `its_autority` TINYINT(4) DEFAULT NULL,
  `autority_person_name` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `autority_person_number` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `number_of_pages` INTEGER(11) DEFAULT NULL,
  `delivery` INTEGER(11) DEFAULT NULL,
  `renewal_date` DATE DEFAULT NULL,
  `exec_date` DATE DEFAULT NULL,
  `executor_post` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `result_delivery` TINYINT(4) DEFAULT NULL,
  `result_date_delivery` DATE DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
AVG_ROW_LENGTH=8192 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_document_cnap_metolobruht`: 
#

CREATE TABLE `ff_document_cnap_metolobruht` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 38,
  `storage` INTEGER(11) DEFAULT NULL,
  `createdate` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `route` INTEGER(11) DEFAULT NULL,
  `available_nodes` INTEGER(11) DEFAULT NULL,
  `available_actions` INTEGER(11) DEFAULT NULL,
  `regnum` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `regdate` DATE DEFAULT NULL,
  `legal_personality` INTEGER(11) DEFAULT NULL,
  `person_name` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `person_drfo` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `address` TEXT COLLATE utf8_general_ci,
  `phone1` VARCHAR(20) COLLATE utf8_general_ci DEFAULT NULL,
  `phone2` VARCHAR(20) COLLATE utf8_general_ci DEFAULT NULL,
  `delivery_reply` INTEGER(11) DEFAULT NULL,
  `email` VARCHAR(70) COLLATE utf8_general_ci DEFAULT NULL,
  `service` INTEGER(11) DEFAULT NULL,
  `context` TEXT COLLATE utf8_general_ci,
  `reason` TEXT COLLATE utf8_general_ci,
  `reply` INTEGER(11) DEFAULT NULL,
  `file_petition` LONGBLOB,
  `file_petition_fileedsname` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `plandate` DATE DEFAULT NULL,
  `factdate` DATE DEFAULT NULL,
  `administrator` INTEGER(11) DEFAULT NULL,
  `executor` INTEGER(11) DEFAULT NULL,
  `file_result` LONGBLOB,
  `file_result_fileedsname` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `authorities` INTEGER(11) DEFAULT NULL,
  `organization_name` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `organization_edrpou` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `outnum` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `outdate` DATE DEFAULT NULL,
  `its_autority` TINYINT(4) DEFAULT NULL,
  `autority_person_name` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `autority_person_number` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `number_of_pages` INTEGER(11) DEFAULT NULL,
  `delivery` INTEGER(11) DEFAULT NULL,
  `renewal_date` DATE DEFAULT NULL,
  `exec_date` DATE DEFAULT NULL,
  `executor_post` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `result_delivery` TINYINT(4) DEFAULT NULL,
  `result_date_delivery` DATE DEFAULT NULL,
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
AUTO_INCREMENT=43 AVG_ROW_LENGTH=546 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
AUTO_INCREMENT=342 AVG_ROW_LENGTH=88 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
AVG_ROW_LENGTH=409 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
  `owner_field` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `reference` BIGINT(20) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT '',
   INDEX `fk_owner_idx` USING BTREE (`owner`) COMMENT '',
  CONSTRAINT `fk_owner` FOREIGN KEY (`owner`) REFERENCES `ff_default` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
)ENGINE=InnoDB
AVG_ROW_LENGTH=167 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
   INDEX `fk_parent_idx` USING BTREE (`parent`) COMMENT '',
   INDEX `idx_owner` USING BTREE (`owner`) COMMENT ''
)ENGINE=InnoDB
AUTO_INCREMENT=150 AVG_ROW_LENGTH=190 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
  `fields` TINYTEXT COLLATE utf8_general_ci,
  PRIMARY KEY USING BTREE (`id`) COMMENT '',
   INDEX `idx_type` USING BTREE (`type`) COMMENT ''
)ENGINE=InnoDB
AUTO_INCREMENT=24 AVG_ROW_LENGTH=780 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
AUTO_INCREMENT=117 AVG_ROW_LENGTH=546 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
  `currentuser` TINYINT(4) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
AVG_ROW_LENGTH=2048 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
COMMENT=''
;

#
# Структура для таблицы `ff_route_action_for_cnap`: 
#

CREATE TABLE `ff_route_action_for_cnap` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 40,
  `storage` INTEGER(11) DEFAULT NULL,
  `name` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `comment` TEXT COLLATE utf8_general_ci,
  `gotonodes` INTEGER(11) DEFAULT NULL,
  `clearnodes` INTEGER(11) DEFAULT NULL,
  `currentuser` TINYINT(4) DEFAULT NULL,
  `default_attributes` INTEGER(11) DEFAULT NULL,
  `roles` INTEGER(11) DEFAULT NULL,
  `users` INTEGER(11) DEFAULT NULL,
  `clearuser` TINYINT(4) DEFAULT NULL,
  `current_authorities` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
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
  `roles` INTEGER(11) DEFAULT NULL,
  `currentrole` TINYINT(4) DEFAULT NULL,
  `currentuser` TINYINT(4) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
AVG_ROW_LENGTH=5461 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
  `users` INTEGER(11) DEFAULT NULL,
  `ownernodes` INTEGER(11) DEFAULT NULL,
  `currentuser` TINYINT(4) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
AVG_ROW_LENGTH=3276 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
AVG_ROW_LENGTH=5461 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
AVG_ROW_LENGTH=5461 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
  `deny_new` INTEGER(11) DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
AVG_ROW_LENGTH=1638 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
  `currentuser` TINYINT(4) DEFAULT NULL,
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
AVG_ROW_LENGTH=2340 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
AUTO_INCREMENT=1021 AVG_ROW_LENGTH=481 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
	DECLARE cur1 cursor for select `tablename` from `ff_registry` where `attaching`=0;
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
# Data for the `ff_available_actions` table  (LIMIT -460,500)
#

INSERT INTO `ff_available_actions` (`id`, `registry`, `storage`, `action`, `node`) VALUES

  (1230,42,14,584,543),
  (1233,42,14,559,541),
  (1236,42,14,563,541),
  (1267,42,14,559,541),
  (1269,42,14,563,541),
  (1278,21,14,548,537),
  (1284,21,14,548,537),
  (1290,21,14,548,537),
  (1313,42,14,559,541),
  (1315,42,14,563,541),
  (1357,42,14,584,543),
  (1361,42,14,559,541),
  (1365,42,14,563,541),
  (1508,42,14,584,543),
  (1516,42,14,577,546),
  (1520,42,14,582,546),
  (1574,42,14,584,543),
  (1617,42,14,553,540),
  (1625,42,14,559,541),
  (1627,42,14,563,541),
  (1651,42,14,553,540),
  (1682,42,14,553,540),
  (1783,42,14,553,540),
  (1801,42,14,553,540),
  (1819,42,14,553,540),
  (1837,42,14,553,540),
  (1911,42,14,584,543),
  (1919,42,14,577,546),
  (1923,42,14,582,546),
  (1957,42,14,553,540),
  (1972,21,14,559,541),
  (1973,21,14,563,541),
  (1980,21,14,559,541),
  (1981,21,14,563,541),
  (1988,21,14,559,541),
  (1989,21,14,563,541),
  (2005,42,14,553,540),
  (2014,21,14,559,541),
  (2015,21,14,563,541);
COMMIT;

#
# Data for the `ff_available_actions_for_cnap` table  (LIMIT -471,500)
#

INSERT INTO `ff_available_actions_for_cnap` (`id`, `registry`, `storage`, `action`, `node`, `users`, `roles`, `authorities`) VALUES

  (1230,42,14,584,543,NULL,NULL,NULL),
  (1233,42,14,559,541,NULL,NULL,NULL),
  (1236,42,14,563,541,NULL,NULL,NULL),
  (1267,42,14,559,541,NULL,NULL,NULL),
  (1269,42,14,563,541,NULL,NULL,NULL),
  (1313,42,14,559,541,NULL,NULL,NULL),
  (1315,42,14,563,541,NULL,NULL,NULL),
  (1357,42,14,584,543,NULL,NULL,NULL),
  (1361,42,14,559,541,NULL,NULL,NULL),
  (1365,42,14,563,541,NULL,NULL,NULL),
  (1508,42,14,584,543,NULL,NULL,NULL),
  (1516,42,14,577,546,NULL,NULL,NULL),
  (1520,42,14,582,546,NULL,NULL,NULL),
  (1574,42,14,584,543,NULL,NULL,NULL),
  (1617,42,14,553,540,NULL,NULL,NULL),
  (1625,42,14,559,541,NULL,NULL,NULL),
  (1627,42,14,563,541,NULL,NULL,NULL),
  (1651,42,14,553,540,NULL,NULL,NULL),
  (1682,42,14,553,540,NULL,NULL,NULL),
  (1783,42,14,553,540,NULL,NULL,NULL),
  (1801,42,14,553,540,NULL,NULL,NULL),
  (1819,42,14,553,540,NULL,NULL,NULL),
  (1837,42,14,553,540,NULL,NULL,NULL),
  (1911,42,14,584,543,NULL,NULL,NULL),
  (1919,42,14,577,546,NULL,NULL,NULL),
  (1923,42,14,582,546,NULL,NULL,NULL),
  (1957,42,14,553,540,NULL,NULL,NULL),
  (2005,42,14,553,540,NULL,NULL,NULL);
COMMIT;

#
# Data for the `ff_available_nodes` table  (LIMIT -464,500)
#

INSERT INTO `ff_available_nodes` (`id`, `registry`, `storage`, `node`) VALUES

  (1224,41,11,539),
  (1227,41,11,543),
  (1349,41,11,539),
  (1353,41,11,543),
  (1383,41,11,538),
  (1504,41,11,543),
  (1512,41,11,547),
  (1531,41,11,539),
  (1571,41,11,544),
  (1593,41,11,538),
  (1611,41,11,538),
  (1614,41,11,540),
  (1623,41,11,541),
  (1645,41,11,538),
  (1648,41,11,540),
  (1676,41,11,538),
  (1679,41,11,540),
  (1777,41,11,538),
  (1780,41,11,540),
  (1795,41,11,538),
  (1798,41,11,540),
  (1813,41,11,538),
  (1816,41,11,540),
  (1831,41,11,538),
  (1834,41,11,540),
  (1859,41,11,538),
  (1934,41,11,544),
  (1951,41,11,538),
  (1954,41,11,540),
  (1971,16,11,541),
  (1979,16,11,541),
  (1987,16,11,541),
  (1999,41,11,538),
  (2002,41,11,540),
  (2013,16,11,541);
COMMIT;

#
# Data for the `ff_available_nodes_for_cnap` table  (LIMIT -468,500)
#

INSERT INTO `ff_available_nodes_for_cnap` (`id`, `registry`, `storage`, `node`, `users`, `roles`) VALUES

  (1224,41,11,539,NULL,NULL),
  (1227,41,11,543,NULL,NULL),
  (1349,41,11,539,NULL,NULL),
  (1353,41,11,543,NULL,NULL),
  (1383,41,11,538,NULL,NULL),
  (1504,41,11,543,NULL,NULL),
  (1512,41,11,547,NULL,NULL),
  (1531,41,11,539,NULL,NULL),
  (1571,41,11,544,NULL,NULL),
  (1593,41,11,538,NULL,NULL),
  (1611,41,11,538,NULL,NULL),
  (1614,41,11,540,NULL,NULL),
  (1623,41,11,541,NULL,NULL),
  (1645,41,11,538,NULL,NULL),
  (1648,41,11,540,NULL,NULL),
  (1676,41,11,538,NULL,NULL),
  (1679,41,11,540,NULL,NULL),
  (1777,41,11,538,NULL,NULL),
  (1780,41,11,540,NULL,NULL),
  (1795,41,11,538,NULL,NULL),
  (1798,41,11,540,NULL,NULL),
  (1813,41,11,538,NULL,NULL),
  (1816,41,11,540,NULL,NULL),
  (1831,41,11,538,NULL,NULL),
  (1834,41,11,540,NULL,NULL),
  (1859,41,11,538,NULL,NULL),
  (1934,41,11,544,NULL,NULL),
  (1951,41,11,538,NULL,NULL),
  (1954,41,11,540,NULL,NULL),
  (1999,41,11,538,NULL,NULL),
  (2002,41,11,540,NULL,NULL);
COMMIT;

#
# Data for the `ff_default` table  (LIMIT 1,500)
#

INSERT INTO `ff_default` (`id`, `registry`, `storage`) VALUES

  (1,12,7),
  (2,2,2),
  (3,12,7),
  (4,2,2),
  (5,3,15),
  (6,3,15),
  (7,3,15),
  (8,12,7),
  (9,2,2),
  (14,2,2),
  (15,2,2),
  (16,2,2),
  (23,2,2),
  (24,2,2),
  (25,2,2),
  (26,2,2),
  (27,2,2),
  (28,2,2),
  (29,2,2),
  (30,2,2),
  (31,2,2),
  (32,2,2),
  (33,2,2),
  (34,2,2),
  (35,2,2),
  (36,2,2),
  (37,2,2),
  (38,2,2),
  (39,2,2),
  (40,2,2),
  (41,2,2),
  (42,2,2),
  (49,2,2),
  (50,2,2),
  (51,2,2),
  (52,2,2),
  (53,2,2),
  (54,2,2),
  (55,2,2),
  (56,2,2),
  (57,2,2),
  (58,2,2),
  (59,2,2),
  (60,2,2),
  (61,2,2),
  (62,2,2),
  (63,2,2),
  (64,2,2),
  (65,2,2),
  (66,2,2),
  (67,2,2),
  (69,2,2),
  (70,2,2),
  (71,2,2),
  (72,2,2),
  (73,2,2),
  (74,2,2),
  (75,2,2),
  (76,2,2),
  (77,2,2),
  (78,2,2),
  (79,2,2),
  (80,2,2),
  (81,2,2),
  (88,3,19),
  (89,3,19),
  (90,3,19),
  (91,3,20),
  (92,3,20),
  (93,3,20),
  (95,2,2),
  (96,2,2),
  (97,2,2),
  (99,2,2),
  (100,2,2),
  (102,2,2),
  (103,2,2),
  (105,2,2),
  (106,2,2),
  (107,2,2),
  (109,2,2),
  (111,2,2),
  (112,2,2),
  (113,2,2),
  (114,2,2),
  (116,2,2),
  (117,2,2),
  (118,2,2),
  (119,2,2),
  (121,2,2),
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
  (145,2,2),
  (146,2,2),
  (147,2,2),
  (148,28,5),
  (149,2,2),
  (169,2,2),
  (170,2,2),
  (171,2,2),
  (172,2,2),
  (181,2,2),
  (182,2,2),
  (183,2,2),
  (184,2,2),
  (185,2,2),
  (186,2,2),
  (188,2,2),
  (189,2,2),
  (190,2,2),
  (191,2,2),
  (192,2,2),
  (203,2,2),
  (204,2,2),
  (205,2,2),
  (206,2,2),
  (207,2,2),
  (208,2,2),
  (218,2,2),
  (219,2,2),
  (220,2,2),
  (221,2,2),
  (222,2,2),
  (223,2,2),
  (225,2,2),
  (226,2,2),
  (227,2,2),
  (236,2,2),
  (237,2,2),
  (238,2,2),
  (239,2,2),
  (240,2,2),
  (241,2,2),
  (251,2,2),
  (252,2,2),
  (253,2,2),
  (254,2,2),
  (255,2,2),
  (256,2,2),
  (266,2,2),
  (267,2,2),
  (268,2,2),
  (269,2,2),
  (270,2,2),
  (271,2,2),
  (281,2,2),
  (282,2,2),
  (283,2,2),
  (284,2,2),
  (285,2,2),
  (286,2,2),
  (292,2,2),
  (293,2,2),
  (294,2,2),
  (295,2,2),
  (296,2,2),
  (299,2,2),
  (300,2,2),
  (309,2,2),
  (310,2,2),
  (311,2,2),
  (312,2,2),
  (313,2,2),
  (314,2,2),
  (320,2,2),
  (321,2,2),
  (322,2,2),
  (323,2,2),
  (324,2,2),
  (333,2,2),
  (334,2,2),
  (335,2,2),
  (336,2,2),
  (337,2,2),
  (338,2,2),
  (344,2,2),
  (345,2,2),
  (346,2,2),
  (347,2,2),
  (348,2,2),
  (351,2,2),
  (352,2,2),
  (361,2,2),
  (362,2,2),
  (363,2,2),
  (364,2,2),
  (365,2,2),
  (366,2,2),
  (372,2,2),
  (373,2,2),
  (374,2,2),
  (375,2,2),
  (376,2,2),
  (385,2,2),
  (386,2,2),
  (387,2,2),
  (388,2,2),
  (389,2,2),
  (390,2,2),
  (396,2,2),
  (397,2,2),
  (398,2,2),
  (399,2,2),
  (400,2,2),
  (401,2,2),
  (402,2,2),
  (403,2,2),
  (405,2,2),
  (406,2,2),
  (407,2,2),
  (408,2,2),
  (409,2,2),
  (410,2,2),
  (411,2,2),
  (420,2,2),
  (421,2,2),
  (422,2,2),
  (423,2,2),
  (424,2,2),
  (425,2,2),
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
  (444,2,2),
  (445,2,2),
  (446,2,2),
  (447,2,2),
  (449,2,2),
  (450,2,2),
  (451,2,2),
  (452,2,2),
  (453,2,2),
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
  (472,2,2),
  (473,2,2),
  (474,2,2),
  (475,2,2),
  (476,2,2),
  (477,2,2),
  (478,2,2),
  (479,2,2),
  (480,2,2),
  (481,2,2),
  (482,2,2),
  (483,2,2),
  (484,2,2),
  (485,2,2),
  (486,2,2),
  (487,2,2),
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
  (504,2,2),
  (505,2,2),
  (506,2,2),
  (507,2,2),
  (508,2,2),
  (509,2,2),
  (510,2,2),
  (511,2,2),
  (512,2,2),
  (513,2,2),
  (514,2,2),
  (515,2,2),
  (516,2,2),
  (517,2,2),
  (518,2,2),
  (519,2,2),
  (520,2,2),
  (521,2,2),
  (522,2,2),
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
  (534,2,2),
  (535,2,2),
  (537,6,4),
  (538,6,4),
  (539,6,4),
  (540,6,4),
  (541,6,4),
  (542,6,4),
  (543,6,4),
  (544,6,4),
  (545,6,4),
  (546,6,4),
  (547,6,4),
  (548,40,3),
  (549,2,2),
  (550,2,2),
  (551,2,2),
  (552,2,2),
  (553,40,3),
  (554,2,2),
  (555,2,2),
  (556,2,2),
  (557,2,2),
  (558,2,2),
  (559,40,3),
  (560,2,2),
  (561,2,2),
  (562,2,2),
  (563,40,3),
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
  (574,40,3),
  (575,2,2),
  (576,2,2),
  (577,40,3),
  (578,2,2),
  (579,2,2),
  (580,2,2),
  (581,2,2),
  (582,40,3),
  (583,2,2),
  (584,40,3),
  (585,2,2),
  (586,2,2),
  (587,2,2),
  (588,2,2),
  (589,2,2),
  (590,2,2),
  (591,2,2),
  (592,2,2),
  (593,2,2),
  (594,2,2),
  (595,2,2),
  (596,2,2),
  (597,2,2),
  (598,2,2),
  (599,2,2),
  (600,2,2),
  (601,2,2),
  (602,2,2),
  (603,2,2),
  (604,2,2),
  (605,2,2),
  (606,2,2),
  (607,2,2),
  (608,2,2),
  (609,2,2),
  (610,2,2),
  (611,2,2),
  (612,8,6),
  (613,2,2),
  (614,2,2),
  (615,2,2),
  (616,2,2),
  (617,2,2),
  (618,8,6),
  (619,2,2),
  (620,8,6),
  (621,2,2),
  (622,8,6),
  (623,2,2),
  (624,8,6),
  (625,2,2),
  (626,8,6),
  (627,2,2),
  (628,8,6),
  (629,2,2),
  (630,8,6),
  (631,2,2),
  (632,8,6),
  (633,2,2),
  (634,8,6),
  (635,2,2),
  (636,2,2),
  (637,2,2),
  (638,2,2),
  (639,2,2),
  (640,2,2),
  (641,2,2),
  (642,2,2),
  (643,2,2),
  (644,2,2),
  (645,2,2),
  (646,2,2),
  (647,2,2),
  (648,2,2),
  (649,2,2),
  (650,8,6),
  (651,2,2),
  (652,2,2),
  (653,2,2),
  (654,2,2),
  (655,2,2),
  (656,2,2),
  (661,2,2),
  (665,2,2),
  (666,2,2),
  (670,2,2),
  (671,2,2),
  (672,2,2),
  (673,2,2),
  (674,2,2),
  (675,2,2),
  (680,2,2),
  (681,2,2),
  (683,2,2),
  (684,2,2),
  (686,2,2),
  (687,2,2),
  (689,2,2),
  (690,2,2),
  (691,2,2),
  (692,2,2),
  (693,2,2),
  (694,2,2),
  (695,2,2),
  (696,2,2),
  (697,2,2),
  (698,2,2),
  (699,2,2),
  (700,2,2),
  (701,2,2),
  (702,2,2),
  (703,2,2),
  (704,2,2),
  (705,2,2),
  (706,2,2),
  (707,2,2),
  (708,2,2),
  (709,2,2),
  (710,2,2),
  (711,2,2),
  (712,2,2),
  (713,2,2),
  (714,2,2),
  (715,2,2),
  (716,2,2),
  (717,2,2),
  (718,2,2);
COMMIT;

#
# Data for the `ff_default` table  (LIMIT 501,500)
#

INSERT INTO `ff_default` (`id`, `registry`, `storage`) VALUES

  (719,2,2),
  (720,2,2),
  (721,2,2),
  (722,2,2),
  (723,2,2),
  (724,2,2),
  (729,2,2),
  (730,2,2),
  (732,2,2),
  (733,2,2),
  (735,2,2),
  (736,2,2),
  (738,2,2),
  (739,2,2),
  (740,2,2),
  (741,2,2),
  (742,2,2),
  (743,2,2),
  (744,2,2),
  (745,2,2),
  (746,2,2),
  (747,2,2),
  (748,2,2),
  (749,2,2),
  (750,2,2),
  (751,2,2),
  (753,2,2),
  (755,2,2),
  (757,2,2),
  (758,2,2),
  (759,2,2),
  (760,2,2),
  (761,2,2),
  (762,2,2),
  (763,2,2),
  (764,2,2),
  (765,2,2),
  (770,2,2),
  (771,2,2),
  (773,2,2),
  (774,2,2),
  (776,2,2),
  (777,2,2),
  (779,2,2),
  (780,2,2),
  (781,2,2),
  (782,2,2),
  (783,2,2),
  (788,2,2),
  (789,2,2),
  (791,2,2),
  (792,2,2),
  (794,2,2),
  (795,2,2),
  (797,2,2),
  (798,2,2),
  (799,2,2),
  (800,2,2),
  (801,2,2),
  (806,2,2),
  (807,2,2),
  (809,2,2),
  (810,2,2),
  (812,2,2),
  (813,2,2),
  (815,2,2),
  (816,2,2),
  (817,2,2),
  (818,2,2),
  (819,2,2),
  (820,2,2),
  (821,2,2),
  (823,2,2),
  (825,2,2),
  (827,2,2),
  (828,2,2),
  (829,2,2),
  (830,2,2),
  (831,2,2),
  (833,2,2),
  (835,2,2),
  (837,2,2),
  (838,2,2),
  (839,2,2),
  (840,2,2),
  (841,2,2),
  (846,2,2),
  (847,2,2),
  (849,2,2),
  (850,2,2),
  (852,2,2),
  (853,2,2),
  (855,2,2),
  (856,2,2),
  (857,2,2),
  (858,2,2),
  (859,2,2),
  (861,2,2),
  (863,2,2),
  (865,2,2),
  (866,2,2),
  (867,2,2),
  (868,2,2),
  (869,2,2),
  (874,2,2),
  (875,2,2),
  (877,2,2),
  (878,2,2),
  (880,2,2),
  (881,2,2),
  (883,2,2),
  (884,2,2),
  (885,2,2),
  (886,2,2),
  (887,2,2),
  (892,2,2),
  (893,2,2),
  (895,2,2),
  (896,2,2),
  (898,2,2),
  (899,2,2),
  (901,2,2),
  (902,2,2),
  (903,2,2),
  (904,2,2),
  (905,2,2),
  (907,2,2),
  (909,2,2),
  (911,2,2),
  (912,2,2),
  (913,2,2),
  (914,2,2),
  (915,2,2),
  (917,2,2),
  (919,2,2),
  (921,2,2),
  (923,2,2),
  (925,2,2),
  (926,2,2),
  (927,2,2),
  (928,2,2),
  (929,2,2),
  (930,2,2),
  (931,2,2),
  (932,2,2),
  (933,2,2),
  (934,2,2),
  (935,2,2),
  (936,2,2),
  (941,2,2),
  (942,2,2),
  (944,2,2),
  (945,2,2),
  (947,2,2),
  (948,2,2),
  (950,2,2),
  (951,2,2),
  (952,2,2),
  (953,2,2),
  (954,2,2),
  (956,2,2),
  (958,2,2),
  (960,2,2),
  (961,2,2),
  (962,2,2),
  (963,2,2),
  (964,2,2),
  (966,2,2),
  (968,2,2),
  (970,2,2),
  (972,2,2),
  (974,2,2),
  (975,2,2),
  (976,2,2),
  (977,2,2),
  (978,2,2),
  (979,2,2),
  (980,2,2),
  (981,2,2),
  (982,2,2),
  (987,2,2),
  (988,2,2),
  (990,2,2),
  (991,2,2),
  (993,2,2),
  (994,2,2),
  (996,2,2),
  (997,2,2),
  (998,2,2),
  (999,2,2),
  (1000,2,2),
  (1002,2,2),
  (1004,2,2),
  (1006,2,2),
  (1007,2,2),
  (1008,2,2),
  (1009,2,2),
  (1010,2,2),
  (1011,2,2),
  (1012,2,2),
  (1013,2,2),
  (1014,2,2),
  (1019,2,2),
  (1020,2,2),
  (1025,2,2),
  (1026,2,2),
  (1028,2,2),
  (1029,2,2),
  (1031,2,2),
  (1032,2,2),
  (1034,2,2),
  (1035,2,2),
  (1036,2,2),
  (1037,2,2),
  (1038,2,2),
  (1043,2,2),
  (1044,2,2),
  (1046,2,2),
  (1047,2,2),
  (1049,2,2),
  (1050,2,2),
  (1052,2,2),
  (1053,2,2),
  (1054,2,2),
  (1055,2,2),
  (1056,2,2),
  (1058,2,2),
  (1060,2,2),
  (1062,2,2),
  (1063,2,2),
  (1064,2,2),
  (1065,2,2),
  (1066,2,2),
  (1069,2,2),
  (1070,2,2),
  (1071,2,2),
  (1072,2,2),
  (1073,2,2),
  (1074,2,2),
  (1075,2,2),
  (1076,2,2),
  (1077,2,2),
  (1078,2,2),
  (1080,2,2),
  (1082,2,2),
  (1084,2,2),
  (1085,2,2),
  (1086,2,2),
  (1087,2,2),
  (1088,2,2),
  (1093,2,2),
  (1094,2,2),
  (1096,2,2),
  (1097,2,2),
  (1099,2,2),
  (1100,2,2),
  (1102,2,2),
  (1103,2,2),
  (1104,2,2),
  (1105,2,2),
  (1106,2,2),
  (1108,2,2),
  (1110,2,2),
  (1112,2,2),
  (1113,2,2),
  (1114,2,2),
  (1115,2,2),
  (1116,2,2),
  (1121,2,2),
  (1122,2,2),
  (1124,2,2),
  (1125,2,2),
  (1127,2,2),
  (1128,2,2),
  (1130,2,2),
  (1131,2,2),
  (1132,2,2),
  (1133,2,2),
  (1134,2,2),
  (1136,2,2),
  (1138,2,2),
  (1140,2,2),
  (1141,2,2),
  (1142,2,2),
  (1143,2,2),
  (1144,2,2),
  (1146,2,2),
  (1147,2,2),
  (1149,2,2),
  (1150,2,2),
  (1152,2,2),
  (1153,2,2),
  (1155,2,2),
  (1156,2,2),
  (1158,2,2),
  (1159,2,2),
  (1160,2,2),
  (1161,2,2),
  (1162,2,2),
  (1163,2,2),
  (1164,2,2),
  (1165,2,2),
  (1166,2,2),
  (1167,2,2),
  (1168,37,18),
  (1172,2,2),
  (1173,2,2),
  (1175,2,2),
  (1176,2,2),
  (1178,2,2),
  (1179,2,2),
  (1181,2,2),
  (1182,2,2),
  (1183,2,2),
  (1184,2,2),
  (1185,2,2),
  (1187,2,2),
  (1189,2,2),
  (1191,2,2),
  (1192,2,2),
  (1193,2,2),
  (1194,2,2),
  (1195,2,2),
  (1196,37,18),
  (1200,2,2),
  (1201,2,2),
  (1203,2,2),
  (1204,2,2),
  (1206,2,2),
  (1207,2,2),
  (1209,2,2),
  (1210,2,2),
  (1211,2,2),
  (1212,2,2),
  (1213,2,2),
  (1215,2,2),
  (1217,2,2),
  (1219,2,2),
  (1220,2,2),
  (1221,2,2),
  (1222,2,2),
  (1223,2,2),
  (1224,41,11),
  (1225,2,2),
  (1226,2,2),
  (1227,41,11),
  (1228,2,2),
  (1229,2,2),
  (1230,42,14),
  (1231,2,2),
  (1232,2,2),
  (1233,42,14),
  (1234,2,2),
  (1235,2,2),
  (1236,42,14),
  (1237,2,2),
  (1238,2,2),
  (1239,2,2),
  (1240,2,2),
  (1241,2,2),
  (1242,2,2),
  (1243,2,2),
  (1244,2,2),
  (1245,2,2),
  (1246,2,2),
  (1247,37,18),
  (1251,2,2),
  (1252,2,2),
  (1254,2,2),
  (1255,2,2),
  (1257,2,2),
  (1258,2,2),
  (1260,2,2),
  (1261,2,2),
  (1262,2,2),
  (1263,2,2),
  (1264,2,2),
  (1266,2,2),
  (1267,42,14),
  (1268,2,2),
  (1269,42,14),
  (1270,2,2),
  (1271,2,2),
  (1272,2,2),
  (1273,2,2),
  (1274,2,2),
  (1275,37,18),
  (1278,21,14),
  (1279,2,2),
  (1280,2,2),
  (1281,37,18),
  (1284,21,14),
  (1285,2,2),
  (1286,2,2),
  (1287,37,18),
  (1290,21,14),
  (1291,2,2),
  (1292,2,2),
  (1293,37,18),
  (1297,2,2),
  (1298,2,2),
  (1300,2,2),
  (1301,2,2),
  (1303,2,2),
  (1304,2,2),
  (1306,2,2),
  (1307,2,2),
  (1308,2,2),
  (1309,2,2),
  (1310,2,2),
  (1312,2,2),
  (1313,42,14),
  (1314,2,2),
  (1315,42,14),
  (1316,2,2),
  (1317,2,2),
  (1318,2,2),
  (1319,2,2),
  (1320,2,2),
  (1321,37,18),
  (1325,2,2),
  (1326,2,2),
  (1328,2,2),
  (1329,2,2),
  (1331,2,2),
  (1332,2,2),
  (1334,2,2),
  (1335,2,2),
  (1336,2,2),
  (1337,2,2),
  (1338,2,2),
  (1340,2,2),
  (1342,2,2),
  (1344,2,2),
  (1345,2,2),
  (1346,2,2),
  (1347,2,2),
  (1348,2,2),
  (1349,41,11),
  (1350,2,2),
  (1351,2,2),
  (1352,2,2),
  (1353,41,11),
  (1354,2,2),
  (1355,2,2),
  (1356,2,2),
  (1357,42,14),
  (1358,2,2),
  (1359,2,2),
  (1360,2,2),
  (1361,42,14),
  (1362,2,2),
  (1363,2,2),
  (1364,2,2),
  (1365,42,14),
  (1366,2,2),
  (1367,2,2),
  (1368,2,2),
  (1369,2,2),
  (1370,2,2),
  (1371,2,2),
  (1372,2,2),
  (1373,2,2),
  (1374,2,2),
  (1375,2,2),
  (1376,2,2),
  (1377,37,18),
  (1381,2,2),
  (1382,2,2),
  (1383,41,11),
  (1384,2,2),
  (1385,2,2),
  (1387,2,2),
  (1388,2,2),
  (1390,2,2),
  (1391,2,2),
  (1392,2,2),
  (1393,2,2),
  (1394,2,2),
  (1395,2,2),
  (1396,2,2),
  (1397,2,2),
  (1398,2,2),
  (1399,2,2),
  (1400,2,2),
  (1401,2,2),
  (1402,2,2),
  (1403,2,2),
  (1404,2,2),
  (1405,2,2),
  (1406,2,2),
  (1407,2,2),
  (1408,2,2),
  (1409,2,2),
  (1410,2,2),
  (1411,2,2),
  (1412,2,2),
  (1413,2,2),
  (1414,37,18),
  (1418,2,2);
COMMIT;

#
# Data for the `ff_default` table  (LIMIT 1001,500)
#

INSERT INTO `ff_default` (`id`, `registry`, `storage`) VALUES

  (1419,2,2),
  (1421,2,2),
  (1422,2,2),
  (1424,2,2),
  (1425,2,2),
  (1427,2,2),
  (1428,2,2),
  (1429,2,2),
  (1430,2,2),
  (1431,2,2),
  (1433,2,2),
  (1435,2,2),
  (1437,2,2),
  (1438,2,2),
  (1439,2,2),
  (1440,2,2),
  (1441,2,2),
  (1443,2,2),
  (1445,2,2),
  (1447,2,2),
  (1448,2,2),
  (1449,2,2),
  (1450,2,2),
  (1451,2,2),
  (1453,2,2),
  (1454,2,2),
  (1456,2,2),
  (1457,2,2),
  (1459,2,2),
  (1460,2,2),
  (1461,2,2),
  (1462,2,2),
  (1463,2,2),
  (1464,2,2),
  (1465,2,2),
  (1466,2,2),
  (1468,2,2),
  (1470,2,2),
  (1472,2,2),
  (1473,2,2),
  (1474,2,2),
  (1475,2,2),
  (1476,2,2),
  (1477,2,2),
  (1479,2,2),
  (1480,2,2),
  (1482,2,2),
  (1483,2,2),
  (1485,2,2),
  (1486,2,2),
  (1487,2,2),
  (1488,2,2),
  (1489,2,2),
  (1490,2,2),
  (1491,2,2),
  (1492,2,2),
  (1494,2,2),
  (1496,2,2),
  (1498,2,2),
  (1499,2,2),
  (1500,2,2),
  (1501,2,2),
  (1502,2,2),
  (1503,2,2),
  (1504,41,11),
  (1505,2,2),
  (1506,2,2),
  (1507,2,2),
  (1508,42,14),
  (1509,2,2),
  (1510,2,2),
  (1511,2,2),
  (1512,41,11),
  (1513,2,2),
  (1514,2,2),
  (1515,2,2),
  (1516,42,14),
  (1517,2,2),
  (1518,2,2),
  (1519,2,2),
  (1520,42,14),
  (1521,2,2),
  (1522,2,2),
  (1523,2,2),
  (1524,2,2),
  (1525,2,2),
  (1526,2,2),
  (1527,2,2),
  (1528,2,2),
  (1529,2,2),
  (1530,2,2),
  (1531,41,11),
  (1532,2,2),
  (1533,2,2),
  (1534,2,2),
  (1535,2,2),
  (1537,2,2),
  (1538,2,2),
  (1539,2,2),
  (1540,2,2),
  (1542,2,2),
  (1543,2,2),
  (1544,2,2),
  (1545,2,2),
  (1547,2,2),
  (1548,2,2),
  (1549,2,2),
  (1550,2,2),
  (1552,2,2),
  (1553,2,2),
  (1554,2,2),
  (1555,2,2),
  (1556,2,2),
  (1557,2,2),
  (1558,2,2),
  (1559,2,2),
  (1560,2,2),
  (1561,2,2),
  (1562,2,2),
  (1563,2,2),
  (1564,2,2),
  (1565,2,2),
  (1566,2,2),
  (1567,2,2),
  (1568,2,2),
  (1569,2,2),
  (1570,2,2),
  (1571,41,11),
  (1572,2,2),
  (1573,2,2),
  (1574,42,14),
  (1575,2,2),
  (1576,2,2),
  (1577,2,2),
  (1578,2,2),
  (1579,2,2),
  (1580,2,2),
  (1581,2,2),
  (1582,2,2),
  (1583,2,2),
  (1584,2,2),
  (1585,2,2),
  (1586,2,2),
  (1587,37,18),
  (1591,2,2),
  (1592,2,2),
  (1593,41,11),
  (1594,2,2),
  (1595,2,2),
  (1597,2,2),
  (1598,2,2),
  (1600,2,2),
  (1601,2,2),
  (1602,2,2),
  (1603,2,2),
  (1604,2,2),
  (1605,37,18),
  (1609,2,2),
  (1610,2,2),
  (1611,41,11),
  (1612,2,2),
  (1613,2,2),
  (1614,41,11),
  (1615,2,2),
  (1616,2,2),
  (1617,42,14),
  (1618,2,2),
  (1619,2,2),
  (1620,2,2),
  (1621,2,2),
  (1622,2,2),
  (1623,41,11),
  (1624,2,2),
  (1625,42,14),
  (1626,2,2),
  (1627,42,14),
  (1628,2,2),
  (1629,2,2),
  (1630,2,2),
  (1631,2,2),
  (1632,2,2),
  (1633,2,2),
  (1634,2,2),
  (1635,2,2),
  (1636,2,2),
  (1637,2,2),
  (1638,2,2),
  (1639,37,18),
  (1643,2,2),
  (1644,2,2),
  (1645,41,11),
  (1646,2,2),
  (1647,2,2),
  (1648,41,11),
  (1649,2,2),
  (1650,2,2),
  (1651,42,14),
  (1652,2,2),
  (1653,2,2),
  (1654,2,2),
  (1655,2,2),
  (1656,2,2),
  (1657,2,2),
  (1658,2,2),
  (1659,2,2),
  (1660,2,2),
  (1661,2,2),
  (1662,2,2),
  (1663,2,2),
  (1664,2,2),
  (1665,2,2),
  (1666,2,2),
  (1667,2,2),
  (1668,2,2),
  (1669,2,2),
  (1670,37,18),
  (1674,2,2),
  (1675,2,2),
  (1676,41,11),
  (1677,2,2),
  (1678,2,2),
  (1679,41,11),
  (1680,2,2),
  (1681,2,2),
  (1682,42,14),
  (1683,2,2),
  (1684,2,2),
  (1685,2,2),
  (1686,2,2),
  (1687,2,2),
  (1688,2,2),
  (1689,2,2),
  (1690,2,2),
  (1691,2,2),
  (1692,2,2),
  (1693,2,2),
  (1694,2,2),
  (1695,2,2),
  (1696,2,2),
  (1697,2,2),
  (1698,2,2),
  (1699,2,2),
  (1700,2,2),
  (1701,2,2),
  (1702,2,2),
  (1703,2,2),
  (1704,2,2),
  (1705,2,2),
  (1706,8,6),
  (1707,2,2),
  (1708,2,2),
  (1709,2,2),
  (1710,2,2),
  (1711,2,2),
  (1712,2,2),
  (1713,2,2),
  (1714,2,2),
  (1715,2,2),
  (1716,2,2),
  (1717,2,2),
  (1718,2,2),
  (1719,2,2),
  (1720,2,2),
  (1721,2,2),
  (1722,2,2),
  (1723,2,2),
  (1724,2,2),
  (1725,2,2),
  (1726,2,2),
  (1727,2,2),
  (1728,2,2),
  (1729,2,2),
  (1730,2,2),
  (1731,2,2),
  (1732,2,2),
  (1733,2,2),
  (1734,2,2),
  (1735,2,2),
  (1736,2,2),
  (1737,2,2),
  (1738,2,2),
  (1739,2,2),
  (1740,2,2),
  (1741,2,2),
  (1742,28,5),
  (1743,2,2),
  (1744,2,2),
  (1745,2,2),
  (1746,2,2),
  (1747,2,2),
  (1748,2,2),
  (1749,2,2),
  (1750,2,2),
  (1751,2,2),
  (1752,2,2),
  (1753,2,2),
  (1754,2,2),
  (1755,2,2),
  (1756,2,2),
  (1757,2,2),
  (1758,2,2),
  (1759,2,2),
  (1760,2,2),
  (1761,2,2),
  (1762,2,2),
  (1763,2,2),
  (1764,2,2),
  (1765,2,2),
  (1766,2,2),
  (1767,2,2),
  (1768,2,2),
  (1769,2,2),
  (1770,2,2),
  (1771,37,18),
  (1775,2,2),
  (1776,2,2),
  (1777,41,11),
  (1778,2,2),
  (1779,2,2),
  (1780,41,11),
  (1781,2,2),
  (1782,2,2),
  (1783,42,14),
  (1784,2,2),
  (1785,2,2),
  (1786,2,2),
  (1787,2,2),
  (1788,2,2),
  (1789,37,18),
  (1793,2,2),
  (1794,2,2),
  (1795,41,11),
  (1796,2,2),
  (1797,2,2),
  (1798,41,11),
  (1799,2,2),
  (1800,2,2),
  (1801,42,14),
  (1802,2,2),
  (1803,2,2),
  (1804,2,2),
  (1805,2,2),
  (1806,2,2),
  (1807,37,18),
  (1811,2,2),
  (1812,2,2),
  (1813,41,11),
  (1814,2,2),
  (1815,2,2),
  (1816,41,11),
  (1817,2,2),
  (1818,2,2),
  (1819,42,14),
  (1820,2,2),
  (1821,2,2),
  (1822,2,2),
  (1823,2,2),
  (1824,2,2),
  (1825,37,18),
  (1829,2,2),
  (1830,2,2),
  (1831,41,11),
  (1832,2,2),
  (1833,2,2),
  (1834,41,11),
  (1835,2,2),
  (1836,2,2),
  (1837,42,14),
  (1838,2,2),
  (1839,2,2),
  (1840,2,2),
  (1841,2,2),
  (1842,2,2),
  (1843,37,18),
  (1844,37,18),
  (1845,37,18),
  (1846,37,18),
  (1847,37,18),
  (1848,37,18),
  (1849,37,18),
  (1850,37,18),
  (1851,37,18),
  (1852,37,18),
  (1853,37,18),
  (1857,2,2),
  (1858,2,2),
  (1859,41,11),
  (1860,2,2),
  (1861,2,2),
  (1863,2,2),
  (1864,2,2),
  (1866,2,2),
  (1867,2,2),
  (1868,2,2),
  (1869,2,2),
  (1870,2,2),
  (1872,2,2),
  (1874,2,2),
  (1876,2,2),
  (1877,2,2),
  (1878,2,2),
  (1879,2,2),
  (1880,2,2),
  (1882,2,2),
  (1883,2,2),
  (1885,2,2),
  (1886,2,2),
  (1888,2,2),
  (1889,2,2),
  (1890,2,2),
  (1891,2,2),
  (1892,2,2),
  (1893,2,2),
  (1894,2,2),
  (1895,2,2),
  (1897,2,2),
  (1899,2,2),
  (1901,2,2),
  (1902,2,2),
  (1903,2,2),
  (1904,2,2),
  (1905,2,2),
  (1906,2,2),
  (1908,2,2),
  (1909,2,2),
  (1910,2,2),
  (1911,42,14),
  (1912,2,2),
  (1913,2,2),
  (1914,2,2),
  (1916,2,2),
  (1917,2,2),
  (1918,2,2),
  (1919,42,14),
  (1920,2,2),
  (1921,2,2),
  (1922,2,2),
  (1923,42,14),
  (1924,2,2),
  (1925,2,2),
  (1926,2,2),
  (1927,2,2),
  (1928,2,2),
  (1929,2,2),
  (1930,2,2),
  (1931,2,2),
  (1932,2,2),
  (1933,2,2),
  (1934,41,11),
  (1935,2,2),
  (1936,2,2),
  (1937,2,2),
  (1938,2,2),
  (1939,2,2),
  (1940,2,2),
  (1941,2,2),
  (1942,2,2),
  (1943,2,2),
  (1944,2,2),
  (1945,37,18),
  (1949,2,2),
  (1950,2,2),
  (1951,41,11),
  (1952,2,2),
  (1953,2,2),
  (1954,41,11),
  (1955,2,2),
  (1956,2,2),
  (1957,42,14),
  (1958,2,2),
  (1959,2,2),
  (1960,2,2),
  (1961,2,2),
  (1962,2,2),
  (1963,37,18),
  (1964,37,18),
  (1965,37,18),
  (1966,37,18),
  (1967,37,18),
  (1968,37,18),
  (1969,37,18),
  (1971,16,11),
  (1972,21,14),
  (1973,21,14),
  (1974,2,2),
  (1975,2,2),
  (1976,2,2),
  (1977,37,18),
  (1979,16,11),
  (1980,21,14),
  (1981,21,14),
  (1982,2,2),
  (1983,2,2),
  (1984,2,2),
  (1985,37,18),
  (1987,16,11),
  (1988,21,14),
  (1989,21,14),
  (1990,2,2),
  (1991,2,2);
COMMIT;

#
# Data for the `ff_default` table  (LIMIT 1024,500)
#

INSERT INTO `ff_default` (`id`, `registry`, `storage`) VALUES

  (1992,2,2),
  (1993,37,18),
  (1997,2,2),
  (1998,2,2),
  (1999,41,11),
  (2000,2,2),
  (2001,2,2),
  (2002,41,11),
  (2003,2,2),
  (2004,2,2),
  (2005,42,14),
  (2006,2,2),
  (2007,2,2),
  (2008,2,2),
  (2009,2,2),
  (2010,2,2),
  (2011,37,18),
  (2013,16,11),
  (2014,21,14),
  (2015,21,14),
  (2016,2,2),
  (2017,2,2),
  (2018,2,2);
COMMIT;

#
# Data for the `ff_registry` table  (LIMIT -466,500)
#

INSERT INTO `ff_registry` (`id`, `parent`, `tablename`, `description`, `protected`, `attaching`, `copying`, `view`) VALUES

  (1,NULL,'default','Корньова батьківська вільна форма',0,0,1,NULL),
  (2,1,'ref_multiguide','Системний довідник багато-до-багатьох',0,0,1,NULL),
  (3,1,'oneline','Довідник з одною строкою',0,0,1,NULL),
  (4,3,'commentline','Довідник з коментуванням',0,0,0,NULL),
  (5,4,'route_action','Дії на маршруті',0,0,1,NULL),
  (6,4,'route_node','Вузли маршруту',0,0,1,NULL),
  (7,4,'route','Маршрут',0,0,1,NULL),
  (8,4,'route_folder','Папки маршруту',0,0,1,NULL),
  (9,4,'route_cabinet','Кабінети користувачив',0,0,1,NULL),
  (10,NULL,'cab_user','Внутрішні користувачи',0,1,0,NULL),
  (11,NULL,'cab_user_roles','Ролі користувачив',0,1,0,NULL),
  (12,9,'route_cabinet_for_role','Кабінет користувача з розділенням за ролями',0,0,1,NULL),
  (13,1,'document_base','Базовий документ',0,0,1,NULL),
  (15,9,'route_cabinet_for_users','Кабінет з розділенням за користувачами',0,0,1,NULL),
  (16,1,'available_nodes','Доступні вузли',0,0,1,NULL),
  (17,16,'available_nodes_for_users','Список доступних вузлів для кола користувачів',0,0,1,NULL),
  (18,16,'available_nodes_for_roles','Перелік доступних вузлів для кола ролів',0,0,1,NULL),
  (19,NULL,'ff_registry','Таблиця реєстрацій',0,1,0,NULL),
  (20,NULL,'ff_storage','Перелік сховищ',0,1,0,NULL),
  (21,1,'available_actions','Дотупні дії',0,0,1,NULL),
  (22,21,'available_actions_for_roles','Дозволенні дії з документом для кола ролей',0,0,0,NULL),
  (23,21,'available_actions_for_users','Перелік дозволених дій з документом в вузлі для переліку користувачів',0,0,1,NULL),
  (25,5,'route_action_for_role','Дія з роллю',0,0,1,NULL),
  (26,5,'route_action_for_user','Дія з користувачем',0,0,1,NULL),
  (27,7,'route_for_role','Маршрут з використанням ролі',0,0,1,NULL),
  (28,7,'route_for_user','Маршрут з використанням переліку користувачив',0,0,1,NULL),
  (30,NULL,'gen_services','Перелік послуг',0,1,0,NULL),
  (36,13,'document_cnap','Документ для отримання адміністративних послуг',0,0,1,NULL),
  (38,36,'document_cnap_metolobruht','Складання актів обстеження спеціалізованих або спеціалізованих металургійних переробних підприємств або їх приймальних пунктів',0,0,0,NULL),
  (39,NULL,'gen_authorities','Перелік управліннь',0,1,0,NULL),
  (40,5,'route_action_for_cnap','Дія для документів ЦНАП',0,0,1,NULL),
  (41,16,'available_nodes_for_cnap','Доступні вузли для документів ЦНАП',0,0,0,NULL),
  (42,21,'available_actions_for_cnap','Дозволені дії з документом для документів ЦНАП',0,0,0,NULL);
COMMIT;

#
# Data for the `ff_field` table  (LIMIT -263,500)
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
  (12,3,'name',1,'Найменування',100,0,''),
  (13,4,'name',1,'Найменування',100,1,''),
  (14,4,'comment',4,'Коментування',200,0,''),
  (15,2,'order',2,'Порядок сортировки',0,0,NULL),
  (16,2,'owner',5,'Посилання на документ',0,0,''),
  (17,2,'owner_field',1,'Поле документа для прив''язування',0,0,''),
  (18,2,'reference',5,'Посилання на елемент довідника',0,0,''),
  (19,5,'registry',2,NULL,0,1,NULL),
  (20,5,'storage',2,NULL,0,1,NULL),
  (21,5,'name',1,'Найменування',100,1,''),
  (22,5,'comment',4,'Коментування',200,1,''),
  (26,6,'registry',2,NULL,0,1,NULL),
  (27,6,'storage',2,NULL,0,1,NULL),
  (28,6,'name',1,'Найменування',100,1,''),
  (29,6,'comment',4,'Коментування',200,1,''),
  (33,7,'registry',2,NULL,0,1,NULL),
  (34,7,'storage',2,NULL,0,1,NULL),
  (35,7,'name',1,'Найменування',100,1,''),
  (36,7,'comment',4,'Коментування',200,1,''),
  (40,8,'registry',2,NULL,0,1,NULL),
  (41,8,'storage',2,NULL,0,1,NULL),
  (42,8,'name',1,'Найменування',100,1,''),
  (43,8,'comment',4,'Коментування',200,1,''),
  (47,9,'registry',2,NULL,0,1,NULL),
  (48,9,'storage',2,NULL,0,1,NULL),
  (49,9,'name',1,'Найменування',100,1,''),
  (50,9,'comment',4,'Коментування',200,1,''),
  (54,7,'start_route',1002,'Начальный узел',300,0,NULL),
  (55,5,'gotonodes',1002,'Перейти до вузлів',300,0,''),
  (56,5,'clearnodes',1002,'Очистити вузли',400,0,''),
  (57,6,'allow_action',1001,'Дозволити дії',300,0,''),
  (58,6,'deny_action',1001,'Заборонити дії',400,0,''),
  (59,8,'nodes',1002,'Асоційованні вузли',300,0,''),
  (60,9,'folders',1007,'Папки кабінету',300,0,''),
  (61,8,'allow_new',1012,'Створити документ',400,0,''),
  (62,8,'allow_edit',1012,'Змінити документ',500,0,''),
  (63,8,'allow_delete',1012,'Видалити документ',600,0,''),
  (65,12,'registry',2,NULL,0,1,NULL),
  (66,12,'storage',2,NULL,0,1,NULL),
  (67,12,'name',1,'Найменування',100,1,''),
  (68,12,'comment',4,'Коментування',200,1,''),
  (69,12,'folders',1007,'Папки кабінету',300,1,''),
  (72,12,'role',1009,'Ролі',400,0,''),
  (73,13,'registry',2,NULL,0,1,NULL),
  (74,13,'storage',2,NULL,0,1,NULL),
  (76,13,'createdate',17,'Час створення документу',0,0,'DBDEFAULT:DEFAULT CURRENT_TIMESTAMP'),
  (89,15,'registry',2,NULL,0,1,NULL),
  (90,15,'storage',2,NULL,0,1,NULL),
  (91,15,'name',1,'Найменування',100,1,''),
  (92,15,'comment',4,'Коментування',200,1,''),
  (93,15,'folders',1007,'Папки кабінету',300,1,''),
  (96,15,'users',1008,'Список пользователей, допущенных к кабинету',400,0,NULL),
  (97,13,'route',1003,'Маршрут',1,0,NULL),
  (101,16,'registry',2,NULL,0,1,NULL),
  (102,16,'storage',2,NULL,0,1,NULL),
  (104,16,'node',5,'Поточний вузол',0,0,''),
  (108,17,'registry',2,NULL,0,1,NULL),
  (109,17,'storage',2,NULL,0,1,NULL),
  (110,17,'node',5,'Поточний вузол',0,1,''),
  (111,18,'registry',2,NULL,0,1,NULL),
  (112,18,'storage',2,NULL,0,1,NULL),
  (113,18,'node',5,'Поточний вузол',0,1,''),
  (114,17,'users',1008,'Список пользователей',0,0,NULL),
  (115,18,'roles',1009,'Список ролей',0,0,NULL),
  (118,13,'available_nodes',1010,'Перелік вузлів у которих знаходиться документ',0,0,''),
  (120,13,'available_actions',1013,'Дії з документом',0,0,''),
  (122,8,'visual_names',4,'Перелік полів для відображення',700,0,''),
  (123,21,'registry',2,NULL,0,1,NULL),
  (124,21,'storage',2,NULL,0,1,NULL),
  (126,21,'action',5,'Посилання на дію',0,0,''),
  (127,22,'registry',2,NULL,0,1,NULL),
  (128,22,'storage',2,NULL,0,1,NULL),
  (129,22,'action',5,'Посилання на дію',0,1,''),
  (130,21,'node',5,'Посилання на вузол',0,0,''),
  (131,22,'node',5,'Посилання на вузол',0,1,''),
  (132,23,'registry',2,NULL,0,1,NULL),
  (133,23,'storage',2,NULL,0,1,NULL),
  (134,23,'action',5,'Посилання на дію',0,1,''),
  (135,23,'node',5,'Посилання на вузол',0,1,''),
  (139,22,'roles',1009,'Список ролей',0,0,''),
  (140,23,'users',1008,'Список користувачів',0,0,''),
  (150,25,'registry',2,NULL,0,1,NULL),
  (151,25,'storage',2,NULL,0,1,NULL),
  (152,25,'name',1,'Найменування',100,1,''),
  (153,25,'comment',4,'Коментування',200,1,''),
  (154,25,'gotonodes',1002,'Перейти до вузлів',300,1,''),
  (155,25,'clearnodes',1002,'Очистити вузли',400,1,''),
  (157,26,'registry',2,NULL,0,1,NULL),
  (158,26,'storage',2,NULL,0,1,NULL),
  (159,26,'name',1,'Найменування',100,1,''),
  (160,26,'comment',4,'Коментування',200,1,''),
  (161,26,'gotonodes',1002,'Перейти до вузлів',300,1,''),
  (162,26,'clearnodes',1002,'Очистити вузли',400,1,''),
  (166,27,'registry',2,NULL,0,1,NULL),
  (167,27,'storage',2,NULL,0,1,NULL),
  (168,27,'name',1,'Найменування',100,1,''),
  (169,27,'comment',4,'Коментування',200,1,''),
  (170,27,'start_route',1002,'Початковий вузол',300,1,''),
  (173,28,'registry',2,NULL,0,1,NULL),
  (174,28,'storage',2,NULL,0,1,NULL),
  (175,28,'name',1,'Найменування',100,1,''),
  (176,28,'comment',4,'Коментування',200,1,''),
  (177,28,'start_route',1002,'Початковий вузол',300,1,''),
  (180,27,'roles',1009,'Ролі',400,0,''),
  (181,28,'users',1008,'Користувачі',400,0,''),
  (182,25,'roles',1009,'Ролі',500,0,''),
  (183,26,'users',1008,'Користувачи',500,0,''),
  (184,25,'currentrole',6,'Для текущего пользователя',600,0,NULL),
  (210,36,'registry',2,NULL,0,1,NULL),
  (211,36,'storage',2,NULL,0,1,NULL),
  (212,36,'createdate',17,'Час створення документу',0,1,'DBDEFAULT:DEFAULT CURRENT_TIMESTAMP'),
  (213,36,'route',1003,'Маршрут',0,1,NULL),
  (214,36,'available_nodes',1010,'Перелік вузлів у которих знаходиться документ',0,1,''),
  (215,36,'available_actions',1013,'Дії з документом',0,1,''),
  (217,36,'regnum',1,'Реєстраційний номер',100,0,NULL),
  (218,36,'regdate',3,'Дата реєстрації',200,0,NULL),
  (219,36,'legal_personality',1014,'Правова форма',300,0,NULL),
  (225,36,'person_name',1,'Ім''я фізичної особи',500,0,''),
  (226,36,'person_drfo',1,'Код ДРФО',600,0,NULL),
  (227,36,'address',4,'Адреса',700,0,NULL),
  (228,36,'phone1',18,'Телефон 1',800,0,''),
  (229,36,'phone2',18,'Телефон 2',900,0,''),
  (230,36,'delivery_reply',1017,'Форма надання відповіді',1000,0,NULL),
  (231,36,'email',19,'E-Mail',1100,0,''),
  (232,36,'service',1015,'Послуга',1200,0,NULL),
  (233,36,'tracknumber',8,'Трек-номер',1300,0,NULL),
  (234,36,'context',4,'Короткий зміст',1400,0,NULL),
  (235,36,'reason',4,'Висновок',1500,0,NULL),
  (236,36,'reply',1018,'Результат',1600,0,NULL),
  (237,36,'file_petition',14,'Заява',1700,0,NULL),
  (238,36,'file_petition_fileedsname',15,'Заява - Имя файла',0,1,NULL),
  (239,36,'initeds',13,'',1,0,''),
  (240,36,'plandate',3,'Контрольна дата',1800,0,''),
  (241,36,'factdate',3,'Знято з контролю',1900,0,''),
  (242,36,'administrator',2,'Адміністратор',2000,0,''),
  (243,36,'executor',2,'Виконавец',2100,0,NULL),
  (244,36,'file_result',14,'Результат розглядення',2200,0,NULL),
  (245,36,'file_result_fileedsname',15,'Результат розглядення документу - Ім''я файлу',0,1,''),
  (246,38,'registry',2,NULL,0,1,NULL),
  (247,38,'storage',2,NULL,0,1,NULL),
  (248,38,'createdate',17,'Час створення документу',0,1,'DBDEFAULT:DEFAULT CURRENT_TIMESTAMP'),
  (249,38,'route',1003,'Маршрут',0,1,'AI_ROUTE_AND_APLLY_FIRST_ACTION:148'),
  (250,38,'available_nodes',1010,'Перелік вузлів у которих знаходиться документ',0,1,''),
  (251,38,'available_actions',1013,'Дії з документом',0,1,''),
  (252,38,'regnum',1,'Реєстраційний номер',100,1,NULL),
  (253,38,'regdate',3,'Дата реєстрації',200,1,NULL),
  (254,38,'legal_personality',1014,'Правова форма',300,1,NULL),
  (256,38,'person_name',1,'Ім''я фізичної особи',500,1,''),
  (257,38,'person_drfo',1,'Код ДРФО',600,1,NULL),
  (258,38,'address',4,'Адреса',700,1,NULL),
  (259,38,'phone1',18,'Телефон 1',800,1,''),
  (260,38,'phone2',18,'Телефон 2',900,1,''),
  (261,38,'delivery_reply',1017,'Форма надання відповіді',1000,1,NULL),
  (262,38,'email',19,'E-Mail',1100,1,''),
  (263,38,'service',1015,'Послуга',1200,1,'AISTATIC:61'),
  (264,38,'tracknumber',8,'Трек-номер',1300,1,NULL),
  (265,38,'context',4,'Короткий зміст',1400,1,NULL),
  (266,38,'reason',4,'Висновок',1500,1,NULL),
  (267,38,'reply',1018,'Результат',1600,1,NULL),
  (268,38,'file_petition',14,'Заява',1700,1,NULL),
  (269,38,'file_petition_fileedsname',15,'Заява - Имя файла',0,1,NULL),
  (270,38,'initeds',13,'',1,1,''),
  (271,38,'plandate',3,'Контрольна дата',1800,1,''),
  (272,38,'factdate',3,'Знято з контролю',1900,1,''),
  (273,38,'administrator',2,'Адміністратор',2000,1,''),
  (274,38,'executor',2,'Виконавец',2100,1,NULL),
  (275,38,'file_result',14,'Результат розглядення',2200,1,NULL),
  (276,38,'file_result_fileedsname',15,'Результат розглядення документу - Ім''я файлу',0,1,''),
  (277,8,'deny_new',1011,'Виключити з реєстрації документ',450,0,''),
  (278,26,'ownernodes',1002,'Власникам вузлів',700,0,''),
  (279,28,'currentuser',6,'Поточний користувач',500,0,''),
  (280,5,'currentuser',6,'Поточний користувач',500,0,''),
  (281,25,'currentuser',6,'Поточний користувач',500,1,''),
  (282,26,'currentuser',6,'Поточний користувач',500,1,''),
  (283,40,'registry',2,NULL,0,1,NULL),
  (284,40,'storage',2,NULL,0,1,NULL),
  (285,40,'name',1,'Найменування',100,1,''),
  (286,40,'comment',4,'Коментування',200,1,''),
  (287,40,'gotonodes',1002,'Перейти до вузлів',300,1,''),
  (288,40,'clearnodes',1002,'Очистити вузли',400,1,''),
  (289,40,'currentuser',6,'Поточний користувач',500,1,''),
  (290,40,'default_attributes',1019,'Реквизити документа за замовченням',600,0,''),
  (291,40,'roles',1009,'Ролі',700,0,''),
  (292,40,'users',1008,'Перелік користувачів',800,0,''),
  (294,41,'registry',2,NULL,0,1,NULL),
  (295,41,'storage',2,NULL,0,1,NULL),
  (296,41,'node',5,'Поточний вузол',0,1,NULL),
  (297,42,'registry',2,NULL,0,1,NULL),
  (298,42,'storage',2,NULL,0,1,NULL),
  (299,42,'action',5,'Посилання на дію',0,1,NULL),
  (300,42,'node',5,'Посилання на вузол',0,1,NULL),
  (304,42,'users',1008,'Користувачі',0,0,''),
  (305,42,'roles',1009,'Ролі',0,0,''),
  (306,42,'authorities',1020,'Управління - виконавці',0,0,''),
  (307,41,'users',1008,'Користувачі',0,0,''),
  (308,41,'roles',1009,'Ролі',0,0,''),
  (310,40,'clearuser',6,'Користувачі з вузлів для очистки',550,0,''),
  (311,40,'current_authorities',1,'Поле з управлінням',1000,0,''),
  (312,36,'authorities',1020,'Суб''єкт розгляду',1150,0,''),
  (313,38,'authorities',1020,'Суб''єкт розгляду',1150,1,'AISTATIC:10'),
  (314,36,'organization_name',1,'Організація',400,0,''),
  (315,38,'organization_name',1,'Організація',400,1,''),
  (316,36,'organization_edrpou',1,'Код ЄДРПОУ',450,0,''),
  (317,38,'organization_edrpou',1,'Код ЄДРПОУ',450,1,''),
  (318,36,'outnum',1,'Вих. номер',250,0,''),
  (319,38,'outnum',1,'Вих. номер',250,1,''),
  (320,36,'outdate',3,'Вих. дата',260,0,''),
  (321,38,'outdate',3,'Вих. дата',260,1,''),
  (322,36,'its_autority',6,'За довіреністю',650,0,''),
  (323,38,'its_autority',6,'За довіреністю',650,1,''),
  (324,36,'autority_person_name',1,'ПІБ довіреної особи',660,0,''),
  (325,38,'autority_person_name',1,'ПІБ довіреної особи',660,1,''),
  (326,36,'autority_person_number',1,'№ довіреності',670,0,''),
  (327,38,'autority_person_number',1,'№ довіреності',670,1,''),
  (328,36,'number_of_pages',2,'Аркушів',210,0,''),
  (329,38,'number_of_pages',2,'Аркушів',210,1,''),
  (330,36,'delivery',1017,'Доставлено',220,0,''),
  (331,38,'delivery',1017,'Доставлено',220,1,''),
  (332,36,'renewal_date',3,'Продовжено до',1850,0,''),
  (333,38,'renewal_date',3,'Продовжено до',1850,1,''),
  (334,36,'exec_date',3,'Дата виконання',1950,0,''),
  (335,38,'exec_date',3,'Дата виконання',1950,1,''),
  (336,36,'executor_post',1,'Посада',2150,0,''),
  (337,38,'executor_post',1,'Посада',2150,1,''),
  (338,36,'result_delivery',6,'Результат вручено субъекту',2300,0,''),
  (339,38,'result_delivery',6,'Результат вручено субъекту',2300,1,''),
  (340,36,'result_date_delivery',3,'Дата вручення',2400,0,''),
  (341,38,'result_date_delivery',3,'Дата вручення',2400,1,'');
COMMIT;

#
# Data for the `ff_oneline` table  (LIMIT -413,500)
#

INSERT INTO `ff_oneline` (`id`, `registry`, `storage`, `name`) VALUES

  (1,12,7,'Кабінет заявника'),
  (3,12,7,'Кабінет адміністратора'),
  (5,3,15,'Фізична особа'),
  (6,3,15,'Фізична особа - підприємець'),
  (7,3,15,'Юридична особа'),
  (8,12,7,'Кабінет виконавця'),
  (88,3,19,'Сайт'),
  (89,3,19,'Особисто'),
  (90,3,19,'Пошта'),
  (91,3,20,'Відмовленно'),
  (92,3,20,'Прийняте рішення'),
  (93,3,20,'Видано дозвільний документ'),
  (148,28,5,'Маршрут ЦНАП 1'),
  (537,6,4,'Нові (Заявник)'),
  (538,6,4,'Розглядаються (заявник)'),
  (539,6,4,'Розглянуті (Заявник)'),
  (540,6,4,'Надіслані (Адміністратор)'),
  (541,6,4,'Прийняті у роботу (Адміністратор)'),
  (542,6,4,'За належністтю (Адміністратор)'),
  (543,6,4,'Вирішені (Адміністратор)'),
  (544,6,4,'Архів'),
  (545,6,4,'Надіслані (Виконавець)'),
  (546,6,4,'Прийняті у роботу (Виконавець)'),
  (547,6,4,'Вирішені (Виконавець)'),
  (548,40,3,'На розгляд'),
  (553,40,3,'Прийняті у роботу'),
  (559,40,3,'Направити до виконавчого органу'),
  (563,40,3,'Відмовити'),
  (574,40,3,'Прийняти у роботу'),
  (577,40,3,'Вдовільнити'),
  (582,40,3,'Відмовити'),
  (584,40,3,'До архіву'),
  (612,8,6,'Нові'),
  (618,8,6,'Розглядаються'),
  (620,8,6,'Розглянуті'),
  (622,8,6,'з Інтернет'),
  (624,8,6,'Надходження'),
  (626,8,6,'На виконанні'),
  (628,8,6,'Відпрацьовано'),
  (630,8,6,'Архів'),
  (632,8,6,'Надходження'),
  (634,8,6,'В роботі'),
  (650,8,6,'Виконані'),
  (1168,37,18,NULL),
  (1196,37,18,NULL),
  (1247,37,18,NULL),
  (1275,37,18,NULL),
  (1281,37,18,NULL),
  (1287,37,18,NULL),
  (1293,37,18,NULL),
  (1321,37,18,NULL),
  (1377,37,18,NULL),
  (1414,37,18,NULL),
  (1587,37,18,NULL),
  (1605,37,18,NULL),
  (1639,37,18,'ООО \"Органик\"'),
  (1670,37,18,NULL),
  (1706,8,6,'Всі'),
  (1742,28,5,'Маршрут ЦНАП 2'),
  (1771,37,18,NULL),
  (1789,37,18,NULL),
  (1807,37,18,NULL),
  (1825,37,18,NULL),
  (1843,37,18,NULL),
  (1844,37,18,NULL),
  (1845,37,18,NULL),
  (1846,37,18,NULL),
  (1847,37,18,NULL),
  (1848,37,18,NULL),
  (1849,37,18,NULL),
  (1850,37,18,NULL),
  (1851,37,18,NULL),
  (1852,37,18,NULL),
  (1853,37,18,NULL),
  (1945,37,18,NULL),
  (1963,37,18,NULL),
  (1964,37,18,NULL),
  (1965,37,18,NULL),
  (1966,37,18,NULL),
  (1967,37,18,NULL),
  (1968,37,18,NULL),
  (1969,37,18,NULL),
  (1977,37,18,NULL),
  (1985,37,18,NULL),
  (1993,37,18,NULL),
  (2011,37,18,NULL);
COMMIT;

#
# Data for the `ff_ref_multiguide` table  (LIMIT -272,500)
#

INSERT INTO `ff_ref_multiguide` (`id`, `registry`, `storage`, `order`, `owner`, `owner_field`, `reference`) VALUES

  (762,2,2,NULL,548,'gotonodes',538),
  (763,2,2,1,548,'gotonodes',540),
  (764,2,2,NULL,548,'clearnodes',537),
  (765,2,2,NULL,548,'roles',2),
  (820,2,2,NULL,553,'gotonodes',541),
  (821,2,2,NULL,553,'clearnodes',540),
  (1011,2,2,NULL,563,'gotonodes',539),
  (1012,2,2,1,563,'gotonodes',543),
  (1013,2,2,NULL,563,'clearnodes',538),
  (1014,2,2,1,563,'clearnodes',541),
  (1225,2,2,NULL,1224,'users',51),
  (1226,2,2,1,1224,'users',51),
  (1228,2,2,NULL,1227,'users',51),
  (1229,2,2,1,1227,'users',51),
  (1231,2,2,NULL,1230,'users',51),
  (1232,2,2,1,1230,'users',51),
  (1234,2,2,NULL,1233,'users',51),
  (1235,2,2,1,1233,'users',51),
  (1237,2,2,NULL,1236,'users',51),
  (1238,2,2,1,1236,'users',51),
  (1268,2,2,NULL,1267,'users',51),
  (1270,2,2,NULL,1269,'users',51),
  (1314,2,2,NULL,1313,'users',51),
  (1316,2,2,NULL,1315,'users',51),
  (1350,2,2,NULL,1349,'users',51),
  (1351,2,2,1,1349,'users',51),
  (1352,2,2,2,1349,'users',1),
  (1354,2,2,NULL,1353,'users',51),
  (1355,2,2,1,1353,'users',51),
  (1356,2,2,2,1353,'users',1),
  (1358,2,2,NULL,1357,'users',51),
  (1359,2,2,1,1357,'users',51),
  (1360,2,2,2,1357,'users',1),
  (1362,2,2,NULL,1361,'users',51),
  (1363,2,2,1,1361,'users',51),
  (1364,2,2,2,1361,'users',1),
  (1366,2,2,NULL,1365,'users',51),
  (1367,2,2,1,1365,'users',51),
  (1368,2,2,2,1365,'users',1),
  (1384,2,2,NULL,1383,'users',1),
  (1385,2,2,NULL,1383,'roles',2),
  (1395,2,2,NULL,559,'gotonodes',542),
  (1396,2,2,1,559,'gotonodes',545),
  (1397,2,2,NULL,559,'clearnodes',541),
  (1398,2,2,NULL,574,'gotonodes',546),
  (1399,2,2,NULL,574,'clearnodes',545),
  (1400,2,2,NULL,577,'gotonodes',543),
  (1401,2,2,1,577,'gotonodes',547),
  (1402,2,2,NULL,577,'clearnodes',542),
  (1403,2,2,1,577,'clearnodes',546),
  (1409,2,2,NULL,584,'gotonodes',544),
  (1410,2,2,NULL,584,'clearnodes',543),
  (1411,2,2,1,584,'clearnodes',547),
  (1412,2,2,NULL,584,'roles',2),
  (1413,2,2,1,584,'roles',3),
  (1505,2,2,NULL,1504,'users',52),
  (1506,2,2,1,1504,'users',51),
  (1507,2,2,2,1504,'users',52),
  (1509,2,2,NULL,1508,'users',52),
  (1510,2,2,1,1508,'users',51),
  (1511,2,2,2,1508,'users',52),
  (1513,2,2,NULL,1512,'users',52),
  (1514,2,2,1,1512,'users',51),
  (1515,2,2,2,1512,'users',52),
  (1517,2,2,NULL,1516,'users',52),
  (1518,2,2,1,1516,'users',51),
  (1519,2,2,2,1516,'users',52),
  (1521,2,2,NULL,1520,'users',52),
  (1522,2,2,1,1520,'users',51),
  (1523,2,2,2,1520,'users',52),
  (1532,2,2,NULL,1531,'users',52),
  (1533,2,2,1,1531,'users',51),
  (1534,2,2,2,1531,'users',52),
  (1535,2,2,3,1531,'users',1),
  (1565,2,2,NULL,582,'gotonodes',539),
  (1566,2,2,1,582,'gotonodes',543),
  (1567,2,2,2,582,'gotonodes',547),
  (1568,2,2,NULL,582,'clearnodes',538),
  (1569,2,2,1,582,'clearnodes',542),
  (1570,2,2,2,582,'clearnodes',546),
  (1572,2,2,NULL,1571,'roles',2),
  (1573,2,2,1,1571,'roles',3),
  (1575,2,2,NULL,1574,'roles',2),
  (1576,2,2,1,1574,'roles',3),
  (1594,2,2,NULL,1593,'users',1),
  (1595,2,2,NULL,1593,'roles',2),
  (1612,2,2,NULL,1611,'users',1),
  (1613,2,2,NULL,1611,'roles',2),
  (1615,2,2,NULL,1614,'users',1),
  (1616,2,2,NULL,1614,'roles',2),
  (1618,2,2,NULL,1617,'users',1),
  (1619,2,2,NULL,1617,'roles',2),
  (1624,2,2,NULL,1623,'users',51),
  (1626,2,2,NULL,1625,'users',51),
  (1628,2,2,NULL,1627,'users',51),
  (1633,2,2,NULL,612,'nodes',537),
  (1634,2,2,NULL,612,'allow_new',16),
  (1635,2,2,NULL,612,'deny_new',36),
  (1636,2,2,NULL,612,'allow_edit',16),
  (1637,2,2,NULL,612,'allow_delete',16),
  (1646,2,2,NULL,1645,'users',1),
  (1647,2,2,NULL,1645,'roles',2),
  (1649,2,2,NULL,1648,'users',1),
  (1650,2,2,NULL,1648,'roles',2),
  (1652,2,2,NULL,1651,'users',1),
  (1653,2,2,NULL,1651,'roles',2),
  (1677,2,2,NULL,1676,'users',1),
  (1678,2,2,NULL,1676,'roles',2),
  (1680,2,2,NULL,1679,'users',1),
  (1681,2,2,NULL,1679,'roles',2),
  (1683,2,2,NULL,1682,'users',1),
  (1684,2,2,NULL,1682,'roles',2),
  (1691,2,2,NULL,618,'nodes',538),
  (1692,2,2,NULL,620,'nodes',539),
  (1693,2,2,NULL,622,'nodes',540),
  (1694,2,2,NULL,624,'nodes',541),
  (1695,2,2,NULL,624,'allow_new',16),
  (1696,2,2,NULL,624,'deny_new',36),
  (1697,2,2,NULL,624,'allow_edit',16),
  (1698,2,2,NULL,624,'allow_delete',16),
  (1699,2,2,NULL,626,'nodes',542),
  (1701,2,2,NULL,628,'nodes',543),
  (1702,2,2,NULL,630,'nodes',544),
  (1703,2,2,NULL,632,'nodes',545),
  (1704,2,2,NULL,634,'nodes',546),
  (1705,2,2,NULL,650,'nodes',547),
  (1718,2,2,NULL,1706,'nodes',537),
  (1719,2,2,1,1706,'nodes',538),
  (1720,2,2,2,1706,'nodes',539),
  (1721,2,2,3,1706,'nodes',540),
  (1722,2,2,4,1706,'nodes',541),
  (1723,2,2,5,1706,'nodes',542),
  (1724,2,2,6,1706,'nodes',543),
  (1725,2,2,7,1706,'nodes',544),
  (1726,2,2,8,1706,'nodes',545),
  (1727,2,2,9,1706,'nodes',546),
  (1728,2,2,10,1706,'nodes',547),
  (1729,2,2,0,3,'folders',622),
  (1730,2,2,1,3,'folders',624),
  (1731,2,2,2,3,'folders',626),
  (1732,2,2,3,3,'folders',628),
  (1733,2,2,4,3,'folders',630),
  (1734,2,2,5,3,'folders',1706),
  (1735,2,2,NULL,3,'role',2),
  (1736,2,2,4,8,'folders',630),
  (1737,2,2,1,8,'folders',632),
  (1738,2,2,2,8,'folders',634),
  (1739,2,2,3,8,'folders',650),
  (1740,2,2,5,8,'folders',1706),
  (1741,2,2,NULL,8,'role',3),
  (1743,2,2,NULL,537,'allow_action',548),
  (1744,2,2,NULL,538,'deny_action',548),
  (1745,2,2,NULL,540,'allow_action',553),
  (1746,2,2,NULL,540,'deny_action',548),
  (1747,2,2,NULL,541,'allow_action',559),
  (1748,2,2,1,541,'allow_action',563),
  (1749,2,2,NULL,541,'deny_action',553),
  (1750,2,2,NULL,543,'allow_action',584),
  (1751,2,2,NULL,543,'deny_action',548),
  (1752,2,2,1,543,'deny_action',553),
  (1753,2,2,2,543,'deny_action',559),
  (1754,2,2,3,543,'deny_action',563),
  (1755,2,2,4,543,'deny_action',574),
  (1756,2,2,5,543,'deny_action',577),
  (1757,2,2,6,543,'deny_action',582),
  (1758,2,2,7,543,'deny_action',584),
  (1759,2,2,NULL,545,'allow_action',574),
  (1760,2,2,NULL,545,'deny_action',559),
  (1761,2,2,1,545,'deny_action',563),
  (1762,2,2,NULL,546,'allow_action',577),
  (1763,2,2,1,546,'allow_action',582),
  (1764,2,2,NULL,546,'deny_action',574),
  (1765,2,2,NULL,148,'start_route',537),
  (1766,2,2,NULL,1742,'start_route',541),
  (1767,2,2,NULL,1,'folders',612),
  (1768,2,2,1,1,'folders',618),
  (1769,2,2,2,1,'folders',620),
  (1770,2,2,NULL,1,'role',4),
  (1778,2,2,NULL,1777,'users',1),
  (1779,2,2,NULL,1777,'roles',2),
  (1781,2,2,NULL,1780,'users',1),
  (1782,2,2,NULL,1780,'roles',2),
  (1784,2,2,NULL,1783,'users',1),
  (1785,2,2,NULL,1783,'roles',2),
  (1796,2,2,NULL,1795,'users',51),
  (1797,2,2,NULL,1795,'roles',2),
  (1799,2,2,NULL,1798,'users',51),
  (1800,2,2,NULL,1798,'roles',2),
  (1802,2,2,NULL,1801,'users',51),
  (1803,2,2,NULL,1801,'roles',2),
  (1814,2,2,NULL,1813,'users',51),
  (1815,2,2,NULL,1813,'roles',2),
  (1817,2,2,NULL,1816,'users',51),
  (1818,2,2,NULL,1816,'roles',2),
  (1820,2,2,NULL,1819,'users',51),
  (1821,2,2,NULL,1819,'roles',2),
  (1832,2,2,NULL,1831,'users',51),
  (1833,2,2,NULL,1831,'roles',2),
  (1835,2,2,NULL,1834,'users',51),
  (1836,2,2,NULL,1834,'roles',2),
  (1838,2,2,NULL,1837,'users',51),
  (1839,2,2,NULL,1837,'roles',2),
  (1860,2,2,NULL,1859,'users',1),
  (1861,2,2,NULL,1859,'roles',2),
  (1912,2,2,NULL,1911,'users',52),
  (1913,2,2,1,1911,'users',51),
  (1914,2,2,2,1911,'users',52),
  (1920,2,2,NULL,1919,'users',52),
  (1921,2,2,1,1919,'users',51),
  (1922,2,2,2,1919,'users',52),
  (1924,2,2,NULL,1923,'users',52),
  (1925,2,2,1,1923,'users',51),
  (1926,2,2,2,1923,'users',52),
  (1935,2,2,NULL,1934,'roles',2),
  (1936,2,2,1,1934,'roles',3),
  (1952,2,2,NULL,1951,'users',51),
  (1953,2,2,NULL,1951,'roles',2),
  (1955,2,2,NULL,1954,'users',51),
  (1956,2,2,NULL,1954,'roles',2),
  (1958,2,2,NULL,1957,'users',51),
  (1959,2,2,NULL,1957,'roles',2),
  (2000,2,2,NULL,1999,'users',1),
  (2001,2,2,NULL,1999,'roles',2),
  (2003,2,2,NULL,2002,'users',1),
  (2004,2,2,NULL,2002,'roles',2),
  (2006,2,2,NULL,2005,'users',1),
  (2007,2,2,NULL,2005,'roles',2);
COMMIT;

#
# Data for the `ff_registry_h` table  (LIMIT -405,500)
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
  (107,28,7),
  (122,36,1),
  (123,36,1),
  (125,36,13),
  (130,38,1),
  (131,38,1),
  (132,38,13),
  (133,38,36),
  (134,40,1),
  (135,40,1),
  (136,40,3),
  (137,40,4),
  (141,40,5),
  (142,41,1),
  (143,41,1),
  (145,41,16),
  (146,42,1),
  (147,42,1),
  (149,42,21);
COMMIT;

#
# Data for the `ff_storage` table  (LIMIT -479,500)
#

INSERT INTO `ff_storage` (`id`, `name`, `description`, `subtype`, `type`, `fields`) VALUES

  (1,'default','Сховище за замовченням',0,NULL,''),
  (2,'ref_multiguide_storage','Сховище для зберігання зв''язок',0,NULL,''),
  (3,'actions','Дії на вузлах маршруту',5,1001,''),
  (4,'nodes','Перечень узлов маршрута',5,1002,''),
  (5,'routes','Маршрути',1,1003,''),
  (6,'folders','Папки кабінету',5,1007,''),
  (7,'cabinets','Кабинети',0,NULL,''),
  (9,'users','Користувачі',5,1008,''),
  (10,'roles','Ролі',5,1009,'user_role'),
  (11,'available nodes','Доступні вузли документу',5,1010,''),
  (12,'ff_registry','Список зареєстрованих вільних форм',5,1011,'tablename:Название;description:Описание'),
  (13,'ff_storage','Список зареєстрованих сховищ',5,1012,'name:Название;description:Описание'),
  (14,'available_actions','Перелік дій які доступні',5,1013,''),
  (15,'Правовая форма','Фізична, або Юридична особа',4,1014,''),
  (16,'Документи ЦНАП','Документи для отримання адміістративних послуг',0,NULL,''),
  (17,'Послуги','Список послуг',1,1015,'name'),
  (19,'Вид доставки','Вид доставки',1,1017,NULL),
  (20,'Результат виконання','Довідник з результатами виконання',1,1018,NULL),
  (22,'Значення документів за-замовченям','Для завдання реквізитів документів за-замовченям',1,1019,'id'),
  (23,'authorities','Перелік управлінь',1,1020,'name:Назва');
COMMIT;

#
# Data for the `ff_registry_storage` table  (LIMIT -465,500)
#

INSERT INTO `ff_registry_storage` (`id`, `registry`, `storage`) VALUES

  (53,3,19),
  (54,3,20),
  (79,6,4),
  (80,10,9),
  (81,11,10),
  (82,16,11),
  (83,17,11),
  (84,18,11),
  (85,41,11),
  (91,39,23),
  (92,19,12),
  (93,20,13),
  (94,21,14),
  (95,22,14),
  (96,23,14),
  (97,42,14),
  (98,3,15),
  (99,36,16),
  (100,38,16),
  (101,30,17),
  (102,36,22),
  (104,5,3),
  (105,25,3),
  (106,26,3),
  (107,40,3),
  (108,7,5),
  (109,27,5),
  (110,28,5),
  (111,8,6),
  (112,1,1),
  (113,2,2),
  (114,9,7),
  (115,12,7),
  (116,15,7);
COMMIT;

#
# Data for the `ff_route` table  (LIMIT -497,500)
#

INSERT INTO `ff_route` (`id`, `registry`, `storage`, `name`, `comment`, `start_route`) VALUES

  (148,28,5,'Маршрут ЦНАП 1','Рух документів починаючи від заявника',NULL),
  (1742,28,5,'Маршрут ЦНАП 2','Рух документів починаючи від адміністратора',NULL);
COMMIT;

#
# Data for the `ff_route_action` table  (LIMIT -491,500)
#

INSERT INTO `ff_route_action` (`id`, `registry`, `storage`, `name`, `comment`, `gotonodes`, `clearnodes`, `currentuser`) VALUES

  (548,40,3,'На розгляд','Дозвільні документи. Дія заявника (автоматична)',NULL,NULL,1),
  (553,40,3,'Прийняті у роботу','Дозвільні документи. Дія адміністратора',NULL,NULL,1),
  (559,40,3,'Направити до виконавчого органу','Дозвільні документи. Дія адміністратора.',NULL,NULL,1),
  (563,40,3,'Відмовити','Дозвільні документи. Дія адміністратора',NULL,NULL,1),
  (574,40,3,'Прийняти у роботу','Дозвільні документи. Дія виконавця',NULL,NULL,1),
  (577,40,3,'Вдовільнити','Дозвільні документи. Дія виконавця',NULL,NULL,0),
  (582,40,3,'Відмовити','Дозвільні документи. Дія виконавця',NULL,NULL,0),
  (584,40,3,'До архіву','Дозвільні документи. Дія адміністратора',NULL,NULL,0);
COMMIT;

#
# Data for the `ff_route_action_for_cnap` table  (LIMIT -491,500)
#

INSERT INTO `ff_route_action_for_cnap` (`id`, `registry`, `storage`, `name`, `comment`, `gotonodes`, `clearnodes`, `currentuser`, `default_attributes`, `roles`, `users`, `clearuser`, `current_authorities`) VALUES

  (548,40,3,'На розгляд','Дозвільні документи. Дія заявника (автоматична)',NULL,NULL,1,NULL,NULL,NULL,0,NULL),
  (553,40,3,'Прийняті у роботу','Дозвільні документи. Дія адміністратора',NULL,NULL,1,NULL,NULL,NULL,0,NULL),
  (559,40,3,'Направити до виконавчого органу','Дозвільні документи. Дія адміністратора.',NULL,NULL,1,NULL,NULL,NULL,0,'authorities'),
  (563,40,3,'Відмовити','Дозвільні документи. Дія адміністратора',NULL,NULL,1,NULL,NULL,NULL,1,NULL),
  (574,40,3,'Прийняти у роботу','Дозвільні документи. Дія виконавця',NULL,NULL,1,NULL,NULL,NULL,0,NULL),
  (577,40,3,'Вдовільнити','Дозвільні документи. Дія виконавця',NULL,NULL,0,NULL,NULL,NULL,1,NULL),
  (582,40,3,'Відмовити','Дозвільні документи. Дія виконавця',NULL,NULL,0,NULL,NULL,NULL,1,NULL),
  (584,40,3,'До архіву','Дозвільні документи. Дія адміністратора',NULL,NULL,0,NULL,NULL,NULL,0,NULL);
COMMIT;

#
# Data for the `ff_route_cabinet` table  (LIMIT -496,500)
#

INSERT INTO `ff_route_cabinet` (`id`, `registry`, `storage`, `name`, `comment`, `folders`) VALUES

  (1,12,7,'Кабінет заявника','Перегляд документі які на розгляді у завника',NULL),
  (3,12,7,'Кабінет адміністратора','Перегляд документів, які знаходяться на розгляді адміністратора',NULL),
  (8,12,7,'Кабінет виконавця','Кабінет в якому обробляе документи представник виконачих органів',NULL);
COMMIT;

#
# Data for the `ff_route_cabinet_for_role` table  (LIMIT -496,500)
#

INSERT INTO `ff_route_cabinet_for_role` (`id`, `registry`, `storage`, `name`, `comment`, `folders`, `role`) VALUES

  (1,12,7,'Кабінет заявника','Перегляд документі які на розгляді у завника',NULL,NULL),
  (3,12,7,'Кабінет адміністратора','Перегляд документів, які знаходяться на розгляді адміністратора',NULL,NULL),
  (8,12,7,'Кабінет виконавця','Кабінет в якому обробляе документи представник виконачих органів',NULL,NULL);
COMMIT;

#
# Data for the `ff_route_folder` table  (LIMIT -487,500)
#

INSERT INTO `ff_route_folder` (`id`, `registry`, `storage`, `name`, `comment`, `nodes`, `allow_new`, `allow_edit`, `allow_delete`, `visual_names`, `deny_new`) VALUES

  (612,8,6,'Нові','Тестування',NULL,NULL,NULL,NULL,'createdate: Дата створення; regnum: Реєстраційній номер; regdate: Дата реєстрації; legal_personality: Правовая форма; person_name: Ім''я; service: Послуга; authorities: Суб''єкт розгляду; tracknumber: Трек-номер; plandate: Запланована дата; factdate: Фактична дата',NULL),
  (618,8,6,'Розглядаються','Перелік документів, що направлені на розгляд',NULL,NULL,NULL,NULL,'createdate:Дата створення;regnum:Реєстраційній номер;regdate:Дата реєстрації;legal_personality:Правовая форма;person_name:Ім''я;service:Послуга;authorities:Суб''єкт розгляду;tracknumber:Трек-номер;plandate:Запланована дата;factdate:Фактична дата',NULL),
  (620,8,6,'Розглянуті','Перелік документів, що були розлянуті',NULL,NULL,NULL,NULL,'createdate: Дата створення; regnum: Реєстраційній номер; regdate: Дата реєстрації; legal_personality: Правовая форма; person_name: Ім''я; service: Послуга; authorities: Суб''єкт розгляду; tracknumber: Трек-номер; plandate: Запланована дата; factdate: Фактична дата',NULL),
  (622,8,6,'з Інтернет','Перелік документів, що надійшли від заявника з порталу',NULL,NULL,NULL,NULL,'createdate: Дата створення; regnum: Реєстраційній номер; regdate: Дата реєстрації; legal_personality: Правовая форма; person_name: Ім''я; service: Послуга; authorities: Суб''єкт розгляду; tracknumber: Трек-номер; plandate: Запланована дата; factdate: Фактична дата',NULL),
  (624,8,6,'Надходження','Документы які були прийняті у роботу адміністратором, або створені ним',NULL,NULL,NULL,NULL,'createdate: Дата створення; regnum: Реєстраційній номер; regdate: Дата реєстрації; legal_personality: Правовая форма; person_name: Ім''я; service: Послуга; authorities: Суб''єкт розгляду; tracknumber: Трек-номер; plandate: Запланована дата; factdate: Фактична дата',NULL),
  (626,8,6,'На виконанні','Документи, які адміністратор направив на виконання до виконавхого органу',NULL,NULL,NULL,NULL,'createdate: Дата створення; regnum: Реєстраційній номер; regdate: Дата реєстрації; legal_personality: Правовая форма; person_name: Ім''я; service: Послуга; authorities: Суб''єкт розгляду; tracknumber: Трек-номер; plandate: Запланована дата; factdate: Фактична дата',NULL),
  (628,8,6,'Відпрацьовано','Документи рішення по якім було винесено',NULL,NULL,NULL,NULL,'createdate: Дата створення; regnum: Реєстраційній номер; regdate: Дата реєстрації; legal_personality: Правовая форма; person_name: Ім''я; service: Послуга; authorities: Суб''єкт розгляду; tracknumber: Трек-номер; plandate: Запланована дата; factdate: Фактична дата',NULL),
  (630,8,6,'Архів','Документи в архіві',NULL,NULL,NULL,NULL,'createdate: Дата створення; regnum: Реєстраційній номер; regdate: Дата реєстрації; legal_personality: Правовая форма; person_name: Ім''я; service: Послуга; authorities: Суб''єкт розгляду; tracknumber: Трек-номер; plandate: Запланована дата; factdate: Фактична дата',NULL),
  (632,8,6,'Надходження','Документи, які надійшни до виконавчого органу від центру надання адміністративних послуг',NULL,NULL,NULL,NULL,'createdate: Дата створення; regnum: Реєстраційній номер; regdate: Дата реєстрації; legal_personality: Правовая форма; person_name: Ім''я; service: Послуга; authorities: Суб''єкт розгляду; tracknumber: Трек-номер; plandate: Запланована дата; factdate: Фактична дата',NULL),
  (634,8,6,'В роботі','Документи прийняті виконавцем в роботу',NULL,NULL,NULL,NULL,'createdate: Дата створення; regnum: Реєстраційній номер; regdate: Дата реєстрації; legal_personality: Правовая форма; person_name: Ім''я; service: Послуга; authorities: Суб''єкт розгляду; tracknumber: Трек-номер; plandate: Запланована дата; factdate: Фактична дата',NULL),
  (650,8,6,'Виконані','Документи, по якім виковчий орган виніс рішення',NULL,NULL,NULL,NULL,'createdate: Дата створення; regnum: Реєстраційній номер; regdate: Дата реєстрації; legal_personality: Правовая форма; person_name: Ім''я; service: Послуга; authorities: Суб''єкт розгляду; tracknumber: Трек-номер; plandate: Запланована дата; factdate: Фактична дата',NULL),
  (1706,8,6,'Всі','Всі документи, які є у системі',NULL,NULL,NULL,NULL,'createdate: Дата створення; regnum: Реєстраційній номер; regdate: Дата реєстрації; legal_personality: Правовая форма; person_name: Ім''я; service: Послуга; authorities: Суб''єкт розгляду; tracknumber: Трек-номер; plandate: Запланована дата; factdate: Фактична дата',NULL);
COMMIT;

#
# Data for the `ff_route_for_user` table  (LIMIT -497,500)
#

INSERT INTO `ff_route_for_user` (`id`, `registry`, `storage`, `name`, `comment`, `start_route`, `users`, `currentuser`) VALUES

  (148,28,5,'Маршрут ЦНАП 1','Рух документів починаючи від заявника',NULL,NULL,1),
  (1742,28,5,'Маршрут ЦНАП 2','Рух документів починаючи від адміністратора',NULL,NULL,1);
COMMIT;

#
# Data for the `ff_route_node` table  (LIMIT -488,500)
#

INSERT INTO `ff_route_node` (`id`, `registry`, `storage`, `name`, `comment`, `allow_action`, `deny_action`) VALUES

  (537,6,4,'Нові (Заявник)','Маршрут ЦНАП 1',NULL,NULL),
  (538,6,4,'Розглядаються (заявник)','Маршрут ЦНАП 1',NULL,NULL),
  (539,6,4,'Розглянуті (Заявник)','Маршрут ЦНАП 1',NULL,NULL),
  (540,6,4,'Надіслані (Адміністратор)','Маршрут ЦНАП 1',NULL,NULL),
  (541,6,4,'Прийняті у роботу (Адміністратор)','Маршрут ЦНАП 1',NULL,NULL),
  (542,6,4,'За належністтю (Адміністратор)','Маршрут ЦНАП 1',NULL,NULL),
  (543,6,4,'Вирішені (Адміністратор)','Маршрут ЦНАП 1',NULL,NULL),
  (544,6,4,'Архів','Маршрут ЦНАП 1',NULL,NULL),
  (545,6,4,'Надіслані (Виконавець)','Маршрут ЦНАП 1',NULL,NULL),
  (546,6,4,'Прийняті у роботу (Виконавець)','Маршрут ЦНАП 1',NULL,NULL),
  (547,6,4,'Вирішені (Виконавець)','Маршрут ЦНАП 1',NULL,NULL);
COMMIT;

#
# Data for the `ff_types` table  (LIMIT -462,500)
#

INSERT INTO `ff_types` (`id`, `typename`, `systemtype`, `view`, `description`, `visible`) VALUES

  (1,'Строка','VARCHAR(255)',NULL,'Строка длиной 255 символов',1),
  (2,'Число','INT(11)',NULL,'Целое число',1),
  (3,'Дата','DATE','date','Дата',1),
  (4,'Текст','TEXT','textarea','Текст',1),
  (5,'Велике число','BIGINT(20)',NULL,'Велике число',1),
  (6,'Логічне','TINYINT(4)','checkbox','Галочка',1),
  (7,'Дата та час','DATETIME','datetime','Дата та час',1),
  (8,'Штрихкод EAN-13',NULL,'barcode','Генерирует штрихкод по формату EAN-13',1),
  (9,'Малюнок','MEDIUMBLOB','image','',1),
  (10,'Файл','LONGBLOB','file','Загружаемый файл',1),
  (11,'filetype','VARCHAR(55)',NULL,'MIME-тип файла',0),
  (12,'filename','VARCHAR(255)',NULL,'Имя файла',0),
  (13,'Ініціалізація ЭЦП',NULL,'initsign','Если файлы в документе будут подписывать, то в документе должен присутствовать',1),
  (14,'Файл с підписом','LONGBLOB','filesign','Данные файла с подписью',1),
  (15,'fileedsname','VARCHAR(255)',NULL,'Имя файла',0),
  (16,'CKeditor','TEXT','ckeditor','WYSIWYG-редактор',1),
  (17,'Штамп времени','TIMESTAMP','datetime','Отображает дату и время',1),
  (18,'Телефон','VARCHAR(20)','phone','Телефон',1),
  (19,'E-mail','VARCHAR(70)','email','Электронный адрес',1),
  (20,'Лінія',NULL,'line','Малює лінію',1),
  (21,'Рамка',NULL,'frame','Малює рамку',1),
  (1001,'actions','INT(11)','listbox_multi','Дії на вузлах маршруту',1),
  (1002,'nodes','INT(11)','listbox_multi','Перечень узлов маршрута',1),
  (1003,'routes','INT(11)','combobox','Маршрути',1),
  (1007,'folders','INT(11)','listbox_multi','Папки кабінету',1),
  (1008,'users','INT(11)','listbox_multi','Користувачі',1),
  (1009,'roles','INT(11)','listbox_multi','Ролі',1),
  (1010,'available nodes','INT(11)','listbox_multi','Доступні вузли документу',1),
  (1011,'ff_registry','INT(11)','listbox_multi','Список зареєстрованих вільних форм',1),
  (1012,'ff_storage','INT(11)','listbox_multi','Список зареєстрованих сховищ',1),
  (1013,'available_actions','INT(11)','listbox_multi','Перелік дій які доступні',1),
  (1014,'Правовая форма','INT(11)','radiobox','Фізична, або Юридична особа',1),
  (1015,'Послуги','INT(11)','combobox','Список послуг',1),
  (1017,'Вид надходження','INT(11)','combobox','Вид доставки',1),
  (1018,'Результат виконання','INT(11)','combobox','Довідник з результатами виконання',1),
  (1019,'Значення документів за-замовченям','INT(11)','combobox','Для завдання реквізитів документів за-замовченям',1),
  (1020,'authorities','INT(11)','combobox','Перелік управлінь',1);
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