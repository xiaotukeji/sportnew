<?php

namespace addon\sport\app\api\controller\diy;

use addon\sport\app\service\api\diy\DiyConfigService;
use app\BaseController;
use core\exception\CommonException;

/**
 * DIY配置控制器
 * Class DiyConfig
 * @package addon\sport\app\api\controller\diy
 */
class DiyConfig extends BaseController
{
    /**
     * 获取赛事的DIY配置
     * @return \think\Response
     */
    public function get()
    {
        try {
            $eventId = $this->request->param('event_id', 0, 'intval');
            
            if (!$eventId) {
                return $this->error('赛事ID不能为空');
            }

            $memberId = $this->request->uid ?? 0;
            $diyConfigService = new DiyConfigService($memberId);
            $result = $diyConfigService->getEventDiyConfig($eventId);

            return $this->success($result, '获取DIY配置成功');

        } catch (CommonException $e) {
            return $this->error($e->getMessage());
        } catch (\Exception $e) {
            return $this->error('系统错误: ' . $e->getMessage());
        }
    }

    /**
     * 保存赛事的DIY配置
     * @return \think\Response
     */
    public function save()
    {
        try {
            $data = $this->request->params([
                ['event_id', 0, 'intval'],
                ['config_data', '', 'trim']
            ]);

            if (!$data['event_id']) {
                return $this->error('赛事ID不能为空');
            }

            if (!$data['config_data']) {
                return $this->error('配置数据不能为空');
            }

            $configData = json_decode($data['config_data'], true);
            if (json_last_error() !== JSON_ERROR_NONE) {
                return $this->error('配置数据格式错误');
            }

            $memberId = $this->request->uid ?? 0;
            $diyConfigService = new DiyConfigService($memberId);
            $result = $diyConfigService->saveEventDiyConfig($data['event_id'], $configData);

            return $this->success($result, '保存DIY配置成功');

        } catch (CommonException $e) {
            return $this->error($e->getMessage());
        } catch (\Exception $e) {
            return $this->error('系统错误: ' . $e->getMessage());
        }
    }

    /**
     * 更新赛事的DIY配置
     * @return \think\Response
     */
    public function update()
    {
        try {
            $data = $this->request->params([
                ['event_id', 0, 'intval'],
                ['config_data', '', 'trim']
            ]);

            if (!$data['event_id']) {
                return $this->error('赛事ID不能为空');
            }

            if (!$data['config_data']) {
                return $this->error('配置数据不能为空');
            }

            $configData = json_decode($data['config_data'], true);
            if (json_last_error() !== JSON_ERROR_NONE) {
                return $this->error('配置数据格式错误');
            }

            $memberId = $this->request->uid ?? 0;
            $diyConfigService = new DiyConfigService($memberId);
            $result = $diyConfigService->updateEventDiyConfig($data['event_id'], $configData);

            return $this->success($result, '更新DIY配置成功');

        } catch (CommonException $e) {
            return $this->error($e->getMessage());
        } catch (\Exception $e) {
            return $this->error('系统错误: ' . $e->getMessage());
        }
    }

    /**
     * 删除赛事的DIY配置
     * @return \think\Response
     */
    public function delete()
    {
        try {
            $eventId = $this->request->param('event_id', 0, 'intval');
            
            if (!$eventId) {
                return $this->error('赛事ID不能为空');
            }

            $memberId = $this->request->uid ?? 0;
            $diyConfigService = new DiyConfigService($memberId);
            $result = $diyConfigService->deleteEventDiyConfig($eventId);

            return $this->success($result, '删除DIY配置成功');

        } catch (CommonException $e) {
            return $this->error($e->getMessage());
        } catch (\Exception $e) {
            return $this->error('系统错误: ' . $e->getMessage());
        }
    }

    /**
     * 重置为默认配置
     * @return \think\Response
     */
    public function reset()
    {
        try {
            $eventId = $this->request->param('event_id', 0, 'intval');
            
            if (!$eventId) {
                return $this->error('赛事ID不能为空');
            }

            $memberId = $this->request->uid ?? 0;
            $diyConfigService = new DiyConfigService($memberId);
            $result = $diyConfigService->resetToDefaultConfig($eventId);

            return $this->success($result, '重置配置成功');

        } catch (CommonException $e) {
            return $this->error($e->getMessage());
        } catch (\Exception $e) {
            return $this->error('系统错误: ' . $e->getMessage());
        }
    }

    /**
     * 获取可用的模块配置
     * @return \think\Response
     */
    public function getAvailableModules()
    {
        try {
            $memberId = $this->request->uid ?? 0;
            $diyConfigService = new DiyConfigService($memberId);
            $result = $diyConfigService->getAvailableModules();

            return $this->success($result, '获取可用模块成功');

        } catch (CommonException $e) {
            return $this->error($e->getMessage());
        } catch (\Exception $e) {
            return $this->error('系统错误: ' . $e->getMessage());
        }
    }
}
