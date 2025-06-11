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

namespace addon\sport\app\service\api\event;

use addon\sport\app\model\sport_category\SportCategory;
use addon\sport\app\model\sport_base_item\SportBaseItem;
use addon\sport\app\model\sport_item\SportItem;
use core\base\BaseApiService;

/**
 * 赛事项目管理服务类
 */
class EventItemService extends BaseApiService
{
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * 获取运动分类列表（包含基础项目）
     * @param array $data
     * @return array
     */
    public function getCategories(array $data)
    {
        $event_id = $data['event_id'] ?? 0;
        
        // 获取所有分类，按sort排序
        $categories = (new SportCategory())->where([
            ['status', '=', 1]
        ])->order('sort asc, id asc')->select()->toArray();
        
        // 获取每个分类下的基础项目
        $category_ids = array_column($categories, 'id');
        $base_items = (new SportBaseItem())->where([
            ['category_id', 'in', $category_ids],
            ['status', '=', 1]
        ])->order('sort asc, id asc')->select()->toArray();
        
        // 按分类组织基础项目
        $base_items_by_category = [];
        foreach ($base_items as $item) {
            $base_items_by_category[$item['category_id']][] = $item;
        }
        
        // 获取赛事已选择的基础项目ID（如果有赛事ID）
        $selected_base_item_ids = [];
        if ($event_id > 0) {
            $selected_base_item_ids = (new SportItem())->where([
                ['event_id', '=', $event_id]
            ])->column('base_item_id');
        }
        
        // 整合数据
        foreach ($categories as &$category) {
            $category['base_items'] = $base_items_by_category[$category['id']] ?? [];
            
            // 标记已选择的项目
            foreach ($category['base_items'] as &$item) {
                $item['selected'] = in_array($item['id'], $selected_base_item_ids);
            }
            
            // 设置默认展开状态（田径、球类、棋类、趣味默认展开）
            $default_expand_names = ['田径运动', '球类运动', '棋类运动', '趣味运动'];
            $category['default_expand'] = in_array($category['name'], $default_expand_names);
        }
        
        return [
            'categories' => $categories,
            'selected_count' => count($selected_base_item_ids)
        ];
    }

    /**
     * 获取基础项目列表
     * @param array $data
     * @return array
     */
    public function getBaseItems(array $data)
    {
        $category_id = $data['category_id'] ?? 0;
        $keyword = $data['keyword'] ?? '';
        
        $where = [
            ['status', '=', 1]
        ];
        
        if ($category_id > 0) {
            $where[] = ['category_id', '=', $category_id];
        }
        
        if (!empty($keyword)) {
            $where[] = ['name', 'like', '%' . $keyword . '%'];
        }
        
        $list = (new SportBaseItem())->where($where)
            ->order('sort asc, id asc')
            ->select()
            ->toArray();
            
        return $list;
    }

    /**
     * 保存赛事项目选择
     * @param array $data
     * @return bool
     */
    public function saveEventItems(array $data)
    {
        $event_id = $data['event_id'] ?? 0;
        $base_item_ids = $data['base_item_ids'] ?? [];
        
        if (empty($event_id)) {
            throw new \Exception('赛事ID不能为空');
        }
        
        // 验证赛事权限
        $event_service = new EventService();
        $event_service->checkEventPermission($event_id);
        
        // 删除原有的项目选择
        (new SportItem())->where([
            ['event_id', '=', $event_id]
        ])->delete();
        
        // 添加新的项目选择
        if (!empty($base_item_ids)) {
            $insert_data = [];
            $base_items = (new SportBaseItem())->where([
                ['id', 'in', $base_item_ids],
                ['status', '=', 1]
            ])->select();
            
            foreach ($base_items as $base_item) {
                $insert_data[] = [
                    'event_id' => $event_id,
                    'base_item_id' => $base_item['id'],
                    'category_id' => $base_item['category_id'],
                    'name' => $base_item['name'],
                    'competition_type' => 1, // 默认个人赛
                    'gender_type' => 3, // 默认不限性别
                    'age_group' => '不限',
                    'max_participants' => 50,
                    'min_participants' => 1,
                    'registration_fee' => 0,
                    'rules' => $base_item['rules'] ?? '',
                    'equipment' => $base_item['equipment'] ?? '',
                    'venue_requirements' => $base_item['venue_requirements'] ?? '',
                    'sort' => $base_item['sort'],
                    'status' => 1,
                    'create_time' => time(),
                    'update_time' => time()
                ];
            }
            
            if (!empty($insert_data)) {
                (new SportItem())->insertAll($insert_data);
            }
        }
        
        return true;
    }

    /**
     * 获取赛事已选择的基础项目
     * @param array $data
     * @return array
     */
    public function getEventItems(array $data)
    {
        $event_id = $data['event_id'] ?? 0;
        
        if (empty($event_id)) {
            return [];
        }
        
        $list = (new SportItem())->where([
            ['event_id', '=', $event_id]
        ])->order('sort asc, id asc')
            ->select()
            ->toArray();
            
        return $list;
    }
} 