-- 修复sport_venue表字段问题
-- 创建时间：2024-12-19
-- 修改说明：添加缺失的venue_type字段，修复字段名不匹配问题

-- 1. 添加venue_type字段（如果不存在）
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'sport_venue' 
     AND COLUMN_NAME = 'venue_type') = 0,
    'ALTER TABLE `sport_venue` ADD COLUMN `venue_type` varchar(50) NOT NULL DEFAULT "" COMMENT "场地类型编码，如：pingpong_table, badminton_court" AFTER `venue_category`',
    'SELECT "venue_type column already exists" as message'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2. 如果venue_type字段为空，从type字段复制数据
UPDATE `sport_venue` SET `venue_type` = `type` WHERE `venue_type` = "" OR `venue_type` IS NULL;

-- 3. 如果venue_category字段为空，从type字段复制数据
UPDATE `sport_venue` SET `venue_category` = `type` WHERE `venue_category` = "" OR `venue_category` IS NULL;

-- 4. 添加venue_type索引（如果不存在）
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'sport_venue' 
     AND INDEX_NAME = 'idx_venue_type') = 0,
    'ALTER TABLE `sport_venue` ADD KEY `idx_venue_type` (`venue_type`)',
    'SELECT "idx_venue_type index already exists" as message'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 5. 显示修复结果
SELECT 
    'sport_venue表字段修复完成' as message,
    COUNT(*) as total_venues,
    COUNT(CASE WHEN venue_type != "" THEN 1 END) as venues_with_type,
    COUNT(CASE WHEN venue_category != "" THEN 1 END) as venues_with_category
FROM `sport_venue`; 