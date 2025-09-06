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

namespace addon\sport\app\service\api\co_organizer;

use addon\sport\app\model\co_organizer\SportEventCoOrganizer;
use addon\sport\app\model\event\SportEvent;
use core\base\BaseApiService;
use core\exception\CommonException;

/**
 * 协办单位服务层
 * Class CoOrganizerService
 * @package addon\sport\app\service\api\co_organizer
 */
class CoOrganizerService extends BaseApiService
{
    public function __construct()
    {
        parent::__construct();
        $this->model = new SportEventCoOrganizer();
    }

    /**
     * 获取赛事协办单位列表
     * @param int $event_id
     * @param array $data
     * @return array
     */
    public function getList(int $event_id, array $data = [])
    {
        // 验证赛事权限
        $this->checkEventPermission($event_id);
        
        $field = 'id, event_id, organizer_id, organizer_type, organizer_name, logo, contact_name, contact_phone, sort, status, remark, create_time';
        
        $where = [
            ['event_id', '=', $event_id]
        ];
        
        if (isset($data['organizer_type']) && $data['organizer_type'] !== '') {
            $where[] = ['organizer_type', '=', $data['organizer_type']];
        }
        
        if (!empty($data['organizer_name'])) {
            $where[] = ['organizer_name', 'like', '%' . $data['organizer_name'] . '%'];
        }
        
        if (isset($data['status']) && $data['status'] !== '') {
            $where[] = ['status', '=', $data['status']];
        }
        
        $list = $this->model
            ->where($where)
            ->field($field)
            ->order('sort asc, create_time desc')
            ->append(['organizer_type_text', 'status_text'])
            ->select()
            ->toArray();
            
        return $list;
    }

    /**
     * 获取协办单位详情
     * @param int $id
     * @return array
     */
    public function getInfo(int $id)
    {
        $field = 'id, event_id, organizer_id, organizer_type, organizer_name, logo, contact_name, contact_phone, sort, status, remark, create_time, update_time';
        
        $info = $this->model
            ->where('id', $id)
            ->field($field)
            ->append(['organizer_type_text', 'status_text'])
            ->findOrEmpty()
            ->toArray();
            
        if (empty($info)) {
            throw new CommonException('SPORT_CO_ORGANIZER_NOT_EXIST');
        }
        
        // 验证赛事权限
        $this->checkEventPermission($info['event_id']);
        
        return $info;
    }

    /**
     * 添加协办单位
     * @param array $data
     * @return mixed
     */
    public function add(array $data)
    {
        // 验证赛事权限
        $this->checkEventPermission($data['event_id']);
        
        // 检查同一赛事下的协办单位名称是否重复
        $exists = $this->model
            ->where([
                ['event_id', '=', $data['event_id']],
                ['organizer_name', '=', $data['organizer_name']]
            ])
            ->findOrEmpty();
            
        if (!$exists->isEmpty()) {
            throw new CommonException('SPORT_CO_ORGANIZER_NAME_EXISTS');
        }
        
        $data['create_time'] = time();
        $data['update_time'] = time();
        $data['status'] = $data['status'] ?? 1;
        $data['sort'] = $data['sort'] ?? 0;
        
        $res = $this->model->save($data);
        return $this->model->id;
    }

    /**
     * 编辑协办单位
     * @param int $id
     * @param array $data
     * @return bool
     */
    public function edit(int $id, array $data)
    {
        // 验证协办单位是否存在
        $info = $this->model->where('id', $id)->findOrEmpty();
        if ($info->isEmpty()) {
            throw new CommonException('SPORT_CO_ORGANIZER_NOT_EXIST');
        }
        
        // 验证赛事权限
        $this->checkEventPermission($info['event_id']);
        
        // 检查同一赛事下的协办单位名称是否重复（排除当前记录）
        $exists = $this->model
            ->where([
                ['event_id', '=', $info['event_id']],
                ['organizer_name', '=', $data['organizer_name']],
                ['id', '<>', $id]
            ])
            ->findOrEmpty();
            
        if (!$exists->isEmpty()) {
            throw new CommonException('SPORT_CO_ORGANIZER_NAME_EXISTS');
        }
        
        $data['update_time'] = time();
        
        $this->model->where('id', $id)->update($data);
        return true;
    }

    /**
     * 删除协办单位
     * @param int $id
     * @return bool
     */
    public function del(int $id)
    {
        // 验证协办单位是否存在
        $info = $this->model->where('id', $id)->findOrEmpty();
        if ($info->isEmpty()) {
            throw new CommonException('SPORT_CO_ORGANIZER_NOT_EXIST');
        }
        
        // 验证赛事权限
        $this->checkEventPermission($info['event_id']);
        
        $this->model->where('id', $id)->delete();
        return true;
    }

    /**
     * 批量添加协办单位
     * @param int $event_id
     * @param array $co_organizers
     * @return array
     */
    public function batchAdd(int $event_id, array $co_organizers)
    {
        // 验证赛事权限
        $this->checkEventPermission($event_id);
        
        $success_count = 0;
        $failed_list = [];
        
        foreach ($co_organizers as $index => $co_organizer) {
            try {
                $co_organizer['event_id'] = $event_id;
                $this->add($co_organizer);
                $success_count++;
            } catch (\Exception $e) {
                $failed_list[] = [
                    'index' => $index + 1,
                    'name' => $co_organizer['organizer_name'] ?? '未知',
                    'error' => $e->getMessage()
                ];
            }
        }
        
        return [
            'success_count' => $success_count,
            'failed_list' => $failed_list,
            'total' => count($co_organizers)
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
        $event = (new SportEvent())->where('id', $event_id)->findOrEmpty();
        if ($event->isEmpty()) {
            throw new CommonException('SPORT_EVENT_NOT_EXIST');
        }
        
        // 这里可以根据需要添加更详细的权限验证
        // 比如检查赛事是否属于当前用户等
    }
}
