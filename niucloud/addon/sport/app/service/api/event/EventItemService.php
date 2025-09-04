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
use addon\sport\app\model\sport_event\SportEvent;
use addon\sport\app\service\api\event\EventService;
use core\base\BaseApiService;
use think\facade\Db;

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
     * 获取运动分类树形结构（支持2-4级灵活结构）
     * @param array $data
     * @return array
     */
    public function getCategories(array $data)
    {
        $event_id = $data['event_id'] ?? 0;
        
        // 获取所有一级分类
        $level1_categories = (new SportCategory())->where([
            ['status', '=', 1],
            ['level', '=', 1]
        ])->order('sort asc, id asc')->select()->toArray();
        
        // 获取赛事已选择的基础项目ID（如果有赛事ID）
        $selected_base_item_ids = [];
        if ($event_id > 0) {
            $selected_base_item_ids = (new SportItem())->where([
                ['event_id', '=', $event_id]
            ])->column('base_item_id');
        }
        
        // 为每个一级分类构建完整的树形结构
        foreach ($level1_categories as &$category) {
            $this->buildCategoryTree($category, $selected_base_item_ids);
            
            // 设置默认展开状态
            $default_expand_names = ['水上运动', '田径类', '球类'];
            $category['default_expand'] = in_array($category['name'], $default_expand_names);
        }
        unset($category); // 清除引用，避免后续意外修改
        

        
        return [
            'categories' => $level1_categories,
            'selected_count' => count($selected_base_item_ids)
        ];
    }
    
    /**
     * 递归构建分类树形结构
     * @param array $category
     * @param array $selected_base_item_ids
     * @return void
     */
    private function buildCategoryTree(&$category, $selected_base_item_ids = [])
    {
        // 获取子分类
        $children = (new SportCategory())->where([
            ['parent_id', '=', $category['id']],
            ['status', '=', 1]
        ])->order('sort asc, id asc')->select()->toArray();
        
        if (!empty($children)) {
            // 有子分类，递归构建
            foreach ($children as &$child) {
                $this->buildCategoryTree($child, $selected_base_item_ids);
            }
            unset($child); // 清除引用，避免后续意外修改
            $category['children'] = $children;
            $category['has_children'] = true;
        } else {
            // 没有子分类，检查是否有基础项目
            $category['children'] = [];
            $category['has_children'] = false;
        }
        
        // 获取当前分类下的基础项目
        $base_items = (new SportBaseItem())->where([
            ['category_id', '=', $category['id']],
            ['status', '=', 1]
        ])->order('sort asc, id asc')->select()->toArray();
        
        // 标记已选择的项目
        foreach ($base_items as &$item) {
            $item['selected'] = in_array($item['id'], $selected_base_item_ids);
        }
        unset($item); // 清除引用，避免后续意外修改
        
        $category['base_items'] = $base_items;
        $category['item_count'] = count($base_items);
        
        // 计算总项目数（包括子分类的项目）
        $total_items = count($base_items);
        if (!empty($category['children'])) {
            foreach ($category['children'] as $child) {
                $total_items += $this->countCategoryItems($child);
            }
        }
        $category['total_item_count'] = $total_items;
    }
    
    /**
     * 递归计算分类下的总项目数
     * @param array $category
     * @return int
     */
    private function countCategoryItems($category)
    {
        $count = $category['item_count'] ?? 0;
        if (!empty($category['children'])) {
            foreach ($category['children'] as $child) {
                $count += $this->countCategoryItems($child);
            }
        }
        return $count;
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
     * 保存赛事项目选择（支持年龄组动态生成）
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
        
        // 验证赛事权限和获取赛事信息
        $event_service = new EventService();
        $event_info = $event_service->getInfo($event_id);
        
        if (empty($event_info)) {
            throw new \Exception('赛事不存在');
        }
        
        // 验证权限：只能操作自己创建的赛事
        if ($event_info['member_id'] != $this->member_id) {
            throw new \Exception('无权限操作此赛事');
        }
        
        // 获取赛事的年龄组设置
        $age_groups = json_decode($event_info['age_groups'] ?? '["不限年龄"]', true);
        $age_group_display = $event_info['age_group_display'] ?? 0;
        
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
                // 根据年龄组设置生成项目
                $items_to_create = $this->generateItemsByAgeGroups(
                    $base_item, 
                    $age_groups, 
                    $age_group_display
                );
                
                foreach ($items_to_create as $item_data) {
                    $insert_data[] = array_merge([
                        'event_id' => $event_id,
                        'base_item_id' => $base_item['id'],
                        'category_id' => $base_item['category_id'],
                        'competition_type' => $base_item['competition_type'] ?? 1,
                        'gender_type' => $base_item['gender_type'] ?? 3,
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
                    ], $item_data);
                }
            }
            
            if (!empty($insert_data)) {
                (new SportItem())->insertAll($insert_data);
            }
        }
        
        return true;
    }
    
    /**
     * 根据年龄组设置生成项目数据
     * @param array $base_item 基础项目数据
     * @param array $age_groups 年龄组列表
     * @param int $age_group_display 是否显示年龄前缀
     * @return array
     */
    private function generateItemsByAgeGroups($base_item, $age_groups, $age_group_display)
    {
        $items = [];
        
        // 如果不限年龄或只有一个年龄组，不显示年龄前缀
        if (in_array('不限年龄', $age_groups) || count($age_groups) == 1) {
            $items[] = [
                'name' => $base_item['name'],
                'age_group' => $age_groups[0] == '不限年龄' ? '不限' : $age_groups[0]
            ];
        } else {
            // 多个年龄组，显示年龄前缀
            foreach ($age_groups as $age_group) {
                if ($age_group == '不限年龄') continue;
                
                $items[] = [
                    'name' => $age_group . $base_item['name'],
                    'age_group' => $age_group
                ];
            }
        }
        
        return $items;
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
        
        // 获取赛事项目列表，关联基础项目信息
        $list = (new SportItem())
            ->alias('si')
            ->join('sport_base_item sbi', 'si.base_item_id = sbi.id')
            ->join('sport_category sc', 'sbi.category_id = sc.id')
            ->where([
                ['si.event_id', '=', $event_id]
            ])
            ->field('si.*, sbi.name as base_item_name, sbi.competition_type, sbi.gender_type, sbi.remark as base_item_remark, sc.name as category_name')
            ->order('si.sort asc, si.id asc')
            ->select()
            ->toArray();
            
        // 处理返回数据：名称使用基础项目名；备注仅在项目备注为空时回填基础备注，避免覆盖用户自定义
        foreach ($list as &$item) {
            $item['name'] = $item['base_item_name'];
            if (!isset($item['remark']) || $item['remark'] === '' || $item['remark'] === null) {
                $item['remark'] = $item['base_item_remark'];
            }
        }
        unset($item);
            
        return $list;
    }

    /**
     * 获取分类列表（支持灵活多级结构）
     * @return array
     */
    public function getCategoryList()
    {
        // 获取所有一级分类
        $categoryModel = new SportCategory();
        $firstLevelCategories = $categoryModel->where([
            ['parent_id', '=', 0],
            ['status', '=', 1]
        ])->order('sort ASC')->select()->toArray();

        $result = [];
        foreach ($firstLevelCategories as $category) {
            $categoryData = [
                'id' => $category['id'],
                'name' => $category['name'],
                'code' => $category['code'],
                'level' => $category['level'],
                'children' => $this->getCategoryChildren($category['id']),
                'has_items' => $this->checkCategoryHasItems($category['id']),
                'structure_type' => $this->getCategoryStructureType($category['id'])
            ];
            $result[] = $categoryData;
        }

        return $result;
    }

    /**
     * 递归获取分类子级
     * @param int $parentId
     * @return array
     */
    private function getCategoryChildren($parentId)
    {
        $categoryModel = new SportCategory();
        $children = $categoryModel->where([
            ['parent_id', '=', $parentId],
            ['status', '=', 1]
        ])->order('sort ASC')->select()->toArray();

        if (empty($children)) {
            return [];
        }

        $result = [];
        foreach ($children as $child) {
            $childData = [
                'id' => $child['id'],
                'name' => $child['name'],
                'code' => $child['code'],
                'level' => $child['level'],
                'children' => $this->getCategoryChildren($child['id']),
                'has_items' => $this->checkCategoryHasItems($child['id']),
                'is_final_level' => $this->isFinalLevel($child['id'])
            ];
            $result[] = $childData;
        }

        return $result;
    }

    /**
     * 检查分类是否有直接关联的基础项目
     * @param int $categoryId
     * @return bool
     */
    private function checkCategoryHasItems($categoryId)
    {
        $baseItemModel = new SportBaseItem();
        $count = $baseItemModel->where([
            ['category_id', '=', $categoryId],
            ['status', '=', 1]
        ])->count();

        return $count > 0;
    }

    /**
     * 判断是否为最终级别（没有子分类但有基础项目）
     * @param int $categoryId
     * @return bool
     */
    private function isFinalLevel($categoryId)
    {
        $categoryModel = new SportCategory();
        $hasChildren = $categoryModel->where([
            ['parent_id', '=', $categoryId],
            ['status', '=', 1]
        ])->count() > 0;

        return !$hasChildren && $this->checkCategoryHasItems($categoryId);
    }

    /**
     * 获取分类的结构类型
     * @param int $categoryId
     * @return string
     */
    private function getCategoryStructureType($categoryId)
    {
        // 检查是否直接有基础项目（二级结构）
        if ($this->checkCategoryHasItems($categoryId)) {
            return 'level_2'; // 二级结构：分类 → 项目
        }

        // 检查子分类的最大深度
        $maxDepth = $this->getMaxCategoryDepth($categoryId, 1);
        
        if ($maxDepth == 2) {
            return 'level_3'; // 三级结构：分类 → 子分类 → 项目
        } elseif ($maxDepth >= 3) {
            return 'level_4'; // 四级结构：分类 → 子分类 → 子子分类 → 项目
        } else {
            return 'unknown';
        }
    }

    /**
     * 获取分类的最大深度
     * @param int $categoryId
     * @param int $currentDepth
     * @return int
     */
    private function getMaxCategoryDepth($categoryId, $currentDepth = 0)
    {
        $categoryModel = new SportCategory();
        $children = $categoryModel->where([
            ['parent_id', '=', $categoryId],
            ['status', '=', 1]
        ])->select();

        if ($children->isEmpty()) {
            return $currentDepth;
        }

        $maxChildDepth = $currentDepth;
        foreach ($children as $child) {
            // 如果这个子分类有基础项目，说明它是最终级别
            if ($this->checkCategoryHasItems($child['id'])) {
                $maxChildDepth = max($maxChildDepth, $currentDepth + 1);
            } else {
                // 递归检查更深层级
                $childDepth = $this->getMaxCategoryDepth($child['id'], $currentDepth + 1);
                $maxChildDepth = max($maxChildDepth, $childDepth);
            }
        }

        return $maxChildDepth;
    }

    /**
     * 根据分类ID获取基础项目（智能适配不同结构）
     * @param int $categoryId
     * @return array
     */
    public function getBaseItemsByCategory($categoryId)
    {
        $baseItemModel = new SportBaseItem();
        
        // 直接查询该分类下的基础项目
        $items = $baseItemModel->where([
            ['category_id', '=', $categoryId],
            ['status', '=', 1]
        ])->order('sort ASC')->select()->toArray();

        // 如果没有直接项目，可能需要查找子分类的项目
        if (empty($items)) {
            $items = $this->getItemsFromChildCategories($categoryId);
        }

        return $items;
    }

    /**
     * 从子分类中获取项目
     * @param int $parentCategoryId
     * @return array
     */
    private function getItemsFromChildCategories($parentCategoryId)
    {
        $categoryModel = new SportCategory();
        $baseItemModel = new SportBaseItem();
        
        // 获取所有子分类
        $childCategories = $categoryModel->where([
            ['parent_id', '=', $parentCategoryId],
            ['status', '=', 1]
        ])->select();

        $allItems = [];
        foreach ($childCategories as $category) {
            // 检查这个子分类是否有直接项目
            $items = $baseItemModel->where([
                ['category_id', '=', $category['id']],
                ['status', '=', 1]
            ])->order('sort ASC')->select()->toArray();

            if (!empty($items)) {
                $allItems = array_merge($allItems, $items);
            } else {
                // 递归查找更深层级的项目
                $deeperItems = $this->getItemsFromChildCategories($category['id']);
                $allItems = array_merge($allItems, $deeperItems);
            }
        }

        return $allItems;
    }

    /**
     * 获取可展开的分类（根据数据自动判断）
     * @return array
     */
    public function getExpandableCategories()
    {
        $result = [];
        
        // 获取所有一级分类
        $categoryModel = new SportCategory();
        $firstLevelCategories = $categoryModel->where([
            ['parent_id', '=', 0],
            ['status', '=', 1]
        ])->select();

        foreach ($firstLevelCategories as $category) {
            $structureType = $this->getCategoryStructureType($category['id']);
            
            // 根据结构类型决定默认展开策略
            if ($structureType === 'level_2') {
                // 二级结构，不需要展开子分类
                continue;
            } elseif ($structureType === 'level_3') {
                // 三级结构，展开到二级
                $result[] = $category['name'];
            } elseif ($structureType === 'level_4') {
                // 四级结构，根据具体业务需求展开
                $result[] = $category['name'];
                // 可能还需要展开特定的二级分类
                if (in_array($category['name'], ['水上运动', '田径类'])) {
                    $children = $this->getCategoryChildren($category['id']);
                    foreach ($children as $child) {
                        $result[] = $child['name'];
                    }
                }
            }
        }

        return $result;
    }
    
    /**
     * 更新项目设置
     * @param int $id
     * @param array $data
     * @return void
     */
    public function updateItemSettings(int $id, array $data)
    {
        // 验证项目是否存在
        $item = SportItem::where('id', $id)->find();
        if (!$item) {
            throw new \core\exception\CommonException('项目不存在');
        }
        
        // 验证权限：只能修改自己创建的赛事中的项目
        $event = SportEvent::where('id', $item['event_id'])->find();
        if (!$event || $event['member_id'] != $this->member_id) {
            throw new \core\exception\CommonException('无权限操作此项目');
        }
        
        // 验证数据
        if (isset($data['registration_fee']) && $data['registration_fee'] < 0) {
            throw new \core\exception\CommonException('报名费不能为负数');
        }
        
        if (isset($data['max_participants']) && $data['max_participants'] < 0) {
            throw new \core\exception\CommonException('人数限制不能为负数');
        }
        
        if (isset($data['rounds']) && $data['rounds'] < 0) {
            throw new \core\exception\CommonException('比赛轮次不能为负数');
        }
        
        // 规范化/校验 - 修复布尔值转换问题
        $registration_fee = (float)($data['registration_fee'] ?? 0);
        $max_participants = (int)($data['max_participants'] ?? 0);
        $rounds = (int)($data['rounds'] ?? 0);
        
        // 修复布尔值转换：true->1, false->0
        $allow_duplicate_registration = 0;
        if (isset($data['allow_duplicate_registration'])) {
            if (is_bool($data['allow_duplicate_registration'])) {
                $allow_duplicate_registration = $data['allow_duplicate_registration'] ? 1 : 0;
            } else {
                $allow_duplicate_registration = (int)$data['allow_duplicate_registration'];
            }
        }
        
        $is_round_robin = 0;
        if (isset($data['is_round_robin'])) {
            if (is_bool($data['is_round_robin'])) {
                $is_round_robin = $data['is_round_robin'] ? 1 : 0;
            } else {
                $is_round_robin = (int)$data['is_round_robin'];
            }
        } else {
            $is_round_robin = (int)($item['is_round_robin'] ?? 0);
        }
        
        $group_size = isset($data['group_size']) ? max(0, (int)$data['group_size']) : ((int)($item['group_size'] ?? 0));

        // 更新数据
        $update_data = [
            'registration_fee' => $registration_fee,
            'max_participants' => $max_participants,
            'rounds' => $rounds,
            'allow_duplicate_registration' => $allow_duplicate_registration,
            'is_round_robin' => $is_round_robin,
            'group_size' => $group_size,
            'venue_count' => (int)($data['venue_count'] ?? 0),
            'venue_type' => $data['venue_type'] ?? '',
            'remark' => $data['remark'] ?? '',
            'update_time' => time()
        ];
        
        // 添加调试日志
        \think\facade\Log::info('EventItemService updateItemSettings Debug: item_id=' . $id . ', update_data=' . json_encode($update_data) . ', original_data=' . json_encode($data));
        
        // 执行更新并记录影响行数
        $affected_rows = SportItem::where('id', $id)->update($update_data);
        
        // 记录更新结果
        \think\facade\Log::info('EventItemService updateItemSettings Result: item_id=' . $id . ', affected_rows=' . $affected_rows);
        
        if ($affected_rows === 0) {
            \think\facade\Log::warning('EventItemService updateItemSettings Warning: No rows affected for item_id=' . $id);
        }
    }
    
    /**
     * 获取项目已分配的场地
     * @param int $itemId
     * @return array
     */
    public function getItemVenues(int $itemId)
    {
        // 使用 $this->member_id，这是正确的方式
        $member_id = $this->member_id;
        
        // 验证项目是否存在
        $item = SportItem::where('id', $itemId)->find();
        if (!$item) {
            throw new \core\exception\CommonException('项目不存在');
        }
        
        // 验证权限：只能查看自己创建的赛事中的项目
        $event = SportEvent::where('id', $item['event_id'])->find();
        if (!$event || $event['member_id'] != $member_id) {
            throw new \core\exception\CommonException('无权限操作此项目');
        }
        
        $assignment_model = new \addon\sport\app\model\assignment\SportItemVenueAssignment();
        
        return $assignment_model
            ->alias('a')
            ->leftJoin('sport_venue v', 'a.venue_id = v.id')
            ->where([
                ['a.item_id', '=', $itemId],
                ['a.status', '=', 1]
            ])
            ->field('a.id, a.venue_id, a.assignment_type, a.start_time, a.end_time, a.remark, v.name, v.venue_code, v.venue_category, v.venue_type, v.type, v.location, v.capacity')
            ->order('a.sort asc, a.id asc')
            ->select()
            ->toArray();
    }
    
    /**
     * 为项目分配场地
     * @param int $itemId
     * @param array $data
     * @return void
     */
    public function assignVenueToItem(int $itemId, array $data)
    {
        // 验证项目是否存在
        $item = SportItem::where('id', $itemId)->find();
        if (!$item) {
            throw new \core\exception\CommonException('项目不存在');
        }
        
        // 验证权限：只能修改自己创建的赛事中的项目
        $event = SportEvent::where('id', $item['event_id'])->find();
        if (!$event || $event['member_id'] != $this->member_id) {
            throw new \core\exception\CommonException('无权限操作此项目');
        }
        
        // 验证场地是否存在且属于该赛事
        $venue_model = new \addon\sport\app\model\venue\SportVenue();
        $venue = $venue_model->where([
            ['id', '=', $data['venue_id']],
            ['event_id', '=', $item['event_id']],
            ['status', '=', 1]
        ])->find();
        
        if (!$venue) {
            throw new \core\exception\CommonException('场地不存在或不可用');
        }
        
        Db::transaction(function () use ($itemId, $data) {
            $assignment_model = new \addon\sport\app\model\assignment\SportItemVenueAssignment();
            // 使用行级锁避免并发导致的唯一键冲突
            $exists = $assignment_model->where([
                ['item_id', '=', $itemId],
                ['venue_id', '=', $data['venue_id']],
            ])->lock(true)->find();

            if ($exists) {
                if ((int)$exists['status'] === 1) {
                    // 已是有效分配，直接返回
                    return;
                }
                // 恢复软删除记录为有效
                $assignment_model->where('id', $exists['id'])->update([
                    'assignment_type' => $data['assignment_type'] ?? ($exists['assignment_type'] ?? 1),
                    'start_time' => $data['start_time'] ?? $exists['start_time'] ?? null,
                    'end_time' => $data['end_time'] ?? $exists['end_time'] ?? null,
                    'remark' => $data['remark'] ?? $exists['remark'] ?? '',
                    'status' => 1,
                    'update_time' => time()
                ]);
                return;
            }

            // 创建分配记录
            $assignment_data = [
                'item_id' => $itemId,
                'venue_id' => $data['venue_id'],
                'assignment_type' => $data['assignment_type'] ?? 1,
                'start_time' => $data['start_time'] ?? null,
                'end_time' => $data['end_time'] ?? null,
                'sort' => 0,
                'status' => 1,
                'remark' => $data['remark'] ?? '',
                'create_time' => time(),
                'update_time' => time()
            ];

            try {
                $assignment_model->save($assignment_data);
            } catch (\Throwable $e) {
                // 并发场景下兜底：若触发唯一键冲突，转为更新/恢复
                if (strpos($e->getMessage(), '1062') !== false || strpos($e->getMessage(), '23000') !== false) {
                    $existsAgain = $assignment_model->where([
                        ['item_id', '=', $itemId],
                        ['venue_id', '=', $data['venue_id']],
                    ])->find();
                    if ($existsAgain) {
                        $assignment_model->where('id', $existsAgain['id'])->update([
                            'status' => 1,
                            'update_time' => time()
                        ]);
                        return;
                    }
                }
                throw $e;
            }
        });
    }
    
    /**
     * 移除项目场地分配
     * @param int $itemId
     * @param int $venueId
     * @return void
     */
    public function removeVenueFromItem(int $itemId, int $venueId)
    {
        // 验证项目是否存在
        $item = SportItem::where('id', $itemId)->find();
        if (!$item) {
            throw new \core\exception\CommonException('项目不存在');
        }
        
        // 验证权限：只能修改自己创建的赛事中的项目
        $event = SportEvent::where('id', $item['event_id'])->find();
        if (!$event || $event['member_id'] != $this->member_id) {
            throw new \core\exception\CommonException('无权限操作此项目');
        }
        
        $assignment_model = new \addon\sport\app\model\assignment\SportItemVenueAssignment();
        
        // 查找要删除的分配记录
        $assignment = $assignment_model->where([
            ['item_id', '=', $itemId],
            ['venue_id', '=', $venueId]
        ])->find();
        
        if (!$assignment) {
            throw new \core\exception\CommonException('场地分配记录不存在');
        }
        
        // 软删除分配记录
        $affected = $assignment_model->where([
            ['item_id', '=', $itemId],
            ['venue_id', '=', $venueId]
        ])->update([
            'status' => 0,
            'update_time' => time()
        ]);
        
        if ($affected === 0) {
            throw new \core\exception\CommonException('删除操作失败，没有记录被更新');
        }
    }
    
    /**
     * 批量分配场地给项目
     * @param int $itemId
     * @param array $data
     * @return void
     */
    public function batchAssignVenuesToItem(int $itemId, array $data)
    {
        // 验证项目是否存在
        $item = SportItem::where('id', $itemId)->find();
        if (!$item) {
            throw new \core\exception\CommonException('项目不存在');
        }
        
        // 验证权限：只能修改自己创建的赛事中的项目
        $event = SportEvent::where('id', $item['event_id'])->find();
        if (!$event || $event['member_id'] != $this->member_id) {
            throw new \core\exception\CommonException('无权限操作此项目');
        }
        
        if (empty($data['venue_ids']) || !is_array($data['venue_ids'])) {
            throw new \core\exception\CommonException('请选择要分配的场地');
        }
        
        foreach ($data['venue_ids'] as $venueId) {
            // 验证场地是否存在且属于该赛事
            $venue_model = new \addon\sport\app\model\venue\SportVenue();
            $venue = $venue_model->where([
                ['id', '=', $venueId],
                ['event_id', '=', $item['event_id']],
                ['status', '=', 1]
            ])->find();
            
            if (!$venue) {
                continue; // 跳过无效场地
            }
            
            Db::transaction(function () use ($itemId, $venueId, $data) {
                // 检查是否已经分配过该场地（包含已软删除记录），并加锁避免并发
                $assignment_model = new \addon\sport\app\model\assignment\SportItemVenueAssignment();
                $exists = $assignment_model->where([
                    ['item_id', '=', $itemId],
                    ['venue_id', '=', $venueId],
                ])->lock(true)->find();

                if ($exists) {
                    if ((int)$exists['status'] === 1) {
                        return; // 已有效分配
                    }
                    // 恢复软删除记录为有效
                    $assignment_model->where('id', $exists['id'])->update([
                        'assignment_type' => $data['assignment_type'] ?? ($exists['assignment_type'] ?? 1),
                        'start_time' => $data['start_time'] ?? $exists['start_time'] ?? null,
                        'end_time' => $data['end_time'] ?? $exists['end_time'] ?? null,
                        'remark' => $exists['remark'] ?? '',
                        'status' => 1,
                        'update_time' => time()
                    ]);
                    return;
                }

                // 创建分配记录
                $assignment_data = [
                    'item_id' => $itemId,
                    'venue_id' => $venueId,
                    'assignment_type' => $data['assignment_type'] ?? 1,
                    'start_time' => $data['start_time'] ?? null,
                    'end_time' => $data['end_time'] ?? null,
                    'sort' => 0,
                    'status' => 1,
                    'remark' => '',
                    'create_time' => time(),
                    'update_time' => time()
                ];

                try {
                    $assignment_model->save($assignment_data);
                } catch (\Throwable $e) {
                    if (strpos($e->getMessage(), '1062') !== false || strpos($e->getMessage(), '23000') !== false) {
                        $existsAgain = $assignment_model->where([
                            ['item_id', '=', $itemId],
                            ['venue_id', '=', $venueId],
                        ])->find();
                        if ($existsAgain) {
                            $assignment_model->where('id', $existsAgain['id'])->update([
                                'status' => 1,
                                'update_time' => time()
                            ]);
                            return;
                        }
                    }
                    throw $e;
                }
            });
        }
    }
    
    /**
     * 获取可用场地列表（用于项目选择）
     * @param int $itemId
     * @param array $data
     * @return array
     */
    public function getAvailableVenuesForItem(int $itemId, array $data = [])
    {
        // 验证项目是否存在
        $item = SportItem::where('id', $itemId)->find();
        if (!$item) {
            throw new \core\exception\CommonException('项目不存在');
        }
        
        // 验证权限：只能查看自己创建的赛事中的项目
        $event = SportEvent::where('id', $item['event_id'])->find();
        if (!$event || $event['member_id'] != $this->member_id) {
            throw new \core\exception\CommonException('无权限操作此项目');
        }
        
        $venue_model = new \addon\sport\app\model\venue\SportVenue();
        
        $where = [
            ['event_id', '=', $item['event_id']],
            ['status', '=', 1],
            ['is_available', '=', 1]
        ];
        
        if (!empty($data['venue_type'])) {
            $where[] = ['venue_type', '=', $data['venue_type']];
        }
        
        if (!empty($data['keyword'])) {
            $where[] = ['name|venue_code', 'like', '%' . $data['keyword'] . '%'];
        }
        
        $field = 'id, name, venue_code, venue_category, venue_type, type, location, capacity, is_available';
        
        $search_model = $venue_model
            ->where($where)
            ->field($field)
            ->order('sort asc, id asc');
        
        return $this->pageQuery($search_model);
    }
} 