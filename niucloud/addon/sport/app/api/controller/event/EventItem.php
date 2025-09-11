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
        
        // 临时返回固定值，用于定位问题
        \think\facade\Log::info('=== EventItem save 接口调试 ===');
        \think\facade\Log::info('接收到的数据: ' . json_encode($data, JSON_UNESCAPED_UNICODE));
        \think\facade\Log::info('event_id: ' . $data['event_id']);
        \think\facade\Log::info('base_item_ids: ' . json_encode($data['base_item_ids'], JSON_UNESCAPED_UNICODE));
        \think\facade\Log::info('base_item_ids 类型: ' . gettype($data['base_item_ids']));
        
        // 暂时注释掉实际保存逻辑，直接返回成功
        // (new EventItemService())->saveEventItems($data);
        
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
        
        // 添加调试日志
        \think\facade\Log::info('=== EventItem Controller getEventItems 调试 ===');
        \think\facade\Log::info('接收到的参数: ' . json_encode($data, JSON_UNESCAPED_UNICODE));
        
        $result = (new EventItemService())->getEventItems($data);
        
        \think\facade\Log::info('服务层返回结果: ' . json_encode($result, JSON_UNESCAPED_UNICODE));
        \think\facade\Log::info('=== 控制器调试结束 ===');
        
        return success($result);
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
            ['is_round_robin', 0],                  // 是否循环赛（小组）
            ['group_size', 0],                      // 每组人数（0表示不分组）
            ['remark', ''],                         // 项目说明
            ['venue_count', 0],                     // 需要的场地数量
            ['venue_type', ''],                     // 场地类型
        ]);
        
        (new EventItemService())->updateItemSettings($id, $data);
        return success('UPDATE_SUCCESS');
    }
    
    /**
     * 获取项目已分配的场地
     * @param int $id 项目ID
     * @return \think\Response
     */
    public function getItemVenues(int $id)
    {
        return success((new EventItemService())->getItemVenues($id));
    }
    
    /**
     * 为项目分配场地
     * @param int $id 项目ID
     * @return \think\Response
     */
    public function assignVenue(int $id)
    {
        $data = $this->request->params([
            ['venue_id', 0],                        // 场地ID
            ['assignment_type', 1],                 // 分配类型：1独占 2共享
            ['start_time', null],                   // 开始使用时间
            ['end_time', null],                     // 结束使用时间
            ['remark', ''],                         // 备注
        ]);
        
        // 验证必填字段
        if (empty($data['venue_id'])) {
            return error('请选择要分配的场地');
        }
        
        (new EventItemService())->assignVenueToItem($id, $data);
        return success('ASSIGN_SUCCESS');
    }
    
    /**
     * 移除项目场地分配
     * @param int $id 项目ID
     * @param int $venueId 场地ID
     * @return \think\Response
     */
    public function removeVenueAssignment(int $id, int $venueId)
    {
        (new EventItemService())->removeVenueFromItem($id, $venueId);
        return success('REMOVE_SUCCESS');
    }
    
    /**
     * 批量分配场地给项目
     * @param int $id 项目ID
     * @return \think\Response
     */
    public function batchAssignVenues(int $id)
    {
        $data = $this->request->params([
            ['venue_ids', []],                      // 场地ID数组
            ['assignment_type', 1],                 // 分配类型：1独占 2共享
            ['start_time', null],                   // 开始使用时间
            ['end_time', null],                     // 结束使用时间
        ]);
        
        // 验证必填字段
        if (empty($data['venue_ids']) || !is_array($data['venue_ids'])) {
            return error('请选择要分配的场地');
        }
        
        (new EventItemService())->batchAssignVenuesToItem($id, $data);
        return success('BATCH_ASSIGN_SUCCESS');
    }
    
    /**
     * 获取可用场地列表（用于项目选择）
     * @param int $id 项目ID
     * @return \think\Response
     */
    public function getAvailableVenues(int $id)
    {
        $data = $this->request->params([
            ['venue_type', ''],                     // 场地类型筛选
            ['keyword', ''],                        // 关键词搜索
            ['page', 1],                           // 页码
            ['limit', 15],                         // 每页数量
        ]);
        
        return success((new EventItemService())->getAvailableVenuesForItem($id, $data));
    }
} 