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

namespace addon\sport\app\api\controller\organizer;

use addon\sport\app\service\api\organizer\OrganizerService;
use core\base\BaseApiController;

/**
 * 主办方控制器
 * Class Organizer
 * @package addon\sport\app\api\controller\organizer
 */
class Organizer extends BaseApiController
{
    /**
     * 获取用户主办方列表
     * @return \think\Response
     */
    public function list()
    {
        $data = $this->request->params([
            ['organizer_type', ''],    // 举办者类型
            ['organizer_name', ''],    // 主办方名称
        ]);
        return success((new OrganizerService())->getList($data));
    }

    /**
     * 添加主办方
     * @return \think\Response
     */
    public function add()
    {
        $data = $this->request->params([
            ['organizer_name', ''],     // 主办方名称
            ['organizer_type', 1],      // 举办者类型：1个人 2单位
            ['organizer_license', ''],  // 单位证件
            ['contact_name', ''],       // 联系人
            ['contact_phone', ''],      // 联系电话
            ['remark', ''],             // 备注
        ]);

        // 验证必填字段
        $this->validate($data, 'addon\sport\app\validate\organizer\Organizer.add');
        
        $id = (new OrganizerService())->add($data);
        return success('ADD_SUCCESS', ['id' => $id]);
    }

    /**
     * 获取主办方详情
     * @param int $id
     * @return \think\Response
     */
    public function info(int $id)
    {
        return success((new OrganizerService())->getInfo($id));
    }

    /**
     * 编辑主办方
     * @param int $id
     * @return \think\Response
     */
    public function edit(int $id)
    {
        $data = $this->request->params([
            ['organizer_name', ''],     // 主办方名称
            ['organizer_type', 1],      // 举办者类型：1个人 2单位
            ['organizer_license', ''],  // 单位证件
            ['contact_name', ''],       // 联系人
            ['contact_phone', ''],      // 联系电话
            ['remark', ''],             // 备注
        ]);

        // 验证必填字段
        $this->validate($data, 'addon\sport\app\validate\organizer\Organizer.edit');
        
        (new OrganizerService())->edit($id, $data);
        return success('EDIT_SUCCESS');
    }

    /**
     * 删除主办方
     * @param int $id
     * @return \think\Response
     */
    public function delete(int $id)
    {
        (new OrganizerService())->del($id);
        return success('DELETE_SUCCESS');
    }
} 