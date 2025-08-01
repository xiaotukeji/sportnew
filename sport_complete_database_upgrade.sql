-- Sport插件完整数据库升级脚本
-- 执行时间：2025-07-31
-- 修改说明：按顺序执行所有必要的数据库升级

-- ============================================
-- 第一步：为sport_event表添加年龄组相关字段
-- ============================================
SELECT '=== 开始添加年龄组字段 ===' AS step_info;

-- 检查age_groups字段是否存在
SET @age_groups_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'sport_event' 
    AND COLUMN_NAME = 'age_groups'
);

-- 如果不存在则添加
SET @sql1 = IF(@age_groups_exists = 0, 
    'ALTER TABLE `sport_event` ADD COLUMN `age_groups` text COMMENT ''年龄组设置，JSON格式，如：["不限年龄","U8","U10","U12"]'' AFTER `remark`',
    'SELECT ''age_groups字段已存在'' AS message'
);

PREPARE stmt1 FROM @sql1;
EXECUTE stmt1;
DEALLOCATE PREPARE stmt1;

-- 检查age_group_display字段是否存在
SET @age_group_display_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'sport_event' 
    AND COLUMN_NAME = 'age_group_display'
);

-- 如果不存在则添加
SET @sql2 = IF(@age_group_display_exists = 0, 
    'ALTER TABLE `sport_event` ADD COLUMN `age_group_display` tinyint(4) NOT NULL DEFAULT ''0'' COMMENT ''年龄组显示方式：0不显示 1显示'' AFTER `age_groups`',
    'SELECT ''age_group_display字段已存在'' AS message'
);

PREPARE stmt2 FROM @sql2;
EXECUTE stmt2;
DEALLOCATE PREPARE stmt2;

-- 为现有数据设置默认值
UPDATE `sport_event` SET 
`age_groups` = '["不限年龄"]',
`age_group_display` = 0 
WHERE `age_groups` IS NULL;

-- 添加索引（检查是否存在）
SET @age_group_display_index_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.STATISTICS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'sport_event' 
    AND INDEX_NAME = 'idx_age_group_display'
);

SET @sql_index1 = IF(@age_group_display_index_exists = 0, 
    'ALTER TABLE `sport_event` ADD INDEX `idx_age_group_display` (`age_group_display`)',
    'SELECT ''idx_age_group_display索引已存在'' AS message'
);

PREPARE stmt_index1 FROM @sql_index1;
EXECUTE stmt_index1;
DEALLOCATE PREPARE stmt_index1;

SELECT '=== 年龄组字段添加完成 ===' AS step_complete;

-- ============================================
-- 第二步：为sport_event表添加赛事设置字段
-- ============================================
SELECT '=== 开始添加赛事设置字段 ===' AS step_info;

-- 检查并添加registration_start_time字段
SET @reg_start_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'sport_event' 
    AND COLUMN_NAME = 'registration_start_time'
);

SET @sql3 = IF(@reg_start_exists = 0, 
    'ALTER TABLE `sport_event` ADD COLUMN `registration_start_time` varchar(20) DEFAULT NULL COMMENT ''报名开始时间，格式：YYYY-MM-DD'' AFTER `age_group_display`',
    'SELECT ''registration_start_time字段已存在'' AS message'
);

PREPARE stmt3 FROM @sql3;
EXECUTE stmt3;
DEALLOCATE PREPARE stmt3;

-- 检查并添加registration_end_time字段
SET @reg_end_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'sport_event' 
    AND COLUMN_NAME = 'registration_end_time'
);

SET @sql4 = IF(@reg_end_exists = 0, 
    'ALTER TABLE `sport_event` ADD COLUMN `registration_end_time` varchar(20) DEFAULT NULL COMMENT ''报名结束时间，格式：YYYY-MM-DD'' AFTER `registration_start_time`',
    'SELECT ''registration_end_time字段已存在'' AS message'
);

PREPARE stmt4 FROM @sql4;
EXECUTE stmt4;
DEALLOCATE PREPARE stmt4;

-- 检查并添加registration_fee字段
SET @reg_fee_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'sport_event' 
    AND COLUMN_NAME = 'registration_fee'
);

SET @sql5 = IF(@reg_fee_exists = 0, 
    'ALTER TABLE `sport_event` ADD COLUMN `registration_fee` decimal(10,2) NOT NULL DEFAULT ''0.00'' COMMENT ''报名费（元）'' AFTER `registration_end_time`',
    'SELECT ''registration_fee字段已存在'' AS message'
);

