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

namespace addon\sport\app\model\sport_category;

use core\base\BaseModel;
use think\model\concern\SoftDelete;
use think\model\relation\HasMany;
use think\model\relation\HasOne;

/**
 * 项目大类模型
 * Class SportCategory
 * @package addon\sport\app\model\sport_category
 */
class SportCategory extends BaseModel
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
    protected $name = 'sport_category';

    

    

    /**
     * 搜索器:项目大类
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
     * 搜索器:项目大类大类名称
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
     * 搜索器:项目大类大类编码
     * @param $value
     * @param $data
     */
    public function searchCodeAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("code", $value);
        }
    }
    
    /**
     * 搜索器:项目大类图标
     * @param $value
     * @param $data
     */
    public function searchIconAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("icon", $value);
        }
    }
    
    /**
     * 搜索器:项目大类描述
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
     * 搜索器:项目大类父级ID，0表示顶级
     * @param $value
     * @param $data
     */
    public function searchParentIdAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("parent_id", $value);
        }
    }
    
    /**
     * 搜索器:项目大类层级，1级为顶级
     * @param $value
     * @param $data
     */
    public function searchLevelAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("level", $value);
        }
    }
    
    /**
     * 搜索器:项目大类层级路径，如：1,2,3
     * @param $value
     * @param $data
     */
    public function searchPathAttr($query, $value, $data)
    {
       if ($value) {
            $query->where("path", $value);
        }
    }
    
    /**
     * 搜索器:项目大类排序
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
     * 搜索器:项目大类状态：0禁用 1启用
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
     * 搜索器:项目大类备注
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
     * 搜索器:项目大类创建时间
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
     * 搜索器:项目大类更新时间
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
