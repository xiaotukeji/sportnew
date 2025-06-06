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

namespace addon\sport\app\service\admin\sport_base_item;

use addon\sport\app\model\sport_base_item\SportBaseItem;

use core\base\BaseAdminService;


/**
 * 基础项目服务层
 * Class SportBaseItemService
 * @package addon\sport\app\service\admin\sport_base_item
 */
class SportBaseItemService extends BaseAdminService
{
    public function __construct()
    {
        parent::__construct();
        $this->model = new SportBaseItem();
    }

    /**
     * 获取基础项目列表
     * @param array $where
     * @return array
     */
    public function getPage(array $where = [])
    {
        $field = 'id,category_id,name,code,competition_type,gender_type,age_group,description,rules,equipment,venue_requirements,referee_requirements,sort,status,remark,create_time,update_time';
        $order = '';

        $search_model = $this->model->withSearch(["id","category_id","name","code","competition_type","gender_type","age_group","description","rules","equipment","venue_requirements","referee_requirements","sort","status","remark","create_time","update_time"], $where)->field($field)->order($order);
        $list = $this->pageQuery($search_model);
        return $list;
    }

    /**
     * 获取基础项目信息
     * @param int $id
     * @return array
     */
    public function getInfo(int $id)
    {
        $field = 'id,category_id,name,code,competition_type,gender_type,age_group,description,rules,equipment,venue_requirements,referee_requirements,sort,status,remark,create_time,update_time';

        $info = $this->model->field($field)->where([['id', "=", $id]])->findOrEmpty()->toArray();
   $info['status'] = strval($info['status']);
        return $info;
    }

    /**
     * 添加基础项目
     * @param array $data
     * @return mixed
     */
    public function add(array $data)
    {
        $res = $this->model->create($data);
        return $res->id;

    }

    /**
     * 基础项目编辑
     * @param int $id
     * @param array $data
     * @return bool
     */
    public function edit(int $id, array $data)
    {

        $this->model->where([['id', '=', $id]])->update($data);
        return true;
    }

    /**
     * 删除基础项目
     * @param int $id
     * @return bool
     */
    public function del(int $id)
    {
        $model = $this->model->where([['id', '=', $id]])->find();
        $res = $model->delete();
        return $res;
    }

    

}
