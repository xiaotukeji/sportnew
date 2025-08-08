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

namespace addon\sport\app\model\schedule;

use core\base\BaseModel;

/**
 * 场地使用时间模型
 * Class SportVenueSchedule
 * @package addon\sport\app\model\schedule
 */
class SportVenueSchedule extends BaseModel
{
    /**
     * 数据表名
     * @var string
     */
    protected $name = 'sport_venue_schedule';

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
        'id', 'venue_id', 'item_id', 'match_id', 'start_time', 'end_time', 
        'usage_type', 'status', 'remark', 'create_time', 'update_time'
    ];

    /**
     * 搜索器 - 场地ID
     * @param $query
     * @param $value
     */
    public function searchVenueIdAttr($query, $value)
    {
        if (!empty($value)) {
            $query->where('venue_id', $value);
        }
    }

    /**
     * 搜索器 - 项目ID
     * @param $query
     * @param $value
     */
    public function searchItemIdAttr($query, $value)
    {
        if (!empty($value)) {
            $query->where('item_id', $value);
        }
    }

    /**
     * 搜索器 - 比赛ID
     * @param $query
     * @param $value
     */
    public function searchMatchIdAttr($query, $value)
    {
        if (!empty($value)) {
            $query->where('match_id', $value);
        }
    }

    /**
     * 搜索器 - 使用类型
     * @param $query
     * @param $value
     */
    public function searchUsageTypeAttr($query, $value)
    {
        if (!empty($value)) {
            $query->where('usage_type', $value);
        }
    }

    /**
     * 搜索器 - 状态
     * @param $query
     * @param $value
     */
    public function searchStatusAttr($query, $value)
    {
        if ($value !== '' && $value !== null) {
            $query->where('status', $value);
        }
    }

    /**
     * 搜索器 - 时间范围
     * @param $query
     * @param $value
     */
    public function searchTimeRangeAttr($query, $value)
    {
        if (!empty($value['start_time'])) {
            $query->where('start_time', '>=', $value['start_time']);
        }
        if (!empty($value['end_time'])) {
            $query->where('end_time', '<=', $value['end_time']);
        }
    }

    /**
     * 关联场地
     * @return \think\model\relation\BelongsTo
     */
    public function venue()
    {
        return $this->belongsTo('addon\sport\app\model\venue\SportVenue', 'venue_id', 'id');
    }

    /**
     * 关联项目
     * @return \think\model\relation\BelongsTo
     */
    public function item()
    {
        return $this->belongsTo('addon\sport\app\model\item\SportItem', 'item_id', 'id');
    }

    /**
     * 关联比赛
     * @return \think\model\relation\BelongsTo
     */
    public function match()
    {
        return $this->belongsTo('addon\sport\app\model\match\SportMatch', 'match_id', 'id');
    }
} 