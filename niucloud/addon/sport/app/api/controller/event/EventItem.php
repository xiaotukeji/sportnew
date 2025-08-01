<?php
// +----------------------------------------------------------------------
// | Niucloud-admin 企业快速开发的saas管理平台
// +----------------------------------------------------------------------
// | 官方网址：https://www.niucloud.com
// +----------------------------------------------------------------------
// | niucloud团队 版权所有 开源版本可自由商用
// +----------------------------------------------------------------------
// | Author: Niucloud Team
// +----------------------------------------------------------------------

namespace addon\sport\app\api\controller\event;

use addon\sport\app\service\api\event\EventItemService;
use core\base\BaseApiController;

/**
 * 赛事项目管理控制器
 */
class EventItem extends BaseApiController
{
    /**
     * 获取运动分类列表（包含基础项目）
     * @return \think\Response
     */
    public function categories()
    {
        $data = $this->request->params([
            ['event_id', 0]
        ]);
        return success((new EventItemService())->getCategories($data));
    }

    /**
     * 获取基础项目列表
     * @return \think\Response
     */
    public function baseItems()
    {
        $data = $this->request->params([
            ['category_id', 0],
            ['keyword', '']
        ]);
        return success((new EventItemService())->getBaseItems($data));
    }

    /**
     * 保存赛事项目选择
     * @return \think\Response
     */
    public function save()
    {
        $data = $this->request->params([
            ['event_id', 0],
            ['base_item_ids', []]
        ]);
        
        (new EventItemService())->saveEventItems($data);
        return success('保存成功');
    }

    /**
     * 获取赛事已选择的基础项目
     * @return \think\Response
     */
    public function getEventItems()
    {
        $data = $this->request->params([
            ['event_id', 0]
        ]);
        return success((new EventItemService())->getEventItems($data));
    }
    
    /**
     * 更新项目设置
     * @param int $id
     * @return \think\Response
     */
    public function updateItemSettings(int $id)
    {
        $data = $this->request->params([
            ['registration_fee', 0],                // 报名费
            ['max_participants', 0],                // 人数限制
            ['rounds', 0],                          // 比赛轮次
            ['allow_duplicate_registration', 0],    // 是否允许重复报名
            ['remark', ''],                         // 项目说明
        ]);
        
        (new EventItemService())->updateItemSettings($id, $data);
        return success('UPDATE_SUCCESS');
    }
} 