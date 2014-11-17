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
CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
# Структура для таблицы `ff_available_nodes_for_cnap`: 
#

CREATE TABLE `ff_available_nodes_for_cnap` (
  `id` INTEGER(11) NOT NULL,
  `registry` INTEGER(11) NOT NULL DEFAULT 41,
  `storage` INTEGER(11) DEFAULT NULL,
  `node` BIGINT(20) DEFAULT NULL,
  `users` INTEGER(11) DEFAULT NULL,
  `roles` INTEGER(11) DEFAULT NULL,
  `authorities` INTEGER(11) DEFAULT NULL,
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
AUTO_INCREMENT=636 AVG_ROW_LENGTH=112 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
  `authorities` INTEGER(11) DEFAULT NULL,
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
  `authorities` INTEGER(11) DEFAULT NULL,
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
AUTO_INCREMENT=314 AVG_ROW_LENGTH=88 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
AUTO_INCREMENT=104 AVG_ROW_LENGTH=546 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
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
  `authorities` INTEGER(11) DEFAULT NULL,
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
# Data for the `ff_default` table  (LIMIT -37,500)
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
  (82,37,18),
  (84,37,18),
  (86,37,18),
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
  (150,37,18),
  (152,37,18),
  (154,37,18),
  (155,37,18),
  (157,37,18),
  (159,37,18),
  (161,37,18),
  (163,37,18),
  (165,37,18),
  (169,2,2),
  (170,2,2),
  (171,2,2),
  (172,2,2),
  (173,37,18),
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
  (195,37,18),
  (203,2,2),
  (204,2,2),
  (205,2,2),
  (206,2,2),
  (207,2,2),
  (208,2,2),
  (210,37,18),
  (218,2,2),
  (219,2,2),
  (220,2,2),
  (221,2,2),
  (222,2,2),
  (223,2,2),
  (225,2,2),
  (226,2,2),
  (227,2,2),
  (228,37,18),
  (236,2,2),
  (237,2,2),
  (238,2,2),
  (239,2,2),
  (240,2,2),
  (241,2,2),
  (243,37,18),
  (251,2,2),
  (252,2,2),
  (253,2,2),
  (254,2,2),
  (255,2,2),
  (256,2,2),
  (258,37,18),
  (266,2,2),
  (267,2,2),
  (268,2,2),
  (269,2,2),
  (270,2,2),
  (271,2,2),
  (273,37,18),
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
  (301,37,18),
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
  (325,37,18),
  (326,38,16),
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
  (353,37,18),
  (354,38,16),
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
  (377,37,18),
  (378,38,16),
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
  (412,37,18),
  (413,38,16),
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
  (635,2,2);
COMMIT;

#
# Data for the `ff_document_base` table  (LIMIT -495,500)
#

INSERT INTO `ff_document_base` (`id`, `registry`, `storage`, `createdate`, `route`, `available_nodes`, `available_actions`) VALUES

  (326,38,16,'2014-11-10 12:48:52',148,NULL,NULL),
  (354,38,16,'2014-11-10 12:53:40',148,NULL,NULL),
  (378,38,16,'2014-11-10 13:11:43',148,NULL,NULL),
  (413,38,16,'2014-11-10 15:24:38',148,NULL,NULL);
COMMIT;

#
# Data for the `ff_document_cnap` table  (LIMIT -495,500)
#

INSERT INTO `ff_document_cnap` (`id`, `registry`, `storage`, `createdate`, `route`, `available_nodes`, `available_actions`, `regnum`, `regdate`, `legal_personality`, `organization`, `person_name`, `person_drfo`, `address`, `phone1`, `phone2`, `delivery_reply`, `email`, `service`, `context`, `reason`, `reply`, `file_petition`, `file_petition_fileedsname`, `plandate`, `factdate`, `administrator`, `executor`, `file_result`, `file_result_fileedsname`, `authorities`) VALUES

  (326,38,16,'2014-11-10 12:48:52',148,NULL,NULL,NULL,NULL,NULL,325,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'тест12',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (354,38,16,'2014-11-10 12:53:40',148,NULL,NULL,NULL,NULL,NULL,353,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'тест 13',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (378,38,16,'2014-11-10 13:11:43',148,NULL,NULL,NULL,NULL,NULL,377,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'test14',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (413,38,16,'2014-11-10 15:24:38',148,NULL,NULL,NULL,NULL,NULL,412,NULL,NULL,NULL,NULL,NULL,NULL,NULL,61,'+++++',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
COMMIT;

#
# Data for the `ff_document_cnap_metolobruht` table  (LIMIT -495,500)
#

INSERT INTO `ff_document_cnap_metolobruht` (`id`, `registry`, `storage`, `createdate`, `route`, `available_nodes`, `available_actions`, `regnum`, `regdate`, `legal_personality`, `organization`, `person_name`, `person_drfo`, `address`, `phone1`, `phone2`, `delivery_reply`, `email`, `service`, `context`, `reason`, `reply`, `file_petition`, `file_petition_fileedsname`, `plandate`, `factdate`, `administrator`, `executor`, `file_result`, `file_result_fileedsname`, `authorities`) VALUES

  (326,38,16,'2014-11-10 12:48:52',148,NULL,NULL,NULL,NULL,NULL,325,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'тест12',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (354,38,16,'2014-11-10 12:53:40',148,NULL,NULL,NULL,NULL,NULL,353,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'тест 13',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (378,38,16,'2014-11-10 13:11:43',148,NULL,NULL,NULL,NULL,NULL,377,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'test14',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (413,38,16,'2014-11-10 15:24:38',148,NULL,NULL,NULL,NULL,NULL,412,NULL,NULL,NULL,NULL,NULL,NULL,NULL,61,'+++++',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
COMMIT;

#
# Data for the `ff_registry` table  (LIMIT -465,500)
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
  (37,3,'organization','Установа',0,0,1,NULL),
  (38,36,'document_cnap_metolobruht','заготівлі, переробки, металургійної переробки металобрухту кольорових і чорних металів',0,0,0,NULL),
  (39,NULL,'gen_authorities','Перелік управліннь',0,1,0,NULL),
  (40,5,'route_action_for_cnap','Дія для документів ЦНАП',0,0,1,NULL),
  (41,16,'available_nodes_for_cnap','Доступні вузли для документів ЦНАП',0,0,0,NULL),
  (42,21,'available_actions_for_cnap','Дозволені дії з документом для документів ЦНАП',0,0,0,NULL);
COMMIT;

#
# Data for the `ff_field` table  (LIMIT -283,500)
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
  (220,37,'registry',2,NULL,0,1,NULL),
  (221,37,'storage',2,NULL,0,1,NULL),
  (222,37,'name',1,'Найменування',100,1,''),
  (223,37,'edrpou',1,'ЄДРПОУ',200,0,NULL),
  (224,36,'organization',1016,'Підприємство',400,0,NULL),
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
  (240,36,'plandate',3,'Запланована дата виконання',1800,0,NULL),
  (241,36,'factdate',3,'Дата виконання',1900,0,NULL),
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
  (255,38,'organization',1016,'Підприємство',400,1,NULL),
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
  (271,38,'plandate',3,'Запланована дата виконання',1800,1,NULL),
  (272,38,'factdate',3,'Дата виконання',1900,1,NULL),
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
  (293,40,'authorities',1020,'Управління',900,0,''),
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
  (309,41,'authorities',1020,'Управління - виконавці',0,0,''),
  (310,40,'clearuser',6,'Користувачі з вузлів для очистки',550,0,''),
  (311,40,'current_authorities',1,'Поле з управлінням',1000,0,''),
  (312,36,'authorities',1020,'Суб''єкт розгляду',1150,0,''),
  (313,38,'authorities',1020,'Суб''єкт розгляду',1150,1,'');
COMMIT;

#
# Data for the `ff_oneline` table  (LIMIT -433,500)
#

INSERT INTO `ff_oneline` (`id`, `registry`, `storage`, `name`) VALUES

  (1,12,7,'Кабінет заявника'),
  (3,12,7,'Кабінет адміністратора'),
  (5,3,15,'Фізична особа'),
  (6,3,15,'Фізична особа - підприємець'),
  (7,3,15,'Юридична особа'),
  (8,12,7,'Кабінет виконавця'),
  (82,37,18,NULL),
  (84,37,18,NULL),
  (86,37,18,NULL),
  (88,3,19,'Сайт'),
  (89,3,19,'Особисто'),
  (90,3,19,'Пошта'),
  (91,3,20,'Відмовленно'),
  (92,3,20,'Прийняте рішення'),
  (93,3,20,'Видано дозвільний документ'),
  (148,28,5,'Маршрут ЦНАП'),
  (150,37,18,NULL),
  (152,37,18,NULL),
  (154,37,18,NULL),
  (155,37,18,NULL),
  (157,37,18,NULL),
  (159,37,18,NULL),
  (161,37,18,NULL),
  (163,37,18,NULL),
  (165,37,18,NULL),
  (173,37,18,NULL),
  (195,37,18,NULL),
  (210,37,18,NULL),
  (228,37,18,NULL),
  (243,37,18,NULL),
  (258,37,18,NULL),
  (273,37,18,NULL),
  (301,37,18,NULL),
  (325,37,18,NULL),
  (353,37,18,NULL),
  (377,37,18,NULL),
  (412,37,18,NULL),
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
  (577,40,3,'Видати позитивне рішення'),
  (582,40,3,'Відмовити'),
  (584,40,3,'До архіву'),
  (612,8,6,'Нові (Заявник)'),
  (618,8,6,'Розглядаються (заявник)'),
  (620,8,6,'Розглянуті (Заявник)'),
  (622,8,6,'Надіслані (Адміністратор)'),
  (624,8,6,'Прийняті у роботу (Адміністратор)'),
  (626,8,6,'За належністтю (Адміністратор)'),
  (628,8,6,'Вирішені (Адміністратор)'),
  (630,8,6,'Архів'),
  (632,8,6,'Надіслані (Виконавець)'),
  (634,8,6,'Прийняті у роботу (Виконавець)');
COMMIT;

#
# Data for the `ff_organization` table  (LIMIT -475,500)
#

INSERT INTO `ff_organization` (`id`, `registry`, `storage`, `name`, `edrpou`) VALUES

  (82,37,18,NULL,NULL),
  (84,37,18,NULL,NULL),
  (86,37,18,NULL,NULL),
  (150,37,18,NULL,NULL),
  (152,37,18,NULL,NULL),
  (154,37,18,NULL,NULL),
  (155,37,18,NULL,NULL),
  (157,37,18,NULL,NULL),
  (159,37,18,NULL,NULL),
  (161,37,18,NULL,NULL),
  (163,37,18,NULL,NULL),
  (165,37,18,NULL,NULL),
  (173,37,18,NULL,NULL),
  (195,37,18,NULL,NULL),
  (210,37,18,NULL,NULL),
  (228,37,18,NULL,NULL),
  (243,37,18,NULL,NULL),
  (258,37,18,NULL,NULL),
  (273,37,18,NULL,NULL),
  (301,37,18,NULL,NULL),
  (325,37,18,NULL,NULL),
  (353,37,18,NULL,NULL),
  (377,37,18,NULL,NULL),
  (412,37,18,NULL,NULL);
COMMIT;

#
# Data for the `ff_ref_multiguide` table  (LIMIT -420,500)
#

INSERT INTO `ff_ref_multiguide` (`id`, `registry`, `storage`, `order`, `owner`, `owner_field`, `reference`) VALUES

  (149,2,2,NULL,148,'start_route',43),
  (171,2,2,NULL,148,'start_route',43),
  (351,2,2,NULL,326,'available_nodes',349),
  (352,2,2,NULL,326,'available_actions',350),
  (372,2,2,NULL,354,'available_nodes',367),
  (373,2,2,1,354,'available_nodes',369),
  (374,2,2,NULL,354,'available_actions',368),
  (375,2,2,1,354,'available_actions',370),
  (376,2,2,2,354,'available_actions',371),
  (396,2,2,NULL,378,'available_nodes',391),
  (397,2,2,1,378,'available_nodes',393),
  (398,2,2,NULL,378,'available_actions',392),
  (399,2,2,1,378,'available_actions',394),
  (400,2,2,2,378,'available_actions',395),
  (401,2,2,0,1,'folders',10),
  (402,2,2,1,1,'folders',11),
  (403,2,2,NULL,1,'role',4),
  (434,2,2,NULL,413,'available_nodes',426),
  (435,2,2,1,413,'available_nodes',428),
  (436,2,2,2,413,'available_nodes',431),
  (437,2,2,NULL,413,'available_actions',427),
  (438,2,2,1,413,'available_actions',429),
  (439,2,2,2,413,'available_actions',430),
  (440,2,2,3,413,'available_actions',432),
  (441,2,2,4,413,'available_actions',433),
  (461,2,2,0,3,'folders',12),
  (462,2,2,2,3,'folders',17),
  (463,2,2,1,3,'folders',448),
  (464,2,2,3,3,'folders',454),
  (465,2,2,4,3,'folders',455),
  (466,2,2,5,3,'folders',456),
  (467,2,2,NULL,3,'role',2),
  (468,2,2,5,8,'folders',456),
  (469,2,2,1,8,'folders',457),
  (470,2,2,2,8,'folders',458),
  (471,2,2,3,8,'folders',459),
  (472,2,2,4,8,'folders',460),
  (473,2,2,NULL,8,'role',3),
  (560,2,2,NULL,559,'gotonodes',542),
  (561,2,2,1,559,'gotonodes',545),
  (562,2,2,NULL,559,'clearnodes',541),
  (566,2,2,NULL,548,'gotonodes',538),
  (567,2,2,1,548,'gotonodes',540),
  (568,2,2,NULL,548,'clearnodes',537),
  (569,2,2,NULL,548,'roles',2),
  (570,2,2,NULL,553,'gotonodes',541),
  (571,2,2,NULL,553,'clearnodes',540),
  (572,2,2,NULL,563,'gotonodes',539),
  (573,2,2,1,563,'gotonodes',543),
  (575,2,2,NULL,574,'gotonodes',546),
  (576,2,2,NULL,574,'clearnodes',545),
  (578,2,2,NULL,577,'gotonodes',543),
  (579,2,2,1,577,'gotonodes',547),
  (580,2,2,NULL,577,'clearnodes',542),
  (581,2,2,1,577,'clearnodes',546),
  (585,2,2,NULL,584,'gotonodes',544),
  (586,2,2,NULL,584,'clearnodes',543),
  (587,2,2,1,584,'clearnodes',547),
  (588,2,2,NULL,582,'gotonodes',539),
  (589,2,2,1,582,'gotonodes',543),
  (590,2,2,2,582,'gotonodes',547),
  (591,2,2,NULL,582,'clearnodes',538),
  (592,2,2,1,582,'clearnodes',542),
  (593,2,2,2,582,'clearnodes',546),
  (594,2,2,NULL,582,'roles',3),
  (613,2,2,NULL,612,'nodes',537),
  (614,2,2,NULL,612,'allow_new',16),
  (615,2,2,NULL,612,'deny_new',36),
  (616,2,2,NULL,612,'allow_edit',16),
  (617,2,2,NULL,612,'allow_delete',16),
  (619,2,2,NULL,618,'nodes',538),
  (621,2,2,NULL,620,'nodes',539),
  (623,2,2,NULL,622,'nodes',540),
  (625,2,2,NULL,624,'nodes',541),
  (627,2,2,NULL,626,'nodes',542),
  (629,2,2,NULL,628,'nodes',543),
  (631,2,2,NULL,630,'nodes',544),
  (633,2,2,NULL,632,'nodes',545),
  (635,2,2,NULL,634,'nodes',546);
COMMIT;

#
# Data for the `ff_registry_h` table  (LIMIT -402,500)
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
# Data for the `ff_storage` table  (LIMIT -478,500)
#

INSERT INTO `ff_storage` (`id`, `name`, `description`, `subtype`, `type`, `fields`) VALUES

  (1,'default','Хранилище по умолчанию',0,NULL,NULL),
  (2,'ref_multiguide_storage','Хранилище для хранения связок',0,NULL,NULL),
  (3,'actions','Действия на узлах маршрута',5,1001,''),
  (4,'nodes','Перечень узлов маршрута',5,1002,''),
  (5,'routes','Маршруты',1,1003,NULL),
  (6,'folders','Папки кабинета',5,1007,NULL),
  (7,'cabinets','Кабинеты',0,NULL,NULL),
  (9,'users','Користувачі',5,1008,''),
  (10,'roles','Ролі',5,1009,'user_role'),
  (11,'available nodes','Доступні вузли документу',5,1010,''),
  (12,'ff_registry','Список зареєстрованих вільних форм',5,1011,'tablename:Название;description:Описание'),
  (13,'ff_storage','Список зареєстрованих сховищ',5,1012,'name:Название;description:Описание'),
  (14,'available_actions','Перелік дій які доступні',5,1013,''),
  (15,'Правовая форма','Фізична, або Юридична особа',4,1014,''),
  (16,'Документи ЦНАП','Документи для отримання адміістративних послуг',0,NULL,''),
  (17,'Послуги','Список послуг',1,1015,'name'),
  (18,'Организации','Вбудований довідник в документ ЦНАП',3,1016,''),
  (19,'Вид доставки','Вид доставки',1,1017,NULL),
  (20,'Результат виконання','Довідник з результатами виконання',1,1018,NULL),
  (22,'Значення документів за-замовченям','Для завдання реквізитів документів за-замовченям',1,1019,'id'),
  (23,'authorities','Перелік управлінь',1,1020,'name:Назва');
COMMIT;

#
# Data for the `ff_registry_storage` table  (LIMIT -464,500)
#

INSERT INTO `ff_registry_storage` (`id`, `registry`, `storage`) VALUES

  (1,1,1),
  (2,2,2),
  (15,8,6),
  (22,9,7),
  (23,12,7),
  (24,15,7),
  (45,7,5),
  (46,27,5),
  (47,28,5),
  (53,3,19),
  (54,3,20),
  (79,6,4),
  (80,10,9),
  (81,11,10),
  (82,16,11),
  (83,17,11),
  (84,18,11),
  (85,41,11),
  (86,5,3),
  (87,25,3),
  (88,26,3),
  (89,40,3),
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
  (103,37,18);
COMMIT;

#
# Data for the `ff_route` table  (LIMIT -498,500)
#

INSERT INTO `ff_route` (`id`, `registry`, `storage`, `name`, `comment`, `start_route`) VALUES

  (148,28,5,'Маршрут ЦНАП','Задає початок руху доументів ЦНАП',NULL);
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
  (577,40,3,'Видати позитивне рішення','Дозвільні документи. Дія виконавця',NULL,NULL,0),
  (582,40,3,'Відмовити','Дозвільні документи. Дія виконавця',NULL,NULL,0),
  (584,40,3,'До архіву','Дозвільні документи. Дія адміністратора',NULL,NULL,0);
COMMIT;

#
# Data for the `ff_route_action_for_cnap` table  (LIMIT -491,500)
#

INSERT INTO `ff_route_action_for_cnap` (`id`, `registry`, `storage`, `name`, `comment`, `gotonodes`, `clearnodes`, `currentuser`, `default_attributes`, `roles`, `users`, `authorities`, `clearuser`, `current_authorities`) VALUES

  (548,40,3,'На розгляд','Дозвільні документи. Дія заявника (автоматична)',NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL),
  (553,40,3,'Прийняті у роботу','Дозвільні документи. Дія адміністратора',NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL),
  (559,40,3,'Направити до виконавчого органу','Дозвільні документи. Дія адміністратора.',NULL,NULL,1,NULL,NULL,NULL,10,NULL,NULL),
  (563,40,3,'Відмовити','Дозвільні документи. Дія адміністратора',NULL,NULL,1,NULL,NULL,NULL,NULL,1,NULL),
  (574,40,3,'Прийняти у роботу','Дозвільні документи. Дія виконавця',NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL),
  (577,40,3,'Видати позитивне рішення','Дозвільні документи. Дія виконавця',NULL,NULL,0,NULL,NULL,NULL,NULL,1,NULL),
  (582,40,3,'Відмовити','Дозвільні документи. Дія виконавця',NULL,NULL,0,NULL,NULL,NULL,NULL,1,NULL),
  (584,40,3,'До архіву','Дозвільні документи. Дія адміністратора',NULL,NULL,0,NULL,NULL,NULL,NULL,1,NULL);
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
# Data for the `ff_route_folder` table  (LIMIT -489,500)
#

INSERT INTO `ff_route_folder` (`id`, `registry`, `storage`, `name`, `comment`, `nodes`, `allow_new`, `allow_edit`, `allow_delete`, `visual_names`, `deny_new`) VALUES

  (612,8,6,'Нові (Заявник)','Тестування',NULL,NULL,NULL,NULL,NULL,NULL),
  (618,8,6,'Розглядаються (заявник)','Тестування',NULL,NULL,NULL,NULL,NULL,NULL),
  (620,8,6,'Розглянуті (Заявник)','Тестування',NULL,NULL,NULL,NULL,NULL,NULL),
  (622,8,6,'Надіслані (Адміністратор)','Тестування',NULL,NULL,NULL,NULL,NULL,NULL),
  (624,8,6,'Прийняті у роботу (Адміністратор)','Тестування',NULL,NULL,NULL,NULL,NULL,NULL),
  (626,8,6,'За належністтю (Адміністратор)','Тестування',NULL,NULL,NULL,NULL,NULL,NULL),
  (628,8,6,'Вирішені (Адміністратор)','Тестування',NULL,NULL,NULL,NULL,NULL,NULL),
  (630,8,6,'Архів','Тестування',NULL,NULL,NULL,NULL,NULL,NULL),
  (632,8,6,'Надіслані (Виконавець)','Тестування',NULL,NULL,NULL,NULL,NULL,NULL),
  (634,8,6,'Прийняті у роботу (Виконавець)','Тестування',NULL,NULL,NULL,NULL,NULL,NULL);
COMMIT;

#
# Data for the `ff_route_for_user` table  (LIMIT -498,500)
#

INSERT INTO `ff_route_for_user` (`id`, `registry`, `storage`, `name`, `comment`, `start_route`, `users`, `currentuser`) VALUES

  (148,28,5,'Маршрут ЦНАП','Задає початок руху доументів ЦНАП',NULL,NULL,1);
COMMIT;

#
# Data for the `ff_route_node` table  (LIMIT -488,500)
#

INSERT INTO `ff_route_node` (`id`, `registry`, `storage`, `name`, `comment`, `allow_action`, `deny_action`) VALUES

  (537,6,4,'Нові (Заявник)',NULL,NULL,NULL),
  (538,6,4,'Розглядаються (заявник)',NULL,NULL,NULL),
  (539,6,4,'Розглянуті (Заявник)',NULL,NULL,NULL),
  (540,6,4,'Надіслані (Адміністратор)',NULL,NULL,NULL),
  (541,6,4,'Прийняті у роботу (Адміністратор)',NULL,NULL,NULL),
  (542,6,4,'За належністтю (Адміністратор)',NULL,NULL,NULL),
  (543,6,4,'Вирішені (Адміністратор)',NULL,NULL,NULL),
  (544,6,4,'Архів',NULL,NULL,NULL),
  (545,6,4,'Надіслані (Виконавець)',NULL,NULL,NULL),
  (546,6,4,'Прийняті у роботу (Виконавець)',NULL,NULL,NULL),
  (547,6,4,'Вирішені (Виконавець)',NULL,NULL,NULL);
COMMIT;

#
# Data for the `ff_types` table  (LIMIT -461,500)
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
  (1001,'actions','INT(11)','listbox_multi','Действия на узлах маршрута',1),
  (1002,'nodes','INT(11)','listbox_multi','Перечень узлов маршрута',1),
  (1003,'routes','INT(11)','combobox','Маршруты',1),
  (1007,'folders','INT(11)','listbox_multi','Папки кабинета',1),
  (1008,'users','INT(11)','listbox_multi','Користувачі',1),
  (1009,'roles','INT(11)','listbox_multi','Ролі',1),
  (1010,'available nodes','INT(11)','listbox_multi','Доступні вузли документу',1),
  (1011,'ff_registry','INT(11)','listbox_multi','Список зареєстрованих вільних форм',1),
  (1012,'ff_storage','INT(11)','listbox_multi','Список зареєстрованих сховищ',1),
  (1013,'available_actions','INT(11)','listbox_multi','Перелік дій які доступні',1),
  (1014,'Правовая форма','INT(11)','radiobox','Фізична, або Юридична особа',1),
  (1015,'Послуги','INT(11)','combobox','Список послуг',1),
  (1016,'Организации','INT(11)','innerguide','Вбудований довідник в документ ЦНАП',1),
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