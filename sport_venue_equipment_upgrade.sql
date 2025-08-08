-- 场馆设备管理升级脚本
-- 创建时间：2024-12-19
-- 修改说明：新增赛事场馆设备管理功能

-- 1. 修改场地表，添加赛事关联（检查字段是否存在）
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'sport_venue' 
     AND COLUMN_NAME = 'event_id') = 0,
    'ALTER TABLE `sport_venue` ADD COLUMN `event_id` int(11) NOT NULL DEFAULT "0" COMMENT "赛事ID，0表示通用场地" AFTER `id`',
    'SELECT "event_id column already exists" as message'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'sport_venue' 
     AND COLUMN_NAME = 'venue_code') = 0,
    'ALTER TABLE `sport_venue` ADD COLUMN `venue_code` varchar(50) NOT NULL DEFAULT "" COMMENT "场地编码，如：table_1, court_1" AFTER `name`',
    'SELECT "venue_code column already exists" as message'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'sport_venue' 
     AND COLUMN_NAME = 'venue_category') = 0,
    'ALTER TABLE `sport_venue` ADD COLUMN `venue_category` varchar(50) NOT NULL DEFAULT "" COMMENT "场地分类，如：乒乓球台、羽毛球场地" AFTER `venue_code`',
    'SELECT "venue_category column already exists" as message'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'sport_venue' 
     AND COLUMN_NAME = 'is_available') = 0,
    'ALTER TABLE `sport_venue` ADD COLUMN `is_available` tinyint(4) NOT NULL DEFAULT "1" COMMENT "是否可用：0不可用 1可用" AFTER `status`',
    'SELECT "is_available column already exists" as message'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 添加索引（如果不存在）
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'sport_venue' 
     AND INDEX_NAME = 'idx_event_id') = 0,
    'ALTER TABLE `sport_venue` ADD KEY `idx_event_id` (`event_id`)',
    'SELECT "idx_event_id index already exists" as message'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'sport_venue' 
     AND INDEX_NAME = 'idx_venue_code') = 0,
    'ALTER TABLE `sport_venue` ADD KEY `idx_venue_code` (`venue_code`)',
    'SELECT "idx_venue_code index already exists" as message'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2. 创建项目场地分配表
