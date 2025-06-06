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

namespace addon\sport\app\service\admin\sport_event;

use addon\sport\app\model\sport_event\SportEvent;

use core\base\BaseAdminService;


/**
 * 赛事服务层
 * Class SportEventService
 * @package addon\sport\app\service\admin\sport_event
 */
class SportEventService extends BaseAdminService
{
    public function __construct()
    {
        parent::__construct();
        $this->model = new SportEvent();
    }

    /**
     * 获取赛事列表
     * @param array $where
     * @return array
     */
    public function getPage(array $where = [])
    {
        $field = 'id,series_id,name,event_type,year,season,start_time,end_time,location,organizer_id,organizer_type,sort,status,remark,create_time,update_time';
        $order = '';

        $search_model = $this->model->withSearch(["id","series_id","name","event_type","year","season","start_time","end_time","location","organizer_id","organizer_type","sort","status","remark","create_time","update_time"], $where)->field($field)->order($order);
        $list = $this->pageQuery($search_model);
        return $list;
    }

    /**
     * 获取赛事信息
     * @param int $id
     * @return array
     */
    public function getInfo(int $id)
    {
        $field = 'id,series_id,name,event_type,year,season,start_time,end_time,location,organizer_id,organizer_type,sort,status,remark,create_time,update_time';

        $info = $this->model->field($field)->where([['id', "=", $id]])->findOrEmpty()->toArray();
   $info['status'] = strval($info['status']);
        return $info;
    }

    /**
     * 添加赛事
     * @param array $data
     * @return mixed
     */
    public function add(array $data)
    {
        $res = $this->model->create($data);
        return $res->id;

    }

    /**
     * 赛事编辑
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
     * 删除赛事
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
