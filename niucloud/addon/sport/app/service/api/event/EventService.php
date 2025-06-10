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
        $field = 'id, series_id, name, event_type, year, season, start_time, end_time, location, organizer_id, organizer_type, sort, status, remark, create_time, update_time';
        
        $info = $this->model
            ->where([['id', '=', $id]])
            ->withJoin(['organizer' => ['organizer_name', 'contact_name', 'contact_phone']])
            ->withJoin(['series' => ['name as series_name']], 'LEFT')
            ->field($field)
            ->append(['start_time_text', 'end_time_text', 'event_type_text', 'organizer_type_text'])
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
        
        $data['create_time'] = time();
        $data['update_time'] = time();
        $data['status'] = 0;  // 默认状态为待发布
        $data['sort'] = 0;
        $data['member_id'] = $this->member_id;  // 设置发布者ID
        
        $res = $this->model->save($data);
        return $this->model->id;
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
        \think\facade\Log::info('EventService MyList Debug:', [
            'input_data' => $data,
            'member_id' => $this->member_id
        ]);
        
        $field = 'se.id, se.series_id, se.name, se.event_type, se.year, se.season, se.start_time, se.end_time, se.location, se.location_detail, se.latitude, se.longitude, se.organizer_id, se.organizer_type, se.member_id, se.status, se.remark, se.create_time, se.update_time';
        $order = 'se.id desc';

        $where = [
            ['se.member_id', '=', $this->member_id]  // 直接根据member_id查询当前用户的赛事
        ];

        // 状态筛选 - 修复empty("0")问题  
        if (isset($data['status']) && $data['status'] !== '' && is_numeric($data['status'])) {
            $status_value = (int)$data['status'];
            $where[] = ['se.status', '=', $status_value];
            \think\facade\Log::info('Status Filter Applied:', [
                'original_status' => $data['status'],
                'converted_status' => $status_value,
                'where_conditions' => $where
            ]);
        } else {
            \think\facade\Log::info('No Status Filter Applied:', [
                'status_isset' => isset($data['status']),
                'status_not_empty' => $data['status'] !== '',
                'status_is_numeric' => is_numeric($data['status'] ?? ''),
                'status_value' => $data['status'] ?? 'not_set'
            ]);
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
} 