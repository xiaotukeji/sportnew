<?php
/**
 * 如果不想使用软删除功能，可以修改SportEvent模型
 * 
 * 方案1：添加delete_time字段（推荐）
 * 执行SQL: ALTER TABLE `sport_event` ADD COLUMN `delete_time` int(11) DEFAULT NULL COMMENT '删除时间';
 * 
 * 方案2：移除软删除功能
 * 修改 niucloud/addon/sport/app/model/event/SportEvent.php
 * 
 * 注释或删除以下代码：
 * use think\model\concern\SoftDelete;
 * use SoftDelete;
 * protected $deleteTime = 'delete_time';
 * protected $defaultSoftDelete = 0;
 * 
 * 并从 $type 数组中移除 'delete_time' => 'integer'
 * 从 $field 数组中移除 'delete_time'
 */

echo "请选择解决方案：\n";
echo "1. 执行 add_delete_time_field.sql 添加字段（推荐）\n";
echo "2. 修改模型移除软删除功能\n";
?> 