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
        'event_id' => 'integer',
        'organizer_id' => 'integer',
        'organizer_type' => 'integer',
        'sort' => 'integer',
        'status' => 'integer',
        'create_time' => 'integer',
        'update_time' => 'integer',
    ];

    /**
     * 获取器 - 协办单位类型文本
     * @param $value
     * @return string
     */
    public function getOrganizerTypeTextAttr($value, $data)
    {
        $types = [
            1 => '协办单位',
            2 => '赞助商',
            3 => '支持单位',
            11 => '赞助商',  // 兼容旧数据
            12 => '赞助商',  // 兼容旧数据
            13 => '赞助商',  // 兼容旧数据
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
            0 => '禁用',
            1 => '启用'
        ];
        return $status[$data['status']] ?? '未知';
    }

    /**
     * 搜索器 - 按赛事ID搜索
     * @param $query
     * @param $value
     * @return void
     */
    public function searchEventIdAttr($query, $value)
    {
        if ($value) {
            $query->where('event_id', $value);
        }
    }

    /**
     * 搜索器 - 按协办单位名称搜索
     * @param $query
     * @param $value
     * @return void
     */
    public function searchOrganizerNameAttr($query, $value)
    {
        if ($value) {
            $query->where('organizer_name', 'like', '%' . $value . '%');
        }
    }

    /**
     * 搜索器 - 按协办单位类型搜索
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
     * 关联赛事模型
     * @return \think\model\relation\BelongsTo
     */
    public function event()
    {
        return $this->belongsTo('addon\sport\app\model\event\SportEvent', 'event_id', 'id');
    }
}
