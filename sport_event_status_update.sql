-- 更新sport_event表的status字段定义
-- 将状态含义从 0禁用 1启用 改为 0待发布 1进行中 2已结束 3已作废

-- 1. 修改字段注释
ALTER TABLE `sport_event` MODIFY COLUMN `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态：0待发布 1进行中 2已结束 3已作废';

-- 2. 更新现有数据的状态
-- 将所有现有的启用状态(1)改为进行中(1)，禁用状态(0)改为已作废(3)
-- 注意：这里假设现有的启用赛事都是进行中的，禁用的都是作废的
-- 实际使用时可能需要根据具体情况调整

-- 如果有现有数据，可以根据实际情况执行以下语句：
-- UPDATE `sport_event` SET `status` = 1 WHERE `status` = 1;  -- 启用状态保持为进行中
-- UPDATE `sport_event` SET `status` = 3 WHERE `status` = 0;  -- 禁用状态改为已作废

-- 3. 如果需要根据时间判断状态，可以使用以下逻辑：
-- UPDATE `sport_event` SET `status` = 0 WHERE `start_time` > UNIX_TIMESTAMP();  -- 未开始的设为待发布
-- UPDATE `sport_event` SET `status` = 1 WHERE `start_time` <= UNIX_TIMESTAMP() AND `end_time` >= UNIX_TIMESTAMP();  -- 进行中的
-- UPDATE `sport_event` SET `status` = 2 WHERE `end_time` < UNIX_TIMESTAMP();  -- 已结束的

-- 注意：执行前请备份数据库！ 