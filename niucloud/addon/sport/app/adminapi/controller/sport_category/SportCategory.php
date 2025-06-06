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

namespace addon\sport\app\adminapi\controller\sport_category;

use core\base\BaseAdminController;
use addon\sport\app\service\admin\sport_category\SportCategoryService;


/**
 * 项目大类控制器
 * Class SportCategory
 * @package addon\sport\app\adminapi\controller\sport_category
 */
class SportCategory extends BaseAdminController
{
   /**
    * 获取项目大类列表
    * @return \think\Response
    */
    public function lists(){
        $data = $this->request->params([
             ["name",""],
             ["code",""],
             ["icon",""],
             ["description",""],
             ["parent_id",""],
             ["level",""],
             ["path",""],
             ["sort",""],
             ["status",""],
             ["remark",""],
             ["create_time",""],
             ["update_time",""]
        ]);
        return success((new SportCategoryService())->getPage($data));
    }

    /**
     * 项目大类详情
     * @param int $id
     * @return \think\Response
     */
    public function info(int $id){
        return success((new SportCategoryService())->getInfo($id));
    }

    /**
     * 添加项目大类
     * @return \think\Response
     */
    public function add(){
        $data = $this->request->params([
             ["name",""],
             ["code",""],
             ["icon",""],
             ["description",""],
             ["parent_id",0],
             ["level",0],
             ["path",""],
             ["sort",0],
             ["status",0],
             ["remark",""],

        ]);
        $this->validate($data, 'addon\sport\app\validate\sport_category\SportCategory.add');
        $id = (new SportCategoryService())->add($data);
        return success('ADD_SUCCESS', ['id' => $id]);
    }

    /**
     * 项目大类编辑
     * @param $id  项目大类id
     * @return \think\Response
     */
    public function edit(int $id){
        $data = $this->request->params([
             ["name",""],
             ["code",""],
             ["icon",""],
             ["description",""],
             ["parent_id",0],
             ["level",0],
             ["path",""],
             ["sort",0],
             ["status",0],
             ["remark",""],

        ]);
        $this->validate($data, 'addon\sport\app\validate\sport_category\SportCategory.edit');
        (new SportCategoryService())->edit($id, $data);
        return success('EDIT_SUCCESS');
    }

    /**
     * 项目大类删除
     * @param $id  项目大类id
     * @return \think\Response
     */
    public function del(int $id){
        (new SportCategoryService())->del($id);
        return success('DELETE_SUCCESS');
    }

    
}
