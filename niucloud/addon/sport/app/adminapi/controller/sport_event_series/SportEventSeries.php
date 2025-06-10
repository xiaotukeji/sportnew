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

namespace addon\sport\app\adminapi\controller\sport_event_series;

use core\base\BaseAdminController;
use addon\sport\app\service\admin\sport_event_series\SportEventSeriesService;


/**
 * 赛事系列控制器
 * Class SportEventSeries
 * @package addon\sport\app\adminapi\controller\sport_event_series
 */
class SportEventSeries extends BaseAdminController
{
   /**
    * 获取赛事系列列表
    * @return \think\Response
    */
    public function lists(){
        $data = $this->request->params([
             ["name",""],
             ["organizer_id",""],
             ["member_id",""],
             ["description",""],
             ["start_year",""],
             ["end_year",""],
             ["sort",""],
             ["status",""],
             ["remark",""],
             ["create_time",""],
             ["update_time",""]
        ]);
        return success((new SportEventSeriesService())->getPage($data));
    }

    /**
     * 赛事系列详情
     * @param int $id
     * @return \think\Response
     */
    public function info(int $id){
        return success((new SportEventSeriesService())->getInfo($id));
    }

    /**
     * 添加赛事系列
     * @return \think\Response
     */
    public function add(){
        $data = $this->request->params([
             ["name",""],
             ["organizer_id",0],
             ["member_id",0],
             ["description",""],
             ["start_year",0],
             ["end_year",0],
             ["sort",0],
             ["status",0],
             ["remark",""],

        ]);
        $this->validate($data, 'addon\sport\app\validate\sport_event_series\SportEventSeries.admin_add');
        $id = (new SportEventSeriesService())->add($data);
        return success('ADD_SUCCESS', ['id' => $id]);
    }

    /**
     * 赛事系列编辑
     * @param $id  赛事系列id
     * @return \think\Response
     */
    public function edit(int $id){
        $data = $this->request->params([
             ["name",""],
             ["organizer_id",0],
             ["member_id",0],
             ["description",""],
             ["start_year",0],
             ["end_year",0],
             ["sort",0],
             ["status",0],
             ["remark",""],

        ]);
        $this->validate($data, 'addon\sport\app\validate\sport_event_series\SportEventSeries.admin_edit');
        (new SportEventSeriesService())->edit($id, $data);
        return success('EDIT_SUCCESS');
    }

    /**
     * 赛事系列删除
     * @param $id  赛事系列id
     * @return \think\Response
     */
    public function del(int $id){
        (new SportEventSeriesService())->del($id);
        return success('DELETE_SUCCESS');
    }

    
}
