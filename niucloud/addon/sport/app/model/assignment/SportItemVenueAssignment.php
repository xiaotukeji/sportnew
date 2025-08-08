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

namespace addon\sport\app\model\assignment;

use core\base\BaseModel;

/**
 * 项目场地分配模型
 * Class SportItemVenueAssignment
 * @package addon\sport\app\model\assignment
 */
class SportItemVenueAssignment extends BaseModel
{
    /**
     * 数据表名
     * @var string
     */
    protected $name = 'sport_item_venue_assignment';

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
        'id', 'item_id', 'venue_id', 'assignment_type', 'start_time', 'end_time', 
        'sort', 'status', 'remark', 'create_time', 'update_time'
    ];

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
     * 搜索器 - 分配类型
     * @param $query
     * @param $value
     */
    public function searchAssignmentTypeAttr($query, $value)
    {
        if (!empty($value)) {
            $query->where('assignment_type', $value);
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
     * 关联项目
     * @return \think\model\relation\BelongsTo
     */
    public function item()
    {
        return $this->belongsTo('addon\sport\app\model\item\SportItem', 'item_id', 'id');
    }

    /**
     * 关联场地
     * @return \think\model\relation\BelongsTo
     */
    public function venue()
    {
        return $this->belongsTo('addon\sport\app\model\venue\SportVenue', 'venue_id', 'id');
    }
} 