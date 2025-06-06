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

namespace addon\sport\app\adminapi\controller\sport_event;

use core\base\BaseAdminController;
use addon\sport\app\service\admin\sport_event\SportEventService;


/**
 * 赛事控制器
 * Class SportEvent
 * @package addon\sport\app\adminapi\controller\sport_event
 */
class SportEvent extends BaseAdminController
{
   /**
    * 获取赛事列表
    * @return \think\Response
    */
    public function lists(){
        $data = $this->request->params([
             ["series_id",""],
             ["name",""],
             ["event_type",""],
             ["year",""],
             ["season",""],
             ["start_time",""],
             ["end_time",""],
             ["location",""],
             ["organizer_id",""],
             ["organizer_type",""],
             ["sort",""],
             ["status",""],
             ["remark",""],
             ["create_time",""],
             ["update_time",""]
        ]);
        return success((new SportEventService())->getPage($data));
    }

    /**
     * 赛事详情
     * @param int $id
     * @return \think\Response
     */
    public function info(int $id){
        return success((new SportEventService())->getInfo($id));
    }

    /**
     * 添加赛事
     * @return \think\Response
     */
    public function add(){
        $data = $this->request->params([
             ["series_id",0],
             ["name",""],
             ["event_type",0],
             ["year",0],
             ["season",""],
             ["start_time",0],
             ["end_time",0],
             ["location",""],
             ["organizer_id",0],
             ["organizer_type",0],
             ["sort",0],
             ["status",0],
             ["remark",""],

        ]);
        $this->validate($data, 'addon\sport\app\validate\sport_event\SportEvent.add');
        $id = (new SportEventService())->add($data);
        return success('ADD_SUCCESS', ['id' => $id]);
    }

    /**
     * 赛事编辑
     * @param $id  赛事id
     * @return \think\Response
     */
    public function edit(int $id){
        $data = $this->request->params([
             ["series_id",0],
             ["name",""],
             ["event_type",0],
             ["year",0],
             ["season",""],
             ["start_time",0],
             ["end_time",0],
             ["location",""],
             ["organizer_id",0],
             ["organizer_type",0],
             ["sort",0],
             ["status",0],
             ["remark",""],

        ]);
        $this->validate($data, 'addon\sport\app\validate\sport_event\SportEvent.edit');
        (new SportEventService())->edit($id, $data);
        return success('EDIT_SUCCESS');
    }

    /**
     * 赛事删除
     * @param $id  赛事id
     * @return \think\Response
     */
    public function del(int $id){
        (new SportEventService())->del($id);
        return success('DELETE_SUCCESS');
    }

    
}
