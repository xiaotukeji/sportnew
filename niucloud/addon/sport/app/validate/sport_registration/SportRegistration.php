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

namespace addon\sport\app\validate\sport_registration;
use core\base\BaseValidate;
/**
 * 报名记录验证器
 * Class SportRegistration
 * @package addon\sport\app\validate\sport_registration
 */
class SportRegistration extends BaseValidate
{

       protected $rule = [
            'event_id' => 'require',
            'item_id' => 'require',
            'athlete_id' => 'require',
            'team_id' => 'require',
            'registration_type' => 'require',
            'registration_time' => 'require',
            'status' => 'require',
            'payment_status' => 'require',
            'sort' => 'require'
        ];

       protected $message = [
            'event_id.require' => ['common_validate.require', ['event_id']],
            'item_id.require' => ['common_validate.require', ['item_id']],
            'athlete_id.require' => ['common_validate.require', ['athlete_id']],
            'team_id.require' => ['common_validate.require', ['team_id']],
            'registration_type.require' => ['common_validate.require', ['registration_type']],
            'registration_time.require' => ['common_validate.require', ['registration_time']],
            'status.require' => ['common_validate.require', ['status']],
            'payment_status.require' => ['common_validate.require', ['payment_status']],
            'sort.require' => ['common_validate.require', ['sort']]
        ];

       protected $scene = [
            "add" => ['event_id', 'item_id', 'athlete_id', 'team_id', 'registration_type', 'registration_time', 'status', 'payment_status', 'payment_time', 'sort', 'remark'],
            "edit" => ['event_id', 'item_id', 'athlete_id', 'team_id', 'registration_type', 'registration_time', 'status', 'payment_status', 'payment_time', 'sort', 'remark']
        ];

}
