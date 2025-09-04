-- 为sport_item表添加缺失的项目设置字段
-- 创建时间：2025-01-31
-- 修改说明：添加项目级别的循环赛、分组、场地等设置字段

-- 为sport_item表添加缺失字段
ALTER TABLE `sport_item` 
ADD COLUMN `is_round_robin` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否循环赛：0否 1是' 
AFTER `allow_duplicate_registration`;

ALTER TABLE `sport_item` 
ADD COLUMN `group_size` int(11) NOT NULL DEFAULT '0' COMMENT '每组人数，0表示不分组' 
AFTER `is_round_robin`;

ALTER TABLE `sport_item` 
ADD COLUMN `venue_count` int(11) NOT NULL DEFAULT '0' COMMENT '需要的场地数量' 
AFTER `group_size`;

ALTER TABLE `sport_item` 
ADD COLUMN `venue_type` varchar(50) NOT NULL DEFAULT '' COMMENT '场地类型' 
AFTER `venue_count`;

-- 添加索引以提高查询性能
ALTER TABLE `sport_item` 
ADD INDEX `idx_is_round_robin` (`is_round_robin`);

ALTER TABLE `sport_item` 
ADD INDEX `idx_group_size` (`group_size`);

ALTER TABLE `sport_item` 
ADD INDEX `idx_venue_type` (`venue_type`);

-- 验证字段添加成功
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    COLUMN_DEFAULT, 
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() 
AND TABLE_NAME = 'sport_item' 
AND COLUMN_NAME IN (
    'is_round_robin',
    'group_size',
    'venue_count',
    'venue_type'
);
