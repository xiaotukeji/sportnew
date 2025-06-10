-- 运动会数据库表结构
-- 创建时间：2024-03-21
-- 修改时间：2024-03-22
-- 修改说明：新增sport_organizer表，用于管理主办方信息

-- 数据字典表
DROP TABLE IF EXISTS `sport_dict`;
CREATE TABLE `sport_dict` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `dict_type` varchar(50) NOT NULL COMMENT '字典类型',
    `dict_name` varchar(100) NOT NULL COMMENT '字典名称',
    `dict_code` varchar(50) NOT NULL COMMENT '字典编码',
    `description` text COMMENT '描述',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_type_code` (`dict_type`,`dict_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='数据字典表';

-- 数据字典项表
DROP TABLE IF EXISTS `sport_dict_item`;
CREATE TABLE `sport_dict_item` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `dict_id` int(11) NOT NULL COMMENT '字典ID',
    `item_name` varchar(100) NOT NULL COMMENT '字典项名称',
    `item_value` varchar(50) NOT NULL COMMENT '字典项值',
    `item_code` varchar(50) NOT NULL COMMENT '字典项编码',
    `description` text COMMENT '描述',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_dict_code` (`dict_id`,`item_code`),
    KEY `idx_dict_id` (`dict_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='数据字典项表';

-- 赛事系列表
DROP TABLE IF EXISTS `sport_event_series`;
CREATE TABLE `sport_event_series` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(100) NOT NULL COMMENT '系列赛名称',
    `organizer_id` int(11) NOT NULL COMMENT '主办方ID',
    `member_id` int(11) NOT NULL COMMENT '发布者ID',
    `description` text COMMENT '系列赛描述',
    `start_year` int(11) NOT NULL COMMENT '开始年份',
    `end_year` int(11) DEFAULT NULL COMMENT '结束年份',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='赛事系列表';

