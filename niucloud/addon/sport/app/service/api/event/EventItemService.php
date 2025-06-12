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
     * 获取运动分类树形结构（四级分类）
     * @param array $data
     * @return array
     */
    public function getCategories(array $data)
    {
        $event_id = $data['event_id'] ?? 0;
        $level = $data['level'] ?? 1;
        $parent_id = $data['parent_id'] ?? 0;
        
        // 获取指定层级的分类
        $categories = (new SportCategory())->where([
            ['status', '=', 1],
            ['parent_id', '=', $parent_id],
            ['level', '=', $level]
        ])->order('sort asc, id asc')->select()->toArray();
        
        // 如果是获取三级分类，则需要加载对应的基础项目
        if ($level == 3) {
            return $this->getLevel3CategoriesWithItems($categories, $event_id);
        }
        
        // 对于一级和二级分类，获取子分类数量
        foreach ($categories as &$category) {
            $category['has_children'] = (new SportCategory())->where([
                ['parent_id', '=', $category['id']],
                ['status', '=', 1]
            ])->count() > 0;
            
            // 设置默认展开状态
            if ($level == 1) {
                $default_expand_names = ['水上运动', '田径类', '球类'];
                $category['default_expand'] = in_array($category['name'], $default_expand_names);
            }
        }
        
        return [
            'categories' => $categories,
            'level' => $level
        ];
    }
    
    /**
     * 获取三级分类及其基础项目
     * @param array $categories
     * @param int $event_id
     * @return array
     */
    private function getLevel3CategoriesWithItems($categories, $event_id = 0)
    {
        // 获取三级分类下的基础项目
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
            $category['item_count'] = count($category['base_items']);
            
            // 标记已选择的项目
            foreach ($category['base_items'] as &$item) {
                $item['selected'] = in_array($item['id'], $selected_base_item_ids);
            }
        }
        
        return [
            'categories' => $categories,
            'selected_count' => count($selected_base_item_ids),
            'level' => 3
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
        
        // 验证赛事权限
        $event_service = new EventService();
        $event_service->checkEventPermission($event_id);
        
        // 获取赛事的年龄组设置
        $event_info = $event_service->getEventInfo($event_id);
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
        
        $list = (new SportItem())->where([
            ['event_id', '=', $event_id]
        ])->order('sort asc, id asc')
            ->select()
            ->toArray();
            
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
} 