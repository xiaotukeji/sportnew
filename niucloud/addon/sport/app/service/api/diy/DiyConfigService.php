<?php

namespace addon\sport\app\service\api\diy;

use addon\sport\app\model\diy_config\SportEventDiyConfig;
use addon\sport\app\model\event\SportEvent;
use core\exception\CommonException;

/**
 * DIY配置服务类
 * Class DiyConfigService
 * @package addon\sport\app\service\api\diy
 */
class DiyConfigService
{
    /**
     * 当前用户ID
     * @var int
     */
    protected $member_id;

    /**
     * 构造函数
     * @param int $member_id
     */
    public function __construct($member_id = 0)
    {
        $this->member_id = $member_id;
    }

    /**
     * 获取赛事的DIY配置
     * @param int $eventId
     * @return array
     * @throws CommonException
     */
    public function getEventDiyConfig($eventId)
    {
        // 验证赛事权限
        $this->checkEventPermission($eventId);

        $diyConfigModel = new SportEventDiyConfig();
        $config = $diyConfigModel->getEventDiyConfig($eventId);

        return [
            'event_id' => $eventId,
            'config' => $config
        ];
    }

    /**
     * 保存赛事的DIY配置
     * @param int $eventId
     * @param array $configData
     * @return bool
     * @throws CommonException
     */
    public function saveEventDiyConfig($eventId, $configData)
    {
        // 验证赛事权限
        $this->checkEventPermission($eventId);

        // 验证配置数据格式
        $this->validateConfigData($configData);

        $diyConfigModel = new SportEventDiyConfig();
        $result = $diyConfigModel->saveEventDiyConfig($eventId, $configData);

        if (!$result) {
            throw new CommonException('保存DIY配置失败');
        }

        return true;
    }

    /**
     * 更新赛事的DIY配置
     * @param int $eventId
     * @param array $configData
     * @return bool
     * @throws CommonException
     */
    public function updateEventDiyConfig($eventId, $configData)
    {
        return $this->saveEventDiyConfig($eventId, $configData);
    }

    /**
     * 删除赛事的DIY配置
     * @param int $eventId
     * @return bool
     * @throws CommonException
     */
    public function deleteEventDiyConfig($eventId)
    {
        // 验证赛事权限
        $this->checkEventPermission($eventId);

        $diyConfigModel = new SportEventDiyConfig();
        $result = $diyConfigModel->where('event_id', $eventId)->delete();

        if (!$result) {
            throw new CommonException('删除DIY配置失败');
        }

        return true;
    }

    /**
     * 重置为默认配置
     * @param int $eventId
     * @return bool
     * @throws CommonException
     */
    public function resetToDefaultConfig($eventId)
    {
        // 验证赛事权限
        $this->checkEventPermission($eventId);

        $diyConfigModel = new SportEventDiyConfig();
        $defaultConfig = $diyConfigModel->getDefaultConfig();
        
        $result = $diyConfigModel->saveEventDiyConfig($eventId, $defaultConfig);

        if (!$result) {
            throw new CommonException('重置配置失败');
        }

        return true;
    }

    /**
     * 获取可用的模块配置
     * @return array
     */
    public function getAvailableModules()
    {
        return [
            [
                'key' => 'banner',
                'name' => 'Banner轮播图',
                'icon' => '🖼️',
                'description' => '展示赛事宣传图片，支持多图轮播',
                'preview' => 'banner-preview.png'
            ],
            [
                'key' => 'basicInfo',
                'name' => '基本信息',
                'icon' => '📋',
                'description' => '展示赛事基本信息和组织方信息',
                'preview' => 'basic-info-preview.png'
            ],
            [
                'key' => 'projects',
                'name' => '比赛项目',
                'icon' => '🏆',
                'description' => '展示赛事项目和报名信息',
                'preview' => 'projects-preview.png'
            ],
            [
                'key' => 'detailContent',
                'name' => '详情内容',
                'icon' => '📄',
                'description' => '展示赛事详细说明和规则',
                'preview' => 'detail-content-preview.png'
            ],
            [
                'key' => 'signupAction',
                'name' => '报名操作',
                'icon' => '📝',
                'description' => '报名状态和操作按钮',
                'preview' => 'signup-action-preview.png'
            ]
        ];
    }

    /**
     * 验证赛事权限
     * @param int $eventId
     * @throws CommonException
     */
    private function checkEventPermission($eventId)
    {
        $eventModel = new SportEvent();
        $event = $eventModel->where('id', $eventId)
            ->where('member_id', $this->member_id)
            ->findOrEmpty();

        if ($event->isEmpty()) {
            throw new CommonException('赛事不存在或无权限操作');
        }
    }

    /**
     * 验证配置数据格式
     * @param array $configData
     * @throws CommonException
     */
    private function validateConfigData($configData)
    {
        if (!is_array($configData)) {
            throw new CommonException('配置数据格式错误');
        }

        // 验证必需字段
        $requiredFields = ['modules', 'global'];
        foreach ($requiredFields as $field) {
            if (!isset($configData[$field])) {
                throw new CommonException("配置数据缺少必需字段: {$field}");
            }
        }

        // 验证模块配置
        if (!is_array($configData['modules'])) {
            throw new CommonException('模块配置格式错误');
        }

        // 验证全局配置
        if (!is_array($configData['global'])) {
            throw new CommonException('全局配置格式错误');
        }
    }
}
