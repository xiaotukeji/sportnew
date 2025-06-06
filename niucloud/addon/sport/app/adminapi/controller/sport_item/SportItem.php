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

namespace addon\sport\app\adminapi\controller\sport_item;

use core\base\BaseAdminController;
use addon\sport\app\service\admin\sport_item\SportItemService;


/**
 * 比赛项目控制器
 * Class SportItem
 * @package addon\sport\app\adminapi\controller\sport_item
 */
class SportItem extends BaseAdminController
{
   /**
    * 获取比赛项目列表
    * @return \think\Response
    */
    public function lists(){
        $data = $this->request->params([
             ["event_id",""],
             ["base_item_id",""],
             ["category_id",""],
             ["name",""],
             ["competition_type",""],
             ["gender_type",""],
             ["age_group",""],
             ["max_participants",""],
             ["min_participants",""],
             ["registration_fee",""],
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
        return success((new SportItemService())->getPage($data));
    }

    /**
     * 比赛项目详情
     * @param int $id
     * @return \think\Response
     */
    public function info(int $id){
        return success((new SportItemService())->getInfo($id));
    }

    /**
     * 添加比赛项目
     * @return \think\Response
     */
    public function add(){
        $data = $this->request->params([
             ["event_id",0],
             ["base_item_id",0],
             ["category_id",0],
             ["name",""],
             ["competition_type",0],
             ["gender_type",0],
             ["age_group",""],
             ["max_participants",0],
             ["min_participants",0],
             ["registration_fee",0.00],
             ["rules",""],
             ["equipment",""],
             ["venue_requirements",""],
             ["referee_requirements",""],
             ["sort",0],
             ["status",0],
             ["remark",""],

        ]);
        $this->validate($data, 'addon\sport\app\validate\sport_item\SportItem.add');
        $id = (new SportItemService())->add($data);
        return success('ADD_SUCCESS', ['id' => $id]);
    }

    /**
     * 比赛项目编辑
     * @param $id  比赛项目id
     * @return \think\Response
     */
    public function edit(int $id){
        $data = $this->request->params([
             ["event_id",0],
             ["base_item_id",0],
             ["category_id",0],
             ["name",""],
             ["competition_type",0],
             ["gender_type",0],
             ["age_group",""],
             ["max_participants",0],
             ["min_participants",0],
             ["registration_fee",0.00],
             ["rules",""],
             ["equipment",""],
             ["venue_requirements",""],
             ["referee_requirements",""],
             ["sort",0],
             ["status",0],
             ["remark",""],

        ]);
        $this->validate($data, 'addon\sport\app\validate\sport_item\SportItem.edit');
        (new SportItemService())->edit($id, $data);
        return success('EDIT_SUCCESS');
    }

    /**
     * 比赛项目删除
     * @param $id  比赛项目id
     * @return \think\Response
     */
    public function del(int $id){
        (new SportItemService())->del($id);
        return success('DELETE_SUCCESS');
    }

    
}
