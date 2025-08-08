-- 修复sport_venue表type字段默认值问题
-- 创建时间：2024-12-19

-- 1. 为type字段添加默认值（如果字段存在但没有默认值）
ALTER TABLE `sport_venue` MODIFY COLUMN `type` varchar(50) NOT NULL DEFAULT '' COMMENT '场地类型';

-- 2. 如果venue_type字段为空，从type字段复制数据
UPDATE `sport_venue` SET `venue_type` = `type` WHERE `venue_type` = '' OR `venue_type` IS NULL;

-- 3. 如果venue_category字段为空，从type字段复制数据
UPDATE `sport_venue` SET `venue_category` = `type` WHERE `venue_category` = '' OR `venue_category` IS NULL;

-- 4. 显示修复结果
SELECT 
    'sport_venue表type字段修复完成' as message,
    COUNT(*) as total_venues,
    COUNT(CASE WHEN type != '' THEN 1 END) as venues_with_type,
    COUNT(CASE WHEN venue_type != '' THEN 1 END) as venues_with_venue_type,
    COUNT(CASE WHEN venue_category != '' THEN 1 END) as venues_with_category
FROM `sport_venue`; 