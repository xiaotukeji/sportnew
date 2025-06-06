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

namespace addon\sport\app\validate\sport_base_item;
use core\base\BaseValidate;
/**
 * 基础项目验证器
 * Class SportBaseItem
 * @package addon\sport\app\validate\sport_base_item
 */
class SportBaseItem extends BaseValidate
{

       protected $rule = [
            'category_id' => 'require',
            'name' => 'require',
            'code' => 'require',
            'competition_type' => 'require',
            'gender_type' => 'require',
            'sort' => 'require',
            'status' => 'require'
        ];

       protected $message = [
            'category_id.require' => ['common_validate.require', ['category_id']],
            'name.require' => ['common_validate.require', ['name']],
            'code.require' => ['common_validate.require', ['code']],
            'competition_type.require' => ['common_validate.require', ['competition_type']],
            'gender_type.require' => ['common_validate.require', ['gender_type']],
            'sort.require' => ['common_validate.require', ['sort']],
            'status.require' => ['common_validate.require', ['status']]
        ];

       protected $scene = [
            "add" => ['category_id', 'name', 'code', 'competition_type', 'gender_type', 'age_group', 'description', 'rules', 'equipment', 'venue_requirements', 'referee_requirements', 'sort', 'status', 'remark'],
            "edit" => ['category_id', 'name', 'code', 'competition_type', 'gender_type', 'age_group', 'description', 'rules', 'equipment', 'venue_requirements', 'referee_requirements', 'sort', 'status', 'remark']
        ];

}
