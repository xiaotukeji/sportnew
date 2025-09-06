<?php

namespace addon\sport\app\service\api\co_organizer;

use addon\sport\app\model\co_organizer\SportEventCoOrganizer;
use core\exception\CommonException;
use core\base\BaseService;

/**
 * 协办单位服务层
 * Class CoOrganizerService
 * @package addon\sport\app\service\api\co_organizer
 */
class CoOrganizerService extends BaseService
{
    /**
     * 获取赛事协办单位列表
     * @param int $eventId 赛事ID
     * @return array
     */
    public function getCoOrganizerList($eventId)
    {
        if (empty($eventId)) {
            throw new CommonException('赛事ID不能为空');
        }

        $list = SportEventCoOrganizer::where('event_id', $eventId)
            ->where('status', 1)
            ->order('sort', 'asc')
            ->order('id', 'asc')
            ->select()
            ->toArray();

        return $list;
    }

    /**
     * 添加协办单位
     * @param array $data 协办单位数据
     * @return int 协办单位ID
     */
    public function addCoOrganizer($data)
    {
        // 验证必填字段
        $this->validateCoOrganizerData($data);

        // 设置默认值
        $data['status'] = $data['status'] ?? 1;
        $data['sort'] = $data['sort'] ?? 0;
        $data['organizer_type'] = $data['organizer_type'] ?? 1;

        $coOrganizer = new SportEventCoOrganizer();
        $result = $coOrganizer->save($data);

        if (!$result) {
            throw new CommonException('添加协办单位失败');
        }

        return $coOrganizer->id;
    }

    /**
     * 更新协办单位
     * @param int $id 协办单位ID
     * @param array $data 更新数据
     * @return bool
     */
    public function updateCoOrganizer($id, $data)
    {
        if (empty($id)) {
            throw new CommonException('协办单位ID不能为空');
        }

        $coOrganizer = SportEventCoOrganizer::find($id);
        if (!$coOrganizer) {
            throw new CommonException('协办单位不存在');
        }

        // 验证数据
        if (isset($data['organizer_name'])) {
            $this->validateCoOrganizerData($data);
        }

        $result = $coOrganizer->save($data);

        if (!$result) {
            throw new CommonException('更新协办单位失败');
        }

        return true;
    }

    /**
     * 删除协办单位
     * @param int $id 协办单位ID
     * @return bool
     */
    public function deleteCoOrganizer($id)
    {
        if (empty($id)) {
            throw new CommonException('协办单位ID不能为空');
        }

        $coOrganizer = SportEventCoOrganizer::find($id);
        if (!$coOrganizer) {
            throw new CommonException('协办单位不存在');
        }

        $result = $coOrganizer->delete();

        if (!$result) {
            throw new CommonException('删除协办单位失败');
        }

        return true;
    }

    /**
     * 批量删除协办单位
     * @param array $ids 协办单位ID数组
     * @return bool
     */
    public function batchDeleteCoOrganizers($ids)
    {
        if (empty($ids) || !is_array($ids)) {
            throw new CommonException('协办单位ID不能为空');
        }

        $result = SportEventCoOrganizer::whereIn('id', $ids)->delete();

        if (!$result) {
            throw new CommonException('批量删除协办单位失败');
        }

        return true;
    }

    /**
     * 获取协办单位详情
     * @param int $id 协办单位ID
     * @return array
     */
    public function getCoOrganizerInfo($id)
    {
        if (empty($id)) {
            throw new CommonException('协办单位ID不能为空');
        }

        $coOrganizer = SportEventCoOrganizer::find($id);
        if (!$coOrganizer) {
            throw new CommonException('协办单位不存在');
        }

        return $coOrganizer->toArray();
    }

    /**
     * 验证协办单位数据
     * @param array $data 数据
     * @throws CommonException
     */
    private function validateCoOrganizerData($data)
    {
        if (empty($data['event_id'])) {
            throw new CommonException('赛事ID不能为空');
        }

        if (empty($data['organizer_name'])) {
            throw new CommonException('单位名称不能为空');
        }

        if (mb_strlen($data['organizer_name']) > 100) {
            throw new CommonException('单位名称不能超过100个字符');
        }

        if (isset($data['contact_name']) && mb_strlen($data['contact_name']) > 50) {
            throw new CommonException('联系人姓名不能超过50个字符');
        }

        if (isset($data['contact_phone']) && mb_strlen($data['contact_phone']) > 20) {
            throw new CommonException('联系电话不能超过20个字符');
        }

        if (isset($data['remark']) && mb_strlen($data['remark']) > 255) {
            throw new CommonException('备注不能超过255个字符');
        }

        if (isset($data['organizer_type']) && !in_array($data['organizer_type'], [1, 2, 3])) {
            throw new CommonException('单位类型无效');
        }
    }

    /**
     * 更新协办单位排序
     * @param array $sortData 排序数据 [['id' => 1, 'sort' => 10], ...]
     * @return bool
     */
    public function updateCoOrganizerSort($sortData)
    {
        if (empty($sortData) || !is_array($sortData)) {
            throw new CommonException('排序数据不能为空');
        }

        $coOrganizer = new SportEventCoOrganizer();
        
        foreach ($sortData as $item) {
            if (isset($item['id']) && isset($item['sort'])) {
                $coOrganizer->where('id', $item['id'])->update(['sort' => $item['sort']]);
            }
        }

        return true;
    }
}
