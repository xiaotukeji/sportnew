
ALTER TABLE `shop_order_refund` CHANGE COLUMN `delivery` `delivery` VARCHAR(3000) NOT NULL DEFAULT '' COMMENT '退货配送信息';

ALTER TABLE `shop_order_goods` ADD COLUMN `shop_active_refund` TINYINT(4) NOT NULL DEFAULT 0 COMMENT '商家主动退款（0否  1是）';

ALTER TABLE `shop_order_goods` ADD COLUMN `shop_active_refund_money` DECIMAL(10, 2) NOT NULL DEFAULT 0.00 COMMENT '商家主动退款金额';

DROP TABLE IF EXISTS `shop_newcomer_member_records`;
CREATE TABLE `shop_newcomer_member_records` (
  `record_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` INT(11) NOT NULL DEFAULT 0 COMMENT '会员id',
  `validity_time` INT(11) NOT NULL DEFAULT 0 COMMENT '有效期',
  `create_time` INT(11) NOT NULL DEFAULT 0 COMMENT '参与时间',
  `update_time` INT(11) NOT NULL DEFAULT 0 COMMENT '更新时间',
  `is_join` TINYINT(4) NOT NULL DEFAULT 0 COMMENT '是否参与',
  `order_id` INT(11) NOT NULL DEFAULT 0 COMMENT '参与订单id',
  `goods_ids` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '参与商品id集合',
  `sku_ids` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '参与商品规格id集合',
  PRIMARY KEY (`record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_general_ci COMMENT='新人专享会员参与记录表';


DROP TABLE IF EXISTS `shop_goods_stat`;
CREATE TABLE `shop_goods_stat` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `date` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '日期',
  `date_time` INT(11) NOT NULL DEFAULT 0 COMMENT '时间戳',
  `goods_id` INT(11) NOT NULL DEFAULT 0 COMMENT '商品id',
  `cart_num` INT(11) NOT NULL DEFAULT 0 COMMENT '加入购物车数量',
  `sale_num` INT(11) NOT NULL DEFAULT 0 COMMENT '商品销量（下单数）',
  `pay_num` INT(11) NOT NULL DEFAULT 0 COMMENT '支付件数',
  `pay_money` DECIMAL(10, 2) NOT NULL DEFAULT 0.00 COMMENT '支付总金额',
  `refund_num` INT(11) NOT NULL DEFAULT 0 COMMENT '退款件数',
  `refund_money` DECIMAL(10, 2) NOT NULL DEFAULT 0.00 COMMENT '退款总额',
  `access_num` INT(11) NOT NULL DEFAULT 0 COMMENT '访问次数（浏览量）',
  `collect_num` INT(11) NOT NULL DEFAULT 0 COMMENT '收藏数量',
  `evaluate_num` INT(11) NOT NULL DEFAULT 0 COMMENT '评论数量',
  `goods_visit_member_count` INT(11) NOT NULL DEFAULT 0 COMMENT '商品访客数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_general_ci COMMENT='商品数据统计';


DROP TABLE IF EXISTS `shop_goods_label_group`;
CREATE TABLE `shop_goods_label_group` (
  group_id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '分组ID',
  group_name VARCHAR(255) NOT NULL DEFAULT '' COMMENT '分组名称',
  sort INT(11) NOT NULL DEFAULT 0 COMMENT '排序',
  create_time INT(11) NOT NULL DEFAULT 0 COMMENT '创建时间',
  update_time INT(11) NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (group_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_general_ci COMMENT='商品标签分组表';

ALTER TABLE `shop_goods_label` ADD COLUMN `group_id` INT(11) NOT NULL DEFAULT 0 COMMENT '标签分组id';

ALTER TABLE `shop_goods_label` ADD COLUMN `style_type` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '效果设置，diy：自定义，icon：图片';

ALTER TABLE `shop_goods_label` ADD COLUMN `color_json` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '自定义颜色（文字、背景、边框），json格式';

ALTER TABLE `shop_goods_label` ADD COLUMN `icon` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '图标';

ALTER TABLE `shop_goods_label` ADD COLUMN status INT(11) NOT NULL DEFAULT 0 COMMENT '状态，1：启用，0；关闭';

ALTER TABLE `shop_goods_label` MODIFY `memo` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '标签说明' AFTER `status`;

ALTER TABLE `shop_goods_label` MODIFY `sort` INT(11) NOT NULL DEFAULT 0 COMMENT '排序' AFTER `memo`;

ALTER TABLE `shop_goods_label` MODIFY `create_time` INT(11) NOT NULL DEFAULT 0 COMMENT '创建时间' AFTER `sort`;

ALTER TABLE `shop_goods_label` MODIFY `update_time` INT(11) NOT NULL DEFAULT 0 COMMENT '更新时间' AFTER `create_time`;


DROP TABLE IF EXISTS `shop_goods_browse`;
CREATE TABLE `shop_goods_browse` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id` INT(11) NOT NULL DEFAULT 0 COMMENT '浏览人',
  `sku_id` INT(11) NOT NULL DEFAULT 0 COMMENT 'sku_id',
  `goods_id` INT(11) NOT NULL DEFAULT 0 COMMENT '商品id',
  `browse_time` INT(11) NOT NULL DEFAULT 0 COMMENT '浏览时间',
  `goods_cover` VARCHAR(2000) NOT NULL DEFAULT '' COMMENT '商品图片',
  `goods_name` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '商品名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_general_ci COMMENT='商品浏览历史';

ALTER TABLE `shop_goods` ADD COLUMN `goods_video` VARCHAR(555) DEFAULT '' COMMENT '商品视频';

ALTER TABLE `shop_goods` ADD COLUMN `is_limit` TINYINT(4) NOT NULL DEFAULT 0 COMMENT '商品是否限购(0:否 1:是)';

ALTER TABLE `shop_goods` ADD COLUMN `limit_type` TINYINT(4) NOT NULL DEFAULT 1 COMMENT '限购类型，1：单次限购，2：单人限购';

ALTER TABLE `shop_goods` ADD COLUMN `max_buy` INT(11) NOT NULL DEFAULT 0 COMMENT '限购数';

ALTER TABLE `shop_goods` ADD COLUMN `min_buy` INT(11) NOT NULL DEFAULT 0 COMMENT '起购数';

ALTER TABLE `shop_goods` ADD COLUMN `is_gift` TINYINT(4) NOT NULL DEFAULT 0 COMMENT '商品是否赠品(0:否 1:是)';

ALTER TABLE `shop_goods` ADD COLUMN `access_num` INT(11) NOT NULL DEFAULT 0 COMMENT '访问次数（浏览量）';

ALTER TABLE `shop_goods` ADD COLUMN `cart_num` INT(11) NOT NULL DEFAULT 0 COMMENT '加入购物车数量';

ALTER TABLE `shop_goods` ADD COLUMN `pay_num` INT(11) NOT NULL DEFAULT 0 COMMENT '支付件数';

ALTER TABLE `shop_goods` ADD COLUMN `pay_money` DECIMAL(10, 2) NOT NULL DEFAULT 0.00 COMMENT '支付总金额';

ALTER TABLE `shop_goods` ADD COLUMN `collect_num` INT(11) NOT NULL DEFAULT 0 COMMENT '收藏数量';

ALTER TABLE `shop_goods` ADD COLUMN `evaluate_num` INT(11) NOT NULL DEFAULT 0 COMMENT '评论数量';

ALTER TABLE `shop_goods` ADD COLUMN `refund_num` INT(11) NOT NULL DEFAULT 0 COMMENT '退款件数';

ALTER TABLE `shop_goods` ADD COLUMN `refund_money` DECIMAL(10, 2) NOT NULL DEFAULT 0.00 COMMENT '退款总额';

ALTER TABLE `shop_goods` MODIFY `goods_video` VARCHAR(555) DEFAULT '' COMMENT '商品视频' AFTER `goods_image`;

ALTER TABLE `shop_goods` MODIFY `create_time` INT(11) NOT NULL DEFAULT 0 COMMENT '创建时间' AFTER `refund_money`;

ALTER TABLE `shop_goods` MODIFY `update_time` INT(11) NOT NULL DEFAULT 0 COMMENT '修改时间' AFTER `create_time`;

ALTER TABLE `shop_goods` MODIFY `delete_time` INT(11) NOT NULL DEFAULT 0 COMMENT '删除时间' AFTER `update_time`;

ALTER TABLE `shop_delivery_local_delivery` ADD COLUMN `time_is_open` TINYINT(4) NOT NULL DEFAULT 0 COMMENT '配送时间设置 0 关闭 1 开启';

ALTER TABLE `shop_delivery_local_delivery` ADD COLUMN `time_type` TINYINT(4) NOT NULL DEFAULT 0 COMMENT '时间选取类型 0 每天  1 自定义';

ALTER TABLE `shop_delivery_local_delivery` ADD COLUMN `time_week` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '营业时间  周一 周二.......';

ALTER TABLE `shop_delivery_local_delivery` ADD COLUMN `time_interval` INT(11) NOT NULL DEFAULT 30 COMMENT '时段设置单位分钟';

ALTER TABLE `shop_delivery_local_delivery` ADD COLUMN `advance_day` INT(11) NOT NULL DEFAULT 0 COMMENT '时间选择需提前多少天';

ALTER TABLE `shop_delivery_local_delivery` ADD COLUMN `most_day` INT(11) NOT NULL DEFAULT 7 COMMENT '最多可预约多少天';

ALTER TABLE `shop_delivery_local_delivery` ADD COLUMN `start_time` INT(11) NOT NULL DEFAULT 0 COMMENT '当日的起始时间';

ALTER TABLE `shop_delivery_local_delivery` ADD COLUMN `end_time` INT(11) NOT NULL DEFAULT 0 COMMENT '当日的营业结束时间';

ALTER TABLE `shop_delivery_local_delivery` ADD COLUMN `delivery_time` VARCHAR(2000) NOT NULL DEFAULT '' COMMENT '配送时间段';

ALTER TABLE `shop_active_goods` ADD COLUMN `sku_id` INT(11) DEFAULT 0 COMMENT '商品规格id';

ALTER TABLE `shop_active_goods` MODIFY `sku_id` INT(11) DEFAULT 0 COMMENT '商品规格id' AFTER `goods_id`;
