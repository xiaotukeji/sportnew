-- 为sport_event表添加赛事设置相关字段
-- 创建时间：2025-07-31
-- 修改说明：添加报名设置、比赛设置、显示设置等字段

-- 为sport_event表添加报名相关字段
ALTER TABLE `sport_event` 
ADD COLUMN `registration_start_time` varchar(20) DEFAULT NULL COMMENT '报名开始时间，格式：YYYY-MM-DD' 
AFTER `age_group_display`;

ALTER TABLE `sport_event` 
ADD COLUMN `registration_end_time` varchar(20) DEFAULT NULL COMMENT '报名结束时间，格式：YYYY-MM-DD' 
AFTER `registration_start_time`;

ALTER TABLE `sport_event` 
ADD COLUMN `registration_fee` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '报名费（元）' 
AFTER `registration_end_time`;

ALTER TABLE `sport_event` 
ADD COLUMN `max_participants` int(11) NOT NULL DEFAULT '0' COMMENT '总报名人数限制，0表示不限制' 
AFTER `registration_fee`;

-- 为sport_event表添加比赛设置字段
ALTER TABLE `sport_event` 
ADD COLUMN `group_size` int(11) NOT NULL DEFAULT '0' COMMENT '每组人数' 
AFTER `max_participants`;

ALTER TABLE `sport_event` 
ADD COLUMN `rounds` int(11) NOT NULL DEFAULT '0' COMMENT '比赛轮次' 
AFTER `group_size`;

ALTER TABLE `sport_event` 
ADD COLUMN `allow_duplicate_registration` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否允许重复报名：0不允许 1允许' 
AFTER `rounds`;

-- 为sport_event表添加显示设置字段
ALTER TABLE `sport_event` 
ADD COLUMN `show_participant_count` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否显示报名人数：0不显示 1显示' 
AFTER `allow_duplicate_registration`;

ALTER TABLE `sport_event` 
ADD COLUMN `show_progress` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否显示比赛进度：0不显示 1显示' 
AFTER `show_participant_count`;

-- 添加索引以提高查询性能
ALTER TABLE `sport_event` 
ADD INDEX `idx_registration_time` (`registration_start_time`, `registration_end_time`);

ALTER TABLE `sport_event` 
ADD INDEX `idx_status_sort` (`status`, `sort`);

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
AND COLUMN_NAME IN (
    'registration_start_time',
    'registration_end_time', 
    'registration_fee',
    'max_participants',
    'group_size',
    'rounds',
    'allow_duplicate_registration',
    'show_participant_count',
    'show_progress'
); 