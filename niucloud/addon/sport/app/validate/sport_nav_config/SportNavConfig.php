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

namespace addon\sport\app\validate\sport_nav_config;
use core\base\BaseValidate;
/**
 * 导航配置验证器
 * Class SportNavConfig
 * @package addon\sport\app\validate\sport_nav_config
 */
class SportNavConfig extends BaseValidate
{

       protected $rule = [
            'name' => 'require',
            'icon' => 'require',
            'selected_icon' => 'require',
            'path' => 'require',
            'sort' => 'require',
            'status' => 'require'
        ];

       protected $message = [
            'name.require' => ['common_validate.require', ['name']],
            'icon.require' => ['common_validate.require', ['icon']],
            'selected_icon.require' => ['common_validate.require', ['selected_icon']],
            'path.require' => ['common_validate.require', ['path']],
            'sort.require' => ['common_validate.require', ['sort']],
            'status.require' => ['common_validate.require', ['status']]
        ];

       protected $scene = [
            "add" => ['name', 'icon', 'selected_icon', 'path', 'sort', 'status', 'remark'],
            "edit" => ['name', 'icon', 'selected_icon', 'path', 'sort', 'status', 'remark']
        ];

}
