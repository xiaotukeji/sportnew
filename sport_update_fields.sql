-- Sport插件数据库字段升级脚本
-- 执行时间：2024-03-22
-- 说明：为sport_event表添加member_id、location_detail、latitude、longitude字段

-- 添加member_id字段
ALTER TABLE `sport_event` ADD COLUMN `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '发布者ID' AFTER `organizer_type`;

-- 添加location_detail字段  
ALTER TABLE `sport_event` ADD COLUMN `location_detail` varchar(500) DEFAULT NULL COMMENT '详细地址' AFTER `location`;

-- 添加latitude字段
ALTER TABLE `sport_event` ADD COLUMN `latitude` decimal(10,7) DEFAULT NULL COMMENT '纬度' AFTER `location_detail`;

-- 添加longitude字段
ALTER TABLE `sport_event` ADD COLUMN `longitude` decimal(10,7) DEFAULT NULL COMMENT '经度' AFTER `latitude`;

-- 添加member_id索引
ALTER TABLE `sport_event` ADD KEY `idx_member_id` (`member_id`);

-- 更新现有数据的member_id字段（通过organizer表关联获取）
UPDATE `sport_event` se 
INNER JOIN `sport_organizer` so ON se.organizer_id = so.id 
SET se.member_id = so.member_id 
WHERE se.member_id = 0; 