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
use addon\sport\app\model\organizer\SportOrganizer;
use addon\sport\app\model\series\SportEventSeries;
use addon\sport\app\model\group\SportEventGroup;
use addon\sport\app\model\item\SportItem;
use core\base\BaseApiService;
use core\exception\CommonException;

/**
 * 赛事服务层
 * Class EventService
 * @package addon\sport\app\service\api\event
 */
class EventService extends BaseApiService
{
    public function __construct()
    {
        parent::__construct();
        $this->model = new SportEvent();
    }

    /**
     * 获取赛事列表
     * @param array $data
     * @return array
     */
    public function getList(array $data = [])
    {
        $field = 'id, name, event_type, year, start_time, end_time, location, organizer_id, organizer_type, status, create_time';
        
        $order = 'create_time desc';
        
        $where = [];
        if (!empty($data['name'])) {
            $where[] = ['name', 'like', '%' . $data['name'] . '%'];
        }
        if (!empty($data['year'])) {
            $where[] = ['year', '=', $data['year']];
        }
        if ($data['event_type'] !== '') {
            $where[] = ['event_type', '=', $data['event_type']];
        }
        if ($data['organizer_type'] !== '') {
            $where[] = ['organizer_type', '=', $data['organizer_type']];
        }
        if ($data['status'] !== '') {
            $where[] = ['status', '=', $data['status']];
        }
        
        // 如果查看我的赛事，需要通过主办方关联查询
        if (!empty($data['my_events']) && $this->member_id) {
            $where[] = ['organizer_id', 'in', function($query) {
                $query->name('sport_organizer')
                      ->where('member_id', $this->member_id)
                      ->field('id');
            }];
        }

        $search_model = $this->model
            ->where($where)
            ->withJoin(['organizer' => ['organizer_name']])
            ->withJoin(['series' => ['name as series_name']], 'LEFT')
            ->field($field)
            ->order($order)
            ->append(['start_time_text', 'end_time_text', 'event_type_text', 'organizer_type_text']);

        return $this->pageQuery($search_model);
    }

    /**
     * 获取赛事详情
     * @param int $id
     * @return array
     */
    public function getInfo(int $id)
    {
        $field = 'se.id, se.series_id, se.name, se.event_type, se.year, se.season, se.start_time, se.end_time, se.location, se.location_detail, se.latitude, se.longitude, se.organizer_id, se.organizer_type, se.member_id, se.sort, se.status, se.remark, se.age_groups, se.age_group_display, se.registration_start_time, se.registration_end_time, se.registration_fee, se.max_participants, se.group_size, se.rounds, se.allow_duplicate_registration, se.show_participant_count, se.show_progress, se.create_time, se.update_time';
        
        $info = $this->model
            ->alias('se')
            ->leftJoin('sport_organizer so', 'se.organizer_id = so.id')
            ->leftJoin('sport_event_series ses', 'se.series_id = ses.id')
            ->where([['se.id', '=', $id]])
            ->field($field . ', so.organizer_name, so.contact_name, so.contact_phone, ses.name as series_name')
            ->append(['start_time_text', 'end_time_text', 'event_type_text', 'organizer_type_text', 'status_text'])
            ->findOrEmpty()
            ->toArray();
            
        if (empty($info)) {
            throw new CommonException('SPORT_EVENT_NOT_EXIST');
        }
        
        return $info;
    }

    /**
     * 添加赛事
     * @param array $data
     * @return mixed
     */
    public function add(array $data)
    {
        // 验证主办方是否属于当前用户
        $this->checkOrganizerPermission($data['organizer_id']);
        
        // 如果是系列赛，验证系列赛是否属于当前用户
        if ($data['event_type'] == 2 && !empty($data['series_id'])) {
            $this->checkSeriesPermission($data['series_id']);
        }
        
        // 提取自定义分组和比赛项目数据
        $custom_groups = $data['custom_groups'] ?? [];
        $base_item_ids = $data['base_item_ids'] ?? [];
        unset($data['custom_groups'], $data['base_item_ids']);
        
        $data['create_time'] = time();
        $data['update_time'] = time();
        $data['status'] = 0;  // 默认状态为待发布
        $data['sort'] = 0;
        $data['member_id'] = $this->member_id;  // 设置发布者ID
        
        // 开启事务
        $this->model->startTrans();
        try {
            // 保存赛事基本信息
            $res = $this->model->save($data);
            $event_id = $this->model->id;
            
            // 保存自定义分组
            if (!empty($custom_groups)) {
                $this->saveEventGroups($event_id, $custom_groups);
            }
            
            // 保存比赛项目
            if (!empty($base_item_ids)) {
                $this->saveEventItems($event_id, $base_item_ids);
            }
            
            $this->model->commit();
            return $event_id;
        } catch (\Exception $e) {
            $this->model->rollback();
            throw new CommonException($e->getMessage());
        }
    }

