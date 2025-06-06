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

namespace addon\sport\app\validate\sport_athlete;
use core\base\BaseValidate;
/**
 * 参赛人员验证器
 * Class SportAthlete
 * @package addon\sport\app\validate\sport_athlete
 */
class SportAthlete extends BaseValidate
{

       protected $rule = [
            'event_id' => 'require',
            'team_id' => 'require',
            'name' => 'require',
            'gender' => 'require',
            'id_card' => 'require',
            'phone' => 'require',
            'birth_date' => 'require',
            'registration_type' => 'require',
            'registration_time' => 'require',
            'sort' => 'require',
            'status' => 'require'
        ];

       protected $message = [
            'event_id.require' => ['common_validate.require', ['event_id']],
            'team_id.require' => ['common_validate.require', ['team_id']],
            'name.require' => ['common_validate.require', ['name']],
            'gender.require' => ['common_validate.require', ['gender']],
            'id_card.require' => ['common_validate.require', ['id_card']],
            'phone.require' => ['common_validate.require', ['phone']],
            'birth_date.require' => ['common_validate.require', ['birth_date']],
            'registration_type.require' => ['common_validate.require', ['registration_type']],
            'registration_time.require' => ['common_validate.require', ['registration_time']],
            'sort.require' => ['common_validate.require', ['sort']],
            'status.require' => ['common_validate.require', ['status']]
        ];

       protected $scene = [
            "add" => ['member_id', 'event_id', 'team_id', 'name', 'gender', 'id_card', 'phone', 'birth_date', 'photo', 'registration_type', 'registration_time', 'sort', 'status', 'remark'],
            "edit" => ['member_id', 'event_id', 'team_id', 'name', 'gender', 'id_card', 'phone', 'birth_date', 'photo', 'registration_type', 'registration_time', 'sort', 'status', 'remark']
        ];

}
