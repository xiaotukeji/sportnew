-- 为sport_item表添加项目级别设置字段
-- 创建时间：2025-07-31
-- 修改说明：添加每个比赛项目的具体设置字段

-- 为sport_item表添加项目设置字段
ALTER TABLE `sport_item` 
ADD COLUMN `registration_fee` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '报名费（元）' 
AFTER `venue_requirements`;

ALTER TABLE `sport_item` 
ADD COLUMN `max_participants` int(11) NOT NULL DEFAULT '0' COMMENT '人数限制，0表示不限制' 
AFTER `registration_fee`;

ALTER TABLE `sport_item` 
ADD COLUMN `rounds` int(11) NOT NULL DEFAULT '0' COMMENT '比赛轮次' 
AFTER `max_participants`;

ALTER TABLE `sport_item` 
ADD COLUMN `allow_duplicate_registration` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否允许重复报名：0不允许 1允许' 
AFTER `rounds`;

-- 添加索引以提高查询性能
ALTER TABLE `sport_item` 
ADD INDEX `idx_registration_fee` (`registration_fee`);

ALTER TABLE `sport_item` 
ADD INDEX `idx_max_participants` (`max_participants`);

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
    'registration_fee',
    'max_participants',
    'rounds',
    'allow_duplicate_registration'
); 