    /**
     * 编辑赛事
     * @param int $id
     * @param array $data
     * @return bool
     */
    public function edit(int $id, array $data)
    {
        // 验证赛事是否存在且属于当前用户
        $this->checkEventPermission($id);
        
        // 验证主办方是否属于当前用户
        $this->checkOrganizerPermission($data['organizer_id']);
        
        // 如果是系列赛，验证系列赛是否属于当前用户
        if ($data['event_type'] == 2 && !empty($data['series_id'])) {
            $this->checkSeriesPermission($data['series_id']);
        }
        
        $data['update_time'] = time();
        
        $this->model->where([['id', '=', $id]])->update($data);
        return true;
    }

    /**
     * 删除赛事
     * @param int $id
     * @return bool
     */
    public function del(int $id)
    {
        // 验证赛事是否存在且属于当前用户
        $this->checkEventPermission($id);
        
        $this->model->where([['id', '=', $id]])->delete();
        return true;
    }

    /**
     * 获取创建初始化数据
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

    /**
     * 验证赛事权限
     * @param int $event_id
     * @return void
     * @throws CommonException
     */
    private function checkEventPermission(int $event_id)
    {
        $event = $this->model
            ->where([
                ['id', '=', $event_id],
                ['member_id', '=', $this->member_id]
            ])
            ->findOrEmpty();
            
        if ($event->isEmpty()) {
            throw new CommonException('SPORT_EVENT_NOT_EXIST_OR_NO_PERMISSION');
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
            throw new CommonException('SPORT_ORGANIZER_NOT_EXIST_OR_NO_PERMISSION');
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
            throw new CommonException('SPORT_SERIES_NOT_EXIST_OR_NO_PERMISSION');
        }
    }

    /**
     * 获取我的赛事列表
     * @param array $data
     * @return array
     */
    public function getMyList(array $data = [])
    {
        // 调试：记录服务层接收的参数
        \think\facade\Log::info('EventService MyList Debug: input_data=' . json_encode($data) . ', member_id=' . $this->member_id);
        
        $field = 'se.id, se.series_id, se.name, se.event_type, se.year, se.season, se.start_time, se.end_time, se.location, se.location_detail, se.latitude, se.longitude, se.organizer_id, se.organizer_type, se.member_id, se.status, se.remark, se.create_time, se.update_time';
        $order = 'se.id desc';

        $where = [
            ['se.member_id', '=', $this->member_id]  // 直接根据member_id查询当前用户的赛事
        ];

        // 状态筛选 - 修复empty("0")问题  
        if (isset($data['status']) && $data['status'] !== '' && is_numeric($data['status'])) {
            $status_value = (int)$data['status'];
            $where[] = ['se.status', '=', $status_value];
            \think\facade\Log::info('Status Filter Applied: original=' . $data['status'] . ', converted=' . $status_value . ', where=' . json_encode($where));
        } else {
            \think\facade\Log::info('No Status Filter Applied: isset=' . (isset($data['status']) ? 'true' : 'false') . ', not_empty=' . (($data['status'] ?? '') !== '' ? 'true' : 'false') . ', is_numeric=' . (is_numeric($data['status'] ?? '') ? 'true' : 'false') . ', value=' . ($data['status'] ?? 'not_set'));
        }

        $search_model = $this->model
            ->alias('se')
            ->leftJoin('sport_organizer so', 'se.organizer_id = so.id')
            ->leftJoin('sport_event_series ses', 'se.series_id = ses.id')
            ->where($where)
            ->field($field . ', so.organizer_name, ses.name as series_name')
            ->order($order)
            ->append(['start_time_text', 'end_time_text', 'event_type_text', 'organizer_type_text', 'status_text']);

        $list = $this->pageQuery($search_model);
        
        // 获取状态统计
        $status_count = $this->getStatusCount();
        $list['status_count'] = $status_count;
        
        return $list;
    }

