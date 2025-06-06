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

namespace addon\sport\app\validate\sport_item;
use core\base\BaseValidate;
/**
 * 比赛项目验证器
 * Class SportItem
 * @package addon\sport\app\validate\sport_item
 */
class SportItem extends BaseValidate
{

       protected $rule = [
            'event_id' => 'require',
            'base_item_id' => 'require',
            'category_id' => 'require',
            'name' => 'require',
            'competition_type' => 'require',
            'gender_type' => 'require',
            'sort' => 'require',
            'status' => 'require'
        ];

       protected $message = [
            'event_id.require' => ['common_validate.require', ['event_id']],
            'base_item_id.require' => ['common_validate.require', ['base_item_id']],
            'category_id.require' => ['common_validate.require', ['category_id']],
            'name.require' => ['common_validate.require', ['name']],
            'competition_type.require' => ['common_validate.require', ['competition_type']],
            'gender_type.require' => ['common_validate.require', ['gender_type']],
            'sort.require' => ['common_validate.require', ['sort']],
            'status.require' => ['common_validate.require', ['status']]
        ];

       protected $scene = [
            "add" => ['event_id', 'base_item_id', 'category_id', 'name', 'competition_type', 'gender_type', 'age_group', 'max_participants', 'min_participants', 'registration_fee', 'rules', 'equipment', 'venue_requirements', 'referee_requirements', 'sort', 'status', 'remark'],
            "edit" => ['event_id', 'base_item_id', 'category_id', 'name', 'competition_type', 'gender_type', 'age_group', 'max_participants', 'min_participants', 'registration_fee', 'rules', 'equipment', 'venue_requirements', 'referee_requirements', 'sort', 'status', 'remark']
        ];

}
