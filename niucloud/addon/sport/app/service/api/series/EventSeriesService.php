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

namespace addon\sport\app\service\api\series;

use addon\sport\app\model\series\SportEventSeries;
use core\base\BaseApiService;
use core\exception\CommonException;

/**
 * 系列赛服务层
 * Class EventSeriesService
 * @package addon\sport\app\service\api\series
 */
class EventSeriesService extends BaseApiService
{
    public function __construct()
    {
        parent::__construct();
        $this->model = new SportEventSeries();
    }

    /**
     * 获取用户系列赛列表
     * @param array $data
     * @return array
     */
    public function getList(array $data = [])
    {
        $field = 'id, name, start_year, end_year, description, status, create_time';
        
        $where = [
            ['member_id', '=', $this->member_id],
            ['status', '=', 1]
        ];
        
        if (!empty($data['name'])) {
            $where[] = ['name', 'like', '%' . $data['name'] . '%'];
        }
        
        if (!empty($data['year'])) {
            $where[] = ['start_year', '<=', $data['year']];
            $where[] = function($query) use ($data) {
                $query->whereNull('end_year')
                      ->whereOr('end_year', '>=', $data['year']);
            };
        }
        
        $list = $this->model
            ->where($where)
            ->field($field)
            ->order('create_time desc')
            ->append(['year_range_text'])
            ->select()
            ->toArray();
            
        return $list;
    }

    /**
     * 获取系列赛详情
     * @param int $id
     * @return array
     */
    public function getInfo(int $id)
    {
        $field = 'id, name, start_year, end_year, description, sort, status, remark, create_time, update_time';
        
        $info = $this->model
            ->where([
                ['id', '=', $id],
                ['member_id', '=', $this->member_id]
            ])
            ->field($field)
            ->append(['year_range_text'])
            ->findOrEmpty()
            ->toArray();
            
        if (empty($info)) {
            throw new CommonException('SPORT_SERIES_NOT_EXIST');
        }
        
        return $info;
    }

    /**
     * 添加系列赛
     * @param array $data
     * @return mixed
     */
    public function add(array $data)
    {
        // 检查同一用户下的系列赛名称是否重复
        $exists = $this->model
            ->where([
                ['member_id', '=', $this->member_id],
                ['name', '=', $data['name']]
            ])
            ->findOrEmpty();
            
        if (!$exists->isEmpty()) {
            throw new CommonException('SPORT_SERIES_NAME_EXISTS');
        }
        
        // 验证年份逻辑
        if (!empty($data['end_year']) && $data['end_year'] < $data['start_year']) {
            throw new CommonException('SPORT_SERIES_END_YEAR_ERROR');
        }
        
        $data['member_id'] = $this->member_id;
        $data['organizer_id'] = $this->member_id; // 设置organizer_id为当前用户ID
        $data['create_time'] = time();
        $data['update_time'] = time();
        $data['status'] = 1;
        $data['sort'] = 0;
        
        // 如果没有设置结束年份，设为null表示至今
        if (empty($data['end_year'])) {
            $data['end_year'] = null;
        }
        
        $res = $this->model->save($data);
        return $this->model->id;
    }

    /**
     * 编辑系列赛
     * @param int $id
     * @param array $data
     * @return bool
     */
    public function edit(int $id, array $data)
    {
        // 验证系列赛是否存在且属于当前用户
        $this->checkPermission($id);
        
        // 检查同一用户下的系列赛名称是否重复（排除当前记录）
        $exists = $this->model
            ->where([
                ['member_id', '=', $this->member_id],
                ['name', '=', $data['name']],
                ['id', '<>', $id]
            ])
            ->findOrEmpty();
            
        if (!$exists->isEmpty()) {
            throw new CommonException('SPORT_SERIES_NAME_EXISTS');
        }
        
        // 验证年份逻辑
        if (!empty($data['end_year']) && $data['end_year'] < $data['start_year']) {
            throw new CommonException('SPORT_SERIES_END_YEAR_ERROR');
        }
        
        $data['update_time'] = time();
        
        // 如果没有设置结束年份，设为null表示至今
        if (empty($data['end_year'])) {
            $data['end_year'] = null;
        }
        
        $this->model->where([['id', '=', $id]])->update($data);
        return true;
    }

    /**
     * 删除系列赛
     * @param int $id
     * @return bool
     */
    public function del(int $id)
    {
        // 验证系列赛是否存在且属于当前用户
        $this->checkPermission($id);
        
        // 检查系列赛是否被赛事使用
        $eventCount = (new \addon\sport\app\model\event\SportEvent())
            ->where('series_id', $id)
            ->count();
            
        if ($eventCount > 0) {
            throw new CommonException('SPORT_SERIES_HAS_EVENTS');
        }
        
        $this->model->where([['id', '=', $id]])->delete();
        return true;
    }

    /**
     * 验证权限
     * @param int $id
     * @return void
     * @throws CommonException
     */
    private function checkPermission(int $id)
    {
        $info = $this->model
            ->where([
                ['id', '=', $id],
                ['member_id', '=', $this->member_id]
            ])
            ->findOrEmpty();
            
        if ($info->isEmpty()) {
            throw new CommonException('SPORT_SERIES_NOT_EXIST_OR_NO_PERMISSION');
        }
    }
} 