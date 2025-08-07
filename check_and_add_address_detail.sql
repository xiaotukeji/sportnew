-- 检查并添加address_detail字段
-- 执行时间：2024-12-19

-- 第一步：检查字段是否存在
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() 
AND TABLE_NAME = 'sport_event' 
AND COLUMN_NAME = 'address_detail';

-- 第二步：如果字段不存在，则添加字段
SET @sql = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'sport_event' 
     AND COLUMN_NAME = 'address_detail') = 0,
    'ALTER TABLE `sport_event` ADD COLUMN `address_detail` varchar(255) DEFAULT NULL COMMENT ''详细地址（如：3楼301室）'' AFTER `location_detail`',
    'SELECT ''address_detail字段已存在，无需添加'' AS message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 第三步：再次检查字段是否存在
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() 
AND TABLE_NAME = 'sport_event' 
AND COLUMN_NAME = 'address_detail';

-- 第四步：查看表结构
DESCRIBE `sport_event`; 