PREPARE stmt5 FROM @sql5;
EXECUTE stmt5;
DEALLOCATE PREPARE stmt5;

-- 检查并添加max_participants字段
SET @max_participants_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'sport_event' 
    AND COLUMN_NAME = 'max_participants'
);

SET @sql6 = IF(@max_participants_exists = 0, 
    'ALTER TABLE `sport_event` ADD COLUMN `max_participants` int(11) NOT NULL DEFAULT ''0'' COMMENT ''总报名人数限制，0表示不限制'' AFTER `registration_fee`',
    'SELECT ''max_participants字段已存在'' AS message'
);

PREPARE stmt6 FROM @sql6;
EXECUTE stmt6;
DEALLOCATE PREPARE stmt6;

-- 检查并添加group_size字段
SET @group_size_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'sport_event' 
    AND COLUMN_NAME = 'group_size'
);

SET @sql7 = IF(@group_size_exists = 0, 
    'ALTER TABLE `sport_event` ADD COLUMN `group_size` int(11) NOT NULL DEFAULT ''0'' COMMENT ''每组人数'' AFTER `max_participants`',
    'SELECT ''group_size字段已存在'' AS message'
);

PREPARE stmt7 FROM @sql7;
EXECUTE stmt7;
DEALLOCATE PREPARE stmt7;

-- 检查并添加rounds字段
SET @rounds_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'sport_event' 
    AND COLUMN_NAME = 'rounds'
);

SET @sql8 = IF(@rounds_exists = 0, 
    'ALTER TABLE `sport_event` ADD COLUMN `rounds` int(11) NOT NULL DEFAULT ''0'' COMMENT ''比赛轮次'' AFTER `group_size`',
    'SELECT ''rounds字段已存在'' AS message'
);

PREPARE stmt8 FROM @sql8;
EXECUTE stmt8;
DEALLOCATE PREPARE stmt8;

-- 检查并添加allow_duplicate_registration字段
SET @allow_duplicate_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'sport_event' 
    AND COLUMN_NAME = 'allow_duplicate_registration'
);

SET @sql9 = IF(@allow_duplicate_exists = 0, 
    'ALTER TABLE `sport_event` ADD COLUMN `allow_duplicate_registration` tinyint(4) NOT NULL DEFAULT ''0'' COMMENT ''是否允许重复报名：0不允许 1允许'' AFTER `rounds`',
    'SELECT ''allow_duplicate_registration字段已存在'' AS message'
);

PREPARE stmt9 FROM @sql9;
EXECUTE stmt9;
DEALLOCATE PREPARE stmt9;

-- 检查并添加show_participant_count字段
SET @show_participant_count_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'sport_event' 
    AND COLUMN_NAME = 'show_participant_count'
);

SET @sql10 = IF(@show_participant_count_exists = 0, 
    'ALTER TABLE `sport_event` ADD COLUMN `show_participant_count` tinyint(4) NOT NULL DEFAULT ''1'' COMMENT ''是否显示报名人数：0不显示 1显示'' AFTER `allow_duplicate_registration`',
    'SELECT ''show_participant_count字段已存在'' AS message'
);

PREPARE stmt10 FROM @sql10;
EXECUTE stmt10;
DEALLOCATE PREPARE stmt10;

-- 检查并添加show_progress字段
SET @show_progress_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'sport_event' 
    AND COLUMN_NAME = 'show_progress'
);

SET @sql11 = IF(@show_progress_exists = 0, 
    'ALTER TABLE `sport_event` ADD COLUMN `show_progress` tinyint(4) NOT NULL DEFAULT ''1'' COMMENT ''是否显示比赛进度：0不显示 1显示'' AFTER `show_participant_count`',
    'SELECT ''show_progress字段已存在'' AS message'
);

PREPARE stmt11 FROM @sql11;
EXECUTE stmt11;
DEALLOCATE PREPARE stmt11;

-- 添加索引（检查是否存在）
SET @registration_time_index_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.STATISTICS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'sport_event' 
    AND INDEX_NAME = 'idx_registration_time'
);