-- 赛事表
DROP TABLE IF EXISTS `sport_event`;
CREATE TABLE `sport_event` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `series_id` int(11) DEFAULT NULL COMMENT '系列赛ID，可为空表示独立赛事',
    `name` varchar(100) NOT NULL COMMENT '赛事名称',
    `event_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '赛事类型：1独立赛事 2系列赛事',
    `year` int(11) NOT NULL COMMENT '举办年份',
    `season` varchar(20) DEFAULT NULL COMMENT '赛季',
    `start_time` int(11) NOT NULL COMMENT '开始时间',
    `end_time` int(11) NOT NULL COMMENT '结束时间',
    `location` varchar(200) NOT NULL COMMENT '举办地点',
    `location_detail` varchar(500) DEFAULT NULL COMMENT '详细地址',
    `latitude` decimal(10,7) DEFAULT NULL COMMENT '纬度',
    `longitude` decimal(10,7) DEFAULT NULL COMMENT '经度',
    `organizer_id` int(11) NOT NULL COMMENT '主办方ID',
    `organizer_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '举办者类型：1个人 2单位',
    `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '发布者ID',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态：0待发布 1进行中 2已结束 3已作废',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    `delete_time` int(11) DEFAULT NULL COMMENT '删除时间',
    PRIMARY KEY (`id`),
    KEY `idx_series_id` (`series_id`),
    KEY `idx_member_id` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='赛事表';

-- 项目大类表
DROP TABLE IF EXISTS `sport_category`;
CREATE TABLE `sport_category` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL COMMENT '大类名称',
    `code` varchar(50) NOT NULL COMMENT '大类编码',
    `icon` varchar(255) DEFAULT NULL COMMENT '图标',
    `description` text COMMENT '描述',
    `parent_id` int(11) DEFAULT '0' COMMENT '父级ID，0表示顶级',
    `level` int(11) NOT NULL DEFAULT '1' COMMENT '层级，1级为顶级',
    `path` varchar(255) DEFAULT NULL COMMENT '层级路径，如：1,2,3',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_code` (`code`),
    KEY `idx_parent_id` (`parent_id`),
    KEY `idx_path` (`path`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目大类表';

-- 项目小类表
DROP TABLE IF EXISTS `sport_subcategory`;
CREATE TABLE `sport_subcategory` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `category_id` int(11) NOT NULL COMMENT '大类ID',
    `name` varchar(50) NOT NULL COMMENT '小类名称',
    `code` varchar(50) NOT NULL COMMENT '小类编码',
    `description` text COMMENT '描述',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_code` (`code`),
    KEY `idx_category_id` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目小类表';

-- 基础项目表
DROP TABLE IF EXISTS `sport_base_item`;
CREATE TABLE `sport_base_item` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `category_id` int(11) NOT NULL COMMENT '项目大类ID',
    `name` varchar(100) NOT NULL COMMENT '项目名称',
    `code` varchar(50) NOT NULL COMMENT '项目编码',
    `competition_type` tinyint(4) NOT NULL COMMENT '比赛类型：1个人 2团体 3混合',
    `gender_type` tinyint(4) NOT NULL COMMENT '性别类型：1男子 2女子 3混合',
    `age_group` varchar(50) DEFAULT NULL COMMENT '年龄组别',
    `description` text COMMENT '项目描述',
    `rules` text COMMENT '比赛规则',
    `equipment` text COMMENT '所需器材',
    `venue_requirements` text COMMENT '场地要求',
    `referee_requirements` text COMMENT '裁判要求',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_code` (`code`),
    KEY `idx_category_id` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='基础项目表';

-- 比赛项目表
DROP TABLE IF EXISTS `sport_item`;
CREATE TABLE `sport_item` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `event_id` int(11) NOT NULL COMMENT '赛事ID',
    `base_item_id` int(11) NOT NULL COMMENT '基础项目ID',
    `category_id` int(11) NOT NULL COMMENT '项目大类ID',
    `name` varchar(100) NOT NULL COMMENT '项目名称',
    `competition_type` tinyint(4) NOT NULL COMMENT '比赛类型：1个人 2团体 3混合',
    `gender_type` tinyint(4) NOT NULL COMMENT '性别类型：1男子 2女子 3混合',
    `age_group` varchar(50) DEFAULT NULL COMMENT '年龄组别',
    `max_participants` int(11) DEFAULT NULL COMMENT '最大参赛人数',
    `min_participants` int(11) DEFAULT NULL COMMENT '最小参赛人数',
    `registration_fee` decimal(10,2) DEFAULT '0.00' COMMENT '报名费用',
    `rules` text COMMENT '比赛规则',
    `equipment` text COMMENT '所需器材',
    `venue_requirements` text COMMENT '场地要求',
    `referee_requirements` text COMMENT '裁判要求',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_event_id` (`event_id`),
    KEY `idx_base_item_id` (`base_item_id`),
    KEY `idx_category_id` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='比赛项目表';

-- 项目报名限制表
DROP TABLE IF EXISTS `sport_item_limit`;
CREATE TABLE `sport_item_limit` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `item_id` int(11) NOT NULL COMMENT '比赛项目ID',
    `limit_type` tinyint(4) NOT NULL COMMENT '限制类型：1年龄 2性别 3人数 4其他',
    `limit_value` varchar(255) NOT NULL COMMENT '限制值',
    `description` varchar(255) DEFAULT NULL COMMENT '限制说明',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_item_id` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目报名限制表';

-- 项目规则表
DROP TABLE IF EXISTS `sport_item_rule`;
CREATE TABLE `sport_item_rule` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `item_id` int(11) NOT NULL COMMENT '比赛项目ID',
    `rule_type` varchar(50) NOT NULL COMMENT '规则类型',
    `rule_content` text NOT NULL COMMENT '规则内容',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_item_id` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目规则表';

-- 项目器材表
DROP TABLE IF EXISTS `sport_item_equipment`;
CREATE TABLE `sport_item_equipment` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `item_id` int(11) NOT NULL COMMENT '比赛项目ID',
    `equipment_name` varchar(100) NOT NULL COMMENT '器材名称',
    `equipment_type` varchar(50) NOT NULL COMMENT '器材类型',
    `quantity` int(11) NOT NULL DEFAULT '1' COMMENT '数量',
    `description` text COMMENT '器材说明',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_item_id` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目器材表';

-- 项目场地要求表
DROP TABLE IF EXISTS `sport_item_venue`;
CREATE TABLE `sport_item_venue` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `item_id` int(11) NOT NULL COMMENT '比赛项目ID',
    `venue_type` varchar(50) NOT NULL COMMENT '场地类型',
    `venue_size` varchar(100) DEFAULT NULL COMMENT '场地尺寸',
    `venue_requirements` text COMMENT '场地要求',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_item_id` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目场地要求表';

-- 项目裁判要求表
DROP TABLE IF EXISTS `sport_item_referee`;
CREATE TABLE `sport_item_referee` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `item_id` int(11) NOT NULL COMMENT '比赛项目ID',
    `referee_type` varchar(50) NOT NULL COMMENT '裁判类型',
    `referee_level` varchar(50) DEFAULT NULL COMMENT '裁判等级要求',
    `quantity` int(11) NOT NULL DEFAULT '1' COMMENT '数量',
    `requirements` text COMMENT '具体要求',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_item_id` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目裁判要求表';

-- 参赛人员表
DROP TABLE IF EXISTS `sport_athlete`;
CREATE TABLE `sport_athlete` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `member_id` int(11) DEFAULT NULL COMMENT '会员ID',
    `event_id` int(11) NOT NULL COMMENT '赛事ID',
    `team_id` int(11) NOT NULL COMMENT '参赛单位ID',
    `name` varchar(50) NOT NULL COMMENT '姓名',
    `gender` tinyint(4) NOT NULL COMMENT '性别：1男 2女',
    `id_card` varchar(18) NOT NULL COMMENT '身份证号',
    `phone` varchar(20) NOT NULL COMMENT '手机号',
    `birth_date` date NOT NULL COMMENT '出生日期',
    `photo` varchar(255) DEFAULT NULL COMMENT '照片',
    `registration_type` tinyint(4) NOT NULL COMMENT '报名类型：1会员报名 2领队导入',
    `registration_time` int(11) NOT NULL COMMENT '报名时间',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_member_id` (`member_id`),
    KEY `idx_event_team` (`event_id`,`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='参赛人员表';

-- 团体赛成员表
DROP TABLE IF EXISTS `sport_team_member`;
CREATE TABLE `sport_team_member` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `team_id` int(11) NOT NULL COMMENT '团队ID',
    `athlete_id` int(11) NOT NULL COMMENT '运动员ID',
    `position` varchar(50) DEFAULT NULL COMMENT '位置/角色',
    `is_captain` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否队长',
    `is_substitute` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否替补',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_team_athlete` (`team_id`,`athlete_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='团体赛成员表';

-- 具体比赛表
DROP TABLE IF EXISTS `sport_match`;
CREATE TABLE `sport_match` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `event_id` int(11) NOT NULL COMMENT '赛事ID',
    `item_id` int(11) NOT NULL COMMENT '项目ID',
    `match_name` varchar(100) NOT NULL COMMENT '比赛名称',
    `match_type` tinyint(4) NOT NULL COMMENT '比赛类型：1预赛 2复赛 3半决赛 4决赛',
    `match_number` varchar(20) NOT NULL COMMENT '比赛编号',
    `start_time` int(11) NOT NULL COMMENT '开始时间',
    `end_time` int(11) NOT NULL COMMENT '结束时间',
    `venue_id` int(11) NOT NULL COMMENT '场地ID',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0未开始 1进行中 2已结束',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_event_item` (`event_id`,`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='具体比赛表';

-- 比赛成绩表
DROP TABLE IF EXISTS `sport_score`;
CREATE TABLE `sport_score` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `match_id` int(11) NOT NULL COMMENT '比赛ID',
    `athlete_id` int(11) DEFAULT NULL COMMENT '运动员ID',
    `team_id` int(11) DEFAULT NULL COMMENT '团队ID',
    `score_type` varchar(50) NOT NULL COMMENT '成绩类型',
    `score_value` decimal(10,2) NOT NULL COMMENT '成绩值',
    `unit` varchar(20) DEFAULT NULL COMMENT '单位',
    `rank` int(11) DEFAULT NULL COMMENT '排名',
    `referee_id` int(11) NOT NULL COMMENT '裁判ID',
    `is_valid` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否有效',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_match_id` (`match_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='比赛成绩表';

-- 接力赛顺序表
DROP TABLE IF EXISTS `sport_relay_order`;
CREATE TABLE `sport_relay_order` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `team_id` int(11) NOT NULL COMMENT '团队ID',
    `match_id` int(11) NOT NULL COMMENT '比赛ID',
    `athlete_id` int(11) NOT NULL COMMENT '运动员ID',
    `order_number` int(11) NOT NULL COMMENT '出场顺序',
    `lane_number` int(11) NOT NULL COMMENT '泳道/跑道号',
    `is_substitute` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否替补',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_team_match` (`team_id`,`match_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='接力赛顺序表';

-- 报名记录表
DROP TABLE IF EXISTS `sport_registration`;
CREATE TABLE `sport_registration` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `event_id` int(11) NOT NULL COMMENT '赛事ID',
    `item_id` int(11) NOT NULL COMMENT '项目ID',
    `athlete_id` int(11) NOT NULL COMMENT '参赛人员ID',
    `team_id` int(11) NOT NULL COMMENT '参赛单位ID',
    `registration_type` tinyint(4) NOT NULL COMMENT '报名类型：1会员报名 2领队导入',
    `registration_time` int(11) NOT NULL COMMENT '报名时间',
    `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态：0待审核 1已通过 2已拒绝',
    `payment_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '支付状态：0未支付 1已支付',
    `payment_time` int(11) DEFAULT NULL COMMENT '支付时间',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_event_item` (`event_id`,`item_id`),
    KEY `idx_athlete_id` (`athlete_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='报名记录表';

-- 批量导入记录表
DROP TABLE IF EXISTS `sport_import_record`;
CREATE TABLE `sport_import_record` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `event_id` int(11) NOT NULL COMMENT '赛事ID',
    `team_id` int(11) NOT NULL COMMENT '参赛单位ID',
    `file_name` varchar(255) NOT NULL COMMENT '文件名',
    `file_url` varchar(255) NOT NULL COMMENT '文件地址',
    `total_count` int(11) NOT NULL COMMENT '总记录数',
    `success_count` int(11) NOT NULL DEFAULT '0' COMMENT '成功数',
    `fail_count` int(11) NOT NULL DEFAULT '0' COMMENT '失败数',
    `operator_id` int(11) NOT NULL COMMENT '操作人ID',
    `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态：0处理中 1完成 2失败',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `error_log` text COMMENT '错误日志',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_event_team` (`event_id`,`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='批量导入记录表';

-- 大屏展示配置表
DROP TABLE IF EXISTS `sport_display_config`;
CREATE TABLE `sport_display_config` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `event_id` int(11) NOT NULL COMMENT '赛事ID',
    `display_type` varchar(50) NOT NULL COMMENT '展示类型：1比赛信息 2实时成绩 3排名 4对阵 5回放',
    `template_id` int(11) NOT NULL COMMENT '模板ID',
    `config` text NOT NULL COMMENT '配置信息(JSON)',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_event_id` (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='大屏展示配置表';

-- 大屏展示模板表
DROP TABLE IF EXISTS `sport_display_template`;
CREATE TABLE `sport_display_template` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(100) NOT NULL COMMENT '模板名称',
    `type` varchar(50) NOT NULL COMMENT '模板类型',
    `layout` text NOT NULL COMMENT '布局配置(JSON)',
    `style` text NOT NULL COMMENT '样式配置(JSON)',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='大屏展示模板表';

-- 大屏展示数据表
DROP TABLE IF EXISTS `sport_display_data`;
CREATE TABLE `sport_display_data` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `event_id` int(11) NOT NULL COMMENT '赛事ID',
    `match_id` int(11) NOT NULL COMMENT '比赛ID',
    `data_type` varchar(50) NOT NULL COMMENT '数据类型',
    `content` text NOT NULL COMMENT '展示内容(JSON)',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_event_match` (`event_id`,`match_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='大屏展示数据表';

-- 场地表
DROP TABLE IF EXISTS `sport_venue`;
CREATE TABLE `sport_venue` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(100) NOT NULL COMMENT '场地名称',
    `type` varchar(50) NOT NULL COMMENT '场地类型',
    `capacity` int(11) DEFAULT NULL COMMENT '容纳人数',
    `location` varchar(200) NOT NULL COMMENT '位置',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='场地表';

-- 场地设施表
DROP TABLE IF EXISTS `sport_venue_facility`;
CREATE TABLE `sport_venue_facility` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `venue_id` int(11) NOT NULL COMMENT '场地ID',
    `facility_name` varchar(100) NOT NULL COMMENT '设施名称',
    `facility_type` varchar(50) NOT NULL COMMENT '设施类型',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_venue_id` (`venue_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='场地设施表';

-- AI报告模板表
DROP TABLE IF EXISTS `sport_ai_report_template`;
CREATE TABLE `sport_ai_report_template` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(100) NOT NULL COMMENT '模板名称',
    `template_type` varchar(50) NOT NULL COMMENT '模板类型',
    `content` text NOT NULL COMMENT '模板内容',
    `variables` text COMMENT '变量定义(JSON)',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI报告模板表';

-- AI报告生成记录表
DROP TABLE IF EXISTS `sport_ai_report`;
CREATE TABLE `sport_ai_report` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `event_id` int(11) NOT NULL COMMENT '赛事ID',
    `template_id` int(11) NOT NULL COMMENT '模板ID',
    `report_type` varchar(50) NOT NULL COMMENT '报告类型',
    `content` text NOT NULL COMMENT '报告内容',
    `data_source` text COMMENT '数据来源(JSON)',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态：0生成中 1已完成 2失败',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_event_id` (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI报告生成记录表';

-- 赛事协办单位表
DROP TABLE IF EXISTS `sport_event_co_organizer`;
CREATE TABLE `sport_event_co_organizer` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `event_id` int(11) NOT NULL COMMENT '赛事ID',
    `organizer_id` int(11) NOT NULL COMMENT '协办单位ID',
    `organizer_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '单位类型：1协办单位 2赞助商 3支持单位',
    `organizer_name` varchar(100) NOT NULL COMMENT '单位名称',
    `logo` varchar(255) DEFAULT NULL COMMENT '单位logo',
    `contact_name` varchar(50) DEFAULT NULL COMMENT '联系人',
    `contact_phone` varchar(20) DEFAULT NULL COMMENT '联系电话',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_event_id` (`event_id`),
    KEY `idx_organizer_id` (`organizer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='赛事协办单位表';

-- 系列赛协办单位表
DROP TABLE IF EXISTS `sport_series_co_organizer`;
CREATE TABLE `sport_series_co_organizer` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `series_id` int(11) NOT NULL COMMENT '系列赛ID',
    `organizer_id` int(11) NOT NULL COMMENT '协办单位ID',
    `organizer_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '单位类型：1协办单位 2赞助商 3支持单位',
    `organizer_name` varchar(100) NOT NULL COMMENT '单位名称',
    `logo` varchar(255) DEFAULT NULL COMMENT '单位logo',
    `contact_name` varchar(50) DEFAULT NULL COMMENT '联系人',
    `contact_phone` varchar(20) DEFAULT NULL COMMENT '联系电话',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_series_id` (`series_id`),
    KEY `idx_organizer_id` (`organizer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系列赛协办单位表';

-- 项目记录表
DROP TABLE IF EXISTS `sport_record`;
CREATE TABLE `sport_record` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `base_item_id` int(11) NOT NULL COMMENT '基础项目ID',
    `record_type` tinyint(4) NOT NULL COMMENT '记录类型：1世界纪录 2洲际纪录 3国家纪录 4省级纪录 5市级纪录 6校级纪录',
    `record_level` varchar(50) NOT NULL COMMENT '记录级别',
    `record_value` decimal(10,2) NOT NULL COMMENT '记录值',
    `unit` varchar(20) DEFAULT NULL COMMENT '单位',
    `athlete_id` int(11) DEFAULT NULL COMMENT '运动员ID',
    `team_id` int(11) DEFAULT NULL COMMENT '团队ID',
    `athlete_name` varchar(50) DEFAULT NULL COMMENT '运动员姓名',
    `team_name` varchar(100) DEFAULT NULL COMMENT '团队名称',
    `event_id` int(11) DEFAULT NULL COMMENT '赛事ID',
    `event_name` varchar(100) DEFAULT NULL COMMENT '赛事名称',
    `match_id` int(11) DEFAULT NULL COMMENT '比赛ID',
    `match_name` varchar(100) DEFAULT NULL COMMENT '比赛名称',
    `record_date` date NOT NULL COMMENT '记录日期',
    `venue` varchar(200) DEFAULT NULL COMMENT '比赛地点',
    `is_verified` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否认证：0未认证 1已认证',
    `verify_time` int(11) DEFAULT NULL COMMENT '认证时间',
    `verify_by` int(11) DEFAULT NULL COMMENT '认证人ID',
    `verify_remark` varchar(255) DEFAULT NULL COMMENT '认证备注',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_base_item_id` (`base_item_id`),
    KEY `idx_record_type` (`record_type`),
    KEY `idx_athlete_id` (`athlete_id`),
    KEY `idx_team_id` (`team_id`),
    KEY `idx_event_id` (`event_id`),
    KEY `idx_match_id` (`match_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目记录表';

-- 项目记录认证表
DROP TABLE IF EXISTS `sport_record_verify`;
CREATE TABLE `sport_record_verify` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `record_id` int(11) NOT NULL COMMENT '记录ID',
    `verify_type` tinyint(4) NOT NULL COMMENT '认证类型：1自动认证 2人工认证 3系统认证',
    `verify_status` tinyint(4) NOT NULL COMMENT '认证状态：0待认证 1已认证 2已拒绝',
    `verify_by` int(11) DEFAULT NULL COMMENT '认证人ID',
    `verify_time` int(11) DEFAULT NULL COMMENT '认证时间',
    `verify_remark` varchar(255) DEFAULT NULL COMMENT '认证备注',
    `evidence` text COMMENT '认证依据',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_record_id` (`record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目记录认证表';

-- 项目记录历史表
DROP TABLE IF EXISTS `sport_record_history`;
CREATE TABLE `sport_record_history` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `record_id` int(11) NOT NULL COMMENT '记录ID',
    `base_item_id` int(11) NOT NULL COMMENT '基础项目ID',
    `record_type` tinyint(4) NOT NULL COMMENT '记录类型：1世界纪录 2洲际纪录 3国家纪录 4省级纪录 5市级纪录 6校级纪录',
    `record_level` varchar(50) NOT NULL COMMENT '记录级别',
    `record_value` decimal(10,2) NOT NULL COMMENT '记录值',
    `unit` varchar(20) DEFAULT NULL COMMENT '单位',
    `athlete_id` int(11) DEFAULT NULL COMMENT '运动员ID',
    `team_id` int(11) DEFAULT NULL COMMENT '团队ID',
    `athlete_name` varchar(50) DEFAULT NULL COMMENT '运动员姓名',
    `team_name` varchar(100) DEFAULT NULL COMMENT '团队名称',
    `event_id` int(11) DEFAULT NULL COMMENT '赛事ID',
    `event_name` varchar(100) DEFAULT NULL COMMENT '赛事名称',
    `match_id` int(11) DEFAULT NULL COMMENT '比赛ID',
    `match_name` varchar(100) DEFAULT NULL COMMENT '比赛名称',
    `record_date` date NOT NULL COMMENT '记录日期',
    `venue` varchar(200) DEFAULT NULL COMMENT '比赛地点',
    `is_verified` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否认证：0未认证 1已认证',
    `verify_time` int(11) DEFAULT NULL COMMENT '认证时间',
    `verify_by` int(11) DEFAULT NULL COMMENT '认证人ID',
    `verify_remark` varchar(255) DEFAULT NULL COMMENT '认证备注',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_record_id` (`record_id`),
    KEY `idx_base_item_id` (`base_item_id`),
    KEY `idx_record_type` (`record_type`),
    KEY `idx_athlete_id` (`athlete_id`),
    KEY `idx_team_id` (`team_id`),
    KEY `idx_event_id` (`event_id`),
    KEY `idx_match_id` (`match_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目记录历史表';

-- 项目记录统计表
DROP TABLE IF EXISTS `sport_record_statistics`;
CREATE TABLE `sport_record_statistics` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `base_item_id` int(11) NOT NULL COMMENT '基础项目ID',
    `record_type` tinyint(4) NOT NULL COMMENT '记录类型：1世界纪录 2洲际纪录 3国家纪录 4省级纪录 5市级纪录 6校级纪录',
    `record_level` varchar(50) NOT NULL COMMENT '记录级别',
    `best_record` decimal(10,2) NOT NULL COMMENT '最好记录',
    `best_record_date` date DEFAULT NULL COMMENT '最好记录日期',
    `best_athlete_id` int(11) DEFAULT NULL COMMENT '最好记录运动员ID',
    `best_team_id` int(11) DEFAULT NULL COMMENT '最好记录团队ID',
    `best_athlete_name` varchar(50) DEFAULT NULL COMMENT '最好记录运动员姓名',
    `best_team_name` varchar(100) DEFAULT NULL COMMENT '最好记录团队名称',
    `record_count` int(11) NOT NULL DEFAULT '0' COMMENT '记录数量',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_item_type_level` (`base_item_id`,`record_type`,`record_level`),
    KEY `idx_base_item_id` (`base_item_id`),
    KEY `idx_record_type` (`record_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目记录统计表';

-- 主办方表
DROP TABLE IF EXISTS `sport_organizer`;
CREATE TABLE `sport_organizer` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `organizer_id` int(11) NOT NULL COMMENT '主办方ID',
    `member_id` int(11) DEFAULT '0' COMMENT '发布者ID',
    `organizer_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '主办方类型：1个人 2单位',
    `organizer_name` varchar(100) NOT NULL COMMENT '主办方名称',
    `organizer_license` varchar(255) DEFAULT NULL COMMENT '单位证件',
    `organizer_license_img` varchar(500) DEFAULT NULL COMMENT '机构证件图片',
    `contact_name` varchar(50) DEFAULT NULL COMMENT '联系人',
    `contact_phone` varchar(20) DEFAULT NULL COMMENT '联系电话',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_organizer_id` (`organizer_id`),
    KEY `idx_member_id` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='主办方表';



DROP TABLE IF EXISTS `member`;
CREATE TABLE `member` (
  `member_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `member_no` varchar(255) NOT NULL DEFAULT '' COMMENT '会员编码',
  `pid` int(11) NOT NULL DEFAULT '0' COMMENT '推广会员id',
  `username` varchar(255) NOT NULL DEFAULT '' COMMENT '会员用户名',
  `mobile` varchar(20) NOT NULL DEFAULT '' COMMENT '手机号',
  `password` varchar(255) NOT NULL DEFAULT '' COMMENT '会员密码',
  `nickname` varchar(255) NOT NULL DEFAULT '' COMMENT '会员昵称',
  `headimg` varchar(1000) NOT NULL DEFAULT '' COMMENT '会员头像',
  `member_level` int(11) NOT NULL DEFAULT '0' COMMENT '会员等级',
  `member_label` varchar(255) NOT NULL DEFAULT '' COMMENT '会员标签',
  `wx_openid` varchar(255) NOT NULL DEFAULT '' COMMENT '微信用户openid',
  `weapp_openid` varchar(255) NOT NULL DEFAULT '' COMMENT '微信小程序openid',
  `wx_unionid` varchar(255) NOT NULL DEFAULT '' COMMENT '微信unionid',
  `ali_openid` varchar(255) NOT NULL DEFAULT '' COMMENT '支付宝账户id',
  `douyin_openid` varchar(255) NOT NULL DEFAULT '' COMMENT '抖音小程序openid',
  `register_channel` varchar(255) NOT NULL DEFAULT 'H5' COMMENT '注册来源',
  `register_type` varchar(255) NOT NULL DEFAULT '' COMMENT '注册方式',
  `login_ip` varchar(255) NOT NULL DEFAULT '' COMMENT '当前登录ip',
  `login_type` varchar(255) NOT NULL DEFAULT 'h5' COMMENT '当前登录的操作终端类型',
  `login_channel` varchar(255) NOT NULL DEFAULT '',
  `login_count` int(11) NOT NULL DEFAULT '0' COMMENT '登录次数',
  `login_time` int(11) NOT NULL DEFAULT '0' COMMENT '当前登录时间',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '注册时间',
  `last_visit_time` int(11) NOT NULL DEFAULT '0' COMMENT '最后访问时间',
  `last_consum_time` int(11) NOT NULL DEFAULT '0' COMMENT '最后消费时间',
  `sex` tinyint(4) NOT NULL DEFAULT '0' COMMENT '性别 0保密 1男 2女',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '用户状态  用户状态默认为1',
  `birthday` varchar(20) NOT NULL DEFAULT '' COMMENT '出生日期',
  `point` int(11) NOT NULL DEFAULT '0' COMMENT '可用积分',
  `point_get` int(11) NOT NULL DEFAULT '0' COMMENT '累计获取积分',
  `balance` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '可用余额',
  `balance_get` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '累计获取余额',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '可用余额（可提现）',
  `money_get` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '累计获取余额（可提现）',
  `money_cash_outing` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '提现中余额（可提现）',
  `growth` int(11) NOT NULL DEFAULT '0' COMMENT '成长值',
  `growth_get` int(11) NOT NULL DEFAULT '0' COMMENT '累计获得成长值',
  `commission` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '当前佣金',
  `commission_get` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '佣金获取',
  `commission_cash_outing` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '提现中佣金',
  `is_member` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否是会员',
  `member_time` int(11) NOT NULL DEFAULT '0' COMMENT '成为会员时间',
  `is_del` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0正常  1已删除',
  `province_id` int(11) NOT NULL DEFAULT '0' COMMENT '省id',
  `city_id` int(11) NOT NULL DEFAULT '0' COMMENT '市id',
  `district_id` int(11) NOT NULL DEFAULT '0' COMMENT '区县id',
  `address` varchar(255) NOT NULL DEFAULT '' COMMENT '详细地址',
  `location` varchar(255) NOT NULL DEFAULT '' COMMENT '定位地址',
  `delete_time` int(11) NOT NULL DEFAULT '0' COMMENT '删除时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`member_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='会员表';




-- 导航配置表
DROP TABLE IF EXISTS `sport_nav_config`;
CREATE TABLE `sport_nav_config` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL COMMENT '导航名称',
    `icon` varchar(255) NOT NULL COMMENT '未选中图标',
    `selected_icon` varchar(255) NOT NULL COMMENT '选中图标',
    `path` varchar(100) NOT NULL COMMENT '跳转路径',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='导航配置表';

-- 初始化导航配置数据
INSERT INTO `sport_nav_config` (`name`, `icon`, `selected_icon`, `path`, `sort`, `status`, `remark`, `create_time`, `update_time`) VALUES
('首页', '/static/images/nav/home.png', '/static/images/nav/home_selected.png', '/addon/sport/pages/index/index', 1, 1, '首页导航', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('赛事', '/static/images/nav/event.png', '/static/images/nav/event_selected.png', '/addon/sport/pages/event/index', 2, 1, '赛事导航', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('我的', '/static/images/nav/my.png', '/static/images/nav/my_selected.png', '/addon/sport/pages/member/index', 3, 1, '我的导航', UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 初始化基础数据字典数据
INSERT INTO `sport_dict` (`dict_type`, `dict_name`, `dict_code`, `description`, `sort`, `status`, `remark`, `create_time`, `update_time`) VALUES
('gender', '性别', 'gender', '性别字典', 1, 1, '性别选项', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('competition_type', '比赛类型', 'competition_type', '比赛类型字典', 2, 1, '个人赛、团体赛等', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('match_type', '比赛阶段', 'match_type', '比赛阶段字典', 3, 1, '预赛、复赛、半决赛、决赛等', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('registration_type', '报名类型', 'registration_type', '报名类型字典', 4, 1, '会员报名、领队导入等', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('payment_status', '支付状态', 'payment_status', '支付状态字典', 5, 1, '未支付、已支付等', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('venue_type', '场地类型', 'venue_type', '场地类型字典', 6, 1, '田径场、游泳馆等', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('facility_type', '设施类型', 'facility_type', '设施类型字典', 7, 1, '计时器、计分牌等', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('display_type', '展示类型', 'display_type', '展示类型字典', 8, 1, '比赛信息、实时成绩等', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('report_type', '报告类型', 'report_type', '报告类型字典', 9, 1, '赛事总结、成绩分析等', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('organizer_type', '单位类型', 'organizer_type', '单位类型字典', 10, 1, '主办方、协办方、赞助商等', UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 初始化字典项数据
INSERT INTO `sport_dict_item` (`dict_id`, `item_name`, `item_value`, `item_code`, `description`, `sort`, `status`, `remark`) VALUES
-- 性别
(1, '男', '1', 'male', '男性', 1, 1, NULL),
(1, '女', '2', 'female', '女性', 2, 1, NULL),
-- 比赛类型
(2, '个人赛', '1', 'individual', '个人比赛', 1, 1, NULL),
(2, '团体赛', '2', 'team', '团体比赛', 2, 1, NULL),
(2, '混合赛', '3', 'mixed', '混合比赛', 3, 1, NULL),
-- 比赛阶段
(3, '预赛', '1', 'preliminary', '预赛阶段', 1, 1, NULL),
(3, '复赛', '2', 'quarterfinal', '复赛阶段', 2, 1, NULL),
(3, '半决赛', '3', 'semifinal', '半决赛阶段', 3, 1, NULL),
(3, '决赛', '4', 'final', '决赛阶段', 4, 1, NULL),
-- 报名类型
(4, '会员报名', '1', 'member', '会员自行报名', 1, 1, NULL),
(4, '领队导入', '2', 'team_leader', '领队批量导入', 2, 1, NULL),
-- 支付状态
(5, '未支付', '0', 'unpaid', '未支付状态', 1, 1, NULL),
(5, '已支付', '1', 'paid', '已支付状态', 2, 1, NULL),
-- 场地类型
(6, '田径场', '1', 'track', '田径比赛场地', 1, 1, NULL),
(6, '游泳馆', '2', 'swimming', '游泳比赛场地', 2, 1, NULL),
(6, '篮球场', '3', 'basketball', '篮球比赛场地', 3, 1, NULL),
-- 设施类型
(7, '计时器', '1', 'timer', '计时设备', 1, 1, NULL),
(7, '计分牌', '2', 'scoreboard', '计分设备', 2, 1, NULL),
(7, '摄像机', '3', 'camera', '摄像设备', 3, 1, NULL),
-- 展示类型
(8, '比赛信息', '1', 'match_info', '比赛基本信息', 1, 1, NULL),
(8, '实时成绩', '2', 'real_time_score', '实时比赛成绩', 2, 1, NULL),
(8, '排名', '3', 'ranking', '比赛排名', 3, 1, NULL),
(8, '对阵', '4', 'matchup', '比赛对阵', 4, 1, NULL),
(8, '回放', '5', 'replay', '比赛回放', 5, 1, NULL),
-- 报告类型
(9, '赛事总结', '1', 'event_summary', '赛事总结报告', 1, 1, NULL),
(9, '成绩分析', '2', 'score_analysis', '成绩分析报告', 2, 1, NULL),
(9, '数据统计', '3', 'statistics', '数据统计报告', 3, 1, NULL),
-- 单位类型
(10, '协办单位', '1', 'co_organizer', '赛事协办单位', 1, 1, NULL),
(10, '赞助商', '2', 'sponsor', '赛事赞助商', 2, 1, NULL),
(10, '支持单位', '3', 'supporter', '赛事支持单位', 3, 1, NULL); 