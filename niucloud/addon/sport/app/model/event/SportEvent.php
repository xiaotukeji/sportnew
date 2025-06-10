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

namespace addon\sport\app\model\event;

use core\base\BaseModel;
use think\model\concern\SoftDelete;

/**
 * 赛事模型
 * Class SportEvent
 * @package addon\sport\app\model\event
 */
class SportEvent extends BaseModel
{
    use SoftDelete;

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

    /**
     * 软删除字段
     * @var string
     */
    protected $deleteTime = 'delete_time';
    protected $defaultSoftDelete = 0;

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
        'member_id' => 'integer',
        'latitude' => 'float',
        'longitude' => 'float',
        'sort' => 'integer',
        'status' => 'integer',
        'create_time' => 'integer',
        'update_time' => 'integer',
        'delete_time' => 'integer',
    ];

    /**
     * 可批量赋值的字段
     * @var array
     */
    protected $field = [
        'id', 'series_id', 'name', 'event_type', 'year', 'season', 'start_time', 
        'end_time', 'location', 'location_detail', 'latitude', 'longitude', 'organizer_id', 
        'organizer_type', 'member_id', 'sort', 'status', 'remark', 'create_time', 'update_time', 'delete_time'
    ];

    /**
     * 获取器 - 格式化开始时间
     * @param $value
     * @return string
     */
    public function getStartTimeTextAttr($value, $data)
    {
        return date('Y-m-d H:i:s', $data['start_time']);
    }

    /**
     * 获取器 - 格式化结束时间
     * @param $value
     * @return string
     */
    public function getEndTimeTextAttr($value, $data)
    {
        return date('Y-m-d H:i:s', $data['end_time']);
    }

    /**
     * 获取器 - 赛事类型文本
     * @param $value
     * @return string
     */
    public function getEventTypeTextAttr($value, $data)
    {
        $types = [
            1 => '独立赛事',
            2 => '系列赛事'
        ];
        return $types[$data['event_type']] ?? '未知';
    }

    /**
     * 获取器 - 举办者类型文本
     * @param $value
     * @return string
     */
    public function getOrganizerTypeTextAttr($value, $data)
    {
        $types = [
            1 => '个人',
            2 => '单位'
        ];
        return $types[$data['organizer_type']] ?? '未知';
    }

    /**
     * 获取器 - 状态文本
     * @param $value
     * @return string
     */
    public function getStatusTextAttr($value, $data)
    {
        $status = [
            0 => '待发布',
            1 => '进行中',
            2 => '已结束',
            3 => '已作废'
        ];
        return $status[$data['status']] ?? '未知';
    }

    /**
     * 关联系列赛
     * @return \think\model\relation\BelongsTo
     */
    public function series()
    {
        return $this->belongsTo(SportEventSeries::class, 'series_id', 'id');
    }

    /**
     * 关联主办方
     * @return \think\model\relation\BelongsTo
     */
    public function organizer()
    {
        return $this->belongsTo(SportOrganizer::class, 'organizer_id', 'id');
    }

    /**
     * 搜索器 - 按赛事名称搜索
     * @param $query
     * @param $value
     * @return void
     */
    public function searchNameAttr($query, $value)
    {
        if ($value) {
            $query->where('name', 'like', '%' . $value . '%');
        }
    }

    /**
     * 搜索器 - 按年份搜索
     * @param $query
     * @param $value
     * @return void
     */
    public function searchYearAttr($query, $value)
    {
        if ($value) {
            $query->where('year', $value);
        }
    }

    /**
     * 搜索器 - 按赛事类型搜索
     * @param $query
     * @param $value
     * @return void
     */
    public function searchEventTypeAttr($query, $value)
    {
        if ($value !== '') {
            $query->where('event_type', $value);
        }
    }

    /**
     * 搜索器 - 按举办者类型搜索
     * @param $query
     * @param $value
     * @return void
     */
    public function searchOrganizerTypeAttr($query, $value)
    {
        if ($value !== '') {
            $query->where('organizer_type', $value);
        }
    }

    /**
     * 搜索器 - 按状态搜索
     * @param $query
     * @param $value
     * @return void
     */
    public function searchStatusAttr($query, $value)
    {
        if ($value !== '') {
            $query->where('status', $value);
        }
    }

    /**
     * 搜索器 - 按会员ID搜索
     * @param $query
     * @param $value
     * @return void
     */
    public function searchMemberIdAttr($query, $value)
    {
        if ($value) {
            // 通过主办方表关联查询
            $query->alias('e')
                  ->join('sport_organizer so', 'e.organizer_id = so.id')
                  ->where('so.member_id', $value);
        }
    }
} 