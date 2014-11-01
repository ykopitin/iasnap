USE `cnap_portal` ;

--
INSERT INTO `ff_types` (`id`, `typename`, `systemtype`, `view`, `description`,`visible`) 
VALUES
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
  (15, 'fileedsname', 'VARCHAR(255)', NULL, 'Имя файла',0);

INSERT INTO `ff_registry` (`id`, `parent`, `tablename`, `description`, `protected`, `attaching`, `copying`, `view`) 
VALUES   
  (1, NULL, 'default', 'Корневая родительская свободная форма', 1, 0, 1, NULL),
  (2, 1, 'ref_multiguide', 'Системный справочник многие-ко-многим', 1, 0, 1, NULL),
  (3, 1, 'oneline', 'Однострочный справочник', 1, 0, 1, NULL),
  (4, 3, 'commentline', 'Справочник с комментированием', 1, 0, 0, NULL);

INSERT INTO `ff_registry_h` (`id`, `owner`, `parent`) 
VALUES 
  (1, 1, 1),
  (2, 2, 1),
  (3, 2, 1),
  (4, 3, 1),
  (5, 3, 1),
  (6, 4, 1),
  (7, 4, 1),
  (9, 4, 3);

INSERT INTO `ff_storage` (`id`, `name`, `description`, `subtype`, `type`) 
VALUES  
  (1, 'default', 'Хранилище по умолчанию', 0, 16),
  (2, 'ref_multiguide_storage', 'Хранилище для хранения связок', 0, 17);

INSERT INTO `ff_registry_storage` (`id`, `registry`, `storage`) 
VALUES 
  (1, 1, 1),
  (2, 2, 2);

INSERT INTO `ff_field` (`id`, `formid`, `name`, `type`, `description`, `order`, `protected`, `default`) 
VALUES  
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
  (17, 2, 'owner_field', 2, 'поле документа привязки', 0, 0, NULL),
  (18, 2, 'reference', 5, 'Ссылка на элемент справочника', 0, 0, NULL);

COMMIT;
