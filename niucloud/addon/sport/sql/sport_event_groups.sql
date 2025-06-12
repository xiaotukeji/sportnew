-- 赛事自定义分组表
CREATE TABLE IF NOT EXISTS `sport_event_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '分组ID',
  `event_id` int(11) NOT NULL DEFAULT '0' COMMENT '赛事ID',
  `group_name` varchar(100) NOT NULL DEFAULT '' COMMENT '分组名称',
  `group_type` varchar(50) NOT NULL DEFAULT 'custom' COMMENT '分组类型：age(年龄组)、grade(年级组)、custom(自定义)',
  `description` varchar(500) NOT NULL DEFAULT '' COMMENT '分组描述',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_event_id` (`event_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='赛事自定义分组表'; 