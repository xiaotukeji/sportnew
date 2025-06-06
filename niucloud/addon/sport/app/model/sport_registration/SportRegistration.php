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

namespace addon\sport\app\model\sport_registration;

use core\base\BaseModel;
use think\model\concern\SoftDelete;
use think\model\relation\HasMany;
use think\model\relation\HasOne;

/**
 * 报名记录模型
 * Class SportRegistration
 * @package addon\sport\app\model\sport_registration
 */
class SportRegistration extends BaseModel
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
    protected $name = 'sport_registration';

    

    

    /**
     * 搜索器:报名记录
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
     * 搜索器:报名记录赛事ID
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
     * 搜索器:报名记录项目ID
     * @param $value
     * @param $data
     */
    public function searchItemIdAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("item_id", $value);
        }
    }
    
    /**
     * 搜索器:报名记录参赛人员ID
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
     * 搜索器:报名记录参赛单位ID
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
     * 搜索器:报名记录报名类型：1会员报名 2领队导入
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
     * 搜索器:报名记录报名时间
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
     * 搜索器:报名记录状态：0待审核 1已通过 2已拒绝
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
     * 搜索器:报名记录支付状态：0未支付 1已支付
     * @param $value
     * @param $data
     */
    public function searchPaymentStatusAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("payment_status", $value);
        }
    }
    
    /**
     * 搜索器:报名记录支付时间
     * @param $value
     * @param $data
     */
    public function searchPaymentTimeAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("payment_time", $value);
        }
    }
    
    /**
     * 搜索器:报名记录排序
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
     * 搜索器:报名记录备注
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
     * 搜索器:报名记录创建时间
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
     * 搜索器:报名记录更新时间
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
