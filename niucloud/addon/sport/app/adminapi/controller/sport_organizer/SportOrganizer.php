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

namespace addon\sport\app\adminapi\controller\sport_organizer;

use core\base\BaseAdminController;
use addon\sport\app\service\admin\sport_organizer\SportOrganizerService;


/**
 * 主办方控制器
 * Class SportOrganizer
 * @package addon\sport\app\adminapi\controller\sport_organizer
 */
class SportOrganizer extends BaseAdminController
{
   /**
    * 获取主办方列表
    * @return \think\Response
    */
    public function lists(){
        $data = $this->request->params([
             ["organizer_id",""],
             ["member_id",""],
             ["organizer_type",""],
             ["organizer_name",""],
             ["organizer_license",""],
             ["contact_name",""],
             ["contact_phone",""],
             ["sort",""],
             ["status",""],
             ["remark",""],
             ["create_time",""],
             ["update_time",""]
        ]);
        return success((new SportOrganizerService())->getPage($data));
    }

    /**
     * 主办方详情
     * @param int $id
     * @return \think\Response
     */
    public function info(int $id){
        return success((new SportOrganizerService())->getInfo($id));
    }

    /**
     * 添加主办方
     * @return \think\Response
     */
    public function add(){
        $data = $this->request->params([
             ["organizer_id",0],
             ["member_id",0],
             ["organizer_type",0],
             ["organizer_name",""],
             ["organizer_license",""],
             ["contact_name",""],
             ["contact_phone",""],
             ["sort",0],
             ["status",0],
             ["remark",""],

        ]);
        $this->validate($data, 'addon\sport\app\validate\sport_organizer\SportOrganizer.admin_add');
        $id = (new SportOrganizerService())->add($data);
        return success('ADD_SUCCESS', ['id' => $id]);
    }

    /**
     * 主办方编辑
     * @param $id  主办方id
     * @return \think\Response
     */
    public function edit(int $id){
        $data = $this->request->params([
             ["organizer_id",0],
             ["member_id",0],
             ["organizer_type",0],
             ["organizer_name",""],
             ["organizer_license",""],
             ["contact_name",""],
             ["contact_phone",""],
             ["sort",0],
             ["status",0],
             ["remark",""],

        ]);
        $this->validate($data, 'addon\sport\app\validate\sport_organizer\SportOrganizer.admin_edit');
        (new SportOrganizerService())->edit($id, $data);
        return success('EDIT_SUCCESS');
    }

    /**
     * 主办方删除
     * @param $id  主办方id
     * @return \think\Response
     */
    public function del(int $id){
        (new SportOrganizerService())->del($id);
        return success('DELETE_SUCCESS');
    }

    
}
