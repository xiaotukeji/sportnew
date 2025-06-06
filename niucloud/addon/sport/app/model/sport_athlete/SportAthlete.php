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

namespace addon\sport\app\model\sport_athlete;

use core\base\BaseModel;
use think\model\concern\SoftDelete;
use think\model\relation\HasMany;
use think\model\relation\HasOne;

/**
 * 参赛人员模型
 * Class SportAthlete
 * @package addon\sport\app\model\sport_athlete
 */
class SportAthlete extends BaseModel
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
    protected $name = 'sport_athlete';

    

    

    /**
     * 搜索器:参赛人员
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
     * 搜索器:参赛人员会员ID
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
     * 搜索器:参赛人员赛事ID
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
     * 搜索器:参赛人员参赛单位ID
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
     * 搜索器:参赛人员姓名
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
     * 搜索器:参赛人员性别：1男 2女
     * @param $value
     * @param $data
     */
    public function searchGenderAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("gender", $value);
        }
    }
    
    /**
     * 搜索器:参赛人员身份证号
     * @param $value
     * @param $data
     */
    public function searchIdCardAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("id_card", $value);
        }
    }
    
    /**
     * 搜索器:参赛人员手机号
     * @param $value
     * @param $data
     */
    public function searchPhoneAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("phone", $value);
        }
    }
    
    /**
     * 搜索器:参赛人员出生日期
     * @param $value
     * @param $data
     */
    public function searchBirthDateAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("birth_date", $value);
        }
    }
    
    /**
     * 搜索器:参赛人员照片
     * @param $value
     * @param $data
     */
    public function searchPhotoAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("photo", $value);
        }
    }
    
    /**
     * 搜索器:参赛人员报名类型：1会员报名 2领队导入
     * @param $value
     * @param $data
     */
    public function searchRegistrationTypeAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("registration_type", $value);
        }
    }
    
    /**
     * 搜索器:参赛人员报名时间
     * @param $value
     * @param $data
     */
    public function searchRegistrationTimeAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("registration_time", $value);
        }
    }
    
    /**
     * 搜索器:参赛人员排序
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
     * 搜索器:参赛人员状态：0禁用 1启用
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
     * 搜索器:参赛人员备注
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
     * 搜索器:参赛人员创建时间
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
     * 搜索器:参赛人员更新时间
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
