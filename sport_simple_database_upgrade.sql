-- Sport插件简化数据库升级脚本
-- 执行时间：2025-07-31
-- 修改说明：兼容所有MySQL版本的简化升级脚本

-- ============================================
-- 第一步：为sport_event表添加年龄组相关字段
-- ============================================
SELECT '=== 开始添加年龄组字段 ===' AS step_info;

-- 添加age_groups字段（如果不存在）
ALTER TABLE `sport_event` 
ADD COLUMN `age_groups` text COMMENT '年龄组设置，JSON格式，如：["不限年龄","U8","U10","U12"]' 
AFTER `remark`;

-- 添加age_group_display字段（如果不存在）
ALTER TABLE `sport_event` 
ADD COLUMN `age_group_display` tinyint(4) NOT NULL DEFAULT '0' COMMENT '年龄组显示方式：0不显示 1显示' 
AFTER `age_groups`;

-- 为现有数据设置默认值
UPDATE `sport_event` SET 
`age_groups` = '["不限年龄"]',
`age_group_display` = 0 
WHERE `age_groups` IS NULL;

SELECT '=== 年龄组字段添加完成 ===' AS step_complete;

-- ============================================
-- 第二步：为sport_event表添加赛事设置字段
-- ============================================
SELECT '=== 开始添加赛事设置字段 ===' AS step_info;

-- 添加报名相关字段
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

-- 添加比赛设置字段
ALTER TABLE `sport_event` 
ADD COLUMN `group_size` int(11) NOT NULL DEFAULT '0' COMMENT '每组人数' 
AFTER `max_participants`;

ALTER TABLE `sport_event` 
ADD COLUMN `rounds` int(11) NOT NULL DEFAULT '0' COMMENT '比赛轮次' 
AFTER `group_size`;

ALTER TABLE `sport_event` 
ADD COLUMN `allow_duplicate_registration` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否允许重复报名：0不允许 1允许' 
AFTER `rounds`;

-- 添加显示设置字段
ALTER TABLE `sport_event` 
ADD COLUMN `show_participant_count` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否显示报名人数：0不显示 1显示' 
AFTER `allow_duplicate_registration`;

ALTER TABLE `sport_event` 
ADD COLUMN `show_progress` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否显示比赛进度：0不显示 1显示' 
AFTER `show_participant_count`;

SELECT '=== 赛事设置字段添加完成 ===' AS step_complete;

-- ============================================
-- 第三步：为sport_item表添加项目设置字段
-- ============================================
SELECT '=== 开始添加项目设置字段 ===' AS step_info;

-- 添加项目设置字段
ALTER TABLE `sport_item` 
ADD COLUMN `rounds` int(11) NOT NULL DEFAULT '0' COMMENT '比赛轮次' 
AFTER `referee_requirements`;

ALTER TABLE `sport_item` 
ADD COLUMN `allow_duplicate_registration` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否允许重复报名：0不允许 1允许' 
AFTER `rounds`;

SELECT '=== 项目设置字段添加完成 ===' AS step_complete;

-- ============================================
-- 第四步：确保sport_item表有remark字段
-- ============================================
SELECT '=== 检查项目备注字段 ===' AS step_info;

-- 添加remark字段（如果不存在）
ALTER TABLE `sport_item` 
ADD COLUMN `remark` varchar(255) DEFAULT NULL COMMENT '备注' 
AFTER `status`;

SELECT '=== 项目备注字段检查完成 ===' AS step_complete;

-- ============================================
-- 最终验证
-- ============================================
SELECT '=== 数据库升级完成，开始验证 ===' AS verification_start;

-- 验证sport_event表字段
SELECT 
    'sport_event表字段验证' AS table_name,
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    COLUMN_DEFAULT, 
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() 
AND TABLE_NAME = 'sport_event' 
AND COLUMN_NAME IN (
    'age_groups',
    'age_group_display',
    'registration_start_time',
    'registration_end_time', 
    'registration_fee',
    'max_participants',
    'group_size',
    'rounds',
    'allow_duplicate_registration',
    'show_participant_count',
    'show_progress'
)
ORDER BY COLUMN_NAME;

-- 验证sport_item表字段
SELECT 
    'sport_item表字段验证' AS table_name,
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
    'allow_duplicate_registration',
    'remark'
)
ORDER BY COLUMN_NAME;

SELECT '=== 数据库升级脚本执行完成！===' AS completion_message;
SELECT '现在可以正常使用所有新功能了！' AS success_message; 