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

namespace addon\sport\app\model\sport_organizer;

use core\base\BaseModel;
use think\model\concern\SoftDelete;
use think\model\relation\HasMany;
use think\model\relation\HasOne;

/**
 * 主办方模型
 * Class SportOrganizer
 * @package addon\sport\app\model\sport_organizer
 */
class SportOrganizer extends BaseModel
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
    protected $name = 'sport_organizer';

    

    

    /**
     * 搜索器:主办方
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
     * 搜索器:主办方主办方ID
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
     * 搜索器:主办方发布者ID
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
     * 搜索器:主办方主办方类型：1个人 2单位
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
     * 搜索器:主办方主办方名称
     * @param $value
     * @param $data
     */
    public function searchOrganizerNameAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("organizer_name", $value);
        }
    }
    
    /**
     * 搜索器:主办方单位证件
     * @param $value
     * @param $data
     */
    public function searchOrganizerLicenseAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("organizer_license", $value);
        }
    }
    
    /**
     * 搜索器:主办方联系人
     * @param $value
     * @param $data
     */
    public function searchContactNameAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("contact_name", $value);
        }
    }
    
    /**
     * 搜索器:主办方联系电话
     * @param $value
     * @param $data
     */
    public function searchContactPhoneAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("contact_phone", $value);
        }
    }
    
    /**
     * 搜索器:主办方排序
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
     * 搜索器:主办方状态：0禁用 1启用
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
     * 搜索器:主办方备注
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
     * 搜索器:主办方创建时间
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
     * 搜索器:主办方更新时间
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
