-- 删除禁用号码功能相关字段
-- 执行时间：2025-01-XX
-- 说明：删除禁用号码功能，简化号码牌设置

-- 删除禁用号码字段
ALTER TABLE `sport_event_number_rule` DROP COLUMN `disabled_numbers`;

-- 注意：此操作会永久删除禁用号码数据，请确保不再需要此功能
