-- 为sport_item表确保备注字段存在
-- 创建时间：2025-07-31
-- 修改说明：确保sport_item表有remark字段用于项目特殊备注

-- 检查sport_item表是否存在remark字段
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    COLUMN_DEFAULT, 
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() 
AND TABLE_NAME = 'sport_item' 
AND COLUMN_NAME = 'remark';

-- 如果remark字段不存在，则添加
SET @remark_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'sport_item' 
    AND COLUMN_NAME = 'remark'
);

SET @sql = IF(@remark_exists = 0, 
    'ALTER TABLE `sport_item` ADD COLUMN `remark` varchar(255) DEFAULT NULL COMMENT ''备注'' AFTER `status`',
    'SELECT ''remark字段已存在，无需添加'' AS message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 验证字段状态
SELECT 
    'sport_item表备注字段状态' AS table_info,
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    COLUMN_DEFAULT, 
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() 
AND TABLE_NAME = 'sport_item' 
AND COLUMN_NAME = 'remark'; 