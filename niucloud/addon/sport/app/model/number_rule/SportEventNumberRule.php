<?php

namespace addon\sport\app\model\number_rule;

use core\base\BaseModel;

/**
 * 赛事号码牌规则模型
 * Class SportEventNumberRule
 * @package addon\sport\app\model\number_rule
 */
class SportEventNumberRule extends BaseModel
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
    protected $name = 'sport_event_number_rule';

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
        'numbering_mode' => 'integer',
        'number_length' => 'integer',
        'start_number' => 'integer',
        'end_number' => 'integer',
        'step' => 'integer',
        'allow_athlete_choice' => 'integer',
        'choice_time_window' => 'integer',
        'auto_assign_after_registration' => 'integer',
        'disable_number_4' => 'integer',
        'status' => 'integer',
        'create_time' => 'integer',
        'update_time' => 'integer'
    ];

    /**
     * 获取器：处理保留号码列表
     * @param $value
     * @return array
     */
    public function getReservedNumbersAttr($value)
    {
        if (empty($value)) {
            return [];
        }
        return json_decode($value, true) ?: [];
    }

    /**
     * 修改器：处理保留号码列表
     * @param $value
     * @return string
     */
    public function setReservedNumbersAttr($value)
    {
        if (is_array($value)) {
            return json_encode($value, JSON_UNESCAPED_UNICODE);
        }
        return $value;
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
     * 搜索器：按赛事ID搜索
     * @param $query
     * @param $value
     */
    public function searchEventIdAttr($query, $value)
    {
        $query->where('event_id', $value);
    }

    /**
     * 搜索器：按编号模式搜索
     * @param $query
     * @param $value
     */
    public function searchNumberingModeAttr($query, $value)
    {
        $query->where('numbering_mode', $value);
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
     * 获取编号模式文本
     * @return string
     */
    public function getNumberingModeTextAttr()
    {
        $modes = [
            1 => '系统分配',
            2 => '用户自选'
        ];
        return $modes[$this->numbering_mode] ?? '未知';
    }

    /**
     * 获取自选规则文本
     * @return string
     */
    public function getChoiceRulesTextAttr()
    {
        $rules = [
            'first_come_first_served' => '先到先得',
            'random' => '随机分配',
            'by_registration_order' => '按报名顺序'
        ];
        return $rules[$this->choice_rules] ?? '未知';
    }

    /**
     * 验证号码是否可用
     * @param string $number 号码
     * @return bool
     */
    public function isNumberAvailable($number)
    {
        // 检查是否禁用包含4的号码
        if ($this->disable_number_4 && strpos($number, '4') !== false) {
            return false;
        }

        // 检查是否在保留列表中
        if (in_array($number, $this->reserved_numbers)) {
            return false;
        }

        return true;
    }

    /**
     * 生成下一个可用号码
     * @return string|null
     */
    public function generateNextNumber()
    {
        $current = $this->start_number;
        
        while ($current <= $this->end_number) {
            $number = $this->prefix . str_pad($current, $this->number_length, '0', STR_PAD_LEFT);
            
            if ($this->isNumberAvailable($number)) {
                return $number;
            }
            
            $current += $this->step;
        }
        
        return null; // 没有可用号码
    }
}
