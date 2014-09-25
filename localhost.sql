-- phpMyAdmin SQL Dump
-- version 4.0.5
-- http://www.phpmyadmin.net
--
-- Хост: localhost
-- Время создания: Сен 24 2014 г., 12:00
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
CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_ALTTBL`(
 in IDREGISTRY INT
 )
BEGIN
 DECLARE CHILDCNT INT;
 DECLARE VOWNER INT;
 DECLARE VSTMT VARCHAR(4000);
 DECLARE VTSTMT VARCHAR(4000);
 DECLARE VTABLENAME VARCHAR(45);
 DECLARE done INT DEFAULT FALSE;
 DECLARE cur1 CURSOR FOR SELECT DISTINCT `owner` FROM `ff_registry_h` where `parent`= IDREGISTRY;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

 select count(`owner`) into CHILDCNT from `ff_registry_h` where `parent`= IDREGISTRY;
 if CHILDCNT=0 then -- Только для пустых таблиц
 call FF_DELTBL(IDREGISTRY);
 call FF_CRTTBL(IDREGISTRY);
 else 
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
 end if;
END$$

CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_CRTTBL`(
 in IDREGISTRY INT
 )
BEGIN
 DECLARE VTABLENAME VARCHAR(45);
 DECLARE Q_CRTBL VARCHAR(1000);
 
 -- SET VTABLENAME=null;
 select `tablename` into VTABLENAME from `ff_registry` where id = IDREGISTRY;
 -- создаем начальную таблицу
 select CONCAT('CREATE TABLE `ff_',VTABLENAME,
 '` ( `id` INT NOT NULL, `registry` INT NOT NULL DEFAULT ',
 IDREGISTRY,', `storage` INT NULL DEFAULT NULL, PRIMARY KEY (`id`))')
 into @Q_CRTBL; 
 
 PREPARE stmt1 FROM @Q_CRTBL;
 EXECUTE stmt1;
 DEALLOCATE PREPARE stmt1; 
 
END$$

CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_DELTBL`(
 in IDREGISTRY INT
 )
BEGIN
 DECLARE VTABLENAME VARCHAR(45);
 DECLARE VATTACHING BIT;
 DECLARE Q_DLTBL VARCHAR(1000);
 DECLARE CHILDCNT INT;
 
 select count(`owner`) into CHILDCNT from `ff_registry_h` where `parent`= IDREGISTRY;
 if CHILDCNT=0 then
 select `tablename`, `attaching` into VTABLENAME,VATTACHING from `ff_registry` where id = IDREGISTRY;
 if VATTACHING=0 then
 select CONCAT('DROP TABLE `ff_',VTABLENAME) into @Q_DLTBL; 
 PREPARE stmt1 FROM @Q_DLTBL;
 EXECUTE stmt1;
 DEALLOCATE PREPARE stmt1;
 end if;
 else
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Нельзя удалить таблицу у которой есть наследники';
 end if;
END$$

CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_GETID`(
 in IDREGISTRY INT,
 in IDSTORAGE INT,
 out ID bigint(20)
 )
BEGIN
 declare vtablename varchar(45);
 declare vquery varchar(1000);
 DECLARE done INT DEFAULT FALSE;
 DECLARE cur1 cursor for 
 SELECT ffr.`tablename` 
 FROM `ff_registry_h` ffrh 
 inner join `ff_registry` ffr 
 on ((ffrh.`parent`=ffr.`id`) and (ffr.`copying`=1) and (ffr.`id`<>1)) 
 where `owner`=IDREGISTRY;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
 
 -- Вычисляем идентификатор
 insert into `ff_default` (`registry`,`storage`) values (IDREGISTRY, IDSTORAGE);
 SELECT LAST_INSERT_ID() INTO ID;

 -- Инициируем всех потомков у которых стоит флаг копирования
 open cur1;
 fetch cur1 into vtablename;
 while (not done) do
 select concat('insert into `',vtablename,'` (`registry`,`storage`) values (IDREGISTRY, IDSTORAGE))') into @vquery;
 PREPARE stmt1 FROM @vquery;
 EXECUTE stmt1;
 DEALLOCATE PREPARE stmt1;

 fetch cur1 into vtablename;
 end while;
 close cur1;
END$$

CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_HELPER_ALTTBL`(
 in IDREGISTRY INT,
 out STMT varchar(4000)
 )
BEGIN
DECLARE done INT DEFAULT FALSE;
DECLARE VSTMTPIACE VARCHAR(200);
DECLARE cur1 CURSOR FOR select sq from (
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
 WHERE ffr.id=IDREGISTRY) 
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
 WHERE fff.`formid`=IDREGISTRY) tt 
 right outer join information_schema.`COLUMNS` isc on (
 (lower(isc.`COLUMN_NAME`) = tt.ffcn) and 
 (isc.`TABLE_SCHEMA`=DATABASE())) 
 inner join `ff_registry` ffr2 on (CONCAT('ff_',lower(ffr2.`tablename`))=lower(isc.`TABLE_NAME`))
 where (LOWER(isc.`COLUMN_NAME`)<>'id') and ffr2.`id`=IDREGISTRY)) t1 ) t2
 where t2.sq is not null;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
open cur1;
 set STMT='';

 fetch cur1 into VSTMTPIACE;
 while (not done) do
 if (STMT='') then
 set STMT=VSTMTPIACE;
 else
 set STMT=concat(STMT,', ',VSTMTPIACE);
 end if;
 fetch cur1 into VSTMTPIACE;
 end while;
close cur1;
END$$