    /**
     * 获取状态统计
     * @return array
     */
    private function getStatusCount()
    {
        $result = [
            'total' => 0,
            '0' => 0,  // 待发布
            '1' => 0,  // 进行中
            '2' => 0,  // 已结束
            '3' => 0   // 已作废
        ];
        
        // 分别查询各个状态的数量
        $total = $this->model
            ->where([['member_id', '=', $this->member_id]])
            ->count();
            
        $status0 = $this->model
            ->where([
                ['member_id', '=', $this->member_id],
                ['status', '=', 0]
            ])
            ->count();
            
        $status1 = $this->model
            ->where([
                ['member_id', '=', $this->member_id],
                ['status', '=', 1]
            ])
            ->count();
            
        $status2 = $this->model
            ->where([
                ['member_id', '=', $this->member_id],
                ['status', '=', 2]
            ])
            ->count();
            
        $status3 = $this->model
            ->where([
                ['member_id', '=', $this->member_id],
                ['status', '=', 3]
            ])
            ->count();
        
        $result = [
            'total' => $total,
            '0' => $status0,
            '1' => $status1,
            '2' => $status2,
            '3' => $status3
        ];
        
        return $result;
    }

    /**
     * 更新赛事状态
     * @param int $id
     * @param int $status
     * @return bool
     */
    public function updateStatus(int $id, int $status)
    {
        // 验证赛事是否存在且属于当前用户
        $this->checkEventPermission($id);
        
        // 验证状态值
        if (!in_array($status, [0, 1, 2, 3])) {
            throw new CommonException('INVALID_STATUS');
        }
        
        $this->model->where([['id', '=', $id]])->update([
            'status' => $status,
            'update_time' => time()
        ]);
        
        return true;
    }

    /**
     * 保存赛事自定义分组
     * @param int $event_id
     * @param array $groups
     * @return void
     */
    private function saveEventGroups(int $event_id, array $groups)
    {
        $group_model = new SportEventGroup();
        
        foreach ($groups as $index => $group) {
            if (empty($group['group_name'])) {
                continue;
            }
            
            $group_data = [
                'event_id' => $event_id,
                'group_name' => $group['group_name'],
                'group_type' => $group['group_type'] ?? 'custom',
                'description' => $group['description'] ?? '',
                'sort' => $group['sort'] ?? $index,
                'status' => 1,
                'create_time' => time(),
                'update_time' => time()
            ];
            
            $group_model->save($group_data);
            $group_model = new SportEventGroup(); // 重新实例化
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
            $base_item = \addon\sport\app\model\item\SportBaseItem::where('id', $base_item_id)->find();
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
     * 获取赛事自定义分组
     * @param int $event_id
     * @return array
     */
    public function getEventGroups(int $event_id)
    {
        $group_model = new SportEventGroup();
        return $group_model
            ->where([
                ['event_id', '=', $event_id],
                ['status', '=', 1]
            ])
            ->order('sort asc, id asc')
            ->select()
            ->toArray();
    }

    /**
     * 获取赛事比赛项目
     * @param int $event_id
     * @return array
     */
    public function getEventItems(int $event_id)
    {
        $item_model = new SportItem();
        return $item_model
            ->where([
                ['event_id', '=', $event_id],
                ['status', '=', 1]
            ])
            ->order('sort asc, id asc')
            ->select()
            ->toArray();
    }
    
    /**
     * 更新赛事设置
     * @param int $id
     * @param array $data
     * @return void
     */
    public function updateSettings(int $id, array $data)
    {
        // 验证权限
        $this->checkEventPermission($id);
        
        // 验证数据
        if (isset($data['registration_start_time']) && isset($data['registration_end_time'])) {
            if (!empty($data['registration_start_time']) && !empty($data['registration_end_time'])) {
                if (strtotime($data['registration_start_time']) >= strtotime($data['registration_end_time'])) {
                    throw new CommonException('报名开始时间不能晚于结束时间');
                }
            }
        }
        
        if (isset($data['registration_fee']) && $data['registration_fee'] < 0) {
            throw new CommonException('报名费不能为负数');
        }
        
        if (isset($data['max_participants']) && $data['max_participants'] < 0) {
            throw new CommonException('报名人数限制不能为负数');
        }
        
        // 更新数据
        $update_data = [
            'status' => $data['status'] ?? 0,
            'sort' => $data['sort'] ?? 0,
            'registration_start_time' => $data['registration_start_time'] ?? '',
            'registration_end_time' => $data['registration_end_time'] ?? '',
            'registration_fee' => $data['registration_fee'] ?? 0,
            'max_participants' => $data['max_participants'] ?? 0,
            'group_size' => $data['group_size'] ?? 0,
            'rounds' => $data['rounds'] ?? 0,
            'allow_duplicate_registration' => $data['allow_duplicate_registration'] ?? 0,
            'age_group_display' => $data['age_group_display'] ?? 0,
            'show_participant_count' => $data['show_participant_count'] ?? 1,
            'show_progress' => $data['show_progress'] ?? 1,
            'remark' => $data['remark'] ?? '',
            'update_time' => time()
        ];
        
        $this->model->where('id', $id)->update($update_data);
    }
} 