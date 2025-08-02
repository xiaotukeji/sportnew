-- 为sport_event表添加address_detail字段
-- 说明：添加单独的详细地址字段，用于存储如"3楼301室"等详细地址信息
-- 执行时间：2024-12-19

-- 检查字段是否已存在
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

-- 为现有数据迁移：从location_detail中分离出address_detail
-- 注意：这个操作需要谨慎执行，建议先备份数据
-- UPDATE `sport_event` 
-- SET `address_detail` = SUBSTRING(`location_detail`, LENGTH(`location`) + 1)
-- WHERE `location_detail` IS NOT NULL 
-- AND `location_detail` != `location` 
-- AND `location_detail` LIKE CONCAT(`location`, '%'); 