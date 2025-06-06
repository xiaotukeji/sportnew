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

namespace addon\sport\app\model\sport_event_series;

use core\base\BaseModel;
use think\model\concern\SoftDelete;
use think\model\relation\HasMany;
use think\model\relation\HasOne;

/**
 * 赛事系列模型
 * Class SportEventSeries
 * @package addon\sport\app\model\sport_event_series
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
     * 搜索器:赛事系列
     * @param $value
     * @param $data
     */
    public function searchIdAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("id", $value);
        }
    }
    
    /**
     * 搜索器:赛事系列系列赛名称
     * @param $value
     * @param $data
     */
    public function searchNameAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("name", $value);
        }
    }
    
    /**
     * 搜索器:赛事系列主办方ID
     * @param $value
     * @param $data
     */
    public function searchOrganizerIdAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("organizer_id", $value);
        }
    }
    
    /**
     * 搜索器:赛事系列发布者ID
     * @param $value
     * @param $data
     */
    public function searchMemberIdAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("member_id", $value);
        }
    }
    
    /**
     * 搜索器:赛事系列系列赛描述
     * @param $value
     * @param $data
     */
    public function searchDescriptionAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("description", $value);
        }
    }
    
    /**
     * 搜索器:赛事系列开始年份
     * @param $value
     * @param $data
     */
    public function searchStartYearAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("start_year", $value);
        }
    }
    
    /**
     * 搜索器:赛事系列结束年份
     * @param $value
     * @param $data
     */
    public function searchEndYearAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("end_year", $value);
        }
    }
    
    /**
     * 搜索器:赛事系列排序
     * @param $value
     * @param $data
     */
    public function searchSortAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("sort", $value);
        }
    }
    
    /**
     * 搜索器:赛事系列状态：0禁用 1启用
     * @param $value
     * @param $data
     */
    public function searchStatusAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("status", $value);
        }
    }
    
    /**
     * 搜索器:赛事系列备注
     * @param $value
     * @param $data
     */
    public function searchRemarkAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("remark", $value);
        }
    }
    
    /**
     * 搜索器:赛事系列创建时间
     * @param $value
     * @param $data
     */
    public function searchCreateTimeAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("create_time", $value);
        }
    }
    
    /**
     * 搜索器:赛事系列更新时间
     * @param $value
     * @param $data
     */
    public function searchUpdateTimeAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("update_time", $value);
        }
    }
    
    

    

    
}
