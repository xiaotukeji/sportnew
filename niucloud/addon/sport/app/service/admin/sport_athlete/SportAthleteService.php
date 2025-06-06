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

namespace addon\sport\app\service\admin\sport_athlete;

use addon\sport\app\model\sport_athlete\SportAthlete;

use core\base\BaseAdminService;


/**
 * 参赛人员服务层
 * Class SportAthleteService
 * @package addon\sport\app\service\admin\sport_athlete
 */
class SportAthleteService extends BaseAdminService
{
    public function __construct()
    {
        parent::__construct();
        $this->model = new SportAthlete();
    }

    /**
     * 获取参赛人员列表
     * @param array $where
     * @return array
     */
    public function getPage(array $where = [])
    {
        $field = 'id,member_id,event_id,team_id,name,gender,id_card,phone,birth_date,photo,registration_type,registration_time,sort,status,remark,create_time,update_time';
        $order = '';

        $search_model = $this->model->withSearch(["id","member_id","event_id","team_id","name","gender","id_card","phone","birth_date","photo","registration_type","registration_time","sort","status","remark","create_time","update_time"], $where)->field($field)->order($order);
        $list = $this->pageQuery($search_model);
        return $list;
    }

    /**
     * 获取参赛人员信息
     * @param int $id
     * @return array
     */
    public function getInfo(int $id)
    {
        $field = 'id,member_id,event_id,team_id,name,gender,id_card,phone,birth_date,photo,registration_type,registration_time,sort,status,remark,create_time,update_time';

        $info = $this->model->field($field)->where([['id', "=", $id]])->findOrEmpty()->toArray();
   $info['status'] = strval($info['status']);
        return $info;
    }

    /**
     * 添加参赛人员
     * @param array $data
     * @return mixed
     */
    public function add(array $data)
    {
        $res = $this->model->create($data);
        return $res->id;

    }

    /**
     * 参赛人员编辑
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
     * 删除参赛人员
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
