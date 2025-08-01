-- 为sport_event表添加年龄组相关字段
-- 创建时间：2025-07-31
-- 修改说明：添加age_groups和age_group_display字段，用于管理赛事的年龄组设置

-- 为sport_event表添加age_groups字段
ALTER TABLE `sport_event` 
ADD COLUMN `age_groups` text COMMENT '年龄组设置，JSON格式，如：["不限年龄","U8","U10","U12"]' 
AFTER `remark`;

-- 为sport_event表添加age_group_display字段
ALTER TABLE `sport_event` 
ADD COLUMN `age_group_display` tinyint(4) NOT NULL DEFAULT '0' COMMENT '年龄组显示方式：0不显示 1显示' 
AFTER `age_groups`;

-- 为现有数据设置默认值
UPDATE `sport_event` SET 
`age_groups` = '["不限年龄"]',
`age_group_display` = 0 
WHERE `age_groups` IS NULL;

-- 添加索引以提高查询性能
ALTER TABLE `sport_event` 
ADD INDEX `idx_age_group_display` (`age_group_display`);

-- 验证字段添加成功
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    COLUMN_DEFAULT, 
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() 
AND TABLE_NAME = 'sport_event' 
AND COLUMN_NAME IN ('age_groups', 'age_group_display'); 