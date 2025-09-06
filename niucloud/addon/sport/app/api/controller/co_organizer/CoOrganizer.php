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

namespace addon\sport\app\api\controller\co_organizer;

use addon\sport\app\service\api\co_organizer\CoOrganizerService;
use core\base\BaseApiController;

/**
 * 协办单位控制器
 * Class CoOrganizer
 * @package addon\sport\app\api\controller\co_organizer
 */
class CoOrganizer extends BaseApiController
{
    /**
     * 获取赛事协办单位列表
     * @param int $event_id
     * @return \think\Response
     */
    public function list(int $event_id)
    {
        $data = $this->request->params([
            ['organizer_type', ''],    // 协办单位类型
            ['organizer_name', ''],    // 协办单位名称
            ['status', ''],            // 状态
        ]);
        
        return success((new CoOrganizerService())->getList($event_id, $data));
    }

    /**
     * 添加协办单位
     * @return \think\Response
     */
    public function add()
    {
        $data = $this->request->params([
            ['event_id', 0],           // 赛事ID
            ['organizer_id', 0],       // 协办单位ID
            ['organizer_type', 1],     // 协办单位类型：1协办单位 2赞助商 3支持单位
            ['organizer_name', ''],    // 协办单位名称
            ['logo', ''],              // 单位logo
            ['contact_name', ''],      // 联系人
            ['contact_phone', ''],     // 联系电话
            ['sort', 0],               // 排序
            ['status', 1],             // 状态
            ['remark', ''],            // 备注
        ]);

        // 验证必填字段
        if (empty($data['event_id'])) {
            return fail('SPORT_EVENT_ID_REQUIRED');
        }
        if (empty($data['organizer_name'])) {
            return fail('SPORT_ORGANIZER_NAME_REQUIRED');
        }
        
        $id = (new CoOrganizerService())->add($data);
        return success('ADD_SUCCESS', ['id' => $id]);
    }

    /**
     * 获取协办单位详情
     * @param int $id
     * @return \think\Response
     */
    public function info(int $id)
    {
        return success((new CoOrganizerService())->getInfo($id));
    }

    /**
     * 编辑协办单位
     * @param int $id
     * @return \think\Response
     */
    public function edit(int $id)
    {
        $data = $this->request->params([
            ['organizer_id', 0],       // 协办单位ID
            ['organizer_type', 1],     // 协办单位类型：1协办单位 2赞助商 3支持单位
            ['organizer_name', ''],    // 协办单位名称
            ['logo', ''],              // 单位logo
            ['contact_name', ''],      // 联系人
            ['contact_phone', ''],     // 联系电话
            ['sort', 0],               // 排序
            ['status', 1],             // 状态
            ['remark', ''],            // 备注
        ]);

        // 验证必填字段
        if (empty($data['organizer_name'])) {
            return fail('SPORT_ORGANIZER_NAME_REQUIRED');
        }
        
        (new CoOrganizerService())->edit($id, $data);
        return success('EDIT_SUCCESS');
    }

    /**
     * 删除协办单位
     * @param int $id
     * @return \think\Response
     */
    public function del(int $id)
    {
        (new CoOrganizerService())->del($id);
        return success('DELETE_SUCCESS');
    }

    /**
     * 批量添加协办单位
     * @return \think\Response
     */
    public function batchAdd()
    {
        $data = $this->request->params([
            ['event_id', 0],           // 赛事ID
            ['co_organizers', []],     // 协办单位列表
        ]);

        // 验证必填字段
        if (empty($data['event_id'])) {
            return fail('SPORT_EVENT_ID_REQUIRED');
        }
        if (empty($data['co_organizers']) || !is_array($data['co_organizers'])) {
            return fail('SPORT_CO_ORGANIZERS_REQUIRED');
        }

        // 验证每个协办单位数据
        foreach ($data['co_organizers'] as $index => $co_organizer) {
            if (empty($co_organizer['organizer_name'])) {
                return fail('SPORT_ORGANIZER_NAME_REQUIRED', ['index' => $index + 1]);
            }
        }
        
        $result = (new CoOrganizerService())->batchAdd($data['event_id'], $data['co_organizers']);
        return success('BATCH_ADD_SUCCESS', $result);
    }
}
