-- 手动修复sport_venue表字段问题
-- 请在数据库中手动执行以下SQL语句

-- 1. 添加venue_type字段（如果不存在）
ALTER TABLE `sport_venue` ADD COLUMN `venue_type` varchar(50) NOT NULL DEFAULT '' COMMENT '场地类型编码，如：pingpong_table, badminton_court' AFTER `venue_category`;

-- 2. 从type字段复制数据到venue_type
UPDATE `sport_venue` SET `venue_type` = `type` WHERE `venue_type` = '' OR `venue_type` IS NULL;

-- 3. 从type字段复制数据到venue_category
UPDATE `sport_venue` SET `venue_category` = `type` WHERE `venue_category` = '' OR `venue_category` IS NULL;

-- 4. 添加venue_type索引
ALTER TABLE `sport_venue` ADD KEY `idx_venue_type` (`venue_type`);

-- 5. 查看修复结果
SELECT 
    COUNT(*) as total_venues,
    COUNT(CASE WHEN venue_type != '' THEN 1 END) as venues_with_type,
    COUNT(CASE WHEN venue_category != '' THEN 1 END) as venues_with_category
FROM `sport_venue`;

-- 6. 查看表结构
DESCRIBE sport_venue; 