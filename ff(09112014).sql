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
DROP TABLE IF EXISTS `ff_route_action`;
DROP TABLE IF EXISTS `ff_route`;
DROP TABLE IF EXISTS `ff_registry_storage`;
DROP TABLE IF EXISTS `ff_storage`;
DROP TABLE IF EXISTS `ff_registry_h`;
DROP TABLE IF EXISTS `ff_ref_multiguide`;
DROP TABLE IF EXISTS `ff_organization`;
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
CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
AUTO_INCREMENT=101 AVG_ROW_LENGTH=165 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
  `nodes` INTEGER(11) DEFAULT NULL,
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
  `organization` INTEGER(11) DEFAULT NULL,
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
  `organization` INTEGER(11) DEFAULT NULL,
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
AUTO_INCREMENT=39 AVG_ROW_LENGTH=546 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
AUTO_INCREMENT=279 AVG_ROW_LENGTH=88 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
# Структура для таблицы `ff_organization`: 
#

CREATE TABLE `ff_organization` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 37,
  `storage` INTEGER(11) DEFAULT NULL,
  `name` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  `edrpou` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
AVG_ROW_LENGTH=5461 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
  PRIMARY KEY USING BTREE (`id`) COMMENT ''
)ENGINE=InnoDB
AVG_ROW_LENGTH=287 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
AUTO_INCREMENT=134 AVG_ROW_LENGTH=190 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
AUTO_INCREMENT=21 AVG_ROW_LENGTH=819 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
AUTO_INCREMENT=62 AVG_ROW_LENGTH=546 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
AVG_ROW_LENGTH=8192 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
AVG_ROW_LENGTH=8192 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
  `currentuser` TINYINT(4) DEFAULT NULL,
  `ownernodes` INTEGER(11) DEFAULT NULL,
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
AUTO_INCREMENT=1019 AVG_ROW_LENGTH=481 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
# Data for the `ff_default` table  (LIMIT -400,500)
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
  (10,8,6),
  (11,8,6),
  (12,8,6),
  (13,8,6),
  (14,2,2),
  (15,2,2),
  (16,2,2),
  (17,8,6),
  (18,8,6),
  (19,8,6),
  (20,8,6),
  (21,8,6),
  (22,8,6),
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
  (43,6,4),
  (44,6,4),
  (45,6,4),
  (46,6,4),
  (47,6,4),
  (48,6,4),
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
  (68,6,4),
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
  (82,37,18),
  (84,37,18),
  (85,38,16),
  (86,37,18),
  (87,38,16),
  (88,3,19),
  (89,3,19),
  (90,3,19),
  (91,3,20),
  (92,3,20),
  (93,3,20),
  (94,25,3),
  (95,2,2),
  (96,2,2),
  (97,2,2),
  (98,25,3),
  (99,2,2),
  (100,2,2);
COMMIT;

#
# Data for the `ff_document_base` table  (LIMIT -497,500)
#

INSERT INTO `ff_document_base` (`id`, `registry`, `storage`, `createdate`, `route`, `nodes`, `available_nodes`, `available_actions`) VALUES

  (85,38,16,'2014-11-09 03:07:53',NULL,NULL,NULL,NULL),
  (87,38,16,'2014-11-09 03:08:56',NULL,NULL,NULL,NULL);
COMMIT;

#
# Data for the `ff_document_cnap` table  (LIMIT -497,500)
#

