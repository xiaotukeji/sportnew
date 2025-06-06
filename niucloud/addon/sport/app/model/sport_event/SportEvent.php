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

namespace addon\sport\app\model\sport_event;

use core\base\BaseModel;
use think\model\concern\SoftDelete;
use think\model\relation\HasMany;
use think\model\relation\HasOne;

/**
 * 赛事模型
 * Class SportEvent
 * @package addon\sport\app\model\sport_event
 */
class SportEvent extends BaseModel
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
    protected $name = 'sport_event';

    

    

    /**
     * 搜索器:赛事
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
     * 搜索器:赛事系列赛ID，可为空表示独立赛事
     * @param $value
     * @param $data
     */
    public function searchSeriesIdAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("series_id", $value);
        }
    }
    
    /**
     * 搜索器:赛事赛事名称
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
     * 搜索器:赛事赛事类型：1独立赛事 2系列赛事
     * @param $value
     * @param $data
     */
    public function searchEventTypeAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("event_type", $value);
        }
    }
    
    /**
     * 搜索器:赛事举办年份
     * @param $value
     * @param $data
     */
    public function searchYearAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("year", $value);
        }
    }
    
    /**
     * 搜索器:赛事赛季
     * @param $value
     * @param $data
     */
    public function searchSeasonAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("season", $value);
        }
    }
    
    /**
     * 搜索器:赛事开始时间
     * @param $value
     * @param $data
     */
    public function searchStartTimeAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("start_time", $value);
        }
    }
    
    /**
     * 搜索器:赛事结束时间
     * @param $value
     * @param $data
     */
    public function searchEndTimeAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("end_time", $value);
        }
    }
    
    /**
     * 搜索器:赛事举办地点
     * @param $value
     * @param $data
     */
    public function searchLocationAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("location", $value);
        }
    }
    
    /**
     * 搜索器:赛事主办方ID
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
     * 搜索器:赛事举办者类型：1个人 2单位
     * @param $value
     * @param $data
     */
    public function searchOrganizerTypeAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("organizer_type", $value);
        }
    }
    
    /**
     * 搜索器:赛事排序
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
     * 搜索器:赛事状态：0禁用 1启用
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
     * 搜索器:赛事备注
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
     * 搜索器:赛事创建时间
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
     * 搜索器:赛事更新时间
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
