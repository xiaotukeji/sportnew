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

namespace addon\sport\app\model\sport_score;

use core\base\BaseModel;
use think\model\concern\SoftDelete;
use think\model\relation\HasMany;
use think\model\relation\HasOne;

/**
 * 比赛成绩模型
 * Class SportScore
 * @package addon\sport\app\model\sport_score
 */
class SportScore extends BaseModel
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
    protected $name = 'sport_score';

    

    

    /**
     * 搜索器:比赛成绩
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
     * 搜索器:比赛成绩比赛ID
     * @param $value
     * @param $data
     */
    public function searchMatchIdAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("match_id", $value);
        }
    }
    
    /**
     * 搜索器:比赛成绩运动员ID
     * @param $value
     * @param $data
     */
    public function searchAthleteIdAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("athlete_id", $value);
        }
    }
    
    /**
     * 搜索器:比赛成绩团队ID
     * @param $value
     * @param $data
     */
    public function searchTeamIdAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("team_id", $value);
        }
    }
    
    /**
     * 搜索器:比赛成绩成绩类型
     * @param $value
     * @param $data
     */
    public function searchScoreTypeAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("score_type", $value);
        }
    }
    
    /**
     * 搜索器:比赛成绩成绩值
     * @param $value
     * @param $data
     */
    public function searchScoreValueAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("score_value", $value);
        }
    }
    
    /**
     * 搜索器:比赛成绩单位
     * @param $value
     * @param $data
     */
    public function searchUnitAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("unit", $value);
        }
    }
    
    /**
     * 搜索器:比赛成绩排名
     * @param $value
     * @param $data
     */
    public function searchRankAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("rank", $value);
        }
    }
    
    /**
     * 搜索器:比赛成绩裁判ID
     * @param $value
     * @param $data
     */
    public function searchRefereeIdAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("referee_id", $value);
        }
    }
    
    /**
     * 搜索器:比赛成绩是否有效
     * @param $value
     * @param $data
     */
    public function searchIsValidAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("is_valid", $value);
        }
    }
    
    /**
     * 搜索器:比赛成绩排序
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
     * 搜索器:比赛成绩状态：0禁用 1启用
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
     * 搜索器:比赛成绩备注
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
     * 搜索器:比赛成绩创建时间
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
     * 搜索器:比赛成绩更新时间
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
