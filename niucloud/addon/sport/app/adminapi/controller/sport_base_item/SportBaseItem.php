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

namespace addon\sport\app\adminapi\controller\sport_base_item;

use core\base\BaseAdminController;
use addon\sport\app\service\admin\sport_base_item\SportBaseItemService;


/**
 * 基础项目控制器
 * Class SportBaseItem
 * @package addon\sport\app\adminapi\controller\sport_base_item
 */
class SportBaseItem extends BaseAdminController
{
   /**
    * 获取基础项目列表
    * @return \think\Response
    */
    public function lists(){
        $data = $this->request->params([
             ["category_id",""],
             ["name",""],
             ["code",""],
             ["competition_type",""],
             ["gender_type",""],
             ["age_group",""],
             ["description",""],
             ["rules",""],
             ["equipment",""],
             ["venue_requirements",""],
             ["referee_requirements",""],
             ["sort",""],
             ["status",""],
             ["remark",""],
             ["create_time",""],
             ["update_time",""]
        ]);
        return success((new SportBaseItemService())->getPage($data));
    }

    /**
     * 基础项目详情
     * @param int $id
     * @return \think\Response
     */
    public function info(int $id){
        return success((new SportBaseItemService())->getInfo($id));
    }

    /**
     * 添加基础项目
     * @return \think\Response
     */
    public function add(){
        $data = $this->request->params([
             ["category_id",0],
             ["name",""],
             ["code",""],
             ["competition_type",0],
             ["gender_type",0],
             ["age_group",""],
             ["description",""],
             ["rules",""],
             ["equipment",""],
             ["venue_requirements",""],
             ["referee_requirements",""],
             ["sort",0],
             ["status",0],
             ["remark",""],

        ]);
        $this->validate($data, 'addon\sport\app\validate\sport_base_item\SportBaseItem.add');
        $id = (new SportBaseItemService())->add($data);
        return success('ADD_SUCCESS', ['id' => $id]);
    }

    /**
     * 基础项目编辑
     * @param $id  基础项目id
     * @return \think\Response
     */
    public function edit(int $id){
        $data = $this->request->params([
             ["category_id",0],
             ["name",""],
             ["code",""],
             ["competition_type",0],
             ["gender_type",0],
             ["age_group",""],
             ["description",""],
             ["rules",""],
             ["equipment",""],
             ["venue_requirements",""],
             ["referee_requirements",""],
             ["sort",0],
             ["status",0],
             ["remark",""],

        ]);
        $this->validate($data, 'addon\sport\app\validate\sport_base_item\SportBaseItem.edit');
        (new SportBaseItemService())->edit($id, $data);
        return success('EDIT_SUCCESS');
    }

    /**
     * 基础项目删除
     * @param $id  基础项目id
     * @return \think\Response
     */
    public function del(int $id){
        (new SportBaseItemService())->del($id);
        return success('DELETE_SUCCESS');
    }

    
}
