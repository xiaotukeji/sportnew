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

namespace addon\sport\app\service\admin\sport_registration;

use addon\sport\app\model\sport_registration\SportRegistration;

use core\base\BaseAdminService;


/**
 * 报名记录服务层
 * Class SportRegistrationService
 * @package addon\sport\app\service\admin\sport_registration
 */
class SportRegistrationService extends BaseAdminService
{
    public function __construct()
    {
        parent::__construct();
        $this->model = new SportRegistration();
    }

    /**
     * 获取报名记录列表
     * @param array $where
     * @return array
     */
    public function getPage(array $where = [])
    {
        $field = 'id,event_id,item_id,athlete_id,team_id,registration_type,registration_time,status,payment_status,payment_time,sort,remark,create_time,update_time';
        $order = '';

        $search_model = $this->model->withSearch(["id","event_id","item_id","athlete_id","team_id","registration_type","registration_time","status","payment_status","payment_time","sort","remark","create_time","update_time"], $where)->field($field)->order($order);
        $list = $this->pageQuery($search_model);
        return $list;
    }

    /**
     * 获取报名记录信息
     * @param int $id
     * @return array
     */
    public function getInfo(int $id)
    {
        $field = 'id,event_id,item_id,athlete_id,team_id,registration_type,registration_time,status,payment_status,payment_time,sort,remark,create_time,update_time';

        $info = $this->model->field($field)->where([['id', "=", $id]])->findOrEmpty()->toArray();
   $info['status'] = strval($info['status']);
        return $info;
    }

    /**
     * 添加报名记录
     * @param array $data
     * @return mixed
     */
    public function add(array $data)
    {
        $res = $this->model->create($data);
        return $res->id;

    }

    /**
     * 报名记录编辑
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
     * 删除报名记录
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
