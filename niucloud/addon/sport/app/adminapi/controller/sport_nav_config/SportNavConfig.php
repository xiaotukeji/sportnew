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

namespace addon\sport\app\adminapi\controller\sport_nav_config;

use core\base\BaseAdminController;
use addon\sport\app\service\admin\sport_nav_config\SportNavConfigService;


/**
 * 导航配置控制器
 * Class SportNavConfig
 * @package addon\sport\app\adminapi\controller\sport_nav_config
 */
class SportNavConfig extends BaseAdminController
{
   /**
    * 获取导航配置列表
    * @return \think\Response
    */
    public function lists(){
        $data = $this->request->params([
             ["name",""],
             ["icon",""],
             ["selected_icon",""],
             ["path",""],
             ["sort",""],
             ["status",""],
             ["remark",""],
             ["create_time",""],
             ["update_time",""]
        ]);
        return success((new SportNavConfigService())->getPage($data));
    }

    /**
     * 导航配置详情
     * @param int $id
     * @return \think\Response
     */
    public function info(int $id){
        return success((new SportNavConfigService())->getInfo($id));
    }

    /**
     * 添加导航配置
     * @return \think\Response
     */
    public function add(){
        $data = $this->request->params([
             ["name",""],
             ["icon",""],
             ["selected_icon",""],
             ["path",""],
             ["sort",0],
             ["status",0],
             ["remark",""],

        ]);
        $this->validate($data, 'addon\sport\app\validate\sport_nav_config\SportNavConfig.add');
        $id = (new SportNavConfigService())->add($data);
        return success('ADD_SUCCESS', ['id' => $id]);
    }

    /**
     * 导航配置编辑
     * @param $id  导航配置id
     * @return \think\Response
     */
    public function edit(int $id){
        $data = $this->request->params([
             ["name",""],
             ["icon",""],
             ["selected_icon",""],
             ["path",""],
             ["sort",0],
             ["status",0],
             ["remark",""],

        ]);
        $this->validate($data, 'addon\sport\app\validate\sport_nav_config\SportNavConfig.edit');
        (new SportNavConfigService())->edit($id, $data);
        return success('EDIT_SUCCESS');
    }

    /**
     * 导航配置删除
     * @param $id  导航配置id
     * @return \think\Response
     */
    public function del(int $id){
        (new SportNavConfigService())->del($id);
        return success('DELETE_SUCCESS');
    }

    
}
