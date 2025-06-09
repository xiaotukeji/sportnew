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

namespace addon\sport\app\service\api\organizer;

use addon\sport\app\model\organizer\SportOrganizer;
use core\base\BaseApiService;
use core\exception\CommonException;

/**
 * 主办方服务层
 * Class OrganizerService
 * @package addon\sport\app\service\api\organizer
 */
class OrganizerService extends BaseApiService
{
    public function __construct()
    {
        parent::__construct();
        $this->model = new SportOrganizer();
    }

    /**
     * 获取用户主办方列表
     * @param array $data
     * @return array
     */
    public function getList(array $data = [])
    {
        $field = 'id, organizer_name, organizer_type, contact_name, contact_phone, status, create_time';
        
        $where = [
            ['member_id', '=', $this->member_id],
            ['status', '=', 1]
        ];
        
        if (!empty($data['organizer_type'])) {
            $where[] = ['organizer_type', '=', $data['organizer_type']];
        }
        
        if (!empty($data['organizer_name'])) {
            $where[] = ['organizer_name', 'like', '%' . $data['organizer_name'] . '%'];
        }
        
        $list = $this->model
            ->where($where)
            ->field($field)
            ->order('create_time desc')
            ->append(['organizer_type_text'])
            ->select()
            ->toArray();
            
        return $list;
    }

    /**
     * 获取主办方详情
     * @param int $id
     * @return array
     */
    public function getInfo(int $id)
    {
        $field = 'id, organizer_name, organizer_type, organizer_license, contact_name, contact_phone, sort, status, remark, create_time, update_time';
        
        $info = $this->model
            ->where([
                ['id', '=', $id],
                ['member_id', '=', $this->member_id]
            ])
            ->field($field)
            ->append(['organizer_type_text'])
            ->findOrEmpty()
            ->toArray();
            
        if (empty($info)) {
            throw new CommonException('SPORT_ORGANIZER_NOT_EXIST');
        }
        
        return $info;
    }

    /**
     * 添加主办方
     * @param array $data
     * @return mixed
     */
    public function add(array $data)
    {
        // 检查同一用户下的主办方名称是否重复
        $exists = $this->model
            ->where([
                ['member_id', '=', $this->member_id],
                ['organizer_name', '=', $data['organizer_name']],
                ['organizer_type', '=', $data['organizer_type']]
            ])
            ->findOrEmpty();
            
        if (!$exists->isEmpty()) {
            throw new CommonException('SPORT_ORGANIZER_NAME_EXISTS');
        }
        
        $data['member_id'] = $this->member_id;
        $data['organizer_id'] = $this->member_id; // 设置organizer_id为当前用户ID
        $data['create_time'] = time();
        $data['update_time'] = time();
        $data['status'] = 1;
        $data['sort'] = 0;
        
        $res = $this->model->save($data);
        return $this->model->id;
    }

    /**
     * 编辑主办方
     * @param int $id
     * @param array $data
     * @return bool
     */
    public function edit(int $id, array $data)
    {
        // 验证主办方是否存在且属于当前用户
        $this->checkPermission($id);
        
        // 检查同一用户下的主办方名称是否重复（排除当前记录）
        $exists = $this->model
            ->where([
                ['member_id', '=', $this->member_id],
                ['organizer_name', '=', $data['organizer_name']],
                ['organizer_type', '=', $data['organizer_type']],
                ['id', '<>', $id]
            ])
            ->findOrEmpty();
            
        if (!$exists->isEmpty()) {
            throw new CommonException('SPORT_ORGANIZER_NAME_EXISTS');
        }
        
        $data['update_time'] = time();
        
        $this->model->where([['id', '=', $id]])->update($data);
        return true;
    }

    /**
     * 删除主办方
     * @param int $id
     * @return bool
     */
    public function del(int $id)
    {
        // 验证主办方是否存在且属于当前用户
        $this->checkPermission($id);
        
        // 检查主办方是否被赛事使用
        $eventCount = (new \addon\sport\app\model\event\SportEvent())
            ->where('organizer_id', $id)
            ->count();
            
        if ($eventCount > 0) {
            throw new CommonException('SPORT_ORGANIZER_HAS_EVENTS');
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
            throw new CommonException('SPORT_ORGANIZER_NOT_EXIST_OR_NO_PERMISSION');
        }
    }
} 