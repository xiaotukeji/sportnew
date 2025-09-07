-- ========================================
-- Sport插件号码牌设置功能数据库表
-- 创建时间: 2025-01-27
-- 功能: 支持赛事号码牌规则设置和分配管理
-- ========================================

-- ----------------------------
-- Table structure for sport_event_number_rule
-- 赛事号码牌规则表
-- ----------------------------
DROP TABLE IF EXISTS `sport_event_number_rule`;
CREATE TABLE `sport_event_number_rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `event_id` int(11) NOT NULL COMMENT '赛事ID',
  `rule_name` varchar(100) NOT NULL DEFAULT '默认规则' COMMENT '规则名称',
  `numbering_mode` tinyint(4) NOT NULL DEFAULT '1' COMMENT '编号模式：1系统分配 2用户自选',
  `prefix` varchar(10) DEFAULT NULL COMMENT '号码前缀，可为空',
  `number_length` tinyint(4) NOT NULL DEFAULT '3' COMMENT '数字位数：1-6位',
  `start_number` int(11) NOT NULL DEFAULT '1' COMMENT '起始号码',
  `end_number` int(11) NOT NULL DEFAULT '999' COMMENT '结束号码',
  `step` int(11) NOT NULL DEFAULT '1' COMMENT '编号步长',
  `reserved_numbers` text COMMENT '保留号码列表，JSON格式存储',
  `disabled_numbers` text COMMENT '禁用号码列表，JSON格式存储',
  `allow_athlete_choice` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否允许运动员自选：0不允许 1允许',
  `choice_time_window` int(11) DEFAULT '7' COMMENT '自选时间窗口（天）',
  `choice_rules` varchar(50) DEFAULT 'first_come_first_served' COMMENT '自选规则：first_come_first_served先到先得',
  `auto_assign_after_registration` tinyint(4) NOT NULL DEFAULT '1' COMMENT '报名后是否自动分配：0不自动 1自动',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_event_id` (`event_id`),
  KEY `idx_event_id` (`event_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='赛事号码牌规则表';

-- ----------------------------
-- Table structure for sport_event_number_assignment
-- 赛事号码分配表
-- ----------------------------
DROP TABLE IF EXISTS `sport_event_number_assignment`;
CREATE TABLE `sport_event_number_assignment` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `event_id` int(11) NOT NULL COMMENT '赛事ID',
  `registration_id` int(11) NOT NULL COMMENT '报名记录ID',
  `athlete_id` int(11) NOT NULL COMMENT '参赛人员ID',
  `item_id` int(11) NOT NULL COMMENT '项目ID',
  `number_plate` varchar(20) NOT NULL COMMENT '分配的号码牌',
  `assignment_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '分配类型：1系统分配 2用户自选',
  `assignment_time` int(11) NOT NULL COMMENT '分配时间',
  `assignment_by` int(11) DEFAULT NULL COMMENT '分配者ID（系统分配为0，用户自选为用户ID）',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0已取消 1有效',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_event_registration` (`event_id`, `registration_id`),
  UNIQUE KEY `uk_event_number` (`event_id`, `number_plate`),
  KEY `idx_event_id` (`event_id`),
  KEY `idx_registration_id` (`registration_id`),
  KEY `idx_athlete_id` (`athlete_id`),
  KEY `idx_item_id` (`item_id`),
  KEY `idx_number_plate` (`number_plate`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='赛事号码分配表';

-- ----------------------------
-- 为sport_registration表添加号码牌相关字段（如果需要的话）
-- 注意：这个ALTER语句是可选的，因为号码分配信息已经存储在专门的表中
-- ----------------------------
-- ALTER TABLE `sport_registration` ADD COLUMN `number_plate` varchar(20) DEFAULT NULL COMMENT '分配的号码牌' AFTER `payment_time`;

-- ----------------------------
-- 插入示例数据（可选）
-- ----------------------------
-- INSERT INTO `sport_event_number_rule` (
--   `event_id`, `rule_name`, `numbering_mode`, `prefix`, `number_length`, 
--   `start_number`, `end_number`, `step`, `reserved_numbers`, `disabled_numbers`,
--   `allow_athlete_choice`, `choice_time_window`, `choice_rules`, 
--   `auto_assign_after_registration`, `status`, `create_time`, `update_time`
-- ) VALUES (
--   1, '默认规则', 1, 'A', 3, 1, 999, 1, 
--   '["666","888","999"]', '["4","44","444"]', 
--   0, 7, 'first_come_first_served', 1, 1, 
--   UNIX_TIMESTAMP(), UNIX_TIMESTAMP()
-- );

-- ========================================
-- 表结构说明
-- ========================================

/*
sport_event_number_rule 表字段说明：
- event_id: 关联到sport_event表，每个赛事只能有一个号码牌规则
- numbering_mode: 1=系统分配，2=用户自选
- prefix: 号码前缀，如"A"、"B"等，可为空表示纯数字
- number_length: 数字部分位数，如3表示001-999
- start_number/end_number: 号码范围
- step: 编号步长，如1表示连续编号，2表示跳号
- reserved_numbers: 保留号码，JSON格式，如["666","888","999"]
- disabled_numbers: 禁用号码，JSON格式，如["4","44","444"]
- allow_athlete_choice: 是否允许运动员自选号码
- choice_time_window: 自选时间窗口，单位天
- choice_rules: 自选规则，目前支持先到先得

sport_event_number_assignment 表字段说明：
- event_id: 关联到sport_event表
- registration_id: 关联到sport_registration表
- athlete_id: 关联到sport_athlete表
- item_id: 关联到sport_item表
- number_plate: 实际分配的号码牌，如"A001"、"B123"
- assignment_type: 1=系统分配，2=用户自选
- assignment_time: 分配时间戳
- assignment_by: 分配者ID，系统分配为0，用户自选为用户ID

使用场景：
1. 创建赛事时设置号码牌规则
2. 用户报名时根据规则分配或自选号码
3. 查询和管理号码分配情况
4. 号码冲突检测和验证
*/
