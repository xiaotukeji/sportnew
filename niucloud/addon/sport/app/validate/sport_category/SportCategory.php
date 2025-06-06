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

namespace addon\sport\app\validate\sport_category;
use core\base\BaseValidate;
/**
 * 项目大类验证器
 * Class SportCategory
 * @package addon\sport\app\validate\sport_category
 */
class SportCategory extends BaseValidate
{

       protected $rule = [
            'name' => 'require',
            'code' => 'require',
            'level' => 'require',
            'sort' => 'require',
            'status' => 'require'
        ];

       protected $message = [
            'name.require' => ['common_validate.require', ['name']],
            'code.require' => ['common_validate.require', ['code']],
            'level.require' => ['common_validate.require', ['level']],
            'sort.require' => ['common_validate.require', ['sort']],
            'status.require' => ['common_validate.require', ['status']]
        ];

       protected $scene = [
            "add" => ['name', 'code', 'icon', 'description', 'parent_id', 'level', 'path', 'sort', 'status', 'remark'],
            "edit" => ['name', 'code', 'icon', 'description', 'parent_id', 'level', 'path', 'sort', 'status', 'remark']
        ];

}
