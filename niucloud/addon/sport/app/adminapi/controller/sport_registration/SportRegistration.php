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

namespace addon\sport\app\adminapi\controller\sport_registration;

use core\base\BaseAdminController;
use addon\sport\app\service\admin\sport_registration\SportRegistrationService;


/**
 * 报名记录控制器
 * Class SportRegistration
 * @package addon\sport\app\adminapi\controller\sport_registration
 */
class SportRegistration extends BaseAdminController
{
   /**
    * 获取报名记录列表
    * @return \think\Response
    */
    public function lists(){
        $data = $this->request->params([
             ["event_id",""],
             ["item_id",""],
             ["athlete_id",""],
             ["team_id",""],
             ["registration_type",""],
             ["registration_time",""],
             ["status",""],
             ["payment_status",""],
             ["payment_time",""],
             ["sort",""],
             ["remark",""],
             ["create_time",""],
             ["update_time",""]
        ]);
        return success((new SportRegistrationService())->getPage($data));
    }

    /**
     * 报名记录详情
     * @param int $id
     * @return \think\Response
     */
    public function info(int $id){
        return success((new SportRegistrationService())->getInfo($id));
    }

    /**
     * 添加报名记录
     * @return \think\Response
     */
    public function add(){
        $data = $this->request->params([
             ["event_id",0],
             ["item_id",0],
             ["athlete_id",0],
             ["team_id",0],
             ["registration_type",0],
             ["registration_time",0],
             ["status",0],
             ["payment_status",0],
             ["payment_time",0],
             ["sort",0],
             ["remark",""],

        ]);
        $this->validate($data, 'addon\sport\app\validate\sport_registration\SportRegistration.add');
        $id = (new SportRegistrationService())->add($data);
        return success('ADD_SUCCESS', ['id' => $id]);
    }

    /**
     * 报名记录编辑
     * @param $id  报名记录id
     * @return \think\Response
     */
    public function edit(int $id){
        $data = $this->request->params([
             ["event_id",0],
             ["item_id",0],
             ["athlete_id",0],
             ["team_id",0],
             ["registration_type",0],
             ["registration_time",0],
             ["status",0],
             ["payment_status",0],
             ["payment_time",0],
             ["sort",0],
             ["remark",""],

        ]);
        $this->validate($data, 'addon\sport\app\validate\sport_registration\SportRegistration.edit');
        (new SportRegistrationService())->edit($id, $data);
        return success('EDIT_SUCCESS');
    }

    /**
     * 报名记录删除
     * @param $id  报名记录id
     * @return \think\Response
     */
    public function del(int $id){
        (new SportRegistrationService())->del($id);
        return success('DELETE_SUCCESS');
    }

    
}
