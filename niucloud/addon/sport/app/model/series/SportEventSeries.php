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

namespace addon\sport\app\model\series;

use core\base\BaseModel;

/**
 * 系列赛模型
 * Class SportEventSeries
 * @package addon\sport\app\model\series
 */
class SportEventSeries extends BaseModel
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
    protected $name = 'sport_event_series';

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
        'organizer_id' => 'integer',
        'member_id' => 'integer',
        'start_year' => 'integer',
        'end_year' => 'integer',
        'sort' => 'integer',
        'status' => 'integer',
        'create_time' => 'integer',
        'update_time' => 'integer',
    ];

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
     * 获取器 - 年份区间文本
     * @param $value
     * @return string
     */
    public function getYearRangeTextAttr($value, $data)
    {
        $startYear = $data['start_year'];
        $endYear = $data['end_year'] ?: '至今';
        return $startYear . ' - ' . $endYear;
    }

    /**
     * 搜索器 - 按系列赛名称搜索
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
     * 搜索器 - 按会员ID搜索
     * @param $query
     * @param $value
     * @return void
     */
    public function searchMemberIdAttr($query, $value)
    {
        if ($value) {
            $query->where('member_id', $value);
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
     * 搜索器 - 按年份搜索
     * @param $query
     * @param $value
     * @return void
     */
    public function searchYearAttr($query, $value)
    {
        if ($value) {
            $query->where('start_year', '<=', $value)
                  ->where(function($query) use ($value) {
                      $query->whereNull('end_year')
                            ->whereOr('end_year', '>=', $value);
                  });
        }
    }
} 