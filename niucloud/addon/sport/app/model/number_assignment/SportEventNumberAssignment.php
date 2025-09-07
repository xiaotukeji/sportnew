<?php

namespace addon\sport\app\model\number_assignment;

use core\base\BaseModel;

/**
 * 赛事号码分配模型
 * Class SportEventNumberAssignment
 * @package addon\sport\app\model\number_assignment
 */
class SportEventNumberAssignment extends BaseModel
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
    protected $name = 'sport_event_number_assignment';

    /**
     * 自动写入时间戳
     * @var bool
     */
    protected $autoWriteTimestamp = true;

    /**
     * 时间字段取出后的默认时间格式
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
        'registration_id' => 'integer',
        'athlete_id' => 'integer',
        'item_id' => 'integer',
        'assignment_type' => 'integer',
        'assignment_time' => 'integer',
        'assignment_by' => 'integer',
        'status' => 'integer',
        'create_time' => 'integer',
        'update_time' => 'integer'
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
     * 关联报名记录
     * @return \think\model\relation\BelongsTo
     */
    public function registration()
    {
        return $this->belongsTo('addon\sport\app\model\sport_registration\SportRegistration', 'registration_id', 'id');
    }

    /**
     * 关联参赛人员
     * @return \think\model\relation\BelongsTo
     */
    public function athlete()
    {
        return $this->belongsTo('addon\sport\app\model\sport_athlete\SportAthlete', 'athlete_id', 'id');
    }

    /**
     * 关联比赛项目
     * @return \think\model\relation\BelongsTo
     */
    public function item()
    {
        return $this->belongsTo('addon\sport\app\model\sport_item\SportItem', 'item_id', 'id');
    }

    /**
     * 搜索器：按赛事ID搜索
     * @param $query
     * @param $value
     */
    public function searchEventIdAttr($query, $value)
    {
        $query->where('event_id', $value);
    }

    /**
     * 搜索器：按报名记录ID搜索
     * @param $query
     * @param $value
     */
    public function searchRegistrationIdAttr($query, $value)
    {
        $query->where('registration_id', $value);
    }

    /**
     * 搜索器：按参赛人员ID搜索
     * @param $query
     * @param $value
     */
    public function searchAthleteIdAttr($query, $value)
    {
        $query->where('athlete_id', $value);
    }

    /**
     * 搜索器：按项目ID搜索
     * @param $query
     * @param $value
     */
    public function searchItemIdAttr($query, $value)
    {
        $query->where('item_id', $value);
    }

    /**
     * 搜索器：按号码牌搜索
     * @param $query
     * @param $value
     */
    public function searchNumberPlateAttr($query, $value)
    {
        $query->where('number_plate', $value);
    }

    /**
     * 搜索器：按分配类型搜索
     * @param $query
     * @param $value
     */
    public function searchAssignmentTypeAttr($query, $value)
    {
        $query->where('assignment_type', $value);
    }

    /**
     * 搜索器：按状态搜索
     * @param $query
     * @param $value
     */
    public function searchStatusAttr($query, $value)
    {
        $query->where('status', $value);
    }

    /**
     * 获取分配类型文本
     * @return string
     */
    public function getAssignmentTypeTextAttr()
    {
        $types = [
            1 => '系统分配',
            2 => '用户自选'
        ];
        return $types[$this->assignment_type] ?? '未知';
    }

    /**
     * 获取状态文本
     * @return string
     */
    public function getStatusTextAttr()
    {
        $statuses = [
            0 => '已取消',
            1 => '有效'
        ];
        return $statuses[$this->status] ?? '未知';
    }

    /**
     * 检查号码是否已被分配
     * @param int $eventId 赛事ID
     * @param string $numberPlate 号码牌
     * @return bool
     */
    public static function isNumberAssigned($eventId, $numberPlate)
    {
        return self::where('event_id', $eventId)
            ->where('number_plate', $numberPlate)
            ->where('status', 1)
            ->count() > 0;
    }

    /**
     * 获取赛事已分配的号码列表
     * @param int $eventId 赛事ID
     * @return array
     */
    public static function getAssignedNumbers($eventId)
    {
        return self::where('event_id', $eventId)
            ->where('status', 1)
            ->column('number_plate');
    }

    /**
     * 获取用户已选择的号码
     * @param int $eventId 赛事ID
     * @param int $athleteId 参赛人员ID
     * @return string|null
     */
    public static function getUserSelectedNumber($eventId, $athleteId)
    {
        $assignment = self::where('event_id', $eventId)
            ->where('athlete_id', $athleteId)
            ->where('status', 1)
            ->find();
            
        return $assignment ? $assignment->number_plate : null;
    }
}