DROP TABLE IF EXISTS `sport_item_venue_assignment`;
CREATE TABLE `sport_item_venue_assignment` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `item_id` int(11) NOT NULL COMMENT '比赛项目ID',
    `venue_id` int(11) NOT NULL COMMENT '场地ID',
    `assignment_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '分配类型：1独占 2共享',
    `start_time` int(11) DEFAULT NULL COMMENT '开始使用时间',
    `end_time` int(11) DEFAULT NULL COMMENT '结束使用时间',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_item_venue` (`item_id`,`venue_id`),
    KEY `idx_item_id` (`item_id`),
    KEY `idx_venue_id` (`venue_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目场地分配表';

-- 3. 创建场地使用时间表
DROP TABLE IF EXISTS `sport_venue_schedule`;
CREATE TABLE `sport_venue_schedule` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `venue_id` int(11) NOT NULL COMMENT '场地ID',
    `item_id` int(11) DEFAULT NULL COMMENT '比赛项目ID',
    `match_id` int(11) DEFAULT NULL COMMENT '具体比赛ID',
    `start_time` int(11) NOT NULL COMMENT '开始时间',
    `end_time` int(11) NOT NULL COMMENT '结束时间',
    `usage_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '使用类型：1比赛 2训练 3其他',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0取消 1已安排 2进行中 3已完成',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_venue_id` (`venue_id`),
    KEY `idx_item_id` (`item_id`),
    KEY `idx_match_id` (`match_id`),
    KEY `idx_time_range` (`start_time`,`end_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='场地使用时间表';

-- 4. 修改项目表，添加场地数量字段（检查字段是否存在）
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'sport_item' 
     AND COLUMN_NAME = 'venue_count') = 0,
    'ALTER TABLE `sport_item` ADD COLUMN `venue_count` int(11) NOT NULL DEFAULT "0" COMMENT "需要的场地数量" AFTER `venue_requirements`',
    'SELECT "venue_count column already exists" as message'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'sport_item' 
     AND COLUMN_NAME = 'venue_type') = 0,
    'ALTER TABLE `sport_item` ADD COLUMN `venue_type` varchar(50) NOT NULL DEFAULT "" COMMENT "场地类型，如：乒乓球台、羽毛球场地" AFTER `venue_count`',
    'SELECT "venue_type column already exists" as message'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 5. 插入场地类型字典数据（如果不存在）
INSERT IGNORE INTO `sport_dict` (`dict_type`, `dict_name`, `dict_code`, `description`, `sort`, `status`, `remark`, `create_time`, `update_time`) VALUES
('venue_type', '场地类型', 'venue_type', '场地类型字典', 11, 1, '乒乓球台、羽毛球场地等', UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 6. 插入场地类型字典项数据（如果不存在）
INSERT IGNORE INTO `sport_dict_item` (`dict_id`, `item_name`, `item_value`, `item_code`, `description`, `sort`, `status`, `remark`) 
SELECT 
    d.id as dict_id,
    '乒乓球台' as item_name,
    'pingpong_table' as item_value,
    'pingpong_table' as item_code,
    '乒乓球比赛台' as description,
    1 as sort,
    1 as status,
    NULL as remark
FROM `sport_dict` d 
WHERE d.dict_type = 'venue_type' AND d.dict_code = 'venue_type'
AND NOT EXISTS (
    SELECT 1 FROM `sport_dict_item` di 
    WHERE di.dict_id = d.id AND di.item_code = 'pingpong_table'
);

INSERT IGNORE INTO `sport_dict_item` (`dict_id`, `item_name`, `item_value`, `item_code`, `description`, `sort`, `status`, `remark`) 
SELECT 
    d.id as dict_id,
    '羽毛球场地' as item_name,
    'badminton_court' as item_value,
    'badminton_court' as item_code,
    '羽毛球比赛场地' as description,
    2 as sort,
    1 as status,
    NULL as remark
FROM `sport_dict` d 
WHERE d.dict_type = 'venue_type' AND d.dict_code = 'venue_type'
AND NOT EXISTS (
    SELECT 1 FROM `sport_dict_item` di 
    WHERE di.dict_id = d.id AND di.item_code = 'badminton_court'
);

INSERT IGNORE INTO `sport_dict_item` (`dict_id`, `item_name`, `item_value`, `item_code`, `description`, `sort`, `status`, `remark`) 
SELECT 
    d.id as dict_id,
    '篮球场' as item_name,
    'basketball_court' as item_value,
    'basketball_court' as item_code,
    '篮球比赛场地' as description,
    3 as sort,
    1 as status,
    NULL as remark
FROM `sport_dict` d 
WHERE d.dict_type = 'venue_type' AND d.dict_code = 'venue_type'
AND NOT EXISTS (
    SELECT 1 FROM `sport_dict_item` di 
    WHERE di.dict_id = d.id AND di.item_code = 'basketball_court'
);

INSERT IGNORE INTO `sport_dict_item` (`dict_id`, `item_name`, `item_value`, `item_code`, `description`, `sort`, `status`, `remark`) 
SELECT 
    d.id as dict_id,
    '足球场' as item_name,
    'football_field' as item_value,
    'football_field' as item_code,
    '足球比赛场地' as description,
    4 as sort,
    1 as status,
    NULL as remark
FROM `sport_dict` d 
WHERE d.dict_type = 'venue_type' AND d.dict_code = 'venue_type'
AND NOT EXISTS (
    SELECT 1 FROM `sport_dict_item` di 
    WHERE di.dict_id = d.id AND di.item_code = 'football_field'
);

INSERT IGNORE INTO `sport_dict_item` (`dict_id`, `item_name`, `item_value`, `item_code`, `description`, `sort`, `status`, `remark`) 
SELECT 
    d.id as dict_id,
    '网球场' as item_name,
    'tennis_court' as item_value,
    'tennis_court' as item_code,
    '网球比赛场地' as description,
    5 as sort,
    1 as status,
    NULL as remark
FROM `sport_dict` d 
WHERE d.dict_type = 'venue_type' AND d.dict_code = 'venue_type'
AND NOT EXISTS (
    SELECT 1 FROM `sport_dict_item` di 
    WHERE di.dict_id = d.id AND di.item_code = 'tennis_court'
);

INSERT IGNORE INTO `sport_dict_item` (`dict_id`, `item_name`, `item_value`, `item_code`, `description`, `sort`, `status`, `remark`) 
SELECT 
    d.id as dict_id,
    '排球场' as item_name,
    'volleyball_court' as item_value,
    'volleyball_court' as item_code,
    '排球比赛场地' as description,
    6 as sort,
    1 as status,
    NULL as remark
FROM `sport_dict` d 
WHERE d.dict_type = 'venue_type' AND d.dict_code = 'venue_type'
AND NOT EXISTS (
    SELECT 1 FROM `sport_dict_item` di 
    WHERE di.dict_id = d.id AND di.item_code = 'volleyball_court'
);

INSERT IGNORE INTO `sport_dict_item` (`dict_id`, `item_name`, `item_value`, `item_code`, `description`, `sort`, `status`, `remark`) 
SELECT 
    d.id as dict_id,
    '田径跑道' as item_name,
    'track' as item_value,
    'track' as item_code,
    '田径比赛跑道' as description,
    7 as sort,
    1 as status,
    NULL as remark
FROM `sport_dict` d 
WHERE d.dict_type = 'venue_type' AND d.dict_code = 'venue_type'
AND NOT EXISTS (
    SELECT 1 FROM `sport_dict_item` di 
    WHERE di.dict_id = d.id AND di.item_code = 'track'
);

INSERT IGNORE INTO `sport_dict_item` (`dict_id`, `item_name`, `item_value`, `item_code`, `description`, `sort`, `status`, `remark`) 
SELECT 
    d.id as dict_id,
    '游泳池' as item_name,
    'swimming_pool' as item_value,
    'swimming_pool' as item_code,
    '游泳比赛池' as description,
    8 as sort,
    1 as status,
    NULL as remark
FROM `sport_dict` d 
WHERE d.dict_type = 'venue_type' AND d.dict_code = 'venue_type'
AND NOT EXISTS (
    SELECT 1 FROM `sport_dict_item` di 
    WHERE di.dict_id = d.id AND di.item_code = 'swimming_pool'
);

INSERT IGNORE INTO `sport_dict_item` (`dict_id`, `item_name`, `item_value`, `item_code`, `description`, `sort`, `status`, `remark`) 
SELECT 
    d.id as dict_id,
    '其他' as item_name,
    'other' as item_value,
    'other' as item_code,
    '其他类型场地' as description,
    9 as sort,
    1 as status,
    NULL as remark
FROM `sport_dict` d 
WHERE d.dict_type = 'venue_type' AND d.dict_code = 'venue_type'
AND NOT EXISTS (
    SELECT 1 FROM `sport_dict_item` di 
    WHERE di.dict_id = d.id AND di.item_code = 'other'
);

-- 7. 插入分配类型字典数据（如果不存在）
INSERT IGNORE INTO `sport_dict` (`dict_type`, `dict_name`, `dict_code`, `description`, `sort`, `status`, `remark`, `create_time`, `update_time`) VALUES
('assignment_type', '分配类型', 'assignment_type', '场地分配类型字典', 12, 1, '独占、共享等', UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 8. 插入分配类型字典项数据（如果不存在）
INSERT IGNORE INTO `sport_dict_item` (`dict_id`, `item_name`, `item_value`, `item_code`, `description`, `sort`, `status`, `remark`) 
SELECT 
    d.id as dict_id,
    '独占' as item_name,
    '1' as item_value,
    'exclusive' as item_code,
    '独占使用' as description,
    1 as sort,
    1 as status,
    NULL as remark
FROM `sport_dict` d 
WHERE d.dict_type = 'assignment_type' AND d.dict_code = 'assignment_type'
AND NOT EXISTS (
    SELECT 1 FROM `sport_dict_item` di 
    WHERE di.dict_id = d.id AND di.item_code = 'exclusive'
);

INSERT IGNORE INTO `sport_dict_item` (`dict_id`, `item_name`, `item_value`, `item_code`, `description`, `sort`, `status`, `remark`) 
SELECT 
    d.id as dict_id,
    '共享' as item_name,
    '2' as item_value,
    'shared' as item_code,
    '共享使用' as description,
    2 as sort,
    1 as status,
    NULL as remark
FROM `sport_dict` d 
WHERE d.dict_type = 'assignment_type' AND d.dict_code = 'assignment_type'
AND NOT EXISTS (
    SELECT 1 FROM `sport_dict_item` di 
    WHERE di.dict_id = d.id AND di.item_code = 'shared'
);

-- 9. 插入使用类型字典数据（如果不存在）
INSERT IGNORE INTO `sport_dict` (`dict_type`, `dict_name`, `dict_code`, `description`, `sort`, `status`, `remark`, `create_time`, `update_time`) VALUES
('usage_type', '使用类型', 'usage_type', '场地使用类型字典', 13, 1, '比赛、训练等', UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 10. 插入使用类型字典项数据（如果不存在）
INSERT IGNORE INTO `sport_dict_item` (`dict_id`, `item_name`, `item_value`, `item_code`, `description`, `sort`, `status`, `remark`) 
SELECT 
    d.id as dict_id,
    '比赛' as item_name,
    '1' as item_value,
    'competition' as item_code,
    '正式比赛' as description,
    1 as sort,
    1 as status,
    NULL as remark
FROM `sport_dict` d 
WHERE d.dict_type = 'usage_type' AND d.dict_code = 'usage_type'
AND NOT EXISTS (
    SELECT 1 FROM `sport_dict_item` di 
    WHERE di.dict_id = d.id AND di.item_code = 'competition'
);

INSERT IGNORE INTO `sport_dict_item` (`dict_id`, `item_name`, `item_value`, `item_code`, `description`, `sort`, `status`, `remark`) 
SELECT 
    d.id as dict_id,
    '训练' as item_name,
    '2' as item_value,
    'training' as item_code,
    '训练使用' as description,
    2 as sort,
    1 as status,
    NULL as remark
FROM `sport_dict` d 
WHERE d.dict_type = 'usage_type' AND d.dict_code = 'usage_type'
AND NOT EXISTS (
    SELECT 1 FROM `sport_dict_item` di 
    WHERE di.dict_id = d.id AND di.item_code = 'training'
);

INSERT IGNORE INTO `sport_dict_item` (`dict_id`, `item_name`, `item_value`, `item_code`, `description`, `sort`, `status`, `remark`) 
SELECT 
    d.id as dict_id,
    '其他' as item_name,
    '3' as item_value,
    'other' as item_code,
    '其他用途' as description,
    3 as sort,
    1 as status,
    NULL as remark
FROM `sport_dict` d 
WHERE d.dict_type = 'usage_type' AND d.dict_code = 'usage_type'
AND NOT EXISTS (
    SELECT 1 FROM `sport_dict_item` di 
    WHERE di.dict_id = d.id AND di.item_code = 'other'
); 