<?php
// 如果不需要软删除功能，可以用这个版本替换原文件
// +----------------------------------------------------------------------
// | Niucloud-admin 企业快速开发的多应用管理平台
// +----------------------------------------------------------------------
// | 官方网址：https://www.niucloud.com
// +----------------------------------------------------------------------
// | niucloud团队 版权所有 开源版本可自由商用
// +----------------------------------------------------------------------
// | Author: Niucloud Team
// +----------------------------------------------------------------------

namespace addon\sport\app\model\event;

use core\base\BaseModel;
// 移除软删除导入
// use think\model\concern\SoftDelete;

/**
 * 赛事模型 - 无软删除版本
 * Class SportEvent
 * @package addon\sport\app\model\event
 */
class SportEvent extends BaseModel
{
    // 移除软删除trait
    // use SoftDelete;

    /**
     * 数据表主键
     * @var string
     */
    protected $pk = 'id';

    /**
     * 模型名称
     * @var string
     */
    protected $name = 'sport_event';

    // 移除软删除相关配置
    // protected $deleteTime = 'delete_time';
    // protected $defaultSoftDelete = 0;

    /**
     * 自动时间戳
     * @var bool
     */
    protected $autoWriteTimestamp = true;

    /**
     * 创建时间字段
     * @var string
     */
    protected $createTime = 'create_time';

    /**
     * 更新时间字段
     * @var string
     */
    protected $updateTime = 'update_time';

    /**
     * 数据类型转换
     * @var array
     */
    protected $type = [
        'id' => 'integer',
        'series_id' => 'integer',
        'event_type' => 'integer',
        'year' => 'integer',
        'start_time' => 'integer',
        'end_time' => 'integer',
        'organizer_id' => 'integer',
        'organizer_type' => 'integer',
        'sort' => 'integer',
        'status' => 'integer',
        'create_time' => 'integer',
        'update_time' => 'integer',
        // 移除delete_time
        // 'delete_time' => 'integer',
    ];

    /**
     * 可批量赋值的字段
     * @var array
     */
    protected $field = [
        'id', 'series_id', 'name', 'event_type', 'year', 'season', 'start_time', 
        'end_time', 'location', 'lng', 'lat', 'full_address', 'organizer_id', 
        'organizer_type', 'sort', 'status', 'remark', 'create_time', 'update_time'
        // 移除delete_time
    ];

    // ... 其他方法保持不变
} 