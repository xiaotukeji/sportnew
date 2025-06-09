-- 修改sport_event表结构，增加经度、纬度和完整地址字段
-- 执行时间：请在备份数据库后执行

-- 增加经度字段
ALTER TABLE `sport_event` ADD COLUMN `lng` varchar(20) DEFAULT NULL COMMENT '经度' AFTER `location`;

-- 增加纬度字段  
ALTER TABLE `sport_event` ADD COLUMN `lat` varchar(20) DEFAULT NULL COMMENT '纬度' AFTER `lng`;

-- 增加完整地址字段
ALTER TABLE `sport_event` ADD COLUMN `full_address` varchar(500) DEFAULT NULL COMMENT '完整地址' AFTER `lat`; 