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

namespace addon\sport\app\service\admin\sport_nav_config;

use addon\sport\app\model\sport_nav_config\SportNavConfig;

use core\base\BaseAdminService;


/**
 * 导航配置服务层
 * Class SportNavConfigService
 * @package addon\sport\app\service\admin\sport_nav_config
 */
class SportNavConfigService extends BaseAdminService
{
    public function __construct()
    {
        parent::__construct();
        $this->model = new SportNavConfig();
    }

    /**
     * 获取导航配置列表
     * @param array $where
     * @return array
     */
    public function getPage(array $where = [])
    {
        $field = 'id,name,icon,selected_icon,path,sort,status,remark,create_time,update_time';
        $order = '';

        $search_model = $this->model->withSearch(["id","name","icon","selected_icon","path","sort","status","remark","create_time","update_time"], $where)->field($field)->order($order);
        $list = $this->pageQuery($search_model);
        return $list;
    }

    /**
     * 获取导航配置信息
     * @param int $id
     * @return array
     */
    public function getInfo(int $id)
    {
        $field = 'id,name,icon,selected_icon,path,sort,status,remark,create_time,update_time';

        $info = $this->model->field($field)->where([['id', "=", $id]])->findOrEmpty()->toArray();
   $info['status'] = strval($info['status']);
        return $info;
    }

    /**
     * 添加导航配置
     * @param array $data
     * @return mixed
     */
    public function add(array $data)
    {
        $res = $this->model->create($data);
        return $res->id;

    }

    /**
     * 导航配置编辑
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
     * 删除导航配置
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
