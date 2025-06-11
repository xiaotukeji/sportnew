-- Sport运动会插件安装脚本
-- 版本：v1.0.0
-- 作者：NiuCloud Team  
-- 创建时间：2024-03-21

-- ============================================
-- 数据表结构创建
-- ============================================

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

-- 参赛人员表
DROP TABLE IF EXISTS `sport_athlete`;
CREATE TABLE `sport_athlete` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `member_id` int(11) NOT NULL COMMENT '用户ID',
    `name` varchar(50) NOT NULL COMMENT '姓名',
    `gender` tinyint(4) NOT NULL COMMENT '性别：1男 2女',
    `birth_date` date DEFAULT NULL COMMENT '出生日期',
    `age` int(11) DEFAULT NULL COMMENT '年龄',
    `id_card` varchar(18) DEFAULT NULL COMMENT '身份证号',
    `phone` varchar(20) DEFAULT NULL COMMENT '联系电话',
    `emergency_contact` varchar(50) DEFAULT NULL COMMENT '紧急联系人',
    `emergency_phone` varchar(20) DEFAULT NULL COMMENT '紧急联系电话',
    `team_name` varchar(100) DEFAULT NULL COMMENT '团队名称',
    `unit_name` varchar(100) DEFAULT NULL COMMENT '单位名称',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_member_id` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='参赛人员表';

-- 报名记录表
DROP TABLE IF EXISTS `sport_registration`;
CREATE TABLE `sport_registration` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `event_id` int(11) NOT NULL COMMENT '赛事ID',
    `item_id` int(11) NOT NULL COMMENT '比赛项目ID',
    `athlete_id` int(11) NOT NULL COMMENT '参赛人员ID',
    `member_id` int(11) NOT NULL COMMENT '用户ID',
    `registration_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '报名类型：1个人报名 2团体报名',
    `team_name` varchar(100) DEFAULT NULL COMMENT '团队名称',
    `team_members` text COMMENT '团队成员JSON',
    `registration_fee` decimal(10,2) DEFAULT '0.00' COMMENT '报名费用',
    `payment_status` tinyint(4) DEFAULT '0' COMMENT '付款状态：0未付款 1已付款 2已退款',
    `payment_time` int(11) DEFAULT NULL COMMENT '付款时间',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态：0待审核 1已通过 2已拒绝 3已取消',
    `audit_time` int(11) DEFAULT NULL COMMENT '审核时间',
    `audit_remark` varchar(255) DEFAULT NULL COMMENT '审核备注',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_event_id` (`event_id`),
    KEY `idx_item_id` (`item_id`),
    KEY `idx_athlete_id` (`athlete_id`),
    KEY `idx_member_id` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='报名记录表';

-- 比赛成绩表
DROP TABLE IF EXISTS `sport_score`;
CREATE TABLE `sport_score` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `event_id` int(11) NOT NULL COMMENT '赛事ID',
    `item_id` int(11) NOT NULL COMMENT '比赛项目ID',
    `registration_id` int(11) NOT NULL COMMENT '报名记录ID',
    `athlete_id` int(11) NOT NULL COMMENT '参赛人员ID',
    `score_value` varchar(50) DEFAULT NULL COMMENT '成绩值',
    `score_type` tinyint(4) DEFAULT '1' COMMENT '成绩类型：1时间 2距离 3分数 4名次',
    `ranking` int(11) DEFAULT NULL COMMENT '排名',
    `is_record` tinyint(4) DEFAULT '0' COMMENT '是否破纪录：0否 1是',
    `record_type` varchar(50) DEFAULT NULL COMMENT '纪录类型',
    `referee_signature` varchar(100) DEFAULT NULL COMMENT '裁判签名',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0无效 1有效',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_event_id` (`event_id`),
    KEY `idx_item_id` (`item_id`),
    KEY `idx_registration_id` (`registration_id`),
    KEY `idx_athlete_id` (`athlete_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='比赛成绩表';

-- 主办方表
DROP TABLE IF EXISTS `sport_organizer`;
CREATE TABLE `sport_organizer` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(100) NOT NULL COMMENT '主办方名称',
    `type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '类型：1个人 2企业 3政府 4学校 5社团',
    `contact_name` varchar(50) DEFAULT NULL COMMENT '联系人姓名',
    `contact_phone` varchar(20) DEFAULT NULL COMMENT '联系电话',
    `contact_email` varchar(100) DEFAULT NULL COMMENT '联系邮箱',
    `address` varchar(200) DEFAULT NULL COMMENT '地址',
    `description` text COMMENT '描述',
    `logo` varchar(255) DEFAULT NULL COMMENT '标志图片',
    `member_id` int(11) NOT NULL COMMENT '创建者ID',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_member_id` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='主办方表';

-- 导航配置表
DROP TABLE IF EXISTS `sport_nav_config`;
CREATE TABLE `sport_nav_config` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `nav_name` varchar(50) NOT NULL COMMENT '导航名称',
    `nav_key` varchar(50) NOT NULL COMMENT '导航标识',
    `nav_url` varchar(255) NOT NULL COMMENT '导航链接',
    `nav_icon` varchar(100) DEFAULT NULL COMMENT '导航图标',
    `nav_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '导航类型：1系统导航 2自定义导航',
    `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
    `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
    `remark` varchar(255) DEFAULT NULL COMMENT '备注',
    `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_nav_key` (`nav_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='导航配置表';


-- ============================================
-- 基础数据初始化
-- ============================================

-- 项目大类数据
INSERT INTO `sport_category` (`id`, `name`, `code`, `icon`, `description`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
(1, '田径', 'track_field', 'icon-track-field', '包括短跑、长跑、跳跃、投掷等项目', 0, 1, '1', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(2, '球类', 'ball_sports', 'icon-ball', '包括足球、篮球、排球、乒乓球、羽毛球、网球等', 0, 1, '2', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(3, '水上运动', 'water_sports', 'icon-swimming', '包括游泳、跳水、水球等项目', 0, 1, '3', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(4, '体操类', 'gymnastics', 'icon-gymnastics', '包括竞技体操、艺术体操、蹦床等', 0, 1, '4', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(5, '武术类', 'martial_arts', 'icon-martial-arts', '包括太极拳、散打、套路等传统武术项目', 0, 1, '5', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '极限运动', 'extreme_sports', 'icon-extreme', '包括攀岩、滑板、BMX等刺激项目', 0, 1, '6', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(7, '冰雪运动', 'winter_sports', 'icon-winter', '包括滑雪、滑冰、冰球等冬季项目', 0, 1, '7', 7, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(8, '格斗类', 'combat_sports', 'icon-boxing', '包括拳击、跆拳道、柔道、摔跤等', 0, 1, '8', 8, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(9, '射击类', 'shooting', 'icon-shooting', '包括射箭、射击等项目', 0, 1, '9', 9, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(10, '棋类', 'board_games', 'icon-chess', '包括象棋、围棋、国际象棋等智力项目', 0, 1, '10', 10, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '趣味比赛', 'fun_games', 'icon-fun', '包括拔河、袋鼠跳、三人四足等趣味项目', 0, 1, '11', 11, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(12, '其他', 'others', 'icon-others', '其他体育项目', 0, 1, '12', 12, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 基础项目数据引用声明
-- 注意：基础项目数据存储在单独的 sport_base_item_data.sql 文件中
-- 安装插件时，请确保先执行基础数据文件
-- 在这里我们提供一个简化的基础项目数据示例

INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES

-- 水上运动基础项目
(3, '自由泳', 'freestyle', 1, 3, '不限', '自由泳项目，可分不同距离', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(3, '仰泳', 'backstroke', 1, 3, '不限', '仰泳项目，可分不同距离', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(3, '蛙泳', 'breaststroke', 1, 3, '不限', '蛙泳项目，可分不同距离', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(3, '蝶泳', 'butterfly', 1, 3, '不限', '蝶泳项目，可分不同距离', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(3, '个人混合泳', 'individual_medley', 1, 3, '不限', '个人混合泳项目，按蝶泳-仰泳-蛙泳-自由泳顺序', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(3, '自由泳接力', 'freestyle_relay', 2, 3, '不限', '自由泳接力项目，4人团队', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(3, '混合泳接力', 'medley_relay', 2, 3, '不限', '混合泳接力项目，按仰泳-蛙泳-蝶泳-自由泳顺序', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 7, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 田径基础项目
(1, '短跑', 'sprint', 1, 3, '不限', '短跑项目，包括100米、200米、400米', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 20, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(1, '中长跑', 'middle_distance', 1, 3, '不限', '中长跑项目，包括800米、1500米', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 21, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(1, '长跑', 'long_distance', 1, 3, '不限', '长跑项目，包括3000米、5000米、10000米', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 22, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(1, '马拉松', 'marathon', 1, 3, '不限', '马拉松项目，包括半程和全程', '国际田联标准规则', '跑鞋、运动服', '标准马拉松路线', 23, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(1, '跳远', 'long_jump', 1, 3, '不限', '跳远项目', '国际田联标准规则', '跑鞋、运动服', '跳远场地', 27, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(1, '跳高', 'high_jump', 1, 3, '不限', '跳高项目', '国际田联标准规则', '跑鞋、运动服', '跳高场地', 29, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(1, '铅球', 'shot_put', 1, 3, '不限', '铅球投掷项目', '国际田联标准规则', '铅球、运动服', '铅球投掷场地', 31, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(1, '接力', 'relay', 2, 3, '不限', '接力跑项目，4人团队', '国际田联标准规则', '接力棒、跑鞋、运动服', '400米标准田径场', 37, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 球类基础项目
(2, '足球', 'football', 2, 3, '不限', '足球项目，可分11人制、7人制、5人制', 'FIFA标准规则', '足球、球门、球服', '足球场', 50, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(2, '篮球', 'basketball', 2, 3, '不限', '篮球项目，可分5人制、3人制', 'FIBA标准规则', '篮球、篮筐、球服', '篮球场', 51, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(2, '排球', 'volleyball', 2, 3, '不限', '排球项目，包括室内排球和沙滩排球', 'FIVB标准规则', '排球、球网、球服', '排球场', 52, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(2, '乒乓球', 'table_tennis', 1, 3, '不限', '乒乓球项目，可分单打、双打、混双', 'ITTF标准规则', '乒乓球、球拍、球桌', '标准乒乓球场', 53, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(2, '羽毛球', 'badminton', 1, 3, '不限', '羽毛球项目，可分单打、双打、混双', 'BWF标准规则', '羽毛球、球拍、球网', '标准羽毛球场', 54, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 趣味比赛基础项目
(11, '拔河', 'tug_of_war', 2, 3, '不限', '传统拔河比赛，团队协作', '传统拔河规则', '拔河绳', '平坦场地', 100, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '三人四足', 'three_legged_race', 2, 3, '不限', '绑腿协作跑步', '团队协调性比赛', '绑腿带', '跑道或平地', 101, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '袋鼠跳', 'sack_race', 1, 3, '不限', '套袋跳跃比赛', '个人趣味竞技', '麻袋或跳袋', '平坦场地', 102, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '跳绳', 'rope_skipping', 1, 3, '不限', '跳绳项目，可分个人和团体', '跳绳比赛规则', '跳绳', '平坦场地', 104, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 导航配置数据
INSERT INTO `sport_nav_config` (`nav_name`, `nav_key`, `nav_url`, `nav_icon`, `nav_type`, `sort`, `status`, `create_time`, `update_time`) VALUES
('首页', 'home', '/addon/sport/pages/index/index', 'home-filled', 1, 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('赛事', 'events', '/addon/sport/pages/event/index', 'trophy', 1, 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('报名', 'registration', '/addon/sport/pages/registration/index', 'document', 1, 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('成绩', 'scores', '/addon/sport/pages/score/index', 'medal', 1, 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('我的', 'member', '/addon/sport/pages/member/index', 'user-filled', 1, 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());
