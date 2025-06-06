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

namespace addon\sport\app\model\sport_item;

use core\base\BaseModel;
use think\model\concern\SoftDelete;
use think\model\relation\HasMany;
use think\model\relation\HasOne;

/**
 * 比赛项目模型
 * Class SportItem
 * @package addon\sport\app\model\sport_item
 */
class SportItem extends BaseModel
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
    protected $name = 'sport_item';

    

    

    /**
     * 搜索器:比赛项目
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
     * 搜索器:比赛项目赛事ID
     * @param $value
     * @param $data
     */
    public function searchEventIdAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("event_id", $value);
        }
    }
    
    /**
     * 搜索器:比赛项目基础项目ID
     * @param $value
     * @param $data
     */
    public function searchBaseItemIdAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("base_item_id", $value);
        }
    }
    
    /**
     * 搜索器:比赛项目项目大类ID
     * @param $value
     * @param $data
     */
    public function searchCategoryIdAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("category_id", $value);
        }
    }
    
    /**
     * 搜索器:比赛项目项目名称
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
     * 搜索器:比赛项目比赛类型：1个人 2团体 3混合
     * @param $value
     * @param $data
     */
    public function searchCompetitionTypeAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("competition_type", $value);
        }
    }
    
    /**
     * 搜索器:比赛项目性别类型：1男子 2女子 3混合
     * @param $value
     * @param $data
     */
    public function searchGenderTypeAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("gender_type", $value);
        }
    }
    
    /**
     * 搜索器:比赛项目年龄组别
     * @param $value
     * @param $data
     */
    public function searchAgeGroupAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("age_group", $value);
        }
    }
    
    /**
     * 搜索器:比赛项目最大参赛人数
     * @param $value
     * @param $data
     */
    public function searchMaxParticipantsAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("max_participants", $value);
        }
    }
    
    /**
     * 搜索器:比赛项目最小参赛人数
     * @param $value
     * @param $data
     */
    public function searchMinParticipantsAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("min_participants", $value);
        }
    }
    
    /**
     * 搜索器:比赛项目报名费用
     * @param $value
     * @param $data
     */
    public function searchRegistrationFeeAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("registration_fee", $value);
        }
    }
    
    /**
     * 搜索器:比赛项目比赛规则
     * @param $value
     * @param $data
     */
    public function searchRulesAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("rules", $value);
        }
    }
    
    /**
     * 搜索器:比赛项目所需器材
     * @param $value
     * @param $data
     */
    public function searchEquipmentAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("equipment", $value);
        }
    }
    
    /**
     * 搜索器:比赛项目场地要求
     * @param $value
     * @param $data
     */
    public function searchVenueRequirementsAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("venue_requirements", $value);
        }
    }
    
    /**
     * 搜索器:比赛项目裁判要求
     * @param $value
     * @param $data
     */
    public function searchRefereeRequirementsAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("referee_requirements", $value);
        }
    }
    
    /**
     * 搜索器:比赛项目排序
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
     * 搜索器:比赛项目状态：0禁用 1启用
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
     * 搜索器:比赛项目备注
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
     * 搜索器:比赛项目创建时间
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
     * 搜索器:比赛项目更新时间
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
