/*
Navicat MySQL Data Transfer

Source Server         : 赛程助手新
Source Server Version : 50740
Source Host           : 101.200.210.97:3306
Source Database       : sportnew

Target Server Type    : MYSQL
Target Server Version : 50740
File Encoding         : 65001

Date: 2025-09-05 00:14:11
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for account_log
-- ----------------------------
DROP TABLE IF EXISTS `account_log`;
CREATE TABLE `account_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `type` varchar(255) NOT NULL DEFAULT 'pay' COMMENT '账单类型pay,refund,transfer',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '交易金额',
  `trade_no` varchar(255) NOT NULL DEFAULT '' COMMENT '对应类型交易单号',
  `create_time` varchar(255) NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='站点账单记录';

-- ----------------------------
-- Table structure for addon
-- ----------------------------
DROP TABLE IF EXISTS `addon`;
CREATE TABLE `addon` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(40) NOT NULL DEFAULT '' COMMENT '插件名称',
  `icon` varchar(255) NOT NULL DEFAULT '' COMMENT '插件图标',
  `key` varchar(20) NOT NULL DEFAULT '' COMMENT '插件标识',
  `desc` text COMMENT '插件描述',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态',
  `author` varchar(40) NOT NULL DEFAULT '' COMMENT '作者',
  `version` varchar(20) NOT NULL DEFAULT '' COMMENT '版本号',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `install_time` int(11) NOT NULL DEFAULT '0' COMMENT '安装时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `cover` varchar(255) NOT NULL DEFAULT '' COMMENT '封面',
  `type` varchar(255) NOT NULL DEFAULT 'app' COMMENT '插件类型app，addon',
  `support_app` varchar(255) NOT NULL DEFAULT '' COMMENT '插件支持的应用空表示通用插件',
  `is_star` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否加星',
  `compile` varchar(2000) NOT NULL DEFAULT '' COMMENT '编译端口',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='插件表';

-- ----------------------------
-- Table structure for addon_log
-- ----------------------------
DROP TABLE IF EXISTS `addon_log`;
CREATE TABLE `addon_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `action` varchar(40) NOT NULL DEFAULT '' COMMENT '操作类型   install 安装 uninstall 卸载 update 更新',
  `key` varchar(20) NOT NULL DEFAULT '' COMMENT '插件标识',
  `from_version` varchar(20) NOT NULL DEFAULT '' COMMENT '升级前的版本号',
  `to_version` varchar(20) NOT NULL DEFAULT '' COMMENT '升级后的版本号',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='插件日志表';

-- ----------------------------
-- Table structure for applet_site_version
-- ----------------------------
DROP TABLE IF EXISTS `applet_site_version`;
CREATE TABLE `applet_site_version` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `version_id` int(11) NOT NULL DEFAULT '0' COMMENT '版本id',
  `type` varchar(20) NOT NULL DEFAULT '' COMMENT '小程序类型',
  `action` varchar(20) NOT NULL DEFAULT '' COMMENT '操作方式 download 下载  upgrade 更新',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='站点小程序版本表';

-- ----------------------------
-- Table structure for applet_version
-- ----------------------------
DROP TABLE IF EXISTS `applet_version`;
CREATE TABLE `applet_version` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `config` varchar(255) NOT NULL DEFAULT '' COMMENT '配置信息',
  `type` varchar(20) NOT NULL DEFAULT '' COMMENT '小程序类型',
  `desc` text COMMENT '插件描述',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态  下架  上架',
  `uid` varchar(40) NOT NULL DEFAULT '' COMMENT '发布者',
  `path` varchar(255) NOT NULL DEFAULT '' COMMENT '小程序包地址',
  `version` varchar(20) NOT NULL DEFAULT '' COMMENT '版本号',
  `version_num` varchar(20) NOT NULL DEFAULT '' COMMENT '版本号数字(用于排序)',
  `release_version` varchar(20) NOT NULL DEFAULT '' COMMENT '发布线上版本号',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `delete_time` int(11) NOT NULL DEFAULT '0' COMMENT '删除时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='小程序版本表';

-- ----------------------------
-- Table structure for diy_form
-- ----------------------------
DROP TABLE IF EXISTS `diy_form`;
CREATE TABLE `diy_form` (
  `form_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '表单id',
  `page_title` varchar(255) NOT NULL DEFAULT '' COMMENT '表单名称（用于后台展示）',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '表单名称（用于前台展示）',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '表单类型',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态（0，关闭，1：开启）',
  `template` varchar(255) NOT NULL DEFAULT '' COMMENT '模板名称',
  `value` longtext COMMENT '表单数据，json格式，包含展示组件',
  `addon` varchar(255) NOT NULL DEFAULT '' COMMENT '所属插件标识',
  `share` varchar(1000) NOT NULL DEFAULT '' COMMENT '分享内容',
  `write_num` int(11) NOT NULL DEFAULT '0' COMMENT '表单填写总数量',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注说明',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`form_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='万能表单表';

-- ----------------------------
-- Table structure for diy_form_fields
-- ----------------------------
DROP TABLE IF EXISTS `diy_form_fields`;
CREATE TABLE `diy_form_fields` (
  `field_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '字段id',
  `form_id` int(11) NOT NULL DEFAULT '0' COMMENT '所属万能表单id',
  `field_key` varchar(255) NOT NULL DEFAULT '' COMMENT '字段唯一标识',
  `field_type` varchar(255) NOT NULL DEFAULT '' COMMENT '字段类型',
  `field_name` varchar(255) NOT NULL DEFAULT '' COMMENT '字段名称',
  `field_remark` varchar(255) NOT NULL DEFAULT '' COMMENT '字段说明',
  `field_default` text COMMENT '字段默认值',
  `write_num` int(11) NOT NULL DEFAULT '0' COMMENT '字段填写总数量',
  `field_required` tinyint(4) NOT NULL DEFAULT '0' COMMENT '字段是否必填 0:否 1:是',
  `field_hidden` tinyint(4) NOT NULL DEFAULT '0' COMMENT '字段是否隐藏 0:否 1:是',
  `field_unique` tinyint(4) NOT NULL DEFAULT '0' COMMENT '字段内容防重复 0:否 1:是',
  `privacy_protection` tinyint(4) NOT NULL DEFAULT '0' COMMENT '隐私保护 0:关闭 1:开启',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`field_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='万能表单字段表';

-- ----------------------------
-- Table structure for diy_form_records
-- ----------------------------
DROP TABLE IF EXISTS `diy_form_records`;
CREATE TABLE `diy_form_records` (
  `record_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '表单填写记录id',
  `form_id` int(11) NOT NULL DEFAULT '0' COMMENT '所属万能表单id',
  `value` longtext COMMENT '填写的表单数据',
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '填写人会员id',
  `relate_id` int(11) NOT NULL DEFAULT '0' COMMENT '关联业务id',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='万能表单填写记录表';

-- ----------------------------
-- Table structure for diy_form_records_fields
-- ----------------------------
DROP TABLE IF EXISTS `diy_form_records_fields`;
CREATE TABLE `diy_form_records_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `form_id` int(11) NOT NULL DEFAULT '0' COMMENT '所属万能表单id',
  `form_field_id` int(11) NOT NULL DEFAULT '0' COMMENT '关联表单字段id',
  `record_id` int(11) NOT NULL DEFAULT '0' COMMENT '关联表单填写记录id',
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '填写会员id',
  `field_key` varchar(255) NOT NULL DEFAULT '' COMMENT '字段唯一标识',
  `field_type` varchar(255) NOT NULL DEFAULT '' COMMENT '字段类型',
  `field_name` varchar(255) NOT NULL DEFAULT '' COMMENT '字段名称',
  `field_value` longtext NOT NULL COMMENT '字段值，根据类型展示对应效果',
  `field_required` tinyint(4) NOT NULL DEFAULT '0' COMMENT '字段是否必填 0:否 1:是',
  `field_hidden` tinyint(4) NOT NULL DEFAULT '0' COMMENT '字段是否隐藏 0:否 1:是',
  `field_unique` tinyint(4) NOT NULL DEFAULT '0' COMMENT '字段内容防重复 0:否 1:是',
  `privacy_protection` tinyint(4) NOT NULL DEFAULT '0' COMMENT '隐私保护 0:关闭 1:开启',
  `update_num` int(11) NOT NULL DEFAULT '0' COMMENT '字段修改次数',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='万能表单填写字段表';

-- ----------------------------
-- Table structure for diy_form_submit_config
-- ----------------------------
DROP TABLE IF EXISTS `diy_form_submit_config`;
CREATE TABLE `diy_form_submit_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `form_id` int(11) NOT NULL DEFAULT '0' COMMENT '所属万能表单id',
  `submit_after_action` varchar(255) NOT NULL DEFAULT '' COMMENT '填表人提交后操作，text：文字信息，voucher：核销凭证',
  `tips_type` varchar(255) NOT NULL DEFAULT '' COMMENT '提示内容类型，default：默认提示，diy：自定义提示',
  `tips_text` varchar(255) NOT NULL DEFAULT '' COMMENT '自定义提示内容',
  `time_limit_type` varchar(255) NOT NULL DEFAULT '0' COMMENT '核销凭证有效期限制类型，no_limit：不限制，specify_time：指定固定开始结束时间，submission_time：按提交时间设置有效期',
  `time_limit_rule` text COMMENT '核销凭证时间限制规则，json格式',
  `voucher_content_rule` text COMMENT '核销凭证内容，json格式',
  `success_after_action` text COMMENT '填写成功后续操作',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='万能表单提交页配置表';

-- ----------------------------
-- Table structure for diy_form_write_config
-- ----------------------------
DROP TABLE IF EXISTS `diy_form_write_config`;
CREATE TABLE `diy_form_write_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `form_id` int(11) NOT NULL DEFAULT '0' COMMENT '所属万能表单id',
  `write_way` varchar(255) NOT NULL COMMENT '填写方式，no_limit：不限制，scan：仅限微信扫一扫，url：仅限链接进入',
  `join_member_type` varchar(255) NOT NULL DEFAULT 'all_member' COMMENT '参与会员，all_member：所有会员参与，selected_member_level：指定会员等级，selected_member_label：指定会员标签',
  `level_ids` text COMMENT '会员等级id集合',
  `label_ids` text COMMENT '会员标签id集合',
  `member_write_type` varchar(255) NOT NULL COMMENT '每人可填写次数，no_limit：不限制，diy：自定义',
  `member_write_rule` text NOT NULL COMMENT '每人可填写次数自定义规则',
  `form_write_type` varchar(255) NOT NULL COMMENT '表单可填写数量，no_limit：不限制，diy：自定义',
  `form_write_rule` text NOT NULL COMMENT '表单可填写总数自定义规则',
  `time_limit_type` varchar(255) NOT NULL DEFAULT '0' COMMENT '填写时间限制类型，no_limit：不限制， specify_time：指定开始结束时间，open_day_time：设置每日开启时间',
  `time_limit_rule` text NOT NULL COMMENT '填写时间限制规则',
  `is_allow_update_content` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否允许修改自己填写的内容，0：否，1：是',
  `write_instruction` text COMMENT '表单填写须知',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='万能表单填写配置表';

-- ----------------------------
-- Table structure for diy_page
-- ----------------------------
DROP TABLE IF EXISTS `diy_page`;
CREATE TABLE `diy_page` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `page_title` varchar(255) NOT NULL DEFAULT '' COMMENT '页面名称（用于后台展示）',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '页面标题（用于前台展示）',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '页面标识',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '页面模板',
  `template` varchar(255) NOT NULL DEFAULT '' COMMENT '模板名称',
  `mode` varchar(255) NOT NULL DEFAULT 'diy' COMMENT '页面展示模式，diy：自定义，fixed：固定',
  `value` longtext COMMENT '页面数据，json格式',
  `is_default` int(11) NOT NULL DEFAULT '0' COMMENT '是否默认页面，1：是，0：否',
  `is_change` int(11) NOT NULL DEFAULT '0' COMMENT '数据是否发生过变化，1：变化了，2：没有',
  `share` varchar(1000) NOT NULL DEFAULT '' COMMENT '分享内容',
  `visit_count` int(11) NOT NULL DEFAULT '0' COMMENT '访问量',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='自定义页面';

-- ----------------------------
-- Table structure for diy_route
-- ----------------------------
DROP TABLE IF EXISTS `diy_route`;
CREATE TABLE `diy_route` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '页面名称',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '页面标识',
  `page` varchar(255) NOT NULL DEFAULT '' COMMENT '页面路径',
  `share` varchar(1000) NOT NULL DEFAULT '' COMMENT '分享内容',
  `is_share` int(11) NOT NULL DEFAULT '0' COMMENT '是否支持分享',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='自定义路由';

-- ----------------------------
-- Table structure for diy_theme
-- ----------------------------
DROP TABLE IF EXISTS `diy_theme`;
CREATE TABLE `diy_theme` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '标题',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '插件类型app，addon',
  `addon` varchar(255) NOT NULL DEFAULT '' COMMENT '所属应用，app：系统，shop：商城、o2o：上门服务',
  `mode` varchar(255) NOT NULL DEFAULT '' COMMENT '模式，default：默认【跟随系统】，diy：自定义配色',
  `theme_type` varchar(255) NOT NULL DEFAULT '' COMMENT '配色类型，default：默认，diy：自定义',
  `default_theme` text COMMENT '当前色调的默认值',
  `theme` text COMMENT '当前色调',
  `new_theme` text COMMENT '新增颜色集合',
  `is_selected` tinyint(4) NOT NULL DEFAULT '0' COMMENT '已选色调，0：否，1.是',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COMMENT='自定义主题配色表';

-- ----------------------------
-- Table structure for generate_column
-- ----------------------------
DROP TABLE IF EXISTS `generate_column`;
CREATE TABLE `generate_column` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `table_id` int(11) NOT NULL DEFAULT '0' COMMENT '表id',
  `column_name` varchar(100) NOT NULL DEFAULT '' COMMENT '字段名称',
  `column_comment` varchar(300) NOT NULL DEFAULT '' COMMENT '字段描述',
  `column_type` varchar(100) NOT NULL DEFAULT '' COMMENT '字段类型',
  `is_required` tinyint(1) DEFAULT '0' COMMENT '是否必填 0-非必填 1-必填',
  `is_pk` tinyint(1) DEFAULT '0' COMMENT '是否为主键 0-不是 1-是',
  `is_insert` tinyint(1) DEFAULT '0' COMMENT '是否为插入字段 0-不是 1-是',
  `is_update` tinyint(1) DEFAULT '0' COMMENT '是否为更新字段 0-不是 1-是',
  `is_lists` tinyint(1) DEFAULT '1' COMMENT '是否为列表字段 0-不是 1-是',
  `is_query` tinyint(1) DEFAULT '1' COMMENT '是否为查询字段 0-不是 1-是',
  `is_search` tinyint(1) DEFAULT '1' COMMENT '是否搜索字段',
  `query_type` varchar(100) DEFAULT '=' COMMENT '查询类型',
  `view_type` varchar(100) DEFAULT 'input' COMMENT '显示类型',
  `dict_type` varchar(255) DEFAULT '' COMMENT '字典类型',
  `addon` varchar(255) DEFAULT '' COMMENT '远程下拉关联应用',
  `model` varchar(255) DEFAULT '' COMMENT '远程下拉关联model',
  `label_key` varchar(255) DEFAULT '' COMMENT '远程下拉标题字段',
  `value_key` varchar(255) DEFAULT '' COMMENT '远程下拉value字段',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  `is_delete` tinyint(4) DEFAULT '0' COMMENT '是否为软删除字段 0-不是 1-是',
  `is_order` tinyint(4) DEFAULT '0' COMMENT '是否为排序字段 0-不是 1-是',
  `validate_type` varchar(255) DEFAULT '' COMMENT '验证类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=413 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='代码生成表字段信息表';

-- ----------------------------
-- Table structure for generate_table
-- ----------------------------
DROP TABLE IF EXISTS `generate_table`;
CREATE TABLE `generate_table` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `table_name` varchar(255) NOT NULL DEFAULT '' COMMENT '表名',
  `table_content` varchar(255) NOT NULL DEFAULT '' COMMENT '描述前缀',
  `module_name` varchar(255) NOT NULL DEFAULT '' COMMENT '模块名',
  `class_name` varchar(255) NOT NULL DEFAULT '' COMMENT '类名前缀',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '添加时间',
  `edit_type` int(11) NOT NULL DEFAULT '1' COMMENT '编辑方式 1-弹框 2-新页面',
  `addon_name` varchar(255) NOT NULL DEFAULT '' COMMENT '插件名',
  `order_type` int(11) NOT NULL DEFAULT '0' COMMENT '排序方式 0-无排序 1-正序 2-倒序',
  `parent_menu` varchar(255) NOT NULL DEFAULT '' COMMENT '上级菜单',
  `relations` text COMMENT '关联配置',
  `synchronous_number` int(11) NOT NULL DEFAULT '0' COMMENT '同步次数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='代码生成表';

-- ----------------------------
-- Table structure for jobs
-- ----------------------------
DROP TABLE IF EXISTS `jobs`;
CREATE TABLE `jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) NOT NULL DEFAULT '',
  `payload` longtext NOT NULL,
  `attempts` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `reserve_time` int(11) unsigned DEFAULT '0',
  `available_time` int(11) unsigned DEFAULT '0',
  `create_time` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='消息队列任务表';

-- ----------------------------
-- Table structure for jobs_failed
-- ----------------------------
DROP TABLE IF EXISTS `jobs_failed`;
CREATE TABLE `jobs_failed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `fail_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='消息队列任务失败记录表';

-- ----------------------------
-- Table structure for jz_service_tag
-- ----------------------------
DROP TABLE IF EXISTS `jz_service_tag`;
CREATE TABLE `jz_service_tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(50) NOT NULL COMMENT '服务标签名称',
  `category_id` int(11) DEFAULT '0' COMMENT '关联分类ID 0:通用标签',
  `sort` int(11) DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态 1:启用 0:禁用',
  `is_system` tinyint(1) DEFAULT '1' COMMENT '是否系统标签 1:系统 0:用户自定义',
  `usage_count` int(11) DEFAULT '0' COMMENT '使用次数',
  `create_time` int(11) DEFAULT NULL COMMENT '创建时间',
  `update_time` int(11) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tag_category` (`tag_name`,`category_id`),
  KEY `idx_category_id` (`category_id`),
  KEY `idx_status` (`status`),
  KEY `idx_sort` (`sort`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COMMENT='服务标签表';

-- ----------------------------
-- Table structure for jz_skill_tag
-- ----------------------------
DROP TABLE IF EXISTS `jz_skill_tag`;
CREATE TABLE `jz_skill_tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(50) NOT NULL COMMENT '技能标签名称',
  `category_id` int(11) DEFAULT '0' COMMENT '关联分类ID 0:通用标签',
  `sort` int(11) DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态 1:启用 0:禁用',
  `is_system` tinyint(1) DEFAULT '1' COMMENT '是否系统标签 1:系统 0:用户自定义',
  `usage_count` int(11) DEFAULT '0' COMMENT '使用次数',
  `create_time` int(11) DEFAULT NULL COMMENT '创建时间',
  `update_time` int(11) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tag_category` (`tag_name`,`category_id`),
  KEY `idx_category_id` (`category_id`),
  KEY `idx_status` (`status`),
  KEY `idx_sort` (`sort`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COMMENT='技能标签表';

-- ----------------------------
-- Table structure for member
-- ----------------------------
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

-- ----------------------------
-- Table structure for member_account_log
-- ----------------------------
DROP TABLE IF EXISTS `member_account_log`;
CREATE TABLE `member_account_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `account_type` varchar(255) NOT NULL DEFAULT 'point' COMMENT '账户类型',
  `account_data` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '账户数据',
  `account_sum` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '变动后的账户余额',
  `from_type` varchar(255) NOT NULL DEFAULT '' COMMENT '来源类型',
  `related_id` varchar(50) NOT NULL DEFAULT '' COMMENT '关联Id',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `memo` varchar(255) NOT NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='会员账单表';

-- ----------------------------
-- Table structure for member_address
-- ----------------------------
DROP TABLE IF EXISTS `member_address`;
CREATE TABLE `member_address` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '会员id',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '用户姓名',
  `mobile` varchar(255) NOT NULL DEFAULT '' COMMENT '手机',
  `province_id` int(11) NOT NULL DEFAULT '0' COMMENT '省id',
  `city_id` int(11) NOT NULL DEFAULT '0' COMMENT '市id',
  `district_id` int(11) NOT NULL DEFAULT '0' COMMENT '区县id',
  `address` varchar(255) NOT NULL DEFAULT '' COMMENT '地址信息',
  `address_name` varchar(255) NOT NULL DEFAULT '',
  `full_address` varchar(255) NOT NULL DEFAULT '' COMMENT '详细地址信息',
  `lng` varchar(255) NOT NULL DEFAULT '' COMMENT '经度',
  `lat` varchar(255) NOT NULL DEFAULT '' COMMENT '纬度',
  `is_default` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否是默认地址',
  PRIMARY KEY (`id`),
  KEY `IDX_member_address` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='会员收货地址';

-- ----------------------------
-- Table structure for member_cash_out
-- ----------------------------
DROP TABLE IF EXISTS `member_cash_out`;
CREATE TABLE `member_cash_out` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cash_out_no` varchar(50) NOT NULL DEFAULT '' COMMENT '提现交易号',
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '会员id',
  `account_type` varchar(255) NOT NULL DEFAULT 'money' COMMENT '提现账户类型',
  `transfer_type` varchar(20) NOT NULL DEFAULT '0' COMMENT '转账提现类型',
  `transfer_realname` varchar(50) NOT NULL DEFAULT '' COMMENT '联系人名称',
  `transfer_mobile` varchar(11) NOT NULL DEFAULT '' COMMENT '手机号',
  `transfer_bank` varchar(255) NOT NULL DEFAULT '' COMMENT '银行名称',
  `transfer_account` varchar(255) NOT NULL DEFAULT '' COMMENT '收款账号',
  `transfer_payee` varchar(255) NOT NULL DEFAULT '' COMMENT '转账收款方(json),主要用于对接在线的打款方式',
  `transfer_payment_code` varchar(500) NOT NULL DEFAULT '' COMMENT '收款码图片',
  `transfer_fail_reason` varchar(255) NOT NULL DEFAULT '' COMMENT '失败原因',
  `transfer_status` varchar(20) NOT NULL DEFAULT '' COMMENT '转账状态',
  `transfer_time` int(11) NOT NULL DEFAULT '0' COMMENT '转账时间',
  `apply_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '提现申请金额',
  `rate` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '提现手续费比率',
  `service_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '提现手续费',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '提现到账金额',
  `audit_time` int(11) NOT NULL DEFAULT '0' COMMENT '审核时间',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态1待审核2.待转账3已转账 -1拒绝 -2 已取消',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '申请时间',
  `refuse_reason` varchar(255) NOT NULL DEFAULT '' COMMENT '拒绝理由',
  `update_time` int(11) NOT NULL DEFAULT '0',
  `transfer_no` varchar(50) NOT NULL DEFAULT '' COMMENT '转账单号',
  `cancel_time` int(11) NOT NULL DEFAULT '0' COMMENT '取消时间',
  `final_transfer_type` varchar(255) NOT NULL DEFAULT '' COMMENT '转账方式',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='会员提现表';

-- ----------------------------
-- Table structure for member_cash_out_account
-- ----------------------------
DROP TABLE IF EXISTS `member_cash_out_account`;
CREATE TABLE `member_cash_out_account` (
  `account_id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '会员id',
  `account_type` varchar(255) NOT NULL DEFAULT '' COMMENT '账户类型',
  `bank_name` varchar(255) NOT NULL DEFAULT '' COMMENT '银行名称',
  `realname` varchar(255) NOT NULL DEFAULT '' COMMENT '真实名称',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  `account_no` varchar(255) NOT NULL DEFAULT '' COMMENT '提现账户',
  `transfer_payment_code` varchar(255) NOT NULL DEFAULT '' COMMENT '收款码',
  PRIMARY KEY (`account_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='会员提现账户';

-- ----------------------------
-- Table structure for member_label
-- ----------------------------
DROP TABLE IF EXISTS `member_label`;
CREATE TABLE `member_label` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '标签id',
  `label_name` varchar(50) NOT NULL DEFAULT '' COMMENT '标签名称',
  `memo` varchar(1000) NOT NULL DEFAULT '' COMMENT '备注',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`label_id`) USING BTREE,
  KEY `label_id` (`label_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='会员标签';

-- ----------------------------
-- Table structure for member_level
-- ----------------------------
DROP TABLE IF EXISTS `member_level`;
CREATE TABLE `member_level` (
  `level_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '会员等级',
  `level_name` varchar(50) NOT NULL DEFAULT '' COMMENT '等级名称',
  `growth` int(11) NOT NULL DEFAULT '0' COMMENT '所需成长值',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `status` int(11) NOT NULL DEFAULT '1' COMMENT '状态 0已禁用1已启用',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `level_benefits` text COMMENT '等级权益',
  `level_gifts` text COMMENT '等级礼包',
  PRIMARY KEY (`level_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='会员等级';

-- ----------------------------
-- Table structure for member_sign
-- ----------------------------
DROP TABLE IF EXISTS `member_sign`;
CREATE TABLE `member_sign` (
  `sign_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '会员id',
  `days` int(11) NOT NULL DEFAULT '0' COMMENT '连续签到天数',
  `day_award` varchar(255) NOT NULL DEFAULT '' COMMENT '日签奖励',
  `continue_award` varchar(255) NOT NULL DEFAULT '' COMMENT '连签奖励',
  `continue_tag` varchar(30) NOT NULL DEFAULT '' COMMENT '连签奖励标识',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '签到时间',
  `start_time` int(11) NOT NULL DEFAULT '0' COMMENT '签到周期开始时间',
  `is_sign` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否签到（0未签到 1已签到）',
  PRIMARY KEY (`sign_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='会员签到表';

-- ----------------------------
-- Table structure for pay
-- ----------------------------
DROP TABLE IF EXISTS `pay`;
CREATE TABLE `pay` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `main_id` int(11) NOT NULL DEFAULT '0' COMMENT '支付会员id',
  `from_main_id` int(11) NOT NULL DEFAULT '0' COMMENT '发起支付会员id',
  `out_trade_no` varchar(255) NOT NULL DEFAULT '' COMMENT '支付流水号',
  `trade_type` varchar(255) NOT NULL DEFAULT '' COMMENT '业务类型',
  `trade_id` int(11) NOT NULL DEFAULT '0' COMMENT '业务id',
  `trade_no` varchar(255) NOT NULL DEFAULT '' COMMENT '交易单号',
  `body` varchar(1000) NOT NULL DEFAULT '' COMMENT '支付主体',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '支付金额',
  `voucher` varchar(255) NOT NULL DEFAULT '' COMMENT '支付票据',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '支付状态（0.待支付 1. 支付中 2. 已支付 -1已取消）',
  `json` varchar(255) NOT NULL DEFAULT '' COMMENT '支付扩展用支付信息',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `pay_time` int(11) NOT NULL DEFAULT '0' COMMENT '支付时间',
  `cancel_time` int(11) NOT NULL DEFAULT '0' COMMENT '关闭时间',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '支付方式',
  `mch_id` varchar(50) NOT NULL DEFAULT '' COMMENT '商户收款账号',
  `main_type` varchar(255) NOT NULL DEFAULT '',
  `channel` varchar(50) NOT NULL DEFAULT '' COMMENT '支付渠道',
  `fail_reason` varchar(255) NOT NULL DEFAULT '' COMMENT '失败原因',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='支付记录表';

-- ----------------------------
-- Table structure for pay_channel
-- ----------------------------
DROP TABLE IF EXISTS `pay_channel`;
CREATE TABLE `pay_channel` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '支付类型',
  `channel` varchar(255) NOT NULL DEFAULT '' COMMENT '支付渠道',
  `config` text NOT NULL COMMENT '支付配置',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '是否启用',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='支付渠道配置表';

-- ----------------------------
-- Table structure for pay_refund
-- ----------------------------
DROP TABLE IF EXISTS `pay_refund`;
CREATE TABLE `pay_refund` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `refund_no` varchar(255) NOT NULL DEFAULT '' COMMENT '退款单号',
  `out_trade_no` varchar(255) NOT NULL DEFAULT '' COMMENT '支付流水号',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '支付方式',
  `channel` varchar(50) NOT NULL DEFAULT '' COMMENT '支付渠道',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '支付金额',
  `reason` varchar(255) NOT NULL DEFAULT '' COMMENT '退款原因',
  `status` varchar(255) NOT NULL DEFAULT '0' COMMENT '支付状态（0.待退款 1. 退款中 2. 已退款 -1已关闭）',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `refund_time` int(11) NOT NULL DEFAULT '0' COMMENT '支付时间',
  `close_time` int(11) NOT NULL DEFAULT '0' COMMENT '关闭时间',
  `fail_reason` varchar(255) NOT NULL DEFAULT '' COMMENT '失败原因',
  `voucher` varchar(255) NOT NULL DEFAULT '' COMMENT '支付凭证',
  `trade_type` varchar(255) NOT NULL DEFAULT '' COMMENT '业务类型',
  `trade_id` varchar(50) NOT NULL DEFAULT '' COMMENT '业务关联id',
  `refund_type` varchar(255) NOT NULL DEFAULT '' COMMENT '退款方式',
  `main_type` varchar(255) NOT NULL DEFAULT '' COMMENT '操作人类型',
  `main_id` int(11) NOT NULL DEFAULT '0' COMMENT '操作人',
  `pay_refund_no` varchar(255) NOT NULL DEFAULT '' COMMENT '外部支付方式的退款单号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='支付退款记录表';

-- ----------------------------
-- Table structure for pay_transfer
-- ----------------------------
DROP TABLE IF EXISTS `pay_transfer`;
CREATE TABLE `pay_transfer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `trade_type` varchar(255) NOT NULL DEFAULT '' COMMENT '业务类型',
  `transfer_no` varchar(50) NOT NULL DEFAULT '' COMMENT '转账单号',
  `main_id` int(11) NOT NULL DEFAULT '0' COMMENT '会员id',
  `main_type` varchar(255) NOT NULL DEFAULT '' COMMENT '主体类型',
  `transfer_type` varchar(20) NOT NULL DEFAULT '' COMMENT '转账类型',
  `transfer_realname` varchar(50) NOT NULL DEFAULT '' COMMENT '联系人名称',
  `transfer_mobile` varchar(11) NOT NULL DEFAULT '' COMMENT '手机号',
  `transfer_bank` varchar(255) NOT NULL DEFAULT '' COMMENT '银行名称',
  `transfer_account` varchar(255) NOT NULL DEFAULT '' COMMENT '收款账号',
  `transfer_voucher` varchar(255) NOT NULL DEFAULT '' COMMENT '凭证',
  `transfer_remark` varchar(255) NOT NULL DEFAULT '' COMMENT '凭证说明',
  `transfer_payment_code` varchar(255) NOT NULL DEFAULT '' COMMENT '收款码图片',
  `transfer_fail_reason` varchar(2000) NOT NULL DEFAULT '' COMMENT '失败原因',
  `transfer_status` varchar(20) NOT NULL DEFAULT '' COMMENT '转账状态',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '转账金额',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '申请时间',
  `transfer_time` int(11) NOT NULL DEFAULT '0' COMMENT '转账时间',
  `update_time` int(11) NOT NULL DEFAULT '0',
  `openid` varchar(50) NOT NULL DEFAULT '',
  `remark` varchar(255) NOT NULL DEFAULT '',
  `batch_id` varchar(500) NOT NULL DEFAULT '' COMMENT '转账批次id',
  `transfer_payee` varchar(500) NOT NULL DEFAULT '' COMMENT '在线转账数据(json)',
  `out_batch_no` varchar(500) NOT NULL DEFAULT '' COMMENT '扩展数据,主要用于记录接收到线上打款的业务数据编号',
  `package_info` varchar(1000) NOT NULL DEFAULT '' COMMENT '跳转领取页面的package信息',
  `extra` varchar(1000) NOT NULL DEFAULT '' COMMENT '扩展信息',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='转账表';

-- ----------------------------
-- Table structure for pay_transfer_scene
-- ----------------------------
DROP TABLE IF EXISTS `pay_transfer_scene`;
CREATE TABLE `pay_transfer_scene` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '业务类型',
  `scene` varchar(50) NOT NULL DEFAULT '' COMMENT '场景',
  `infos` varchar(2000) NOT NULL DEFAULT '' COMMENT '转账报备背景',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `perception` varchar(500) NOT NULL DEFAULT '' COMMENT '转账收款感知',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='支付转账场景表';

-- ----------------------------
-- Table structure for shop_active
-- ----------------------------
DROP TABLE IF EXISTS `shop_active`;
CREATE TABLE `shop_active` (
  `active_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '活动id',
  `active_name` varchar(255) NOT NULL DEFAULT '' COMMENT '活动名称',
  `active_desc` text COMMENT '活动说明',
  `active_type` varchar(255) NOT NULL DEFAULT '' COMMENT '活动类型(店铺活动，会员活动，商品活动)',
  `active_goods_type` varchar(255) NOT NULL DEFAULT '' COMMENT '商品活动类型（单品，独立商品，店铺整体商品）',
  `active_goods_info` text COMMENT '参与活动商品信息',
  `active_class` varchar(255) NOT NULL DEFAULT '' COMMENT '活动类别',
  `active_class_category` varchar(255) NOT NULL DEFAULT '' COMMENT '活动类别子分类（活动管理）',
  `relate_member` varchar(1000) NOT NULL DEFAULT '' COMMENT '参与会员条件(默认全部)',
  `active_value` text COMMENT '活动扩展信息数据',
  `start_time` int(11) NOT NULL DEFAULT '0' COMMENT '活动开始时间',
  `end_time` int(11) NOT NULL DEFAULT '0' COMMENT '活动结束时间',
  `active_status` varchar(50) NOT NULL DEFAULT '' COMMENT '活动状态',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  `active_order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '活动累计金额',
  `active_order_num` int(11) NOT NULL DEFAULT '0' COMMENT '活动累计订单数',
  `active_member_num` int(11) NOT NULL DEFAULT '0' COMMENT '活动参与会员数',
  `active_success_num` int(11) NOT NULL DEFAULT '0' COMMENT '活动成功参与会员数',
  PRIMARY KEY (`active_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='店铺营销活动表（整体活动）';

-- ----------------------------
-- Table structure for shop_active_goods
-- ----------------------------
DROP TABLE IF EXISTS `shop_active_goods`;
CREATE TABLE `shop_active_goods` (
  `active_goods_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '活动商品id',
  `active_id` int(11) NOT NULL DEFAULT '0' COMMENT '活动id',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品id',
  `sku_id` int(11) DEFAULT '0' COMMENT '商品规格id',
  `active_goods_type` varchar(255) NOT NULL DEFAULT '' COMMENT '商品活动类型（单品，独立商品，店铺整体商品）',
  `active_class` varchar(255) NOT NULL DEFAULT '' COMMENT '商品活动类别',
  `active_goods_label` varchar(1000) NOT NULL DEFAULT '' COMMENT '活动商品标签（针对活动有标签）',
  `active_goods_category` varchar(1000) NOT NULL DEFAULT '' COMMENT '活动商品分类（针对活动有分类）',
  `active_goods_value` text COMMENT '活动商品信息数据',
  `active_goods_status` varchar(50) NOT NULL DEFAULT '' COMMENT '活动状态',
  `active_goods_point` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '活动商品积分（展示，搜索）',
  `active_goods_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '活动商品价格（展示，搜索）',
  `active_goods_stock` int(11) NOT NULL DEFAULT '0' COMMENT '活动商品库存（针对参与库存）',
  `active_goods_order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '活动累计金额',
  `active_goods_order_num` int(11) NOT NULL DEFAULT '0' COMMENT '活动累计订单数',
  `active_goods_member_num` int(11) NOT NULL DEFAULT '0' COMMENT '活动参与会员数',
  `active_goods_success_num` int(11) NOT NULL DEFAULT '0' COMMENT '活动成功参与会员数',
  PRIMARY KEY (`active_goods_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='店铺营销活动';

-- ----------------------------
-- Table structure for shop_address
-- ----------------------------
DROP TABLE IF EXISTS `shop_address`;
CREATE TABLE `shop_address` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contact_name` varchar(255) NOT NULL DEFAULT '' COMMENT '联系人',
  `mobile` varchar(50) NOT NULL DEFAULT '' COMMENT '手机号',
  `province_id` int(11) NOT NULL DEFAULT '0' COMMENT '省',
  `city_id` int(11) NOT NULL DEFAULT '0' COMMENT '市',
  `district_id` int(11) NOT NULL DEFAULT '0' COMMENT '区',
  `address` varchar(255) NOT NULL DEFAULT '' COMMENT '详细地址',
  `full_address` varchar(1000) NOT NULL DEFAULT '' COMMENT '地址',
  `lat` varchar(50) NOT NULL DEFAULT '' COMMENT '纬度',
  `lng` varchar(50) NOT NULL DEFAULT '' COMMENT '经度',
  `is_delivery_address` int(11) NOT NULL DEFAULT '0' COMMENT '是否是发货地址',
  `is_refund_address` int(11) NOT NULL DEFAULT '0' COMMENT '是否是退货地址',
  `is_default_delivery` int(11) NOT NULL DEFAULT '0' COMMENT '默认发货地址',
  `is_default_refund` int(11) NOT NULL DEFAULT '0' COMMENT '默认收货地址',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家地址库';

-- ----------------------------
-- Table structure for shop_cart
-- ----------------------------
DROP TABLE IF EXISTS `shop_cart`;
CREATE TABLE `shop_cart` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '购物车表ID',
  `member_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '会员ID',
  `goods_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `sku_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'sku id',
  `num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '商品数量',
  `market_type` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '活动类型',
  `market_type_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '活动id',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '购物车商品状态',
  `invalid_remark` varchar(255) NOT NULL DEFAULT '' COMMENT '失效原因',
  PRIMARY KEY (`id`),
  KEY `goods_id` (`goods_id`),
  KEY `member_id` (`member_id`),
  KEY `sku_id` (`sku_id`),
  KEY `type` (`market_type`),
  KEY `type_id` (`market_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='购物车表';

-- ----------------------------
-- Table structure for shop_coupon
-- ----------------------------
DROP TABLE IF EXISTS `shop_coupon`;
CREATE TABLE `shop_coupon` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '名称',
  `start_time` int(11) NOT NULL DEFAULT '0' COMMENT '活动开启时间',
  `end_time` int(11) NOT NULL DEFAULT '0' COMMENT '活动结束时间',
  `remain_count` int(11) NOT NULL DEFAULT '0' COMMENT '剩余数量',
  `receive_count` int(11) NOT NULL DEFAULT '0' COMMENT '已领取数量',
  `give_count` int(11) NOT NULL DEFAULT '0' COMMENT '已发放数量',
  `limit_count` int(11) NOT NULL DEFAULT '0' COMMENT '单个会员限制领取数量',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT ' 状态 1 正常 2 未开启 3 已无效',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '添加时间',
  `price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '面值',
  `min_condition_money` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '商品最低多少金额可用优惠券',
  `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '优惠券类型 1通用优惠券 2商品品类优惠券 3商品优惠券',
  `receive_type` int(11) NOT NULL DEFAULT '0' COMMENT '领取方式',
  `valid_type` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '有效时间',
  `length` int(11) NOT NULL DEFAULT '0' COMMENT '有效期时长(天)',
  `valid_start_time` int(11) NOT NULL DEFAULT '0' COMMENT '有效期开始时间',
  `valid_end_time` int(11) NOT NULL DEFAULT '0' COMMENT '有效期结束时间',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `receive_status` tinyint(4) NOT NULL DEFAULT '1' COMMENT ' 状态 1 正常 2 关闭',
  PRIMARY KEY (`id`),
  KEY `status` (`status`),
  KEY `title` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券表';

-- ----------------------------
-- Table structure for shop_coupon_goods
-- ----------------------------
DROP TABLE IF EXISTS `shop_coupon_goods`;
CREATE TABLE `shop_coupon_goods` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `coupon_id` int(11) NOT NULL DEFAULT '0' COMMENT '优惠券模板id',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品id',
  `category_id` int(11) NOT NULL DEFAULT '0' COMMENT '分类id',
  PRIMARY KEY (`id`),
  KEY `index_category_id` (`category_id`),
  KEY `index_coupon_id` (`coupon_id`),
  KEY `index_goods_id` (`goods_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券商品或品类关联表';

-- ----------------------------
-- Table structure for shop_coupon_member
-- ----------------------------
DROP TABLE IF EXISTS `shop_coupon_member`;
CREATE TABLE `shop_coupon_member` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '优惠券发放记录id',
  `coupon_id` int(11) NOT NULL DEFAULT '0' COMMENT '优惠券id',
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '会员id',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '领取时间',
  `expire_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '过期时间',
  `use_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '使用时间',
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT '优惠券类型',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '优惠券名称',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '面值',
  `min_condition_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '最低使用门槛',
  `receive_type` varchar(255) NOT NULL DEFAULT '' COMMENT '领取方式',
  `trade_id` int(11) NOT NULL DEFAULT '0' COMMENT '关联业务id',
  PRIMARY KEY (`id`),
  KEY `coupon_id` (`coupon_id`),
  KEY `member_id` (`member_id`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券会员领取记录表';

-- ----------------------------
-- Table structure for shop_delivery_company
-- ----------------------------
DROP TABLE IF EXISTS `shop_delivery_company`;
CREATE TABLE `shop_delivery_company` (
  `company_id` int(11) NOT NULL AUTO_INCREMENT,
  `company_name` varchar(255) NOT NULL DEFAULT '' COMMENT '物流公司名称',
  `logo` varchar(255) NOT NULL DEFAULT '' COMMENT '物流公司logo',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT '物流公司网站',
  `express_no` varchar(255) NOT NULL DEFAULT '' COMMENT '物流公司编号(用于物流跟踪)',
  `express_no_electronic_sheet` varchar(255) NOT NULL DEFAULT '' COMMENT '物流公司编号(用于电子面单)',
  `electronic_sheet_switch` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否支持电子面单（0：不支持，1：支持）',
  `print_style` varchar(2000) NOT NULL DEFAULT '' COMMENT '电子面单打印模板样式，json字符串',
  `exp_type` varchar(2000) NOT NULL DEFAULT '' COMMENT '物流公司业务类型，json字符串',
  `create_time` int(11) NOT NULL DEFAULT '0',
  `update_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for shop_delivery_deliver
-- ----------------------------
DROP TABLE IF EXISTS `shop_delivery_deliver`;
CREATE TABLE `shop_delivery_deliver` (
  `deliver_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '配送员id',
  `deliver_name` varchar(255) NOT NULL DEFAULT '' COMMENT '配送员名称',
  `deliver_mobile` varchar(20) NOT NULL DEFAULT '' COMMENT '配送员手机号',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `modify_time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  `store_id` int(11) NOT NULL DEFAULT '0' COMMENT '门店id',
  PRIMARY KEY (`deliver_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='配送员表';

-- ----------------------------
-- Table structure for shop_delivery_electronic_sheet
-- ----------------------------
DROP TABLE IF EXISTS `shop_delivery_electronic_sheet`;
CREATE TABLE `shop_delivery_electronic_sheet` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `template_name` varchar(255) NOT NULL DEFAULT '' COMMENT '模板名称',
  `express_company_id` int(11) NOT NULL DEFAULT '0' COMMENT '物流公司id',
  `customer_name` varchar(255) NOT NULL DEFAULT '' COMMENT '电子面单客户账号（CustomerName）',
  `customer_pwd` varchar(255) NOT NULL DEFAULT '' COMMENT '电子面单密码（CustomerPwd）',
  `send_site` varchar(255) NOT NULL DEFAULT '' COMMENT 'SendSite',
  `send_staff` varchar(255) NOT NULL DEFAULT '' COMMENT 'SendStaff',
  `month_code` varchar(255) NOT NULL DEFAULT '' COMMENT 'MonthCode',
  `pay_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '邮费支付方式（1：现付，2：到付，3：月结）',
  `is_notice` tinyint(4) NOT NULL DEFAULT '0' COMMENT '快递员上门揽件（0：否，1：是）',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态（1：开启，0：关闭）',
  `exp_type` int(11) NOT NULL DEFAULT '0' COMMENT '物流公司业务类型',
  `print_style` varchar(255) NOT NULL DEFAULT '' COMMENT '电子面单打印模板样式',
  `is_default` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否默认（1：是，0：否）',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COMMENT='电子面单';

-- ----------------------------
-- Table structure for shop_delivery_local_delivery
-- ----------------------------
DROP TABLE IF EXISTS `shop_delivery_local_delivery`;
CREATE TABLE `shop_delivery_local_delivery` (
  `local_id` int(11) NOT NULL AUTO_INCREMENT,
  `fee_type` varchar(30) NOT NULL DEFAULT '' COMMENT '费用类型',
  `base_dist` decimal(10,1) NOT NULL DEFAULT '0.0' COMMENT '多少km内',
  `base_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '配送费用',
  `grad_dist` decimal(10,1) NOT NULL DEFAULT '0.0' COMMENT '每超出多少km内',
  `grad_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '配送费用',
  `weight_start` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '重量多少内不额外收费',
  `weight_unit` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '每超出多少kg',
  `weight_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '价格',
  `delivery_type` varchar(2000) NOT NULL DEFAULT '' COMMENT '配送类型',
  `area` longtext NOT NULL COMMENT '配送区域',
  `center` varchar(255) NOT NULL DEFAULT '' COMMENT '发货地址中心点',
  `time_is_open` tinyint(4) NOT NULL DEFAULT '0' COMMENT '配送时间设置 0 关闭 1 开启',
  `time_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '时间选取类型 0 每天  1 自定义',
  `time_week` varchar(255) NOT NULL DEFAULT '' COMMENT '营业时间  周一 周二.......',
  `time_interval` int(11) NOT NULL DEFAULT '30' COMMENT '时段设置单位分钟',
  `advance_day` int(11) NOT NULL DEFAULT '0' COMMENT '时间选择需提前多少天',
  `most_day` int(11) NOT NULL DEFAULT '7' COMMENT '最多可预约多少天',
  `start_time` int(11) NOT NULL DEFAULT '0' COMMENT '当日的起始时间',
  `end_time` int(11) NOT NULL DEFAULT '0' COMMENT '当日的营业结束时间',
  `delivery_time` varchar(2000) NOT NULL DEFAULT '' COMMENT '配送时间段',
  PRIMARY KEY (`local_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for shop_delivery_shipping_template
-- ----------------------------
DROP TABLE IF EXISTS `shop_delivery_shipping_template`;
CREATE TABLE `shop_delivery_shipping_template` (
  `template_id` int(11) NOT NULL AUTO_INCREMENT,
  `template_name` varchar(50) NOT NULL DEFAULT '' COMMENT '模板名称',
  `fee_type` varchar(20) NOT NULL DEFAULT '' COMMENT '运费计算方式1.重量2体积3按件',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  `is_free_shipping` smallint(6) NOT NULL DEFAULT '0' COMMENT '该区域是否包邮',
  `no_delivery` smallint(6) NOT NULL DEFAULT '0' COMMENT '是否指定该区域不配送',
  PRIMARY KEY (`template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='运费模板';

-- ----------------------------
-- Table structure for shop_delivery_shipping_template_item
-- ----------------------------
DROP TABLE IF EXISTS `shop_delivery_shipping_template_item`;
CREATE TABLE `shop_delivery_shipping_template_item` (
  `item_id` int(11) NOT NULL AUTO_INCREMENT,
  `template_id` int(11) NOT NULL DEFAULT '0' COMMENT '模板id',
  `city_id` int(11) NOT NULL DEFAULT '0' COMMENT '市id',
  `snum` int(11) NOT NULL DEFAULT '0' COMMENT '起步计算标准',
  `sprice` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '起步计算价格',
  `xnum` int(11) NOT NULL DEFAULT '0' COMMENT '续步计算标准',
  `xprice` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '续步计算价格',
  `fee_type` varchar(20) NOT NULL DEFAULT '1' COMMENT '运费计算方式',
  `fee_area_ids` text NOT NULL COMMENT '运费设置区域id集',
  `fee_area_names` text NOT NULL COMMENT '运费设置区域名称集',
  `no_delivery` smallint(6) NOT NULL DEFAULT '0' COMMENT '是否指定该区域不配送',
  `no_delivery_area_ids` text NOT NULL COMMENT '不配送的区域id集',
  `no_delivery_area_names` text NOT NULL COMMENT '不配送的区域名称集',
  `is_free_shipping` smallint(6) NOT NULL DEFAULT '0' COMMENT '该区域是否包邮',
  `free_shipping_area_ids` text NOT NULL COMMENT '包邮的区域id集',
  `free_shipping_area_names` text NOT NULL COMMENT '包邮的区域名称集',
  `free_shipping_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '满足包邮的条件',
  `free_shipping_num` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`item_id`),
  KEY `express_template_item_city_id` (`city_id`),
  KEY `express_template_item_fee_type` (`fee_type`),
  KEY `express_template_item_template_id` (`template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='运费模板细节';

-- ----------------------------
-- Table structure for shop_goods
-- ----------------------------
DROP TABLE IF EXISTS `shop_goods`;
CREATE TABLE `shop_goods` (
  `goods_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '商品id',
  `goods_name` varchar(255) NOT NULL DEFAULT '' COMMENT '商品名称',
  `goods_type` varchar(50) NOT NULL DEFAULT 'real' COMMENT '商品类型',
  `sub_title` varchar(255) NOT NULL DEFAULT '' COMMENT '副标题',
  `goods_cover` varchar(2000) NOT NULL DEFAULT '' COMMENT '商品封面',
  `goods_image` text COMMENT '商品图片',
  `goods_video` varchar(555) DEFAULT '' COMMENT '商品视频',
  `goods_category` varchar(255) NOT NULL DEFAULT '' COMMENT '商品分类',
  `goods_desc` text COMMENT '商品介绍',
  `brand_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品品牌id',
  `label_ids` varchar(255) NOT NULL DEFAULT '' COMMENT '标签组',
  `service_ids` varchar(255) NOT NULL DEFAULT '' COMMENT '商品服务',
  `unit` varchar(255) NOT NULL DEFAULT '件' COMMENT '单位',
  `stock` int(11) NOT NULL DEFAULT '0' COMMENT '商品库存（总和）',
  `sale_num` int(11) NOT NULL DEFAULT '0' COMMENT '销量',
  `virtual_sale_num` int(11) NOT NULL DEFAULT '0' COMMENT '虚拟销量',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '商品状态（1.正常0下架）',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `delivery_type` varchar(255) NOT NULL DEFAULT '' COMMENT '支持的配送方式',
  `is_free_shipping` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否免邮',
  `fee_type` varchar(255) NOT NULL DEFAULT '' COMMENT '运费设置，选择模板：template，固定运费：fixed',
  `delivery_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '固定运费',
  `delivery_template_id` int(11) NOT NULL DEFAULT '0' COMMENT '运费模板',
  `virtual_auto_delivery` tinyint(4) NOT NULL DEFAULT '0' COMMENT '虚拟商品是否自动发货',
  `virtual_receive_type` varchar(255) NOT NULL DEFAULT 'artificial' COMMENT '虚拟商品收货方式，auto：自动收货，artificial：买家确认收货，verify：到店核销',
  `virtual_verify_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '虚拟商品核销有效期类型，0：不限，1：购买后几日有效，2：指定过期日期',
  `virtual_indate` int(11) NOT NULL DEFAULT '0' COMMENT '虚拟到期时间',
  `supplier_id` int(11) NOT NULL DEFAULT '0' COMMENT '供应商id',
  `attr_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品参数id',
  `attr_format` text COMMENT '商品参数内容，json格式',
  `is_discount` int(11) NOT NULL DEFAULT '0' COMMENT '是否参与限时折扣',
  `member_discount` varchar(255) NOT NULL DEFAULT '' COMMENT '会员等级折扣，不参与：空，会员折扣：discount，指定会员价：fixed_price',
  `poster_id` int(11) NOT NULL DEFAULT '0' COMMENT '海报id',
  `form_id` int(11) NOT NULL DEFAULT '0' COMMENT '万能表单id',
  `is_limit` tinyint(4) NOT NULL DEFAULT '0' COMMENT '商品是否限购(0:否 1:是)',
  `limit_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '限购类型，1：单次限购，2：单人限购',
  `max_buy` int(11) NOT NULL DEFAULT '0' COMMENT '限购数',
  `min_buy` int(11) NOT NULL DEFAULT '0' COMMENT '起购数',
  `is_gift` tinyint(4) NOT NULL DEFAULT '0' COMMENT '商品是否赠品(0:否 1:是)',
  `access_num` int(11) NOT NULL DEFAULT '0' COMMENT '访问次数（浏览量）',
  `cart_num` int(11) NOT NULL DEFAULT '0' COMMENT '加入购物车数量',
  `pay_num` int(11) NOT NULL DEFAULT '0' COMMENT '支付件数',
  `pay_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '支付总金额',
  `collect_num` int(11) NOT NULL DEFAULT '0' COMMENT '收藏数量',
  `evaluate_num` int(11) NOT NULL DEFAULT '0' COMMENT '评论数量',
  `refund_num` int(11) NOT NULL DEFAULT '0' COMMENT '退款件数',
  `refund_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '退款总额',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  `delete_time` int(11) NOT NULL DEFAULT '0' COMMENT '删除时间',
  PRIMARY KEY (`goods_id`),
  KEY `idx_goods_category` (`goods_category`),
  KEY `idx_goods_create_time` (`create_time`),
  KEY `idx_goods_delete_time` (`delete_time`),
  KEY `idx_goods_name` (`goods_name`),
  KEY `idx_goods_sort` (`sort`),
  KEY `idx_goods_status` (`status`),
  KEY `idx_goods_sub_title` (`sub_title`),
  KEY `IDX_ns_goods_goods_class` (`goods_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品表';

-- ----------------------------
-- Table structure for shop_goods_attr
-- ----------------------------
DROP TABLE IF EXISTS `shop_goods_attr`;
CREATE TABLE `shop_goods_attr` (
  `attr_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '商品参数id',
  `attr_name` varchar(255) NOT NULL DEFAULT '' COMMENT '参数名称',
  `attr_value_format` text COMMENT '参数值，json格式',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '参数排序号',
  PRIMARY KEY (`attr_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品参数表';

-- ----------------------------
-- Table structure for shop_goods_brand
-- ----------------------------
DROP TABLE IF EXISTS `shop_goods_brand`;
CREATE TABLE `shop_goods_brand` (
  `brand_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '品牌ID',
  `brand_name` varchar(100) NOT NULL DEFAULT '' COMMENT '品牌名称',
  `logo` varchar(255) NOT NULL DEFAULT '' COMMENT '品牌logo',
  `desc` text NOT NULL COMMENT '品牌介绍',
  `color_json` varchar(255) NOT NULL DEFAULT '' COMMENT '自定义颜色（文字、背景、边框），json格式',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `delete_time` int(11) NOT NULL DEFAULT '0' COMMENT '删除时间',
  PRIMARY KEY (`brand_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品品牌表';

-- ----------------------------
-- Table structure for shop_goods_browse
-- ----------------------------
DROP TABLE IF EXISTS `shop_goods_browse`;
CREATE TABLE `shop_goods_browse` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '浏览人',
  `sku_id` int(11) NOT NULL DEFAULT '0' COMMENT 'sku_id',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品id',
  `browse_time` int(11) NOT NULL DEFAULT '0' COMMENT '浏览时间',
  `goods_cover` varchar(2000) NOT NULL DEFAULT '' COMMENT '商品图片',
  `goods_name` varchar(255) NOT NULL DEFAULT '' COMMENT '商品名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品浏览历史';

-- ----------------------------
-- Table structure for shop_goods_category
-- ----------------------------
DROP TABLE IF EXISTS `shop_goods_category`;
CREATE TABLE `shop_goods_category` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '商品分类id',
  `category_name` varchar(255) NOT NULL DEFAULT '' COMMENT '分类名称',
  `image` varchar(255) NOT NULL DEFAULT '' COMMENT '分类图片',
  `level` int(11) NOT NULL DEFAULT '0' COMMENT '层级',
  `pid` int(11) NOT NULL DEFAULT '0' COMMENT '上级分类id',
  `category_full_name` varchar(255) NOT NULL DEFAULT '' COMMENT '组装分类名称',
  `is_show` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否显示（1：显示，0：不显示）',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序号',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品分类表';

-- ----------------------------
-- Table structure for shop_goods_collect
-- ----------------------------
DROP TABLE IF EXISTS `shop_goods_collect`;
CREATE TABLE `shop_goods_collect` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '会员id',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品id',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '收藏时间',
  PRIMARY KEY (`id`),
  KEY `IDX_member_collect_goods` (`goods_id`),
  KEY `IDX_member_collect_member` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品收藏记录表';

-- ----------------------------
-- Table structure for shop_goods_evaluate
-- ----------------------------
DROP TABLE IF EXISTS `shop_goods_evaluate`;
CREATE TABLE `shop_goods_evaluate` (
  `evaluate_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL DEFAULT '0' COMMENT '订单id',
  `order_goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '订单项ID',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '会员ID',
  `member_head` varchar(255) NOT NULL DEFAULT '' COMMENT '会员头像',
  `member_name` varchar(100) NOT NULL DEFAULT '' COMMENT '会员名称',
  `content` varchar(3000) NOT NULL COMMENT '评价内容',
  `images` varchar(3000) NOT NULL DEFAULT '' COMMENT '评价图片',
  `is_anonymous` tinyint(4) NOT NULL DEFAULT '1' COMMENT '1匿名  2不匿名',
  `scores` tinyint(4) NOT NULL DEFAULT '1' COMMENT '评论分数 1-5',
  `is_audit` tinyint(4) NOT NULL DEFAULT '1' COMMENT '审核状态 1待审 2通过 3拒绝',
  `explain_first` varchar(3000) NOT NULL DEFAULT '' COMMENT '解释内容',
  `topping` int(11) NOT NULL DEFAULT '0' COMMENT '排序 置顶',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '评论时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`evaluate_id`),
  KEY `idx_shop_goods_evaluate_create_time` (`create_time`),
  KEY `idx_shop_goods_evaluate_goods_id` (`goods_id`),
  KEY `idx_shop_goods_evaluate_is_anonymous` (`is_anonymous`),
  KEY `idx_shop_goods_evaluate_is_audit` (`is_audit`),
  KEY `idx_shop_goods_evaluate_member_id` (`member_id`),
  KEY `idx_shop_goods_evaluate_order_id` (`order_id`),
  KEY `idx_shop_goods_evaluate_scores` (`scores`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品评价表';

-- ----------------------------
-- Table structure for shop_goods_label
-- ----------------------------
DROP TABLE IF EXISTS `shop_goods_label`;
CREATE TABLE `shop_goods_label` (
  `label_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '标签ID',
  `label_name` varchar(255) NOT NULL DEFAULT '' COMMENT '标签名称',
  `group_id` int(11) NOT NULL DEFAULT '0' COMMENT '标签分组id',
  `style_type` varchar(255) NOT NULL DEFAULT '' COMMENT '效果设置，diy：自定义，icon：图片',
  `color_json` varchar(255) NOT NULL DEFAULT '' COMMENT '自定义颜色（文字、背景、边框），json格式',
  `icon` varchar(255) NOT NULL DEFAULT '' COMMENT '图标',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态，1：启用，0；关闭',
  `memo` varchar(255) NOT NULL DEFAULT '' COMMENT '标签说明',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`label_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COMMENT='商品标签表';

-- ----------------------------
-- Table structure for shop_goods_label_group
-- ----------------------------
DROP TABLE IF EXISTS `shop_goods_label_group`;
CREATE TABLE `shop_goods_label_group` (
  `group_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '分组ID',
  `group_name` varchar(255) NOT NULL DEFAULT '' COMMENT '分组名称',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='商品标签分组表';

-- ----------------------------
-- Table structure for shop_goods_rank
-- ----------------------------
DROP TABLE IF EXISTS `shop_goods_rank`;
CREATE TABLE `shop_goods_rank` (
  `rank_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '榜单名称',
  `rank_type` varchar(100) NOT NULL DEFAULT '' COMMENT '排行周期 day=天，week=周，month=月, quarter=季度',
  `goods_source` varchar(100) NOT NULL DEFAULT '' COMMENT '来源类型 goods=指定商品，category=指定分类，brand=指定品牌, label=指定标签',
  `rule_type` varchar(100) NOT NULL DEFAULT '' COMMENT '排序规则 sale=按照销量，collect=按收藏数，evaluate=按评价数, access=按照浏览量',
  `goods_json` text COMMENT '商品信息',
  `category_ids` varchar(255) NOT NULL DEFAULT '' COMMENT '商品分类id',
  `brand_ids` varchar(255) NOT NULL DEFAULT '0' COMMENT '商品品牌id',
  `label_ids` varchar(255) NOT NULL DEFAULT '' COMMENT '商品标签id，多个逗号隔开',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序号',
  `status` int(11) NOT NULL DEFAULT '1' COMMENT '显示状态（0不显示 1显示）',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`rank_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品排行榜';

-- ----------------------------
-- Table structure for shop_goods_service
-- ----------------------------
DROP TABLE IF EXISTS `shop_goods_service`;
CREATE TABLE `shop_goods_service` (
  `service_id` int(11) NOT NULL AUTO_INCREMENT,
  `service_name` varchar(255) NOT NULL DEFAULT '' COMMENT '服务名称',
  `image` varchar(255) NOT NULL DEFAULT '' COMMENT '图片',
  `desc` varchar(255) NOT NULL DEFAULT '' COMMENT '描述',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品服务表';

-- ----------------------------
-- Table structure for shop_goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `shop_goods_sku`;
CREATE TABLE `shop_goods_sku` (
  `sku_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '商品sku_id',
  `sku_name` varchar(255) NOT NULL DEFAULT '' COMMENT '商品sku名称',
  `sku_image` varchar(2000) NOT NULL DEFAULT '' COMMENT 'sku主图',
  `sku_no` varchar(255) NOT NULL DEFAULT '' COMMENT '商品sku编码',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品id',
  `sku_spec_format` text COMMENT 'sku规格格式',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'sku单价',
  `market_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '划线价',
  `sale_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '实际卖价（有活动显示活动价，默认原价）',
  `cost_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'sku成本价',
  `stock` int(11) NOT NULL DEFAULT '0' COMMENT '商品sku库存',
  `weight` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '重量（单位kg）',
  `volume` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '体积（单位立方米）',
  `sale_num` int(11) NOT NULL DEFAULT '0' COMMENT '销量',
  `is_default` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否默认',
  `member_price` text COMMENT '会员价，json格式，指定会员价，数据结构为：{"level_1":"10.00","level_2":"10.00"}',
  PRIMARY KEY (`sku_id`),
  KEY `idx_goods_sku_is_default` (`is_default`),
  KEY `idx_goods_sku_price` (`price`),
  KEY `idx_goods_sku_sale_price` (`sale_price`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品规格表';

-- ----------------------------
-- Table structure for shop_goods_spec
-- ----------------------------
DROP TABLE IF EXISTS `shop_goods_spec`;
CREATE TABLE `shop_goods_spec` (
  `spec_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '规格id',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '关联商品id',
  `spec_name` varchar(255) NOT NULL DEFAULT '' COMMENT '规格项名称',
  `spec_values` text COMMENT '规格值名称，多个逗号隔开',
  PRIMARY KEY (`spec_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品规格项/值表';

-- ----------------------------
-- Table structure for shop_goods_stat
-- ----------------------------
DROP TABLE IF EXISTS `shop_goods_stat`;
CREATE TABLE `shop_goods_stat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` varchar(255) NOT NULL DEFAULT '' COMMENT '日期',
  `date_time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品id',
  `cart_num` int(11) NOT NULL DEFAULT '0' COMMENT '加入购物车数量',
  `sale_num` int(11) NOT NULL DEFAULT '0' COMMENT '商品销量（下单数）',
  `pay_num` int(11) NOT NULL DEFAULT '0' COMMENT '支付件数',
  `pay_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '支付总金额',
  `refund_num` int(11) NOT NULL DEFAULT '0' COMMENT '退款件数',
  `refund_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '退款总额',
  `access_num` int(11) NOT NULL DEFAULT '0' COMMENT '访问次数（浏览量）',
  `collect_num` int(11) NOT NULL DEFAULT '0' COMMENT '收藏数量',
  `evaluate_num` int(11) NOT NULL DEFAULT '0' COMMENT '评论数量',
  `goods_visit_member_count` int(11) NOT NULL DEFAULT '0' COMMENT '商品访客数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品数据统计';

-- ----------------------------
-- Table structure for shop_invoice
-- ----------------------------
DROP TABLE IF EXISTS `shop_invoice`;
CREATE TABLE `shop_invoice` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '发票id',
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '会员id',
  `trade_type` varchar(10) NOT NULL DEFAULT 'order' COMMENT '开票分类 order:订单',
  `trade_id` int(11) NOT NULL DEFAULT '0' COMMENT '业务id',
  `header_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '抬头类型',
  `header_name` varchar(100) NOT NULL DEFAULT '' COMMENT '名称（发票抬头）',
  `type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '发票类型',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '发票内容',
  `tax_number` varchar(50) NOT NULL DEFAULT '' COMMENT '公司税号',
  `mobile` varchar(30) NOT NULL DEFAULT '' COMMENT '开票人手机号',
  `email` varchar(100) NOT NULL DEFAULT '' COMMENT '开票人邮箱',
  `telephone` varchar(30) NOT NULL DEFAULT '' COMMENT '注册电话',
  `address` varchar(255) NOT NULL DEFAULT '' COMMENT '注册地址',
  `bank_name` varchar(50) NOT NULL DEFAULT '' COMMENT '开户银行',
  `bank_card_number` varchar(50) NOT NULL DEFAULT '' COMMENT '银行账号',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '开票金额',
  `is_invoice` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否开票',
  `invoice_number` varchar(50) NOT NULL DEFAULT '' COMMENT '发票代码',
  `invoice_voucher` varchar(1000) NOT NULL DEFAULT '' COMMENT '发票凭证',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '申请时间',
  `invoice_time` int(11) NOT NULL DEFAULT '0' COMMENT '开票时间',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '是否生效',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='发票表';

-- ----------------------------
-- Table structure for shop_manjian
-- ----------------------------
DROP TABLE IF EXISTS `shop_manjian`;
CREATE TABLE `shop_manjian` (
  `manjian_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '满减活动id',
  `manjian_name` varchar(50) NOT NULL DEFAULT '' COMMENT '名称',
  `condition_type` varchar(255) NOT NULL DEFAULT 'over_n_yuan' COMMENT '条件类型 over_n_yuan:满N元  over_n_piece:满N件',
  `goods_type` varchar(255) NOT NULL DEFAULT 'all_goods' COMMENT '参与商品 all_goods:全部商品参与  selected_goods:指定商品 selected_goods_not:指定商品不参与 ',
  `join_member_type` varchar(255) NOT NULL DEFAULT 'all_member' COMMENT '参与会员 all_member:所有会员参与  selected_member_level:指定会员等级  selected_member_label:指定会员标签 ',
  `rule_type` varchar(255) NOT NULL DEFAULT 'ladder' COMMENT '优惠规格 ladder:阶梯优惠  cycle:循环优惠',
  `rule_json` text COMMENT '优惠规则json',
  `goods_ids` text COMMENT '商品id集',
  `level_ids` text COMMENT '会员等级id集',
  `label_ids` text COMMENT '会员标签id集',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态（0未开始1进行中2已结束-1已关闭）',
  `start_time` int(11) NOT NULL DEFAULT '0' COMMENT '开始时间',
  `end_time` int(11) NOT NULL DEFAULT '0' COMMENT '结束时间',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `total_order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '活动累计金额',
  `total_order_num` int(11) NOT NULL DEFAULT '0' COMMENT '活动累计订单数',
  `total_member_num` int(11) NOT NULL DEFAULT '0' COMMENT '活动参与会员数',
  `total_point` int(11) NOT NULL DEFAULT '0' COMMENT '活动累计赠送积分',
  `total_balance` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '活动累计赠送余额',
  `total_coupon_num` int(11) NOT NULL DEFAULT '0' COMMENT '活动累计赠送优惠券数',
  `total_goods_num` int(11) NOT NULL DEFAULT '0' COMMENT '活动累计赠送商品数',
  PRIMARY KEY (`manjian_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='满减活动表';

-- ----------------------------
-- Table structure for shop_manjian_give_records
-- ----------------------------
DROP TABLE IF EXISTS `shop_manjian_give_records`;
CREATE TABLE `shop_manjian_give_records` (
  `record_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '赠送记录id',
  `manjian_id` int(11) NOT NULL DEFAULT '0' COMMENT '满减送活动id',
  `order_id` int(11) NOT NULL DEFAULT '0' COMMENT '订单id',
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '会员id',
  `level` int(11) NOT NULL DEFAULT '0' COMMENT '优惠层级',
  `point` int(11) NOT NULL DEFAULT '0' COMMENT '赠送积分数量',
  `balance` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '赠送余额',
  `coupon_json` text COMMENT '赠送优惠券',
  `goods_json` text COMMENT '赠送商品',
  `sku_ids` varchar(255) NOT NULL DEFAULT '' COMMENT '满足条件的商品规格id',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='满减送记录表';

-- ----------------------------
-- Table structure for shop_manjian_goods
-- ----------------------------
DROP TABLE IF EXISTS `shop_manjian_goods`;
CREATE TABLE `shop_manjian_goods` (
  `manjian_goods_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '满减商品活动id',
  `manjian_id` int(11) NOT NULL DEFAULT '0' COMMENT '满减活动id',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品id',
  `sku_id` int(11) NOT NULL DEFAULT '0' COMMENT '规格id',
  `goods_type` varchar(255) NOT NULL DEFAULT 'all_goods' COMMENT '参与商品 all_goods:全部商品参与  selected_goods:指定商品 selected_goods_not:指定商品不参与 ',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态（0未开始1进行中2已结束-1已关闭）',
  PRIMARY KEY (`manjian_goods_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='满减商品表';

-- ----------------------------
-- Table structure for shop_newcomer_member_records
-- ----------------------------
DROP TABLE IF EXISTS `shop_newcomer_member_records`;
CREATE TABLE `shop_newcomer_member_records` (
  `record_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '会员id',
  `validity_time` int(11) NOT NULL DEFAULT '0' COMMENT '有效期',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '参与时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `is_join` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否参与',
  `order_id` int(11) NOT NULL DEFAULT '0' COMMENT '参与订单id',
  `goods_ids` varchar(255) NOT NULL DEFAULT '' COMMENT '参与商品id集合',
  `sku_ids` varchar(255) NOT NULL DEFAULT '' COMMENT '参与商品规格id集合',
  PRIMARY KEY (`record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='新人专享会员参与记录表';

-- ----------------------------
-- Table structure for shop_order
-- ----------------------------
DROP TABLE IF EXISTS `shop_order`;
CREATE TABLE `shop_order` (
  `order_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_no` varchar(50) NOT NULL DEFAULT '' COMMENT '订单编号',
  `body` varchar(1000) NOT NULL DEFAULT '' COMMENT '订单内容',
  `order_type` varchar(55) NOT NULL DEFAULT '' COMMENT '订单类型',
  `order_from` varchar(55) NOT NULL DEFAULT '' COMMENT '订单来源',
  `out_trade_no` varchar(50) NOT NULL DEFAULT '' COMMENT '支付流水号',
  `status` varchar(55) NOT NULL DEFAULT '' COMMENT '订单状态',
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '会员id',
  `ip` varchar(20) NOT NULL DEFAULT '' COMMENT 'ip',
  `goods_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品金额',
  `delivery_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '配送金额',
  `discount_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '优惠金额',
  `order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '订单金额',
  `pay_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '支付金额',
  `invoice_id` int(11) NOT NULL DEFAULT '0' COMMENT '发票id，0表示不开发票',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `pay_time` int(11) NOT NULL DEFAULT '0' COMMENT '订单支付时间',
  `delivery_time` int(11) NOT NULL DEFAULT '0' COMMENT '订单发货时间',
  `take_time` int(11) NOT NULL DEFAULT '0' COMMENT '订单收货时间',
  `finish_time` int(11) NOT NULL DEFAULT '0' COMMENT '订单完成时间',
  `close_time` int(11) NOT NULL DEFAULT '0' COMMENT '订单关闭时间',
  `delete_time` int(11) NOT NULL DEFAULT '0' COMMENT '是否删除(针对后台)',
  `timeout` int(11) NOT NULL DEFAULT '0' COMMENT '通用业务超时时间记录',
  `delivery_type` varchar(255) NOT NULL DEFAULT '' COMMENT '配送方式',
  `take_store_id` int(11) NOT NULL DEFAULT '0' COMMENT '自提点',
  `taker_name` varchar(500) NOT NULL DEFAULT '' COMMENT '收货人',
  `taker_mobile` varchar(50) NOT NULL DEFAULT '' COMMENT '收货人手机号',
  `taker_province` int(11) NOT NULL DEFAULT '0' COMMENT '收货省',
  `taker_city` int(11) NOT NULL DEFAULT '0' COMMENT '收货市',
  `taker_district` int(11) NOT NULL DEFAULT '0' COMMENT '收货区县',
  `taker_address` varchar(1000) NOT NULL DEFAULT '' COMMENT '收货地址',
  `taker_full_address` varchar(1000) NOT NULL DEFAULT '' COMMENT '收货详细地址',
  `taker_longitude` varchar(50) NOT NULL DEFAULT '' COMMENT '收货地址经度',
  `taker_latitude` varchar(50) NOT NULL DEFAULT '' COMMENT '收货详细纬度',
  `taker_store_id` varchar(50) NOT NULL DEFAULT '' COMMENT '收货门店',
  `is_enable_refund` int(11) NOT NULL DEFAULT '0' COMMENT '是否允许退款',
  `member_remark` varchar(50) NOT NULL DEFAULT '' COMMENT '会员留言信息',
  `shop_remark` varchar(255) NOT NULL DEFAULT '' COMMENT '商家留言',
  `close_remark` varchar(255) NOT NULL DEFAULT '' COMMENT '关闭原因',
  `close_type` varchar(255) NOT NULL DEFAULT '' COMMENT '关闭来源(未支付自动关闭   手动关闭  退款关闭)',
  `refund_status` int(11) NOT NULL DEFAULT '1' COMMENT '退款状态  1不存在退款  2 部分退款  3 全部退款',
  `has_goods_types` varchar(255) NOT NULL DEFAULT '' COMMENT '包含的商品类型 json',
  `is_evaluate` int(11) NOT NULL DEFAULT '0' COMMENT '是否评论',
  `relate_id` int(11) NOT NULL DEFAULT '0' COMMENT '关联id',
  `point` int(11) NOT NULL DEFAULT '0' COMMENT '积分兑换',
  `activity_type` varchar(255) NOT NULL DEFAULT '' COMMENT '营销类型',
  `form_record_id` int(11) NOT NULL DEFAULT '0' COMMENT '万能表单记录id',
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- ----------------------------
-- Table structure for shop_order_batch_delivery
-- ----------------------------
DROP TABLE IF EXISTS `shop_order_batch_delivery`;
CREATE TABLE `shop_order_batch_delivery` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `main_id` int(11) NOT NULL DEFAULT '0' COMMENT '操作人id',
  `status` int(11) NOT NULL DEFAULT '1' COMMENT '状态 进行中  已完成  已失败',
  `type` varchar(255) NOT NULL DEFAULT '操作类型 批量发货  批量打单 ....' COMMENT '操作类型',
  `total_num` int(11) NOT NULL DEFAULT '0' COMMENT '总发货单数',
  `success_num` int(11) NOT NULL DEFAULT '0' COMMENT '成功发货单数',
  `fail_num` int(11) NOT NULL DEFAULT '0' COMMENT '失败发货单数',
  `data` varchar(2000) NOT NULL DEFAULT '' COMMENT '导入文件的路径',
  `output` varchar(500) NOT NULL DEFAULT '' COMMENT '对外输出记录',
  `fail_output` varchar(500) NOT NULL DEFAULT '' COMMENT '失败记录',
  `fail_remark` varchar(1000) NOT NULL DEFAULT '' COMMENT '失败原因',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '操作时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单批量发货表';

-- ----------------------------
-- Table structure for shop_order_delivery
-- ----------------------------
DROP TABLE IF EXISTS `shop_order_delivery`;
CREATE TABLE `shop_order_delivery` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `order_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '包裹名称',
  `delivery_type` varchar(50) NOT NULL DEFAULT '' COMMENT '配送方式',
  `sub_delivery_type` varchar(50) NOT NULL DEFAULT '' COMMENT '详细配送方式',
  `express_company_id` int(11) NOT NULL DEFAULT '0' COMMENT '快递公司id',
  `express_number` varchar(50) NOT NULL DEFAULT '' COMMENT '配送单号',
  `local_deliver_id` int(11) NOT NULL DEFAULT '0' COMMENT '同城配送员',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '配送状态',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `remark` varchar(1000) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单发货表';

-- ----------------------------
-- Table structure for shop_order_discount
-- ----------------------------
DROP TABLE IF EXISTS `shop_order_discount`;
CREATE TABLE `shop_order_discount` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL DEFAULT '0' COMMENT '订单id',
  `order_goods_ids` varchar(255) NOT NULL DEFAULT '' COMMENT '参与的订单商品项',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '类型 discount 优惠，gift 赠送',
  `num` int(11) NOT NULL DEFAULT '0' COMMENT '使用数量',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '优惠金额',
  `discount_type` varchar(255) NOT NULL DEFAULT '' COMMENT '优惠类型',
  `discount_type_id` int(11) NOT NULL DEFAULT '0' COMMENT '优惠类型id',
  `content` varchar(255) NOT NULL DEFAULT '' COMMENT '订单优惠说明',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `status` int(11) NOT NULL DEFAULT '1' COMMENT '状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单优惠表';

-- ----------------------------
-- Table structure for shop_order_discount_goods
-- ----------------------------
DROP TABLE IF EXISTS `shop_order_discount_goods`;
CREATE TABLE `shop_order_discount_goods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_discount_id` int(11) NOT NULL DEFAULT '0' COMMENT '订单优惠id',
  `order_id` int(11) NOT NULL DEFAULT '0' COMMENT '订单id',
  `order_goods_id` varchar(255) NOT NULL DEFAULT '' COMMENT '参与的订单商品项',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '类型 discount 优惠，gift 赠送',
  `num` int(11) NOT NULL DEFAULT '0' COMMENT '使用数量',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '优惠金额',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单项优惠表';

-- ----------------------------
-- Table structure for shop_order_goods
-- ----------------------------
DROP TABLE IF EXISTS `shop_order_goods`;
CREATE TABLE `shop_order_goods` (
  `order_goods_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL DEFAULT '0' COMMENT '订单id',
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '购买会员id',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品id',
  `sku_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品规格id',
  `goods_name` varchar(400) NOT NULL DEFAULT '' COMMENT '商品名称',
  `sku_name` varchar(400) NOT NULL DEFAULT '' COMMENT '商品规格名称',
  `goods_image` varchar(2000) NOT NULL DEFAULT '' COMMENT '商品图片',
  `sku_image` varchar(1000) NOT NULL DEFAULT '' COMMENT 'sku规格图片',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品单价',
  `num` int(11) NOT NULL DEFAULT '0' COMMENT '购买数量',
  `goods_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品总价',
  `is_enable_refund` int(11) NOT NULL DEFAULT '0' COMMENT '是否允许退款',
  `goods_type` varchar(255) NOT NULL DEFAULT '' COMMENT '商品类型',
  `delivery_status` varchar(255) NOT NULL DEFAULT '' COMMENT '配送状态',
  `delivery_id` int(11) NOT NULL DEFAULT '0' COMMENT '发货单号',
  `discount_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '优惠金额',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态',
  `order_refund_no` varchar(50) NOT NULL DEFAULT '' COMMENT '退款单号',
  `order_goods_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '订单项实付金额',
  `original_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品原价',
  `extend` varchar(1000) NOT NULL DEFAULT '' COMMENT '数据项扩展',
  `verify_count` int(11) NOT NULL DEFAULT '0' COMMENT '已核销次数',
  `verify_expire_time` int(11) NOT NULL DEFAULT '0' COMMENT '过期时间 0 为永久',
  `is_verify` int(11) NOT NULL DEFAULT '0' COMMENT '是否需要核销',
  `shop_active_refund` tinyint(4) NOT NULL DEFAULT '0' COMMENT '商家主动退款（0否  1是）',
  `shop_active_refund_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商家主动退款金额',
  `is_gift` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否是赠品（0否  1是）',
  `form_record_id` int(11) NOT NULL DEFAULT '0' COMMENT '万能表单记录id',
  PRIMARY KEY (`order_goods_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单项表';

-- ----------------------------
-- Table structure for shop_order_log
-- ----------------------------
DROP TABLE IF EXISTS `shop_order_log`;
CREATE TABLE `shop_order_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `order_id` int(11) NOT NULL DEFAULT '0' COMMENT '订单id',
  `main_type` varchar(255) NOT NULL DEFAULT '操作人类型',
  `main_id` int(11) NOT NULL DEFAULT '0' COMMENT '操作人id',
  `status` int(11) DEFAULT NULL COMMENT '订单状态',
  `type` varchar(255) NOT NULL DEFAULT '',
  `content` varchar(255) DEFAULT NULL COMMENT '日志内容',
  `create_time` int(11) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单日志表';

-- ----------------------------
-- Table structure for shop_order_refund
-- ----------------------------
DROP TABLE IF EXISTS `shop_order_refund`;
CREATE TABLE `shop_order_refund` (
  `refund_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL DEFAULT '0' COMMENT '订单id',
  `order_goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '订单项id',
  `order_refund_no` varchar(255) NOT NULL DEFAULT '0' COMMENT '退款单号',
  `refund_type` varchar(255) NOT NULL DEFAULT '0' COMMENT '退款方式 ',
  `reason` varchar(255) NOT NULL DEFAULT '0' COMMENT '退款原因 ',
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '会员id',
  `apply_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '申请退款',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '实际退款',
  `status` varchar(30) NOT NULL DEFAULT '0' COMMENT '退款状态',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `transfer_time` int(11) NOT NULL DEFAULT '0' COMMENT '转账时间',
  `remark` varchar(2000) NOT NULL DEFAULT '描述' COMMENT '描述',
  `voucher` varchar(2000) NOT NULL DEFAULT '凭证' COMMENT '凭证',
  `source` varchar(255) NOT NULL DEFAULT '' COMMENT '来源 system 系统 member 会员',
  `timeout` int(11) NOT NULL DEFAULT '0' COMMENT '操作超时时间',
  `refund_no` varchar(255) NOT NULL DEFAULT '' COMMENT '退款交易号',
  `delivery` varchar(3000) NOT NULL DEFAULT '' COMMENT '退货配送信息',
  `shop_reason` varchar(255) NOT NULL DEFAULT '' COMMENT '上架拒绝原因',
  `refund_address` varchar(1000) NOT NULL DEFAULT '' COMMENT '商家退货地址',
  `is_refund_delivery` int(11) NOT NULL DEFAULT '0' COMMENT '是否退运费',
  PRIMARY KEY (`refund_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单退款表';

-- ----------------------------
-- Table structure for shop_order_refund_log
-- ----------------------------
DROP TABLE IF EXISTS `shop_order_refund_log`;
CREATE TABLE `shop_order_refund_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `order_refund_no` varchar(100) NOT NULL DEFAULT '' COMMENT '退款编号',
  `main_type` varchar(255) NOT NULL DEFAULT '操作人类型',
  `main_id` int(11) NOT NULL DEFAULT '0' COMMENT '操作人id',
  `status` int(11) DEFAULT NULL COMMENT '退款状态',
  `type` varchar(255) NOT NULL DEFAULT '',
  `content` varchar(255) DEFAULT NULL COMMENT '日志内容',
  `create_time` int(11) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单退款日志表';

-- ----------------------------
-- Table structure for shop_point_exchange
-- ----------------------------
DROP TABLE IF EXISTS `shop_point_exchange`;
CREATE TABLE `shop_point_exchange` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '兑换活动主键id',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '兑换类型（商品、优惠券、红包）',
  `names` varchar(255) NOT NULL DEFAULT '' COMMENT '兑换标题',
  `title` varchar(255) NOT NULL COMMENT '副标题',
  `image` text COMMENT '图片',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '兑换状态 0 下架  1上架  -1 删除',
  `product_detail` text COMMENT '兑换产品信息',
  `point` int(11) NOT NULL DEFAULT '0' COMMENT '兑换所需积分',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '兑换所需金额',
  `limit_num` int(11) NOT NULL DEFAULT '0' COMMENT '限制数量',
  `content` text COMMENT '产品介绍',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `total_point_num` int(11) DEFAULT '0' COMMENT '积分消费总额',
  `total_price_num` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '总支付金额',
  `total_order_num` int(11) DEFAULT '0' COMMENT '订单笔数',
  `total_member_num` int(11) DEFAULT '0' COMMENT '参与会员数',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `stock` int(11) NOT NULL DEFAULT '0' COMMENT '库存',
  `total_exchange_num` int(11) NOT NULL DEFAULT '0' COMMENT '兑换数量',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='积分兑换表';

-- ----------------------------
-- Table structure for shop_point_exchange_order
-- ----------------------------
DROP TABLE IF EXISTS `shop_point_exchange_order`;
CREATE TABLE `shop_point_exchange_order` (
  `order_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '兑换记录id',
  `order_no` varchar(255) NOT NULL DEFAULT '' COMMENT '订单编号',
  `out_trade_no` varchar(255) NOT NULL DEFAULT '' COMMENT '支付流水表',
  `exchange_id` int(11) NOT NULL DEFAULT '0' COMMENT '兑换活动id',
  `exchange_name` varchar(255) NOT NULL DEFAULT '' COMMENT '兑换商品名称',
  `exchange_image` varchar(600) NOT NULL DEFAULT '' COMMENT '兑换商品图片',
  `type` varchar(50) NOT NULL DEFAULT '' COMMENT '兑换类型',
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '消费会员id',
  `member_address_id` int(11) NOT NULL DEFAULT '0' COMMENT '会员地址id',
  `relate_id` int(11) NOT NULL DEFAULT '0' COMMENT '关联业务id',
  `relate_order_id` int(11) NOT NULL DEFAULT '0' COMMENT '关联订单id',
  `point` int(11) NOT NULL DEFAULT '0' COMMENT '使用积分',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '支付金额',
  `balance` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '赠送余额',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `pay_time` int(11) NOT NULL DEFAULT '0' COMMENT '兑换时间',
  `close_time` int(11) NOT NULL DEFAULT '0' COMMENT '关闭时间',
  `delete_time` int(11) NOT NULL DEFAULT '0' COMMENT '订单删除',
  `num` int(11) NOT NULL DEFAULT '0' COMMENT '兑换数量',
  `status` varchar(50) NOT NULL DEFAULT '' COMMENT '订单状态',
  `order_money` decimal(10,2) NOT NULL COMMENT '订单金额',
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='积分兑换订单表';

-- ----------------------------
-- Table structure for shop_stat
-- ----------------------------
DROP TABLE IF EXISTS `shop_stat`;
CREATE TABLE `shop_stat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` varchar(255) NOT NULL DEFAULT '' COMMENT '日期',
  `date_time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
  `order_num` int(11) NOT NULL DEFAULT '0' COMMENT '订单总数',
  `sale_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '销售总额',
  `refund_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '退款总额',
  `access_sum` int(11) NOT NULL DEFAULT '0' COMMENT '访问数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for shop_store
-- ----------------------------
DROP TABLE IF EXISTS `shop_store`;
CREATE TABLE `shop_store` (
  `store_id` int(11) NOT NULL AUTO_INCREMENT,
  `store_name` varchar(255) NOT NULL DEFAULT '' COMMENT '门店名称',
  `store_desc` varchar(3000) NOT NULL DEFAULT '' COMMENT '简介',
  `store_logo` varchar(255) NOT NULL DEFAULT '' COMMENT '门店logo',
  `store_mobile` varchar(255) NOT NULL DEFAULT '' COMMENT '手机号',
  `province_id` int(11) NOT NULL DEFAULT '0' COMMENT '省id',
  `city_id` int(11) NOT NULL DEFAULT '0' COMMENT '市',
  `district_id` int(11) NOT NULL DEFAULT '0' COMMENT '县（区）',
  `address` varchar(255) NOT NULL DEFAULT '' COMMENT '详细地址',
  `full_address` varchar(255) NOT NULL DEFAULT '' COMMENT '完整地址',
  `longitude` varchar(255) NOT NULL DEFAULT '' COMMENT '经度',
  `latitude` varchar(255) NOT NULL DEFAULT '' COMMENT '纬度',
  `trade_time` varchar(255) NOT NULL DEFAULT '' COMMENT '营业时间',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='自提门店表';

-- ----------------------------
-- Table structure for sport_ai_report
-- ----------------------------
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

-- ----------------------------
-- Table structure for sport_ai_report_template
-- ----------------------------
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

-- ----------------------------
-- Table structure for sport_athlete
-- ----------------------------
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

-- ----------------------------
-- Table structure for sport_base_item
-- ----------------------------
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
) ENGINE=InnoDB AUTO_INCREMENT=188 DEFAULT CHARSET=utf8mb4 COMMENT='基础项目表';

-- ----------------------------
-- Table structure for sport_base_item_backup
-- ----------------------------
DROP TABLE IF EXISTS `sport_base_item_backup`;
CREATE TABLE `sport_base_item_backup` (
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
) ENGINE=InnoDB AUTO_INCREMENT=188 DEFAULT CHARSET=utf8mb4 COMMENT='基础项目表';

-- ----------------------------
-- Table structure for sport_category
-- ----------------------------
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
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COMMENT='项目大类表';

-- ----------------------------
-- Table structure for sport_category_backup
-- ----------------------------
DROP TABLE IF EXISTS `sport_category_backup`;
CREATE TABLE `sport_category_backup` (
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
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COMMENT='项目大类表';

-- ----------------------------
-- Table structure for sport_dict
-- ----------------------------
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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COMMENT='数据字典表';

-- ----------------------------
-- Table structure for sport_dict_item
-- ----------------------------
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
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COMMENT='数据字典项表';

-- ----------------------------
-- Table structure for sport_display_config
-- ----------------------------
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

-- ----------------------------
-- Table structure for sport_display_data
-- ----------------------------
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

-- ----------------------------
-- Table structure for sport_display_template
-- ----------------------------
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

-- ----------------------------
-- Table structure for sport_equipment_maintenance
-- ----------------------------
DROP TABLE IF EXISTS `sport_equipment_maintenance`;
CREATE TABLE `sport_equipment_maintenance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `equipment_id` int(11) NOT NULL DEFAULT '0' COMMENT '设备ID',
  `maintenance_type` varchar(50) NOT NULL DEFAULT '' COMMENT '维护类型：日常维护/故障维修/定期保养',
  `maintenance_date` date NOT NULL COMMENT '维护日期',
  `maintenance_person` varchar(50) DEFAULT '' COMMENT '维护人员',
  `maintenance_content` text COMMENT '维护内容',
  `maintenance_cost` decimal(10,2) DEFAULT '0.00' COMMENT '维护费用',
  `next_maintenance_date` date DEFAULT NULL COMMENT '下次维护日期',
  `remarks` text COMMENT '备注',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_equipment_id` (`equipment_id`),
  KEY `idx_maintenance_date` (`maintenance_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='设备维护记录表';

-- ----------------------------
-- Table structure for sport_event
-- ----------------------------
DROP TABLE IF EXISTS `sport_event`;
CREATE TABLE `sport_event` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `series_id` int(11) DEFAULT NULL COMMENT '系列赛ID，可为空表示独立赛事',
  `name` varchar(100) NOT NULL COMMENT '赛事名称',
  `event_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '赛事类型：1独立赛事 2系列赛事',
  `member_id` int(11) DEFAULT '0' COMMENT '会员编号',
  `delete_time` int(11) DEFAULT '0' COMMENT '删除时间',
  `year` int(11) NOT NULL COMMENT '举办年份',
  `season` varchar(20) DEFAULT NULL COMMENT '赛季',
  `start_time` int(11) NOT NULL COMMENT '开始时间',
  `end_time` int(11) NOT NULL COMMENT '结束时间',
  `location` varchar(200) NOT NULL COMMENT '举办地点',
  `location_detail` varchar(500) DEFAULT NULL COMMENT '详细地址',
  `latitude` decimal(10,7) DEFAULT NULL COMMENT '纬度',
  `longitude` decimal(10,7) DEFAULT NULL COMMENT '经度',
  `full_address` varchar(500) DEFAULT NULL COMMENT '完整地址',
  `organizer_id` int(11) NOT NULL COMMENT '主办方ID',
  `organizer_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '举办者类型：1个人 2单位',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `age_groups` text COMMENT '年龄组设置，JSON格式，如：["不限年龄","U8","U10","U12"]',
  `age_group_display` tinyint(4) NOT NULL DEFAULT '0' COMMENT '年龄组显示方式：0不显示 1显示',
  `signup_fields` json DEFAULT NULL COMMENT '报名字段配置(JSON: [{key,label,required}])',
  `registration_start_time` varchar(20) DEFAULT NULL COMMENT '报名开始时间，格式：YYYY-MM-DD',
  `registration_end_time` varchar(20) DEFAULT NULL COMMENT '报名结束时间，格式：YYYY-MM-DD',
  `registration_fee` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '报名费（元）',
  `max_participants` int(11) NOT NULL DEFAULT '0' COMMENT '总报名人数限制，0表示不限制',
  `group_size` int(11) NOT NULL DEFAULT '0' COMMENT '每组人数',
  `rounds` int(11) NOT NULL DEFAULT '0' COMMENT '比赛轮次',
  `allow_duplicate_registration` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否允许重复报名：0不允许 1允许',
  `show_participant_count` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否显示报名人数：0不显示 1显示',
  `show_progress` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否显示比赛进度：0不显示 1显示',
  `contact_name` varchar(50) DEFAULT NULL COMMENT '联系人姓名',
  `contact_phone` varchar(20) DEFAULT NULL COMMENT '联系电话',
  `contact_wechat` varchar(50) DEFAULT NULL COMMENT '微信号',
  `contact_email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `address_detail` varchar(100) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `idx_series_id` (`series_id`),
  KEY `idx_member_id` (`member_id`),
  KEY `idx_age_group_display` (`age_group_display`),
  KEY `idx_registration_time` (`registration_start_time`,`registration_end_time`),
  KEY `idx_status_sort` (`status`,`sort`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COMMENT='赛事表';

-- ----------------------------
-- Table structure for sport_event_co_organizer
-- ----------------------------
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

-- ----------------------------
-- Table structure for sport_event_series
-- ----------------------------
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='赛事系列表';

-- ----------------------------
-- Table structure for sport_import_record
-- ----------------------------
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

-- ----------------------------
-- Table structure for sport_item
-- ----------------------------
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
  `venue_count` int(11) NOT NULL DEFAULT '0' COMMENT '需要的场地数量',
  `venue_type` varchar(50) NOT NULL DEFAULT '' COMMENT '场地类型，如：乒乓球台、羽毛球场地',
  `referee_requirements` text COMMENT '裁判要求',
  `rounds` int(11) NOT NULL DEFAULT '0' COMMENT '比赛轮次',
  `allow_duplicate_registration` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否允许重复报名：0不允许 1允许',
  `is_round_robin` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否循环赛(小组)：0否 1是',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `group_size` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_event_id` (`event_id`),
  KEY `idx_base_item_id` (`base_item_id`),
  KEY `idx_category_id` (`category_id`),
  KEY `idx_registration_fee` (`registration_fee`),
  KEY `idx_max_participants` (`max_participants`)
) ENGINE=InnoDB AUTO_INCREMENT=680 DEFAULT CHARSET=utf8mb4 COMMENT='比赛项目表';

-- ----------------------------
-- Table structure for sport_item_equipment
-- ----------------------------
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

-- ----------------------------
-- Table structure for sport_item_limit
-- ----------------------------
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

-- ----------------------------
-- Table structure for sport_item_referee
-- ----------------------------
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

-- ----------------------------
-- Table structure for sport_item_rule
-- ----------------------------
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

-- ----------------------------
-- Table structure for sport_item_venue
-- ----------------------------
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

-- ----------------------------
-- Table structure for sport_item_venue_assignment
-- ----------------------------
DROP TABLE IF EXISTS `sport_item_venue_assignment`;
CREATE TABLE `sport_item_venue_assignment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) NOT NULL COMMENT '比赛项目ID',
  `venue_id` int(11) NOT NULL COMMENT '场地ID',
  `assignment_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '分配类型：1独占 2共享',
  `start_time` int(11) DEFAULT NULL COMMENT '开始使用时间',
  `end_time` int(11) DEFAULT NULL COMMENT '结束使用时间',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_item_venue` (`item_id`,`venue_id`),
  KEY `idx_item_id` (`item_id`),
  KEY `idx_venue_id` (`venue_id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COMMENT='项目场地分配表';

-- ----------------------------
-- Table structure for sport_match
-- ----------------------------
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

-- ----------------------------
-- Table structure for sport_nav_config
-- ----------------------------
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COMMENT='导航配置表';

-- ----------------------------
-- Table structure for sport_organizer
-- ----------------------------
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COMMENT='主办方表';

-- ----------------------------
-- Table structure for sport_record
-- ----------------------------
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

-- ----------------------------
-- Table structure for sport_record_history
-- ----------------------------
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

-- ----------------------------
-- Table structure for sport_record_statistics
-- ----------------------------
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

-- ----------------------------
-- Table structure for sport_record_verify
-- ----------------------------
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

-- ----------------------------
-- Table structure for sport_registration
-- ----------------------------
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

-- ----------------------------
-- Table structure for sport_relay_order
-- ----------------------------
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

-- ----------------------------
-- Table structure for sport_score
-- ----------------------------
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

-- ----------------------------
-- Table structure for sport_series_co_organizer
-- ----------------------------
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

-- ----------------------------
-- Table structure for sport_subcategory
-- ----------------------------
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

-- ----------------------------
-- Table structure for sport_team_member
-- ----------------------------
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

-- ----------------------------
-- Table structure for sport_venue
-- ----------------------------
DROP TABLE IF EXISTS `sport_venue`;
CREATE TABLE `sport_venue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) NOT NULL DEFAULT '0' COMMENT '赛事ID，0表示通用场地',
  `name` varchar(100) NOT NULL COMMENT '场地名称',
  `venue_code` varchar(50) NOT NULL DEFAULT '' COMMENT '场地编码，如：table_1, court_1',
  `venue_category` varchar(50) NOT NULL DEFAULT '' COMMENT '场地分类，如：乒乓球台、羽毛球场地',
  `venue_type` varchar(50) NOT NULL DEFAULT '' COMMENT '场地类型编码，如：pingpong_table, badminton_court',
  `type` varchar(50) NOT NULL DEFAULT '' COMMENT '场地类型',
  `capacity` int(11) DEFAULT NULL COMMENT '容纳人数',
  `location` varchar(200) NOT NULL COMMENT '位置',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
  `is_available` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否可用：0不可用 1可用',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_event_id` (`event_id`),
  KEY `idx_venue_code` (`venue_code`),
  KEY `idx_venue_type` (`venue_type`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COMMENT='场地表';

-- ----------------------------
-- Table structure for sport_venue_equipment
-- ----------------------------
DROP TABLE IF EXISTS `sport_venue_equipment`;
CREATE TABLE `sport_venue_equipment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `venue_id` int(11) NOT NULL DEFAULT '0' COMMENT '场地ID',
  `equipment_name` varchar(100) NOT NULL DEFAULT '' COMMENT '设备名称',
  `equipment_type` varchar(50) NOT NULL DEFAULT '' COMMENT '设备类型',
  `equipment_code` varchar(50) NOT NULL DEFAULT '' COMMENT '设备编码',
  `brand` varchar(50) DEFAULT '' COMMENT '品牌',
  `model` varchar(50) DEFAULT '' COMMENT '型号',
  `purchase_date` date DEFAULT NULL COMMENT '购买日期',
  `warranty_expire` date DEFAULT NULL COMMENT '保修到期',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：0故障 1正常 2维修中',
  `last_maintenance` date DEFAULT NULL COMMENT '最后维护日期',
  `next_maintenance` date DEFAULT NULL COMMENT '下次维护日期',
  `maintenance_cycle` int(11) DEFAULT '0' COMMENT '维护周期（天）',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_venue_id` (`venue_id`),
  KEY `idx_equipment_code` (`equipment_code`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='场馆设备表';

-- ----------------------------
-- Table structure for sport_venue_facility
-- ----------------------------
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

-- ----------------------------
-- Table structure for sport_venue_schedule
-- ----------------------------
DROP TABLE IF EXISTS `sport_venue_schedule`;
CREATE TABLE `sport_venue_schedule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `venue_id` int(11) NOT NULL COMMENT '场地ID',
  `item_id` int(11) DEFAULT NULL COMMENT '比赛项目ID',
  `match_id` int(11) DEFAULT NULL COMMENT '具体比赛ID',
  `start_time` int(11) NOT NULL COMMENT '开始时间',
  `end_time` int(11) NOT NULL COMMENT '结束时间',
  `usage_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '使用类型：1比赛 2训练 3其他',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0取消 1已安排 2进行中 3已完成',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_venue_id` (`venue_id`),
  KEY `idx_item_id` (`item_id`),
  KEY `idx_match_id` (`match_id`),
  KEY `idx_time_range` (`start_time`,`end_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='场地使用时间表';

-- ----------------------------
-- Table structure for stat_hour
-- ----------------------------
DROP TABLE IF EXISTS `stat_hour`;
CREATE TABLE `stat_hour` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `addon` varchar(255) NOT NULL DEFAULT '' COMMENT '插件',
  `field` varchar(255) NOT NULL DEFAULT '' COMMENT '统计字段',
  `field_total` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '总计',
  `year` int(11) NOT NULL DEFAULT '0' COMMENT '年',
  `month` int(11) NOT NULL DEFAULT '0' COMMENT '月',
  `day` int(11) NOT NULL DEFAULT '0' COMMENT '天',
  `start_time` int(11) NOT NULL DEFAULT '0' COMMENT '当日开始时间戳',
  `last_time` int(11) NOT NULL DEFAULT '0' COMMENT '最后执行时间',
  `hour_0` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_1` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_2` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_3` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_4` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_5` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_6` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_7` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_8` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_9` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_10` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_11` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_12` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_13` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_14` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_15` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_16` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_17` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_18` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_19` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_20` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_21` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_22` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_23` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='小时统计表';

-- ----------------------------
-- Table structure for sys_agreement
-- ----------------------------
DROP TABLE IF EXISTS `sys_agreement`;
CREATE TABLE `sys_agreement` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `agreement_key` varchar(255) NOT NULL DEFAULT '' COMMENT '协议关键字',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '协议标题',
  `content` text COMMENT '协议内容',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='协议表';

-- ----------------------------
-- Table structure for sys_area
-- ----------------------------
DROP TABLE IF EXISTS `sys_area`;
CREATE TABLE `sys_area` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL DEFAULT '0' COMMENT '父级',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '名称',
  `shortname` varchar(30) NOT NULL DEFAULT '' COMMENT '简称',
  `longitude` varchar(30) NOT NULL DEFAULT '' COMMENT '经度',
  `latitude` varchar(30) NOT NULL DEFAULT '' COMMENT '纬度',
  `level` smallint(6) NOT NULL DEFAULT '0' COMMENT '级别',
  `sort` mediumint(9) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态1有效',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=460400501 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='地址表';

-- ----------------------------
-- Table structure for sys_attachment
-- ----------------------------
DROP TABLE IF EXISTS `sys_attachment`;
CREATE TABLE `sys_attachment` (
  `att_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '附件名称',
  `real_name` varchar(255) NOT NULL DEFAULT '' COMMENT '原始文件名',
  `path` varchar(255) NOT NULL DEFAULT '' COMMENT '完整地址',
  `dir` varchar(200) NOT NULL DEFAULT '' COMMENT '附件路径',
  `att_size` char(30) NOT NULL DEFAULT '' COMMENT '附件大小',
  `att_type` char(30) NOT NULL DEFAULT '' COMMENT '附件类型image,video',
  `storage_type` varchar(20) NOT NULL DEFAULT '' COMMENT '图片上传类型 local本地  aliyun  阿里云oss  qiniu  七牛 ....',
  `cate_id` int(11) NOT NULL DEFAULT '0' COMMENT '相关分类',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '上传时间',
  `update_time` int(11) NOT NULL DEFAULT '0',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT '网络地址',
  PRIMARY KEY (`att_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='附件管理表';

-- ----------------------------
-- Table structure for sys_attachment_category
-- ----------------------------
DROP TABLE IF EXISTS `sys_attachment_category`;
CREATE TABLE `sys_attachment_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL DEFAULT '0' COMMENT '父级ID',
  `type` varchar(50) NOT NULL DEFAULT '' COMMENT '文件管理类型（image,video）',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '分类名称',
  `enname` varchar(50) NOT NULL DEFAULT '' COMMENT '分类目录',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='附件分类表';

-- ----------------------------
-- Table structure for sys_backup_records
-- ----------------------------
DROP TABLE IF EXISTS `sys_backup_records`;
CREATE TABLE `sys_backup_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `version` varchar(255) NOT NULL DEFAULT '' COMMENT '备份版本号',
  `backup_key` varchar(255) NOT NULL DEFAULT '' COMMENT '备份标识',
  `content` varchar(255) NOT NULL DEFAULT '' COMMENT '备份内容',
  `status` varchar(255) NOT NULL DEFAULT '' COMMENT '状态',
  `fail_reason` longtext COMMENT '失败原因',
  `remark` varchar(500) NOT NULL DEFAULT '' COMMENT '备注',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `complete_time` int(11) NOT NULL DEFAULT '0' COMMENT '完成时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='备份记录表';

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `config_key` varchar(255) NOT NULL DEFAULT '' COMMENT '配置项关键字',
  `value` text COMMENT '配置值json',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否启用 1启用 0不启用',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  `addon` varchar(255) NOT NULL DEFAULT '' COMMENT '所属插件',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='系统配置表';

-- ----------------------------
-- Table structure for sys_cron_task
-- ----------------------------
DROP TABLE IF EXISTS `sys_cron_task`;
CREATE TABLE `sys_cron_task` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` int(11) NOT NULL DEFAULT '1' COMMENT '任务状态',
  `count` int(11) NOT NULL DEFAULT '0' COMMENT '执行次数',
  `title` char(50) NOT NULL DEFAULT '' COMMENT '任务名称',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '任务模式  cron  定时任务  crond 周期任务',
  `crond_type` char(200) NOT NULL DEFAULT '' COMMENT '任务周期',
  `crond_length` int(11) NOT NULL DEFAULT '0' COMMENT '任务周期',
  `task` varchar(500) NOT NULL DEFAULT '' COMMENT '任务命令',
  `data` longtext COMMENT '附加参数',
  `status_desc` varchar(1000) NOT NULL DEFAULT '' COMMENT '上次执行结果',
  `last_time` int(11) NOT NULL DEFAULT '0' COMMENT '最后执行时间',
  `next_time` int(11) NOT NULL DEFAULT '0' COMMENT '下次执行时间',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `delete_time` int(11) NOT NULL DEFAULT '0' COMMENT '删除时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT=' 系统任务';

-- ----------------------------
-- Table structure for sys_dict
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict`;
CREATE TABLE `sys_dict` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '字典名称',
  `key` varchar(100) NOT NULL DEFAULT '' COMMENT '字典关键词',
  `dictionary` text NOT NULL COMMENT '字典数据',
  `memo` varchar(255) NOT NULL DEFAULT '',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='数据字典表';

-- ----------------------------
-- Table structure for sys_export
-- ----------------------------
DROP TABLE IF EXISTS `sys_export`;
CREATE TABLE `sys_export` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `export_key` varchar(255) NOT NULL DEFAULT '' COMMENT '主题关键字',
  `export_num` int(11) NOT NULL DEFAULT '0' COMMENT '导出数据数量',
  `file_path` varchar(255) NOT NULL DEFAULT '' COMMENT '文件存储路径',
  `file_size` varchar(255) NOT NULL DEFAULT '' COMMENT '文件大小',
  `export_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '导出状态',
  `fail_reason` varchar(255) NOT NULL DEFAULT '' COMMENT '失败原因',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '导出时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='导出报表';

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `app_type` varchar(255) NOT NULL DEFAULT 'admin' COMMENT '应用类型',
  `menu_name` varchar(32) NOT NULL DEFAULT '' COMMENT '菜单名称',
  `menu_short_name` varchar(50) NOT NULL DEFAULT '' COMMENT '菜单短标题',
  `menu_key` varchar(255) NOT NULL DEFAULT '' COMMENT '菜单标识（菜单输入，接口自动生成）',
  `parent_key` varchar(255) NOT NULL DEFAULT '' COMMENT '父级key',
  `menu_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '菜单类型 0目录 1菜单 2按钮',
  `icon` varchar(500) NOT NULL DEFAULT '' COMMENT '图标 菜单有效',
  `api_url` varchar(100) NOT NULL DEFAULT '' COMMENT 'api接口地址',
  `router_path` varchar(128) NOT NULL DEFAULT '' COMMENT '菜单路由地址 前端使用',
  `view_path` varchar(255) NOT NULL DEFAULT '' COMMENT '菜单文件地址',
  `methods` varchar(10) NOT NULL DEFAULT '' COMMENT '提交方式POST GET PUT DELETE',
  `sort` int(11) NOT NULL DEFAULT '1' COMMENT '排序',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '正常，禁用（禁用后不允许访问）',
  `is_show` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否显示',
  `create_time` int(11) NOT NULL DEFAULT '0',
  `delete_time` int(11) NOT NULL DEFAULT '0',
  `addon` varchar(255) NOT NULL DEFAULT '' COMMENT '所属插件',
  `source` varchar(255) NOT NULL DEFAULT 'system' COMMENT '菜单来源   system 系统文件  create 新建菜单  generator 代码生成器',
  `menu_attr` varchar(50) NOT NULL DEFAULT '' COMMENT '菜单属性 common 公共 system 系统',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=461 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='菜单表';

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(50) NOT NULL DEFAULT '' COMMENT '标识',
  `sms_content` text COMMENT '短信配置参数',
  `is_wechat` tinyint(4) NOT NULL DEFAULT '0' COMMENT '公众号模板消息（0：关闭，1：开启）',
  `is_weapp` tinyint(4) NOT NULL DEFAULT '0' COMMENT '小程序订阅消息（0：关闭，1：开启）',
  `is_sms` tinyint(4) NOT NULL DEFAULT '0' COMMENT '发送短信（0：关闭，1：开启）',
  `wechat_template_id` varchar(255) NOT NULL DEFAULT '' COMMENT '微信模版消息id',
  `weapp_template_id` varchar(255) NOT NULL DEFAULT '' COMMENT '微信小程序订阅消息id',
  `sms_id` varchar(255) NOT NULL DEFAULT '' COMMENT '短信id（对应短信配置）',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '添加时间',
  `wechat_first` varchar(255) NOT NULL DEFAULT '' COMMENT '微信头部',
  `wechat_remark` varchar(255) NOT NULL DEFAULT '' COMMENT '微信说明',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='通知模型';

-- ----------------------------
-- Table structure for sys_notice_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice_log`;
CREATE TABLE `sys_notice_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '通知记录ID',
  `key` varchar(255) DEFAULT '' COMMENT '消息key',
  `notice_type` varchar(50) DEFAULT 'sms' COMMENT '消息类型（sms,wechat.weapp）',
  `uid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '通知的用户id',
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '消息的会员id',
  `nickname` varchar(255) NOT NULL DEFAULT '' COMMENT '接收人用户昵称或姓名',
  `receiver` varchar(255) NOT NULL DEFAULT '' COMMENT '接收人（对应手机号，openid）',
  `content` text COMMENT '消息数据',
  `is_click` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '点击次数',
  `is_visit` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '访问次数',
  `visit_time` int(11) NOT NULL DEFAULT '0' COMMENT '访问时间',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '消息时间',
  `result` varchar(1000) NOT NULL DEFAULT '' COMMENT '结果',
  `params` text,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='通知记录表';

-- ----------------------------
-- Table structure for sys_notice_sms_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice_sms_log`;
CREATE TABLE `sys_notice_sms_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `mobile` varchar(11) NOT NULL DEFAULT '' COMMENT '手机号码',
  `sms_type` varchar(32) NOT NULL DEFAULT '' COMMENT '发送关键字（注册、找回密码）',
  `key` varchar(32) NOT NULL DEFAULT '' COMMENT '发送关键字（注册、找回密码）',
  `template_id` varchar(50) NOT NULL DEFAULT '',
  `content` text NOT NULL COMMENT '发送内容',
  `params` text NOT NULL COMMENT '数据参数',
  `status` varchar(32) NOT NULL DEFAULT 'sending' COMMENT '发送状态：sending-发送中；success-发送成功；fail-发送失败',
  `result` text COMMENT '短信结果',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `send_time` int(11) NOT NULL DEFAULT '0' COMMENT '发送时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `delete_time` int(11) NOT NULL DEFAULT '0' COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='短信发送表';

-- ----------------------------
-- Table structure for sys_poster
-- ----------------------------
DROP TABLE IF EXISTS `sys_poster`;
CREATE TABLE `sys_poster` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '海报名称',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '海报类型',
  `channel` varchar(255) NOT NULL DEFAULT '' COMMENT '海报支持渠道',
  `value` text COMMENT '配置值json',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否启用 1启用 2不启用',
  `addon` varchar(255) NOT NULL DEFAULT '' COMMENT '所属插件',
  `is_default` int(11) NOT NULL DEFAULT '0' COMMENT '是否默认海报，1：是，0：否',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='海报表';

-- ----------------------------
-- Table structure for sys_printer
-- ----------------------------
DROP TABLE IF EXISTS `sys_printer`;
CREATE TABLE `sys_printer` (
  `printer_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `printer_name` varchar(255) NOT NULL DEFAULT '' COMMENT '打印机名称',
  `brand` varchar(255) NOT NULL DEFAULT '' COMMENT '设备品牌（易联云，365，飞鹅）',
  `printer_code` varchar(255) NOT NULL DEFAULT '' COMMENT '打印机编号',
  `printer_key` varchar(255) NOT NULL DEFAULT '' COMMENT '打印机秘钥',
  `open_id` varchar(255) NOT NULL DEFAULT '' COMMENT '开发者id',
  `apikey` varchar(255) NOT NULL DEFAULT '' COMMENT '开发者密钥',
  `template_type` varchar(255) NOT NULL DEFAULT '' COMMENT '小票打印模板类型，多个逗号隔开',
  `trigger` varchar(255) NOT NULL DEFAULT '' COMMENT '触发打印时机',
  `value` longtext COMMENT '打印模板数据，json格式',
  `print_width` varchar(255) NOT NULL DEFAULT '58mm' COMMENT '纸张宽度',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态（0，关闭，1：开启）',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`printer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='小票打印机';

-- ----------------------------
-- Table structure for sys_printer_template
-- ----------------------------
DROP TABLE IF EXISTS `sys_printer_template`;
CREATE TABLE `sys_printer_template` (
  `template_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `template_name` varchar(255) NOT NULL DEFAULT '' COMMENT '模板名称',
  `template_type` varchar(255) NOT NULL DEFAULT '' COMMENT '模板类型',
  `value` longtext COMMENT '模板数据，json格式',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='小票打印模板';

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `role_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '角色id',
  `role_name` varchar(255) NOT NULL DEFAULT '' COMMENT '角色名称',
  `rules` text COMMENT '角色权限(menus_id)',
  `addon_keys` text COMMENT '角色应用权限（应用key）',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '状态',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '最后修改时间',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='角色表';

-- ----------------------------
-- Table structure for sys_schedule
-- ----------------------------
DROP TABLE IF EXISTS `sys_schedule`;
CREATE TABLE `sys_schedule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `addon` varchar(255) NOT NULL DEFAULT '' COMMENT '所属插件',
  `key` varchar(255) NOT NULL DEFAULT '' COMMENT '计划任务模板key',
  `status` int(11) NOT NULL DEFAULT '1' COMMENT '任务状态 是否启用',
  `time` varchar(500) NOT NULL DEFAULT '' COMMENT '任务周期  json结构',
  `count` int(11) NOT NULL DEFAULT '0' COMMENT '执行次数',
  `last_time` int(11) NOT NULL DEFAULT '0' COMMENT '最后执行时间',
  `next_time` int(11) NOT NULL DEFAULT '0' COMMENT '下次执行时间',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `delete_time` int(11) NOT NULL DEFAULT '0' COMMENT '删除时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='系统任务';

-- ----------------------------
-- Table structure for sys_schedule_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_schedule_log`;
CREATE TABLE `sys_schedule_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '执行记录id',
  `schedule_id` int(11) NOT NULL DEFAULT '0' COMMENT '任务id',
  `addon` varchar(255) NOT NULL DEFAULT '' COMMENT '所属插件',
  `key` varchar(255) NOT NULL DEFAULT '' COMMENT '计划任务模板key',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '计划任务名称',
  `execute_time` int(11) NOT NULL COMMENT '执行时间',
  `execute_result` text COMMENT '日志信息',
  `status` varchar(255) NOT NULL DEFAULT '' COMMENT '执行状态',
  `class` varchar(255) NOT NULL DEFAULT '',
  `job` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='计划任务执行记录';

-- ----------------------------
-- Table structure for sys_upgrade_records
-- ----------------------------
DROP TABLE IF EXISTS `sys_upgrade_records`;
CREATE TABLE `sys_upgrade_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `upgrade_key` varchar(255) NOT NULL DEFAULT '' COMMENT '升级标识',
  `app_key` varchar(255) NOT NULL DEFAULT '' COMMENT '插件标识',
  `name` longtext COMMENT '升级名称',
  `content` text COMMENT '升级内容',
  `prev_version` varchar(255) NOT NULL DEFAULT '' COMMENT '前一版本',
  `current_version` varchar(255) NOT NULL DEFAULT '' COMMENT '当前版本',
  `status` varchar(255) NOT NULL DEFAULT '' COMMENT '状态',
  `fail_reason` longtext COMMENT '失败原因',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `complete_time` int(11) NOT NULL DEFAULT '0' COMMENT '完成时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='升级记录表';

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `uid` smallint(5) unsigned NOT NULL AUTO_INCREMENT COMMENT '系统用户ID',
  `username` varchar(255) NOT NULL DEFAULT '' COMMENT '用户账号',
  `head_img` varchar(255) NOT NULL DEFAULT '',
  `password` varchar(100) NOT NULL DEFAULT '' COMMENT '用户密码',
  `real_name` varchar(16) NOT NULL DEFAULT '' COMMENT '实际姓名',
  `last_ip` varchar(50) NOT NULL DEFAULT '' COMMENT '最后一次登录ip',
  `last_time` int(10) NOT NULL DEFAULT '0' COMMENT '最后一次登录时间',
  `create_time` int(10) NOT NULL DEFAULT '0' COMMENT '添加时间',
  `login_count` int(10) NOT NULL DEFAULT '0' COMMENT '登录次数',
  `is_del` tinyint(3) NOT NULL DEFAULT '0',
  `delete_time` int(11) NOT NULL DEFAULT '0' COMMENT '删除时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(3) NOT NULL DEFAULT '1' COMMENT '后台管理员状态 1有效0无效',
  `role_ids` varchar(255) NOT NULL DEFAULT '' COMMENT '权限组',
  `is_admin` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否是管理员',
  PRIMARY KEY (`uid`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='后台管理员表';

-- ----------------------------
-- Table structure for sys_user_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_log`;
CREATE TABLE `sys_user_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '管理员操作记录ID',
  `ip` varchar(50) NOT NULL DEFAULT '' COMMENT '登录IP',
  `uid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '管理员id',
  `username` varchar(64) NOT NULL DEFAULT '' COMMENT '管理员姓名',
  `url` varchar(128) NOT NULL DEFAULT '' COMMENT '链接',
  `params` longtext COMMENT '参数',
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT '请求方式',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='管理员操作记录表';

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `role_ids` varchar(255) NOT NULL DEFAULT '' COMMENT '角色id',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '添加时间',
  `is_admin` int(11) NOT NULL DEFAULT '0' COMMENT '是否是超级管理员',
  `status` int(11) NOT NULL DEFAULT '1' COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='用户权限表';

-- ----------------------------
-- Table structure for verifier
-- ----------------------------
DROP TABLE IF EXISTS `verifier`;
CREATE TABLE `verifier` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL DEFAULT '0' COMMENT '会员id',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '添加时间',
  `verify_type` varchar(255) NOT NULL DEFAULT '' COMMENT '核销类型',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='核销员表';

-- ----------------------------
-- Table structure for verify
-- ----------------------------
DROP TABLE IF EXISTS `verify`;
CREATE TABLE `verify` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL DEFAULT '' COMMENT '核销码',
  `data` varchar(255) NOT NULL DEFAULT '' COMMENT '核销参数',
  `type` varchar(30) NOT NULL DEFAULT '' COMMENT '核销类型',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '核销时间',
  `verifier_member_id` int(11) NOT NULL DEFAULT '0' COMMENT '核销会员id',
  `value` varchar(1000) NOT NULL DEFAULT '' COMMENT '核销内容',
  `body` varchar(500) NOT NULL DEFAULT '' COMMENT '描述',
  `relate_tag` varchar(255) NOT NULL DEFAULT '' COMMENT '业务标识',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='核销记录';

-- ----------------------------
-- Table structure for weapp_version
-- ----------------------------
DROP TABLE IF EXISTS `weapp_version`;
CREATE TABLE `weapp_version` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version` varchar(255) NOT NULL DEFAULT '',
  `version_no` int(11) NOT NULL DEFAULT '1',
  `desc` varchar(255) NOT NULL DEFAULT '' COMMENT '说明',
  `create_time` int(11) NOT NULL DEFAULT '0',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态',
  `update_time` int(11) NOT NULL DEFAULT '0',
  `fail_reason` text,
  `task_key` varchar(20) NOT NULL DEFAULT '' COMMENT '上传任务key',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='小程序版本';

-- ----------------------------
-- Table structure for web_adv
-- ----------------------------
DROP TABLE IF EXISTS `web_adv`;
CREATE TABLE `web_adv` (
  `adv_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `adv_key` varchar(50) NOT NULL DEFAULT '0' COMMENT '广告位key',
  `adv_title` varchar(255) NOT NULL DEFAULT '' COMMENT '广告内容描述',
  `adv_url` varchar(255) NOT NULL DEFAULT '' COMMENT '广告链接',
  `adv_image` varchar(255) NOT NULL DEFAULT '' COMMENT '广告内容图片',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序号',
  `background` varchar(255) NOT NULL DEFAULT '#FFFFFF' COMMENT '背景色',
  PRIMARY KEY (`adv_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='广告表';

-- ----------------------------
-- Table structure for web_friendly_link
-- ----------------------------
DROP TABLE IF EXISTS `web_friendly_link`;
CREATE TABLE `web_friendly_link` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '索引id',
  `link_title` varchar(100) NOT NULL DEFAULT '' COMMENT '标题',
  `link_url` varchar(100) NOT NULL DEFAULT '' COMMENT '链接',
  `link_pic` varchar(100) NOT NULL DEFAULT '' COMMENT '图片',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序号',
  `is_show` int(11) NOT NULL DEFAULT '1' COMMENT '是否显示 1.是 2.否',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='电脑端友情链接表';

-- ----------------------------
-- Table structure for web_nav
-- ----------------------------
DROP TABLE IF EXISTS `web_nav`;
CREATE TABLE `web_nav` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `nav_title` varchar(255) NOT NULL DEFAULT '' COMMENT '导航名称',
  `nav_url` varchar(255) NOT NULL DEFAULT '' COMMENT '链接地址',
  `sort` int(11) NOT NULL COMMENT '排序号',
  `is_blank` int(11) DEFAULT '0' COMMENT '是否新打开',
  `create_time` int(11) DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) DEFAULT '0' COMMENT '修改时间',
  `is_show` smallint(6) NOT NULL DEFAULT '1' COMMENT '是否显示 1显示 0不显示',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='PC导航管理';

-- ----------------------------
-- Table structure for wechat_fans
-- ----------------------------
DROP TABLE IF EXISTS `wechat_fans`;
CREATE TABLE `wechat_fans` (
  `fans_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '粉丝ID',
  `nickname` varchar(255) NOT NULL DEFAULT '' COMMENT '昵称',
  `avatar` varchar(500) NOT NULL DEFAULT '' COMMENT '头像',
  `sex` smallint(6) NOT NULL DEFAULT '1' COMMENT '性别',
  `language` varchar(20) NOT NULL DEFAULT '' COMMENT '用户语言',
  `country` varchar(60) NOT NULL DEFAULT '' COMMENT '国家',
  `province` varchar(255) NOT NULL DEFAULT '' COMMENT '省',
  `city` varchar(255) NOT NULL DEFAULT '' COMMENT '城市',
  `district` varchar(255) NOT NULL DEFAULT '' COMMENT '行政区/县',
  `openid` varchar(255) NOT NULL DEFAULT '' COMMENT '用户的标识，对当前公众号唯一     用户的唯一身份ID',
  `unionid` varchar(255) NOT NULL DEFAULT '' COMMENT '粉丝unionid',
  `groupid` int(11) NOT NULL DEFAULT '0' COMMENT '粉丝所在组id',
  `is_subscribe` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否订阅',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `subscribe_time` int(11) NOT NULL DEFAULT '0' COMMENT '关注时间',
  `subscribe_scene` varchar(100) NOT NULL DEFAULT '' COMMENT '返回用户关注的渠道来源',
  `unsubscribe_time` int(11) NOT NULL DEFAULT '0' COMMENT '取消关注时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '粉丝信息最后更新时间',
  `app_id` int(11) NOT NULL DEFAULT '0' COMMENT '应用appid',
  PRIMARY KEY (`fans_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='微信粉丝列表';

-- ----------------------------
-- Table structure for wechat_media
-- ----------------------------
DROP TABLE IF EXISTS `wechat_media`;
CREATE TABLE `wechat_media` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '类型',
  `value` text COMMENT '值',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  `media_id` varchar(70) NOT NULL DEFAULT '0' COMMENT '微信端返回的素材id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='微信素材表';

-- ----------------------------
-- Table structure for wechat_reply
-- ----------------------------
DROP TABLE IF EXISTS `wechat_reply`;
CREATE TABLE `wechat_reply` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT '规则名称',
  `keyword` varchar(64) NOT NULL DEFAULT '' COMMENT '关键词',
  `reply_type` varchar(30) NOT NULL DEFAULT '' COMMENT '回复类型 subscribe-关注回复 keyword-关键字回复 default-默认回复',
  `matching_type` varchar(30) NOT NULL DEFAULT '1' COMMENT '匹配方式：full 全匹配；like-模糊匹配',
  `content` text NOT NULL COMMENT '回复内容',
  `sort` int(10) unsigned NOT NULL DEFAULT '50' COMMENT '排序',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `delete_time` int(11) NOT NULL DEFAULT '0' COMMENT '删除时间',
  `reply_method` varchar(50) NOT NULL DEFAULT '' COMMENT '回复方式 all 全部 rand随机',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='公众号消息回调表';

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
  `allow_athlete_choice` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否允许运动员自选：0不允许 1允许',
  `disable_number_4` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否禁用包含4的号码：0不禁用 1禁用',
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
