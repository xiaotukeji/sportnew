-- 为号码牌设置表添加禁用4功能字段
-- 执行时间：2025-01-XX
-- 说明：添加是否禁用包含4的号码功能

-- 添加禁用4字段
ALTER TABLE `sport_event_number_rule` 
ADD COLUMN `disable_number_4` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否禁用包含4的号码(0:不禁用 1:禁用)' 
AFTER `auto_assign_after_registration`;

-- 更新现有记录的默认值
UPDATE `sport_event_number_rule` SET `disable_number_4` = 0 WHERE `disable_number_4` IS NULL;
