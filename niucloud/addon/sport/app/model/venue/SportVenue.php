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

namespace addon\sport\app\model\venue;

use core\base\BaseModel;

/**
 * 场地模型
 * Class SportVenue
 * @package addon\sport\app\model\venue
 */
class SportVenue extends BaseModel
{
    /**
     * 数据表名
     * @var string
     */
    protected $name = 'sport_venue';

    /**
     * 主键
     * @var string
     */
    protected $pk = 'id';

    /**
     * 允许修改的字段
     * @var array
     */
    protected $field = [
        'id', 'event_id', 'name', 'venue_code', 'venue_category', 'venue_type', 'type', 'capacity', 
        'location', 'is_available', 'sort', 'status', 'remark', 'create_time', 'update_time'
    ];

    /**
     * 搜索器 - 赛事ID
     * @param $query
     * @param $value
     */
    public function searchEventIdAttr($query, $value)
    {
        if (!empty($value)) {
            $query->where('event_id', $value);
        }
    }

    /**
     * 搜索器 - 场地类型
     * @param $query
     * @param $value
     */
    public function searchVenueTypeAttr($query, $value)
    {
        if (!empty($value)) {
            $query->where('venue_type', $value);
        }
    }

    /**
     * 搜索器 - 可用状态
     * @param $query
     * @param $value
     */
    public function searchIsAvailableAttr($query, $value)
    {
        if ($value !== '' && $value !== null) {
            $query->where('is_available', $value);
        }
    }

    /**
     * 搜索器 - 场地名称
     * @param $query
     * @param $value
     */
    public function searchNameAttr($query, $value)
    {
        if (!empty($value)) {
            $query->where('name', 'like', '%' . $value . '%');
        }
    }

    /**
     * 搜索器 - 场地编码
     * @param $query
     * @param $value
     */
    public function searchVenueCodeAttr($query, $value)
    {
        if (!empty($value)) {
            $query->where('venue_code', 'like', '%' . $value . '%');
        }
    }

    /**
     * 关联赛事
     * @return \think\model\relation\BelongsTo
     */
    public function event()
    {
        return $this->belongsTo('addon\sport\app\model\event\SportEvent', 'event_id', 'id');
    }

    /**
     * 关联项目场地分配
     * @return \think\model\relation\HasMany
     */
    public function itemAssignments()
    {
        return $this->hasMany('addon\sport\app\model\assignment\SportItemVenueAssignment', 'venue_id', 'id');
    }

    /**
     * 关联场地使用时间
     * @return \think\model\relation\HasMany
     */
    public function schedules()
    {
        return $this->hasMany('addon\sport\app\model\schedule\SportVenueSchedule', 'venue_id', 'id');
    }
} 