DELIMITER ;

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
(14, 'Модуль «Вільні форми до послуг»', 2, 'admin/default', 3),
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
  PRIMARY KEY (`id`),
  KEY `ext_user_certs_idx` (`ext_user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Сертифікати зовнішніх користувачів»' AUTO_INCREMENT=3 ;

--
-- Дамп данных таблицы `cab_user_extern_certs`
--

INSERT INTO `cab_user_extern_certs` (`id`, `type_of_user`, `certissuer`, `certserial`, `certSubjDRFOCode`, `certSubjEDRPOUCode`, `certData`, `certType`, `ext_user_id`) VALUES
(1, 0, 'O=АТ "ІІТ";OU=Тестовий ЦСК;CN=Тестовий ЦСК АТ "ІІТ";Serial=UA-22723472;C=UA;L=Харків;ST=Харківська', '5B63D88375D9201804000000EB040000630A0000', '9987654321', '99876540', 0x3082068130820629a00302010202145b63d88375d9201804000000eb040000630a0000300d060b2a862402010101010301013081c331163014060355040a0c0dd090d0a22022d086d086d0a2223120301e060355040b0c17d0a2d0b5d181d182d0bed0b2d0b8d0b920d0a6d0a1d09a312e302c06035504030c25d0a2d0b5d181d182d0bed0b2d0b8d0b920d0a6d0a1d09a20d090d0a22022d086d086d0a2223114301206035504050c0b55412d3232373233343732310b30090603550406130255413115301306035504070c0cd0a5d0b0d180d0bad196d0b2311d301b06035504080c14d0a5d0b0d180d0bad196d0b2d181d18cd0bad0b0301e170d3134303830383231303030305a170d3135303830383231303030305a3082012231223020060355040a0c19d0a4d196d0b7d0b8d187d0bdd0b020d0bed181d0bed0b1d0b031223020060355040b0c19d0a4d196d0b7d0b8d187d0bdd0b020d0bed181d0bed0b1d0b031223020060355040c0c19d0a4d196d0b7d0b8d187d0bdd0b020d0bed181d0bed0b1d0b0312f302d06035504030c26d09cd0bed0bbd0bed0b4d188d0b8d0b920d094d0b8d18020d094d0b8d180d0bed0b2d0b8d1873119301706035504040c10d09cd0bed0bbd0bed0b4d188d0b8d0b9311e301c060355042a0c15d094d0b8d18020d094d0b8d180d0bed0b2d0b8d187310d300b06035504050c0431323539310b30090603550406130255413113301106035504070c0ad09ed0b4d0b5d181d0b03117301506035504080c0ed09ed0b4d0b5d181d18cd0bad0b03081f23081c9060b2a862402010101010301013081b9307530070202010102010c020100042110bee3db6aea9e1f86578c45c12594ff942394a7d738f9187e6515017294f4ce01022100800000000000000000000000000000006759213af182e987d3e17714907d470d0421b60fd2d8dce8a93423c6101bca91c47a007e6c300b26cd556c9b0e7d20ef292a000440a9d6eb45f13c708280c4967b231f5eadf658eba4c037291d38d96bf025ca4e17f8e9720dc615b43a28975f0bc1dea36438b564ea2c179fd0123e6db8fac5790403240004215869fc50fc2b8e07bc779940ba002d79e08fba55b3560679580fb2a7cab3f95f00a38202fa308202f630290603551d0e042204204d0fb29c86aa18eea3a89eef34b84ab2bf8f3f928010767dd468bddaf7441527302b0603551d230424302280205b63d88375d92018cdb4b10eb9b6a5c69a59fd4327c671e3c1f53aeab02d6ade302f0603551d1004283026a011180f32303134303830383231303030305aa111180f32303135303830383231303030305a300e0603551d0f0101ff0404030206c030190603551d200101ff040f300d300b06092a8624020101010202300c0603551d130101ff04023000301e06082b060105050701030101ff040f300d300b06092a86240201010102013081810603551d11047a3078a035060c2b0601040181974601010402a0250c23d0b2d183d0bb2e20d0a1d0b5d180d182d0b8d184d196d0bad0b0d182d0bdd0b02c2033a01f060c2b0601040181974601010401a00f0c0d2b333830303831323334353637820c6961736e61702e6c6f63616c8110666f726d61743132406d6574612e756130410603551d1f043a30383036a034a0328630687474703a2f2f63612e6969742e636f6d2e75612f646f776e6c6f61642f63726c732f434131332d46756c6c2e63726c30420603551d2e043b30393037a035a0338631687474703a2f2f63612e6969742e636f6d2e75612f646f776e6c6f61642f63726c732f434131332d44656c74612e63726c30818106082b0601050507010104753073302f06082b060105050730018623687474703a2f2f63612e6969742e636f6d2e75612f73657276696365732f6f6373702f304006082b060105050730028634687474703a2f2f63612e6969742e636f6d2e75612f646f776e6c6f61642f6365727469666963617465732f63616969742e703762303e06082b0601050507010b04323030302e06082b060105050730038622687474703a2f2f63612e6969742e636f6d2e75612f73657276696365732f7473702f30430603551d09043c303a301a060c2a8624020101010b01040201310a13083939383736353430301c060c2a8624020101010b01040101310c130a39393837363534333231300d060b2a862402010101010301010343000440c61a79035d4ef320eb20a1be8c19e7bc8ecfdef485f00180a3262cb2e9b66206bc1ac6b4bda3b092360149d34316e9aaaac7bb95e9dc39ac4373de0035c5a942, 0, 1),
(2, 0, 'O=АТ "ІІТ";OU=Тестовий ЦСК;CN=Тестовий ЦСК АТ "ІІТ";Serial=UA-22723472;C=UA;L=Харків;ST=Харківська', '5B63D88375D9201804000000EB040000630A0000', '9987654321', '99876540', 0x3082068130820629a00302010202145b63d88375d9201804000000eb040000630a0000300d060b2a862402010101010301013081c331163014060355040a0c0dd090d0a22022d086d086d0a2223120301e060355040b0c17d0a2d0b5d181d182d0bed0b2d0b8d0b920d0a6d0a1d09a312e302c06035504030c25d0a2d0b5d181d182d0bed0b2d0b8d0b920d0a6d0a1d09a20d090d0a22022d086d086d0a2223114301206035504050c0b55412d3232373233343732310b30090603550406130255413115301306035504070c0cd0a5d0b0d180d0bad196d0b2311d301b06035504080c14d0a5d0b0d180d0bad196d0b2d181d18cd0bad0b0301e170d3134303830383231303030305a170d3135303830383231303030305a3082012231223020060355040a0c19d0a4d196d0b7d0b8d187d0bdd0b020d0bed181d0bed0b1d0b031223020060355040b0c19d0a4d196d0b7d0b8d187d0bdd0b020d0bed181d0bed0b1d0b031223020060355040c0c19d0a4d196d0b7d0b8d187d0bdd0b020d0bed181d0bed0b1d0b0312f302d06035504030c26d09cd0bed0bbd0bed0b4d188d0b8d0b920d094d0b8d18020d094d0b8d180d0bed0b2d0b8d1873119301706035504040c10d09cd0bed0bbd0bed0b4d188d0b8d0b9311e301c060355042a0c15d094d0b8d18020d094d0b8d180d0bed0b2d0b8d187310d300b06035504050c0431323539310b30090603550406130255413113301106035504070c0ad09ed0b4d0b5d181d0b03117301506035504080c0ed09ed0b4d0b5d181d18cd0bad0b03081f23081c9060b2a862402010101010301013081b9307530070202010102010c020100042110bee3db6aea9e1f86578c45c12594ff942394a7d738f9187e6515017294f4ce01022100800000000000000000000000000000006759213af182e987d3e17714907d470d0421b60fd2d8dce8a93423c6101bca91c47a007e6c300b26cd556c9b0e7d20ef292a000440a9d6eb45f13c708280c4967b231f5eadf658eba4c037291d38d96bf025ca4e17f8e9720dc615b43a28975f0bc1dea36438b564ea2c179fd0123e6db8fac5790403240004215869fc50fc2b8e07bc779940ba002d79e08fba55b3560679580fb2a7cab3f95f00a38202fa308202f630290603551d0e042204204d0fb29c86aa18eea3a89eef34b84ab2bf8f3f928010767dd468bddaf7441527302b0603551d230424302280205b63d88375d92018cdb4b10eb9b6a5c69a59fd4327c671e3c1f53aeab02d6ade302f0603551d1004283026a011180f32303134303830383231303030305aa111180f32303135303830383231303030305a300e0603551d0f0101ff0404030206c030190603551d200101ff040f300d300b06092a8624020101010202300c0603551d130101ff04023000301e06082b060105050701030101ff040f300d300b06092a86240201010102013081810603551d11047a3078a035060c2b0601040181974601010402a0250c23d0b2d183d0bb2e20d0a1d0b5d180d182d0b8d184d196d0bad0b0d182d0bdd0b02c2033a01f060c2b0601040181974601010401a00f0c0d2b333830303831323334353637820c6961736e61702e6c6f63616c8110666f726d61743132406d6574612e756130410603551d1f043a30383036a034a0328630687474703a2f2f63612e6969742e636f6d2e75612f646f776e6c6f61642f63726c732f434131332d46756c6c2e63726c30420603551d2e043b30393037a035a0338631687474703a2f2f63612e6969742e636f6d2e75612f646f776e6c6f61642f63726c732f434131332d44656c74612e63726c30818106082b0601050507010104753073302f06082b060105050730018623687474703a2f2f63612e6969742e636f6d2e75612f73657276696365732f6f6373702f304006082b060105050730028634687474703a2f2f63612e6969742e636f6d2e75612f646f776e6c6f61642f6365727469666963617465732f63616969742e703762303e06082b0601050507010b04323030302e06082b060105050730038622687474703a2f2f63612e6969742e636f6d2e75612f73657276696365732f7473702f30430603551d09043c303a301a060c2a8624020101010b01040201310a13083939383736353430301c060c2a8624020101010b01040101310c130a39393837363534333231300d060b2a862402010101010301010343000440c61a79035d4ef320eb20a1be8c19e7bc8ecfdef485f00180a3262cb2e9b66206bc1ac6b4bda3b092360149d34316e9aaaac7bb95e9dc39ac4373de0035c5a942, 0, 3);

-- --------------------------------------------------------

--
-- Структура таблицы `cab_user_external`
--

CREATE TABLE IF NOT EXISTS `cab_user_external` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `type_of_user` tinyint(3) unsigned NOT NULL COMMENT 'Тип користувача (0-фіз.особа, 1- ФОП, 2-юр.особа)',
  `email` varchar(45) NOT NULL COMMENT 'Електронна поштова скринька',
  `phone` varchar(12) NOT NULL COMMENT 'Мобільний телефон',
  `cab_state` enum('не активований','активований','блокований') NOT NULL COMMENT 'Стан кабінету',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `phone_UNIQUE` (`phone`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Каталог зовнішніх користувачів порталу»' AUTO_INCREMENT=5 ;

--
-- Дамп данных таблицы `cab_user_external`
--

INSERT INTO `cab_user_external` (`id`, `type_of_user`, `email`, `phone`, `cab_state`) VALUES
(1, 0, 'format12@meta.ua', '380671234567', 'активований'),
(3, 0, 'email@email.em', '0639876543', 'не активований');

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

--
-- Дамп данных таблицы `cab_user_gen_str`
--

INSERT INTO `cab_user_gen_str` (`sauth`, `itime`) VALUES
('-faofJuT5{4x1Zd21-fko9THxxUEoi+mn+DtGY]o', 1411415477);

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
  `type` tinyint(3) unsigned NOT NULL COMMENT 'Тип ЕЦП/шифрування',
  `int_user_id` smallint(5) unsigned NOT NULL COMMENT 'ID внутрішнього користувача',
  PRIMARY KEY (`id`),
  KEY `int_user_certs_idx` (`int_user_id`)
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
-- Структура таблицы `ff_default`
--

CREATE TABLE IF NOT EXISTS `ff_default` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `registry` int(11) NOT NULL COMMENT 'Ссылка на регистрацию(таблица которой принадлижит запись)',
  `storage` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_REGISTRY_idx` (`registry`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Корневая родительская форма для ' AUTO_INCREMENT=2 ;

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
  `order` int(10) NOT NULL DEFAULT '0',
  `protected` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`),
  KEY `id_idx` (`formid`),
  KEY `FK_TYPE_idx` (`type`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Список полей подключенных в своб' AUTO_INCREMENT=4 ;

-- --------------------------------------------------------

--
-- Структура таблицы `ff_langaliace`
--

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
-- Структура таблицы `ff_registry`
--

CREATE TABLE IF NOT EXISTS `ff_registry` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent` int(11) DEFAULT NULL COMMENT 'ссылка на родителя',
  `tablename` varchar(45) NOT NULL COMMENT 'Имя таблицы в которая используется для хранения данных свободной формы',
  `description` tinytext COMMENT 'описание',
  `protected` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Блокировка/ системная таблица',
  `attaching` bit(1) NOT NULL DEFAULT b'0' COMMENT 'равен 1 если таблица создана не методами свободных форм',
  `copying` bit(1) NOT NULL DEFAULT b'0' COMMENT 'При 1 потомки копируют свои значения в эту таблицу',
  `view` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `table_UNIQUE` (`tablename`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Список зарегистрированных свобо' AUTO_INCREMENT=10 ;

--
-- Дамп данных таблицы `ff_registry`
--

INSERT INTO `ff_registry` (`id`, `parent`, `tablename`, `description`, `protected`, `attaching`, `copying`, `view`) VALUES
(1, NULL, 'default', 'Родительская таблица для всех таблиц', b'1', b'0', b'1', NULL);

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

CREATE TABLE IF NOT EXISTS `ff_registry_h` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` int(11) NOT NULL,
  `parent` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_parent_idx` (`parent`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Иерархия(вспомогательная таблиц' AUTO_INCREMENT=16 ;

-- --------------------------------------------------------

--
-- Структура таблицы `ff_storage`
--

CREATE TABLE IF NOT EXISTS `ff_storage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT 'Имя хранилища',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Хранилище свободной формы' AUTO_INCREMENT=2 ;

-- --------------------------------------------------------

--
-- Структура таблицы `ff_types`
--

CREATE TABLE IF NOT EXISTS `ff_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `typename` varchar(255) NOT NULL COMMENT 'Имя типа отображаемого в свободной форме',
  `systemtype` varchar(255) NOT NULL COMMENT 'Имя типа используемого для генерации таблиц',
  `view` varchar(255) DEFAULT NULL COMMENT 'Путь к визуальному представлению типа',
  `descripton` tinytext COMMENT 'Описание',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Список зарегистрированных типов' AUTO_INCREMENT=6 ;

--
-- Дамп данных таблицы `ff_types`
--

INSERT INTO `ff_types` (`id`, `typename`, `systemtype`, `view`, `descripton`) VALUES
(1, 'Строка', 'VARCHAR(255)', NULL, 'Строка длиной 255 символов'),
(2, 'Число', 'INT(11)', NULL, 'Целое число'),
(3, 'Дата', 'DATE', NULL, 'Дата'),
(4, 'Текст', 'TEXT', NULL, 'Текст'),
(5, 'Большое число', 'BIGINT(20)', NULL, 'Большое целое число');

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
  KEY `fk_locations` (`locations_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Відомості про центри та субєкти»' AUTO_INCREMENT=7 ;

--
-- Дамп данных таблицы `gen_authorities`
--

INSERT INTO `gen_authorities` (`id`, `is_cnap`, `type`, `name`, `locations_id`, `index`, `street`, `building`, `office`, `working_time`, `phone`, `fax`, `email`, `web`, `transport`, `gpscoordinates`, `photo`) VALUES
(1, 'ЦНАП', 'обласний', 'Центр надання адміністративних послуг Одеської міської ради ', 1, '65026', 'вул. Преображенська', '21', '', '<p>Понеділок, середа - з 09:00 до 18:00</p>\r\n\r\n<p>Вівторок, четвер - з 09:00 до 20:00</p>\r\n\r\n<p>П&#39;ятниця - з 09:00 до 16:45</p>\r\n\r\n<p>Субота - з 09:00 до 16:00 (без перерви)</p>\r\n', '720-70-21', '720-70-21', 'admin.center3@omr.odessa.ua', 'http://www.odessa.ua/ru/essential/5577/', '121 маршрутне таксі', '46.485169, 30.732369', ''),
(2, 'СНАП', 'обласний', 'Департамент  освіти і науки Одеської обласної державної адміністрації', 1, '65107', 'вул. Канатна', '83', NULL, '9.00-18.00', '776-20-56, 722-52-54', NULL, 'osvita@osvita.od.ua', 'http://osvita.odessa.gov.ua/', NULL, '46.465661, 30.746671', NULL),
(3, 'СНАП', 'обласний', 'Департамент розвитку інфраструктури та житлово-комунального господарства Одеської обласної державної адміністрації', 1, '65107', 'вул. Канатна', '83', '', '<p>Понеділок &mdash; четвер: 9.00-18.00</p>\r\n\r\n<p>П`ятниця: 9.00-16.45</p>\r\n', '32-87-01', '', 'oblgkh@odessa.gov.ua', 'http://oda.odessa.gov.ua/', '', '', ''),
(4, 'СНАП', 'міський', 'Управління  архітектури та містобудування  Одеської міської  ради', 1, '65026', 'вул. Гоголя', '10', '', '<p>Понеділок &ndash; четвер:</p>\r\n\r\n<p>з 9.00 до 18.00</p>\r\n\r\n<p>п&rsquo;ятниця:</p>\r\n\r\n<p>з&nbsp; 9.00 до 16.45</p>\r\n', '723-07-35', '729-74-29 ', 'mailto:uag_odessa@mail.ru', 'http://www.odessa.ua/departments/259', '', '', ''),
(5, 'СНАП', 'обласний', 'Департамент зовнішньоекономічної діяльності та європейської інтеграції', 1, '65032', 'просп. Шевченка ', '4', '', '<p>Режим роботи:</p>\r\n\r\n<p>Понеділок, середа - з 09:00 до 18:00</p>\r\n\r\n<p>Вівторок, четвер - з 09:00 до 20:00</p>\r\n\r\n<p>П&#39;ятниця - з 09:00 до 16:45</p>\r\n\r\n<p>Субота - з 09:00 до 16:00</p>\r\n\r\n<p>Без перерви</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>Прийом та видача документів:</p>\r\n\r\n<p>Понеділок, вівторок, середа, четвер, п&#39;ятниця - з 09:00 до 16:00</p>\r\n\r\n<p>Без перерви</p>\r\n\r\n<p>&nbsp;</p>\r\n', 'тел/факс: 720-70-21 ', '', '', '', '', '', ''),
(6, 'СНАП', 'обласний', 'Управління культури і туризму, національностей та релігії', 1, '65017', 'Канатна', '83', '', '<p>Понеділок четвер: 9.00-18.00; П`ятниця: 9.00-16.45</p>\r\n', '(048) 722-04-15', '', '', 'http://culture.odessa.gov.ua/', '', '', '');

-- --------------------------------------------------------

--
-- Структура таблицы `gen_bid_current_status`
--

CREATE TABLE IF NOT EXISTS `gen_bid_current_status` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bid_id` varchar(11) NOT NULL,
  `status_id` tinyint(4) unsigned NOT NULL COMMENT 'ID статуса обробки',
  `date_of_change` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Час зміни стутусу',
  PRIMARY KEY (`id`),
  UNIQUE KEY `bid_id_UNIQUE` (`bid_id`),
  KEY `curr_stat` (`status_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Поточний статус обробки заявки (звонішній) еталон для bid_id' AUTO_INCREMENT=3 ;

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Звязок категорій з класами»' AUTO_INCREMENT=25 ;

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
(4, 11, 2),
(19, 12, 2),
(14, 14, 2),
(18, 15, 2),
(21, 22, 1),
(22, 23, 1),
(23, 24, 1),
(24, 25, 2);

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
-- Структура таблицы `gen_locations`
--

CREATE TABLE IF NOT EXISTS `gen_locations` (
  `id` smallint(3) NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `type` enum('місто','смт.','село','селище') NOT NULL COMMENT 'Тип населеного пункту',
  `name` varchar(50) NOT NULL COMMENT 'Назва населеного пункту',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Відомості про населені пункти»' AUTO_INCREMENT=3 ;

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Пункти меню»' AUTO_INCREMENT=12 ;

--
-- Дамп данных таблицы `gen_menu_items`
--

INSERT INTO `gen_menu_items` (`id`, `content`, `paderntid`, `url`, `ref`, `visability`) VALUES
(1, 'Послуги', 0, 'qw', 0, 1),
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
(2, '2014-08-26', '<p>Електронний цифровий підпис тепер можна замовити через пошту</p>\r\n', '<p>Починаючи з листопада &laquo;Укрпошта&raquo; запровадила пілотний проект &laquo;Замовлення електронного цифрового підпису&raquo;.</p>\r\n', '<p>Починаючи з листопада &laquo;Укрпошта&raquo; запровадила пілотний проект &laquo;Замовлення електронного цифрового підпису&raquo;. &laquo;Проект спрямований на спрощення доступу населення до безкоштовних послуг електронного цифрового підпису від Акредитованого центру сертифікації ключів Інформаційно-довідкового департаменту Міністерства доходів&raquo;, - наголошується в повідомленні Держпідприємства. Наразі пілотний проект впроваджений тільки в 70 відділеннях Донецької, Львівської та Київської областей. У цих відділеннях пошти підприємець-фізособа має можливість подати проект документів для отримання послуги електронного цифрового підпису, а співробітники &laquo;Укрпошти&raquo; передадуть їх безпосередньо до підрозділу Міндоходов, повідомив &laquo;Інтерфакс&raquo;. Раніше повідомлялося, що з 1 листопада &laquo;Укрпошта&raquo; приступила до надання 10 послуг з державної реєстрації бізнесу, нерухомості і актів цивільного стану. Такі послуги надаватимуть в 13,263 тис. відділеннях поштового зв&#39;язку по всій країні.</p>\r\n', '/iasnap/ckeditor/kcfinder/upload/images/sign%281%29.jpg\r\n'),
(3, '2014-09-18', 'Онлайн-игра Particle Clicker - почувствуйте себя исследователем элементарных частиц!', 'В ходе прошедшего на днях в ЦЕРНе студенческого мероприятия CERN Summer Student Webfest группа студентов-энтузиастов написала с нуля простую, но симпатичную и затягивающую онлайн-игру Particle Clicker.', 'В ходе прошедшего на днях в ЦЕРНе студенческого мероприятия CERN Summer Student Webfest группа студентов-энтузиастов написала с нуля простую, но симпатичную и затягивающую онлайн-игру Particle Clicker. Игра позволяет погрузиться в мир исследователя элементарных частиц. Она в ненавязчивой форме дает вам возможность почувствовать себя пусть не ученым, но хотя бы менеджером физического эксперимента.\r\n\r\nКликните по игровому полю — и детектор начнет набирать статистику столкновений элементарных частиц. Накопив некоторый объем данных, вы можете проанализировать его. При этом вы открываете некоторое свойство частиц, а у вашего проекта повышается репутация. От репутации зависит финансирование проекта, оно позволяет вам нанимать для работы студентов, постдоков и даже нобелевских лауреатов. Ваша коллаборация растет, и каждый новый человек в команде повышает скорость набора данных — а значит, и темп новых открытий и исследований элементарных частиц. Вы также можете потратить накопленный бюджет на модернизацию детектора или на мероприятия по популяризации своих открытий — всё это тоже сказывается на эффективности работы.', 'http://particle-clicker.web.cern.ch/particle-clicker'),
(4, '2014-09-19', '<p>Близкие пульсары B0950+08 и В1919+21</p>\r\n', '<p>Дальний рассеивающий слой находится, скорее всего, на внешней границе Местного пузыря (область разреженного газа внутри галактического рукава) на расстоянии 26&ndash;170 парсек, а ближний слой (4.4&ndash;16.4 парсек) находится на ионизированной поверхности молекулярного облака.</p>\r\n', '<p>Наземно-космический интерферометр РадиоАстрон в одном из первых экспериментов, 25 января 2012 года, зафиксировал интерференционный отклик от индивидуальных радиоимпульсов пульсара B0950+08 в диапазоне 92 см с максимального удаления космического радиотелескопа на 300,000 км. При этом проекция базы интерферометра в направлении на исследуемый объект составила 220,000 км, что обеспечило рекордное для метрового диапазона радиоволн угловое разрешение в одну тысячную секунды дуги. Наземное плечо интерферометра образовывали крупнейшие радиотелескопы в Аресибо (США), Вестерборке (Нидерланды) и Эффельсберге (Германия). В результате обработки данных и анализа результатов этой обработки оригинальным методом построения структурных функций получена информация о распределении межзвездной плазмы на луче зрения, которая рассеивает сигнал и вызывает его мерцания. Флуктуации сигнала имеют вид модуляции на уровне около 40%. Было показано, что к такой модуляции могла привести конфигурация плазмы на луче зрения в виде двух рассеивающих слоев и &ldquo;космической призмы&rdquo; &mdash; достаточно резкого градиента в распределении плазмы, отклоняющего радиоизлучение на углы 1.1-4.4 угловых миллисекунд. Дальний рассеивающий слой находится, скорее всего, на внешней границе Местного пузыря (область разреженного газа внутри галактического рукава) на расстоянии 26&ndash;170 парсек, а ближний слой (4.4&ndash;16.4 парсек) находится на ионизированной поверхности молекулярного облака. Спектр турбулентных флуктуаций плотности в обоих слоях следует степенному закону с показателями &gamma;1 = &gamma;2 = 3.00 &plusmn; 0.08, что отличается от колмогоровского спектра с &gamma; = 11/3. Эти результаты нельзя было бы получить при наблюдениях с поверхности Земли, так как зона Френеля при рефракции излучения пульсара превышает диаметр Земли. Результаты этого исследования опубликованы в международном научном журнале Astrophysical Journal (T.V. Smirnova, V.I. Shishov, M.V. Popov, C.R. Gwinn et al., 2014, ApJ, 786, 115): http://dx.doi.org/10.1088/0004-637X/786/2/115. Аналогичные результаты были недавно получены и для другого близкого пульсара В1919+21. Наблюдаемые параметры рассеяния радиоизлучения от этого пульсара также требуют введения двух эффективных экранов, расположенных на расстояниях 300 и 0.7 парсек от наблюдателя. Вновь получены указания на наличие &ldquo;космической призмы&rdquo;, расположенной на расстоянии 1.7 парсек и дающей рефракционное отклонение на угол 110 угловых миллисекунд. Для этого пульсара был измерен размер диска рассеяния около 1.5 угловых миллисекунд. Субструктура диска мерцаний от пульсара B0329+54 Высокое угловое разрешение наземно-космического интерферометра РадиоАстрон обеспечило возможность измерить размер диска рассеяния и оценить положение в пространстве эффективного рассеивающего экрана для пульсара B0329+54 на частоте 324 МГц. Наблюдения проводились в два этапа: в ноябре 2012 года и январе 2014 года. Наблюдения были поддержаны 100-м радиотелескопом обсерватории Грин Бэнк (США), системой апертурного синтеза в Вестерборке (WSRT, Нидерланды) и российским 64-м радиотелескопом в Калязине. Наземно-космические проекции базы интерферометра покрыли интервал от 60,000 до 235,000 километров во время сессии в ноябре 2012 года и от 15,000 до 120,000 километров в январе 2014 года. Измеренный сигнал имеет значительную амплитуду даже на самых длинных проекциях с величиной около 0.05 % (20&sigma;). Отклик интерферометра на самых длинных наземно-космических базах не содержит центрального максимума и состоит из множества изолированных неразрешенных пиков. Общее распределение этих пиков по задержке сигнала следует распределению Лоренца и соответствует размытию по времени около 7.5 мс. Тонкая структура по задержке согласуется с моделью амплитудно-модулированного шума, указывая на случайный характер интерференции лучей, рассеянных на неоднородностях межзвездной плазмы. На малых наземно-космических базах амплитуда центрального пика сигнала, измеренного интерферометром, постепенно уменьшается с увеличением проекции базы, обеспечивая возможность прямого измерения углового размера диска рассеяния, который оказался равным 4.6 миллисекунды дуги. Путем сравнения временного и углового уширения мы оценили расстояние до эффективного рассеивающего экрана. Он оказался расположен почти посередине между Землей и пульсаром. Рисунок 1 демонстрирует эволюцию структуры измеренного сигнала по мере увеличения базы наземно-космического интерферометра: на малых базах присутствует центральный максимум и протяженная по задержке составляющая, центральный пик уменьшается по амплитуде с увеличением базы и на самых длинных наземно-космических базах остается только протяженная составляющая. Эти результаты были представлены недавно на ассамблее COSPAR-2014 в Москве.</p>\r\n', '/iasnap/ckeditor/kcfinder/upload/images/sign.jpg\r\n');

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
(1, '2014-08-18', 'Інструкція з інсталяції', 'Тест Тест', '', 'http://www.google.com.ua/', 5),
(2, '2014-08-26', 'йцу', '<p>qwd w</p>\r\n', '<p><img alt="" src="http://upload.wikimedia.org/wikipedia/uk/6/63/%D0%95%D0%BC%D0%B1%D0%BB%D0%B5%D0%BC%D0%B0_%D0%A4%D0%9A_%D0%A7%D0%BE%D1%80%D0%BD%D0%BE%D0%BC%D0%BE%D1%80%D0%B5%D1%86%D1%8C_%D0%9E%D0%B4%D0%B5%D1%81%D0%B0.gif" style="height:545px; width:450px" /></p>\r\n', 'http://ya.ru', 9),
(3, '2014-08-26', 'qw', 'qw', '', 'http://yahoo.com', 9);

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Відомості про нормативно-правові акти»' AUTO_INCREMENT=3 ;

--
-- Дамп данных таблицы `gen_regulations`
--

INSERT INTO `gen_regulations` (`id`, `type`, `name`, `hyperlink`) VALUES
(1, 'Закони України', 'Закон України від 06.09.2012 № 5203-VI "Про адміністративні послуги"', 'http://zakon.rada.gov.ua/laws/show/5203-17'),
(2, 'Акти Кабінету Міністрів України', 'Постанова КМУ від 1 серпня 2013 р. № 588 "Про затвердження Примірного регламенту центру надання адміністративних послуг"', 'http://zakon.rada.gov.ua/laws/show/588-2013-%D0%BF');

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Звязок послуг з категоріями та класами»' AUTO_INCREMENT=7 ;

--
-- Дамп данных таблицы `gen_serv_cat_class`
--

INSERT INTO `gen_serv_cat_class` (`id`, `service_id`, `cat_class_id`) VALUES
(1, 4, 14),
(2, 5, 14),
(3, 6, 14),
(4, 7, 14),
(5, 8, 14),
(6, 9, 11);

-- --------------------------------------------------------

--
-- Структура таблицы `gen_serv_categories`
--

CREATE TABLE IF NOT EXISTS `gen_serv_categories` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `name` varchar(60) NOT NULL COMMENT 'Назва категорії',
  `visability` enum('так','ні') NOT NULL COMMENT 'Видимість (0/1)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Каталог категорій послуг»' AUTO_INCREMENT=26 ;

--
-- Дамп данных таблицы `gen_serv_categories`
--

INSERT INTO `gen_serv_categories` (`id`, `name`, `visability`) VALUES
(2, 'Промисловість', 'так'),
(3, 'Комунікації та звязок', 'так'),
(4, 'Сільське господарство', 'так'),
(6, 'Реклама', 'так'),
(9, 'Будівництво та архітектура', 'так'),
(10, 'Релігія', 'так'),
(11, 'Освіта', 'так'),
(12, 'Землеустрій', 'так'),
(13, 'Культура та спорт', 'так'),
(14, 'Економіка та інвестиції', 'так'),
(15, 'Реєстрація бізнеса', 'так'),
(16, 'Комунікації та зв''язок', 'так'),
(22, 'Сім''я', 'так'),
(23, 'Соціальне забезпечення', 'так'),
(24, 'Охорона здоров''я', 'так'),
(25, 'Екологія', 'так');

-- --------------------------------------------------------

--
-- Структура таблицы `gen_serv_classes`
--

CREATE TABLE IF NOT EXISTS `gen_serv_classes` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `item_name` varchar(45) NOT NULL COMMENT 'Назва класу',
  `visability` enum('так','ні') NOT NULL COMMENT 'Видимість (0/1)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Каталог класів послуг»' AUTO_INCREMENT=4 ;

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
  `name` varchar(255) NOT NULL COMMENT 'Назва послуги',
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  KEY `id_idx` (`subjnap_id`),
  KEY `id2_idx` (`subjwork_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Таблиця «Відомості про послуги»' AUTO_INCREMENT=10 ;

--
-- Дамп данных таблицы `gen_services`
--

INSERT INTO `gen_services` (`id`, `name`, `subjnap_id`, `subjwork_id`, `regulations`, `reason`, `submission_proc`, `docums`, `is_payed`, `payed_regulations`, `payed_rate`, `bank_info`, `deadline`, `denail_grounds`, `result`, `answer`, `is_online`) VALUES
(1, 'Ліцензування діяльності з надання освітніх послуг у сфері загальної середньої освіти (юридичні особи)', 1, 3, '<p>qweq</p>\r\n', '<p>---</p>\r\n', '<p>через Центр надання адміністративних послуг</p>\r\n', '<p>qwe</p>\r\n', 1, '<p>- Відшкодування витрат, пов&rsquo;язаних з проведенням ліцензійної експертизи &ndash; пункт 24 постанови Кабінету Міністрів України від 08.08.2007 № 1019 &laquo;Про ліцензування діяльності з надання освітніх послуг&raquo;. - Плата за видачу, переоформлення ліцензії, видачу копії та дубліката ліцензії &ndash; пункт 2 постанови Кабінету Міністрів України від 29.08.2003 № 1380 &laquo;Про ліцензування освітніх послуг&raquo;</p>\r\n', '<p>Відшкодування витрат, пов&rsquo;язаних з проведенням ліцензійної експертизи становить &ndash; 24 неоподаткованих мінімумів громадян (408 грн) Плата за видачу ліцензії становить &ndash; 15 неоподаткованих мінімумів доходів громадян (255 грн) Плата за переоформлення ліцензії, видачу копії та дубліката ліцензії &ndash; 5 неоподаткованих мінімумів доходів громадян (85 грн)</p>\r\n', '<p>Реквізити для Відшкодування витрат, пов&rsquo;язаних з проведенням ліцензійної експертизи,- р/р 31256277221575 МФО 828011 код 23207206, одержувач Навчально-методичний центр професійно-технічної освіти в Одеській області, банк одержувача ГУДКСУ в Одеській області.</p>\r\n\r\n<p>Реквізити для внесення плати за видачу ліцензії, переоформлення ліцензії, видачу копії та дубліката ліцензії &ndash; р/р 31413511700001 код 37607526 МФО 828011одержувач ГУДКСУ в Одеській області, код бюджетної класифікації 22010200</p>\r\n', '<p>Три місяці</p>\r\n', '', '<p>Ліцензія або лист з обґрунтуванням причин відмови</p>\r\n', '<p>через Центр надання адміністративних послуг</p>\r\n', 'так'),
(2, 'Ліцензія  на право провадження господарської діяльності з виробництва та транспортування теплової енергії магістральними та місцевими (розподільчими) тепловими мережами', 1, 3, '<p>Закон України &ldquo; Про ліцензування певних видів господарської діяльності&rdquo; від 1 червня 2000р. №1775-ІІІ</p>\r\n', '<p>&lt;&gt;</p>\r\n', '<p>через Центр надання адміністративних послуг</p>\r\n', '<p>1.Заява, заповнена відповідно до ст..10 Закону України &laquo;Про ліцензування певних видів господарської діяльності&raquo;.</p>\r\n\r\n<p>2. Засвідчена в астановленому поррядку копія документа, що підтверджує право власності суб&rsquo;єкта господарювання або оренди ним виробничих об&rsquo;єктів, де провадитиметься відповідний вид господарської діяльності;</p>\r\n\r\n<p>3. Відомості за підписом заявника &ndash; суб&rsquo;єкта господарювання (за формою, встановленою ліцензійними умовами) про:</p>\r\n\r\n<p>3.1 Наявність власних або орендованих виробничих об&rsquo;єктів, де провадитиметься відповідний вид господарської діяльності;</p>\r\n\r\n<p>3.2 Наявність та стан технологічного обладнання і технічної бази для його обслуговування;</p>\r\n\r\n<p>3.3 Освітній та кваліфікаційний рівень працівників, необхідний для провадження відповідного виду господарської діяльності;</p>\r\n\r\n<p>3.4&nbsp; Наявність матеріально-технічної бази, необхідної для провадження відповідного виду господарської діяльності;</p>\r\n\r\n<p>3.5 Технічний стан трубопроводів та споруд на них (на підставі експлуатаційної документації на такі об&rsquo;єкти);</p>\r\n\r\n<p>3.6 Наявність проектної і виконавчої документації на трубопроводи та споруди на них, які використовуються для провадження відповідного виду господарської діяльності;</p>\r\n\r\n<p>3.7 Перелік трубопроводів, що перебувають у користуванні заявника &ndash; суб&rsquo;єкта господарювання, їх технічна характеристика та річні обсяги транспортування теплової енергії;</p>\r\n\r\n<p>3.8 Перелік приладів обліку із зазначенням місць їх встановлення;</p>\r\n\r\n<p>3.9&nbsp; Схема трубопроводів, нанесена на географічну карту місцевості;</p>\r\n\r\n<p>3.10&nbsp; Копія затвердженої міс цевим органом виконавчої влади схеми теплопостачання;</p>\r\n\r\n<p>3.11 Засвідчені в установленому порядку копії актів і схем розмежування&nbsp; ділянок обслуговування між суб&rsquo;єктами господарювання, трубопроводи яких з&rsquo;єднані між собою;</p>\r\n\r\n<p>3.12 Баланс підприємства на останню звітню дату за підписом керівника суб&rsquo;єкта&nbsp; господарювання, скріпленим печаткою;</p>\r\n\r\n<p>3.13 Засвідчені в установленому порядку копії документав, що підтверджують освітний і кваліфікаційний рівень працівників, необхідний для провадження відповідного виду господарської діяльності.</p>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 29 листопада 2000р. №1755 &ldquo;Про термін дії ліцензії на провадження певних видів господарської діяльності, розміри і порядок зарахування плати за її видачу&rdquo;</p>\r\n', '<p>Одна мінімальна заробітна плата виходячи з її розміру на дату прийняття органам ліцензування рішення про видачу ліцензії.</p>\r\n\r\n<p>Плата за видачу ліцензії вноситься заявником після отримання повідомлення в письмовій формі про прийняття рішення про видачу ліцензії</p>\r\n', '<p>Одержувач: Г<strong>УДКСУ в Одеській області</strong></p>\r\n\r\n<p>Банк одержувача: Г<strong>УДКСУ в Одеській області</strong></p>\r\n\r\n<p>ОКПО (код):&nbsp;<strong>37607526</strong></p>\r\n\r\n<p>Розрахунковий рахунок:&nbsp;<strong>31413511700001</strong></p>\r\n\r\n<p>МФО (код банку):&nbsp;<strong>828011</strong></p>\r\n\r\n<p>Код платежу:&nbsp;<strong>22010200</strong></p>\r\n\r\n<p>Призначення платежу:&nbsp;<strong>плата за видачу ліцензій</strong></p>\r\n', '<p>Орган ліцензування приймає рішення про видачу ліцензії, про залишення заяви без розгляду або відмову у видачі ліцензії приймається у строк не пізніше ніж 10 робочих днів з дати надходження заяви про видачу ліцензії та документів, що додаються до заяви.</p>\r\n\r\n<p>Повідомлення про прийняття рішення про видачу ліцензії, про залишення заяви без розгляду або про відмову у її видачі надсилається заявникові в письмовій формі протягом трьох робочих днів з дати прийняття відповідного рішення.</p>\r\n\r\n<p>Орган ліцензування оформляє ліцензію не пізніше ніж за 3 робочих днів з дня надходження документа , що підтверджує внесення плати за видачу ліцензії.</p>\r\n\r\n<p>Якщо заявник протягом тридцяти календарних днів з дня направлення йому повідомлення про прийняте рішення про видачу ліцензії не подав документа, що підтверджує внесення плати за видачу ліцензії, або не звернувся до суб&#39;єкта надання адміністративної послуги для отримання оформленої ліцензії, орган ліцензування, який оформив ліцензію, має право скасувати рішення про видачу ліцензії або прийняти рішення про визнання такої ліцензії недійсної</p>\r\n', '<p>Відмова у видачі ліцензії:</p>\r\n\r\n<p>Недостовірність даних у документах, поданих заявником, для отримання ліцензії;</p>\r\n\r\n<p>Невідповідність заявника згідно з поданими документами ліцензійним умовам, встановленому для виду господарської діяльності, зазначеного в заяві про видачу ліцензії.</p>\r\n\r\n<p>Залишення заяви без розгляду:</p>\r\n\r\n<p>Заява подана (підписана) особою, яка не має на це повноважень;</p>\r\n\r\n<p>Документи оформлені з порушенням вимог;</p>\r\n\r\n<p>Немає в Єдиному державному реєстрі юридичних осіб і фізичних осіб-підприємців відомостей про заявника або наявні відомості про перебування юридичної особи у стані припинення шляхом ліквідації чи про державну реєстрацію її припинення</p>\r\n', '<p>Ліцензія&nbsp; на право провадження господарської діяльності з виробництва та транспортування теплової енергії магістральними та місцевими (розподільчими) тепловими мережами або залишення заяви без розгляду</p>\r\n', '<p>через Центр надання адміністративних послуг</p>\r\n', 'так'),
(3, 'Висновок по проекту землеустрою щодо відведення земельної ділянки або технічній документації по встановленню меж земельної ділянки', 1, 1, '<p>Земельний кодекс України, ст.ст. 123, 124, 186-1;</p>\r\n\r\n<p>Закон України &laquo;Про землеустрій&raquo;, Закон України &laquo;Про внесення змін до деяких законодавчих актів України щодо вдосконалення процедури відведення земельних ділянок та зміни їх цільового призначення&raquo;.</p>\r\n', '<p>z</p>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради</p>\r\n', '<p>1.Звернення УЗР або</p>\r\n\r\n<p>землевпорядної організації;</p>\r\n\r\n<p>2.Проект землеустрою або</p>\r\n\r\n<p>технічна документація, розроблені землевпорядною організацією відповідно до Еталону (див. п.6)</p>\r\n', 0, '', '', '', '<p>10 робочих днів з дня надання проекту землеустрою на погодження до виконавчого органу</p>\r\n', '<p>Надана документація не відповідає вимогам нормативно-правових актів, зокрема Еталону (див. п.6), у тому числі:&nbsp;</p>\r\n\r\n<p>- не надано відкорегований&nbsp; топогеодезичний план у М 1:500, прийнятий геослужбою м. Одеси;</p>\r\n\r\n<p>- відсутнє погодження суміжних землекористувачів;</p>\r\n\r\n<p>- на земельній ділянці, розташовані самовільно збудовані будівлі, на які не оформлена декларація про введення в експлуатацію;</p>\r\n\r\n<p>- відсутня фотофіксація об&rsquo;єкту;</p>\r\n\r\n<p>- об&rsquo;єкт, розташований на земельній ділянці, знаходиться в неексплуатаційному стані і потребує розробки проектно - кошторисної документації;</p>\r\n\r\n<p>- проект землеустрою розроблений з відхиленнями від погоджених УАМ меж земельної ділянки;</p>\r\n\r\n<p>-&nbsp; не встановлена площа дії сервітутів;</p>\r\n\r\n<p>-&nbsp; земельна ділянка використовується не по цільовому призначенню;</p>\r\n\r\n<p>-&nbsp; на земельній ділянці розташовані об&rsquo;єкти, цільове призначення яких не визначено;</p>\r\n\r\n<p>- &nbsp;площа земельної ділянки не обґрунтована затвердженою проектною або містобудівною документацією;</p>\r\n\r\n<p>- якщо попередній висновок УАМ втратив чинність</p>\r\n', '<p>Висновок</p>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради</p>\r\n', 'ні'),
(4, 'Державна реєстрація іноземних інвестицій', 1, 5, '<ul>\r\n	<li>Частина друга статті 13 Закону України &ldquo;Про режим іноземного інвестування&rdquo;</li>\r\n	<li>Постанова Кабінету Міністрів України від 6 березня 2013 р. № 139 Про затвердження Порядку державної реєстрації (перереєстрації) іноземних інвестицій та її анулювання</li>\r\n</ul>\r\n', '<p>Здійснення іноземної інвестиції</p>\r\n', '<p>Документи подаються іноземним інвестором або уповноваженою ним в установленому порядку особою до центру надання адміністративних послуг</p>\r\n', '<ol>\r\n	<li>Інформаційне повідомлення згідно з <a href="http://zakon3.rada.gov.ua/laws/show/139-2013-%D0%BF#n68">додатком 1</a> до Порядку державної реєстрації (перереєстрації) іноземних інвестицій та її анулювання у трьох примірниках з відміткою територіального органу Міністерства доходів і зборів за місцем здійснення інвестицій про їх фактичне здійснення.</li>\r\n	<li>Документи, що підтверджують форму здійснення іноземних інвестицій (установчі документи, договори (контракти) про виробничу кооперацію, спільне виробництво та інші види спільної інвестиційної діяльності, концесійні договори тощо).</li>\r\n	<li>Документи, які підтверджують вартість іноземних інвестицій, що визначається відповідно до статті 2 <a href="http://zakon3.rada.gov.ua/laws/show/93/96-%D0%B2%D1%80" target="_blank">Закону України &ldquo;Про режим іноземного інвестування&rdquo;</a>.</li>\r\n</ol>\r\n\r\n<p><a href="/iasnap/ckeditor/kcfinder/upload/files/nf_pov_domlennya_17_05_2013.doc">Завантажити форму інформаційного повідомлення. </a></p>\r\n', 0, '', '', '', '<p>7 днів</p>\r\n', '<p>Порушення встановленого порядку реєстрації</p>\r\n', '<p>Державна реєстрація іноземної інвестиції (інформаційне повідомлення) або відмова в наданні адміністративної послуги.</p>\r\n', '<p>Адміністративна послуга вважається надана з моменту отримання її через Управління надання адміністративних послуг Одеської міської ради</p>\r\n', 'ні'),
(5, 'Перереєстрація іноземних інвестицій', 1, 5, '<p>Закон України &laquo;Про режим іноземного інвестування&raquo; Постанова Кабінету Міністрів України від 6 березня 2013 р. № 139 Про затвердження Порядку державної реєстрації (перереєстрації) іноземних інвестицій та її анулювання.</p>\r\n', '<p>---</p>\r\n', '<p>Документи подаються іноземним інвестором або уповноваженою ним в установленому порядку особою до центру надання адміністративних послуг</p>\r\n', '<p>Або:</p>\r\n\r\n<ul>\r\n	<li>письмове повідомлення про припинення іноземним інвестором своєї діяльності у зв&#39;язку з передачею (продажем) своїх інвестицій іншим суб&#39;єктам інвестиційної діяльності;</li>\r\n	<li>інформаційне повідомлення про попередню державну реєстрацію іноземних інвестицій;</li>\r\n	<li>довідку територіального органу Міністерства доходів і зборів про сплачені іноземним інвестором в Україні податки.</li>\r\n</ul>\r\n\r\n<p>Або:</p>\r\n\r\n<ul>\r\n	<li>інформаційне повідомлення згідно з додатком 1 до Порядку державної реєстрації (перереєстрації) іноземних інвестицій та її анулювання у трьох примірниках з відміткою територіального органу Міністерства доходів і зборів за місцем здійснення інвестицій про їх фактичне здійснення</li>\r\n	<li>документи, що підтверджують форму здійснення іноземних інвестицій (установчі документи, договори (контракти) про виробничу кооперацію, спільне виробництво та інші види спільної інвестиційної діяльності, концесійні договори тощо);</li>\r\n	<li>документи, які підтверджують вартість іноземних інвестицій, що визначається відповідно до статті 2 Закону України &ldquo;Про режим іноземного інвестування&rdquo;.</li>\r\n</ul>\r\n', 0, '', '', '', '<p>7 днів</p>\r\n', '<p>Порушення встановленого порядку перереєстрації</p>\r\n', '<p>Державна реєстрація іноземної інвестиції (інформаційне повідомлення) або відмова в наданні адміністративної послуги.</p>\r\n', '<p>Адміністративна послуга вважається надана з моменту отримання її через Управління надання адміністративних послуг Одеської міської ради</p>\r\n', 'ні'),
(6, 'Анулювання державної реєстрації іноземних інвестицій', 1, 5, '<p>Постанова Кабінету Міністрів України від 6 березня 2013 р. № 139 Про затвердження Порядку державної реєстрації (перереєстрації) іноземних інвестицій та її анулювання</p>\r\n', '<p>---</p>\r\n', '<p>Документи подаються іноземним інвестором або уповноваженою ним в установленому порядку особою до центру надання адміністративних послуг</p>\r\n', '<ul>\r\n	<li>письмове повідомлення про припинення іноземним інвестором своєї діяльності у зв&#39;язку з передачею (продажем) своїх інвестицій іншим суб&#39;єктам інвестиційної діяльності;</li>\r\n	<li>інформаційне повідомлення про попередню державну реєстрацію іноземних інвестицій;</li>\r\n	<li>довідку територіального органу Міністерства доходів і зборів про сплачені іноземним інвестором в Україні податки.</li>\r\n</ul>\r\n', 0, '', '', '', '<p>7 днів</p>\r\n', '<p>Порушення встановленого порядку анулювання</p>\r\n', '<p>Анулювання іноземної інвестиції або відмова в наданні адміністративної послуги.</p>\r\n', '<p>Адміністративна послуга вважається надана з моменту отримання її через Управління надання адміністративних послуг Одеської міської ради</p>\r\n', 'ні'),
(7, 'Видача дубліката інформаційного повідомлення про внесення іноземної інвестиції, у разі його втрати (знищення)', 1, 5, '<p>Постанова Кабінету Міністрів України від 6 березня 2013 р. № 139 Про затвердження Порядку державної реєстрації (перереєстрації) іноземних інвестицій та її анулювання.</p>\r\n', '<p>---</p>\r\n', '<p>Документи подаються іноземним інвестором або уповноваженою ним в установленому порядку особою до центру надання адміністративних послуг.</p>\r\n', '<p>Опубліковане в офіційних друкованих засобах масової інформації оголошення про визнання недійсним втраченого інформаційного повідомлення.</p>\r\n', 0, '', '', '', '<p>5 днів</p>\r\n', '<p>Порушення встановленого порядку видачі дублікату.</p>\r\n', '<p><strong>Видача дублікату інформаційного повідомлення або відмова в наданні адміністративної послуги.</strong></p>\r\n', '<p>Адміністративна послуга вважається надана з моменту отримання її через Управління надання адміністративних послуг Одеської міської ради.</p>\r\n', 'так'),
(8, 'Державна реєстрація договорів (контрактів) про спільну інвестиційну діяльність за участю іноземного інвестора', 1, 5, '<p>Стаття 24 Закону України &laquo;Про режим іноземного інвестування&raquo;; Постанова Кабінету Міністрів України від 30.01.1997 №112 &quot;Про затвердження Положення про порядок державної реєстрації договорів (контрактів) про спільну інвестиційну діяльність за участю іноземного інвестора&quot;; Наказ Міністерства зовнішніх економічних зв&#39;язків і торгівлі України від 20.02.1997 р. №125 України &laquo;Про заходи МЗЕЗторгу щодо забезпечення виконання Постанови КМУ від 30.01.1997 р. № 112&raquo;.</p>\r\n', '<p>---</p>\r\n', '<p>Суб&#39;єкт зовнішньоекономічної діяльності України - учасник договору (контракту), якому доручено ведення спільних справ учасників, або уповноважена ним особа подає документи до центру надання адміністративних послуг</p>\r\n', '<ol>\r\n	<li>лист-звернення про державну реєстрацію договору (контракту);</li>\r\n	<li>інформаційна картка договору (контракту) за формою, що встановлює Мінекономрозвитку;</li>\r\n	<li>договір (контракт) (оригінал і копію), засвідчені в установленому порядку;</li>\r\n	<li>засвідчені копії установчих документів суб&rsquo;єкта (суб&rsquo;єктів) зовнішньоекономічної діяльності України та свідоцтва про його державну реєстрацію як суб&rsquo;єкта підприємницької діяльності;</li>\r\n	<li>документи, що свідчать про реєстрацію (створення) іноземної юридичної особи (нерезидента) в країні її місцезнаходження (витяг із торгівельного, банківського або судового реєстру тощо). Ці документи повинні бути засвідчені відповідно до законодавства країни їх видачі, перекладенні українською мовою та легалізовані у консульській установі України, якщо міжнародними договорами, в яких бере участь Україна, не передбачено інше. Зазначені документи можуть бути засвідчені також у посольстві відповідної держави в Україні та легалізовані в МЗС;</li>\r\n	<li>ліцензію, якщо згідно із законодавством України цього вимагає діяльність, що передбачається договором (контрактом);</li>\r\n	<li>документ про оплату послуг за державну реєстрацію договору (контракту).</li>\r\n</ol>\r\n', 1, '<p>Постанова Кабінету Міністрів України від 30.01.1997 №112 &quot;Про затвердження Положення про порядок державної реєстрації договорів (контрактів) про спільну інвестиційну діяльність за участю іноземного інвестора&quot;.</p>\r\n', '<p>Шість неоподатковуваних мінімумів доходів громадян, встановлених на день реєстрації.</p>\r\n', '<p><a href="/iasnap/ckeditor/kcfinder/upload/files/nomera_rahunk_v_cajt.xls">Завантажити файл з банківськими реквізитами.</a></p>\r\n', '<p>20 днів</p>\r\n', '<p>Порушення встановленого порядку реєстрації</p>\r\n', '<p><strong>Державна реєстрація договору (контракту) про спільну інвестиційну діяльність за участю іноземного інвестора або відмова в наданні адміністративної послуги.</strong></p>\r\n', '<p>Адміністративна послуга вважається надана з моменту отримання її через Управління надання адміністративних послуг Одеської міської ради.</p>\r\n', 'так'),
(9, 'Реєстрація статутів (положень) релігійних громад та змін до них', 1, 6, '<p>Закон України &laquo;Про свободу совісті та релігійні організації&raquo;</p>\r\n', '<p>---</p>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', '<ol>\r\n	<li>Заява засновників (членів) релігійної громади на ім&rsquo;я голови обладміністрації (заяву підписують не менше 10 повнолітніх громадян. Підписи завіряються нотаріально).</li>\r\n	<li>Статут релігійної громади, прийнятий на загальних зборах віруючих громадян (прошиті, 5 примірників).</li>\r\n	<li>Документ, що підтверджує місцезнаходження релігійної громади(підпис завіряється нотаріально).</li>\r\n	<li>Протокол установчих(загальних) зборів віруючих громадян ( 2 примірника)</li>\r\n	<li>Оригінали реєстраційних документів релігійної громади (у разі реєстрації статуту релігійної громади у нової редакції) .</li>\r\n</ol>\r\n\r\n<p><a href="Завантажити зразок заяви про реєстрацію статуту релігійної громади">Завантажити зразок заяви про реєстрацію статуту релігійної громади</a>&nbsp;</p>\r\n', 0, '', '', '', '<p>Відповідно до статті 14 Закону України &laquo;Про свободу совісті та релігійні організації&raquo; обласна державна адміністрація в місячний термін розглядає заяву, статут (положення) релігійної громади, приймає відповідне рішення&nbsp; і не пізніш як у десятиденний термін письмово повідомляє про нього заявникам. У необхідних випадках облдержадміністрація може зажадати висновок місцевої державної адміністрації, виконавчого комітету сільської, селищної, міської Рад народних депутатів, а також спеціалістів. У цьому разі рушення приймається у тримісячний термін.</p>\r\n', '<p>---</p>\r\n', '<p><strong>Розпорядження голови обласної державної адміністрації; рішення про відмову в реєстраціях статуту (положення) релігійної громади із зазначенням підстав відмови.</strong></p>\r\n', '<p>Через Центр надання адміністративних послуг Одеської міської ради.</p>\r\n', 'ні');

-- --------------------------------------------------------

--
-- Структура таблицы `gen_status_description`
--

CREATE TABLE IF NOT EXISTS `gen_status_description` (
  `id` tinyint(3) unsigned NOT NULL,
  `description` varchar(150) NOT NULL COMMENT 'Текст повідомлення',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Опис статусів';

--
-- Ограничения внешнего ключа сохраненных таблиц
--

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
  ADD CONSTRAINT `ext_user_certs` FOREIGN KEY (`ext_user_id`) REFERENCES `cab_user_external` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

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
-- Ограничения внешнего ключа таблицы `cab_user_intern_certs`
--
ALTER TABLE `cab_user_intern_certs`
  ADD CONSTRAINT `int_user_certs` FOREIGN KEY (`int_user_id`) REFERENCES `cab_user_internal` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

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
-- Ограничения внешнего ключа таблицы `gen_serv_regulations`
--
ALTER TABLE `gen_serv_regulations`
  ADD CONSTRAINT `serv_reg` FOREIGN KEY (`service_id`) REFERENCES `gen_services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `gen_services`
--
ALTER TABLE `gen_services`
  ADD CONSTRAINT `id_sub` FOREIGN KEY (`subjwork_id`) REFERENCES `gen_authorities` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `id` FOREIGN KEY (`subjnap_id`) REFERENCES `gen_authorities` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
