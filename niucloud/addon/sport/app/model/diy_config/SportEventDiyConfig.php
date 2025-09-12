<?php

namespace addon\sport\app\model\diy_config;

use core\base\BaseModel;

/**
 * 赛事DIY配置模型
 * Class SportEventDiyConfig
 * @package addon\sport\app\model\diy_config
 */
class SportEventDiyConfig extends BaseModel
{
    /**
     * 数据表主键
     * @var string
     */
    protected $pk = 'id';

    /**
     * 模型名称
     * @var string
     */
    protected $name = 'sport_event_diy_config';

    /**
     * 自动时间戳
     * @var bool
     */
    protected $autoWriteTimestamp = true;

    /**
     * 时间戳字段名
     * @var string
     */
    protected $createTime = 'create_time';
    protected $updateTime = 'update_time';

    /**
     * 配置数据获取器
     * @param $value
     * @return array
     */
    public function getConfigDataAttr($value)
    {
        return $value ? json_decode($value, true) : [];
    }

    /**
     * 配置数据修改器
     * @param $value
     * @return string
     */
    public function setConfigDataAttr($value)
    {
        return is_array($value) ? json_encode($value, JSON_UNESCAPED_UNICODE) : $value;
    }

    /**
     * 关联赛事
     * @return \think\model\relation\BelongsTo
     */
    public function event()
    {
        return $this->belongsTo('addon\sport\app\model\event\SportEvent', 'event_id', 'id');
    }

    /**
     * 获取赛事的DIY配置
     * @param int $eventId
     * @return array
     */
    public function getEventDiyConfig($eventId)
    {
        $config = $this->where('event_id', $eventId)
            ->where('status', 1)
            ->find();

        if (!$config) {
            // 返回默认配置
            return $this->getDefaultConfig();
        }

        return $config->config_data;
    }

    /**
     * 保存赛事的DIY配置
     * @param int $eventId
     * @param array $configData
     * @return bool
     */
    public function saveEventDiyConfig($eventId, $configData)
    {
        $existing = $this->where('event_id', $eventId)->find();
        
        if ($existing) {
            return $existing->save([
                'config_data' => $configData,
                'update_time' => time()
            ]);
        } else {
            return $this->save([
                'event_id' => $eventId,
                'config_data' => $configData,
                'status' => 1,
                'create_time' => time(),
                'update_time' => time()
            ]);
        }
    }

    /**
     * 获取默认配置
     * @return array
     */
    private function getDefaultConfig()
    {
        return [
            'modules' => [
                'banner' => [
                    'enabled' => true,
                    'order' => 1,
                    'properties' => [
                        'images' => [],
                        'height' => 400,
                        'autoplay' => true,
                        'indicator' => true,
                        'interval' => 3000
                    ]
                ],
                'basicInfo' => [
                    'enabled' => true,
                    'order' => 2,
                    'properties' => [
                        'showEventName' => true,
                        'showTimeLocation' => true,
                        'showOrganizer' => true,
                        'showCoOrganizer' => true,
                        'showSeries' => true,
                        'showCategory' => true,
                        'showAgeGroups' => true,
                        'showCustomGroups' => true,
                        'showContactInfo' => true,
                        'layout' => 'vertical',
                        'cardStyle' => 'default'
                    ]
                ],
                'projects' => [
                    'enabled' => true,
                    'order' => 3,
                    'properties' => [
                        'showProjectDetails' => true,
                        'showRegistrationFee' => true,
                        'showParticipantCount' => true,
                        'showAgeGroup' => true,
                        'showGenderLimit' => true,
                        'showVenue' => true,
                        'layout' => 'list',
                        'maxDisplay' => 10
                    ]
                ],
                'detailContent' => [
                    'enabled' => true,
                    'order' => 4,
                    'properties' => [
                        'content' => '',
                        'showRichText' => true,
                        'showImages' => true,
                        'maxHeight' => 500,
                        'showExpand' => true
                    ]
                ],
                'signupAction' => [
                    'enabled' => true,
                    'order' => 5,
                    'properties' => [
                        'showRegistrationStatus' => true,
                        'showRegistrationTime' => true,
                        'showParticipantCount' => true,
                        'buttonText' => '立即报名',
                        'buttonStyle' => 'primary',
                        'buttonSize' => 'large',
                        'showProgress' => true
                    ]
                ]
            ],
            'global' => [
                'theme' => 'light',
                'primaryColor' => '#409EFF',
                'backgroundColor' => '#FFFFFF',
                'borderRadius' => 8,
                'spacing' => 16
            ]
        ];
    }
}
