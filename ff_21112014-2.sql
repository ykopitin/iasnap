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
-- Table `cnap_portal`.`AuthItem`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`AuthItem` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`AuthItem` (
  `name` VARCHAR(64) NOT NULL,
  `type` INT(11) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `bizrule` TEXT NULL DEFAULT NULL,
  `data` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`name`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`AuthAssignment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`AuthAssignment` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`AuthAssignment` (
  `itemname` VARCHAR(64) NOT NULL,
  `userid` VARCHAR(64) NOT NULL,
  `bizrule` TEXT NULL DEFAULT NULL,
  `data` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`itemname`, `userid`),
  CONSTRAINT `AuthAssignment_ibfk_1`
    FOREIGN KEY (`itemname`)
    REFERENCES `cnap_portal`.`AuthItem` (`name`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`AuthItemChild`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`AuthItemChild` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`AuthItemChild` (
  `parent` VARCHAR(64) NOT NULL,
  `child` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`parent`, `child`),
  CONSTRAINT `AuthItemChild_ibfk_1`
    FOREIGN KEY (`parent`)
    REFERENCES `cnap_portal`.`AuthItem` (`name`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `AuthItemChild_ibfk_2`
    FOREIGN KEY (`child`)
    REFERENCES `cnap_portal`.`AuthItem` (`name`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `child` ON `cnap_portal`.`AuthItemChild` (`child` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`YiiLog`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`YiiLog` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`YiiLog` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `level` VARCHAR(128) NULL DEFAULT NULL,
  `category` VARCHAR(128) NULL DEFAULT NULL,
  `logtime` INT(11) NULL DEFAULT NULL,
  `user_ip` VARCHAR(50) NULL DEFAULT NULL,
  `user_id` INT(10) NULL DEFAULT NULL,
  `user_fio` VARCHAR(100) NULL DEFAULT NULL,
  `request_URL` TEXT NULL DEFAULT NULL,
  `message` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 1068
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`cab_adm_menu`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`cab_adm_menu` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`cab_adm_menu` (
  `id` TINYINT(3) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `par_id` TINYINT(4) NOT NULL DEFAULT '0',
  `url` VARCHAR(45) NOT NULL DEFAULT 'admin/default',
  `ref` TINYINT(3) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 29
DEFAULT CHARACTER SET = utf8
COMMENT = 'Меню адміністративної панелі';


-- -----------------------------------------------------
-- Table `cnap_portal`.`gen_locations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`gen_locations` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`gen_locations` (
  `id` SMALLINT(3) NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `type` ENUM('місто','смт.','село','селище') NOT NULL COMMENT 'Тип населеного пункту',
  `name` VARCHAR(50) NOT NULL COMMENT 'Назва населеного пункту',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8
COMMENT = 'Таблиця «Відомості про населені пункти»';

CREATE UNIQUE INDEX `name_UNIQUE` ON `cnap_portal`.`gen_locations` (`name` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`gen_authorities`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`gen_authorities` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`gen_authorities` (
  `id` SMALLINT(3) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `is_cnap` ENUM('ЦНАП','СНАП') NOT NULL COMMENT 'Тип обєкта',
  `type` ENUM('обласний','районний','міський') NOT NULL COMMENT 'Приналежність',
  `name` VARCHAR(255) NOT NULL COMMENT 'Назва органу',
  `locations_id` SMALLINT(3) NOT NULL COMMENT 'ID населеного пункту',
  `index` VARCHAR(5) NOT NULL COMMENT 'Індекс',
  `street` VARCHAR(50) NOT NULL COMMENT 'Вулиця',
  `building` VARCHAR(10) NOT NULL COMMENT 'Будинок №',
  `office` VARCHAR(5) NULL DEFAULT NULL COMMENT 'Кабінет',
  `working_time` VARCHAR(1500) NOT NULL COMMENT 'Режим роботи',
  `phone` VARCHAR(44) NOT NULL COMMENT 'Телефони',
  `fax` VARCHAR(29) NULL DEFAULT NULL COMMENT 'Факс',
  `email` VARCHAR(45) NULL DEFAULT NULL COMMENT 'Електронна скринька',
  `web` VARCHAR(45) NULL DEFAULT NULL COMMENT 'Веб-сайт',
  `transport` VARCHAR(1000) NULL DEFAULT NULL COMMENT 'Міський транспорт',
  `gpscoordinates` VARCHAR(20) NULL DEFAULT NULL COMMENT 'GPS координати (наприклад, 46.483723, 30.729476)',
  `photo` VARCHAR(255) NULL DEFAULT NULL COMMENT 'Фотографія (посилання)',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_locations`
    FOREIGN KEY (`locations_id`)
    REFERENCES `cnap_portal`.`gen_locations` (`id`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 24
DEFAULT CHARACTER SET = utf8
COMMENT = 'Таблиця «Відомості про центри та субєкти»';

CREATE UNIQUE INDEX `name_UNIQUE` ON `cnap_portal`.`gen_authorities` (`name` ASC);

CREATE INDEX `fk_locations` ON `cnap_portal`.`gen_authorities` (`locations_id` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`cab_authorities_certs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`cab_authorities_certs` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`cab_authorities_certs` (
  `id` INT(10) UNSIGNED NOT NULL,
  `certissuer` TEXT NOT NULL COMMENT 'Власник сертифікату',
  `certserial` VARCHAR(40) NOT NULL COMMENT 'Серійний номер сертифікату',
  `certSubjDRFOCode` VARCHAR(10) NULL DEFAULT NULL COMMENT 'Код ДРФО',
  `certSubjEDRPOUCode` VARCHAR(10) NOT NULL COMMENT 'Код ЄДРПОУ',
  `certData` MEDIUMBLOB NOT NULL COMMENT 'Вміст сертифікату',
  `type` TINYINT(3) UNSIGNED NOT NULL COMMENT 'Тип 0-ЕЦП 1-шифрування',
  `authorities_id` SMALLINT(5) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `authorities_certs`
    FOREIGN KEY (`authorities_id`)
    REFERENCES `cnap_portal`.`gen_authorities` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Сертифікати користувачів (ЦНАП, СНАП, тех.підтримка)';

CREATE INDEX `authorities_certs_idx` ON `cnap_portal`.`cab_authorities_certs` (`authorities_id` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`gen_bid_current_status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`gen_bid_current_status` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`gen_bid_current_status` (
  `id` INT(10) UNSIGNED NOT NULL,
  `bid_id` VARCHAR(11) NOT NULL,
  `status_id` TINYINT(4) UNSIGNED NOT NULL COMMENT 'ID статуса обробки',
  `date_of_change` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Час зміни стутусу',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Поточний статус обробки заявки (звонішній) еталон для bid_id';

CREATE UNIQUE INDEX `bid_id_UNIQUE` ON `cnap_portal`.`gen_bid_current_status` (`bid_id` ASC);

CREATE INDEX `curr_stat` ON `cnap_portal`.`gen_bid_current_status` (`status_id` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`cab_bids_rkk`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`cab_bids_rkk` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`cab_bids_rkk` (
  `id` INT(11) UNSIGNED NOT NULL COMMENT '№ з/п',
  `date` DATE NULL DEFAULT NULL COMMENT 'дата надходження',
  `bid_id` VARCHAR(11) NOT NULL COMMENT 'Трек номер',
  `subj_category` ENUM('фізична особа','фізична особа - підприємець','юридична особа') NOT NULL COMMENT 'Категорія суб\'єкта звернення',
  `organization` VARCHAR(255) NOT NULL COMMENT 'Організація',
  `edrpouCode` VARCHAR(10) NULL DEFAULT NULL COMMENT 'Код ЄДРПОУ',
  `surname` VARCHAR(20) NOT NULL COMMENT 'Прізвище',
  `name` VARCHAR(20) NOT NULL COMMENT 'ім\'я',
  `patronymic` VARCHAR(20) NOT NULL COMMENT 'По-батькові',
  `drfoCode` VARCHAR(10) NULL DEFAULT NULL COMMENT 'Код ДРФО',
  `address` VARCHAR(255) NOT NULL COMMENT 'Адреса надсилання відповіді',
  `phone1` VARCHAR(15) NOT NULL COMMENT 'Контактний телефон 1',
  `phone2` VARCHAR(15) NULL DEFAULT NULL COMMENT 'Контактний телефон 2',
  `e-mail` VARCHAR(45) NULL DEFAULT NULL COMMENT 'Електронна пошта',
  `answer_method` TINYINT(3) UNSIGNED NOT NULL COMMENT 'Варіант отримання відповіді 0-поштою, 1-особисто, 2- через портал',
  `out_number` VARCHAR(20) NULL DEFAULT NULL COMMENT 'Вих. №',
  `out_date` DATE NULL DEFAULT NULL COMMENT 'Дата листа',
  `method_of_delivery` ENUM('особисто','портал','курєр','електронна пошта','пошта','факс') NOT NULL COMMENT 'метод доставки',
  `secrecy` ENUM('Відкрита','Конфіденційна') NOT NULL COMMENT 'Гриф обмеження доступу',
  `sheets` TINYINT(4) NULL DEFAULT NULL COMMENT 'Кількість аркушів',
  `services_id` SMALLINT(6) NOT NULL COMMENT 'ID послуги',
  `intern_status_id` TINYINT(3) UNSIGNED NULL DEFAULT NULL COMMENT 'Статус обробки заявки',
  `organization_id` SMALLINT(5) UNSIGNED NULL DEFAULT NULL COMMENT 'ID організації',
  `step` SMALLINT(5) UNSIGNED NULL DEFAULT NULL COMMENT 'Крок',
  `date_of_delivery` DATETIME NULL DEFAULT NULL COMMENT 'Дата вручення',
  `return_date` DATETIME NULL DEFAULT NULL COMMENT 'Дата повернення',
  `considers` VARCHAR(45) NULL DEFAULT NULL COMMENT 'Розглядає',
  `contents` VARCHAR(255) NULL DEFAULT NULL COMMENT 'Короткий зміст',
  `control_type` ENUM('звичайний','додатковий') NOT NULL,
  `term` DATETIME NULL DEFAULT NULL COMMENT 'Термін',
  `add_to_term` DATETIME NULL DEFAULT NULL COMMENT 'Продовжено днів',
  `end_of_control_date` DATETIME NULL DEFAULT NULL COMMENT 'Дата зняття контролю',
  `end_of_control_person_id` SMALLINT(5) UNSIGNED NULL DEFAULT NULL COMMENT 'Особа, яка зняла з контролю',
  `result` VARCHAR(255) NULL DEFAULT NULL COMMENT 'Результат',
  `readiness` TINYINT(4) NOT NULL COMMENT 'готовність 0-не завершений, 1-завершений',
  PRIMARY KEY (`id`),
  CONSTRAINT `bid_id_rkk`
    FOREIGN KEY (`id`)
    REFERENCES `cnap_portal`.`gen_bid_current_status` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'РКК заяв користувачів';

CREATE UNIQUE INDEX `bid_id_UNIQUE` ON `cnap_portal`.`cab_bids_rkk` (`bid_id` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`cab_user_external`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`cab_user_external` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`cab_user_external` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `type_of_user` TINYINT(3) UNSIGNED NOT NULL COMMENT 'Тип користувача (0-фіз.особа, 1- ФОП, 2-юр.особа)',
  `fio` VARCHAR(100) NOT NULL COMMENT 'ПІБ',
  `organization` VARCHAR(100) NOT NULL DEFAULT 'фізична особа' COMMENT 'Організація',
  `email` VARCHAR(45) NOT NULL COMMENT 'Електронна поштова скринька',
  `phone` VARCHAR(12) NOT NULL COMMENT 'Мобільний телефон',
  `cab_state` ENUM('не активований','активований','блокований') NOT NULL COMMENT 'Стан кабінету',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8
COMMENT = 'Таблиця «Каталог зовнішніх користувачів порталу»';

CREATE UNIQUE INDEX `email_UNIQUE` ON `cnap_portal`.`cab_user_external` (`email` ASC);

CREATE UNIQUE INDEX `phone_UNIQUE` ON `cnap_portal`.`cab_user_external` (`phone` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`cab_org_external_certs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`cab_org_external_certs` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`cab_org_external_certs` (
  `id` INT(10) UNSIGNED NOT NULL,
  `certissuer` TEXT NOT NULL COMMENT 'Власник сертифікату',
  `certserial` VARCHAR(40) NOT NULL COMMENT 'Серійний номер сертифікату',
  `certSubjDRFOCode` VARCHAR(10) NULL DEFAULT NULL COMMENT 'Код ДРФО',
  `certSubjEDRPOUCode` VARCHAR(10) NOT NULL COMMENT 'Код ЄДРПОУ',
  `certData` MEDIUMBLOB NOT NULL COMMENT 'Вміст сертифікату',
  `type` TINYINT(3) UNSIGNED NOT NULL COMMENT 'Тип 0-ЕЦП 1-шифрування',
  `ext_user_id` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `ext_org_certs`
    FOREIGN KEY (`ext_user_id`)
    REFERENCES `cnap_portal`.`cab_user_external` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Сертифікати організацій';

CREATE INDEX `authorities_certs_idx` ON `cnap_portal`.`cab_org_external_certs` (`ext_user_id` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`gen_services`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`gen_services` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`gen_services` (
  `id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `name` VARCHAR(500) NOT NULL COMMENT 'Назва послуги',
  `subjnap_id` SMALLINT(5) UNSIGNED NOT NULL COMMENT 'ID суб’єкта НАП',
  `subjwork_id` SMALLINT(5) UNSIGNED NOT NULL,
  `regulations` TEXT NOT NULL COMMENT 'Нормативно-правові акти',
  `reason` TEXT NOT NULL COMMENT 'Підстава для отримання',
  `submission_proc` TEXT NOT NULL COMMENT 'Порядок подання',
  `docums` TEXT NOT NULL COMMENT 'Перелік документів',
  `is_payed` TINYINT(4) NOT NULL COMMENT 'Платність послуги',
  `payed_regulations` TEXT NULL DEFAULT NULL COMMENT 'Нормативно-правові акти',
  `payed_rate` TEXT NULL DEFAULT NULL COMMENT 'Розмір плати',
  `bank_info` TEXT NULL DEFAULT NULL COMMENT 'Банківські реквізити',
  `deadline` TEXT NOT NULL COMMENT 'Строк надання',
  `denail_grounds` TEXT NULL DEFAULT NULL COMMENT 'Підстави для відмови',
  `result` TEXT NOT NULL COMMENT 'Результат надання',
  `answer` TEXT NOT NULL COMMENT 'Способи отримання відповіді',
  `is_online` ENUM('так','ні') NOT NULL COMMENT 'Можливість надання в електронному вигляді',
  `have_expertise` TINYINT(3) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Наявність експертизи (0-ні,1-так)',
  `nes_expertise` TEXT NULL DEFAULT NULL,
  `is_payed_expertise` TINYINT(4) NOT NULL DEFAULT '0' COMMENT 'Чи платна експертиза',
  `payed_expertise` TEXT NULL DEFAULT NULL COMMENT 'Платність експертизи',
  `regul_expertise` TEXT NULL DEFAULT NULL COMMENT 'НПА експертизи',
  `rate_expertise` TEXT NULL DEFAULT NULL COMMENT 'Розмір плати за експертизу',
  `bank_info_expertise` TEXT NULL DEFAULT NULL COMMENT 'Банківські реквізити (експертиза)',
  `ff_link` INT(11) NULL DEFAULT NULL COMMENT 'Посилання на вільну форму',
  PRIMARY KEY (`id`),
  CONSTRAINT `id_i`
    FOREIGN KEY (`subjnap_id`)
    REFERENCES `cnap_portal`.`gen_authorities` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `id_sub`
    FOREIGN KEY (`subjwork_id`)
    REFERENCES `cnap_portal`.`gen_authorities` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 122
DEFAULT CHARACTER SET = utf8
COMMENT = 'Таблиця «Відомості про послуги»';

CREATE UNIQUE INDEX `name` ON `cnap_portal`.`gen_services` (`name`(255) ASC);

CREATE INDEX `id_idx` ON `cnap_portal`.`gen_services` (`subjnap_id` ASC);

CREATE INDEX `id2_idx` ON `cnap_portal`.`gen_services` (`subjwork_id` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`cab_promoting_bids`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`cab_promoting_bids` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`cab_promoting_bids` (
  `id` SMALLINT(5) UNSIGNED NOT NULL,
  `services_id` SMALLINT(5) UNSIGNED NOT NULL COMMENT 'ID послуги',
  `step` TINYINT(3) UNSIGNED NOT NULL COMMENT 'Крок',
  `authorities_id` SMALLINT(5) UNSIGNED NOT NULL COMMENT 'ID організації',
  `scab_user_id` SMALLINT(5) UNSIGNED NULL DEFAULT NULL COMMENT 'ID виконавця (за потреби)',
  PRIMARY KEY (`id`),
  CONSTRAINT `promoting_services`
    FOREIGN KEY (`services_id`)
    REFERENCES `cnap_portal`.`gen_services` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Просування заявки';

CREATE INDEX `fk_services` ON `cnap_portal`.`cab_promoting_bids` (`services_id` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`cab_user_roles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`cab_user_roles` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`cab_user_roles` (
  `id` TINYINT(3) UNSIGNED NOT NULL COMMENT '№ з/п',
  `user_role` VARCHAR(30) NOT NULL COMMENT 'Назва ролі',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Таблиця «Каталог ролі користувачів»';


-- -----------------------------------------------------
-- Table `cnap_portal`.`cab_user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`cab_user` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`cab_user` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `type_of_user` TINYINT(3) UNSIGNED NOT NULL COMMENT 'Тип користувача (0-фіз.особа, 1- ФОП, 2-юр.особа)',
  `fio` VARCHAR(100) NOT NULL COMMENT 'ПІБ',
  `organization` VARCHAR(100) NOT NULL DEFAULT 'фізична особа' COMMENT 'Організація',
  `email` VARCHAR(45) NOT NULL COMMENT 'Електронна поштова скринька',
  `phone` VARCHAR(12) NOT NULL COMMENT 'Мобільний телефон',
  `cab_state` ENUM('не активований','активований','блокований') NOT NULL COMMENT 'Стан кабінету',
  `authorities_id` SMALLINT(3) UNSIGNED NOT NULL,
  `user_roles_id` TINYINT(3) UNSIGNED NOT NULL COMMENT 'ID ролі користувача',
  `str_activcode` VARCHAR(40) NULL DEFAULT NULL COMMENT 'Строка з кодом активації',
  `time_activcode` INT(11) NULL DEFAULT NULL COMMENT 'Час дії строки з кодом активації',
  `pd_agreement_signed` MEDIUMBLOB NOT NULL COMMENT 'Згода на обробку персональних даних',
  `time_registered` INT(11) NULL DEFAULT NULL COMMENT 'Дата реєстрації користувача',
  `time_last_login` INT(11) NULL DEFAULT NULL COMMENT 'Дата останнього входу користувача',
  PRIMARY KEY (`id`),
  CONSTRAINT `t_author_id`
    FOREIGN KEY (`authorities_id`)
    REFERENCES `cnap_portal`.`gen_authorities` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `t_role_id`
    FOREIGN KEY (`user_roles_id`)
    REFERENCES `cnap_portal`.`cab_user_roles` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 58
DEFAULT CHARACTER SET = utf8
COMMENT = 'Таблиця «Каталог користувачів порталу»';

CREATE INDEX `role_id_idx` ON `cnap_portal`.`cab_user` (`user_roles_id` ASC);

CREATE INDEX `author_id_idx` ON `cnap_portal`.`cab_user` (`authorities_id` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`cab_user_activities`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`cab_user_activities` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`cab_user_activities` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `portal_user_id` SMALLINT(5) UNSIGNED NOT NULL COMMENT 'ID користувача',
  `visiting` DATETIME NOT NULL COMMENT 'Час події',
  `IPAdress` VARCHAR(15) NOT NULL COMMENT 'IP адреса',
  `type` ENUM('вхід','вихід','роздрукування','редагування') NOT NULL COMMENT 'Подія',
  `success` TINYINT(4) NOT NULL COMMENT 'Успішність 0/1',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Таблиця «Відомості про активність користувачів»';


-- -----------------------------------------------------
-- Table `cnap_portal`.`cab_user_bids_connect`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`cab_user_bids_connect` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`cab_user_bids_connect` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT(10) UNSIGNED NOT NULL COMMENT 'ID користувача',
  `bid_created_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата подачі',
  `services_id` SMALLINT(5) UNSIGNED NOT NULL COMMENT 'ID послуги',
  `payment_status` ENUM('UNPAID','PAID') NOT NULL COMMENT 'Статус оплати',
  `answer_variant` TINYINT(3) UNSIGNED NOT NULL COMMENT 'Варіант отримання відповіді 0-пошта 1-особисто 2-портал',
  `address` VARCHAR(255) NULL DEFAULT NULL COMMENT 'Адреса куди надсилати відповідь поштою',
  PRIMARY KEY (`id`),
  CONSTRAINT `bid_id`
    FOREIGN KEY (`id`)
    REFERENCES `cnap_portal`.`gen_bid_current_status` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `cab_ser_id`
    FOREIGN KEY (`services_id`)
    REFERENCES `cnap_portal`.`gen_services` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `int_user_bid_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `cnap_portal`.`cab_user_external` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8
COMMENT = 'Таблиця з заявками';

CREATE INDEX `fk_serv` ON `cnap_portal`.`cab_user_bids_connect` (`services_id` ASC);

CREATE INDEX `fk_user_id` ON `cnap_portal`.`cab_user_bids_connect` (`user_id` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`cab_user_extern_certs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`cab_user_extern_certs` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`cab_user_extern_certs` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `type_of_user` TINYINT(4) NOT NULL COMMENT 'Тип користувача (0-фіз.особа 1-організація)',
  `certissuer` TEXT NOT NULL COMMENT 'Власник сертифікату',
  `certserial` VARCHAR(40) NOT NULL COMMENT 'Серійний номер сертифікату',
  `certSubjDRFOCode` VARCHAR(10) NULL DEFAULT NULL COMMENT 'Код ДРФО',
  `certSubjEDRPOUCode` VARCHAR(10) NULL DEFAULT NULL COMMENT 'Код ЄДРПОУ',
  `certData` MEDIUMBLOB NOT NULL COMMENT 'Вміст сертифікату',
  `certType` TINYINT(3) UNSIGNED NOT NULL COMMENT 'Тип ЕЦП/шифрування',
  `ext_user_id` INT(10) UNSIGNED NOT NULL COMMENT 'ID зовнішнього користувача',
  `certSignTime` INT(11) NULL DEFAULT NULL COMMENT 'Час підпису форми реєстрації',
  `certUseTSP` TINYINT(1) NULL DEFAULT NULL COMMENT 'Присутність мітки часу',
  `certIssuerCN` TEXT NULL DEFAULT NULL COMMENT 'Загальне ім\'я видавника',
  `certSubject` TEXT NULL DEFAULT NULL COMMENT 'Власник сертифікату',
  `certSubjCN` TEXT NULL DEFAULT NULL COMMENT 'Загальне ім\'я власника',
  `certSubjOrg` TEXT NULL DEFAULT NULL COMMENT 'Організація',
  `certSubjOrgUnit` TEXT NULL DEFAULT NULL COMMENT 'Підрозділ',
  `certSubjTitle` TEXT NULL DEFAULT NULL COMMENT 'Посада',
  `certSubjState` TEXT NULL DEFAULT NULL COMMENT 'Область',
  `certSubjLocality` TEXT NULL DEFAULT NULL COMMENT 'Місто',
  `certSubjFullName` TEXT NULL DEFAULT NULL COMMENT 'Повне ім\'я',
  `certSubjAddress` TEXT NULL DEFAULT NULL COMMENT 'Адреса',
  `certSubjPhone` TEXT NULL DEFAULT NULL COMMENT 'Телефон',
  `certSubjEMail` TEXT NULL DEFAULT NULL COMMENT 'E-Mail',
  `certSubjDNS` TEXT NULL DEFAULT NULL COMMENT 'DNS',
  `certExpireEndTime` INT(11) NULL DEFAULT NULL COMMENT 'Дата закінчення дії сертифікату',
  `certExpireBeginTime` INT(11) NULL DEFAULT NULL COMMENT 'Дата початку дії сертифікату',
  PRIMARY KEY (`id`),
  CONSTRAINT `ext_user_certs`
    FOREIGN KEY (`ext_user_id`)
    REFERENCES `cnap_portal`.`cab_user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 42
DEFAULT CHARACTER SET = utf8
COMMENT = 'Таблиця «Сертифікати зовнішніх користувачів»';

CREATE INDEX `ext_user_certs_idx` ON `cnap_portal`.`cab_user_extern_certs` (`ext_user_id` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`cab_user_files_in`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`cab_user_files_in` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`cab_user_files_in` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_bid_id` INT(11) UNSIGNED NOT NULL COMMENT 'ID заявки користувача',
  `content` MEDIUMBLOB NOT NULL COMMENT 'Вміст файлу',
  `extension` VARCHAR(5) NOT NULL COMMENT 'Розширення файлу',
  `state` TINYINT(4) NOT NULL COMMENT '0-оброблені, 1-не оброблені',
  `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата та час додавання',
  PRIMARY KEY (`id`),
  CONSTRAINT `bid_id_in`
    FOREIGN KEY (`user_bid_id`)
    REFERENCES `cnap_portal`.`gen_bid_current_status` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8
COMMENT = 'Вхідні файли заявок';

CREATE INDEX `fk_bid_out` ON `cnap_portal`.`cab_user_files_in` (`user_bid_id` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`cab_user_files_out`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`cab_user_files_out` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`cab_user_files_out` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_bid_id` INT(11) UNSIGNED NOT NULL COMMENT 'ID заявки',
  `content` MEDIUMBLOB NOT NULL COMMENT 'Вміст файлу',
  `extension` VARCHAR(5) NOT NULL COMMENT 'Розширення файлу',
  `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата та час додавання',
  PRIMARY KEY (`id`),
  CONSTRAINT `bid_id_out`
    FOREIGN KEY (`user_bid_id`)
    REFERENCES `cnap_portal`.`gen_bid_current_status` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Вихідні файли заявок';

CREATE INDEX `fk_bid_out` ON `cnap_portal`.`cab_user_files_out` (`user_bid_id` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`cab_user_gen_str`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`cab_user_gen_str` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`cab_user_gen_str` (
  `sauth` VARCHAR(40) NOT NULL COMMENT 'Строка авторизації',
  `itime` INT(11) NOT NULL COMMENT 'час авторизації',
  PRIMARY KEY (`sauth`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Генеровані строки авторизації';


-- -----------------------------------------------------
-- Table `cnap_portal`.`cab_user_intern_certs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`cab_user_intern_certs` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`cab_user_intern_certs` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `certissuer` TEXT NOT NULL COMMENT 'Власник сертифікату',
  `certserial` VARCHAR(40) NOT NULL COMMENT 'Серійний номер сертифікату',
  `certSubjDRFOCode` VARCHAR(10) NOT NULL COMMENT 'Код ДРФО',
  `certSubjEDRPOUCode` VARCHAR(10) NULL DEFAULT NULL COMMENT 'Код ЄДРПОУ',
  `certData` MEDIUMBLOB NOT NULL COMMENT 'Вміст сертифікату',
  `certType` TINYINT(3) UNSIGNED NOT NULL COMMENT 'Тип ЕЦП/шифрування',
  `signedData` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Таблиця «Сертифікати внутрішніх користувачів»';


-- -----------------------------------------------------
-- Table `cnap_portal`.`cab_user_internal`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`cab_user_internal` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`cab_user_internal` (
  `id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `authorities_id` SMALLINT(5) UNSIGNED NOT NULL COMMENT 'ID органу',
  `user_roles_id` TINYINT(3) UNSIGNED NOT NULL COMMENT 'ID ролі користувача',
  `cab_state` ENUM('активований','блокований') NOT NULL COMMENT 'стан кабінету',
  PRIMARY KEY (`id`),
  CONSTRAINT `author_id`
    FOREIGN KEY (`authorities_id`)
    REFERENCES `cnap_portal`.`gen_authorities` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `role_id`
    FOREIGN KEY (`user_roles_id`)
    REFERENCES `cnap_portal`.`cab_user_roles` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Таблиця «Каталог внутрішніх користувачів порталу»';

CREATE INDEX `role_id_idx` ON `cnap_portal`.`cab_user_internal` (`user_roles_id` ASC);

CREATE INDEX `author_id_idx` ON `cnap_portal`.`cab_user_internal` (`authorities_id` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_available_actions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_available_actions` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_available_actions` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NOT NULL DEFAULT '21',
  `storage` INT(11) NULL DEFAULT NULL,
  `action` BIGINT(20) NULL DEFAULT NULL,
  `node` BIGINT(20) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
AVG_ROW_LENGTH = 442
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_available_actions_for_cnap`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_available_actions_for_cnap` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_available_actions_for_cnap` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NOT NULL DEFAULT '42',
  `storage` INT(11) NULL DEFAULT NULL,
  `action` BIGINT(20) NULL DEFAULT NULL,
  `node` BIGINT(20) NULL DEFAULT NULL,
  `users` INT(11) NULL DEFAULT NULL,
  `roles` INT(11) NULL DEFAULT NULL,
  `authorities` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
AVG_ROW_LENGTH = 585
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_available_actions_for_roles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_available_actions_for_roles` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_available_actions_for_roles` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NOT NULL DEFAULT '22',
  `storage` INT(11) NULL DEFAULT NULL,
  `action` BIGINT(20) NULL DEFAULT NULL,
  `node` BIGINT(20) NULL DEFAULT NULL,
  `roles` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_available_actions_for_users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_available_actions_for_users` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_available_actions_for_users` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NOT NULL DEFAULT '23',
  `storage` INT(11) NULL DEFAULT NULL,
  `action` BIGINT(20) NULL DEFAULT NULL,
  `node` BIGINT(20) NULL DEFAULT NULL,
  `users` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_available_nodes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_available_nodes` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_available_nodes` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NOT NULL DEFAULT '16',
  `storage` INT(11) NULL DEFAULT NULL,
  `node` BIGINT(20) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
AVG_ROW_LENGTH = 481
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_available_nodes_for_cnap`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_available_nodes_for_cnap` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_available_nodes_for_cnap` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NOT NULL DEFAULT '41',
  `storage` INT(11) NULL DEFAULT NULL,
  `node` BIGINT(20) NULL DEFAULT NULL,
  `users` INT(11) NULL DEFAULT NULL,
  `roles` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
AVG_ROW_LENGTH = 564
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_available_nodes_for_roles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_available_nodes_for_roles` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_available_nodes_for_roles` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NOT NULL DEFAULT '18',
  `storage` INT(11) NULL DEFAULT NULL,
  `node` BIGINT(20) NULL DEFAULT NULL,
  `roles` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_available_nodes_for_users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_available_nodes_for_users` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_available_nodes_for_users` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NOT NULL DEFAULT '17',
  `storage` INT(11) NULL DEFAULT NULL,
  `node` BIGINT(20) NULL DEFAULT NULL,
  `users` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_commentline`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_commentline` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_commentline` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NULL DEFAULT NULL,
  `storage` INT(11) NULL DEFAULT NULL,
  `name` VARCHAR(255) NULL DEFAULT NULL,
  `comment` TEXT NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_default`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_default` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_default` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `registry` INT(11) NOT NULL COMMENT 'Ссылка на регистрацию(таблица которой принадлижит запись)',
  `storage` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2463
AVG_ROW_LENGTH = 112
DEFAULT CHARACTER SET = utf8
COMMENT = 'Корневая родительская форма. Ее наследуют все другие таблицы сформированые при помощи свободных форм ';

CREATE INDEX `FK_STORAGE_idx` USING BTREE ON `cnap_portal`.`ff_default` (`storage` ASC);

CREATE INDEX `FK_REGISTRY_IDX` USING BTREE ON `cnap_portal`.`ff_default` (`registry` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_document_base`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_document_base` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_document_base` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NOT NULL DEFAULT '13',
  `storage` INT(11) NULL DEFAULT NULL,
  `createdate` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `route` INT(11) NULL DEFAULT NULL,
  `available_nodes` INT(11) NULL DEFAULT NULL,
  `available_actions` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
AVG_ROW_LENGTH = 8192
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `indx_registry` USING BTREE ON `cnap_portal`.`ff_document_base` (`registry` ASC);

CREATE INDEX `indx_storage` USING BTREE ON `cnap_portal`.`ff_document_base` (`storage` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_document_cnap`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_document_cnap` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_document_cnap` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NOT NULL DEFAULT '36',
  `storage` INT(11) NULL DEFAULT NULL,
  `createdate` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `route` INT(11) NULL DEFAULT NULL,
  `available_nodes` INT(11) NULL DEFAULT NULL,
  `available_actions` INT(11) NULL DEFAULT NULL,
  `regnum` VARCHAR(255) NULL DEFAULT NULL,
  `regdate` DATE NULL DEFAULT NULL,
  `legal_personality` INT(11) NULL DEFAULT NULL,
  `person_name` VARCHAR(255) NULL DEFAULT NULL,
  `person_drfo` VARCHAR(255) NULL DEFAULT NULL,
  `address` TEXT NULL DEFAULT NULL,
  `phone1` VARCHAR(20) NULL DEFAULT NULL,
  `phone2` VARCHAR(20) NULL DEFAULT NULL,
  `delivery_reply` INT(11) NULL DEFAULT NULL,
  `email` VARCHAR(70) NULL DEFAULT NULL,
  `service` INT(11) NULL DEFAULT NULL,
  `context` TEXT NULL DEFAULT NULL,
  `reason` TEXT NULL DEFAULT NULL,
  `reply` INT(11) NULL DEFAULT NULL,
  `file_petition` LONGBLOB NULL DEFAULT NULL,
  `file_petition_fileedsname` VARCHAR(255) NULL DEFAULT NULL,
  `plandate` DATE NULL DEFAULT NULL,
  `factdate` DATE NULL DEFAULT NULL,
  `administrator` INT(11) NULL DEFAULT NULL,
  `executor` INT(11) NULL DEFAULT NULL,
  `file_result` LONGBLOB NULL DEFAULT NULL,
  `file_result_fileedsname` VARCHAR(255) NULL DEFAULT NULL,
  `authorities` INT(11) NULL DEFAULT NULL,
  `organization_name` VARCHAR(255) NULL DEFAULT NULL,
  `organization_edrpou` VARCHAR(255) NULL DEFAULT NULL,
  `outnum` VARCHAR(255) NULL DEFAULT NULL,
  `outdate` DATE NULL DEFAULT NULL,
  `its_autority` TINYINT(4) NULL DEFAULT NULL,
  `autority_person_name` VARCHAR(255) NULL DEFAULT NULL,
  `autority_person_number` VARCHAR(255) NULL DEFAULT NULL,
  `number_of_pages` INT(11) NULL DEFAULT NULL,
  `delivery` INT(11) NULL DEFAULT NULL,
  `renewal_date` DATE NULL DEFAULT NULL,
  `exec_date` DATE NULL DEFAULT NULL,
  `executor_post` VARCHAR(255) NULL DEFAULT NULL,
  `result_delivery` TINYINT(4) NULL DEFAULT NULL,
  `result_date_delivery` DATE NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
AVG_ROW_LENGTH = 8192
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_document_cnap_metolobruht`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_document_cnap_metolobruht` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_document_cnap_metolobruht` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NOT NULL DEFAULT '38',
  `storage` INT(11) NULL DEFAULT NULL,
  `createdate` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `route` INT(11) NULL DEFAULT NULL,
  `available_nodes` INT(11) NULL DEFAULT NULL,
  `available_actions` INT(11) NULL DEFAULT NULL,
  `regnum` VARCHAR(255) NULL DEFAULT NULL,
  `regdate` DATE NULL DEFAULT NULL,
  `legal_personality` INT(11) NULL DEFAULT NULL,
  `person_name` VARCHAR(255) NULL DEFAULT NULL,
  `person_drfo` VARCHAR(255) NULL DEFAULT NULL,
  `address` TEXT NULL DEFAULT NULL,
  `phone1` VARCHAR(20) NULL DEFAULT NULL,
  `phone2` VARCHAR(20) NULL DEFAULT NULL,
  `delivery_reply` INT(11) NULL DEFAULT NULL,
  `email` VARCHAR(70) NULL DEFAULT NULL,
  `service` INT(11) NULL DEFAULT NULL,
  `context` TEXT NULL DEFAULT NULL,
  `reason` TEXT NULL DEFAULT NULL,
  `reply` INT(11) NULL DEFAULT NULL,
  `file_petition` LONGBLOB NULL DEFAULT NULL,
  `file_petition_fileedsname` VARCHAR(255) NULL DEFAULT NULL,
  `plandate` DATE NULL DEFAULT NULL,
  `factdate` DATE NULL DEFAULT NULL,
  `administrator` INT(11) NULL DEFAULT NULL,
  `executor` INT(11) NULL DEFAULT NULL,
  `file_result` LONGBLOB NULL DEFAULT NULL,
  `file_result_fileedsname` VARCHAR(255) NULL DEFAULT NULL,
  `authorities` INT(11) NULL DEFAULT NULL,
  `organization_name` VARCHAR(255) NULL DEFAULT NULL,
  `organization_edrpou` VARCHAR(255) NULL DEFAULT NULL,
  `outnum` VARCHAR(255) NULL DEFAULT NULL,
  `outdate` DATE NULL DEFAULT NULL,
  `its_autority` TINYINT(4) NULL DEFAULT NULL,
  `autority_person_name` VARCHAR(255) NULL DEFAULT NULL,
  `autority_person_number` VARCHAR(255) NULL DEFAULT NULL,
  `number_of_pages` INT(11) NULL DEFAULT NULL,
  `delivery` INT(11) NULL DEFAULT NULL,
  `renewal_date` DATE NULL DEFAULT NULL,
  `exec_date` DATE NULL DEFAULT NULL,
  `executor_post` VARCHAR(255) NULL DEFAULT NULL,
  `result_delivery` TINYINT(4) NULL DEFAULT NULL,
  `result_date_delivery` DATE NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
AVG_ROW_LENGTH = 16384
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_document_demo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_document_demo` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_document_demo` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NOT NULL DEFAULT '14',
  `storage` INT(11) NULL DEFAULT NULL,
  `createdate` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `creditor` TEXT NULL DEFAULT NULL,
  `route` INT(11) NULL DEFAULT NULL,
  `nodes` INT(11) NULL DEFAULT NULL,
  `available_nodes` INT(11) NULL DEFAULT NULL,
  `available_actions` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
AVG_ROW_LENGTH = 224
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_document_rkk`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_document_rkk` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_document_rkk` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NOT NULL DEFAULT '24',
  `storage` INT(11) NULL DEFAULT NULL,
  `createdate` DATETIME NULL DEFAULT NULL,
  `route` INT(11) NULL DEFAULT NULL,
  `available_nodes` INT(11) NULL DEFAULT NULL,
  `available_actions` INT(11) NULL DEFAULT NULL,
  `regnum` VARCHAR(255) NULL DEFAULT NULL,
  `regdate` DATE NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
AVG_ROW_LENGTH = 8192
DEFAULT CHARACTER SET = utf8;


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
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 43
AVG_ROW_LENGTH = 546
DEFAULT CHARACTER SET = utf8
COMMENT = 'Список зарегистрированных свободных форм';

CREATE UNIQUE INDEX `table_UNIQUE` USING BTREE ON `cnap_portal`.`ff_registry` (`tablename` ASC);

CREATE INDEX `parent` USING BTREE ON `cnap_portal`.`ff_registry` (`parent` ASC);


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
  `default` TINYTEXT NULL DEFAULT NULL COMMENT 'Значение поля по-умолчанию',
  PRIMARY KEY USING BTREE (`id`),
  CONSTRAINT `fk_formid`
    FOREIGN KEY (`formid`)
    REFERENCES `cnap_portal`.`ff_registry` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 342
AVG_ROW_LENGTH = 88
DEFAULT CHARACTER SET = utf8
COMMENT = 'Список полей подключенных в свобных формах';

CREATE INDEX `id_idx` USING BTREE ON `cnap_portal`.`ff_field` (`formid` ASC);

CREATE INDEX `FK_TYPE_idx` USING BTREE ON `cnap_portal`.`ff_field` (`type` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_oneline`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_oneline` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_oneline` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NULL DEFAULT NULL,
  `storage` INT(11) NULL DEFAULT NULL,
  `name` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
AVG_ROW_LENGTH = 409
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_organization`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_organization` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_organization` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NOT NULL DEFAULT '37',
  `storage` INT(11) NULL DEFAULT NULL,
  `name` VARCHAR(255) NULL DEFAULT NULL,
  `edrpou` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
AVG_ROW_LENGTH = 5461
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_ref_multiguide`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_ref_multiguide` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_ref_multiguide` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NULL DEFAULT NULL,
  `storage` INT(11) NULL DEFAULT NULL,
  `order` INT(11) NULL DEFAULT NULL,
  `owner` BIGINT(20) NULL DEFAULT NULL,
  `owner_field` VARCHAR(255) NULL DEFAULT NULL,
  `reference` BIGINT(20) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`),
  CONSTRAINT `fk_owner`
    FOREIGN KEY (`owner`)
    REFERENCES `cnap_portal`.`ff_default` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AVG_ROW_LENGTH = 167
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_owner_idx` USING BTREE ON `cnap_portal`.`ff_ref_multiguide` (`owner` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_registry_h`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_registry_h` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_registry_h` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `owner` INT(11) NOT NULL COMMENT 'Основная таблица',
  `parent` INT(11) NOT NULL COMMENT 'Родители основной талицы',
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 150
AVG_ROW_LENGTH = 190
DEFAULT CHARACTER SET = utf8
COMMENT = 'Иерархия(вспомогательная таблиц';

CREATE INDEX `fk_parent_idx` USING BTREE ON `cnap_portal`.`ff_registry_h` (`parent` ASC);

CREATE INDEX `idx_owner` USING BTREE ON `cnap_portal`.`ff_registry_h` (`owner` ASC);


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
  `fields` TINYTEXT NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 24
AVG_ROW_LENGTH = 780
DEFAULT CHARACTER SET = utf8
COMMENT = 'Хранилище свободной формы';

CREATE INDEX `idx_type` USING BTREE ON `cnap_portal`.`ff_storage` (`type` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_registry_storage`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_registry_storage` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_registry_storage` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `registry` INT(11) NOT NULL COMMENT 'Ссылка на регистрацию свободной формы',
  `storage` INT(11) NOT NULL COMMENT 'Ссылка на хранилище в свободной форме',
  PRIMARY KEY USING BTREE (`id`),
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
AUTO_INCREMENT = 117
AVG_ROW_LENGTH = 546
DEFAULT CHARACTER SET = utf8
COMMENT = 'Привязка форм и хранилищ';

CREATE INDEX `fk_registry_idx` USING BTREE ON `cnap_portal`.`ff_registry_storage` (`registry` ASC);

CREATE INDEX `fk_storage_idx` USING BTREE ON `cnap_portal`.`ff_registry_storage` (`storage` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_route`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_route` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_route` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NOT NULL DEFAULT '7',
  `storage` INT(11) NULL DEFAULT NULL,
  `name` VARCHAR(255) NULL DEFAULT NULL,
  `comment` TEXT NULL DEFAULT NULL,
  `start_route` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_route_action`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_route_action` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_route_action` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NOT NULL DEFAULT '5',
  `storage` INT(11) NULL DEFAULT NULL,
  `name` VARCHAR(255) NULL DEFAULT NULL,
  `comment` TEXT NULL DEFAULT NULL,
  `gotonodes` INT(11) NULL DEFAULT NULL,
  `clearnodes` INT(11) NULL DEFAULT NULL,
  `currentuser` TINYINT(4) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
AVG_ROW_LENGTH = 2048
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_route_action_for_cnap`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_route_action_for_cnap` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_route_action_for_cnap` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NOT NULL DEFAULT '40',
  `storage` INT(11) NULL DEFAULT NULL,
  `name` VARCHAR(255) NULL DEFAULT NULL,
  `comment` TEXT NULL DEFAULT NULL,
  `gotonodes` INT(11) NULL DEFAULT NULL,
  `clearnodes` INT(11) NULL DEFAULT NULL,
  `currentuser` TINYINT(4) NULL DEFAULT NULL,
  `default_attributes` INT(11) NULL DEFAULT NULL,
  `roles` INT(11) NULL DEFAULT NULL,
  `users` INT(11) NULL DEFAULT NULL,
  `clearuser` TINYINT(4) NULL DEFAULT NULL,
  `current_authorities` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
AVG_ROW_LENGTH = 2048
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_route_action_for_role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_route_action_for_role` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_route_action_for_role` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NOT NULL DEFAULT '25',
  `storage` INT(11) NULL DEFAULT NULL,
  `name` VARCHAR(255) NULL DEFAULT NULL,
  `comment` TEXT NULL DEFAULT NULL,
  `gotonodes` INT(11) NULL DEFAULT NULL,
  `clearnodes` INT(11) NULL DEFAULT NULL,
  `roles` INT(11) NULL DEFAULT NULL,
  `currentrole` TINYINT(4) NULL DEFAULT NULL,
  `currentuser` TINYINT(4) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
AVG_ROW_LENGTH = 5461
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_route_action_for_user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_route_action_for_user` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_route_action_for_user` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NOT NULL DEFAULT '26',
  `storage` INT(11) NULL DEFAULT NULL,
  `name` VARCHAR(255) NULL DEFAULT NULL,
  `comment` TEXT NULL DEFAULT NULL,
  `gotonodes` INT(11) NULL DEFAULT NULL,
  `clearnodes` INT(11) NULL DEFAULT NULL,
  `users` INT(11) NULL DEFAULT NULL,
  `ownernodes` INT(11) NULL DEFAULT NULL,
  `currentuser` TINYINT(4) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
AVG_ROW_LENGTH = 3276
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_route_cabinet`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_route_cabinet` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_route_cabinet` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NOT NULL DEFAULT '9',
  `storage` INT(11) NULL DEFAULT NULL,
  `name` VARCHAR(255) NULL DEFAULT NULL,
  `comment` TEXT NULL DEFAULT NULL,
  `folders` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
AVG_ROW_LENGTH = 5461
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_route_cabinet_for_role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_route_cabinet_for_role` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_route_cabinet_for_role` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NOT NULL DEFAULT '12',
  `storage` INT(11) NULL DEFAULT NULL,
  `name` VARCHAR(255) NULL DEFAULT NULL,
  `comment` TEXT NULL DEFAULT NULL,
  `folders` INT(11) NULL DEFAULT NULL,
  `role` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
AVG_ROW_LENGTH = 5461
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_route_cabinet_for_users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_route_cabinet_for_users` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_route_cabinet_for_users` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NOT NULL DEFAULT '15',
  `storage` INT(11) NULL DEFAULT NULL,
  `name` VARCHAR(255) NULL DEFAULT NULL,
  `comment` TEXT NULL DEFAULT NULL,
  `folders` INT(11) NULL DEFAULT NULL,
  `users` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_route_folder`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_route_folder` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_route_folder` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NOT NULL DEFAULT '8',
  `storage` INT(11) NULL DEFAULT NULL,
  `name` VARCHAR(255) NULL DEFAULT NULL,
  `comment` TEXT NULL DEFAULT NULL,
  `nodes` INT(11) NULL DEFAULT NULL,
  `allow_new` INT(11) NULL DEFAULT NULL,
  `allow_edit` INT(11) NULL DEFAULT NULL,
  `allow_delete` INT(11) NULL DEFAULT NULL,
  `visual_names` TEXT NULL DEFAULT NULL,
  `deny_new` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
AVG_ROW_LENGTH = 1638
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_route_for_role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_route_for_role` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_route_for_role` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NOT NULL DEFAULT '27',
  `storage` INT(11) NULL DEFAULT NULL,
  `name` VARCHAR(255) NULL DEFAULT NULL,
  `comment` TEXT NULL DEFAULT NULL,
  `start_route` INT(11) NULL DEFAULT NULL,
  `roles` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_route_for_user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_route_for_user` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_route_for_user` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NOT NULL DEFAULT '28',
  `storage` INT(11) NULL DEFAULT NULL,
  `name` VARCHAR(255) NULL DEFAULT NULL,
  `comment` TEXT NULL DEFAULT NULL,
  `start_route` INT(11) NULL DEFAULT NULL,
  `users` INT(11) NULL DEFAULT NULL,
  `currentuser` TINYINT(4) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`ff_route_node`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`ff_route_node` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`ff_route_node` (
  `id` INT(11) NOT NULL,
  `registry` INT(11) NOT NULL DEFAULT '6',
  `storage` INT(11) NULL DEFAULT NULL,
  `name` VARCHAR(255) NULL DEFAULT NULL,
  `comment` TEXT NULL DEFAULT NULL,
  `allow_action` INT(11) NULL DEFAULT NULL,
  `deny_action` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
AVG_ROW_LENGTH = 2340
DEFAULT CHARACTER SET = utf8;


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
  PRIMARY KEY USING BTREE (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 1021
AVG_ROW_LENGTH = 481
DEFAULT CHARACTER SET = utf8
COMMENT = 'Список зарегистрированных типов';


-- -----------------------------------------------------
-- Table `cnap_portal`.`fpoll_config`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`fpoll_config` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`fpoll_config` (
  `user` TEXT NOT NULL,
  `pass` TEXT NOT NULL,
  `bg1` TEXT NOT NULL,
  `bg2` TEXT NOT NULL,
  `text` TEXT NOT NULL,
  `size` TEXT NOT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`fpoll_ips`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`fpoll_ips` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`fpoll_ips` (
  `ip` TEXT NOT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`fpoll_options`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`fpoll_options` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`fpoll_options` (
  `id` TINYINT(4) NOT NULL AUTO_INCREMENT,
  `field` TEXT NOT NULL,
  `votes` TEXT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`fpoll_poll`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`fpoll_poll` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`fpoll_poll` (
  `id` TINYINT(4) NOT NULL AUTO_INCREMENT,
  `question` TEXT NOT NULL,
  `totalvotes` SMALLINT(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `cnap_portal`.`gen_serv_categories`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`gen_serv_categories` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`gen_serv_categories` (
  `id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `name` VARCHAR(60) NOT NULL COMMENT 'Назва категорії',
  `visability` ENUM('так','ні') NOT NULL COMMENT 'Видимість (0/1)',
  `icon` VARCHAR(255) NOT NULL DEFAULT '/' COMMENT 'Піктограма',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 29
DEFAULT CHARACTER SET = utf8
COMMENT = 'Таблиця «Каталог категорій послуг»';

CREATE UNIQUE INDEX `name_UNIQUE` ON `cnap_portal`.`gen_serv_categories` (`name` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`gen_serv_classes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`gen_serv_classes` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`gen_serv_classes` (
  `id` TINYINT(3) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `item_name` VARCHAR(45) NOT NULL COMMENT 'Назва класу',
  `visability` ENUM('так','ні') NOT NULL COMMENT 'Видимість (0/1)',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8
COMMENT = 'Таблиця «Каталог класів послуг»';

CREATE UNIQUE INDEX `item_name_UNIQUE` ON `cnap_portal`.`gen_serv_classes` (`item_name` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`gen_cat_classes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`gen_cat_classes` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`gen_cat_classes` (
  `id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `categorie_id` SMALLINT(5) UNSIGNED NOT NULL COMMENT 'ID послуги',
  `class_id` TINYINT(3) UNSIGNED NOT NULL COMMENT 'ID класу послуги',
  PRIMARY KEY (`id`),
  CONSTRAINT `cat_id`
    FOREIGN KEY (`categorie_id`)
    REFERENCES `cnap_portal`.`gen_serv_categories` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `class_id`
    FOREIGN KEY (`class_id`)
    REFERENCES `cnap_portal`.`gen_serv_classes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 35
DEFAULT CHARACTER SET = utf8
COMMENT = 'Таблиця «Звязок категорій з класами»';

CREATE UNIQUE INDEX `categorie_id` ON `cnap_portal`.`gen_cat_classes` (`categorie_id` ASC, `class_id` ASC);

CREATE INDEX `serv_class_idx` ON `cnap_portal`.`gen_cat_classes` (`categorie_id` ASC);

CREATE INDEX `class_id_idx` ON `cnap_portal`.`gen_cat_classes` (`class_id` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`gen_interview_question`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`gen_interview_question` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`gen_interview_question` (
  `id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `question` VARCHAR(255) NOT NULL COMMENT 'Поставлене питання',
  `is_active` TINYINT(3) UNSIGNED NOT NULL COMMENT '0-не відбуваеться 1-відбувається 2 - архівне',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Теми для опитування';


-- -----------------------------------------------------
-- Table `cnap_portal`.`gen_interview_result`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`gen_interview_result` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`gen_interview_result` (
  `id` SMALLINT(5) UNSIGNED NOT NULL,
  `question_id` SMALLINT(6) UNSIGNED NOT NULL COMMENT 'ID питання',
  `answer_name` VARCHAR(100) NOT NULL COMMENT 'Варіант відповіді',
  `answer_count` SMALLINT(5) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'кількість відповідей',
  PRIMARY KEY (`id`),
  CONSTRAINT `question_id`
    FOREIGN KEY (`question_id`)
    REFERENCES `cnap_portal`.`gen_interview_question` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Результати опитування';

CREATE INDEX `question_id_idx` ON `cnap_portal`.`gen_interview_result` (`question_id` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`gen_life_situation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`gen_life_situation` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`gen_life_situation` (
  `id` SMALLINT(6) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL COMMENT 'Життєва ситуація',
  `visability` ENUM('так','ні') NOT NULL COMMENT 'Видимість',
  `icon` VARCHAR(255) NOT NULL COMMENT 'Піктограма',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8
COMMENT = 'Послуги за життєвими ситуаціями';

CREATE UNIQUE INDEX `name_UNIQUE` ON `cnap_portal`.`gen_life_situation` (`name` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`gen_menu_items`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`gen_menu_items` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`gen_menu_items` (
  `id` TINYINT(3) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `content` VARCHAR(45) NOT NULL COMMENT 'Назва пункту',
  `paderntid` TINYINT(3) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Породжений',
  `url` VARCHAR(45) NOT NULL COMMENT 'URL',
  `ref` TINYINT(3) UNSIGNED NOT NULL COMMENT 'Послідовність',
  `visability` TINYINT(3) UNSIGNED NOT NULL COMMENT 'Видимість (0/1)',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8
COMMENT = 'Таблиця «Пункти меню»';


-- -----------------------------------------------------
-- Table `cnap_portal`.`gen_news`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`gen_news` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`gen_news` (
  `id` TINYINT(3) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `publicationDate` DATE NOT NULL COMMENT 'Дата публікації',
  `title` VARCHAR(255) NOT NULL COMMENT 'Заголовок',
  `summary` TEXT NOT NULL COMMENT 'Стислий опис новини',
  `text` MEDIUMTEXT NOT NULL COMMENT 'Зміст новини',
  `img` VARCHAR(255) NOT NULL COMMENT 'Посилання на зображення',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8
COMMENT = 'Таблиця «Управління новинами»';


-- -----------------------------------------------------
-- Table `cnap_portal`.`gen_other_info`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`gen_other_info` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`gen_other_info` (
  `id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `publicationDate` DATE NOT NULL COMMENT 'Дата публікації',
  `title` VARCHAR(255) NOT NULL COMMENT 'Заголовок',
  `summary` TEXT NOT NULL COMMENT 'Стислий опис публікації',
  `text` MEDIUMTEXT NOT NULL COMMENT 'Зміст публлікації',
  `img` VARCHAR(255) NOT NULL COMMENT 'Посилання',
  `kind_of_publication` TINYINT(3) UNSIGNED NOT NULL COMMENT 'ID виду публікації',
  PRIMARY KEY (`id`),
  CONSTRAINT `menu_info`
    FOREIGN KEY (`kind_of_publication`)
    REFERENCES `cnap_portal`.`gen_menu_items` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8
COMMENT = 'Таблиця «Посилання на статті до категорій сайту»';

CREATE INDEX `menu_info_idx` ON `cnap_portal`.`gen_other_info` (`kind_of_publication` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`gen_regulations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`gen_regulations` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`gen_regulations` (
  `id` TINYINT(3) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `type` ENUM('Закони України','Акти Кабінету Міністрів України','Акти центральних органів виконавчої влади','Акти регіональних органів виконавчої влади та місцевого самоврядування') NOT NULL COMMENT 'Тип нормативно-правового акту',
  `name` VARCHAR(255) NOT NULL COMMENT 'Назва нормативно-правового акту',
  `hyperlink` VARCHAR(255) NOT NULL COMMENT 'Посилання на документ',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 17
DEFAULT CHARACTER SET = utf8
COMMENT = 'Таблиця «Відомості про нормативно-правові акти»';


-- -----------------------------------------------------
-- Table `cnap_portal`.`gen_serv_cat_class`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`gen_serv_cat_class` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`gen_serv_cat_class` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `service_id` SMALLINT(5) UNSIGNED NOT NULL,
  `cat_class_id` SMALLINT(5) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `cat_class_id`
    FOREIGN KEY (`cat_class_id`)
    REFERENCES `cnap_portal`.`gen_cat_classes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `serv_id`
    FOREIGN KEY (`service_id`)
    REFERENCES `cnap_portal`.`gen_services` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 114
DEFAULT CHARACTER SET = utf8
COMMENT = 'Таблиця «Звязок послуг з категоріями та класами»';

CREATE UNIQUE INDEX `service_id` ON `cnap_portal`.`gen_serv_cat_class` (`service_id` ASC, `cat_class_id` ASC);

CREATE INDEX `serv_cat_idx` ON `cnap_portal`.`gen_serv_cat_class` (`cat_class_id` ASC);

CREATE INDEX `serv_id_idx` ON `cnap_portal`.`gen_serv_cat_class` (`service_id` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`gen_serv_docum`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`gen_serv_docum` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`gen_serv_docum` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `name` TEXT NOT NULL COMMENT 'Назва документа',
  `hyperlink` VARCHAR(255) NULL DEFAULT NULL COMMENT 'Посилання',
  `service_id` SMALLINT(5) UNSIGNED NOT NULL COMMENT 'ID послуги',
  PRIMARY KEY (`id`),
  CONSTRAINT `serv_docum`
    FOREIGN KEY (`service_id`)
    REFERENCES `cnap_portal`.`gen_services` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8
COMMENT = 'Таблиця «Перелік документів до послуги»';

CREATE INDEX `serv_docum_idx` ON `cnap_portal`.`gen_serv_docum` (`service_id` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`gen_serv_life_situations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`gen_serv_life_situations` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`gen_serv_life_situations` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `service_id` SMALLINT(6) UNSIGNED NOT NULL,
  `life_situation_id` SMALLINT(6) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `life_situat`
    FOREIGN KEY (`life_situation_id`)
    REFERENCES `cnap_portal`.`gen_life_situation` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `serv_live`
    FOREIGN KEY (`service_id`)
    REFERENCES `cnap_portal`.`gen_services` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 14
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `life_situat` ON `cnap_portal`.`gen_serv_life_situations` (`service_id` ASC, `life_situation_id` ASC);

CREATE INDEX `life_situation_idx` ON `cnap_portal`.`gen_serv_life_situations` (`life_situation_id` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`gen_serv_regulations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`gen_serv_regulations` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`gen_serv_regulations` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '№ з/п',
  `type` ENUM('Закони України','Акти Кабінету Міністрів України','Акти центральних органів виконавчої влади','Акти місцевих ОВВ та МС') NOT NULL COMMENT 'Тип',
  `name` TEXT NOT NULL COMMENT 'Назва',
  `hyperlink` VARCHAR(255) NOT NULL COMMENT 'Посилання',
  `service_id` SMALLINT(5) UNSIGNED NOT NULL COMMENT 'ID послуги',
  PRIMARY KEY (`id`),
  CONSTRAINT `serv_reg`
    FOREIGN KEY (`service_id`)
    REFERENCES `cnap_portal`.`gen_services` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8
COMMENT = 'Таблиця «Законодавчі акти до послуги»';

CREATE INDEX `serv_reg_idx` ON `cnap_portal`.`gen_serv_regulations` (`service_id` ASC);


-- -----------------------------------------------------
-- Table `cnap_portal`.`gen_status_description`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cnap_portal`.`gen_status_description` ;

CREATE TABLE IF NOT EXISTS `cnap_portal`.`gen_status_description` (
  `id` TINYINT(3) UNSIGNED NOT NULL,
  `description` VARCHAR(150) NOT NULL COMMENT 'Текст повідомлення',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Опис статусів';

USE `cnap_portal` ;

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

DELIMITER ;

-- -----------------------------------------------------
-- procedure FF_ALTTBL
-- -----------------------------------------------------

USE `cnap_portal`;
DROP procedure IF EXISTS `cnap_portal`.`FF_ALTTBL`;

DELIMITER $$
USE `cnap_portal`$$
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

DELIMITER ;

-- -----------------------------------------------------
-- procedure FF_AU_FIELD
-- -----------------------------------------------------

USE `cnap_portal`;
DROP procedure IF EXISTS `cnap_portal`.`FF_AU_FIELD`;

DELIMITER $$
USE `cnap_portal`$$
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

DELIMITER ;

-- -----------------------------------------------------
-- procedure FF_BD_FIELD
-- -----------------------------------------------------

USE `cnap_portal`;
DROP procedure IF EXISTS `cnap_portal`.`FF_BD_FIELD`;

DELIMITER $$
USE `cnap_portal`$$
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

DELIMITER ;

-- -----------------------------------------------------
-- procedure FF_CRTTBL
-- -----------------------------------------------------

USE `cnap_portal`;
DROP procedure IF EXISTS `cnap_portal`.`FF_CRTTBL`;

DELIMITER $$
USE `cnap_portal`$$
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

DELIMITER ;

-- -----------------------------------------------------
-- procedure FF_DELTBL
-- -----------------------------------------------------

USE `cnap_portal`;
DROP procedure IF EXISTS `cnap_portal`.`FF_DELTBL`;

DELIMITER $$
USE `cnap_portal`$$
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

DELIMITER ;

-- -----------------------------------------------------
-- procedure FF_HELPER_ALTTBL
-- -----------------------------------------------------

USE `cnap_portal`;
DROP procedure IF EXISTS `cnap_portal`.`FF_HELPER_ALTTBL`;

DELIMITER $$
USE `cnap_portal`$$
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

DELIMITER ;

-- -----------------------------------------------------
-- procedure FF_HELPER_SYNCDATA
-- -----------------------------------------------------

USE `cnap_portal`;
DROP procedure IF EXISTS `cnap_portal`.`FF_HELPER_SYNCDATA`;

DELIMITER $$
USE `cnap_portal`$$
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

DELIMITER ;

-- -----------------------------------------------------
-- procedure FF_HELPER_SYNCDATA_DELETE
-- -----------------------------------------------------

USE `cnap_portal`;
DROP procedure IF EXISTS `cnap_portal`.`FF_HELPER_SYNCDATA_DELETE`;

DELIMITER $$
USE `cnap_portal`$$
CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_HELPER_SYNCDATA_DELETE`(
        IN `ID` BIGINT
    )
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

-- -----------------------------------------------------
-- procedure FF_HELPER_SYNCDATA_UPDATE
-- -----------------------------------------------------

USE `cnap_portal`;
DROP procedure IF EXISTS `cnap_portal`.`FF_HELPER_SYNCDATA_UPDATE`;

DELIMITER $$
USE `cnap_portal`$$
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

DELIMITER ;

-- -----------------------------------------------------
-- procedure FF_INITID
-- -----------------------------------------------------

USE `cnap_portal`;
DROP procedure IF EXISTS `cnap_portal`.`FF_INITID`;

DELIMITER $$
USE `cnap_portal`$$
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

DELIMITER ;

-- -----------------------------------------------------
-- procedure FF_RSCLEAR
-- -----------------------------------------------------

USE `cnap_portal`;
DROP procedure IF EXISTS `cnap_portal`.`FF_RSCLEAR`;

DELIMITER $$
USE `cnap_portal`$$
CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_RSCLEAR`(
        IN `IDSTORAGE` INTEGER
    )
    COMMENT 'Предварительная очистка привязок СФ к хранилищам'
BEGIN
	DELETE FROM `ff_registry_storage` where (`storage`=IDSTORAGE);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure FF_RSINIT
-- -----------------------------------------------------

USE `cnap_portal`;
DROP procedure IF EXISTS `cnap_portal`.`FF_RSINIT`;

DELIMITER $$
USE `cnap_portal`$$
CREATE DEFINER=`iasnap`@`%` PROCEDURE `FF_RSINIT`(
        IN `IDREGISTRY` INTEGER,
        IN `IDSTORAGE` INTEGER
    )
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

DELIMITER ;

-- -----------------------------------------------------
-- function FF_isParent
-- -----------------------------------------------------

USE `cnap_portal`;
DROP function IF EXISTS `cnap_portal`.`FF_isParent`;

DELIMITER $$
USE `cnap_portal`$$
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

-- -----------------------------------------------------
-- View `cnap_portal`.`ff_listtables`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `cnap_portal`.`ff_listtables` ;
DROP TABLE IF EXISTS `cnap_portal`.`ff_listtables`;
USE `cnap_portal`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`iasnap`@`%` SQL SECURITY DEFINER VIEW `cnap_portal`.`ff_listtables` AS select lcase(`information_schema`.`tables`.`TABLE_NAME`) AS `TABLE_NAME` from `information_schema`.`tables` where (`information_schema`.`tables`.`TABLE_SCHEMA` = database()) order by `information_schema`.`tables`.`TABLE_NAME`;
USE `cnap_portal`;

DELIMITER $$

USE `cnap_portal`$$
DROP TRIGGER IF EXISTS `cnap_portal`.`ff_registry_AI` $$
USE `cnap_portal`$$
CREATE
DEFINER=`iasnap`@`%`
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
DEFINER=`iasnap`@`%`
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
DROP TRIGGER IF EXISTS `cnap_portal`.`ff_registry_ad` $$
USE `cnap_portal`$$
CREATE
DEFINER=`iasnap`@`%`
TRIGGER `cnap_portal`.`ff_registry_ad`
AFTER DELETE ON `cnap_portal`.`ff_registry`
FOR EACH ROW
begin
	if (@disable_triggers is null) then
		delete from `ff_registry_h` where `owner`= old.id;		
	end if;
end$$


USE `cnap_portal`$$
DROP TRIGGER IF EXISTS `cnap_portal`.`ff_storage_BDEL` $$
USE `cnap_portal`$$
CREATE
DEFINER=`iasnap`@`%`
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
DEFINER=`iasnap`@`%`
TRIGGER `cnap_portal`.`ff_storage_BUPD`
BEFORE UPDATE ON `cnap_portal`.`ff_storage`
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


USE `cnap_portal`$$
DROP TRIGGER IF EXISTS `cnap_portal`.`ff_storage_bins` $$
USE `cnap_portal`$$
CREATE
DEFINER=`iasnap`@`%`
TRIGGER `cnap_portal`.`ff_storage_bins`
BEFORE INSERT ON `cnap_portal`.`ff_storage`
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


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
