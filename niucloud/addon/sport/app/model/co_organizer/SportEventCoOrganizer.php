<?php

namespace addon\sport\app\model\co_organizer;

use core\base\BaseModel;

/**
 * 赛事协办单位模型
 * Class SportEventCoOrganizer
 * @package addon\sport\app\model\co_organizer
 */
class SportEventCoOrganizer extends BaseModel
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
    protected $name = 'sport_event_co_organizer';

    /**
     * 自动写入时间戳
     * @var bool
     */
    protected $autoWriteTimestamp = true;

    /**
     * 时间字段格式
     * @var string
     */
    protected $dateFormat = 'Y-m-d H:i:s';

    /**
     * 字段类型转换
     * @var array
     */
    protected $type = [
        'id' => 'integer',
        'event_id' => 'integer',
        'organizer_id' => 'integer',
        'organizer_type' => 'integer',
        'sort' => 'integer',
        'status' => 'integer',
        'create_time' => 'timestamp',
        'update_time' => 'timestamp'
    ];

    /**
     * 关联赛事
     * @return \think\model\relation\BelongsTo
     */
    public function event()
    {
        return $this->belongsTo('addon\sport\app\model\event\SportEvent', 'event_id', 'id');
    }

    /**
     * 获取单位类型标签
     * @param int $type
     * @return string
     */
    public static function getOrganizerTypeLabel($type)
    {
        $typeMap = [
            1 => '协办单位',
            2 => '赞助商',
            3 => '支持单位'
        ];
        return $typeMap[$type] ?? '未知类型';
    }

    /**
     * 搜索器：按赛事ID
     * @param $query
     * @param $value
     */
    public function searchEventIdAttr($query, $value)
    {
        $query->where('event_id', $value);
    }

    /**
     * 搜索器：按单位类型
     * @param $query
     * @param $value
     */
    public function searchOrganizerTypeAttr($query, $value)
    {
        $query->where('organizer_type', $value);
    }

    /**
     * 搜索器：按状态
     * @param $query
     * @param $value
     */
    public function searchStatusAttr($query, $value)
    {
        $query->where('status', $value);
    }

    /**
     * 搜索器：按单位名称
     * @param $query
     * @param $value
     */
    public function searchOrganizerNameAttr($query, $value)
    {
        $query->whereLike('organizer_name', '%' . $value . '%');
    }
}
