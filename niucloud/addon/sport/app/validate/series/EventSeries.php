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

namespace addon\sport\app\validate\series;
use core\base\BaseValidate;

/**
 * 系列赛验证器（前端API专用）
 * Class EventSeries
 * @package addon\sport\app\validate\series
 */
class EventSeries extends BaseValidate
{
    protected $rule = [
        'name' => 'require',
        'start_year' => 'require'
    ];

    protected $message = [
        'name.require' => '系列赛名称不能为空',
        'start_year.require' => '开始年份不能为空'
    ];

    protected $scene = [
        "add" => ['name', 'start_year', 'end_year', 'description', 'remark'],
        "edit" => ['name', 'start_year', 'end_year', 'description', 'remark']
    ];
} 