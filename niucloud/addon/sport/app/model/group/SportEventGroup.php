<?php
// +----------------------------------------------------------------------
// | Niucloud-admin 企业快速开发的多应用管理平台
// +----------------------------------------------------------------------
// | 官方网址：https://www.niucloud.com
// +----------------------------------------------------------------------
// | niucloud团队 版权所有 开源版本可自由商用
// +----------------------------------------------------------------------
// | Author: Niucloud Team
// +----------------------------------------------------------------------

namespace addon\sport\app\model\group;

use core\base\BaseModel;

/**
 * 赛事自定义分组模型
 * Class SportEventGroup
 * @package addon\sport\app\model\group
 */
class SportEventGroup extends BaseModel
{
    /**
     * 数据表主键
     * @var string
     */
    protected $pk = 'id';

    /**
     * 模型名称
     * @var string
     */
    protected $name = 'sport_event_groups';

    /**
     * 自动写入时间戳字段
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
     * 字段类型转换
     * @var array
     */
    protected $type = [
        'id' => 'integer',
        'event_id' => 'integer',
        'sort' => 'integer',
        'status' => 'integer',
        'create_time' => 'integer',
        'update_time' => 'integer',
    ];

    /**
     * 搜索器：赛事ID
     * @param $query
     * @param $value
     * @param $data
     */
    public function searchEventIdAttr($query, $value, $data)
    {
        if ($value !== '') {
            $query->where('event_id', $value);
        }
    }

    /**
     * 搜索器：状态
     * @param $query
     * @param $value
     * @param $data
     */
    public function searchStatusAttr($query, $value, $data)
    {
        if ($value !== '') {
            $query->where('status', $value);
        }
    }

    /**
     * 搜索器：分组类型
     * @param $query
     * @param $value
     * @param $data
     */
    public function searchGroupTypeAttr($query, $value, $data)
    {
        if ($value !== '') {
            $query->where('group_type', $value);
        }
    }

    /**
     * 关联赛事
     * @return \think\model\relation\BelongsTo
     */
    public function event()
    {
        return $this->belongsTo(\addon\sport\app\model\event\SportEvent::class, 'event_id', 'id');
    }
} 