SET @sql_index2 = IF(@registration_time_index_exists = 0, 
    'ALTER TABLE `sport_event` ADD INDEX `idx_registration_time` (`registration_start_time`, `registration_end_time`)',
    'SELECT ''idx_registration_time索引已存在'' AS message'
);

PREPARE stmt_index2 FROM @sql_index2;
EXECUTE stmt_index2;
DEALLOCATE PREPARE stmt_index2;

SET @status_sort_index_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.STATISTICS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'sport_event' 
    AND INDEX_NAME = 'idx_status_sort'
);

SET @sql_index3 = IF(@status_sort_index_exists = 0, 
    'ALTER TABLE `sport_event` ADD INDEX `idx_status_sort` (`status`, `sort`)',
    'SELECT ''idx_status_sort索引已存在'' AS message'
);

PREPARE stmt_index3 FROM @sql_index3;
EXECUTE stmt_index3;
DEALLOCATE PREPARE stmt_index3;

SELECT '=== 赛事设置字段添加完成 ===' AS step_complete;

-- ============================================
-- 第三步：为sport_item表添加项目设置字段
-- ============================================
SELECT '=== 开始添加项目设置字段 ===' AS step_info;

-- 检查并添加rounds字段到sport_item表
SET @item_rounds_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'sport_item' 
    AND COLUMN_NAME = 'rounds'
);

SET @sql12 = IF(@item_rounds_exists = 0, 
    'ALTER TABLE `sport_item` ADD COLUMN `rounds` int(11) NOT NULL DEFAULT ''0'' COMMENT ''比赛轮次'' AFTER `referee_requirements`',
    'SELECT ''sport_item.rounds字段已存在'' AS message'
);

PREPARE stmt12 FROM @sql12;
EXECUTE stmt12;
DEALLOCATE PREPARE stmt12;

-- 检查并添加allow_duplicate_registration字段到sport_item表
SET @item_allow_duplicate_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'sport_item' 
    AND COLUMN_NAME = 'allow_duplicate_registration'
);

SET @sql13 = IF(@item_allow_duplicate_exists = 0, 
    'ALTER TABLE `sport_item` ADD COLUMN `allow_duplicate_registration` tinyint(4) NOT NULL DEFAULT ''0'' COMMENT ''是否允许重复报名：0不允许 1允许'' AFTER `rounds`',
    'SELECT ''sport_item.allow_duplicate_registration字段已存在'' AS message'
);

PREPARE stmt13 FROM @sql13;
EXECUTE stmt13;
DEALLOCATE PREPARE stmt13;

-- 添加索引（检查是否存在）
SET @registration_fee_index_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.STATISTICS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'sport_item' 
    AND INDEX_NAME = 'idx_registration_fee'
);

SET @sql_index4 = IF(@registration_fee_index_exists = 0, 
    'ALTER TABLE `sport_item` ADD INDEX `idx_registration_fee` (`registration_fee`)',
    'SELECT ''idx_registration_fee索引已存在'' AS message'
);

PREPARE stmt_index4 FROM @sql_index4;
EXECUTE stmt_index4;
DEALLOCATE PREPARE stmt_index4;

SET @max_participants_index_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.STATISTICS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'sport_item' 
    AND INDEX_NAME = 'idx_max_participants'
);

SET @sql_index5 = IF(@max_participants_index_exists = 0, 
    'ALTER TABLE `sport_item` ADD INDEX `idx_max_participants` (`max_participants`)',
    'SELECT ''idx_max_participants索引已存在'' AS message'
);

PREPARE stmt_index5 FROM @sql_index5;
EXECUTE stmt_index5;
DEALLOCATE PREPARE stmt_index5;

SELECT '=== 项目设置字段添加完成 ===' AS step_complete;

-- ============================================
-- 第四步：确保sport_item表有remark字段
-- ============================================
SELECT '=== 检查项目备注字段 ===' AS step_info;

-- 检查remark字段是否存在
SET @item_remark_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'sport_item' 
    AND COLUMN_NAME = 'remark'
);

SET @sql14 = IF(@item_remark_exists = 0, 
    'ALTER TABLE `sport_item` ADD COLUMN `remark` varchar(255) DEFAULT NULL COMMENT ''备注'' AFTER `status`',
    'SELECT ''sport_item.remark字段已存在'' AS message'
);

PREPARE stmt14 FROM @sql14;
EXECUTE stmt14;
DEALLOCATE PREPARE stmt14;

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