INSERT INTO `ff_document_cnap` (`id`, `registry`, `storage`, `createdate`, `route`, `available_nodes`, `available_actions`, `regnum`, `regdate`, `legal_personality`, `organization`, `person_name`, `person_drfo`, `address`, `phone1`, `phone2`, `delivery_reply`, `email`, `service`, `context`, `reason`, `reply`, `file_petition`, `file_petition_fileedsname`, `plandate`, `factdate`, `administrator`, `executor`, `file_result`, `file_result_fileedsname`) VALUES

  (85,38,16,'2014-11-09 03:07:53',NULL,NULL,NULL,NULL,NULL,NULL,84,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Тест ',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (87,38,16,'2014-11-09 03:08:56',NULL,NULL,NULL,NULL,NULL,NULL,86,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'ТЕСТ №2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
COMMIT;

#
# Data for the `ff_document_cnap_metolobruht` table  (LIMIT -497,500)
#

INSERT INTO `ff_document_cnap_metolobruht` (`id`, `registry`, `storage`, `createdate`, `route`, `available_nodes`, `available_actions`, `regnum`, `regdate`, `legal_personality`, `organization`, `person_name`, `person_drfo`, `address`, `phone1`, `phone2`, `delivery_reply`, `email`, `service`, `context`, `reason`, `reply`, `file_petition`, `file_petition_fileedsname`, `plandate`, `factdate`, `administrator`, `executor`, `file_result`, `file_result_fileedsname`) VALUES

  (85,38,16,'2014-11-09 03:07:53',NULL,NULL,NULL,NULL,NULL,NULL,84,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Тест ',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (87,38,16,'2014-11-09 03:08:56',NULL,NULL,NULL,NULL,NULL,NULL,86,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'ТЕСТ №2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
COMMIT;

#
# Data for the `ff_registry` table  (LIMIT -469,500)
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
  (15,9,'route_cabinet_for_users','Кабинет пользователя с разделением по пользователям',0,0,1,NULL),
  (16,1,'available_nodes','Доступные узлы для определенных пользователей на маршруте',0,0,1,NULL),
  (17,16,'available_nodes_for_users','Список доступных узлов для круга пользователей',0,0,1,NULL),
  (18,16,'available_nodes_for_roles','Список доступных узлов для списка ролей',0,0,1,NULL),
  (19,NULL,'ff_registry','Таблица регистраций',0,1,0,NULL),
  (20,NULL,'ff_storage','Список хранилищ',0,1,0,NULL),
  (21,1,'available_actions','Список разрешенных действий с документом',0,0,1,NULL),
  (22,21,'available_actions_for_roles','Разшенные действия с документом для набора ролей',0,0,0,NULL),
  (23,21,'available_actions_for_users','Список разрешенных действий с документом в узле для перечня пользователей',0,0,1,NULL),
  (25,5,'route_action_for_role','Действие с привязкой к роли',0,0,1,NULL),
  (26,5,'route_action_for_user','Действие с привязкой к пользователям',0,0,1,NULL),
  (27,7,'route_for_role','Маршрут с применением роли',0,0,1,NULL),
  (28,7,'route_for_user','Маршрут с применением списка пользователей',0,0,1,NULL),
  (30,NULL,'gen_services','Перечень услуг',0,1,0,NULL),
  (36,13,'document_cnap','Документ для отримання адміністративних послуг',0,0,1,NULL),
  (37,3,'organization','Организация',0,0,1,NULL),
  (38,36,'document_cnap_metolobruht','заготівлі, переробки, металургійної переробки металобрухту кольорових і чорних металів',0,0,0,NULL);
COMMIT;

#
# Data for the `ff_field` table  (LIMIT -314,500)
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
  (17,2,'owner_field',1,'поле документа привязки',0,0,''),
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
  (54,7,'start_route',1002,'Начальный узел',300,0,NULL),
  (55,5,'gotonodes',1002,'Перейти к узлам',300,0,NULL),
  (56,5,'clearnodes',1002,'Очистить узлы',400,0,NULL),
  (57,6,'allow_action',1001,'Разрешить действия',300,0,NULL),
  (58,6,'deny_action',1001,'Запретить действия',400,0,NULL),
  (59,8,'nodes',1002,'Ассоциированные узлы',300,0,NULL),
  (60,9,'folders',1007,'Папки кабинета',300,0,NULL),
  (61,8,'allow_new',1012,'Создать документ',400,0,NULL),
  (62,8,'allow_edit',1012,'Изменить документ',500,0,NULL),
  (63,8,'allow_delete',1012,'Удалить документ',600,0,NULL),
  (65,12,'registry',2,NULL,0,1,NULL),
  (66,12,'storage',2,NULL,0,1,NULL),
  (67,12,'name',1,'Наименование',100,1,NULL),
  (68,12,'comment',4,'Комментарий',200,1,NULL),
  (69,12,'folders',1007,'Папки кабинета',300,1,NULL),
  (72,12,'role',1009,'ИД роли пользователя',400,0,NULL),
  (73,13,'registry',2,NULL,0,1,NULL),
  (74,13,'storage',2,NULL,0,1,NULL),
  (76,13,'createdate',17,'Время создания документа',0,0,'DBDEFAULT:DEFAULT CURRENT_TIMESTAMP'),
  (89,15,'registry',2,NULL,0,1,NULL),
  (90,15,'storage',2,NULL,0,1,NULL),
  (91,15,'name',1,'Наименование',100,1,NULL),
  (92,15,'comment',4,'Комментарий',200,1,NULL),
  (93,15,'folders',1007,'Папки кабинета',300,1,NULL),
  (96,15,'users',1008,'Список пользователей, допущенных к кабинету',400,0,NULL),
  (97,13,'route',1003,'Маршрут',1,0,NULL),
  (101,16,'registry',2,NULL,0,1,NULL),
  (102,16,'storage',2,NULL,0,1,NULL),
  (104,16,'node',5,'Текущий узел',0,0,NULL),
  (108,17,'registry',2,NULL,0,1,NULL),
  (109,17,'storage',2,NULL,0,1,NULL),
  (110,17,'node',5,'Текущий узел',0,1,NULL),
  (111,18,'registry',2,NULL,0,1,NULL),
  (112,18,'storage',2,NULL,0,1,NULL),
  (113,18,'node',5,'Текущий узел',0,1,NULL),
  (114,17,'users',1008,'Список пользователей',0,0,NULL),
  (115,18,'roles',1009,'Список ролей',0,0,NULL),
  (118,13,'available_nodes',1010,'Список узлов в которых находится документ',0,0,NULL),
  (120,13,'available_actions',1013,'Действия с документом',0,0,NULL),
  (122,8,'visual_names',4,'Список отображаемых полей',700,0,NULL),
  (123,21,'registry',2,NULL,0,1,NULL),
  (124,21,'storage',2,NULL,0,1,NULL),
  (126,21,'action',5,'Ссылка на действие',0,0,NULL),
  (127,22,'registry',2,NULL,0,1,NULL),
  (128,22,'storage',2,NULL,0,1,NULL),
  (129,22,'action',5,'Ссылка на действие',0,1,NULL),
  (130,21,'node',5,'Ссылка на узел',0,0,NULL),
  (131,22,'node',5,'Ссылка на узел',0,1,NULL),
  (132,23,'registry',2,NULL,0,1,NULL),
  (133,23,'storage',2,NULL,0,1,NULL),
  (134,23,'action',5,'Ссылка на действие',0,1,NULL),
  (135,23,'node',5,'Ссылка на узел',0,1,NULL),
  (139,22,'roles',1009,'Список ролей',0,0,NULL),
  (140,23,'users',1008,'Список пользователей',0,0,NULL),
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
  (180,27,'roles',1009,'Роли',400,0,NULL),
  (181,28,'users',1008,'Пользователи',400,0,NULL),
  (182,25,'roles',1009,'Роли',500,0,NULL),
  (183,26,'users',1008,'Пользователи',500,0,NULL),
  (184,25,'currentrole',6,'Для текущего пользователя',600,0,NULL),
  (185,26,'currentuser',6,'Для текущего пользователя',600,0,NULL),
  (210,36,'registry',2,NULL,0,1,NULL),
  (211,36,'storage',2,NULL,0,1,NULL),
  (212,36,'createdate',17,'Время создания документа',0,1,'DBDEFAULT: DEFAULT CURRENT_TIMESTAMP'),
  (213,36,'route',1003,'Маршрут',0,1,NULL),
  (214,36,'available_nodes',1010,'Список узлов в которых находится документ',0,1,NULL),
  (215,36,'available_actions',1013,'Действия с документом',0,1,NULL),
  (217,36,'regnum',1,'Реєстраційний номер',100,0,NULL),
  (218,36,'regdate',3,'Дата реєстрації',200,0,NULL),
  (219,36,'legal_personality',1014,'Правова форма',300,0,NULL),
  (220,37,'registry',2,NULL,0,1,NULL),
  (221,37,'storage',2,NULL,0,1,NULL),
  (222,37,'name',1,'Наименование',100,1,NULL),
  (223,37,'edrpou',1,'ЄДРПОУ',200,0,NULL),
  (224,36,'organization',1016,'Підприємство',400,0,NULL),
  (225,36,'person_name',1,'Им''я фізичної особи',500,0,NULL),
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
  (239,36,'initeds',13,'Java-аплет.',1,0,NULL),
  (240,36,'plandate',3,'Запланована дата виконання',1800,0,NULL),
  (241,36,'factdate',3,'Дата виконання',1900,0,NULL),
  (242,36,'administrator',2,'Администратор',2000,0,NULL),
  (243,36,'executor',2,'Виконавец',2100,0,NULL),
  (244,36,'file_result',14,'Результат рассмотрения',2200,0,NULL),
  (245,36,'file_result_fileedsname',15,'Результат рассмотрения - Имя файла',0,1,NULL),
  (246,38,'registry',2,NULL,0,1,NULL),
  (247,38,'storage',2,NULL,0,1,NULL),
  (248,38,'createdate',17,'Время создания документа',0,1,'DBDEFAULT: NOT NULL DEFAULT CURRENT_TIMESTAMP'),
  (249,38,'route',1003,'Маршрут',0,1,NULL),
  (250,38,'available_nodes',1010,'Список узлов в которых находится документ',0,1,NULL),
  (251,38,'available_actions',1013,'Действия с документом',0,1,NULL),
  (252,38,'regnum',1,'Реєстраційний номер',100,1,NULL),
  (253,38,'regdate',3,'Дата реєстрації',200,1,NULL),
  (254,38,'legal_personality',1014,'Правова форма',300,1,NULL),
  (255,38,'organization',1016,'Підприємство',400,1,NULL),
  (256,38,'person_name',1,'Им''я фізичної особи',500,1,NULL),
  (257,38,'person_drfo',1,'Код ДРФО',600,1,NULL),
  (258,38,'address',4,'Адреса',700,1,NULL),
  (259,38,'phone1',18,'Телефон 1',800,1,''),
  (260,38,'phone2',18,'Телефон 2',900,1,''),
  (261,38,'delivery_reply',1017,'Форма надання відповіді',1000,1,NULL),
  (262,38,'email',19,'E-Mail',1100,1,''),
  (263,38,'service',1015,'Послуга',1200,1,NULL),
  (264,38,'tracknumber',8,'Трек-номер',1300,1,NULL),
  (265,38,'context',4,'Короткий зміст',1400,1,NULL),
  (266,38,'reason',4,'Висновок',1500,1,NULL),
  (267,38,'reply',1018,'Результат',1600,1,NULL),
  (268,38,'file_petition',14,'Заява',1700,1,NULL),
  (269,38,'file_petition_fileedsname',15,'Заява - Имя файла',0,1,NULL),
  (270,38,'initeds',13,'Java-аплет.',0,1,''),
  (271,38,'plandate',3,'Запланована дата виконання',1800,1,NULL),
  (272,38,'factdate',3,'Дата виконання',1900,1,NULL),
  (273,38,'administrator',2,'Администратор',2000,1,NULL),
  (274,38,'executor',2,'Виконавец',2100,1,NULL),
  (275,38,'file_result',14,'Результат рассмотрения',2200,1,NULL),
  (276,38,'file_result_fileedsname',15,'Результат рассмотрения - Имя файла',0,1,NULL),
  (277,8,'deny_new',1011,'Исключить из регистрации (Создание документа)',450,0,''),
  (278,26,'ownernodes',1002,'Владельцам узлов',700,0,'');
COMMIT;

#
# Data for the `ff_oneline` table  (LIMIT -465,500)
#

INSERT INTO `ff_oneline` (`id`, `registry`, `storage`, `name`) VALUES

  (1,12,7,'Кабінет заявника'),
  (3,12,7,'Кабінет адміністратора'),
  (5,3,15,'Фізична особа'),
  (6,3,15,'Фізична особа - підприємець'),
  (7,3,15,'Юридична особа'),
  (8,12,7,'Кабінет виконавця'),
  (10,8,6,'Розглядаються'),
  (11,8,6,'Є рішення'),
  (12,8,6,'Надісланні'),
  (13,8,6,'У роботі'),
  (17,8,6,'У виконавця'),
  (18,8,6,'Прийняте рішення'),
  (19,8,6,'Архив'),
  (20,8,6,'Надісланні'),
  (21,8,6,'У роботі'),
  (22,8,6,'Виконано'),
  (43,6,4,'Нові (Заявник)'),
  (44,6,4,'На розляді у Адміністратора'),
  (45,6,4,'Прийняті у роботу (Адміністратор)'),
  (46,6,4,'У виконавця'),
  (47,6,4,'Виконані'),
  (48,6,4,'В архіві'),
  (68,6,4,'У виконавця в роботі'),
  (82,37,18,NULL),
  (84,37,18,NULL),
  (86,37,18,NULL),
  (88,3,19,'Сайт'),
  (89,3,19,'Особисто'),
  (90,3,19,'Пошта'),
  (91,3,20,'Відмовленно'),
  (92,3,20,'Прийняте рішення'),
  (93,3,20,'Видано дозвільний документ'),
  (94,25,3,'Направити на розгляд'),
  (98,25,3,'Прийняті у роботу');
COMMIT;

#
# Data for the `ff_organization` table  (LIMIT -496,500)
#

INSERT INTO `ff_organization` (`id`, `registry`, `storage`, `name`, `edrpou`) VALUES

  (82,37,18,NULL,NULL),
  (84,37,18,NULL,NULL),
  (86,37,18,NULL,NULL);
COMMIT;

#
# Data for the `ff_ref_multiguide` table  (LIMIT -442,500)
#

INSERT INTO `ff_ref_multiguide` (`id`, `registry`, `storage`, `order`, `owner`, `owner_field`, `reference`) VALUES

  (4,2,2,NULL,3,'role',2),
  (9,2,2,NULL,8,'role',3),
  (16,2,2,NULL,13,'allow',16),
  (23,2,2,NULL,1,'folders',10),
  (24,2,2,1,1,'folders',11),
  (25,2,2,NULL,1,'role',4),
  (29,2,2,NULL,1,'folders',10),
  (30,2,2,1,1,'folders',11),
  (31,2,2,NULL,1,'role',4),
  (32,2,2,NULL,3,'folders',12),
  (33,2,2,1,3,'folders',13),
  (34,2,2,2,3,'folders',17),
  (35,2,2,3,3,'folders',18),
  (36,2,2,4,3,'folders',19),
  (37,2,2,NULL,3,'role',2),
  (38,2,2,4,8,'folders',19),
  (39,2,2,1,8,'folders',20),
  (40,2,2,2,8,'folders',21),
  (41,2,2,3,8,'folders',22),
  (42,2,2,NULL,8,'role',3),
  (49,2,2,NULL,10,'nodes',44),
  (50,2,2,1,10,'nodes',45),
  (51,2,2,2,10,'nodes',46),
  (52,2,2,NULL,11,'nodes',47),
  (53,2,2,1,11,'nodes',48),
  (54,2,2,NULL,12,'nodes',44),
  (55,2,2,NULL,13,'nodes',45),
  (56,2,2,NULL,13,'nodes',45),
  (57,2,2,NULL,13,'allow_new',16),
  (58,2,2,NULL,13,'allow_edit',16),
  (59,2,2,NULL,13,'allow_delete',16),
  (60,2,2,NULL,13,'nodes',45),
  (61,2,2,NULL,13,'allow_new',16),
  (62,2,2,NULL,13,'allow_edit',16),
  (63,2,2,NULL,13,'allow_delete',16),
  (64,2,2,NULL,17,'nodes',46),
  (65,2,2,NULL,18,'nodes',47),
  (66,2,2,NULL,19,'nodes',48),
  (67,2,2,NULL,20,'nodes',46),
  (69,2,2,NULL,17,'nodes',46),
  (70,2,2,NULL,17,'nodes',46),
  (71,2,2,1,17,'nodes',68),
  (72,2,2,NULL,18,'nodes',47),
  (73,2,2,NULL,19,'nodes',48),
  (74,2,2,NULL,20,'nodes',46),
  (75,2,2,NULL,21,'nodes',68),
  (76,2,2,NULL,22,'nodes',47),
  (77,2,2,NULL,13,'nodes',45),
  (78,2,2,NULL,13,'allow_new',16),
  (79,2,2,NULL,13,'deny_new',36),
  (80,2,2,NULL,13,'allow_edit',16),
  (81,2,2,NULL,13,'allow_delete',16),
  (95,2,2,NULL,94,'gotonodes',44),
  (96,2,2,NULL,94,'clearnodes',43),
  (97,2,2,NULL,94,'roles',2),
  (99,2,2,NULL,98,'gotonodes',45),
  (100,2,2,NULL,98,'clearnodes',44);
COMMIT;

#
# Data for the `ff_registry_h` table  (LIMIT -413,500)
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
  (126,37,1),
  (127,37,1),
  (129,37,3),
  (130,38,1),
  (131,38,1),
  (132,38,13),
  (133,38,36);
COMMIT;

#
# Data for the `ff_storage` table  (LIMIT -479,500)
#

INSERT INTO `ff_storage` (`id`, `name`, `description`, `subtype`, `type`, `fields`) VALUES

  (1,'default','Хранилище по умолчанию',0,NULL,NULL),
  (2,'ref_multiguide_storage','Хранилище для хранения связок',0,NULL,NULL),
  (3,'actions','Действия на узлах маршрута',5,1001,NULL),
  (4,'nodes','Перечень узлов маршрута',5,1002,NULL),
  (5,'routes','Маршруты',1,1003,NULL),
  (6,'folders','Папки кабинета',5,1007,NULL),
  (7,'cabinets','Кабинеты',0,NULL,NULL),
  (8,'Тестовые документы','Хранилище для тестирования документов',0,NULL,NULL),
  (9,'Список пользователей','Проба работы с внешними таблицами',5,1008,NULL),
  (10,'Роли','Проба работы с внешними таблицами',5,1009,'user_role'),
  (11,'Доступные узлы','Доступные узлы(available nodes) документа',5,1010,NULL),
  (12,'Список регистраций свободных форм','Список зарегистрированых свободных форм',5,1011,'tablename:Название;description:Описание'),
  (13,'Список хранилищ','Список зарегистрированных хранилищ',5,1012,'name:Название;description:Описание'),
  (14,'Доступные действия','Перечень доступных действий в узле',5,1013,NULL),
  (15,'Правовая форма','Физик, Юрик',4,1014,NULL),
  (16,'Документы ЦНАП','Документы по получению админуслуг',0,NULL,''),
  (17,'Услуги','Список услуг',1,1015,'name'),
  (18,'Организации','Встраиваемый справочник в документ ЦНАП',3,1016,NULL),
  (19,'Вид доставки','Вид доставки',1,1017,NULL),
  (20,'Результат виконання','Довідник з результатами виконання',1,1018,NULL);
COMMIT;

#
# Data for the `ff_registry_storage` table  (LIMIT -469,500)
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
  (32,16,11),
  (33,17,11),
  (34,18,11),
  (36,20,13),
  (37,21,14),
  (38,22,14),
  (39,23,14),
  (42,5,3),
  (43,25,3),
  (44,26,3),
  (45,7,5),
  (46,27,5),
  (47,28,5),
  (48,3,15),
  (52,37,18),
  (53,3,19),
  (54,3,20),
  (55,11,10),
  (58,30,17),
  (59,36,16),
  (60,38,16),
  (61,19,12);
COMMIT;

#
# Data for the `ff_route_action` table  (LIMIT -497,500)
#

INSERT INTO `ff_route_action` (`id`, `registry`, `storage`, `name`, `comment`, `gotonodes`, `clearnodes`) VALUES

  (94,25,3,'Направити на розгляд','Заявник направляє документ на розгляд до ЦНАП',NULL,NULL),
  (98,25,3,'Прийняті у роботу','Адміністратор приймає у роботу документ',NULL,NULL);
COMMIT;

#
# Data for the `ff_route_action_for_role` table  (LIMIT -497,500)
#

INSERT INTO `ff_route_action_for_role` (`id`, `registry`, `storage`, `name`, `comment`, `gotonodes`, `clearnodes`, `setroles`, `roles`, `currentrole`) VALUES

  (94,25,3,'Направити на розгляд','Заявник направляє документ на розгляд до ЦНАП',NULL,NULL,NULL,NULL,1),
  (98,25,3,'Прийняті у роботу','Адміністратор приймає у роботу документ',NULL,NULL,NULL,NULL,1);
COMMIT;

#
# Data for the `ff_route_cabinet` table  (LIMIT -496,500)
#

INSERT INTO `ff_route_cabinet` (`id`, `registry`, `storage`, `name`, `comment`, `folders`, `role`) VALUES

  (1,12,7,'Кабінет заявника','Перегляд документі які на розгляді у завника',NULL,NULL),
  (3,12,7,'Кабінет адміністратора','Перегляд документів, які знаходяться на розгляді адміністратора',NULL,NULL),
  (8,12,7,'Кабінет виконавця','Кабінет в якому обробляе документи представник виконачих органів',NULL,NULL);
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
# Data for the `ff_route_folder` table  (LIMIT -489,500)
#

INSERT INTO `ff_route_folder` (`id`, `registry`, `storage`, `name`, `comment`, `nodes`, `allow_new`, `allow_edit`, `allow_delete`, `visual_names`, `deny_new`) VALUES

  (10,8,6,'Розглядаються','Документи які обробляються у виконавчому органі',NULL,NULL,NULL,NULL,NULL,NULL),
  (11,8,6,'Є рішення','Дкументи по якім виконавчий орган прийняв рішення',NULL,NULL,NULL,NULL,NULL,NULL),
  (12,8,6,'Надісланні','Документи які надійшли до Адміністратора ЦНАП',NULL,NULL,NULL,NULL,NULL,NULL),
  (13,8,6,'У роботі','Документи які Адміністратор ЦНАП прийняв у роботу, або створив',NULL,NULL,NULL,NULL,NULL,NULL),
  (17,8,6,'У виконавця','Документи, які Адміністратор ЦПАП надійслав до виконавчого органу',NULL,NULL,NULL,NULL,NULL,NULL),
  (18,8,6,'Прийняте рішення','Документи, по якім виконавчий орган прийняв рішення',NULL,NULL,NULL,NULL,NULL,NULL),
  (19,8,6,'Архив','Документи, які Адміністратор ЦНАП поклав до архіву',NULL,NULL,NULL,NULL,NULL,NULL),
  (20,8,6,'Надісланні','Документи які надійшли до виконавчого органу',NULL,NULL,NULL,NULL,NULL,NULL),
  (21,8,6,'У роботі','Документи, які представник виконавчого органу прийняв у роботу',NULL,NULL,NULL,NULL,NULL,NULL),
  (22,8,6,'Виконано','Документи, по якім представник виконавчого органу виніс рішення',NULL,NULL,NULL,NULL,NULL,NULL);
COMMIT;

#
# Data for the `ff_route_node` table  (LIMIT -492,500)
#

INSERT INTO `ff_route_node` (`id`, `registry`, `storage`, `name`, `comment`, `allow_action`, `deny_action`) VALUES

  (43,6,4,'Нові (Заявник)','Документи зареєстровані заявником',NULL,NULL),
  (44,6,4,'На розляді у Адміністратора','На розляді у Адміністратора',NULL,NULL),
  (45,6,4,'Прийняті у роботу (Адміністратор)','Прийняті у роботу Адміністратором',NULL,NULL),
  (46,6,4,'У виконавця','Документи надіслані до виконавчого органу',NULL,NULL),
  (47,6,4,'Виконані','Документи виконані виконачим органом',NULL,NULL),
  (48,6,4,'В архіві','Документи які направленні до архіву',NULL,NULL),
  (68,6,4,'У виконавця в роботі','Документи, які виконавець прийняв до роботи',NULL,NULL);
COMMIT;

#
# Data for the `ff_types` table  (LIMIT -465,500)
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
  (18,'Телефон','VARCHAR(20)','phone','Телефон',1),
  (19,'E-mail','VARCHAR(70)','email','Электронный адрес',1),
  (1001,'actions','INT(11)','listbox_multi','Действия на узлах маршрута',1),
  (1002,'nodes','INT(11)','listbox_multi','Перечень узлов маршрута',1),
  (1003,'routes','INT(11)','combobox','Маршруты',1),
  (1007,'folders','INT(11)','listbox_multi','Папки кабинета',1),
  (1008,'Список пользователей','INT(11)','listbox_multi','Проба работы с внешними таблицами',1),
  (1009,'Роли','INT(11)','listbox_multi','Проба работы с внешними таблицами',1),
  (1010,'Доступные узлы','INT(11)','listbox_multi','Доступные узлы(available nodes) документа',1),
  (1011,'Список регистраций свободных форм','INT(11)','listbox_multi','Список зарегистрированых свободных форм',1),
  (1012,'Список хранилищ','INT(11)','listbox_multi','Список зарегистрированных хранилищ',1),
  (1013,'Доступные действия','INT(11)','listbox_multi','Перечень доступных действий в узле',1),
  (1014,'Правовая форма','INT(11)','radiobox','Физик, Юрик',1),
  (1015,'Услуги','INT(11)','combobox','Список услуг',1),
  (1016,'Организации','INT(11)','innerguide','Встраиваемый справочник в документ ЦНАП',1),
  (1017,'Вид доставки','INT(11)','combobox','Вид доставки',1),
  (1018,'Результат виконання','INT(11)','combobox','Довідник з результатами виконання',1);
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