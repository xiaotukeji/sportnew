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

namespace addon\sport\app\service\api\event;

use addon\sport\app\model\event\SportEvent;
use addon\sport\app\model\sport_item\SportItem;
use addon\sport\app\model\organizer\SportOrganizer;
use addon\sport\app\model\series\SportEventSeries;
use core\base\BaseApiService;
use core\exception\CommonException;

/**
 * 改进版赛事服务层
 * Class EventQoderService
 * @package addon\sport\app\service\api\event
 */
class EventQoderService extends BaseApiService
{
    public function __construct()
    {
        parent::__construct();
        $this->model = new SportEvent();
    }

    /**
     * 一体化创建赛事
     * @param array $data
     * @return int
     */
    public function createAllInOne(array $data)
    {
        // 验证主办方是否属于当前用户
        if (isset($data['organizer_id']) && !empty($data['organizer_id'])) {
            $this->checkOrganizerPermission($data['organizer_id']);
        }
        
        // 如果是系列赛，验证系列赛是否属于当前用户
        if (isset($data['event_type']) && $data['event_type'] == 2 && !empty($data['series_id'])) {
            $this->checkSeriesPermission($data['series_id']);
        }
        
        // 合并日期和时间
        $start_time = strtotime($data['start_date'] . ' ' . $data['start_time']);
        $end_time = strtotime($data['end_date'] . ' ' . $data['end_time']);
        
        // 准备赛事数据
        $event_data = [
            'name' => $data['name'],
            'location' => $data['location'],
            'address_detail' => $data['address_detail'],
            'start_time' => $start_time,
            'end_time' => $end_time,
            'organizer_id' => $data['organizer_id'],
            'event_type' => $data['event_type'],
            'series_id' => $data['series_id'] ?? 0,
            'year' => date('Y', $start_time),
            'status' => 0,  // 默认状态为待发布
            'sort' => 0,
            'member_id' => $this->member_id,
            'create_time' => time(),
            'update_time' => time()
        ];
        
        // 开启事务
        $this->model->startTrans();
        try {
            // 保存赛事基本信息
            $this->model->save($event_data);
            $event_id = $this->model->id;
            
            // 保存比赛项目
            if (!empty($data['base_item_ids'])) {
                $this->saveEventItems($event_id, $data['base_item_ids']);
            }
            
            $this->model->commit();
            return $event_id;
        } catch (\Exception $e) {
            $this->model->rollback();
            throw new CommonException($e->getMessage());
        }
    }

    /**
     * 保存赛事比赛项目
     * @param int $event_id
     * @param array $base_item_ids
     * @return void
     */
    private function saveEventItems(int $event_id, array $base_item_ids)
    {
        $item_model = new SportItem();
        
        foreach ($base_item_ids as $index => $base_item_id) {
            // 获取基础项目信息
            $base_item = \addon\sport\app\model\sport_base_item\SportBaseItem::where('id', $base_item_id)->find();
            if (!$base_item) {
                continue;
            }
            
            $item_data = [
                'event_id' => $event_id,
                'base_item_id' => $base_item_id,
                'name' => $base_item['name'],
                'category_id' => $base_item['category_id'],
                'description' => $base_item['description'] ?? '',
                'rules' => $base_item['rules'] ?? '',
                'equipment' => $base_item['equipment'] ?? '',
                'venue_requirements' => $base_item['venue_requirements'] ?? '',
                'sort' => $index,
                'status' => 1,
                'create_time' => time(),
                'update_time' => time()
            ];
            
            $item_model->save($item_data);
            $item_model = new SportItem(); // 重新实例化
        }
    }

    /**
     * 验证主办方权限
     * @param int $organizer_id
     * @return void
     * @throws CommonException
     */
    private function checkOrganizerPermission(int $organizer_id)
    {
        $organizer = (new SportOrganizer())
            ->where([
                ['id', '=', $organizer_id],
                ['member_id', '=', $this->member_id],
                ['status', '=', 1]
            ])
            ->findOrEmpty();
            
        if ($organizer->isEmpty()) {
            throw new CommonException('主办方不存在或无权限');
        }
    }

    /**
     * 验证系列赛权限
     * @param int $series_id
     * @return void
     * @throws CommonException
     */
    private function checkSeriesPermission(int $series_id)
    {
        $series = (new SportEventSeries())
            ->where([
                ['id', '=', $series_id],
                ['member_id', '=', $this->member_id],
                ['status', '=', 1]
            ])
            ->findOrEmpty();
            
        if ($series->isEmpty()) {
            throw new CommonException('系列赛不存在或无权限');
        }
    }

    /**
     * 获取创建赛事所需初始化数据
     * @return array
     */
    public function getInit()
    {
        return [
            'event_type_list' => [
                ['value' => 1, 'label' => '独立赛事'],
                ['value' => 2, 'label' => '系列赛事']
            ],
            'organizer_type_list' => [
                ['value' => 1, 'label' => '个人'],
                ['value' => 2, 'label' => '单位']
            ],
            'current_year' => date('Y')
        ];
    }
}
?>
</file>