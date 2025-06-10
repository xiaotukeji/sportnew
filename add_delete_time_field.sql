-- 添加delete_time字段到sport_event表
-- 请在数据库管理工具中执行此SQL

USE sportnew;

-- 添加delete_time字段
ALTER TABLE `sport_event` ADD COLUMN `delete_time` int(11) DEFAULT NULL COMMENT '删除时间';

-- 验证字段是否添加成功
SHOW COLUMNS FROM `sport_event` LIKE 'delete_time'; 