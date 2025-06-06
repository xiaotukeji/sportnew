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

namespace addon\sport\app\adminapi\controller\sport_athlete;

use core\base\BaseAdminController;
use addon\sport\app\service\admin\sport_athlete\SportAthleteService;


/**
 * 参赛人员控制器
 * Class SportAthlete
 * @package addon\sport\app\adminapi\controller\sport_athlete
 */
class SportAthlete extends BaseAdminController
{
   /**
    * 获取参赛人员列表
    * @return \think\Response
    */
    public function lists(){
        $data = $this->request->params([
             ["member_id",""],
             ["event_id",""],
             ["team_id",""],
             ["name",""],
             ["gender",""],
             ["id_card",""],
             ["phone",""],
             ["birth_date",""],
             ["photo",""],
             ["registration_type",""],
             ["registration_time",""],
             ["sort",""],
             ["status",""],
             ["remark",""],
             ["create_time",""],
             ["update_time",""]
        ]);
        return success((new SportAthleteService())->getPage($data));
    }

    /**
     * 参赛人员详情
     * @param int $id
     * @return \think\Response
     */
    public function info(int $id){
        return success((new SportAthleteService())->getInfo($id));
    }

    /**
     * 添加参赛人员
     * @return \think\Response
     */
    public function add(){
        $data = $this->request->params([
             ["member_id",0],
             ["event_id",0],
             ["team_id",0],
             ["name",""],
             ["gender",0],
             ["id_card",""],
             ["phone",""],
             ["birth_date","2025-06-06 19:32:16"],
             ["photo",""],
             ["registration_type",0],
             ["registration_time",0],
             ["sort",0],
             ["status",0],
             ["remark",""],

        ]);
        $this->validate($data, 'addon\sport\app\validate\sport_athlete\SportAthlete.add');
        $id = (new SportAthleteService())->add($data);
        return success('ADD_SUCCESS', ['id' => $id]);
    }

    /**
     * 参赛人员编辑
     * @param $id  参赛人员id
     * @return \think\Response
     */
    public function edit(int $id){
        $data = $this->request->params([
             ["member_id",0],
             ["event_id",0],
             ["team_id",0],
             ["name",""],
             ["gender",0],
             ["id_card",""],
             ["phone",""],
             ["birth_date","2025-06-06 19:32:16"],
             ["photo",""],
             ["registration_type",0],
             ["registration_time",0],
             ["sort",0],
             ["status",0],
             ["remark",""],

        ]);
        $this->validate($data, 'addon\sport\app\validate\sport_athlete\SportAthlete.edit');
        (new SportAthleteService())->edit($id, $data);
        return success('EDIT_SUCCESS');
    }

    /**
     * 参赛人员删除
     * @param $id  参赛人员id
     * @return \think\Response
     */
    public function del(int $id){
        (new SportAthleteService())->del($id);
        return success('DELETE_SUCCESS');
    }

    
}
