<?php

namespace addon\sport\app\api\controller\co_organizer;

use addon\sport\app\service\api\co_organizer\CoOrganizerService;
use core\base\BaseApiController;
use core\exception\CommonException;

/**
 * 协办单位控制器
 * Class CoOrganizer
 * @package addon\sport\app\api\controller\co_organizer
 */
class CoOrganizer extends BaseApiController
{
    /**
     * 协办单位服务
     * @var CoOrganizerService
     */
    protected $coOrganizerService;

    /**
     * 初始化
     */
    public function initialize()
    {
        parent::initialize();
        $this->coOrganizerService = new CoOrganizerService();
    }

    /**
     * 获取协办单位列表
     * @return \think\Response
     */
    public function index()
    {
        try {
            $data = $this->request->params([
                ['event_id', 0]
            ]);

            if (empty($data['event_id'])) {
                return $this->error('赛事ID不能为空');
            }

            $list = $this->coOrganizerService->getCoOrganizerList($data['event_id']);

            return $this->success('获取成功', $list);
        } catch (CommonException $e) {
            return $this->error($e->getMessage());
        } catch (\Exception $e) {
            return $this->error('获取协办单位列表失败');
        }
    }

    /**
     * 添加协办单位
     * @return \think\Response
     */
    public function add()
    {
        try {
            $data = $this->request->params([
                ['event_id', 0],
                ['organizer_type', 1],
                ['organizer_name', ''],
                ['logo', ''],
                ['contact_name', ''],
                ['contact_phone', ''],
                ['remark', ''],
                ['sort', 0],
                ['status', 1]
            ]);

            $id = $this->coOrganizerService->addCoOrganizer($data);

            return $this->success('添加成功', ['id' => $id]);
        } catch (CommonException $e) {
            return $this->error($e->getMessage());
        } catch (\Exception $e) {
            return $this->error('添加协办单位失败');
        }
    }

    /**
     * 更新协办单位
     * @return \think\Response
     */
    public function edit()
    {
        try {
            $data = $this->request->params([
                ['id', 0],
                ['organizer_type', 1],
                ['organizer_name', ''],
                ['logo', ''],
                ['contact_name', ''],
                ['contact_phone', ''],
                ['remark', ''],
                ['sort', 0],
                ['status', 1]
            ]);

            if (empty($data['id'])) {
                return $this->error('协办单位ID不能为空');
            }

            $this->coOrganizerService->updateCoOrganizer($data['id'], $data);

            return $this->success('更新成功');
        } catch (CommonException $e) {
            return $this->error($e->getMessage());
        } catch (\Exception $e) {
            return $this->error('更新协办单位失败');
        }
    }

    /**
     * 删除协办单位
     * @return \think\Response
     */
    public function delete()
    {
        try {
            $data = $this->request->params([
                ['id', 0]
            ]);

            if (empty($data['id'])) {
                return $this->error('协办单位ID不能为空');
            }

            $this->coOrganizerService->deleteCoOrganizer($data['id']);

            return $this->success('删除成功');
        } catch (CommonException $e) {
            return $this->error($e->getMessage());
        } catch (\Exception $e) {
            return $this->error('删除协办单位失败');
        }
    }

    /**
     * 批量删除协办单位
     * @return \think\Response
     */
    public function batchDelete()
    {
        try {
            $data = $this->request->params([
                ['ids', []]
            ]);

            if (empty($data['ids']) || !is_array($data['ids'])) {
                return $this->error('协办单位ID不能为空');
            }

            $this->coOrganizerService->batchDeleteCoOrganizers($data['ids']);

            return $this->success('批量删除成功');
        } catch (CommonException $e) {
            return $this->error($e->getMessage());
        } catch (\Exception $e) {
            return $this->error('批量删除协办单位失败');
        }
    }

    /**
     * 获取协办单位详情
     * @return \think\Response
     */
    public function info()
    {
        try {
            $data = $this->request->params([
                ['id', 0]
            ]);

            if (empty($data['id'])) {
                return $this->error('协办单位ID不能为空');
            }

            $info = $this->coOrganizerService->getCoOrganizerInfo($data['id']);

            return $this->success('获取成功', $info);
        } catch (CommonException $e) {
            return $this->error($e->getMessage());
        } catch (\Exception $e) {
            return $this->error('获取协办单位详情失败');
        }
    }

    /**
     * 更新协办单位排序
     * @return \think\Response
     */
    public function updateSort()
    {
        try {
            $data = $this->request->params([
                ['sort_data', []]
            ]);

            if (empty($data['sort_data']) || !is_array($data['sort_data'])) {
                return $this->error('排序数据不能为空');
            }

            $this->coOrganizerService->updateCoOrganizerSort($data['sort_data']);

            return $this->success('排序更新成功');
        } catch (CommonException $e) {
            return $this->error($e->getMessage());
        } catch (\Exception $e) {
            return $this->error('更新排序失败');
        }
    }
}
